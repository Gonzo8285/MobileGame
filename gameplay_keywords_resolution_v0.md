# Gameplay keyword resolution v0 — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory item GP-1. Per-keyword resolver spec for the 8 keywords currently in the `GFEnums.Keyword` enum but unresolved in `turn_engine.gd` (per backlog B2.7 note "CLEAVE/PIERCE/FEAR/ROOT/SLOW/SMOKE/DREAD/SHIELD deferred — keyword plumbing exists but resolution lives in B2.7+ balance pass"). Includes ordering, stacking, and edge cases. Adds anti-soft-lock rules per inventory GP-5._

**Status:** v0 spec. Pure design doc — no `.gd` / `.tres` edits.

---

## 0. Existing resolved keywords (recap, do not change)

| Keyword | Resolver | Spec |
|---|---|---|
| BLEED | `turn_engine.gd` DoT tick — -1 per turn, decay-1 | (per `cards_v0.md` + B2.7 close note) |
| POISON | `turn_engine.gd` DoT tick — sticky -1 per turn | (per B2.7 close note) |
| PERSIST | end-of-turn return, -1 ATK floor 0, once per combat, non-token | `keywords/persist_v0.md` |
| TAUNT | targeting filter on enemy MELEE in-range | `keywords/taunt_v0.md` (E1 wiring pending) |
| SACRIFICE | (per card-text — manual outlet, no auto-resolver) | `cards_*_v1.md` flavour |
| RESURRECT | unit revives once at 1 HP on death | (per Mhar W5 Cinder-Wolf) |
| HANGING_HOUR (compound effect) | turn 5 standard / turn 4 boss | `keywords/hanging_hour_persist_v0.md` |

These 7 keywords are LOCKED. This doc adds resolvers for the remaining 8.

---

## 1. CLEAVE

### 1.1 Spec

> When this unit attacks, it deals its ATK to all enemies on its tile + the two adjacent tiles in the same lane row.

### 1.2 Resolver pseudocode

```
func resolve_attack_cleave(attacker: UnitInstance, lane: Lane, target_tile: int) -> Array[DamageEvent]:
    var events: Array[DamageEvent] = []
    var center_dmg = DamageEvent.new(attacker, lane.tile_at(target_tile), attacker.current_attack())
    events.append(center_dmg)
    
    # Left tile (if exists and has enemy)
    if target_tile > 0:
        var left_enemy = lane.enemy_at(target_tile - 1)
        if left_enemy != null:
            events.append(DamageEvent.new(attacker, left_enemy, attacker.current_attack()))
    
    # Right tile (if exists and has enemy)
    if target_tile < lane.tile_count - 1:
        var right_enemy = lane.enemy_at(target_tile + 1)
        if right_enemy != null:
            events.append(DamageEvent.new(attacker, right_enemy, attacker.current_attack()))
    
    return events
```

### 1.3 Stacking rule

CLEAVE doesn't stack with itself (one CLEAVE = one cleave). Multiple CLEAVE keywords on one unit are a no-op duplicate.

### 1.4 Interactions

- **CLEAVE + PIERCE:** PIERCE ignores SHIELD; CLEAVE hits 3 enemies. Combined: 3 enemies each take damage that bypasses SHIELD. Stacks.
- **CLEAVE + TAUNT:** per `keywords/taunt_v0.md` line, CLEAVE ignores TAUNT — distributing damage across multiple targets defeats the redirect-to-one-target rule. **Locked: CLEAVE bypasses TAUNT.**
- **CLEAVE + SLOW/ROOT:** these are status applied per-hit. CLEAVE attack applies status to all 3 hit targets.
- **CLEAVE + BLEED/POISON on-hit:** same — applied to all 3 hit targets.
- **Friendly-fire:** CLEAVE only damages enemies. Friendly units in adjacent tiles are unaffected.

### 1.5 Edge cases

