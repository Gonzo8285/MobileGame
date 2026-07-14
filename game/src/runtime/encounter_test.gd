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

	# ---- WaveGenerator.for_node → legal wave per archetype (BM-3) ----------
	for aid in EncounterArchetype.ids():
		var node := MapNode.new(StringName("t_%s" % aid), GFEnums.NodeKind.COMBAT, 5, 55)
		node.encounter_id = aid
		var wave: Wave = WaveGenerator.for_node(node, 4242)
		if wave == null:
			errors += 1; printerr("for_node(%s) returned null" % aid); continue
		if wave.spawns.is_empty():
			errors += 1; printerr("for_node(%s) produced no spawns" % aid)
		for entry in wave.spawns:
			if entry.enemy == null or entry.enemy.max_hp <= 0:
				errors += 1; printerr("for_node(%s) has an invalid spawn" % aid); break

	# Density biases actually change counts: swarm (+) > bruisers (-).
	var swarm_n := _spawn_count(&"swarm")
	var bruiser_n := _spawn_count(&"bruisers")
	if swarm_n <= bruiser_n:
		errors += 1; printerr("swarm (%d) should out-number bruisers (%d)" % [swarm_n, bruiser_n])

	# Determinism: same node + seed → identical spawn count.
	var n2 := MapNode.new(&"t_det", GFEnums.NodeKind.COMBAT, 5, 55)
	n2.encounter_id = &"swarm"
	if WaveGenerator.for_node(n2, 999).spawns.size() != WaveGenerator.for_node(n2, 999).spawns.size():
		errors += 1; printerr("for_node not deterministic")

	return errors


func _spawn_count(aid: StringName) -> int:
	var node := MapNode.new(StringName("c_%s" % aid), GFEnums.NodeKind.COMBAT, 5, 55)
	node.encounter_id = aid
	var w: Wave = WaveGenerator.for_node(node, 4242)
	return 0 if w == null else w.spawns.size()
