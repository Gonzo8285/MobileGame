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
## Emitted at the end of `_on_turn_ended` after the TurnEngine has resolved
## DoTs / attacks / Persist. Carries the merged result Dictionary from
## TurnEngine for HUD + test consumption (see TurnEngine docstring for shape).
signal turn_resolved(turn_num: int, summary: Dictionary)

const LANE_COUNT: int = 3
const DEFAULT_TILES_PER_LANE: int = 6
const OPENING_HAND_SIZE: int = 5

var lanes: Array[Lane] = []
var spawner: WaveSpawner = null
var current_wave: Wave = null
var is_over: bool = false
var ended_in_victory: bool = false

# Persist (M1) queue — UnitInstances that died this turn AND carry the
# PERSIST keyword AND haven't already persisted this combat. Captured via
# the lane.unit_killed signal in `_on_unit_killed`. Drained at the end of
# `_on_turn_ended` after enemy advance + cull, then cleared.
var _pending_persists: Array[UnitInstance] = []

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
		lane.unit_placed.connect(_on_unit_placed)
		lane.unit_killed.connect(_on_unit_killed)
		# IMV-1 visuals: visualize enemies on lane (HP bars, advance feedback).
		lane.enemy_spawned.connect(_on_enemy_spawned)
		lane.enemy_killed.connect(_on_enemy_killed)
		lanes.append(lane)


# ============================================================================
# Run
# ============================================================================

## Begin the combat. Drives GameState into COMBAT phase, binds turn signals.
## Caller is expected to have already done `GameState.start_run(...)`.
##
## B2.7 added: opening-hand draw of 5 cards happens BEFORE GameState.start_combat
## so the player faces turn 1 with their starting hand. Subsequent turns draw 1
## via the TurnEngine.
func start() -> void:
	if current_wave == null:
		push_error("[Combat] start() called with no wave set")
		return
	spawner.start_wave(current_wave)

	_gs_turn_started_cb = Callable(self, "_on_turn_started")
	_gs_turn_ended_cb = Callable(self, "_on_turn_ended")
	GameState.turn_started.connect(_gs_turn_started_cb)
	GameState.turn_ended.connect(_gs_turn_ended_cb)

	# Wire hand-overflow → discard so any turn-N draw on a full hand burns the
	# overflow rather than dropping it on the floor (matches cards_v0.md
	# "burn-mill" rule). Local lambda captures the discard reference; safe to
	# leave bound across combats — Hand and Discard are recreated by start_run.
	if GameState.hand != null and GameState.discard != null:
		var d := GameState.discard
		var overflow_cb := func(c: Card):
			if c != null:
				d.add(c)
		if not GameState.hand.overflowed.is_connected(overflow_cb):
			GameState.hand.overflowed.connect(overflow_cb)

	GameState.start_combat(OPENING_HAND_SIZE)
	combat_started.emit(current_wave)
	# Self-subscribe so the HUD StatusLabel reflects play-attempt outcomes
	# and mana/turn changes — Paul reported being confused about why some
	# cards wouldn't play. Show the actual reason on every drop attempt.
	if not card_play_attempted.is_connected(_on_card_play_attempted):
		card_play_attempted.connect(_on_card_play_attempted)
	if not GameState.mana_changed.is_connected(_on_mana_changed):
		GameState.mana_changed.connect(_on_mana_changed)
	_refresh_status_hud("Turn 1 — drag a card to a lane to play it")


# ============================================================================
# Turn handlers
# ============================================================================

func _on_turn_started(turn_num: int) -> void:
	if is_over or spawner == null:
		return
	# B2.7 turn-start phase: status duration decay + cooldown ticks + draw 1.
	# Spawn happens AFTER so newly-spawned enemies don't get an immediate
	# duration decay on turn-of-spawn (clean status semantics).
	TurnEngine.process_turn_start(lanes, GameState.hand, GameState.deck, GameState.discard, turn_num)
	spawner.tick(turn_num)


