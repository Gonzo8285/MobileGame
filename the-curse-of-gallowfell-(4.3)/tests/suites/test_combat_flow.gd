extends GFTest

## Integration: drive real waves through the Combat orchestrator (in the scene
## tree so its _ready + lane signals fire) and assert spawn / advance / base
## damage / victory / defeat wiring. Combat has no class_name, so we reference
## it via a preloaded-script constant (the codebase's own pattern).

const CombatScript := preload("res://src/runtime/combat.gd")

var _combat: CombatScript = null

func before_each() -> void:
	var empty: Array[Card] = []
	GameState.start_run(empty, &"test_warlord", 999)

func after_each() -> void:
	if _combat != null:
		_combat.cleanup()
		_combat.queue_free()
		_combat = null

func _new_combat(w: Wave) -> CombatScript:
	var c: CombatScript = CombatScript.new()
	host.add_child(c)          # fires _ready → default lanes
	c.setup(w)                 # rebuild lanes + spawner for this wave
	_combat = c
	return c

func test_enemy_spawns_advances_and_hits_base() -> void:
	var e: Enemy = GFFactory.enemy(&"walker", 6, 3, 1)
	var spawns: Array[WaveSpawnEntry] = [GFFactory.spawn_entry(1, 0, e)]
	var w: Wave = GFFactory.wave(&"w_adv", 8, spawns)
	var c: CombatScript = _new_combat(w)
	c.start()   # start_combat → turn 1 → spawn
	assert_gt(c.total_enemy_count(), 0, "enemy spawned on turn 1")
	for _i: int in range(12):
		GameState.next_turn()
	assert_lt(GameState.base_hp, GameState.max_base_hp, "undefended enemy damaged the base")

func test_victory_when_wave_done_and_lanes_clear() -> void:
	var no_spawns: Array[WaveSpawnEntry] = []
	var w: Wave = GFFactory.wave(&"w_empty", 2, no_spawns)
	var c: CombatScript = _new_combat(w)
	var results: Array[bool] = []
	c.combat_ended.connect(func(v: bool) -> void: results.append(v))
	c.start()
	for _i: int in range(4):
		GameState.next_turn()
	assert_not_empty(results, "combat_ended fired")
	assert_true(results[0], "empty wave that elapses = victory")

func test_defeat_when_base_dies() -> void:
	var brute: Enemy = GFFactory.enemy(&"brute", 6, 5, 2)
	var spawns: Array[WaveSpawnEntry] = [GFFactory.spawn_entry(1, 0, brute)]
	var w: Wave = GFFactory.wave(&"w_kill", 10, spawns)
	var c: CombatScript = _new_combat(w)
	var results: Array[bool] = []
	c.combat_ended.connect(func(v: bool) -> void: results.append(v))
	c.start()
	GameState.base_hp = 3   # fragile base; one strike ends it
	for _i: int in range(12):
		if c.has_ended():
			break
		GameState.next_turn()
	assert_eq(GameState.base_hp, 0, "base reduced to 0")
	assert_not_empty(results, "combat_ended fired")
	assert_false(results[0], "base death = defeat")
