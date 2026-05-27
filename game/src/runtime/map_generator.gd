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

static func generate(chapter: int, seed_value: int) -> MapGraph:
	var graph := MapGraph.new()
	graph.chapter = chapter
	graph.seed_value = seed_value

	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value ^ (chapter * _MULT_KNUTH)

	# IMV-1: one chapter, linear 8 rounds, no branching. Future chapters can
	# reuse this scaffold or branch off `_generate_branching` (legacy, kept
	# below for engine-test back-compat).
	_generate_linear_8_round(graph, rng)

	return graph


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
