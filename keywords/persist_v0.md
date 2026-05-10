# PERSIST — keyword spec v0

_M1, Phase 2.9 mechanical mining. Authored 2026-05-10 heartbeat. Mirrors the MTG keyword Paul's references centre on; reframed for Gallowfell + the lane-defence combat shape._

## One-line text

> **Persist.** When this unit dies, return it to the lane at the end of the same turn with -1 ATK (floor 0). Cannot Persist again this combat.

Design intent: every Ash-Mourner unit that "dies" should feel like it almost stayed dead, but the curse pulled it back one more time. Reinforces the Gallowfell through-line — _the curse keeps the dead from staying dead_.

## Mechanics — locked

- **Trigger:** unit's HP reaches 0.
- **Resolution timing:** death is processed normally (death-triggers fire, body leaves the lane, corpse-counted for any "on death" effects). The PersistTask queues onto the active turn. At **end-of-turn phase** (after enemy advance + status tick, before next-turn draw), each queued PersistTask resolves: the unit re-enters its origin tile with HP=max, ATK=max(0, atk-1), `has_persisted=true`.
- **Tile occupied?** Push the persisted unit to the nearest empty tile in the same lane row. If no empty tile exists, the Persist fails silently — the unit is gone.
- **Once per combat:** `CardInstance.has_persisted` flips true on first Persist resolution and is checked at next death; second death = normal death, no re-queue. Resets on `Combat.cleanup()`.
- **ATK floor:** 0. A unit with 1 ATK that Persists becomes a 0-ATK chump body. Intentional: this lets it eat one more attack as a meatshield. Re-evaluate after first internal-MVP playtest — if it feels too durable, hard-kill at ATK=0 instead.
- **Off cooldown reset:** persisted unit's attack CD resets to its base value on return. (Same as a fresh play.)

## Interactions

- **Resurrect** (existing keyword, M6 The Pyre-Priest): Resurrect _replaces_ the death — the body never enters the corpse pool, never queues a Persist. If both could fire on the same unit, Resurrect wins. Rationale: Resurrect's "as a 1/1 Ash Wraith with Fear" is more transformative; Persist's "same unit, -1 ATK" is the lighter touch. Same-unit double-dip would be too sticky.
- **Sacrifice** (existing keyword, Iron Penitents + Coven): a sacrificed unit has died → Persist applies. _This is intentional_. Sacrifice-and-return loops are core to Paul's MTG references. Coven's "sacrifice-combo" archetype gets a free synergy if a Persist-tagged Ash-Mourner is in the deck.
- **Bleed / Poison DoT-kills:** Persist still triggers (death is death, regardless of source).
- **Mass-removal spells (Cinder Tide etc.):** each Persist-tagged unit independently queues — board-wipe vs Persist-stacked Ash-Mourners means the wipe lands but half the lane re-stands at end-of-turn at -1 ATK. Costly to play around.
- **Hanging Hour (M4 future hook):** at the Hanging Hour, every unit that died this combat Persists back at **full stats**, ignoring the -1 ATK clause and ignoring the once-per-combat lock. Boss-escalation made even more terrifying. (M4 will spec the override flag formally.)
- **Token units (Ash Wraith, Bog-Spawn, etc.):** tokens cannot be Persist-tagged. Tokens are summon-on-demand, not "this card returns to the lane" — there's no source `Card` resource in the persisted-unit slot. Engine-side check: `if instance.is_token: return false` early in queue-Persist logic.
- **Self-buffs / equipped-spells / aura-stacks:** lost on death, NOT restored on Persist. The unit comes back stripped. (Counter-balances the -1 ATK floor and prevents stat-snowball.)

## Engine wiring (sketch — full impl deferred to B2.7+)

- `GFEnums.Keyword.PERSIST` — added this heartbeat.
- `CardInstance` (per-instance runtime; already authored T1) — gains `has_persisted: bool = false`. Reset on `Combat.cleanup()` along with all other per-combat flags.
- `Combat.gd` — at unit-death-resolution, after existing on-death effects fire, check `instance.card.keywords.has(PERSIST) and not instance.has_persisted and not instance.is_token` → enqueue PersistTask onto `pending_persists: Array[Dictionary]`.
- `Combat.gd` end-of-turn phase — drain `pending_persists`, re-instantiate units onto origin tile or nearest empty in row, mark `has_persisted=true`. Emit `unit_persisted(instance)` signal for VFX hook.
- `combat_test.gd` — add Persist case once B2.7 turn engine ships.

## Anti-P2W invariant

PERSIST is a gameplay keyword on the `Card` Resource. It is **never** a cosmetic/treatment. Whales cannot buy a Persist tag. (Same rule as every other keyword; restated here because Persist is one of the most powerful effects in the pool and the temptation to gate it behind IAP is real. Don't.)

## Open questions for Paul

1. **ATK floor=0 vs hard-kill at ATK=0?** Default 0 chump body. Recommendation: ship with floor 0, watch for "Ash-Mourner walls" feel-bad in playtest, retune if needed.
2. **Persist on enemy-side?** Should bosses be allowed to Persist? Recommendation: **no on standard enemies**, **yes on chapter bosses** as a balancing lever. M4's Hanging Hour already escalates this.
3. **Display:** show Persist on the card frame as a faded silhouette behind the cost? Or a small icon next to keyword text? Pure UI call — defer to B3.2 frame-author pass.
