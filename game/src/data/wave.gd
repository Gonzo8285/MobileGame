extends Resource
class_name Wave

## Wave (B2.5) — declarative spawn pattern for one combat encounter.
##
## A combat is a sequence of waves. A wave is a list of `WaveSpawnEntry`
## items: each entry says "on turn T, spawn enemy X in lane L". The
## `WaveSpawner` reads this list at start of each turn and does the work.
##
## We keep entries inline (Array of typed sub-Resource) rather than a
## separate `.tres` per spawn, because there will be hundreds of these and
## one file per wave is enough granularity for designers. WaveSpawnEntry is
## defined as an inner Resource class below.

@export var id: StringName = &""
@export var display_name: String = ""

## Total turn count for the wave. The combat is "victory" when this many
## turns have elapsed AND all spawned enemies are cleared (killed or routed).
@export_range(1, 50) var turn_count: int = 8

## Spawn schedule. Each entry triggers on the given `on_turn` value.
@export var spawns: Array[WaveSpawnEntry] = []


func entries_for_turn(turn_num: int) -> Array[WaveSpawnEntry]:
	var out: Array[WaveSpawnEntry] = []
	for e in spawns:
		if e != null and e.on_turn == turn_num:
			out.append(e)
	return out


func _to_string() -> String:
	return "Wave(%s '%s' turns=%d spawns=%d)" % [
		id, display_name, turn_count, spawns.size()
	]
