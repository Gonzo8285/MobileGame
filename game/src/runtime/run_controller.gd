extends Node2D
class_name RunController

## Run controller — top-level scene that orchestrates the IMV-1 playable loop.
##
## Owns one active child scene at a time and swaps them on GameState phase
## transitions:
##
##   TITLE  → title.tscn        (picks Warlord, calls GameState.start_run)
##   MAP    → map_view.tscn     (renders graph, picks next node)
##   COMBAT → combat.tscn       (sandbox-style placement; auto-resolves)
##   REWARD → reward_view.tscn  (3-card pick or skip)
##   GAME_OVER / VICTORY → game_over.tscn
##
## Listens to GameState.phase_changed and reacts. Children emit signals
## (MapView.node_selected, RewardView.picked, Title.run_started_pressed) which
## the controller routes back into GameState API calls.

const TITLE_SCENE: PackedScene = preload("res://scenes/title.tscn")
const MAP_SCENE: PackedScene = preload("res://scenes/map_view.tscn")
const COMBAT_SCENE: PackedScene = preload("res://scenes/combat.tscn")
const REWARD_SCENE: PackedScene = preload("res://scenes/reward_view.tscn")
const GAME_OVER_SCENE: PackedScene = preload("res://scenes/game_over.tscn")
const DECK_BUILDER_SCENE: PackedScene = preload("res://scenes/deck_builder.tscn")
const WARLORD_SELECT_SCENE: PackedScene = preload("res://scenes/warlord_select.tscn")
const COLLECTION_SCENE: PackedScene = preload("res://scenes/collection.tscn")

# How many enemies to spawn per combat. Placeholder until proper wave content
# is per-node. Hook for B2.11 (Hanging Hour escalation per chapter depth).
const PLACEHOLDER_COMBAT_TIMEOUT_SEC: float = 0.0  # 0 = wait for manual end via debug "End Combat" key

var _active_child: Node = null


func _ready() -> void:
	GameState.phase_changed.connect(_on_phase_changed)
	GameState.run_ended.connect(_on_run_ended)
	# run_started fires BEFORE phase_changed; we also wire it because the
	# default GameState phase is MAP, so set_phase(MAP) during start_run is a
	# no-op and phase_changed wouldn't fire for the initial title → map swap.
	GameState.run_started.connect(_on_run_started)
	# DB-5: Title emits deck_build_requested on Warlord pick → show the builder.
	GameState.deck_build_requested.connect(_on_deck_build_requested)
	# WL-4: screen router — Title "Play" → Warlord Select; Back → Title.
	GameState.warlord_select_requested.connect(func(): _swap_to(WARLORD_SELECT_SCENE))
	GameState.title_requested.connect(func(): _swap_to(TITLE_SCENE))
	GameState.collection_requested.connect(func(): _swap_to(COLLECTION_SCENE))
	# Start on title screen.
	_swap_to(TITLE_SCENE)


func _on_run_started(_seed_value: int, _warlord_id: StringName) -> void:
	# Initial title → map swap. From here on phase_changed handles transitions.
	_swap_to(MAP_SCENE, _wire_map)


func _on_deck_build_requested(warlord_id: StringName, faction: int) -> void:
	# DB-5: swap to the deck-builder. setup() runs BEFORE add_child so the
	# builder's _ready resolves the draftable pool for the right faction.
	if _active_child != null:
		_active_child.queue_free()
		_active_child = null
	var db: Node = DECK_BUILDER_SCENE.instantiate()
	db.setup(warlord_id, faction)
	add_child(db)
	_active_child = db


func _on_phase_changed(_old: int, new_phase: int) -> void:
	match new_phase:
		GFEnums.RunPhase.MAP:
			_swap_to(MAP_SCENE, _wire_map)
		GFEnums.RunPhase.COMBAT, GFEnums.RunPhase.BOSS:
			_swap_to(COMBAT_SCENE, _wire_combat)
		GFEnums.RunPhase.REWARD:
			_swap_to(REWARD_SCENE, _wire_reward)
		GFEnums.RunPhase.GAME_OVER, GFEnums.RunPhase.VICTORY:
			_swap_to(GAME_OVER_SCENE, _wire_game_over)
		_:
			pass  # SHOP / EVENT / SHRINE not implemented in IMV-1 — auto-skip below


func _on_run_ended(_victory: bool) -> void:
	# `set_phase(GAME_OVER|VICTORY)` already fired in `_on_phase_changed`.
	pass


