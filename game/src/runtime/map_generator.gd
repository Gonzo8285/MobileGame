extends RefCounted
class_name MapGenerator

## MapGenerator (IMV-1 redesign 2026-05-18) — builds a linear 8-round gauntlet.
##
## Per Paul's design call: the run is 8 sequential combats. Win all 8 = run
## victory. Lose any = defeat (or spend a retry gem). No branching at IMV-1;
## the engine still supports MapGraph branching for future iterations.
##
## Round layout (locked for IMV-1):
##
##   Round 1   COMBAT       (easy intro — baseline scaling)
##   Round 2   COMBAT
##   Round 3   COMBAT
##   Round 4   ELITE        (first power gate; +30% stats vs round 1)
##   Round 5   HORDE        (many weak enemies; +5 bonus gem payout on win)
##   Round 6   COMBAT       (mid-curve)
##   Round 7   HORDE        (second swarm; same bonus)
##   Round 8   BOSS         (single tough enemy; +10 gem payout)
##
## Deterministic per (run_seed): same seed → same per-node seed_offsets so the
## wave/event rolls inside each round replay identically.

const _MULT_KNUTH: int = 2654435761


# ============================================================================
# Public entry
# ============================================================================

const DEPTHS: int = 12          ## depth 0 (START) .. DEPTHS-1 (BOSS)
const MIN_WIDTH: int = 2
const MAX_WIDTH: int = 4


## Default generator (BM-2): a branching, Slay-the-Spire-style layered DAG.
static func generate(chapter: int, seed_value: int) -> MapGraph:
	return generate_branching(chapter, seed_value)


## Legacy linear 8-round gauntlet — kept for engine tests / back-compat.
static func generate_linear(chapter: int, seed_value: int) -> MapGraph:
	var graph := MapGraph.new()
	graph.chapter = chapter
	graph.seed_value = seed_value
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value ^ (chapter * _MULT_KNUTH)
	_generate_linear_8_round(graph, rng)
	return graph


## Branching DAG (BM-2): DEPTHS rows, START at depth 0, BOSS at DEPTHS-1, middle
## rows MIN..MAX wide, edges forward 1-2 per node, every node reachable from
## START and able to reach BOSS. Guarantees a full SHOP row + full REST row
## (per-path), an ELITE gate node ~depth 8, and a depth-1 COMBAT on-ramp.
## Deterministic per (chapter, seed). validate() passes.
static func generate_branching(chapter: int, seed_value: int) -> MapGraph:
	var graph := MapGraph.new()
	graph.chapter = chapter
	graph.seed_value = seed_value
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value ^ (chapter * _MULT_KNUTH)

	var shop_depth: int = int(DEPTHS / 2)       # full SHOP row (per-path shop)
	var rest_depth: int = DEPTHS - 2            # pre-boss full REST row
	var elite_gate: int = DEPTHS - 4            # guaranteed elite gate node

	# 1. Rows of nodes per depth.
	var rows: Array = []
	for d in range(DEPTHS):
		var row: Array = []
		var width: int = 1 if (d == 0 or d == DEPTHS - 1) else \
				MIN_WIDTH + (rng.randi() % (MAX_WIDTH - MIN_WIDTH + 1))
		for i in range(width):
			var node := MapNode.new(StringName("d%d_%d" % [d, i]),
					_kind_for(d, i, rng, shop_depth, rest_depth, elite_gate),
					d, d * 101 + i * 17 + 1)
			row.append(node)
			graph.add_node(node)
		rows.append(row)
	graph.start_id = rows[0][0].id
	graph.boss_id = rows[DEPTHS - 1][0].id

	# 2. Edges depth d -> d+1; ensure no orphans (every next node has a parent).
	var parents: Dictionary = {}
	for d in range(DEPTHS - 1):
		var cur: Array = rows[d]
		var nxt: Array = rows[d + 1]
		for ci in range(cur.size()):
			for ti in _pick_targets(ci, cur.size(), nxt.size(), rng):
				_link(cur[ci], nxt[ti], parents)
		for ti in range(nxt.size()):
			if not parents.has((nxt[ti] as MapNode).id):
				_link(cur[min(ti, cur.size() - 1)], nxt[ti], parents)

	# 3. Encounter archetypes on combat-type nodes, varied along every path.
	_assign_encounters(graph, rows, parents)
	return graph


static func _link(parent: MapNode, child: MapNode, parents: Dictionary) -> void:
	if not parent.children.has(child.id):
		parent.children.append(child.id)
	if not parents.has(child.id):
		parents[child.id] = []
	if not (parents[child.id] as Array).has(parent.id):
		(parents[child.id] as Array).append(parent.id)


