extends RefCounted
class_name MapGenerator

## MapGenerator (B2.9) — builds a chapter MapGraph from (chapter, seed).
##
## Pure static. Deterministic: same (chapter, seed) → byte-identical graph
## (kinds, children edges, seed_offsets). Backbone of run save/load — a save
## file only needs to store the run-seed + chapter + current_node_id; the
## graph is rebuilt on demand.
##
## Chapter 1 is the prototype map per backlog B2.9: a 5-node test chapter
## that exercises the branching + merge mechanic without needing 16 nodes
## of layout work. Subsequent chapters (B2.9 follow-on / B8 tuning) extend
## this generator with full STS-style 4×4 + boss layouts.
##
## Anti-P2W invariant: the generator reads no monetisation state. Run-seed
## comes from the player's `start_run` call; no IAP path can bias the kind
## distribution.

const _MULT_KNUTH: int = 2654435761  # Knuth multiplicative hash constant


# ============================================================================
# Public entry
# ============================================================================

## Build a chapter MapGraph. `chapter` is 1-indexed (matches GameState.chapter).
## `seed_value` should be the run-seed so all chapters in a run share a
## deterministic pedigree — we mix in `chapter` internally so chapter 1 and
## chapter 2 never collide on identical seeds.
static func generate(chapter: int, seed_value: int) -> MapGraph:
	var graph := MapGraph.new()
	graph.chapter = chapter
	graph.seed_value = seed_value

	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value ^ (chapter * _MULT_KNUTH)

	if chapter == 1:
		_generate_chapter_1(graph, rng)
	else:
		# Placeholder for chapters 2+. For now they clone the chapter-1 shape
		# so end-to-end smoke flow has something to chew on. Real per-chapter
		# generators land alongside their content (B2.9 follow-on).
		_generate_chapter_1(graph, rng)

	return graph


# ============================================================================
# Chapter 1 — 5-node prototype (start → branch → merge → boss)
# ============================================================================
#
#   depth 0       depth 1       depth 2       depth 3
#   c1_start  →   c1_left   →   c1_mid    →   c1_boss
#             →   c1_right  ↗
#
# 5 nodes, one branch point (depth-1), one merge point (depth-2).
# - c1_start is always COMBAT (every chapter must open on a fight)
# - c1_left + c1_right are an EVENT + COMBAT pair, order coin-flipped per seed
# - c1_mid is ELITE or SHOP (50/50)
# - c1_boss is BOSS

static func _generate_chapter_1(graph: MapGraph, rng: RandomNumberGenerator) -> void:
	# Branch node kinds: one COMBAT, one EVENT — order rolls so reruns vary.
	var branch_swap: bool = (rng.randi() % 2) == 0
	var left_kind: int = GFEnums.NodeKind.EVENT if branch_swap else GFEnums.NodeKind.COMBAT
	var right_kind: int = GFEnums.NodeKind.COMBAT if branch_swap else GFEnums.NodeKind.EVENT

	# Merge node: ELITE or SHOP (the "tougher fight vs. spend-Ash" call).
	var mid_kind: int = GFEnums.NodeKind.ELITE if (rng.randi() % 2) == 0 else GFEnums.NodeKind.SHOP

	var n_start := MapNode.new(&"c1_start", GFEnums.NodeKind.COMBAT, 0, 1)
	var n_left  := MapNode.new(&"c1_left",  left_kind,                  1, 2)
	var n_right := MapNode.new(&"c1_right", right_kind,                 1, 3)
	var n_mid   := MapNode.new(&"c1_mid",   mid_kind,                   2, 4)
	var n_boss  := MapNode.new(&"c1_boss",  GFEnums.NodeKind.BOSS,      3, 5)

	# Wire children. Boss is terminal (no children).
	n_start.children = [&"c1_left", &"c1_right"]
	n_left.children  = [&"c1_mid"]
	n_right.children = [&"c1_mid"]
	n_mid.children   = [&"c1_boss"]

	graph.add_node(n_start)
	graph.add_node(n_left)
	graph.add_node(n_right)
	graph.add_node(n_mid)
	graph.add_node(n_boss)

	graph.start_id = n_start.id
	graph.boss_id = n_boss.id
