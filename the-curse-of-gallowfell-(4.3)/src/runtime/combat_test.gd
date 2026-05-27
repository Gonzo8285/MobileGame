extends Node

## Smoke test for the B2.5 combat scaffold.
##
## Three fights are exercised, all headless (no scene-tree visuals required —
## though Combat is a Node2D, the test attaches it as a child so its _ready
## fires; no rendering needed for the assertions):
##
##   FIGHT 1 — basic spawn & advance: load the act1_combat1.tres wave, drive
##             10 turns by manually calling GameState.next_turn(), confirm
##             enemies spawn in the right lane / on the right turn / advance
##             toward the base / route damage through GameState.take_damage.
##
##   FIGHT 2 — defeat path: tiny wave with one over-tuned enemy; let it walk
##             to the base, confirm Combat fires combat_ended(false) and
##             GameState.base_hp hits 0.
##
##   FIGHT 3 — victory path: tiny wave with one enemy; manually deal lethal
##             damage to it via EnemyInstance.take_damage and Lane.cull_dead;
##             advance the turn count past wave.turn_count; confirm Combat
##             fires combat_ended(true).
##
## PASS = 0 errors. Wired into main.gd alongside the other dev tests.

const ENEMIES_DIR: String = "res://data/enemies/"
const WAVE_PATH: String = "res://data/waves/act1_combat1.tres"
const WARLORD_ID: StringName = &"vyrrun_test"


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[combat_test] PASS")
	else:
		printerr("[combat_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors: int = 0

	# ---- Resource loads ---------------------------------------------------
	var enemies := _load_enemies(ENEMIES_DIR)
	if enemies.size() < 5:
		printerr("FATAL: expected ≥5 enemies under %s, got %d" % [ENEMIES_DIR, enemies.size()])
		return 1
	var wave: Wave = load(WAVE_PATH) as Wave
	if wave == null:
		printerr("FATAL: could not load wave at %s" % WAVE_PATH)
		return 1
	if wave.spawns.size() < 1:
		printerr("FATAL: wave %s has no spawn entries" % WAVE_PATH)
		return 1
	print("[combat_test] loaded %d enemies + wave '%s' (%d spawns, %d turns)" % [
		enemies.size(), wave.id, wave.spawns.size(), wave.turn_count
	])

	# A throwaway starter pool so GameState.start_run is happy.
	var starter_pool: Array[Card] = []

	# ===== FIGHT 1 — basic spawn & advance =================================
	GameState.start_run(starter_pool, WARLORD_ID, 1234)
	var combat1 := preload("res://src/runtime/combat.gd").new()
	add_child(combat1)
	combat1.setup(wave)
	combat1.start()  # will GameState.start_combat() → turn 1, fires first spawn

	if combat1.lanes.size() != 3:
		printerr("AS1: expected 3 lanes, got %d" % combat1.lanes.size())
		errors += 1
	if combat1.spawner == null:
		printerr("AS2: spawner not initialised")
		errors += 1
	# After turn 1 fired, lane 1 should have its turn-1 spawn (per act1_combat1).
	if combat1.lanes[1].enemy_count() != 1:
		printerr("AS3: lane 1 should have 1 enemy after turn 1 fires, got %d" %
				combat1.lanes[1].enemy_count())
		errors += 1

	# Drive turns 2..10 manually and watch the wave play out.
	while not combat1.has_ended() and GameState.turn < wave.turn_count:
		GameState.next_turn()

	# All scheduled spawns should have fired by turn 10.
	if not combat1.spawner.all_spawns_fired():
		printerr("AS4: spawner should have fired all entries by turn %d" % GameState.turn)
		errors += 1
	# Base HP should have taken at least *some* damage (E1 spawned turn 1 hits
	# tile 0 by turn 7, attack=2 → base_hp ≤ 28).
	if GameState.base_hp >= 30:
		printerr("AS5: expected some base damage by end of fight 1, got hp=%d" % GameState.base_hp)
		errors += 1
	combat1.cleanup()
	combat1.queue_free()

	# ===== FIGHT 2 — defeat path ==========================================
	GameState.start_run(starter_pool, WARLORD_ID, 5678)
	# Drop base HP low so we can exercise lethal-damage in a single hit.
	GameState.max_base_hp = 4
	GameState.base_hp = 4
	var killer_wave: Wave = _make_killer_wave(enemies)
	var combat2 := preload("res://src/runtime/combat.gd").new()
	add_child(combat2)
	combat2.setup(killer_wave, 2)  # 2-tile lanes — enemy spawns at tile 2, hits base on turn 3
	var combat2_ended_args: Array = []
	combat2.combat_ended.connect(func(v): combat2_ended_args.append(v))
	combat2.start()
	# Spawned on turn 1 at tile 2, advances 1 tile each end-of-turn → hits base
	# on the end-of-turn-2 advance. Drive turns until combat ends or 10 ticks.
	var ticks: int = 0
	while not combat2.has_ended() and ticks < 10:
		GameState.next_turn()
		ticks += 1
	if not combat2.has_ended():
		printerr("AS6: combat 2 didn't end within 10 turns")
		errors += 1
	if combat2_ended_args.size() != 1:
		printerr("AS7: expected exactly 1 combat_ended emit, got %d" % combat2_ended_args.size())
		errors += 1
	elif combat2_ended_args[0] != false:
		printerr("AS8: expected combat_ended(false) for defeat, got combat_ended(%s)" %
				str(combat2_ended_args[0]))
		errors += 1
	if GameState.base_hp > 0:
		printerr("AS9: expected base_hp=0 on defeat, got %d" % GameState.base_hp)
		errors += 1
	# Restore default max HP for the next fight.
	GameState.max_base_hp = 30
	combat2.cleanup()
	combat2.queue_free()

	# ===== FIGHT 3 — victory path =========================================
	GameState.start_run(starter_pool, WARLORD_ID, 9012)
	var lonely_wave: Wave = _make_lonely_wave(enemies)
	var combat3 := preload("res://src/runtime/combat.gd").new()
	add_child(combat3)
	combat3.setup(lonely_wave, 6)
	var combat3_ended_args: Array = []
	combat3.combat_ended.connect(func(v): combat3_ended_args.append(v))
	combat3.start()
	# After start, turn 1 should have spawned the lonely enemy in lane 0.
	if combat3.lanes[0].enemy_count() != 1:
		printerr("AS10: lonely wave should have spawned 1 enemy in lane 0, got %d" %
				combat3.lanes[0].enemy_count())
		errors += 1
	# Manually kill the enemy — simulating a B2.7 attack.
	if combat3.lanes[0].enemies.size() > 0:
		var victim: EnemyInstance = combat3.lanes[0].enemies[0]
		victim.take_damage(victim.current_hp + 1)
		combat3.lanes[0].cull_dead()
	# Now fast-forward past the wave.turn_count so is_complete fires.
	var ticks3: int = 0
	while not combat3.has_ended() and ticks3 < lonely_wave.turn_count + 4:
		GameState.next_turn()
		ticks3 += 1
	if not combat3.has_ended():
		printerr("AS11: combat 3 didn't reach victory inside %d ticks" % ticks3)
		errors += 1
	if combat3_ended_args.size() != 1:
		printerr("AS12: combat 3 expected 1 combat_ended emit, got %d" % combat3_ended_args.size())
		errors += 1
	elif combat3_ended_args[0] != true:
		printerr("AS13: expected combat_ended(true) for victory, got combat_ended(%s)" %
				str(combat3_ended_args[0]))
		errors += 1
	if GameState.base_hp != 30:
		printerr("AS14: expected full base HP on victory path, got %d" % GameState.base_hp)
		errors += 1
	combat3.cleanup()
	combat3.queue_free()

	return errors


# ---------- Helpers --------------------------------------------------------

func _load_enemies(dir_path: String) -> Array[Enemy]:
	var out: Array[Enemy] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		printerr("[combat_test] cannot open %s" % dir_path)
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


## Tiny wave with a single overtuned enemy used for the defeat-path test.
func _make_killer_wave(enemies: Array[Enemy]) -> Wave:
	var w := Wave.new()
	w.id = &"test_killer"
	w.display_name = "Test — Killer"
	w.turn_count = 4
	# Pick the highest-damage enemy on file for a guaranteed one-shot of 4 HP.
	var hardest: Enemy = enemies[0]
	for e in enemies:
		if e.base_strike_damage() > hardest.base_strike_damage():
			hardest = e
	var entry := WaveSpawnEntry.new()
	entry.on_turn = 1
	entry.lane = 0
	entry.enemy = hardest
	var entries: Array[WaveSpawnEntry] = [entry]
	w.spawns = entries
	return w


## Single-enemy wave used to confirm the victory path. Turn count is short so
## the test loop terminates quickly once we kill the enemy.
func _make_lonely_wave(enemies: Array[Enemy]) -> Wave:
	var w := Wave.new()
	w.id = &"test_lonely"
	w.display_name = "Test — Lonely"
	w.turn_count = 3
	var entry := WaveSpawnEntry.new()
	entry.on_turn = 1
	entry.lane = 0
	entry.enemy = enemies[0]
	var entries: Array[WaveSpawnEntry] = [entry]
	w.spawns = entries
	return w
