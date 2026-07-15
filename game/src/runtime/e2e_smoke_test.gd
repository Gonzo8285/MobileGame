extends Node

## End-to-end smoke test for B2.10 — composes every B2.x system.
##
## Walks the full per-run lifecycle once, with assertions at each hand-off:
##
##   start_run                  (GameState — B2.4)
##     → enter_chapter(1)       (MapGenerator + GameState — B2.9)
##     → choose_next_node       (graph-aware nav — B2.9)
##     → setup + start combat   (Combat orchestrator — B2.5)
##     → drive turn engine      (TurnEngine + Lane — B2.7)
##     → combat_ended(true)     (victory path)
##     → reward offer           (RewardGenerator + RewardOffer — B2.8)
##     → offer.choose           (deck grows by 1)
##     → choose_next_node       (advance off the start tile)
##     → setup + start combat   (second fight)
##     → arrange defeat         (base_hp low + killer wave)
##     → combat_ended(false)    (defeat path)
##     → run_ended(false)       (GameState.take_damage → end_run on lethal)
##     → phase == GAME_OVER
##
## What this test is for: each prior B2.x test verified one system in isolation.
## This one verifies the systems COMPOSE — that signals propagate the right way,
## that GameState bookkeeping survives a phase transition, that the reward
## handshake doesn't desync the deck, and that lethal damage during the second
## combat collapses out to the run-end terminal phase.
##
## Headless: lanes / combat are Node2D but no rendering is required. Paul runs
## this in the Godot editor (F5 → main.gd dev-test runner) and watches for the
## `[e2e_smoke_test] PASS` line. "Playable in editor" per the backlog item.
##
## NOT in scope (covered elsewhere or deferred):
##   - UI scene composition (map_view.tscn, reward_view.tscn) — UI defer pattern
##   - shop / event / shrine / rest / boss nodes — only COMBAT exercised here
##   - chapter-2 generation — placeholder generator clones chapter 1
##   - per-card visual / drag-drop — exercised by card_play_test.gd (B2.6)