- **Cleave with range LONG (3 tiles):** ATK projectile hits target tile, then cleaves to adjacent tiles **at the target tile depth**, not at attacker's tile. E.g. attacker at tile 0 with LONG range cleaves enemies at tiles 2/3/4 (target = tile 3, adjacent = 2 and 4).
- **Cleave with target == empty tile:** if direct target is empty (e.g. boss positioned at tile X, but X has no enemy), CLEAVE still rolls to adjacent tiles. Damage to non-existent enemies = no-op.

---

## 2. PIERCE

### 2.1 Spec

> When this unit attacks, ignore the target's SHIELD charges (consume 0 charges) and the target's armor.

### 2.2 Resolver pseudocode

```
func resolve_attack_pierce(attacker: UnitInstance, target: EnemyInstance) -> int:
    # Skip SHIELD check
    var damage = attacker.current_attack()
    # Skip armor reduction
    target.hp -= damage
    target.emit_signal("hp_changed", target.hp)
    return damage
```

### 2.3 Stacking rule

PIERCE doesn't stack — present or absent.

### 2.4 Interactions

- **PIERCE + SHIELD on attacker:** unrelated. SHIELD on attacker only matters when attacker is being hit. PIERCE is an attacker-side ability.
- **PIERCE + CLEAVE:** see §1.4.
- **PIERCE bypasses TAUNT?** No. TAUNT is a targeting filter; PIERCE is a damage modifier. Separate phases. PIERCE attack still redirects to TAUNT target, just bypasses TAUNT-target's SHIELD/armor.

### 2.5 Edge case

- **PIERCE + boss-only damage cap (e.g. boss takes max 5 damage per turn from minions per a future relic):** PIERCE bypasses *target's* defences, not global rules. Cap holds.

---

## 3. FEAR (apply-on-hit, target-side debuff)

### 3.1 Spec

> When this unit attacks, apply FEAR-X for Y turns. A FEAR-ed unit's attack damage is reduced by X (floor 0) for Y turns.

### 3.2 Resolver pseudocode

```
func resolve_apply_fear(target: EnemyInstance, intensity: int, duration: int) -> void:
    var existing = target.get_status(GFEnums.Status.FEAR)
    if existing == null:
        target.statuses[GFEnums.Status.FEAR] = StatusEntry.new(intensity, duration)
    else:
        # Stack: take higher intensity, sum durations capped at 5
        existing.intensity = max(existing.intensity, intensity)
        existing.duration = min(existing.duration + duration, 5)
```

### 3.3 Stacking rule

- Higher intensity wins (FEAR-2 replaces FEAR-1, not additive).
- Durations sum, capped at 5 turns (anti-soft-lock).

### 3.4 Resolution at attack-time

```
func get_modified_attack(unit: EnemyInstance) -> int:
    var base = unit.current_attack()
    var fear_status = unit.get_status(GFEnums.Status.FEAR)
    if fear_status != null:
        base -= fear_status.intensity
    return max(0, base)
```

### 3.5 Tick

At end-of-turn, decrement FEAR duration by 1. If duration reaches 0, remove status.

### 3.6 Interactions

- **FEAR + friendly units:** by default, FEAR can apply to friendly units too (`SMOKE` puddles in lanes affect everything in them per Saint of Gallowsmoke). For typical card-based FEAR, on-attack-hit applies only to enemies. Spell-applied FEAR (e.g. AoE spells) can hit friendlies if spell flavour says so.
- **FEAR + SMOKE:** SMOKE tile + FEAR — these stack independently. SMOKE-bound enemy can also be FEAR-ed by a separate attack.
- **FEAR + Hanging Hour:** at HH, all units +1 ATK (per `lore_gallowfell.md`). FEAR reduces post-HH ATK (so net = base + 1 - fear_intensity, floor 0).

### 3.7 Edge case

