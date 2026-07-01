extends Node
## WL-6 — WarlordDatabase roster (headless). Asserts the canonical free-5 loads,
## faction_of returns the spec §3 value per id, free_warlords().size() == 5, and
## the _deprecated/ stubs (vey/quag) are NOT indexed.

const EXPECTED_FREE := {
	&"vyrrun": GFEnums.Faction.IRON_PENITENTS,
	&"sieren": GFEnums.Faction.ASH_MOURNERS,
	&"eddra": GFEnums.Faction.COVEN,
	&"veska": GFEnums.Faction.LAST_LEGION,
	&"mhar": GFEnums.Faction.SKINWARD_PACT,
}


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[warlord_select_test] PASS")
	else:
		printerr("[warlord_select_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors := 0

	var free := WarlordDatabase.free_warlords()
	if free.size() != 5:
		errors += 1; printerr("free_warlords().size() == %d, expected 5" % free.size())
	for w in free:
		if not w.is_free:
			errors += 1; printerr("free_warlords returned a non-free warlord: %s" % w.id)

	for id in EXPECTED_FREE:
		var w: Warlord = WarlordDatabase.get_by_id(id)
		if w == null:
			errors += 1; printerr("missing free warlord %s" % id)
			continue
		var fac: int = WarlordDatabase.faction_of(id)
		if fac != EXPECTED_FREE[id]:
			errors += 1; printerr("%s faction_of = %d, expected %d" % [id, fac, EXPECTED_FREE[id]])

	# Archived stubs must NOT be indexed.
	if WarlordDatabase.get_by_id(&"vey") != null or WarlordDatabase.get_by_id(&"quag") != null:
		errors += 1; printerr("deprecated stub (vey/quag) leaked into the roster")

	# Unknown id → NEUTRAL fallback.
	if WarlordDatabase.faction_of(&"__nope__") != GFEnums.Faction.NEUTRAL:
		errors += 1; printerr("faction_of(unknown) should be NEUTRAL")

	return errors