static func _kind_for(d: int, i: int, rng: RandomNumberGenerator,
		shop_depth: int, rest_depth: int, elite_gate: int) -> int:
	if d == 0:
		return GFEnums.NodeKind.COMBAT
	if d == DEPTHS - 1:
		return GFEnums.NodeKind.BOSS
	if d == 1:
		return GFEnums.NodeKind.COMBAT          # gentle on-ramp
	if d == shop_depth:
		return GFEnums.NodeKind.SHOP
	if d == rest_depth:
		return GFEnums.NodeKind.REST
	if d == elite_gate and i == 0:
		return GFEnums.NodeKind.ELITE           # guaranteed gate
	var r: int = rng.randi() % 100
	if r < 62:
		return GFEnums.NodeKind.COMBAT
	elif r < 77:
		return GFEnums.NodeKind.ELITE
	elif r < 89:
		return GFEnums.NodeKind.EVENT
	return GFEnums.NodeKind.SHRINE


## 1-2 forward targets biased to the node's proportional slot in the next row.
static func _pick_targets(ci: int, cur_size: int, nxt_size: int, rng: RandomNumberGenerator) -> Array:
	if nxt_size <= 1:
		return [0]
	var center: int = (rng.randi() % nxt_size) if cur_size <= 1 else \
			int(round(float(ci) / float(cur_size - 1) * float(nxt_size - 1)))
	center = clampi(center, 0, nxt_size - 1)
	var targets: Array = [center]
	if rng.randi() % 2 == 0:
		var second: int = clampi(center + (1 if rng.randi() % 2 == 0 else -1), 0, nxt_size - 1)
		if second != center:
			targets.append(second)
	return targets


## Assign an EncounterArchetype to each COMBAT/ELITE node, avoiding any parent's
## archetype so no path hits the same archetype back-to-back. Depth order so a
## node's parents are already assigned when it is processed.
static func _assign_encounters(graph: MapGraph, rows: Array, parents: Dictionary) -> void:
	var arch_ids: Array = EncounterArchetype.ids()
	if arch_ids.is_empty():
		return
	for d in range(rows.size()):
		for node in rows[d]:
			if node.kind != GFEnums.NodeKind.COMBAT and node.kind != GFEnums.NodeKind.ELITE:
				continue
			var avoid: Dictionary = {}
			if parents.has(node.id):
				for pid in parents[node.id]:
					var p: MapNode = graph.get_node_by_id(pid)
					if p != null and p.encounter_id != &"":
						avoid[p.encounter_id] = true
			var candidates: Array = []
			for aid in arch_ids:
				if not avoid.has(aid):
					candidates.append(aid)
			if candidates.is_empty():
				candidates = arch_ids
			var node_rng: RandomNumberGenerator = node.make_rng(graph.seed_value)
			node.encounter_id = candidates[node_rng.randi() % candidates.size()]


# ============================================================================
# Linear 8-round gauntlet (IMV-1)
# ============================================================================

const ROUND_KINDS: Array[int] = [
	GFEnums.NodeKind.COMBAT,   # round 1
	GFEnums.NodeKind.COMBAT,   # round 2
	GFEnums.NodeKind.COMBAT,   # round 3
	GFEnums.NodeKind.ELITE,    # round 4 — power gate
	GFEnums.NodeKind.HORDE,    # round 5 — swarm + bonus gems
	GFEnums.NodeKind.COMBAT,   # round 6
	GFEnums.NodeKind.HORDE,    # round 7 — swarm + bonus gems
	GFEnums.NodeKind.BOSS,     # round 8 — boss
]

static func _generate_linear_8_round(graph: MapGraph, _rng: RandomNumberGenerator) -> void:
	var ids: Array[StringName] = []
	for i in range(ROUND_KINDS.size()):
		var nid: StringName = StringName("r%d" % (i + 1))
		ids.append(nid)
		var node := MapNode.new(nid, ROUND_KINDS[i], i, (i + 1) * 11)
		graph.add_node(node)

	# Linear wiring: each round points to the next; round 8 (boss) is terminal.
	for i in range(ids.size() - 1):
		var node: MapNode = graph.nodes[ids[i]]
		node.children = [ids[i + 1]]

	graph.start_id = ids[0]
	graph.boss_id = ids[ids.size() - 1]


# ============================================================================
# Helpers
# ============================================================================

## Returns the round number (1-8) for a given node id in the linear gauntlet.
## Returns -1 if the id doesn't match the rN pattern.
static func round_for_node(node_id: StringName) -> int:
	var s: String = String(node_id)
	if not s.begins_with("r"):
		return -1
	return int(s.substr(1)) if s.substr(1).is_valid_int() else -1


## True if the round is a horde wave (more enemies, bonus gem payout).
static func is_horde_round(round_num: int) -> bool:
	return round_num == 5 or round_num == 7


## True if the round is a boss wave (single tough enemy, max gem payout).
static func is_boss_round(round_num: int) -> bool:
	return round_num == 8