- **FEAR-1 on a 1-ATK unit:** unit has 0 effective ATK; still attacks (visual + sound), just deals 0 damage. Doesn't skip turn.
- **FEAR on Persisted unit:** Persist returns at base ATK -1. If FEAR-2 also active, total = base - 1 - 2 (floor 0).

---

## 4. ROOT

### 4.1 Spec

> A ROOTed unit cannot move (lane advance is blocked) for X turns. Does not prevent attacking from its current tile.

### 4.2 Resolver pseudocode

Modify `lane.advance_all()`:
```
func advance_all(damage_callback: Callable) -> void:
    for enemy in enemies:
        if enemy.has_status(GFEnums.Status.ROOT):
            continue  # ROOTed enemies don't advance this turn
        # ... normal advance logic
```

### 4.3 Stacking rule

- Higher intensity wins (ROOT-3 replaces ROOT-1, not additive).
- Duration sums, capped at 4 turns (boss + per-encounter feel).

### 4.4 Interactions

- **ROOT + LONG-range enemy attack:** enemy can still attack from current tile (LONG-range hits player base from anywhere on lane). ROOT only blocks movement.
- **ROOT + SLOW:** SLOW slows advance speed; ROOT halts entirely. ROOT supersedes SLOW for movement.
- **ROOT + Sieren's Funeral Writ:** per W2 sig spell, Funeral Writ ROOTs lane + DoT 1/turn rooted. The DoT is a separate effect; the ROOT itself follows §4.

### 4.5 Edge case

- **ROOT on enemy already at front tile:** they stay there. Can still attack player base if MELEE range.

---

## 5. SLOW

### 5.1 Spec

> A SLOWed enemy advances 1 tile every 2 turns instead of every turn (effective speed halved). Duration in turns; expires after.

### 5.2 Resolver pseudocode

Modify `EnemyInstance`:
```
var slow_counter: int = 0  # increments per turn while SLOW active

func should_advance_this_turn() -> bool:
    if not has_status(GFEnums.Status.SLOW):
        return true
    slow_counter += 1
    if slow_counter >= 2:
        slow_counter = 0
        return true
    return false
```

### 5.3 Stacking rule

- Multiple SLOW from different sources → take max intensity (SLOW-2 advances 1 tile per 3 turns; SLOW-3 = 1 per 4 turns).
- Duration sums, capped at 5 turns.

### 5.4 Interactions

- **SLOW + ROOT:** ROOT supersedes (no movement at all).
- **SLOW + FREEZE (boss control):** FREEZE (e.g. Caspar Voll Slow-3 vs boss for 2 turns) is essentially SLOW-3 + duration cap. Mechanically same effect — FREEZE is a Slow-3-flavoured variant.

### 5.5 Edge case

- **SLOW + Hanging Hour:** doesn't affect ATK bonus. SLOW is a movement-only debuff.

---

## 6. SMOKE

### 6.1 Spec

> A SMOKE-tile is a lane-effect that lasts X turns. Enemies inside the SMOKE tile have a 50% miss-chance on attacks. The SMOKE-tile is removed after X turns or if cleared by a specific effect.

### 6.2 Resolver pseudocode

```
class_name SmokeTile extends LaneEffect

var lane_idx: int
var tile_idx: int
var duration: int
var miss_chance: float = 0.50

func on_enemy_attack(attacker: EnemyInstance, target: Object) -> bool:
    if enemy_in_smoke_tile(attacker):
        if randf() < miss_chance:
            return false  # miss
    return true  # hit

func on_turn_end() -> void:
    duration -= 1
    if duration <= 0:
        emit_signal("smoke_cleared", self)
```

### 6.3 Stacking rule

- Multiple SMOKE on same tile: durations sum, capped at 6 turns. Miss-chance does NOT compound (no 75% miss; max stays 50%).

### 6.4 Interactions

