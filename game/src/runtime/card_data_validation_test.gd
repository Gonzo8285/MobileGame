extends Node
## AC5 — walk CardDatabase and run Card.validate() on every indexed card.
## Catches schema drift: missing id/display_name, negative cost, units with
## hp<=0, non-units carrying stray combat stats, etc. Wired into main.gd after
## card_database_test. PASS = every card valid.


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[card_data_validation_test] PASS")
	else:
		printerr("[card_data_validation_test] FAIL — %d invalid card(s)" % rc)


func _run() -> int:
	var all := CardDatabase.all_cards()
	var bad := 0
	for c in all:
		var errs: Array[String] = c.validate()
		if not errs.is_empty():
			bad += 1
			printerr("  %s (%s): %s" % [c.id, c.display_name, str(errs)])
	print("[card_data_validation_test] validated %d cards, %d invalid" % [all.size(), bad])
	return bad
