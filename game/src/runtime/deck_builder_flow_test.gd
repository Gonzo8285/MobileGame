extends Node
## DB-5 — Title → Deck-Builder → run wiring (headless integration test).
##
## The headless suite doesn't otherwise exercise the scene flow, so this drives
## it directly: instantiate RunController (the top-level scene), simulate a
## Warlord pick by emitting GameState.deck_build_requested, assert the controller
## swapped to the deck-builder for the right faction, auto-fill + start, then
## assert the run actually begins (phase MAP, 20-card deck, controller off the
## builder).
##
## Wired into main.gd last (it instantiates a full RunController + mutates
## GameState through a complete run-start). PASS = 0 errors.


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[deck_builder_flow_test] PASS")
	else:
		printerr("[deck_builder_flow_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors := 0

	var ctrl := (load("res://scenes/run_controller.tscn") as PackedScene).instantiate() as RunController
	add_child(ctrl)  # _ready: connects GameState signals + swaps to Title

	# Simulate Title's Warlord pick.
	GameState.active_warlord_id = &"vyrrun"
	GameState.request_deck_build(&"vyrrun", GFEnums.Faction.IRON_PENITENTS)

	var child: Node = ctrl._active_child
	if not (child is DeckBuilder):
		printerr("controller did not swap to DeckBuilder (got %s)" %
				("null" if child == null else child.get_class()))
		ctrl.queue_free()
		return errors + 1
	var db := child as DeckBuilder
	if db._faction != GFEnums.Faction.IRON_PENITENTS:
		errors += 1; printerr("deck-builder faction wrong: %d" % db._faction)
	if db._available.is_empty():
		errors += 1; printerr("deck-builder pool empty for Iron Penitents")

	# Build a legal deck and start the run.
	db._autofill()
	if db._deck_count() != DeckBuilder.DECK_SIZE:
		errors += 1; printerr("auto-fill did not reach 20 (%d)" % db._deck_count())
	db._on_start()

	# Run should now be live: phase MAP, deck of 20, controller off the builder.
	if GameState.current_phase != GFEnums.RunPhase.MAP:
		errors += 1; printerr("phase not MAP after start (got %d)" % GameState.current_phase)
	var dsize: int = 0 if GameState.deck == null else GameState.deck.size()
	if dsize != DeckBuilder.DECK_SIZE:
		errors += 1; printerr("run deck size %d, expected 20" % dsize)
	if ctrl._active_child is DeckBuilder:
		errors += 1; printerr("controller still on the deck-builder after start")

	ctrl.queue_free()
	return errors
