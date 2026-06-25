extends Node

## Smoke test for GameState autoload (B2.4).
##
## Exercises the run lifecycle: start_run → start_combat → spend/gain mana →
## next_turn → take_damage → heal → run-end on lethal damage. Verifies all
## the right signals fire and counters land on the expected values.
##
## Wired into main.gd alongside the B2.3 zones test. Attach as a Node child
## and `_ready()` runs the suite. PASS = 0 errors.

const POOL_DIR: String = "res://data/cards/iron_penitents/"


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[game_state_test] PASS")
	else:
		printerr("[game_state_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors := 0
	var pool: Array[Card] = _load_pool(POOL_DIR)
	if pool.is_empty():
		printerr("FATAL: no cards loaded from %s" % POOL_DIR)
		return 1

	# Track signal fires so we can assert they actually emit.
	var signal_log: Array[String] = []
	GameState.run_started.connect(func(s, w): signal_log.append("run_started:%d:%s" % [s, w]))
	GameState.phase_changed.connect(func(o, n): signal_log.append("phase_changed:%d->%d" % [o, n]))
	GameState.turn_started.connect(func(t): signal_log.append("turn_started:%d" % t))
	GameState.turn_ended.connect(func(t): signal_log.append("turn_ended:%d" % t))
	GameState.mana_changed.connect(func(m, c): signal_log.append("mana_changed:%d/%d" % [m, c]))
	GameState.hp_changed.connect(func(h, m): signal_log.append("hp_changed:%d/%d" % [h, m]))
	GameState.run_ended.connect(func(v): signal_log.append("run_ended:%s" % str(v)))

	# ---- Run start ------------------------------------------------------
	GameState.start_run(pool, &"warlord_test", 4242)
	errors += _expect_eq("run_seed", GameState.run_seed, 4242)
	errors += _expect_eq("active_warlord_id", GameState.active_warlord_id, &"warlord_test")
	errors += _expect_eq("phase after start_run", GameState.current_phase, GFEnums.RunPhase.MAP)
	errors += _expect_eq("deck built from pool", GameState.deck.size(), pool.size())
	errors += _expect_eq("hand fresh", GameState.hand.size(), 0)
	errors += _expect_eq("base_hp at full", GameState.base_hp, GameState.max_base_hp)

	# ---- Combat start ---------------------------------------------------
	GameState.start_combat()
	errors += _expect_eq("phase after start_combat", GameState.current_phase, GFEnums.RunPhase.COMBAT)
	errors += _expect_eq("turn after start_combat", GameState.turn, 1)
	errors += _expect_eq("mana at turn start", GameState.mana, GameState.max_mana)

	# ---- Mana spend / gain ---------------------------------------------
	var spent := GameState.spend_mana(2)
	errors += _expect_eq("spend_mana(2) returns true", spent, true)
	errors += _expect_eq("mana after spending 2", GameState.mana, GameState.max_mana - 2)

	var overspent := GameState.spend_mana(99)
	errors += _expect_eq("spend_mana(99) returns false", overspent, false)
	errors += _expect_eq("mana unchanged after overspend", GameState.mana, GameState.max_mana - 2)

	GameState.gain_mana(1)
	errors += _expect_eq("mana after gain_mana(1)", GameState.mana, GameState.max_mana - 1)

	GameState.gain_mana(99)  # cap test
	errors += _expect_eq("mana capped at max+overflow",
			GameState.mana, GameState.max_mana + GameState.MANA_OVERFLOW_CAP)

	# ---- Turn advance ---------------------------------------------------
	GameState.next_turn()
	errors += _expect_eq("turn after next_turn", GameState.turn, 2)
	errors += _expect_eq("mana refilled at new turn", GameState.mana, GameState.max_mana)

	# ---- HP take_damage / heal ------------------------------------------
	var dmg_dealt := GameState.take_damage(10)
	errors += _expect_eq("take_damage(10) returns 10", dmg_dealt, 10)
	errors += _expect_eq("hp after damage 10", GameState.base_hp, GameState.max_base_hp - 10)

	var healed := GameState.heal(3)
	errors += _expect_eq("heal(3) returns 3", healed, 3)
	errors += _expect_eq("hp after heal 3", GameState.base_hp, GameState.max_base_hp - 7)

	var overheal := GameState.heal(99)  # cap test
	errors += _expect_eq("heal capped at max_hp", GameState.base_hp, GameState.max_base_hp)
	errors += _expect_eq("overheal returns clamped delta", overheal, 7)

	# ---- Lethal damage triggers run_ended -------------------------------
	var pre_log_size := signal_log.size()
	GameState.take_damage(GameState.max_base_hp + 5)
	errors += _expect_eq("hp clamped to 0 on lethal", GameState.base_hp, 0)
	errors += _expect_eq("phase = GAME_OVER on death",
			GameState.current_phase, GFEnums.RunPhase.GAME_OVER)
	# Verify run_ended fired
	var found_run_ended: bool = false
	for i in range(pre_log_size, signal_log.size()):
		if signal_log[i].begins_with("run_ended:"):
			found_run_ended = true
			break
	errors += _expect_eq("run_ended signal fired on death", found_run_ended, true)

	# ---- Signal emission audit (grand total) ---------------------------
	# At minimum we should have seen: run_started, several phase_changed,
	# at least 2 turn_started, at least 1 turn_ended, several mana_changed,
	# several hp_changed, 1 run_ended.
	errors += _expect_at_least("run_started fired", _count_prefix(signal_log, "run_started:"), 1)
	errors += _expect_at_least("phase_changed fired",
			_count_prefix(signal_log, "phase_changed:"), 2)  # MAP→COMBAT, COMBAT→GAME_OVER
	errors += _expect_at_least("turn_started fired ≥2",
			_count_prefix(signal_log, "turn_started:"), 2)
	errors += _expect_at_least("turn_ended fired ≥1",
			_count_prefix(signal_log, "turn_ended:"), 1)
	errors += _expect_at_least("hp_changed fired ≥3",
			_count_prefix(signal_log, "hp_changed:"), 3)

	# ---- DB-2: deck persistence + start_run_from_ids -------------------
	# set_last_deck stores a defensive copy (mutating the source must not bleed).
	var src_ids: Array[StringName] = [&"DB2_A", &"DB2_B"]
	GameState.set_last_deck(src_ids)
	src_ids.append(&"DB2_C")
	errors += _expect_eq("set_last_deck stored a copy", GameState.last_deck_ids.size(), 2)

	# start_run_from_ids resolves real ids -> a deck of matching size via CardDatabase.
	var db2_ids: Array[StringName] = []
	for c in CardDatabase.all_cards():
		db2_ids.append(c.id)
		if db2_ids.size() >= 5:
			break
	GameState.start_run_from_ids(db2_ids, &"db2_warlord", 777)
	errors += _expect_eq("start_run_from_ids built deck", GameState.deck.size(), db2_ids.size())
	errors += _expect_eq("start_run_from_ids set warlord", GameState.active_warlord_id, &"db2_warlord")
	errors += _expect_eq("start_run_from_ids set seed", GameState.run_seed, 777)

	print("Signals fired (%d total): %s" % [signal_log.size(), str(signal_log)])
	return errors


# ---------- helpers ---------------------------------------------------------

func _load_pool(dir_path: String) -> Array[Card]:
	var pool: Array[Card] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return pool
	dir.list_dir_begin()
	var fname := dir.get_next()
	while fname != "":
		if fname.ends_with(".tres"):
			var c: Card = load(dir_path + fname)
			if c != null:
				pool.append(c)
		fname = dir.get_next()
	dir.list_dir_end()
	return pool


func _count_prefix(log: Array[String], prefix: String) -> int:
	var count := 0
	for entry in log:
		if entry.begins_with(prefix):
			count += 1
	return count


func _expect_eq(label: String, actual, expected) -> int:
	if actual == expected:
		return 0
	printerr("FAIL %s — expected %s got %s" % [label, expected, actual])
	return 1


func _expect_at_least(label: String, actual: int, minimum: int) -> int:
	if actual >= minimum:
		return 0
	printerr("FAIL %s — expected ≥%d got %d" % [label, minimum, actual])
	return 1