# ---------------------------------------------------------------------------
# Scene swapping
# ---------------------------------------------------------------------------

func _swap_to(scene: PackedScene, wire: Callable = Callable()) -> void:
	if _active_child != null:
		_active_child.queue_free()
		_active_child = null
	var inst: Node = scene.instantiate()
	add_child(inst)
	_active_child = inst
	if wire.is_valid():
		wire.call(inst)


# ---------------------------------------------------------------------------
# Per-scene wiring
# ---------------------------------------------------------------------------

func _wire_map(map_view: Node) -> void:
	if map_view.has_signal("node_selected"):
		map_view.node_selected.connect(_on_map_node_selected)


func _wire_combat(combat: Node) -> void:
	# Combat scene's drag-drop works out of the box, but for a real combat loop
	# we need to: load a Wave, call Combat.setup(wave)+start() to kick the turn
	# engine, and add an End-Turn button + HUD so the player can act each turn.
	# We also listen for `combat_ended` to route victory → reward, defeat → HP-check.
	# Per-round wave: build via WaveGenerator using the current node's kind +
	# round number (derived from MapNode depth + 1). Falls back to the static
	# act1_combat1.tres if anything goes wrong.
	var round_num: int = 1
	var kind: int = GFEnums.NodeKind.COMBAT
	if GameState.current_map_graph != null and GameState.current_map_graph.nodes.has(GameState.current_node_id):
		var cur_node: MapNode = GameState.current_map_graph.nodes[GameState.current_node_id]
		round_num = cur_node.depth + 1
		kind = cur_node.kind
	var wave: Wave = WaveGenerator.for_round(round_num, kind, GameState.run_seed)
	if wave == null:
		wave = load("res://data/waves/act1_combat1.tres") as Wave
	if wave == null:
		push_error("[run_controller] could not build or load wave; falling back to debug hotkeys")
		set_process_input(true)
		return
	if combat.has_method("setup") and combat.has_method("start"):
		combat.setup(wave)
		combat.start()
	if combat.has_signal("combat_ended"):
		combat.combat_ended.connect(_on_combat_ended)
	_build_combat_hud(combat)
	# Keep the C/X debug hotkeys as a fallback in case the wave doesn't conclude
	# (e.g. lanes can't be cleared with current placeholder card pool).
	set_process_input(true)


