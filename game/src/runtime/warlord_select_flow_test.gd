extends Node
## WL-4 — Title → Warlord-Select → Deck-Builder wiring (headless integration).
##
## Drives the scene router through RunController: Title "Play" opens Warlord
## Select; selecting a Warlord opens the deck-builder scoped to that faction;
## run_controller resolves the same faction via WarlordDatabase (WL-5); Back
## from the builder returns to Warlord Select. PASS = 0 errors.


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[warlord_select_flow_test] PASS")
	else:
		printerr("[warlord_select_flow_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors := 0

	var ctrl := (load("res://scenes/run_controller.tscn") as PackedScene).instantiate() as RunController
	add_child(ctrl)  # boots to Title

	# Title "Play" → Warlord Select.
	GameState.request_warlord_select()
	if not (ctrl._active_child is WarlordSelect):
		printerr("Play did not open WarlordSelect (got %s)" %
				("null" if ctrl._active_child == null else ctrl._active_child.get_class()))
		ctrl.queue_free()
		return errors + 1

	# Select Sieren (Ash-Mourners) → deck-builder scoped to that faction.
	GameState.active_warlord_id = &"sieren"
	GameState.request_deck_build(&"sieren", GFEnums.Faction.ASH_MOURNERS)
	if not (ctrl._active_child is DeckBuilder):
		errors += 1; printerr("Select did not open DeckBuilder")
	else:
		var db := ctrl._active_child as DeckBuilder
		if db._faction != GFEnums.Faction.ASH_MOURNERS:
			errors += 1; printerr("deck-builder faction %d, expected ASH_MOURNERS" % db._faction)

	# WL-5: run_controller resolves the same faction via WarlordDatabase.
	if ctrl._get_active_warlord_faction() != GFEnums.Faction.ASH_MOURNERS:
		errors += 1; printerr("run_controller faction != ASH_MOURNERS via WarlordDatabase")

	# Back from the builder → Warlord Select (not change_scene_to_file).
	if ctrl._active_child is DeckBuilder:
		ctrl._active_child._on_back()
		if not (ctrl._active_child is WarlordSelect):
			errors += 1; printerr("deck-builder Back did not return to WarlordSelect")

	ctrl.queue_free()
	return errors
