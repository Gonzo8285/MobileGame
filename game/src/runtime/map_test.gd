extends Node

## Map subsystem test (BM-2/BM-6). generate() now yields a branching DAG;
## generate_linear() keeps the 8-round gauntlet for back-compat.
##
## Covers (branching via generate()):
##   - valid graph: START (COMBAT, depth 0) → BOSS (terminal, last depth)
##   - graph.validate() clean (reachable, boss-terminal, no orphans/dangling)
##   - a full SHOP row + full REST row exist → every path hits a shop and a rest
##   - an ELITE gate node around depth 6-9
##   - combat nodes carry an encounter_id; no parent→child pair shares an
##     archetype (no back-to-back repeat on any path)
##   - determinism: same (chapter, seed) → identical graph
##   - GameState.enter_chapter seats at start; choose_next_node walks children to
##     the boss; illegal (non-child) + unknown jumps rejected
##   - generate_linear() still yields the 8-round gauntlet (back-compat)


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[map_test] PASS")
	else:
		printerr("[map_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors := 0
	var g: MapGraph = MapGenerator.generate(1, 12345)
	if g == null:
		printerr("FATAL: generate returned null")
		return 1

	# ---- Structure --------------------------------------------------------
	if g.size() < 10:
		errors += 1; printerr("branching graph too small: %d nodes" % g.size())
	if g.chapter != 1 or g.seed_value != 12345:
		errors += 1; printerr("chapter/seed not propagated")
	var start_node: MapNode = g.get_node_by_id(g.start_id)
	if start_node == null or start_node.depth != 0 or start_node.kind != GFEnums.NodeKind.COMBAT:
		errors += 1; printerr("start not a depth-0 COMBAT")
	var boss_node: MapNode = g.get_node_by_id(g.boss_id)
	if boss_node == null or boss_node.kind != GFEnums.NodeKind.BOSS or boss_node.children.size() != 0:
		errors += 1; printerr("boss not a terminal BOSS")

	# ---- validate() clean -------------------------------------------------
	var validation: Array[String] = g.validate()
	if not validation.is_empty():
		errors += 1; printerr("validate errors: %s" % str(validation))

	# ---- Per-path SHOP + REST (full rows) + ELITE gate --------------------
	var max_depth: int = boss_node.depth if boss_node != null else 0
	var has_shop_row := false
	var has_rest_row := false
	var has_elite_gate := false
	for d in range(max_depth + 1):
		var row: Array[MapNode] = g.nodes_at_depth(d)
		if row.is_empty():
			continue
		var all_shop := true
		var all_rest := true
		for n in row:
			if n.kind != GFEnums.NodeKind.SHOP: all_shop = false
			if n.kind != GFEnums.NodeKind.REST: all_rest = false
			if n.kind == GFEnums.NodeKind.ELITE and d >= 6 and d <= 9: has_elite_gate = true
		if all_shop: has_shop_row = true
		if all_rest: has_rest_row = true
	if not has_shop_row:
		errors += 1; printerr("no full SHOP row — per-path shop not guaranteed")
	if not has_rest_row:
		errors += 1; printerr("no full REST row — per-path rest not guaranteed")
	if not has_elite_gate:
		errors += 1; printerr("no ELITE gate around depth 6-9")

	# ---- Encounter archetypes + no back-to-back repeat --------------------
	for nid in g.nodes.keys():
		var n: MapNode = g.nodes[nid]
		if (n.kind == GFEnums.NodeKind.COMBAT or n.kind == GFEnums.NodeKind.ELITE) \
				and n.encounter_id == &"":
			errors += 1; printerr("combat node %s has no encounter_id" % nid); break
	for nid in g.nodes.keys():
		var n: MapNode = g.nodes[nid]
		if n.encounter_id == &"":
			continue
		for cid in n.children:
			var c: MapNode = g.get_node_by_id(cid)
			if c != null and c.encounter_id != &"" and c.encounter_id == n.encounter_id:
				errors += 1
				printerr("back-to-back archetype %s: %s->%s" % [n.encounter_id, nid, cid]); break

	# ---- Determinism ------------------------------------------------------
	var g2: MapGraph = MapGenerator.generate(1, 12345)
	if g2.size() != g.size():
		errors += 1; printerr("determinism: size drift %d vs %d" % [g.size(), g2.size()])
	else:
		for nid in g.nodes.keys():
			var a: MapNode = g.nodes[nid]
			var b: MapNode = g2.get_node_by_id(nid)
			if b == null or a.kind != b.kind or a.depth != b.depth \
					or a.encounter_id != b.encounter_id or a.children != b.children:
				errors += 1; printerr("determinism drift at %s" % nid); break

	# ---- Back-compat: generate_linear() still the 8-round gauntlet ---------
	var lin: MapGraph = MapGenerator.generate_linear(1, 12345)
	if lin.size() != 8 or lin.start_id != &"r1" or lin.boss_id != &"r8":
		errors += 1; printerr("generate_linear drifted from the 8-round gauntlet")

	# ---- GameState nav over the branching graph ---------------------------
	GameState.start_run(_dummy_card_pool(), &"map_test_warlord", 12345)
	var chapter_count: Array = [0]
	var entered_count: Array = [0]
	var on_chap := func(_num, _gph): chapter_count[0] = int(chapter_count[0]) + 1
	var on_entered := func(_node): entered_count[0] = int(entered_count[0]) + 1
	GameState.chapter_started.connect(on_chap)
	GameState.map_node_entered.connect(on_entered)

	var built: MapGraph = GameState.enter_chapter(1)
	if built == null:
		errors += 1; printerr("enter_chapter returned null")
	elif GameState.current_node_id != built.start_id:
		errors += 1; printerr("not seated at start, got %s" % GameState.current_node_id)
	if chapter_count[0] != 1:
		errors += 1; printerr("chapter_started fired %d times (expected 1)" % chapter_count[0])
	if GameState.current_phase != GFEnums.RunPhase.MAP:
		errors += 1; printerr("phase not MAP after enter_chapter")

	if built != null:
		if GameState.choose_next_node(built.boss_id):
			errors += 1; printerr("illegal jump straight to boss accepted")
		if GameState.choose_next_node(&"__nope__"):
			errors += 1; printerr("unknown node id accepted")
		var cur: StringName = built.start_id
		var steps := 0
		var entered_before: int = int(entered_count[0])
		while cur != built.boss_id and steps < 30:
			var node: MapNode = built.get_node_by_id(cur)
			if node == null or node.children.is_empty():
				break
			var nxt: StringName = node.children[0]
			if not GameState.choose_next_node(nxt):
				errors += 1; printerr("legal advance to %s rejected" % nxt); break
			if GameState.current_node_id != nxt:
				errors += 1; printerr("current_node_id not updated to %s" % nxt); break
			cur = nxt
			steps += 1
		if cur != built.boss_id:
			errors += 1; printerr("did not reach boss on children[0] walk (stuck at %s)" % cur)
		if int(entered_count[0]) - entered_before != steps:
			errors += 1; printerr("map_node_entered count mismatch (%d fires, %d steps)" %
					[int(entered_count[0]) - entered_before, steps])

	if GameState.chapter_started.is_connected(on_chap):
		GameState.chapter_started.disconnect(on_chap)
	if GameState.map_node_entered.is_connected(on_entered):
		GameState.map_node_entered.disconnect(on_entered)

	return errors


## Minimal Card pool so start_run can build a deck.
func _dummy_card_pool() -> Array[Card]:
	var out: Array[Card] = []
	for i in range(5):
		var c: Card = Card.new()
		c.id = StringName("MAPTEST_%d" % i)
		c.display_name = "Maptest %d" % i
		c.cost = 1
		c.faction = GFEnums.Faction.NEUTRAL
		c.card_type = GFEnums.CardType.UNIT
		c.rarity = GFEnums.Rarity.COMMON
		c.hp = 1
		c.attack = 1
		c.is_draftable = true
		out.append(c)
	return out
