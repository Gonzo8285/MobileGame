extends Node
## CO-6 — Collection/Codex (headless). Asserts CardDatabase accessors are
## self-consistent and the Collection screen builds + opens a detail overlay
## without error. PASS = 0 errors.


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[collection_test] PASS")
	else:
		printerr("[collection_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors := 0

	# all_cards() == sum of per-faction counts.
	var total := CardDatabase.all_cards().size()
	var sum := 0
	for n in CardDatabase.counts_by_faction().values():
		sum += int(n)
	if total != sum:
		errors += 1; printerr("all_cards (%d) != sum of counts_by_faction (%d)" % [total, sum])
	if total < 200:
		errors += 1; printerr("codex total suspiciously low: %d" % total)

	# by_faction returns a defensive copy.
	var iron := CardDatabase.by_faction(GFEnums.Faction.IRON_PENITENTS)
	var iron_n := iron.size()
	iron.clear()
	if CardDatabase.by_faction(GFEnums.Faction.IRON_PENITENTS).size() != iron_n:
		errors += 1; printerr("by_faction did not return a defensive copy")

	# Screen builds (headless) + opens a detail overlay on a sample card.
	var screen := Collection.new()
	add_child(screen)  # _ready -> builds grid
	var sample: Card = CardDatabase.all_cards()[0] if total > 0 else null
	if sample != null:
		screen._show_detail(sample)
		if screen.get_node_or_null("DetailOverlay") == null:
			errors += 1; printerr("detail overlay did not open for %s" % sample.id)
	screen.queue_free()

	return errors
