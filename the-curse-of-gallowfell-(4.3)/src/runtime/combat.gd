extends Node2D

## Combat (B2.5) — combat scene orchestrator.
##
## Owns three Lane data objects, the WaveSpawner, the player base HP wiring,
## and the win/loss conditions. Card-play (drag-drop) lands in B2.6;
## attack-resolution / draw / status tick in B2.7. This file keeps the
## scaffold to spawning, advancing, and ending the combat.
##
## The visual children of `combat.tscn` (lane backgrounds, base art) are
## placeholders — they're informational only at this stage. The B2.6/B2.7
## work will replace the placeholders with live unit + enemy sprites.
##
## Lifecycle:
##   1. Caller (B2.9 map / dev-test) calls `setup(wave)` then `start()`.
##   2. Combat calls `GameState.start_combat()` and binds turn signals.
##   3. Each `turn_started` from GameState ⇒ spawner.tick(turn).
##   4. Each `turn_ended` ⇒ lanes.advance_all(); base eats damage; check end.
##   5. Win when wave is done + lanes empty. Loss when base HP ⇒ 0.

signal combat_started(wave: Wave)
signal combat_ended(victory: bool)

const LANE_COUNT: int = 3
const DEFAULT_TILES_PER_LANE: int = 6

var lanes: Array[Lane] = []
var spawner: WaveSpawner = null
var current_wave: Wave = null
var is_over: bool = false
var ended_in_victory: bool = false

# Connections we manage so we can disconnect cleanly on combat_ended.
var _gs_turn_started_cb: Callable
var _gs_turn_ended_cb: Callable


func _ready() -> void:
	# Build lanes up front so the scaffold is in a valid state even before a
	# wave is loaded. setup() is the proper entry point for a real combat.
	if lanes.is_empty():
		_init_lanes(DEFAULT_TILES_PER_LANE)


# ============================================================================
# Setup
# ============================================================================

## Configure the combat with a Wave resource. Call before start().
func setup(wave: Wave, tiles_per_lane: int = DEFAULT_TILES_PER_LANE) -> void:
	current_wave = wave
	_init_lanes(tiles_per_lane)
	spawner = WaveSpawner.new(lanes)


func _init_lanes(tiles_per_lane: int) -> void:
	lanes.clear()
	for i in range(LANE_COUNT):
		var lane := Lane.new(i, tiles_per_lane)
		lane.enemy_reached_base.connect(_on_enemy_reached_base)
		lanes.append(lane)


# ============================================================================
# Run
# ============================================================================

## Begin the combat. Drives GameState into COMBAT phase, binds turn signals.
## Caller is expected to have already done `GameState.start_run(...)`.
func start() -> void:
	if current_wave == null:
		push_error("[Combat] start() called with no wave set")
		return
	spawner.start_wave(current_wave)

	_gs_turn_started_cb = Callable(self, "_on_turn_started")
	_gs_turn_ended_cb = Callable(self, "_on_turn_ended")
	GameState.turn_started.connect(_gs_turn_started_cb)
	GameState.turn_ended.connect(_gs_turn_ended_cb)

	GameState.start_combat()
	combat_started.emit(current_wave)


# ============================================================================
# Turn handlers
# ============================================================================

func _on_turn_started(turn_num: int) -> void:
	if is_over or spawner == null:
		return
	spawner.tick(turn_num)


func _on_turn_ended(turn_num: int) -> void:
	# Move every enemy on every lane. Each lane reports any base damage via
	# the connected `enemy_reached_base` signal, which routes through
	# `_on_enemy_reached_base` and into GameState.
	if is_over:
		return
	for lane in lanes:
		lane.advance_all()
	# Did the base just die?
	if GameState.base_hp <= 0:
		_finish(false)
		return
	# Did we win? Wave done + lanes empty.
	if spawner != null and spawner.is_complete():
		_finish(true)
		return
	# Otherwise the orchestrator (B2.7 turn engine, or the dev smoke test) is
	# responsible for calling GameState.next_turn() — the scaffold deliberately
	# does NOT self-drive, to avoid recursing through the turn-end signal.


# ============================================================================
# Damage routing
# ============================================================================

func _on_enemy_reached_base(enemy: EnemyInstance, damage: int) -> void:
	GameState.take_damage(damage)


# ============================================================================
# Cleanup
# ============================================================================

func _finish(victory: bool) -> void:
	is_over = true
	ended_in_victory = victory
	# Detach turn signals so we don't double-handle if the scene is reused.
	if _gs_turn_started_cb.is_valid() and GameState.turn_started.is_connected(_gs_turn_started_cb):
		GameState.turn_started.disconnect(_gs_turn_started_cb)
	if _gs_turn_ended_cb.is_valid() and GameState.turn_ended.is_connected(_gs_turn_ended_cb):
		GameState.turn_ended.disconnect(_gs_turn_ended_cb)
	combat_ended.emit(victory)
	# We don't end the run here — that's the meta-progression's call. A loss
	# in a non-boss combat just means "node failed"; the run-end check sits
	# higher up. For the B2.5 smoke test we leave that hook to the test.


# ============================================================================
# Convenience
# ============================================================================

func total_enemy_count() -> int:
	var n: int = 0
	for lane in lanes:
		n += lane.enemy_count()
	return n


func has_ended() -> bool:
	return is_over


## Detach this combat from GameState. Idempotent; safe to call after a
## natural combat_ended already disconnected. Call before freeing the node
## if combat didn't run to completion (e.g. test tear-down, scene change).
func cleanup() -> void:
	is_over = true
	if _gs_turn_started_cb.is_valid() and GameState.turn_started.is_connected(_gs_turn_started_cb):
		GameState.turn_started.disconnect(_gs_turn_started_cb)
	if _gs_turn_ended_cb.is_valid() and GameState.turn_ended.is_connected(_gs_turn_ended_cb):
		GameState.turn_ended.disconnect(_gs_turn_ended_cb)
