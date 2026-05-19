# Shrines v0 — one-time blessings and curses

_Authored 2026-05-19 by Controller. Phase 2.12 M9 deliverable (part 1 of 2 — companion file `rests_v0.md` covers REST nodes). Implements the SHRINE NodeKind added in B2.9 — pure design content, engine wiring is M9.E1._

## What a SHRINE is

A SHRINE node on the chapter map is a one-time interaction:

1. Enter shrine → text describes the shrine
2. Player picks **Pray** or **Defile**
3. Mechanical payoff applies for the rest of the run (or until cleared by a specific event)
4. Node consumes — same shrine can't be visited twice within a chapter

Shrines are higher-variance than rests. The "good" outcome is usually slightly worse than a guaranteed rest heal/upgrade, but it carries a chance of a permanent run-level upside (relic, +max-HP, free cards). The "bad" outcome is meaningful — curses, HP loss, or deck pollution.

## Anti-P2W invariant

Shrine outcomes read run-level state only (current HP, current deck, current relics). They never read monetisation state, account-level state, or warlord-tier state. Engine MUST NOT branch shrine outcomes on `account.tier` or `account.battle_pass_active`.

## Shrine roster — 4 variants

### S1. The Gallows Shrine (Iron Penitents flavour)

> Cathedral Ruins / Gallows Hill biomes. A rope hangs from the iron rafters. The bell tolls once when you draw near.

**Pray:**
- Add a **Penance Token** card to your deck (0c Spell: deal 2 damage to a friendly unit, draw 1 card)
- +5 max HP for the rest of the run

**Defile:**
- Lose 10 current HP (cannot kill — clamps at 1 HP minimum)
- Gain relic **Crown of Thorns** (every turn, your first card costs 1 less mana)

**Why both feel like trades:** Pray gives a card that the engine LIKES (cheap sacrifice outlet for Persist + Penance chains) at a cost of opening a deck-pollution argument. Defile feels expensive at the moment but pays off across every combat for the rest of the run.

### S2. The Bog Shrine (Coven flavour)

> Black Mire biome. A pact-stone half-sunk in the swamp. Three demon-coins ring its base. A green pyre flickers in your peripheral vision.

**Pray:**
- Remove one card from your deck (player choice)
- Heal 8 HP

**Defile:**
- Add 3 random rare cards to your deck (faction-matched to your warlord)
- All Coven cards in your deck cost 1 more mana for the next 2 combats

**Why both feel like trades:** Pray is a deck-thinning play — Slay-the-Spire-grade utility for a player who knows their losing cards. Defile is a high-variance power injection with a real downside clock.

### S3. The Ash Shrine (Ash-Mourners flavour)

> Ash Quarter / Forgotten Parade biomes. A black bell hangs above a charred altar. The censer-smoke moves wrong.

**Pray:**
- Resurrect 1 card from your last defeated run (persists between runs — pulls from `GameState.last_run.discard` if any)
- Lose 3 max HP for the rest of this run

**Defile:**
- Skip the next combat entirely (auto-victory, no reward)
- Add **Cursed: Smoke-Bound** to your warlord (every turn, draw 1 fewer card; lasts until next REST node)

**Why both feel like trades:** Pray reaches across runs — pulls in a fan-favourite card from a prior loss, at a real HP cost. Defile is the "skip the boss-feeling combat" escape hatch, paid for with a draw-engine choke.

### S4. The Hollow Shrine (Last Legion + Skinward Pact crossover)

> Cinderwood / Forgotten Parade biomes. An antler-crowned standard planted in front of a foundry-rivet altar. Both factions left offerings here once, and both factions left curses too.

**Pray:**
- Reveal next 3 nodes on the map (you see what's coming, can plan)
- All combats for the rest of the run start with 1 extra mana on turn 1

**Defile:**
- Skip Hanging Hour for the next 2 boss combats (your Persist queue still drains normally, but the curse-amplification beat doesn't fire)
- Lose 1 relic of player's choice (cannot be the warlord's starting relic)

**Why both feel like trades:** Pray gives information + a flat power bump, no deck pollution. Defile is the anti-boss-difficulty escape but burns relic real-estate.

## Distribution rules

- Each chapter map generates between 1 and 3 SHRINE nodes (Chapter 1 prototype = 0 currently; future chapters add 1-3)
- Per chapter, the shrine variants spawned are sampled WITHOUT replacement (no two of the same shrine in one chapter)
- Faction-flavour shrines are weighted by warlord faction primary: warlord's primary faction shrine has 2× weight, other 4 shrines have 1× weight
- Hollow Shrine (S4) is always 1× weight (no warlord favours it)

## Engine wiring sketch — M9.E1

`game/data/shrines/` — new folder. One `.tres` per shrine using a `Shrine` Resource class:

```
class_name Shrine extends Resource

@export var id: StringName               # "s1_gallows", "s2_bog", etc
@export var display_name: String
@export var biome: StringName            # "cathedral_ruins", "black_mire", ...
@export var flavour_text: String         # the 2-line setup
@export var pray_effects: Array          # ShrineEffect resources
@export var defile_effects: Array        # ShrineEffect resources
@export var faction_flavour: GFEnums.Faction  # for distribution weighting
```

`ShrineEffect` is another small Resource with a `kind: GFEnums.ShrineEffectKind` enum and per-kind payload (card_id to add, hp_delta, relic_id to grant, etc). The 8 effect kinds needed:

1. `ADD_CARD` — add a specific card by id
2. `REMOVE_CARD` — remove a player-chosen card
3. `HEAL_HP` — restore current HP
4. `DAMAGE_HP` — lose current HP, clamp at 1
5. `MAX_HP_DELTA` — change max HP (+ or −)
6. `GRANT_RELIC` — add a specific relic
7. `REVOKE_RELIC` — remove a player-chosen relic
8. `APPLY_CURSE` / `APPLY_BLESSING` — add a temporary modifier

Shrine resolution lifecycle from `GameState`:
- `shrine_offered(shrine)` signal
- `resolve_shrine(shrine, choice: bool)` — `choice == true` is Pray, `false` is Defile
- `shrine_resolved(shrine, choice)` signal after effects apply

## Open questions for Paul

1. **S3 Pray pulls from last run.** Cross-run persistence is an IMV-2 concern per `internal_mvp_scope.md`. For IMV-1, should Pray-S3 fall back to "resurrect a random card from this run's discard"? Recommend yes — keeps the spec engine-testable now, escalates cleanly to cross-run once save persists.
2. **S4 Defile relic-revoke.** Should the player be allowed to refuse to give up a relic (cancel the Defile)? Recommend no — once Defile is picked, the cost lands. Otherwise it's free information.
3. **Defile + Hanging Hour interaction.** S4 Defile skipping Hanging Hour for 2 boss combats — what counts as a "boss combat"? Recommend: any combat where `wave.is_boss == true`. Elite combats don't trigger Hanging Hour either way per `keywords/hanging_hour_persist_v0.md`.

## What this spec ships

- 4 shrine designs, 2 outcomes each, faction-flavoured
- Distribution rules for chapter generation
- Engine handoff sketch for M9.E1
- Anti-P2W invariant restated

— Controller, 2026-05-19