func _on_turn_ended(turn_num: int) -> void:
	if is_over:
		return
	# B2.7 turn-end phase order — see TurnEngine docstring.
	# 1-3: DoT tick → friendly attacks → cull dead enemies (player initiative).
	var pre := TurnEngine.process_turn_end_pre_advance(lanes)

	# 4: Enemies advance (Lane owns this; routes base-reach damage through the
	# enemy_reached_base signal into GameState.take_damage).
	for lane in lanes:
		lane.advance_all()

	# 5-6: Enemy stand-attacks vs friendlies on the same tile, then cull dead
	# friendlies. The cull fires unit_killed → _on_unit_killed which captures
	# Persist candidates into _pending_persists.
	var post := TurnEngine.process_turn_end_post_advance(lanes)

	# 7: Drain the Persist queue. Returns persisted units to origin tile (or
	# nearest empty in row) at -1 ATK, marks has_persisted, clears the queue.
	var persisted: int = 0
	if not _pending_persists.is_empty():
		persisted = TurnEngine.drain_persists(lanes, _pending_persists)
		_pending_persists.clear()

	# Surface a single summary signal for HUD + tests.
	var summary := pre.duplicate()
	summary["enemy_atk"] = post["enemy_atk"]
	summary["kills_friend"] = post["kills_friend"]
	summary["persisted"] = persisted
	summary["turn"] = turn_num
	turn_resolved.emit(turn_num, summary)

	# Did the base just die?
	if GameState.base_hp <= 0:
		_finish(false)
		return
	# Did we win? Wave done + lanes empty.
	if spawner != null and spawner.is_complete():
		_finish(true)
		return
	# Otherwise the orchestrator (or test driver) is responsible for calling
	# GameState.next_turn() — the engine deliberately does NOT self-drive, to
	# avoid recursing through the turn-end signal and to give the UI a chance
	# to render between turns.


# ============================================================================
# Damage routing
# ============================================================================

func _on_enemy_reached_base(enemy: EnemyInstance, damage: int) -> void:
	GameState.take_damage(damage)
	# Despawn the visual — enemy_killed isn't fired for base-reach despawns.
	if _enemy_views.has(enemy):
		var ev: EnemyView = _enemy_views[enemy]
		_enemy_views.erase(enemy)
		if is_instance_valid(ev):
			ev.queue_free()


# ============================================================================
# Friendly unit visuals (B2.6 UI)
# ============================================================================

## Track UnitView instances by the UnitInstance they represent so we can
## clean them up when the unit dies. Held weakly by reference; UnitView
## queue_frees itself on _on_unit_killed.
var _unit_views: Dictionary = {}  ## { UnitInstance -> UnitView }
var _enemy_views: Dictionary = {}  ## { EnemyInstance -> EnemyView }

func _on_unit_placed(unit: UnitInstance) -> void:
	if unit == null:
		return
	var uv: UnitView = UnitView.new()
	uv.bind(unit)
	add_child(uv)
	_unit_views[unit] = uv
	# Phase 2.16 / W41.E1 — Pack-Caller Initiate Wolf-Token draw trigger.
	# Per Phase 2.13 N3: "When a friendly Wolf-Token is summoned in your lane,
	# draw 1 card. Once per turn." Conditions:
	#   - placed unit's card.id == &"W28" (Wolf-Token)
	#   - a friendly W41 (Pack-Caller Initiate) is alive in the SAME lane as
	#     the newly-placed Wolf-Token (per spec: "in your lane" = W41's lane)
	#   - the trigger has not already fired this turn (GameState's
	#     try_trigger_wolf_summon_draw() returns false if fired-this-turn)
	# The just-placed Wolf-Token is in `lane.friendly_units` by the time this
	# signal fires (lane.place_unit appends BEFORE emitting unit_placed), but
	# the trigger checks for ANY alive friendly W41 in the lane — W28 is never
	# W41 itself, so there's no self-trigger risk.
	if unit.card_data != null and unit.card_data.id == &"W28":
		var placed_lane_idx: int = unit.lane_index
		if placed_lane_idx >= 0 and placed_lane_idx < lanes.size():
			var placed_lane: Lane = lanes[placed_lane_idx]
			for u in placed_lane.friendly_units:
				if u != null and u.is_alive() and u.card_data != null \
						and u.card_data.id == &"W41":
					GameState.try_trigger_wolf_summon_draw()
					break


func _on_unit_killed(unit: UnitInstance) -> void:
	if unit == null:
		return
	# B2.7 / M1: capture Persist-eligible deaths for end-of-turn return.
	# Conditions per `keywords/persist_v0.md`: card has PERSIST keyword, unit
	# has not already persisted this combat, and the unit is not a token.
	# Tokens are excluded because Persist returns the source Card to the lane
	# — tokens have no playable Card to return to.
	if unit.card_data != null \
			and unit.card_data.has_keyword(GFEnums.Keyword.PERSIST) \
			and not unit.has_persisted \
			and not unit.is_token:
		_pending_persists.append(unit)
	# Phase 2.16 / M41.E1 — Wraith-Caller of the Dirge cost-discount trigger.
	# Per Phase 2.13 N1: "When a friendly Mourner dies, the next Mourner you
	# play this turn costs 1 less. Cap once per turn." Conditions:
	#   - dying unit's faction == ASH_MOURNERS
	#   - a friendly M41 (Wraith-Caller of the Dirge) is alive in the SAME lane
	#     as the dying unit (per spec: "friendly M41 in lane")
	#   - the trigger has not already fired this turn (handled by GameState's
	#     two-flag model: arm_mourner_discount is a no-op if fired-this-turn)
	# By the time _on_unit_killed fires, the dying unit has been removed from
	# `lane.friendly_units` by `cull_dead_units`, so M41 dying does not
	# inadvertently satisfy the "M41 in lane" check on its own death.
	if unit.card_data != null \
			and unit.card_data.faction == GFEnums.Faction.ASH_MOURNERS:
		var dying_lane_idx: int = unit.lane_index
		if dying_lane_idx >= 0 and dying_lane_idx < lanes.size():
			var dying_lane: Lane = lanes[dying_lane_idx]
			for u in dying_lane.friendly_units:
				if u != null and u.is_alive() and u.card_data != null \
						and u.card_data.id == &"M41":
					GameState.arm_mourner_discount()
					break
	# Clean up the visual.
	if not _unit_views.has(unit):
		return
	var uv: UnitView = _unit_views[unit]
	_unit_views.erase(unit)
	if is_instance_valid(uv):
		uv.queue_free()


