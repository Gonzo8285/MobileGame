# M3 — Court-Necromant Sieren Tier-3 Alt-Fire: _Glean_ (v0)

_Authored 2026-05-10 14:18 UTC by heartbeat. Phase 2.9 M3 deliverable. Designs the graveyard-as-resource Warlord ability per Paul's "Deathrite Shaman energy" brief. Repurposes an existing Warlord's T3 alt-fire slot (Sieren) rather than adding a 12th Warlord — roster is locked at 11 per `warlords_v1.md`. Anti-P2W bound by `warlord_tiers_v0.md` §6._

## 1. Decision

- **Path chosen:** repurpose existing alt-fire slot, don't author new Warlord.
- **Warlord:** Court-Necromant Sieren (W2, Ash-Mourners, Control). Faction-canonical fit — graveyard recursion is the Ash-Mourners' design pillar.
- **Replaces:** the illustrative "Pall Writ" worked example in `warlord_tiers_v0.md` §3.3. Pall Writ was Smoke-flavour and is a much cleaner fit for **The Saint of Gallowsmoke (W8)** when W2 authors her T3 alt-fire — flagged for reassignment.

## 2. Glean — full spec

| Field | Value |
|---|---|
| Spell name | **Glean** |
| Slot | Sieren — Tier-3 Signature Alt-Fire (replaces Funeral Writ when slotted) |
| Mana cost | **3** (matches Funeral Writ — same-cost rule per W1 §3.3) |
| Additional cost | **Exhaust 2 cards from your discard pile** (zone cost, distinct from mana) |
| Cooldown band | **Once per wave** (matches Funeral Writ — same-band rule per W1 §3.3) |
| Targeting | Choose: 1 friendly tile + 1 UNIT card in your discard |
| Effect | Summon a copy of the chosen UNIT to the chosen tile. Summoned copy enters with **-1 ATK** (floor 0). |
| Restrictions | (a) Cannot target tokens (`is_token=true`). (b) Cannot target a unit that died via Persist this combat (`has_persisted=true`). (c) Cannot target relics or non-UNIT cards in discard. |
| Interaction with Persist | Glean'd copy does NOT inherit Persist's once-per-combat lock. If the Glean'd copy's base card has the PERSIST keyword, it can Persist normally on death. (Glean is a fresh summon, not a return-to-lane.) |
| Interaction with summon-on-play effects | Treat as standard summon — all `on_play` triggers fire. |
| Interaction with M2 sacrifice loop | Glean'd unit can be sacrificed normally (e.g. Last Vows, Black Mire Pact). Combos intentional. |

## 3. Anti-P2W audit

- ✅ Same mana cost as Funeral Writ (3). Same cooldown band (once/wave). Opposite-axis effect (lane-control DoT → resource conversion). Locked-pattern compliant.
- ✅ Not strictly better than Funeral Writ. Funeral Writ wins vs swarm-lane pressure. Glean wins vs attrition fights with discard depth. Different matchup coverage.
- ✅ -1 ATK floor 0 prevents free value loops (no Persist+Glean infinite recur via the `has_persisted` block).
- ✅ Not a flat power increase — gated entirely by **what you put in your discard**, which is a deckbuilding intent the player chose. Rewards Ash-Mourners archetype play, not raw stats.
- ✅ Tier 3 unlock = signature alt-fire, sidegrade only (per `warlord_tiers_v0.md` §3.3).

## 4. Snowball checks

- **Glean → Glean:** the Glean'd copy enters discard at -1 ATK, but Glean costs 2 discard cards. Re-Gleaning the same unit costs 2 fresh discards each time. Self-throttling.
- **Persist + Glean:** if Sieren Persist-tags an Ash-Mourners unit (M21 Bone-Shroud Acolyte etc.), the Persisted body has `has_persisted=true` and is **excluded** from Glean targeting. Bug-class avoided.
- **Mass-discard combos:** Sieren has limited mass-discard outlets. Most Ash-Mourners discard pressure is opt-in (sacrifice spells, milled draws). No 1-mana fill-the-discard combo identified in current cards_v1 pools.
- **Mid-combat lethal recovery:** Glean is lane-tile-targeted but not free placement — must be a friendly empty tile. Cannot be used as last-second emergency block of a unit already at base. Containment intentional.

