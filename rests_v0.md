# Rests v0 — heal or upgrade

_Authored 2026-05-19 by Controller. Phase 2.12 M9 deliverable (part 2 of 2 — companion file `shrines_v0.md` covers SHRINE nodes). Implements the REST NodeKind added in B2.9 — pure design content, engine wiring is M9.E1._

## What a REST is

A REST node on the chapter map is a binary choice: heal or upgrade. Unlike SHRINE, both outcomes are positive — there is no "Defile" downside. Rests are the safe map node; shrines are the risky map node.

## Rest roster — 2 variants

### R1. The Mourning Hearth (standard rest)

> A campfire burns low under a cinder-stained awning. You have a moment to choose.

**Heal:**
- Restore 30 current HP (clamped at max HP)

**Upgrade:**
- Pick one card from your deck → permanently +1 to its primary stat (UNIT = +1 ATK; SPELL/TRAP = effect magnitude +1, e.g. Bleed-1 → Bleed-2, +1 damage, +1 charge; RELIC = +1 to whatever the relic ticks)
- Upgrade is permanent for this run, persists across combats

**Why both feel like trades:** Heal is the safe, predictable HP top-up. Upgrade is the "I'm flush on HP, time to scale my key card" play. Player picks based on board state at rest time.

### R2. The Standing Stone (rare rest — Skinward Pact flavour)

> An antler-crowned monolith stands at the edge of the cinderwood. Mosses cover its base. Something in your deck recognises it.

**Heal:**
- Restore 50 current HP (clamped at max HP)
- Cannot upgrade

**Upgrade:**
- Pick TWO cards from your deck → both get +1 to primary stat
- Cannot heal

**Why both feel like trades:** Bigger numbers, same trade-off shape. Spawns at 25% the rate of R1 — when it appears, it's a meaningful inflection point.

## Distribution rules

- Each chapter map generates between 0 and 2 REST nodes (Chapter 1 prototype = 0 currently; future chapters add 1-2)
- R1 spawns 4× more often than R2 (R2 is the "rare rest")
- A REST node never neighbours another REST node directly (graph-generator constraint)

## Upgrade rules — engine-side

**What counts as the "primary stat" for upgrade:**
- UNIT card: `attack` (or `hp` if attack == 0 — relics/standards-style cards)
- SPELL card: the highest-magnitude numeric in the card's effect (Bleed-X → X+1, "deal X damage" → X+1, "heal X" → X+1)
- TRAP card: the highest-magnitude numeric, OR charge count if the trap is charge-counted
- RELIC card: the primary tick value (e.g. "every turn, gain X mana" → X+1)

**Upgrade is per-instance, not per-card:**
- Upgrading a copy of M5 Last Censer-Bearer in your deck only upgrades that one copy. Other copies stay base.
- Engine reads `CardInstance.upgrade_count: int` (default 0). UI shows `★` overlay per upgrade level.
- Visual: upgraded cards get a brass +1 sigil in the bottom-right corner of the card art frame.

**Stacking:**
- A card can be upgraded multiple times across multiple rests. No cap; in practice runs are short enough that 2-3 upgrades is the realistic ceiling.
- Stat increases stack linearly (+1 each upgrade).

## Anti-P2W invariant

Rest outcomes read run-level state only. The upgrade system is per-instance and runs through `CardInstance` not `Card` (so the gameplay Resource is never mutated). Treatment_id is NEVER read during a rest — cosmetic frame state is orthogonal. Engine MUST NOT couple upgrade availability to monetisation state.

## Engine wiring sketch — M9.E1

`game/data/rests/` — new folder. One `.tres` per rest using a `Rest` Resource:

```
class_name Rest extends Resource

@export var id: StringName               # "r1_mourning_hearth", "r2_standing_stone"
@export var display_name: String
@export var flavour_text: String
@export var heal_amount: int             # 30 for R1, 50 for R2
@export var upgrade_picks: int           # 1 for R1, 2 for R2
@export var can_heal: bool = true        # R2 = true, but exclusive with upgrade
@export var can_upgrade: bool = true     # R2 = true, but exclusive with heal
```

Rest resolution lifecycle from `GameState`:
- `rest_offered(rest)` signal
- `resolve_rest_heal(rest)` or `resolve_rest_upgrade(rest, card_instances: Array[CardInstance])` — caller passes pre-validated picks
- `rest_resolved(rest, choice)` signal after effects apply

`CardInstance.upgrade_count` field added; `CardInstance.get_effective_stats()` returns base stats + upgrade_count × per-stat-delta.

## Open questions for Paul

1. **Upgrade on Persist-tagged units.** A Persist unit returns at base ATK -1. If upgraded to ATK +1, does Persist still drop by 1 from the upgraded value (net 0) or from the base (net +1)? Recommend: from base. Upgrade is a permanent buff; Persist's debuff is a per-instance per-combat one-shot. They don't fight each other.
2. **Upgrade on tokens.** Tokens (Bog-Spawn, Cub, Banner) are summoned cards, never in the player's deck. Rest upgrade can't target them. Recommend: confirm by `card.is_token == true` filter in the picker UI.
3. **Visual feedback budget.** The brass +1 sigil overlay is a small art ask — single SVG, faction-neutral. Can be authored against `pipeline_setup/fetch_icons.py` patterns. Recommend: produce as part of B3.2 frame-pass, not as a blocker.

## What this spec ships

- 2 rest designs, 2 outcomes each
- Upgrade rules with engine-side mechanics
- Distribution rules for chapter generation
- Engine handoff sketch for M9.E1
- Anti-P2W invariant restated

— Controller, 2026-05-19