func _build_combat_hud(combat: Node) -> void:
	# Find the existing HUD CanvasLayer from combat.tscn (added in B2.6).
	var hud: CanvasLayer = combat.get_node_or_null("HUD") as CanvasLayer
	if hud == null:
		hud = CanvasLayer.new()
		hud.name = "HUD"
		combat.add_child(hud)

	# Replace / repurpose the existing StatusLabel for status messages.
	var status: Label = hud.get_node_or_null("StatusLabel") as Label
	if status != null:
		status.text = "Place units, then press End Turn (or C to fake-win, X to fake-lose)"

	# HP / Mana / Turn / Wave labels (top-right strip).
	var hp_label := Label.new()
	hp_label.name = "HpLabel"
	hp_label.text = "HP %d/%d" % [GameState.base_hp, GameState.max_base_hp]
	hp_label.add_theme_font_size_override("font_size", 28)
	hp_label.offset_left = 800
	hp_label.offset_top = 80
	hp_label.offset_right = 1060
	hp_label.offset_bottom = 120
	hud.add_child(hp_label)

	var mana_label := Label.new()
	mana_label.name = "ManaLabel"
	mana_label.text = "Mana %d/%d" % [GameState.mana, GameState.max_mana]
	mana_label.add_theme_font_size_override("font_size", 28)
	mana_label.modulate = Color(0.6, 0.8, 1.0)
	mana_label.offset_left = 800
	mana_label.offset_top = 120
	mana_label.offset_right = 1060
	mana_label.offset_bottom = 160
	hud.add_child(mana_label)

	var next_label := Label.new()
	next_label.name = "NextManaLabel"
	next_label.text = "Next turn: %d mana" % GameState.max_mana
	next_label.add_theme_font_size_override("font_size", 16)
	next_label.modulate = Color(0.95, 0.80, 0.30)  # amber, matches next-turn card border
	next_label.offset_left = 800
	next_label.offset_top = 154
	next_label.offset_right = 1060
	next_label.offset_bottom = 180
	hud.add_child(next_label)

	var gem_label := Label.new()
	gem_label.name = "GemLabel"
	gem_label.text = "Gems: %d" % GameState.gems
	gem_label.add_theme_font_size_override("font_size", 20)
	gem_label.modulate = Color(0.55, 0.85, 1.0)  # gem-blue
	gem_label.offset_left = 800
	gem_label.offset_top = 215
	gem_label.offset_right = 1060
	gem_label.offset_bottom = 245
	hud.add_child(gem_label)
	GameState.gems_changed.connect(func(n):
		if is_instance_valid(gem_label):
			gem_label.text = "Gems: %d" % n
	)

	var turn_label := Label.new()
	turn_label.name = "TurnLabel"
	turn_label.text = "Turn %d" % GameState.turn
	turn_label.add_theme_font_size_override("font_size", 24)
	turn_label.modulate = Color(0.9, 0.9, 0.7)
	turn_label.offset_left = 800
	turn_label.offset_top = 184
	turn_label.offset_right = 1060
	turn_label.offset_bottom = 220
	hud.add_child(turn_label)

	# End Turn button (bottom-right, above the hand).
	var end_btn := Button.new()
	end_btn.name = "EndTurnButton"
	end_btn.text = "End Turn"
	end_btn.add_theme_font_size_override("font_size", 28)
	end_btn.offset_left = 880
	end_btn.offset_top = 985
	end_btn.offset_right = 1060
	end_btn.offset_bottom = 1065
	end_btn.pressed.connect(func():
		if combat.has_method("end_turn"):
			combat.end_turn()
	)
	hud.add_child(end_btn)

	# Live-refresh HUD on signal updates.
	GameState.hp_changed.connect(func(new_hp, max_hp):
		if is_instance_valid(hp_label):
			hp_label.text = "HP %d/%d" % [new_hp, max_hp]
	)
	GameState.mana_changed.connect(func(new_mana, ceiling):
		if is_instance_valid(mana_label):
			mana_label.text = "Mana %d/%d" % [new_mana, ceiling]
		if is_instance_valid(next_label):
			next_label.text = "Next turn: %d mana" % ceiling
	)
	GameState.turn_started.connect(func(turn_num):
		if is_instance_valid(turn_label):
			turn_label.text = "Turn %d" % turn_num
	)


func _on_combat_ended(victory: bool) -> void:
	if victory:
		# Award gems based on the just-completed node kind.
		var kind_for_gem: int = GFEnums.NodeKind.COMBAT
		if GameState.current_map_graph != null and GameState.current_map_graph.nodes.has(GameState.current_node_id):
			kind_for_gem = GameState.current_map_graph.nodes[GameState.current_node_id].kind
		var gem_reward: int = GameState.gem_reward_for_kind(kind_for_gem)
		GameState.gain_gems(gem_reward)
		print("[run_controller] combat won — awarded %d gems (kind=%s)" %
				[gem_reward, GFEnums.NodeKind.keys()[kind_for_gem]])
		_award_reward_after_node()
	else:
		# Base HP already dropped to 0 via lanes — GameState.take_damage routes
		# the lethal path. Surface to game-over.
		if GameState.base_hp <= 0:
			GameState.end_run(false)
		else:
			# Non-lethal "lost the wave but survived" path — IMV-1 treats it as
			# minor base damage and returns to map.
			GameState.take_damage(5)
			if GameState.base_hp > 0:
				GameState.set_phase(GFEnums.RunPhase.MAP)


func _wire_reward(reward_view: Node) -> void:
	if reward_view.has_signal("picked"):
		reward_view.picked.connect(_on_reward_picked)


func _wire_game_over(go: Node) -> void:
	if go.has_signal("restart_pressed"):
		go.restart_pressed.connect(_on_restart_pressed)
	if go.has_signal("retry_pressed"):
		go.retry_pressed.connect(_on_retry_pressed)


# ---------------------------------------------------------------------------
# Signal handlers from child scenes
# ---------------------------------------------------------------------------

