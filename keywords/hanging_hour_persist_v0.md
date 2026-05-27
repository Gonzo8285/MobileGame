# HANGING HOUR × PERSIST — interaction spec v0

_M4, Phase 2.9 mechanical mining. Authored 2026-05-10 heartbeat. Cross-references `keywords/persist_v0.md` (M1), `gdd_v0.md` ("Curse mechanics"), `lore_gallowfell.md` §"Curse mechanics → game systems", and `warlords_v1.md` (Vyrrun, Sieren, The Saint That Should Not Hang)._

## What the Hanging Hour already does (existing — recap, not new)

Per GDD v0 + lore_gallowfell.md: every combat has an in-fiction "midnight" beat. On the Hanging Hour turn, **all units on the field — yours and enemies' — gain +1 ATK for that turn only.** Drives mid-fight tension; reframes RNG as inevitability. Three Warlords have signature synergies (Vyrrun: doubles his self-damage and buff; Sieren: Hanged Memory raises units at full stats; W11 Saint: weaponises both curse systems).

## What M4 adds (the Persist override)

> **At the Hanging Hour, every PERSIST-tagged unit that has died this combat returns to its origin tile at FULL base stats — ignoring the -1 ATK clause and ignoring the once-per-combat lock. The standard +1 ATK midnight buff stacks on top.**

Design intent: the curse keeps the dead from staying dead — and at midnight the curse intensifies. The lighter "-1 ATK once" Persist is the everyday curse; the Hanging Hour is the curse's voice raised. Every Ash-Mourner that almost stayed dead suddenly stands back up at full strength. Boss fights become genuinely terrifying when the boss is PERSIST-tagged and the player can't rush the kill before midnight.

## Mechanics — locked

### Trigger
- **Default Hanging Hour turn = 5** in standard combat. Combat tracks `hanging_hour_turn: int` (configurable per encounter, defaults to 5 from a Combat tuning constant).
- **Chapter bosses:** override to **turn 4** (boss combats are shorter / harder; midnight comes sooner). Boss `Encounter` resource carries the override.
- **One trigger per combat.** `hanging_hour_fired: bool` flips true on resolution; cannot re-trigger.
- **Trigger phase:** at the start of the Hanging Hour turn's TURN-START phase, *after* duration decay and cooldown tick, *before* draw. Emit `hanging_hour_struck` signal for VFX (rope creak SFX + dimmed-screen pulse + corpse-light flicker).

### Resolution
- Build a `hanging_hour_persist_queue: Array[CardInstance]` from `Combat.corpses` (the running list of every unit that died this combat — see "Engine wiring" below).
- Filter: **PERSIST-tagged only**, **not currently alive on the board** (no double-spawn), **not a token** (same exclusion as standard Persist), **at most one entry per unique CardInstance ID** (dedupe latest-death-wins — covers a unit that died once normally, Persisted, then died a second time: only the latest corpse counts).
- For each queued instance:
  - Re-instantiate at origin tile (or nearest empty in same lane row; if no empty tile, Persist fails silently — same fallback as standard Persist).
  - HP = max, ATK = full base ATK (no -1 floor). The +1 Hanging Hour buff applies on top this turn only.
  - `has_persisted` is set to **true** after Hanging Hour Persist resolves. Hanging Hour grants **one** bonus Persist resolution; it does NOT permanently unlock re-Persist. Subsequent deaths that turn or after are normal-rule (no further Persist, body stays dead).
  - Cooldown resets to base.
  - Self-buffs / aura-stacks NOT restored (same as standard Persist; counter-balances the full-stat return).
- Drain runs in the TURN-START phase of the Hanging Hour turn — before the player gets to act, before draw. Players see the dead stand up, then play their turn against a freshly-stacked board.

### Symmetry — both sides
- Hanging Hour Persist applies to **friendly AND enemy** PERSIST-tagged units. Combined with persist_v0 Q2 ("Persist on bosses = yes"), this means a PERSIST-tagged chapter boss that the player nearly killed pre-midnight returns to full HP. **This is the design terror moment** — the boss line in the brief reads "Boss-escalation made even more terrifying."
- Standard enemies still cannot carry PERSIST (per persist_v0 Q2 default), so this is a boss-fight escalator, not a wave-grind escalator. Standard combats see only the player's PERSIST-tagged units stand back up — a player-favouring beat in normal play, a punishment beat against bosses.