- **SMOKE + Saint of Gallowsmoke (W8):** her passive extends SMOKE duration +1 turn AND adds 1 DoT/turn to enemies inside. DoT applies even if attack-miss.
- **SMOKE + FEAR:** independent statuses. SMOKE affects accuracy; FEAR affects ATK.
- **SMOKE on friendly tile:** by default SMOKE applies miss-chance to whoever attacks **from** the SMOKE tile. Player units in SMOKE also have 50% miss-chance. Spec-locked: SMOKE is symmetric (Saint of Gallowsmoke synergy needs enemy-only? — no, symmetry is what the player learns to use the boundary tiles for).
- **SMOKE + RANGE LONG:** Long-range attacker shoots OVER tiles. If the *attacker* is in a SMOKE tile, miss-chance applies regardless of target tile.

### 6.5 Edge case

- **SMOKE + PIERCE:** PIERCE ignores SHIELD/armor. SMOKE is an accuracy effect. PIERCE attack still has 50% miss-chance.
- **SMOKE + CLEAVE:** if attacker is in SMOKE, miss roll fires once for the whole cleave; pass = all 3 hit, fail = all 3 miss.

---

## 7. DREAD

### 7.1 Spec

> A DREAD-ed unit's first attack each combat targets itself instead of an enemy. (Used by Iron Penitents-flavour cards for self-sacrifice payoffs.)

### 7.2 Resolver pseudocode

```
func resolve_attack_with_dread_check(attacker: UnitInstance) -> AttackTarget:
    var dread_status = attacker.get_status(GFEnums.Status.DREAD)
    if dread_status != null and not attacker.has_consumed_dread:
        attacker.has_consumed_dread = true
        return AttackTarget.SELF  # caller deals damage to attacker itself
    return AttackTarget.NORMAL  # caller uses standard targeting
```

### 7.3 Stacking rule

DREAD doesn't stack — present or absent. Once consumed (first attack), stays consumed for the rest of the combat.

### 7.4 Interactions

- **DREAD + CLEAVE:** DREAD first-attack targets self only; CLEAVE doesn't fire on the self-hit. After consume, subsequent attacks fire normal CLEAVE.
- **DREAD + Bone-Pageant (Vyrrun T3 alt-fire):** Vyrrun T3 deals damage to weakest unit then Persists at HH. DREAD chained: first attack of the Persisted-back-with-+2-ATK unit fires self-damage first. Funky combo, but consistent.

---

## 8. SHIELD

### 8.1 Spec

> SHIELD-X grants X "charges" that absorb full damage from one attack each. SHIELD persists between turns until consumed. SHIELD does not regenerate.

### 8.2 Resolver pseudocode

```
func resolve_damage_with_shield(target: Object, damage: int) -> int:
    var shield_charges = target.shield_charges
    if shield_charges > 0:
        target.shield_charges -= 1
        target.emit_signal("shield_consumed", target.shield_charges)
        return 0  # damage fully absorbed
    target.hp -= damage
    return damage  # damage applied
```

### 8.3 Stacking rule

- SHIELD stacks additively. SHIELD-1 + SHIELD-2 = 3 charges.
- No cap on shield charges (in practice ~6 is the achievable ceiling).

### 8.4 Interactions

- **SHIELD vs PIERCE:** PIERCE attack consumes 0 charges. Hits HP directly.
- **SHIELD vs CLEAVE:** each cleaved target's SHIELD is independent. CLEAVE consumes one charge per hit target.
- **SHIELD vs BLEED/POISON DoT:** DoT is not an attack — SHIELD does NOT block DoT damage. (Anti-soft-lock — full-shield infinite-stall prevented.)
- **SHIELD + Sergeant-Smith Vikar (L7):** Vikar grants +1 ATK and SHIELD-1 to all friendly Host units in same row. SHIELD-1 stacks — units already with SHIELD get +1.

### 8.5 Edge case

- **SHIELD on enemy boss:** absorbs CLEAVE / spell damage equally. Bosses without specific anti-SHIELD must trade through charge-by-charge.