## 5. Engine handoff (extends W1 §5)

`Card` resource encoding:
```gdscript
# resources/cards/sieren_glean.tres (or live as alt-fire payload, not draftable)
@export var card_id: StringName = &"sieren_t3_glean"
@export var card_type: GFEnums.CardType = GFEnums.CardType.SPELL
@export var faction: GFEnums.Faction = GFEnums.Faction.ASH_MOURNERS
@export var cost: int = 3
@export var keywords: Array[GFEnums.Keyword] = []  # no inline keywords
@export var rarity: GFEnums.Rarity = GFEnums.Rarity.LEGENDARY  # alt-fire payload
@export var is_draftable: bool = false  # alt-fire only, never in shop / reward / packs
@export var unlock_tag: StringName = &"warlord_t3_sieren"
```

`SpellResolver` (or M2-style standalone): new `Glean` resolver function that:
1. Reads `discard_pile` from `GameState.discard`.
2. Filters: `card.card_type == UNIT && !card.is_token && !persisted_this_combat.has(card_instance_id)`.
3. Surfaces filtered list to UI for player selection.
4. On selection: `unit_instance = UnitInstance.new(chosen_card); unit_instance.atk_offset -= 1; lane.place(target_tile, unit_instance);`
5. Removes 2 player-selected cards from discard (UI prompt).
6. Removes the chosen unit copy from discard (note: it's a *copy* — the discard entry is also consumed, otherwise the same unit infinitely re-Gleans).

(Cost = 3 mana + 2 discard cards + the targeted discard unit consumed = 3 cards out of discard total. Real opportunity cost.)

`UI` requires:
- A two-step picker (target tile, then discard browser). `B2.6` drag-and-drop loop already supports tile-targeted spell casts; discard-browser is new — flag for B2.10 follow-up if Sieren is included in MVP slice.

## 6. Open questions for Paul

1. **Discard cost — 2 cards or 1 card?** Currently 2. Tunable. Lower = more activations per combat, higher = scarcer. 2 feels right pre-playtest. Tag for soft-launch tuning.
2. **Glean'd copy consumes discard entry?** Currently yes (cost line item 5.6). Alternative: copy stays in discard for re-Glean. Currently designed to consume to prevent perpetual chain.
3. **Pall Writ reassignment to Saint of Gallowsmoke (W8) — confirm before W2.** W8's faction stack is Coven × Court, and her existing signature spell *Veil of Gallowsmoke* is already lane-Smoke-Fear. Pall Writ would be a duplicate. Suggest W8's T3 alt-fire instead becomes "Saint's Pyre" (Smoke tiles deal +1 damage/turn but burn out 1 turn faster — opposite-axis from Veil's persistence-buffing passive _Drift_). Flagged for W2.
4. **MVP slice (first internal build) ships Sieren — does T3 ship too?** `internal_mvp_scope.md` defers Tier 3 to IMV-2. Glean is therefore a v0 spec for IMV-2 build, not IMV-1. Authoring early is fine; engine wiring waits.
5. **Naming — "Glean"?** Plain English, agricultural/scavenger fantasy, channels harvest-the-dead. Alternatives: "Reckoning", "Recompense", "Harvest the Dead", "Cull the Mourners". Lock at W2 sign-off.

## 7. Diff vs `warlord_tiers_v0.md` worked example

| W1 §3.3 worked example | M3 v0 |
|---|---|
| Sieren default: Funeral Writ — root + DoT (lane-control). | _Unchanged._ |
| Sieren alt-fire: **Pall Writ** — Smoke + Fear-1, all 3 lanes, 1 turn. | **Glean** — graveyard-as-resource summon. Pall Writ flagged for reassignment to W8. |

Reason: Glean is faction-canonical for Sieren (Ash-Mourners = graveyard recursion). Pall Writ is faction-canonical for the Saint of Gallowsmoke (Smoke pillar). The W1 worked example was illustrative only — this M3 v0 is a thematic improvement, not a contradiction.
