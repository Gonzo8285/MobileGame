extends RefCounted
class_name Lane

## Lane (B2.5) — one of the three lanes on the combat board.
##
## Pure data + logic. No scene-tree presence. The Combat node owns three of
## these and renders them via placeholder visuals in `combat.tscn`. Holds
## the enemies currently advancing down this lane and the friendly units
## placed on it (B2.6 will populate units; B2.5 leaves the units array empty).
##
## Tile numbering convention (sticky for the whole project):
##   tile 0  = the player's base. Reaching tile 0 ⇒ damage the base, despawn.
##   tile 1..tile_count-1 = playable tiles, friendly units placed here.
##   spawn  = tile_count (one past the last playable tile). Enemies enter from
##            the spawn position and advance toward tile 0.
##
## Signals are intentionally narrow: any UI / Combat orchestrator listens to
## these instead of polling.

signal enemy_spawned(enemy: EnemyInstance)
signal enemy_reached_base(enemy: EnemyInstance, damage: int)
signal enemy_killed(enemy: EnemyInstance)
signal unit_placed(unit: UnitInstance)
signal unit_killed(unit: UnitInstance)
signal enemy_hit(enemy: EnemyInstance, damage: int)  ## flash hook (IMV-1)
signal unit_hit(unit: UnitInstance, damage: int)      ## flash hook (IMV-1)
signal enemy_blocked(enemy: EnemyInstance, blocker: UnitInstance)  ## advance-blocked

var lane_index: int = 0
var tile_count: int = 6                   ## number of playable tiles 1..tile_count-1, plus tile 0 = base
var enemies: Array[EnemyInstance] = []
var friendly_units: Array[UnitInstance] = []   ## set by CardPlay (B2.6) when UNIT cards resolve


func _init(idx: int = 0, tiles: int = 6) -> void:
	lane_index = idx
	tile_count = tiles


# ============================================================================
# Spawning
# ============================================================================

## Insert an EnemyInstance at the spawn position (tile = tile_count). The
## WaveSpawner is the only caller in normal flow; tests may call directly.
func spawn_enemy(data: Enemy) -> EnemyInstance:
	var ei := EnemyInstance.new(data, tile_count, lane_index)
	enemies.append(ei)
	enemy_spawned.emit(ei)
	return ei


# ============================================================================
# Per-turn advance
# ============================================================================

## Advance every living enemy by its `move_speed`, but BLOCK at any friendly
## tile in the enemy's path. Enemies do NOT pass through friendlies — they
## stop at the friendly's tile and stand-attack on the next phase (handled
## by TurnEngine.process_turn_end_post_advance).
##
## Any enemy that reaches tile 0 (no friendly blocking) emits
## `enemy_reached_base` and despawns.
##
## Returns the total base damage dealt this tick.
func advance_all() -> int:
	var total_damage: int = 0
	var to_despawn: Array[EnemyInstance] = []
	for e in enemies:
		if not e.is_alive():
			to_despawn.append(e)
			continue
		var speed: int = e.enemy_data.move_speed if e.enemy_data != null else 1
		var target_tile: int = maxi(e.tile - speed, 0)
		# Walk the path tile-by-tile, looking for a friendly to block on.
		# Block at the FIRST friendly encountered (highest tile in the path).
		var blocker: UnitInstance = null
		var new_tile: int = target_tile
		for t in range(e.tile - 1, target_tile - 1, -1):
			var occupant: UnitInstance = _friendly_at_tile(t)
			if occupant != null and occupant.is_alive():
				blocker = occupant
				new_tile = t  # stop on the friendly's tile
				break
		e.tile = new_tile
		if blocker != null:
			enemy_blocked.emit(e, blocker)
			continue  # don't check base — we're not there
		if e.is_at_base():
			var dmg: int = e.enemy_data.base_strike_damage()
			total_damage += dmg
			enemy_reached_base.emit(e, dmg)
			to_despawn.append(e)
	for d in to_despawn:
		enemies.erase(d)
	return total_damage


## Helper — first alive friendly on the given tile (or null).
func _friendly_at_tile(tile_idx: int) -> UnitInstance:
	for u in friendly_units:
		if u != null and u.is_alive() and u.tile == tile_idx:
			return u
	return null


# ============================================================================
# Cleanup helpers
# ============================================================================

## Remove a dead enemy from the lane. Call after take_damage if you want
## reaction-fire behaviour; otherwise advance_all() sweeps dead at end-of-tick.
func cull_dead() -> int:
	var removed: int = 0
	for e in enemies.duplicate():
		if not e.is_alive():
			enemies.erase(e)
			enemy_killed.emit(e)
			removed += 1
	return removed


func is_empty() -> bool:
	return enemies.is_empty()


func enemy_count() -> int:
	return enemies.size()


# ============================================================================
# Friendly unit placement (B2.6)
# ============================================================================

## True if a friendly unit currently occupies the given tile.
func is_tile_occupied(tile_idx: int) -> bool:
	for u in friendly_units:
		if u != null and u.is_alive() and u.tile == tile_idx:
			return true
	return false


## True if `tile_idx` is in the playable range (1 .. tile_count - 1).
## Tile 0 is the base, never a valid placement target. Tile = tile_count is
## the enemy spawn line, never a valid friendly placement target either.
func is_tile_in_range(tile_idx: int) -> bool:
	return tile_idx >= 1 and tile_idx < tile_count


