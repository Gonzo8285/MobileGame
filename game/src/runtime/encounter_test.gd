extends Node
## BM encounter tests. BM-1 portion: EncounterArchetype catalog integrity.
## BM-3 extends this with WaveGenerator.for_node → legal-wave-per-archetype.

func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[encounter_test] PASS")
	else:
		printerr("[encounter_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors := 0

	# ---- Catalog integrity (BM-1) -----------------------------------------
	var cat := EncounterArchetype.catalog()
	if cat.size() != 7:
		errors += 1; printerr("expected 7 archetypes, got %d" % cat.size())
	for id in cat:
		var a: EncounterArchetype = cat[id]
		if a.id == &"" or a.display_name == "" or a.symbol == "" or a.blurb == "":
			errors += 1; printerr("archetype %s missing a display field" % id)
	# Symbols must be unique (players read them on the map).
	var seen_symbols := {}
	for id in cat:
		var s: String = cat[id].symbol
		if seen_symbols.has(s):
			errors += 1; printerr("duplicate archetype symbol '%s'" % s)
		seen_symbols[s] = true
	if EncounterArchetype.get_archetype(&"swarm") == null:
		errors += 1; printerr("get_archetype(swarm) returned null")
	if EncounterArchetype.get_archetype(&"__nope__") != null:
		errors += 1; printerr("get_archetype(unknown) should be null")

	return errors
