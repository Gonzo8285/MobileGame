extends Node

## Headless entry point for the Gallowfell test suite.
## Run:  godot --headless --path . res://tests/test_main.tscn
## Exits 0 if all tests pass, 1 otherwise (CI-gating).

func _ready() -> void:
	var runner := GFTestRunner.new()
	add_child(runner)
	var res: Dictionary = runner.run_all()
	get_tree().quit(0 if res.ok else 1)
