extends Node

## Smoke test for the map subsystem (B2.9, IMV-1 linear redesign 2026-05-18).
##
## The chapter map is an 8-round linear gauntlet (r1..r8): three combats, an
## elite gate (r4), two hordes (r5, r7), a mid combat (r6), then a boss (r8).
## Win all 8 = run victory. No branching at IMV-1 — MapGraph still supports DAG
## branching for future chapters (see MapGenerator header); when BM-2 flips
## generate() to branching, BM-6 will revise these assertions.
##
## Covers:
##   - generate(1, seed) returns exactly 8 nodes (r1..r8)
##   - chapter + seed_value fields propagate
##   - start_id = r1 (COMBAT, depth 0, single child r2)
##   - boss_id = r8 (BOSS, depth 7, 0 children — terminal)
##   - round kinds match the locked ROUND_KINDS layout (ELITE@4, HORDE@5/7, BOSS@8)
##   - linear wiring: every non-boss round points to exactly the next round
##   - graph.validate() returns no errors (terminal boss, no dangling refs,
##     boss reachable, no orphans)
##   - determinism: same seed → identical graph (kind/depth/seed_offset/children)
##   - per-node make_rng(run_seed) deterministic for same node; distinct between
##     sibling rounds (different seed_offset)
##   - GameState.enter_chapter seats player at start, fires chapter_started, MAP phase
##   - GameState.choose_next_node accepts the legal next round
##   - choose_next_node REJECTS an illegal skip (jumping past the next round)
##   - choose_next_node REJECTS unknown node ids
##   - map_node_entered fires once per legal advance; walking r1→r8 seats at boss
##
## All assertions PASS = 0 errors. Wired into main.gd alongside the other tests.


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[map_test] PASS")
	else:
		printerr("[map_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors: int = 0

	# ---- Basic generation: 8-round linear gauntlet -------------------------
	var g: MapGraph = MapGenerator.generate(1, 12345)
	if g == null:
		printerr("FATAL: generate returned null")
		return 1
	if g.size() != 8:
		errors += 1; printerr("expected 8 nodes, got %d" % g.size())
	if g.chapter != 1:
		errors += 1; printerr("chapter field not propagated: got %d" % g.chapter)
	if g.seed_value != 12345:
		errors += 1; printerr("seed_value field not propagated: got %d" % g.seed_value)

	# ---- Start invariants: r1 = COMBAT, depth 0, single child r2 -----------
	if g.start_id != &"r1":
		errors += 1; printerr("start_id = %s, expected r1" % g.start_id)
	var start_node: MapNode = g.get_node_by_id(g.start_id)
	if start_node == null:
		errors += 1; printerr("start_id %s did not resolve" % g.start_id)
	else:
		if start_node.kind != GFEnums.NodeKind.COMBAT:
			errors += 1; printerr("start kind = %d, expected COMBAT" % start_node.kind)
		if start_node.depth != 0:
			errors += 1; printerr("start depth = %d, expected 0" % start_node.depth)
		if start_node.children.size() != 1 or start_node.children[0] != &"r2":
			errors += 1; printerr("start children = %s, expected [r2]" % str(start_node.children))

	# ---- Boss invariants: r8 = BOSS, depth 7, terminal ---------------------
	if g.boss_id != &"r8":
		errors += 1; printerr("boss_id = %s, expected r8" % g.boss_id)
	var boss_node: MapNode = g.get_node_by_id(g.boss_id)
	if boss_node == null:
		errors += 1; printerr("boss_id %s did not resolve" % g.boss_id)
	else:
		if boss_node.kind != GFEnums.NodeKind.BOSS:
			errors += 1; printerr("boss kind = %d, expected BOSS" % boss_node.kind)
		if boss_node.depth != 7:
			errors += 1; printerr("boss depth = %d, expected 7" % boss_node.depth)
		if boss_node.children.size() != 0:
			errors += 1; printerr("boss children = %d, expected 0" % boss_node.children.size())

	# ---- Round-kind layout + linear wiring ---------------------------------
	var expected_kinds: Array[int] = [
		GFEnums.NodeKind.COMBAT, GFEnums.NodeKind.COMBAT, GFEnums.NodeKind.COMBAT,
		GFEnums.NodeKind.ELITE, GFEnums.NodeKind.HORDE, GFEnums.NodeKind.COMBAT,
		GFEnums.NodeKind.HORDE, GFEnums.NodeKind.BOSS,
	]
	for i in range(8):
		var nid: StringName = StringName("r%d" % (i + 1))
		var n: MapNode = g.get_node_by_id(nid)
		if n == null:
			errors += 1; printerr("round %s missing" % nid)
			continue
		if n.kind != expected_kinds[i]:
			errors += 1; printerr("%s kind = %d, expected %d" % [nid, n.kind, expected_kinds[i]])
		if n.depth != i:
			errors += 1; printerr("%s depth = %d, expected %d" % [nid, n.depth, i])
		# Non-boss rounds point to exactly the next round.
		if i < 7:
			var want: StringName = StringName("r%d" % (i + 2))
			if n.children.size() != 1 or n.children[0] != want:
				errors += 1; printerr("%s children = %s, expected [%s]" % [nid, str(n.children), want])

	# ---- Validate clean graph (terminal boss, no orphans/dangling) ---------
	var validation: Array[String] = g.validate()
	if not validation.is_empty():
		errors += 1; printerr("validate errors: %s" % str(validation))

	# ---- Determinism: same seed → identical graph -------------------------
	var g_again: MapGraph = MapGenerator.generate(1, 12345)
	if g_again.size() != g.size():
		errors += 1; printerr("determinism: size drift %d vs %d" % [g.size(), g_again.size()])
	for nid in g.nodes.keys():
		var n1: MapNode = g.nodes[nid]
		var n2: MapNode = g_again.nodes.get(nid, null)
		if n2 == null:
			errors += 1; printerr("determinism: node %s missing in second gen" % nid)
			continue
		if n1.kind != n2.kind:
			errors += 1; printerr("determinism: node %s kind drift" % nid)
		if n1.depth != n2.depth:
			errors += 1; printerr("determinism: node %s depth drift" % nid)
		if n1.seed_offset != n2.seed_offset:
			errors += 1; printerr("determinism: node %s seed_offset drift" % nid)
		if n1.children != n2.children:
			errors += 1; printerr("determinism: node %s children drift" % nid)

	# ---- Per-node make_rng determinism + sibling distinctness -------------
	if start_node != null:
		var rng_a := start_node.make_rng(99)
		var rng_b := start_node.make_rng(99)
		if rng_a.randi() != rng_b.randi():
			errors += 1; printerr("per-node RNG not deterministic for same run_seed")
	var r2node: MapNode = g.get_node_by_id(&"r2")
	if start_node != null and r2node != null:
		var s_rng := start_node.make_rng(99)
		var r_rng := r2node.make_rng(99)
		if s_rng.randi() == r_rng.randi():
			errors += 1; printerr("sibling rounds share first-roll RNG (seed_offset not mixed)")

	# ---- GameState integration: enter_chapter + choose_next_node ----------
	var dummy_pool: Array[Card] = _dummy_card_pool()
	GameState.start_run(dummy_pool, &"map_test_warlord", 12345)

	var chapter_count: Array = [0]
	var entered_count: Array = [0]
	var on_chap := func(_num: int, _gph: MapGraph) -> void:
		chapter_count[0] = (chapter_count[0] as int) + 1
	var on_entered := func(_node: MapNode) -> void:
		entered_count[0] = (entered_count[0] as int) + 1
	GameState.chapter_started.connect(on_chap)
	GameState.map_node_entered.connect(on_entered)

	var built: MapGraph = GameState.enter_chapter(1)
	if built == null:
		errors += 1; printerr("enter_chapter returned null")
	elif GameState.current_map_graph == null:
		errors += 1; printerr("current_map_graph not set after enter_chapter")
	if built != null and GameState.current_node_id != built.start_id:
		errors += 1; printerr("current_node_id not seated at start, got %s" % GameState.current_node_id)
	if chapter_count[0] != 1:
		errors += 1; printerr("chapter_started fired %d times (expected 1)" % chapter_count[0])
	if GameState.current_phase != GFEnums.RunPhase.MAP:
		errors += 1; printerr("phase not MAP after enter_chapter")

	# Legal advance: r1 → r2
	if not GameState.choose_next_node(&"r2"):
		errors += 1; printerr("choose_next_node(r2) rejected legal advance")
	if GameState.current_node_id != &"r2":
		errors += 1; printerr("current_node_id not updated after legal advance")
	if entered_count[0] != 1:
		errors += 1; printerr("map_node_entered fired %d times (expected 1)" % entered_count[0])

	# Illegal skip: r2 → r8 (rounds must be taken in order)
	if GameState.choose_next_node(&"r8"):
		errors += 1; printerr("choose_next_node(r8) ACCEPTED an illegal skip from r2")
	if entered_count[0] != 1:
		errors += 1; printerr("illegal skip still fired map_node_entered")

	# Unknown node id
	if GameState.choose_next_node(&"r_does_not_exist"):
		errors += 1; printerr("choose_next_node(unknown) ACCEPTED an invalid id")

	# Walk the rest legally: r3 → r4 → … → r8
	for r in range(3, 9):
		var nid: StringName = StringName("r%d" % r)
		if not GameState.choose_next_node(nid):
			errors += 1; printerr("choose_next_node(%s) rejected legal advance" % nid)
	if GameState.current_node_id != &"r8":
		errors += 1
		printerr("not seated at boss r8 after the gauntlet, got %s" % GameState.current_node_id)
	# map_node_entered fires once per legal advance: r2..r8 = 7 total.
	if entered_count[0] != 7:
		errors += 1
		printerr("map_node_entered fired %d times (expected 7 for r2..r8)" % entered_count[0])

	# Cleanup listeners so later suites don't see leaked connections.
	if GameState.chapter_started.is_connected(on_chap):
		GameState.chapter_started.disconnect(on_chap)
	if GameState.map_node_entered.is_connected(on_entered):
		GameState.map_node_entered.disconnect(on_entered)

	return errors


## Minimal Card pool so start_run can build a deck. Map test doesn't care about
## deck contents — just that GameState is valid when enter_chapter fires.
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