---

## 9. Ordering rule — when multiple keywords resolve

In a single attack action, keywords resolve in this order:

```
1. Target selection (TAUNT redirect applies here)
2. PIERCE check (decides whether to skip SHIELD/armor)
3. SHIELD consume (unless PIERCE)
4. Armor reduction (unless PIERCE)
5. Damage application
6. On-hit status application (BLEED, POISON, FEAR, SLOW, ROOT, etc.)
7. Death-trigger keyword resolution (PERSIST, RESURRECT, sacrifice-payoff)
8. Cleave fan-out (if CLEAVE — repeats 1-7 per additional target)
9. Phase tick (BLEED -1 decay, POISON sticky, FEAR/ROOT/SLOW duration tick)
```

End-of-turn order (player + enemy):

```
1. Start-of-turn: cooldown tick, duration decay for statuses with `decay_on_turn_start` = true (currently FEAR / SLOW)
2. Draw (turn > 1)
3. Player plays cards (CardPlay.play_card per B2.6)
4. End-of-turn: DoT tick (BLEED decay-1, POISON sticky)
5. Friendly attacks (per `turn_engine.gd` B2.7)
6. Cull dead enemies
7. Enemy advance (per `lane.advance_all` modulo ROOT/SLOW)
8. Enemy stand-attacks (same-tile collision)
9. Cull dead friendlies
10. Drain Persist queue
11. Hanging Hour check (if turn matches: trigger HH effects)
12. Drain SMOKE / SHIELD / FEAR / ROOT / SLOW duration counters
13. End-of-turn cleanup (signal `turn_resolved`)
```

---

## 10. Anti-soft-lock rules (cross-ref GP-5)

The "curse closes in" rule, per inventory GP-5.

### 10.1 Curse damage at turn 12+

