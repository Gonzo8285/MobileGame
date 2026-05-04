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

var lane_index: int = 0
var tile_count: int = 6                   ## number of playable tiles 1..tile_count-1, plus tile 0 = base
var enemies: Array[EnemyInstance] = []
var friendly_units: Array = []            ## populated by B2.6 (UnitInstance — class lands then)


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

## Advance every living enemy by its `move_speed`. Any enemy that crosses tile
## 0 emits `enemy_reached_base` with the damage it deals; Combat listens and
## forwards the hit to GameState.take_damage.
##
## Returns the total base damage dealt this tick (for tests / damage-roll-up
## display).
func advance_all() -> int:
	var total_damage: int = 0
	# Iterate a copy so we can splice the list mid-loop if an enemy despawns.
	var to_despawn: Array[EnemyInstance] = []
	for e in enemies:
		if not e.is_alive():
			to_despawn.append(e)
			continue
		var speed: int = e.enemy_data.move_speed if e.enemy_data != null else 1
		e.advance(speed)
		if e.is_at_base():
			var dmg: int = e.enemy_data.base_strike_damage()
			total_damage += dmg
			enemy_reached_base.emit(e, dmg)
			to_despawn.append(e)
	for d in to_despawn:
		enemies.erase(d)
	return total_damage


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


func _to_string() -> String:
	return "Lane(idx=%d tiles=%d enemies=%d)" % [
		lane_index, tile_count, enemies.size()
	]
