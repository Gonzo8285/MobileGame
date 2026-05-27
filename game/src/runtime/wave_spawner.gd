extends RefCounted
class_name WaveSpawner

## WaveSpawner (B2.5) — drives enemy spawns from a Wave resource.
##
## Owned by Combat. Each turn-tick, Combat calls `tick(turn)` and the spawner
## consults the active wave's spawn schedule, asks the relevant lanes to
## insert the right enemies. When the wave's turn_count is reached and all
## lanes are empty, Combat reads `is_complete()` and triggers victory.

signal wave_started(wave: Wave)
signal wave_complete(wave: Wave)
signal spawn_fired(entry: WaveSpawnEntry, instance: EnemyInstance)

var current_wave: Wave = null
var current_turn: int = 0
var lanes: Array[Lane] = []  ## Set by Combat at scene-init.


func _init(combat_lanes: Array[Lane] = []) -> void:
	lanes = combat_lanes


# ============================================================================
# Wave control
# ============================================================================

func start_wave(wave: Wave) -> void:
	current_wave = wave
	current_turn = 0
	wave_started.emit(wave)


## Advance the wave by one turn. Spawns any entries scheduled for this turn.
## Returns the number of spawns that fired (0 = no spawns this tick).
func tick(turn_num: int) -> int:
	if current_wave == null:
		return 0
	current_turn = turn_num
	var entries := current_wave.entries_for_turn(turn_num)
	var fired: int = 0
	for entry in entries:
		if entry == null or entry.enemy == null:
			continue
		if entry.lane < 0 or entry.lane >= lanes.size():
			push_warning("[WaveSpawner] entry lane %d out of range (lanes=%d)" % [
				entry.lane, lanes.size()
			])
			continue
		var lane: Lane = lanes[entry.lane]
		var instance := lane.spawn_enemy(entry.enemy)
		spawn_fired.emit(entry, instance)
		fired += 1
	return fired


# ============================================================================
# Completion
# ============================================================================

## True if the wave's turn_count has been reached AND every lane is empty
## (all spawned enemies killed or reached the base). Combat polls this each
## turn-end to decide whether to fire victory.
func is_complete() -> bool:
	if current_wave == null:
		return false
	if current_turn < current_wave.turn_count:
		return false
	for lane in lanes:
		if not lane.is_empty():
			return false
	return true


## True if every scheduled spawn has fired. Useful for B2.7 boss-music cues
## and "last wave" prompts.
func all_spawns_fired() -> bool:
	if current_wave == null:
		return false
	return current_turn >= current_wave.turn_count


func _to_string() -> String:
	var name_str: String = current_wave.id if current_wave != null else "<none>"
	return "WaveSpawner(wave=%s turn=%d/%d)" % [
		name_str,
		current_turn,
		current_wave.turn_count if current_wave != null else 0,
	]