# ============================================================================
# Enemy visuals (IMV-1)
# ============================================================================

func _on_enemy_spawned(enemy: EnemyInstance) -> void:
	if enemy == null:
		return
	var ev: EnemyView = EnemyView.new()
	ev.bind(enemy)
	add_child(ev)
	_enemy_views[enemy] = ev


func _on_enemy_killed(enemy: EnemyInstance) -> void:
	if enemy == null or not _enemy_views.has(enemy):
		return
	var ev: EnemyView = _enemy_views[enemy]
	_enemy_views.erase(enemy)
	if is_instance_valid(ev):
		ev.queue_free()


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


# ============================================================================
# Drag-drop entry point (B2.6 UI)
# ============================================================================

## Called by LaneDropZone when the player drops a card on a lane. Translates
## the drop into a `CardPlay.play_card` call and surfaces the result via the
## `card_play_attempted` signal so the HUD can react (mana update, error
## toast, etc).
##
## `drop_position` is the local position inside the lane visual. For B2.6
## we ignore it and auto-place at the back rank — per-tile drop targeting
## is a polish item the layout review will decide.
signal card_play_attempted(result: Dictionary)

func handle_drop(lane_idx: int, card: Card, _drop_position: Vector2) -> Dictionary:
	if lane_idx < 0 or lane_idx >= lanes.size():
		var fail := {"success": false, "reason": "lane out of range", "unit": null}
		card_play_attempted.emit(fail)
		return fail
	var hand: Hand = GameState.hand
	var discard: Discard = GameState.discard
	if hand == null or discard == null:
		var fail2 := {"success": false, "reason": "no run in progress", "unit": null}
		card_play_attempted.emit(fail2)
		return fail2
	var result: Dictionary = CardPlay.play_card(card, {"lane": lane_idx}, hand, discard, lanes)
	card_play_attempted.emit(result)
	return result


## End the current player turn. Public entry point for the UI's "End Turn"
## button. Equivalent to `GameState.next_turn()` but lives on Combat for clean
## API surface — UI talks to Combat, Combat talks to GameState. Idempotent on
## a finished combat (no-op).
func end_turn() -> void:
	if is_over:
		return
	GameState.next_turn()


# ============================================================================
# HUD feedback (B2.6+ — make the play-rejection reason visible)
# ============================================================================

func _refresh_status_hud(message: String) -> void:
	var lbl: Label = get_node_or_null("HUD/StatusLabel") as Label
	if lbl == null:
		return
	var mana_str: String = "Mana %d/%d" % [GameState.mana, GameState.max_mana]
	var turn_str: String = "Turn %d" % GameState.turn
	lbl.text = "%s   |   %s   |   %s" % [turn_str, mana_str, message]


func _on_mana_changed(_new_mana: int, _ceiling: int) -> void:
	_refresh_status_hud("Drag a card to a lane")


func _on_card_play_attempted(result: Dictionary) -> void:
	if result.get("success", false):
		var unit_str: String = "card"
		var u = result.get("unit")
		if u != null and u.card_data != null:
			unit_str = u.card_data.display_name
		_refresh_status_hud("Played %s" % unit_str)
	else:
		var reason: String = result.get("reason", "rejected")
		_refresh_status_hud("Cannot play: %s" % reason)


## Detach this combat from GameState. Idempotent; safe to call after a
## natural combat_ended already disconnected. Call before freeing the node
## if combat didn't run to completion (e.g. test tear-down, scene change).
func cleanup() -> void:
	is_over = true
	_pending_persists.clear()
	if _gs_turn_started_cb.is_valid() and GameState.turn_started.is_connected(_gs_turn_started_cb):
		GameState.turn_started.disconnect(_gs_turn_started_cb)
	if _gs_turn_ended_cb.is_valid() and GameState.turn_ended.is_connected(_gs_turn_ended_cb):
		GameState.turn_ended.disconnect(_gs_turn_ended_cb)