## Interactions

- **Standard Persist this combat:** if a unit Persisted normally earlier in combat (-1 ATK, has_persisted=true) and then died a second time, the Hanging Hour treats the **latest** corpse entry as the trigger and brings the unit back at full base stats. Hanging Hour is a hard reset of the Persist clock for that one resolution.
- **Resurrect (M6 Pyre-Priest):** Resurrect still wins vs Persist on the same death (per persist_v0). For Hanging Hour resolution: a unit that was Resurrected and then died again is in `corpses` from its second death; Hanging Hour brings it back via Persist if it has the PERSIST keyword. Resurrect's transformation (e.g. into Ash Wraith) is a *different* CardInstance — the original card, if PERSIST-tagged, stays queue-eligible.
- **Sacrifice + Hanging Hour:** sacrificed PERSIST units return at full stats at midnight. **Intentional and powerful** — Coven sacrifice-combo decks running an Ash-Mourner Persist splash get a midnight payoff. Watch for runaway combo in playtest; v0 ships without a cap, retune if telemetry shows >70% win rates on Coven×Mourner sacrifice builds.
- **The Saint That Should Not Hang (W11) signature spell — _Speak the Name_:** "At the Hanging Hour, all units on the field stop for one turn." The freeze applies to **attacks and movement**, NOT to the Hanging Hour Persist drain. Persist still resolves at TURN-START before the freeze takes effect. (Otherwise W11's spell would brick the lore-payoff turn.) The freeze begins immediately after Persist drain. Lock this ordering — without it the W11 fantasy collapses.
- **Vyrrun's Hanging Hour synergy ("self-damage doubled, buff doubled"):** orthogonal to M4. Vyrrun's hook is the +ATK buff being doubled; M4 is about Persist resurrection. They stack — Vyrrun on a Persist-heavy deck means his doubled +2 buff lands on freshly-stood-up Persist bodies on his Hanging Hour turn. Felt power spike, intentional.
- **Sieren's Hanged Memory (Reanimation interaction):** Sieren's passive raises Reanimated enemies as friendlies at full stats. M4's Hanging Hour Persist triggers at TURN-START; Reanimation is a chance-roll on enemy death (not a Hanging Hour event). They share the "full stats" theme but resolve in separate phases. No conflict.
- **Mass-removal spells (Cinder Tide etc.) used pre-midnight:** every PERSIST-tagged unit wiped is queued in `corpses`. At the Hanging Hour, the lane re-stands at full stats. Mass-removal still has value (the turns between the wipe and midnight = pressure relief), but the wipe is no longer terminal vs PERSIST stacks. Feels right for the Ash-Mourners archetype.
- **Persist already fired this combat (has_persisted=true) on units still alive:** unaffected. The Hanging Hour only drains corpses; live units don't re-stand. Their lock stays true; if they die after midnight, no further Persist (Hanging Hour was their bonus chance, used).
- **Tokens:** still excluded. Same rule as standard Persist — Ash Wraiths, Bog-Spawn, Cub-Tokens, Banner-Tokens, Wolf-Tokens never queue. There's no source `Card` Resource to re-instantiate from.

## Anti-P2W invariant

The Hanging Hour Persist override is a **gameplay rule** triggered by the PERSIST keyword on the `Card` Resource. It is **never** a cosmetic/treatment effect, **never** an IAP, **never** a battle-pass tier reward. Whales cannot buy the override. Whales cannot buy more PERSIST tags. The CURSED treatment (animated green-pyre overlay) is *visual only* and **must not** branch combat code on `treatment_id == CURSED`. Restated here because the Cursed treatment shares the curse-flavour and the temptation to wire them together is real. Don't.

## Engine wiring (sketch — full impl deferred to B2.7+ balance pass)

Adds to `Combat.gd`:
- `hanging_hour_turn: int = 5` — exported, override-able by `Encounter.hanging_hour_turn` resource field for boss combats (default override = 4).
- `hanging_hour_fired: bool = false` — reset on `Combat.cleanup()`.
- `corpses: Array[CardInstance]` — running list of every dead unit this combat. Push on `unit_killed` signal. Cleared on `Combat.cleanup()`.
- New signal `hanging_hour_struck(turn_num: int, persisted_count: int)` — VFX + audio + HUD hook.
- New method `_run_hanging_hour(turn_num)` called from `_on_turn_started` when `turn_num == hanging_hour_turn and not hanging_hour_fired`. Builds queue, calls `TurnEngine.drain_hanging_hour_persists(queue, lanes)`, emits signal, sets `hanging_hour_fired=true`.

Adds to `TurnEngine.gd`:
- New static method `drain_hanging_hour_persists(queue: Array[CardInstance], lanes: Array[Lane]) -> Dictionary` — same shape as `drain_persists` but: ATK = base (no -1 floor), bypasses `has_persisted` check on entry, **sets** `has_persisted=true` on exit (locks subsequent normal Persist).

Adds to `CardInstance` runtime:
- No new fields needed. Hanging Hour reuses `has_persisted` as a final lock; the override is a one-shot bypass at the trigger moment, not a cleared flag.

Adds to `Encounter` Resource (when boss encounters land in B2.9):
- `hanging_hour_turn_override: int = -1` — `-1` means "use Combat default". Boss `.tres` files set this to 4.

Test cases for `turn_engine_test.gd` (defer to B2.7+):
1. Two PERSIST units die turn 2 + turn 3, neither has Persisted before. At turn 5 TURN-START: both stand up at full base ATK + Hanging Hour +1, `has_persisted` becomes true on both. Drain returns count=2.
2. PERSIST unit Persists normally turn 2 (-1 ATK), dies again turn 4. At turn 5: returns at full base ATK (no -1), `has_persisted` stays true (already true). Cube unaffected by re-set.
3. Token unit (Ash Wraith) dies turn 3. At turn 5: NOT in queue (token exclusion).
4. PERSIST unit dies turn 6 (after Hanging Hour). Standard Persist applies on turn 6 end — `-1` ATK, once-per-combat. No second Hanging Hour.
5. Boss with PERSIST + `hanging_hour_turn_override=4`. Player kills boss turn 3. At turn 4 TURN-START: boss returns full HP/ATK. Player must kill it again. (Boss combat win condition needs to handle the "killed twice" case — flagged for B2.9 boss-encounter spec.)

## Open questions for Paul

1. **Default Hanging Hour turn = 5 in standard combat, 4 in boss combat.** Lock these or pull in to 4 / 3 for tension? Recommendation: ship at 5/4, retune in soft-launch.
2. **Should the Hanging Hour grant a separate "second-Persist" lock, OR fully reuse `has_persisted`?** Spec'd to reuse — keeps the data model clean. Alternative: a `hanging_hour_persist_used: bool` separate flag would let a future "Hanging Hour resets all Persist locks" relic exist without ambiguity. Recommendation: ship with the unified flag; add the second flag only if a relic explicitly needs it.
3. **Boss with PERSIST: do they Persist with their full enrage / phase-2 modifiers, or back to phase-1 baseline?** Spec'd to return at base stats (matches "self-buffs / aura-stacks lost"). Boss phase-2 is a separate trigger that can re-fire if HP drops below threshold again. Recommendation: confirm in B2.9 boss-encounter design that phase-state is tracked separately from `CardInstance` state so this works cleanly.
4. **VFX / SFX budget:** the Hanging Hour beat needs to feel *biblical*. Spec calls for screen-pulse + rope creak SFX + corpse-light flicker. B3.2 frame-pass owns this. Defer.

## Files written this run

- `keywords/hanging_hour_persist_v0.md` — this doc.

No engine changes (no enum additions, no `.tres` edits, no `.gd` modifications). Pure spec — engine wiring lives in B2.7+ balance pass and B2.9 boss-encounter spec, both of which can read this doc verbatim and implement against it.

## Diff vs persist_v0.md

- persist_v0 specs the everyday Persist (-1 ATK floor, once-per-combat lock, end-of-turn drain).
- This doc specs the **Hanging Hour override**: full-stats Persist, lock bypassed once, queued from `corpses` not from current-turn deaths, runs at TURN-START not TURN-END.
- The two specs together fully define Persist behaviour through internal-MVP. M5+ work (if any) handles balance retune from playtest data.
