extends Node

## Smoke test for B2.9 — MapNode + MapGraph + MapGenerator + GameState wiring.
##
## Covers:
##   - generate(1, seed) returns a graph with exactly 5 nodes
##   - start_id is set and refers to a node with kind=COMBAT, depth=0
##   - boss_id is set and refers to a node with kind=BOSS, depth=3, 0 children
##   - graph.validate() returns no errors (no orphans, no dangling child refs,
##     boss reachable from start)
##   - start node has 2 children (branch point)
##   - merge node has 1 child (the boss)
##   - same seed → byte-identical graph (kind, children, depth, seed_offset)
##   - different seeds produce ≥2 distinct graphs over a 10-seed sweep
##     (proves the RNG is actually doing something — would catch a generator
##     bug where rng.randi() got cached/short-circuited)
##   - per-node make_rng(run_seed) returns deterministic, distinct RNGs
##     (same seed → same first-roll; sibling nodes → different first-roll)
##   - GameState.enter_chapter builds a graph, seats player at start
##   - GameState.choose_next_node accepts legal child jumps
##   - GameState.choose_next_node REJECTS illegal jumps (boss from start)
##   - GameState.choose_next_node REJECTS unknown node ids
##   - chapter_started + map_node_entered signals fire correctly
##
## All assertions PASS = 0 errors. Wired into main.gd alongside the other
## dev tests (after reward_test).


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[map_test] PASS")
	else:
		printerr("[map_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors: int = 0

	# ---- Basic generation --------------------------------------------------
	var g: MapGraph = MapGenerator.generate(1, 12345)
	if g == null:
		printerr("FATAL: generate returned null")
		return 1
	if g.size() != 5:
		errors += 1; printerr("expected 5 nodes, got %d" % g.size())
	if g.chapter != 1:
		errors += 1; printerr("chapter field not propagated: got %d" % g.chapter)
	if g.seed_value != 12345:
		errors += 1; printerr("seed_value field not propagated: got %d" % g.seed_value)

	# ---- Start + boss structural invariants --------------------------------
	if g.start_id == &"":
		errors += 1; printerr("no start_id set")
	if g.boss_id == &"":
		errors += 1; printerr("no boss_id set")
	var start_node: MapNode = g.get_node_by_id(g.start_id)
	if start_node == null:
		errors += 1; printerr("start_id %s did not resolve" % g.start_id)
	else:
		if start_node.kind != GFEnums.NodeKind.COMBAT:
			errors += 1; printerr("start kind = %d, expected COMBAT" % start_node.kind)
		if start_node.depth != 0:
			errors += 1; printerr("start depth = %d, expected 0" % start_node.depth)
		if start_node.children.size() != 2:
			errors += 1
			printerr("start children = %d, expected 2" % start_node.children.size())

	var boss_node: MapNode = g.get_node_by_id(g.boss_id)
	if boss_node == null:
		errors += 1; printerr("boss_id %s did not resolve" % g.boss_id)
	else:
		if boss_node.kind != GFEnums.NodeKind.BOSS:
			errors += 1; printerr("boss kind = %d, expected BOSS" % boss_node.kind)
		if boss_node.depth != 3:
			errors += 1; printerr("boss depth = %d, expected 3" % boss_node.depth)
		if boss_node.children.size() != 0:
			errors += 1
			printerr("boss children = %d, expected 0" % boss_node.children.size())

	# ---- Validate clean graph (no dangling refs, boss reachable) -----------
	var validation: Array[String] = g.validate()
	if not validation.is_empty():
		errors += 1; printerr("validate errors: %s" % str(validation))

	# ---- Merge node (depth 2) has 1 child (the boss) -----------------------
	var depth_2: Array[MapNode] = g.nodes_at_depth(2)
	if depth_2.size() != 1:
		errors += 1; printerr("depth 2 has %d nodes, expected 1" % depth_2.size())
	elif depth_2[0].children.size() != 1:
		errors += 1
		printerr("merge node has %d children, expected 1" % depth_2[0].children.size())
	elif depth_2[0].children[0] != g.boss_id:
		errors += 1
		printerr("merge child = %s, expected boss %s" % [depth_2[0].children[0], g.boss_id])

	# ---- Determinism: same seed → byte-identical graph ---------------------
	var g_again: MapGraph = MapGenerator.generate(1, 12345)
	if g_again.size() != g.size():
		errors += 1; printerr("determinism: size drift %d vs %d" % [g.size(), g_again.size()])
	for nid in g.nodes.keys():
		var n1: MapNode = g.nodes[nid]
		var n2: MapNode = g_again.nodes[nid]
		if n2 == null:
			errors += 1; printerr("determinism: node %s missing in second gen" % nid)
			continue
		if n1.kind != n2.kind:
			errors += 1; printerr("determinism: node %s kind drift %d vs %d" %
					[nid, n1.kind, n2.kind])
		if n1.depth != n2.depth:
			errors += 1; printerr("determinism: node %s depth drift" % nid)
		if n1.seed_offset != n2.seed_offset:
			errors += 1; printerr("determinism: node %s seed_offset drift" % nid)
		if n1.children.size() != n2.children.size():
			errors += 1; printerr("determinism: node %s children size drift" % nid)
		else:
			for i in range(n1.children.size()):
				if n1.children[i] != n2.children[i]:
					errors += 1
					printerr("determinism: node %s child[%d] %s vs %s" %
							[nid, i, n1.children[i], n2.children[i]])

	# ---- RNG variance: ≥2 distinct graphs across 10 seeds -----------------
	var variants: Dictionary = {}
	for s in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]:
		var gn: MapGraph = MapGenerator.generate(1, s)
		var key: String = ""
		for nid in [&"c1_start", &"c1_left", &"c1_right", &"c1_mid", &"c1_boss"]:
			var nn: MapNode = gn.get_node_by_id(nid)
			if nn != null:
				key += "%s:%d|" % [nid, nn.kind]
		variants[key] = true
	if variants.size() < 2:
		errors += 1
		printerr("RNG variance too low: only %d distinct graphs across 10 seeds" %
				variants.size())

	# ---- Per-node make_rng determinism + distinctness ---------------------
	# Same node, same seed → same roll. Sibling nodes (different seed_offset)
	# → different first roll. This is the contract combat/event scenes rely on.
	var start_rng_a := start_node.make_rng(99)
	var start_rng_b := start_node.make_rng(99)
	if start_rng_a.randi() != start_rng_b.randi():
		errors += 1; printerr("per-node RNG not deterministic for same run_seed")
	var left: MapNode = g.get_node_by_id(&"c1_left")
	var right: MapNode = g.get_node_by_id(&"c1_right")
	if left != null and right != null:
		var l_rng := left.make_rng(99)
		var r_rng := right.make_rng(99)
		if l_rng.randi() == r_rng.randi():
			# Theoretical 1-in-2^32 collision — flag it but don't fail hard.
			# In practice this would mean seed_offset isn't being mixed in.
			errors += 1; printerr("sibling nodes share first-roll RNG state")

	# ---- GameState integration: enter_chapter + choose_next_node ----------
	# Build a deck so start_run completes cleanly.
	var dummy_pool: Array[Card] = _dummy_card_pool()
	GameState.start_run(dummy_pool, &"map_test_warlord", 12345)

	var chapter_signals: Array = [0, null]  # [fire_count, last_graph]
	var entered_signals: Array = [0, null]  # [fire_count, last_node]
	var on_chap := func(num: int, gph: MapGraph) -> void:
		chapter_signals[0] = (chapter_signals[0] as int) + 1
		chapter_signals[1] = gph
	var on_entered := func(node: MapNode) -> void:
		entered_signals[0] = (entered_signals[0] as int) + 1
		entered_signals[1] = node
	GameState.chapter_started.connect(on_chap)
	GameState.map_node_entered.connect(on_entered)

	var built: MapGraph = GameState.enter_chapter(1)
	if built == null:
		errors += 1; printerr("enter_chapter returned null")
	if GameState.current_map_graph == null:
		errors += 1; printerr("current_map_graph not set after enter_chapter")
	if GameState.current_node_id != built.start_id:
		errors += 1; printerr("current_node_id not seated at start")
	if chapter_signals[0] != 1:
		errors += 1; printerr("chapter_started fired %d times (expected 1)" % chapter_signals[0])
	if GameState.current_phase != GFEnums.RunPhase.MAP:
		errors += 1; printerr("phase not MAP after enter_chapter")

	# Legal jump: start → left
	var ok_left: bool = GameState.choose_next_node(&"c1_left")
	if not ok_left:
		errors += 1; printerr("choose_next_node(left) rejected legal jump")
	if GameState.current_node_id != &"c1_left":
		errors += 1; printerr("current_node_id not updated after legal jump")
	if entered_signals[0] != 1:
		errors += 1; printerr("map_node_entered fired %d times (expected 1)" % entered_signals[0])

	# Illegal jump: left → boss (must go via merge)
	var ok_boss_skip: bool = GameState.choose_next_node(&"c1_boss")
	if ok_boss_skip:
		errors += 1; printerr("choose_next_node(boss) ACCEPTED an illegal skip")
	if entered_signals[0] != 1:
		errors += 1; printerr("illegal jump still fired map_node_entered")

	# Unknown node id
	var ok_unknown: bool = GameState.choose_next_node(&"c1_does_not_exist")
	if ok_unknown:
		errors += 1; printerr("choose_next_node(unknown) ACCEPTED an invalid id")

	# Walk to the end legally: left → mid → boss
	var ok_mid: bool = GameState.choose_next_node(&"c1_mid")
	if not ok_mid:
		errors += 1; printerr("choose_next_node(mid) rejected legal jump")
	var ok_boss: bool = GameState.choose_next_node(&"c1_boss")
	if not ok_boss:
		errors += 1; printerr("choose_next_node(boss) rejected legal jump from mid")
	if GameState.current_node_id != &"c1_boss":
		errors += 1; printerr("not seated at boss after walking the graph")
	if entered_signals[0] != 3:
		errors += 1
		printerr("map_node_entered fired %d times (expected 3: left/mid/boss)" %
				entered_signals[0])

	# Disconnect so subsequent test suites don't see leaked listeners.
	if GameState.chapter_started.is_connected(on_chap):
		GameState.chapter_started.disconnect(on_chap)
	if GameState.map_node_entered.is_connected(on_entered):
		GameState.map_node_entered.disconnect(on_entered)

	return errors


## Pull together a minimal Card pool so start_run can build the player's deck.
## Map test doesn't care about deck contents — just that GameState is in a
## valid post-start_run state when enter_chapter fires.
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
