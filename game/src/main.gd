extends Node2D

## Main entry point — The Curse of Gallowfell
##
## Phase 3 B1 hello-world + B2.3 dev-mode smoke test. Replace with the actual
## game bootstrap in B2.4 (GameState autoload) / B2.5 (combat scene scaffold).

## Set false to skip dev-mode smoke tests on launch (e.g. when wiring later
## scenes that don't want test output cluttering the console).
const RUN_DEV_TESTS: bool = true


func _ready() -> void:
	print("=== The Curse of Gallowfell ===")
	print("Engine: Godot 4 — hello world confirmed")

	if RUN_DEV_TESTS:
		_run_dev_test("res://src/runtime/card_zones_test.gd")    # B2.3
		_run_dev_test("res://src/runtime/game_state_test.gd")    # B2.4
		_run_dev_test("res://src/runtime/card_database_test.gd") # DB-1
		_run_dev_test("res://src/runtime/deck_builder_test.gd")  # DB-6
		_run_dev_test("res://src/runtime/combat_test.gd")        # B2.5
		_run_dev_test("res://src/runtime/card_play_test.gd")     # B2.6
		_run_dev_test("res://src/runtime/turn_engine_test.gd")   # B2.7
		_run_dev_test("res://src/runtime/reward_test.gd")        # B2.8
		_run_dev_test("res://src/runtime/warlord_test.gd")       # W5
		_run_dev_test("res://src/runtime/warlord_select_test.gd") # WL-6
		_run_dev_test("res://src/runtime/map_test.gd")           # B2.9
		_run_dev_test("res://src/runtime/e2e_smoke_test.gd")     # B2.10
		_run_dev_test("res://src/runtime/deck_builder_flow_test.gd")  # DB-5


func _run_dev_test(path: String) -> void:
	print("[main] loading %s ..." % path)
	var test_script: GDScript = load(path)
	if test_script == null:
		print("[main] FAILED TO LOAD %s — check Errors tab + Debugger panel for the parse error" % path)
		return
	print("[main] %s loaded OK, instantiating ..." % path)
	var test := test_script.new() as Node
	if test == null:
		print("[main] FAILED TO INSTANTIATE %s as Node" % path)
		return
	add_child(test)  # _ready() on the test node will fire the suite
