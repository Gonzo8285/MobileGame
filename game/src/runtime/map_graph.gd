extends RefCounted
class_name MapGraph

## Chapter map (B2.9) — a directed acyclic graph of MapNodes.
##
## Built by MapGenerator from (chapter, seed). Pure data: no UI state, no
## "visited" or "current" tracking — those live on GameState so a fresh
## MapGraph is fully reconstructible from chapter+seed alone (cheap save/load).
##
## Invariants (enforced by validate()):
##   - start_id and boss_id are both non-empty and present in `nodes`
##   - boss_id node has zero children (terminal)
##   - every node-id referenced by a `children` array exists in `nodes`
##   - boss is reachable from start via BFS (no orphan nodes)
##
## Lookup is O(1) via the `nodes` dictionary. The graph is read-only after
## construction — the generator builds it; GameState navigates over it but
## never mutates it.

var chapter: int = 1
var seed_value: int = 0
var nodes: Dictionary = {}  # StringName -> MapNode
var start_id: StringName = &""
var boss_id: StringName = &""
var max_depth: int = 0


# ============================================================================
# Construction (used by MapGenerator)
# ============================================================================

func add_node(node: MapNode) -> void:
	if node == null or node.id == &"":
		return
	nodes[node.id] = node
	if node.depth > max_depth:
		max_depth = node.depth


# ============================================================================
# Lookup + navigation
# ============================================================================

func get_node_by_id(node_id: StringName) -> MapNode:
	return nodes.get(node_id, null) as MapNode


func get_children(node_id: StringName) -> Array[MapNode]:
	var out: Array[MapNode] = []
	var n: MapNode = nodes.get(node_id, null)
	if n == null:
		return out
	for cid in n.children:
		var c: MapNode = nodes.get(cid, null)
		if c != null:
			out.append(c)
	return out


## True if `child_id` is a direct successor of `parent_id`. Used by
## GameState.choose_next_node to reject illegal jumps.
func is_child_of(parent_id: StringName, child_id: StringName) -> bool:
	var p: MapNode = nodes.get(parent_id, null)
	if p == null:
		return false
	return p.children.has(child_id)


## All nodes at a given depth. Used by the UI to lay out columns.
func nodes_at_depth(d: int) -> Array[MapNode]:
	var out: Array[MapNode] = []
	for nid in nodes:
		var n: MapNode = nodes[nid]
		if n.depth == d:
			out.append(n)
	return out


func size() -> int:
	return nodes.size()


# ============================================================================
# Validation
# ============================================================================

## Returns an Array[String] of structural errors. Empty array = valid graph.
## Tests call this after construction; production code can skip it.
func validate() -> Array[String]:
	var errors: Array[String] = []

	if start_id == &"":
		errors.append("no start_id set")
	if boss_id == &"":
		errors.append("no boss_id set")
	if start_id != &"" and not nodes.has(start_id):
		errors.append("start_id %s not in nodes" % start_id)
	if boss_id != &"" and not nodes.has(boss_id):
		errors.append("boss_id %s not in nodes" % boss_id)

	# Boss must be a terminal — no children.
	if boss_id != &"" and nodes.has(boss_id):
		var boss: MapNode = nodes[boss_id]
		if boss.children.size() != 0:
			errors.append("boss %s has %d children (expected 0)" %
					[boss_id, boss.children.size()])

	# All child-id refs must resolve.
	for nid in nodes:
		var n: MapNode = nodes[nid]
		for cid in n.children:
			if not nodes.has(cid):
				errors.append("node %s references missing child %s" % [nid, cid])

	# Reachability: every node must be reachable from start via children edges,
	# AND boss must be reachable. We BFS from start and compare set sizes.
	if start_id != &"" and nodes.has(start_id):
		var reached: Dictionary = {}
		var frontier: Array[StringName] = []
		frontier.append(start_id)
		while not frontier.is_empty():
			var nid: StringName = frontier.pop_back()
			if reached.has(nid):
				continue
			reached[nid] = true
			var n: MapNode = nodes[nid]
			for cid in n.children:
				if not reached.has(cid):
					frontier.append(cid)
		if boss_id != &"" and not reached.has(boss_id):
			errors.append("boss %s not reachable from start %s" % [boss_id, start_id])
		if reached.size() != nodes.size():
			errors.append("orphan nodes: %d reachable / %d total" %
					[reached.size(), nodes.size()])

	return errors
