extends Resource
class_name WaveSpawnEntry

## WaveSpawnEntry (B2.5) — single line item inside a Wave.
##
## Says "on turn T, spawn enemy X in lane L." Multiple entries on the same
## turn are fine (same lane = simultaneous spawn at the spawn tile, FIFO
## advance order).

## 1-based turn number (matches GameState.turn). on_turn = 1 means the spawn
## fires on the first turn of the wave.
@export_range(1, 50) var on_turn: int = 1

## Which lane the enemy spawns in. 0..2 valid for a 3-lane combat.
@export_range(0, 2) var lane: int = 0

## The enemy archetype to spawn.
@export var enemy: Enemy = null


func _to_string() -> String:
	var name_str: String = enemy.id if enemy != null else "<no-enemy>"
	return "Spawn(t%d L%d %s)" % [on_turn, lane, name_str]