## Returns the lowest-index empty playable tile, or -1 if no empty slot.
## Convention: tile 1 is closest to the base (back rank), tile_count-1 is
## furthest forward. CardPlay defaults to first_empty_tile() when the player
## hasn't picked a specific tile (auto-place at the back rank).
func first_empty_tile() -> int:
	for t in range(1, tile_count):
		if not is_tile_occupied(t):
			return t
	return -1


## Place a unit on the given tile. Returns the UnitInstance on success, or
## null if the tile is invalid / occupied. The Card's hp / attack_range etc.
## are read by the engine from `unit.card_data`.
##
## After the unit is appended, fires the aura on-enter hook (AURA.E1):
## existing aura sources in lane get a chance to grant onto the new unit,
## and if the new unit is itself an aura source, it walks existing
## friendlies and grants onto each.
func place_unit(card: Card, tile_idx: int) -> UnitInstance:
	if card == null or card.card_type != GFEnums.CardType.UNIT:
		return null
	if not is_tile_in_range(tile_idx):
		return null
	if is_tile_occupied(tile_idx):
		return null
	var u := UnitInstance.new(card, tile_idx, lane_index)
	friendly_units.append(u)
	_on_unit_entered_lane(u)
	unit_placed.emit(u)
	return u


## AURA.E1 — granted-keyword & granted-stat plumbing per
## `keywords/aura_v0.md`. Called after `place_unit()` appends the new unit
## and after Persist resurrects a unit (Combat drain queue). Three passes:
##   (1) walk every existing source in lane and let it `maybe_grant` onto
##       `new_unit` (outbound auras from existing sources)
##   (2) call `maybe_grant(new_unit, null, self)` so `new_unit` (if it's a
##       source) grants onto all existing friendlies
##   (3) `re_evaluate_self_auras(self)` so self-aura conditions like L41's
##       "while a friendly banner is in lane" reflow.
func _on_unit_entered_lane(new_unit: UnitInstance) -> void:
	if new_unit == null:
		return
	for source in friendly_units:
		if source == null or source == new_unit:
			continue
		AuraDispatch.maybe_grant(source, new_unit, self)
	AuraDispatch.maybe_grant(new_unit, null, self)
	AuraDispatch.re_evaluate_self_auras(self, null)
	# W4.E1 — dynamic outbound auras (W4 Bear-Skin Hierophant's
	# highest-cost-Wilds target) need a clean-slate revoke + re-grant
	# pass when ANY unit enters lane since the predicate's target set
	# may have shifted.
	AuraDispatch.re_evaluate_dynamic_outbound_auras(self, null)


## Called before a unit is removed from the lane (cull_dead_units, also
## Sacrifice when wired). Strips all aura grants whose source is the
## leaving unit, then re-evaluates self-auras passing `leaving_unit` as
## `excluding` so the dying banner doesn't keep L41's PIERCE alive past
## its own death.
func _on_unit_leaving_lane(leaving_unit: UnitInstance) -> void:
	if leaving_unit == null:
		return
	AuraDispatch.revoke_all_from(leaving_unit, self)
	AuraDispatch.re_evaluate_self_auras(self, leaving_unit)
	# W4.E1 — re-evaluate dynamic outbound auras with leaving_unit excluded
	# so the grant moves to the next-highest when the current holder dies.
	AuraDispatch.re_evaluate_dynamic_outbound_auras(self, leaving_unit)


## Cull dead friendly units. Mirrors `cull_dead()` for enemies. Call after
## any phase that can damage friendlies (B2.7 enemy attacks, sacrifice
## resolution, etc).
##
## Fires `_on_unit_leaving_lane()` BEFORE erase so any aura grants the
## dying unit was projecting onto others get cleanly revoked (AURA.E1).
## Order matters: revoke first, then unit_killed signal — listeners
## including Combat's Persist-queue capture see consistent aura state.
func cull_dead_units() -> int:
	var removed: int = 0
	for u in friendly_units.duplicate():
		if not u.is_alive():
			_on_unit_leaving_lane(u)
			friendly_units.erase(u)
			unit_killed.emit(u)
			removed += 1
	return removed


func unit_count() -> int:
	return friendly_units.size()


func _to_string() -> String:
	return "Lane(idx=%d tiles=%d enemies=%d units=%d)" % [
		lane_index, tile_count, enemies.size(), friendly_units.size()
	]



# ============================================================================
# Damage wrappers (IMV-1 — fires hit signals for flash)
# ============================================================================

## Apply damage to an enemy and fire `enemy_hit` for view feedback.
## Returns actual damage taken.
func apply_damage_to_enemy(enemy: EnemyInstance, damage: int) -> int:
	if enemy == null or damage <= 0:
		return 0
	var actual: int = enemy.take_damage(damage)
	if actual > 0:
		enemy_hit.emit(enemy, actual)
	return actual


## Apply damage to a friendly unit and fire `unit_hit` for view feedback.
## Returns actual damage taken.
func apply_damage_to_unit(unit: UnitInstance, damage: int) -> int:
	if unit == null or damage <= 0:
		return 0
	var actual: int = unit.take_damage(damage)
	if actual > 0:
		unit_hit.emit(unit, actual)
	return actual