func _on_map_node_selected(node_id: StringName) -> void:
	var ok: bool = GameState.choose_next_node(node_id)
	if not ok:
		push_warning("[run_controller] illegal node jump to %s" % node_id)
		return
	# After choose_next_node, GameState may auto-set COMBAT phase for a COMBAT
	# kind, or stay on MAP for non-combat kinds in IMV-1.
	var node: MapNode = GameState.current_map_graph.get_node_by_id(node_id)
	if node == null:
		return
	# IMV-1 mapping: COMBAT/ELITE/BOSS → combat scene; others → skip-to-reward.
	match node.kind:
		GFEnums.NodeKind.COMBAT, GFEnums.NodeKind.ELITE, GFEnums.NodeKind.HORDE, GFEnums.NodeKind.BOSS:
			GameState.start_combat(5)  # 5-card opening hand
		_:
			# IMV-1: non-combat nodes auto-resolve with a console note + reward roll.
			print("[run_controller] non-combat node kind=%s — auto-resolving (IMV-1 stub)" %
					GFEnums.NodeKind.keys()[node.kind])
			_award_reward_after_node()


const MAX_CHAPTERS: int = 3  # IMV-1 cap; full game extends in B2.9 follow-on.

func _on_reward_picked(_card: Card) -> void:
	# GameState's reward path adds the card to the deck (or skip = no-op).
	# Determine if we just finished a boss — if yes, advance chapter.
	var boss_completed: bool = false
	if GameState.current_map_graph != null:
		boss_completed = (GameState.current_node_id == GameState.current_map_graph.boss_id)
	if boss_completed:
		# IMV-1 gauntlet: round 8 boss = full run victory. No chapter 2.
		print("[run_controller] gauntlet complete — run victory (gems retained: %d, retries used: %d)" %
				[GameState.gems, GameState.retries_taken])
		GameState.end_run(true)
		return
	GameState.set_phase(GFEnums.RunPhase.MAP)


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


# ---------------------------------------------------------------------------
# Combat → reward bridge (debug)
# ---------------------------------------------------------------------------

func _input(event: InputEvent) -> void:
	if GameState.current_phase != GFEnums.RunPhase.COMBAT and GameState.current_phase != GFEnums.RunPhase.BOSS:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		var k: int = event.keycode
		# C = combat victory (placeholder), X = defeat (placeholder).
		if k == KEY_C:
			print("[run_controller] DEBUG: combat victory by hotkey")
			_award_reward_after_node()
		elif k == KEY_X:
			print("[run_controller] DEBUG: combat defeat by hotkey")
			GameState.take_damage(99)  # lethal


func _award_reward_after_node() -> void:
	# Build a reward offer via RewardGenerator and start it.
	var pool: Array[Card] = RewardGenerator.load_pool([
		"res://data/cards/iron_penitents/",
		"res://data/cards/ash_mourners/",
		"res://data/cards/coven/",
	])
	if pool.is_empty():
		push_warning("[run_controller] reward pool empty — returning to map")
		GameState.set_phase(GFEnums.RunPhase.MAP)
		return

	var rng := RandomNumberGenerator.new()
	rng.seed = GameState.run_seed ^ (GameState.current_node * 4242)
	var warlord_faction: int = _get_active_warlord_faction()
	# generate_offer wraps generate() + RewardOffer.new(). Don't call generate()
	# directly here — that returns Array[Card] and the type-check fails.
	var offer: RewardOffer = RewardGenerator.generate_offer(pool, warlord_faction, rng, 3)

	# GameState.start_reward emits reward_offered which RewardView listens for.
	GameState.start_reward(offer)


func _get_active_warlord_faction() -> int:
	# WL-5: resolve via the roster DB (was a hardcoded match).
	return WarlordDatabase.faction_of(GameState.active_warlord_id)



# ============================================================================
# Retry from game-over screen (Paul, 2026-05-18 — gem economy)
# ============================================================================

func _on_retry_pressed() -> void:
	# Round number = current node's depth + 1 in the linear gauntlet.
	if GameState.current_map_graph == null or not GameState.current_map_graph.nodes.has(GameState.current_node_id):
		push_warning("[run_controller] retry pressed but no current node")
		return
	var cur_node: MapNode = GameState.current_map_graph.nodes[GameState.current_node_id]
	var round_num: int = cur_node.depth + 1
	var ok: bool = GameState.spend_gems_for_retry(round_num)
	if not ok:
		push_warning("[run_controller] retry failed — insufficient gems")
		return
	print("[run_controller] retry purchased for round %d (-%d gems, %d left)" %
			[round_num, GameState.retry_cost_for_round(round_num), GameState.gems])
	# Restore HP and re-fire the same round's combat.
	GameState.base_hp = GameState.max_base_hp
	GameState.hp_changed.emit(GameState.base_hp, GameState.max_base_hp)
	GameState.start_combat(5)