const POOL_ROOTS: Array = [
	"res://data/cards/iron_penitents/",
	"res://data/cards/ash_mourners/",
	"res://data/cards/coven/",
]
const ENEMIES_DIR: String = "res://data/enemies/"
const WARLORD_ID: StringName = &"vyrrun_e2e"


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[e2e_smoke_test] PASS")
	else:
		printerr("[e2e_smoke_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors: int = 0

	# ---- Preflight: load assets ------------------------------------------
	var pool: Array[Card] = RewardGenerator.load_pool(POOL_ROOTS)
	if pool.size() < 10:
		printerr("FATAL: pool too thin (%d) — reward step will be flaky" % pool.size())
		return 1
	var enemies: Array[Enemy] = _load_enemies(ENEMIES_DIR)
	if enemies.size() < 1:
		printerr("FATAL: no enemies under %s" % ENEMIES_DIR)
		return 1

	# A modest starter pool — first 12 cards of the loaded pool. Real game uses
	# the active Warlord's starter deck; the e2e contract doesn't care about
	# composition, only that the deck round-trips through start_combat reshuffle.
	var starter_pool: Array[Card] = []
	for i in range(min(12, pool.size())):
		starter_pool.append(pool[i])

	# Capture run-level signals so we can assert end-state without polling.
	var run_started_args: Array = []
	var run_ended_args: Array = []
	var phase_log: Array[int] = []
	var chapter_started_args: Array = []
	var map_node_entered_args: Array = []
	var reward_offered_args: Array = []
	var reward_resolved_args: Array = []
	GameState.run_started.connect(func(s, w): run_started_args.append([s, w]))
	GameState.run_ended.connect(func(v): run_ended_args.append(v))
	GameState.phase_changed.connect(func(_old, n): phase_log.append(n))
	GameState.chapter_started.connect(func(c, g): chapter_started_args.append([c, g]))
	GameState.map_node_entered.connect(func(n): map_node_entered_args.append(n))
	GameState.reward_offered.connect(func(o): reward_offered_args.append(o))
	GameState.reward_resolved.connect(func(c): reward_resolved_args.append(c))

	# ===== START RUN ======================================================
	GameState.start_run(starter_pool, WARLORD_ID, 4242)
	if run_started_args.size() != 1:
		errors += 1; printerr("AS1: expected 1 run_started emit, got %d" % run_started_args.size())
	if GameState.deck == null or GameState.deck.size() != starter_pool.size():
		errors += 1; printerr("AS2: deck not built — size %d, expected %d" %
				[0 if GameState.deck == null else GameState.deck.size(), starter_pool.size()])
	if GameState.base_hp != 30:
		errors += 1; printerr("AS3: fresh run should be full HP, got %d" % GameState.base_hp)

	# ===== ENTER CHAPTER ==================================================
	var graph: MapGraph = GameState.enter_chapter(1)
	if graph == null or graph.size() < 10 or not graph.validate().is_empty():
		errors += 1; printerr("AS4: chapter 1 branching graph invalid (size %d)" %
				(0 if graph == null else graph.size()))
	if chapter_started_args.size() != 1:
		errors += 1; printerr("AS5: expected 1 chapter_started emit, got %d" % chapter_started_args.size())
	if GameState.current_node_id != graph.start_id:
		errors += 1; printerr("AS6: player not seated at start tile, got %s" % GameState.current_node_id)

	# ===== COMBAT 1 — VICTORY =============================================
	# Start node is always COMBAT per map_generator. Run a lonely wave so the
	# test can dispatch the single enemy and the wave drains cleanly.
	var lonely_wave: Wave = _make_lonely_wave(enemies)
	var combat1 := preload("res://src/runtime/combat.gd").new()
	add_child(combat1)
	combat1.setup(lonely_wave, 6)
	var combat1_ended: Array = []
	combat1.combat_ended.connect(func(v): combat1_ended.append(v))
	combat1.start()  # → GameState.start_combat(5) → turn 1 → spawn

	if GameState.current_phase != GFEnums.RunPhase.COMBAT:
		errors += 1; printerr("AS7: should be in COMBAT phase after combat.start()")
	# Hand should be populated with the opening 5 (or whatever the deck could supply).
	if GameState.hand.size() == 0:
		errors += 1; printerr("AS8: opening hand empty after start_combat")

	# Kill the single enemy outright — simulates a B2.7 friendly-attack resolve.
	if combat1.lanes[0].enemies.size() > 0:
		var victim: EnemyInstance = combat1.lanes[0].enemies[0]
		victim.take_damage(victim.current_hp + 1)
		combat1.lanes[0].cull_dead()
	# Drive turns past the wave length so spawner.is_complete() fires.
	var ticks: int = 0
	while not combat1.has_ended() and ticks < lonely_wave.turn_count + 4:
		GameState.next_turn()
		ticks += 1
	if not combat1.has_ended():
		errors += 1; printerr("AS9: combat 1 didn't end in %d ticks" % ticks)
	if combat1_ended.size() != 1 or combat1_ended[0] != true:
		errors += 1; printerr("AS10: expected combat_ended(true), got %s" % str(combat1_ended))
	combat1.cleanup()
	combat1.queue_free()

	# ===== REWARD =========================================================
	# Build an offer post-victory. In real gameplay the map controller does this;
	# the e2e contract only needs the handshake to round-trip.
	var deck_before: int = GameState.deck.size()
	var reward_rng := RandomNumberGenerator.new()
	reward_rng.seed = GameState.run_seed ^ 0xC0FFEE
	var offer: RewardOffer = RewardGenerator.generate_offer(
			pool, GFEnums.Faction.IRON_PENITENTS, reward_rng, 3)
	if offer == null or offer.cards.size() == 0:
		errors += 1; printerr("AS11: empty reward offer")
		return errors  # nothing further to assert without a card
	GameState.start_reward(offer)
	if reward_offered_args.size() != 1:
		errors += 1; printerr("AS12: expected 1 reward_offered emit, got %d" % reward_offered_args.size())
	if GameState.current_phase != GFEnums.RunPhase.REWARD:
		errors += 1; printerr("AS13: phase should be REWARD after start_reward")

	# Pick the first card.
	var picked: Card = offer.choose(0)
	if picked == null:
		errors += 1; printerr("AS14: offer.choose(0) returned null")
	if reward_resolved_args.size() != 1:
		errors += 1; printerr("AS15: expected 1 reward_resolved emit, got %d" % reward_resolved_args.size())
	if GameState.deck.size() != deck_before + 1:
		errors += 1; printerr("AS16: deck grew by %d (expected +1)" %
				(GameState.deck.size() - deck_before))

	# ===== ADVANCE MAP ====================================================
	# Pick the left child of the start tile to advance into the next encounter.
	var start_node: MapNode = graph.get_node_by_id(graph.start_id)
	if start_node.children.is_empty():
		errors += 1; printerr("AS17: start node has no children — graph malformed")
		return errors
	var next_id: StringName = start_node.children[0]
	var ok: bool = GameState.choose_next_node(next_id)
	if not ok:
		errors += 1; printerr("AS18: choose_next_node(%s) rejected — expected legal child jump" % next_id)
	if map_node_entered_args.size() != 1:
		errors += 1; printerr("AS19: expected 1 map_node_entered emit, got %d" % map_node_entered_args.size())
	if GameState.current_node_id != next_id:
		errors += 1; printerr("AS20: current_node_id didn't advance — got %s" % GameState.current_node_id)

	# ===== COMBAT 2 — DEFEAT ==============================================
	# Force a defeat: shrink base HP so the first enemy advance lethals it.
	# We don't care whether the second tile is COMBAT or EVENT in this seed —
	# the contract being tested is "lethal damage anywhere in the run ends the
	# run via GameState.end_run(false)", which is exercised by routing a wave
	# through a base with HP=2. (A run-victory variant — boss defeated, run_ended(true)
	# — is left to a future test once the boss node has real wave content.)
	GameState.max_base_hp = 2
	GameState.base_hp = 2
	var killer_wave: Wave = _make_killer_wave(enemies)
	var combat2 := preload("res://src/runtime/combat.gd").new()
	add_child(combat2)
	combat2.setup(killer_wave, 2)  # short lane so the enemy reaches base fast
	var combat2_ended: Array = []
	combat2.combat_ended.connect(func(v): combat2_ended.append(v))
	combat2.start()
	var ticks2: int = 0
	while not combat2.has_ended() and ticks2 < 10:
		GameState.next_turn()
		ticks2 += 1
	if not combat2.has_ended():
		errors += 1; printerr("AS21: combat 2 didn't end in 10 ticks")
	if combat2_ended.size() != 1 or combat2_ended[0] != false:
		errors += 1; printerr("AS22: expected combat_ended(false), got %s" % str(combat2_ended))
	# GameState.take_damage hit zero → end_run(false) fired.
	if run_ended_args.size() != 1:
		errors += 1; printerr("AS23: expected 1 run_ended emit, got %d" % run_ended_args.size())
	elif run_ended_args[0] != false:
		errors += 1; printerr("AS24: expected run_ended(false), got run_ended(%s)" % str(run_ended_args[0]))
	if GameState.current_phase != GFEnums.RunPhase.GAME_OVER:
		errors += 1; printerr("AS25: phase should be GAME_OVER after lethal, got %d" % GameState.current_phase)

	combat2.cleanup()
	combat2.queue_free()
	# Restore default HP for any subsequent tests sharing the autoload.
	GameState.max_base_hp = 30

	# ===== PHASE LOG SANITY ==============================================
	# We should have transitioned MAP → COMBAT → REWARD → MAP → COMBAT → GAME_OVER
	# at minimum. We don't assert the exact sequence (re-entry to the same phase
	# is a no-op per set_phase) but we DO assert REWARD and GAME_OVER both
	# appeared in the log — proves the phase signals fired across the handshake.
	var saw_reward: bool = false
	var saw_game_over: bool = false
	for p in phase_log:
		if p == GFEnums.RunPhase.REWARD: saw_reward = true
		if p == GFEnums.RunPhase.GAME_OVER: saw_game_over = true
	if not saw_reward:
		errors += 1; printerr("AS26: phase log missing REWARD transition")
	if not saw_game_over:
		errors += 1; printerr("AS27: phase log missing GAME_OVER transition")

	return errors


# ============================================================================
# Helpers — same shape as combat_test.gd's wave builders
# ============================================================================

func _load_enemies(dir_path: String) -> Array[Enemy]:
	var out: Array[Enemy] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		printerr("[e2e_smoke_test] cannot open %s" % dir_path)
		return out
	dir.list_dir_begin()
	var f := dir.get_next()
	while f != "":
		if f.ends_with(".tres"):
			var res := load(dir_path + f) as Enemy
			if res != null:
				out.append(res)
		f = dir.get_next()
	dir.list_dir_end()
	out.sort_custom(func(a, b): return String(a.id) < String(b.id))
	return out


## Tiny wave: 1 enemy in lane 0 on turn 1, 3-turn wave length. Easy victory.
func _make_lonely_wave(enemies: Array[Enemy]) -> Wave:
	var w := Wave.new()
	w.id = &"e2e_lonely"
	w.display_name = "E2E — Lonely"
	w.turn_count = 3
	var entry := WaveSpawnEntry.new()
	entry.on_turn = 1
	entry.lane = 0
	entry.enemy = enemies[0]
	var entries: Array[WaveSpawnEntry] = [entry]
	w.spawns = entries
	return w


## Single overtuned enemy that walks straight into the player base — used to
## confirm the lethal-damage path ends the run. Picks the highest-damage
## enemy on file (same pattern combat_test.gd uses for the defeat case).
func _make_killer_wave(enemies: Array[Enemy]) -> Wave:
	var w := Wave.new()
	w.id = &"e2e_killer"
	w.display_name = "E2E — Killer"
	w.turn_count = 5
	var hardest: Enemy = enemies[0]
	for e in enemies:
		if e.base_strike_damage() > hardest.base_strike_damage():
			hardest = e
	var entry := WaveSpawnEntry.new()
	entry.on_turn = 1
	entry.lane = 1
	entry.enemy = hardest
	var entries: Array[WaveSpawnEntry] = [entry]
	w.spawns = entries
	return w