If combat reaches turn 12 without natural conclusion:
- Player base HP takes +1 damage per turn starting turn 12 (turn 12 = -1 HP, turn 13 = -2, ..., turn 17 = -7)
- This damage **ignores SHIELD** (it's atmospheric/lore damage, not an attack)
- A boss-on-the-board accelerates this: bosses add +1 damage to the curse-tick per active boss

### 10.2 Anti-infinite-Persist

The PERSIST keyword already has a once-per-combat guard. Combined with:
- **Hanging Hour bypass (per `keywords/hanging_hour_persist_v0.md`):** HH fires Persist once, then the lock holds. No infinite-Persist loop possible.
- **Cap on PERSIST corpses at 8** per combat — any beyond 8 are dropped from the queue and don't HH-revive.

### 10.3 Anti-mana-flood stall

At max 8 mana with 1-cost spam (per `2026-05-18_gallowfell_balance.md` mana cap), curse damage above kicks in. Player can't just spam 1-costs forever.

---

## 11. Engine handoff

### 11.1 Resolver module pattern

Add `game/src/runtime/keyword_resolver.gd` — pure-static module like `turn_engine.gd`:

```
class_name KeywordResolver extends Object

# Per-keyword resolver
static func resolve_cleave(...) -> Array[DamageEvent]
static func resolve_pierce(...) -> int
static func apply_fear(target, intensity, duration) -> void
static func tick_fear(target) -> void
static func apply_root(target, duration) -> void
static func tick_root(target) -> void
static func apply_slow(target, intensity, duration) -> void
static func tick_slow(target) -> void
static func apply_smoke(lane, tile, duration) -> SmokeTile
static func tick_smoke(smoke_tile) -> bool  # returns false if cleared
static func resolve_dread(attacker) -> AttackTarget
static func resolve_shield(target, damage) -> int  # returns damage actually dealt
static func resolve_attack_full_chain(attacker, target_tile, lane) -> AttackResult
```

### 11.2 New / extended enums

```
# enums.gd additions
enum Status { BLEED, POISON, FEAR, ROOT, SLOW, DREAD, SHIELD, CURSE }  # SHIELD as status? Discuss
enum AttackTarget { NORMAL, SELF }
```

Note: SHIELD is sometimes modeled as a counter on the EnemyInstance (`shield_charges: int`) and sometimes as a status. Recommend counter approach — simpler.

### 11.3 New combat-level types

```
class_name LaneEffect extends RefCounted
  var lane_idx: int
  var tile_idx: int
  var duration: int

class_name SmokeTile extends LaneEffect
  var miss_chance: float

class_name DamageEvent extends RefCounted
  var attacker: UnitInstance
  var target: Object
  var amount: int
```

### 11.4 Combat scene additions

```
# combat.gd extension
var smoke_tiles: Array[SmokeTile] = []  # per-combat lane effects

func add_smoke_tile(lane_idx, tile_idx, duration) -> SmokeTile
func tick_smoke_tiles() -> void  # called from end-of-turn
```

---

## 12. Test plan

Per the existing test pattern (`turn_engine_test.gd`), add `keyword_resolver_test.gd` with assertions:

| Test | Assertion |
|---|---|
| CLEAVE-3-targets | 3-tile cleave on a row of 3 enemies kills all 3 |
| CLEAVE-out-of-bounds | Cleave at tile 0 with no left tile doesn't error |
| PIERCE-vs-SHIELD-2 | PIERCE attack on SHIELD-2 enemy: 0 charges consumed, full HP damage |
| FEAR-stack-cap | FEAR-1 + FEAR-2 = FEAR-2 (not FEAR-3) |
| FEAR-tick-decay | FEAR-2 for 3 turns ticks to 0 turns over 3 turn-ends |
| ROOT-blocks-advance | ROOTed enemy does not advance lane |
| SLOW-2-turn-cycle | SLOW enemy advances on turn 2, 4, 6 |
| SMOKE-miss-rate | SMOKE 50% miss-rate verified over 100 attacks ±5% |
| SMOKE-friendly-symmetric | friendly unit in SMOKE also has 50% miss |
| DREAD-first-attack-self | DREAD-ed unit's first attack targets self; second attack normal |
| SHIELD-consume-per-hit | SHIELD-2 absorbs 2 attacks, 3rd hits HP |
| SHIELD-vs-DoT | DoT ignores SHIELD |
| ordering-attack-status | on-hit BLEED applies AFTER damage; cull check uses post-damage HP |
| anti-soft-lock-curse-tick | turn 12 reached → base HP -1 |

Wire into `RUN_DEV_TESTS=true` flow.

---

## 13. Open questions for Paul

1. **SMOKE friendly symmetry.** Spec'd as symmetric (friendly units inside SMOKE also have 50% miss). Alternative: enemy-only (Saint of Gallowsmoke purely buffs your side). Recommend symmetric — gives the boundary-tile tactic teeth. Confirm.
2. **PERSIST corpse cap of 8.** Recommend 8 to prevent extreme HH-revive-spam. Confirm.
3. **Curse-tick boss accelerator.** Curse +1 per boss feels right; 2 bosses = +2/turn extra. Confirm.
4. **DREAD on a tokenised unit.** Should tokens (Bog-Spawn etc.) be DREAD-able? Recommend no (tokens never have on-attack keywords). Confirm by `card.is_token == true` exclusion.

---

## 14. Cross-references

- `keywords/persist_v0.md`, `keywords/taunt_v0.md`, `keywords/hanging_hour_persist_v0.md` — locked specs for resolved keywords.
- `turn_engine.gd` — existing resolver for BLEED/POISON/PERSIST/friendly-attack.
- `cards_*_v1.md` — every card with one of these keywords becomes truly playable once this resolver lands.
- `2026-05-18_gallowfell_balance.md` — mana ramp, retry economy, base-HP damage.
- `bosses_v0.md` §"Anti-P2W invariant" — combat doesn't read account state.

— Controller, 2026-05-21
