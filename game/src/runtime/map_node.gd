extends RefCounted
class_name MapNode

## One tile on the chapter map (B2.9).
##
## Pure data. Holds:
##   - `id`            — stable StringName, unique within a MapGraph (e.g. &"c1_start")
##   - `kind`          — GFEnums.NodeKind (COMBAT / ELITE / EVENT / SHOP / SHRINE / REST / BOSS)
##   - `depth`         — 0..N from start; the UI lays nodes out by depth column
##   - `children`      — Array[StringName] of node ids reachable from this tile
##   - `seed_offset`   — deterministic per-node sub-seed so each combat/event/shop
##                       gets reproducible rolls without colliding with siblings
##
## No traversal logic lives here — see `map_graph.gd`. No UI state either —
## "visited?" / "current?" live on GameState so the graph itself stays
## save-friendly (a fresh MapGraph is reconstructible from chapter+seed alone).

var id: StringName = &""
var kind: int = 0  # GFEnums.NodeKind
var depth: int = 0
var children: Array[StringName] = []
var seed_offset: int = 0


func _init(p_id: StringName = &"", p_kind: int = 0, p_depth: int = 0, p_seed_offset: int = 0) -> void:
	id = p_id
	kind = p_kind
	depth = p_depth
	seed_offset = p_seed_offset


## Per-node deterministic RNG. Combat/event/shop/etc. scenes seed their rolls
## from this so the same run-seed always produces the same enemy spawns, event
## flavour text, shop inventory, etc. when revisiting via save/load.
func make_rng(run_seed: int) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	# Combine run_seed and seed_offset deterministically. XOR + multiplicative
	# mix is enough for our purposes — we're not seeding a cryptographic RNG.
	rng.seed = run_seed ^ (seed_offset * 2654435761)  # Knuth multiplicative hash
	return rng


## Debug helper. Used by map_test.gd output and the (future) map screen
## inspector overlay.
func describe() -> String:
	return "MapNode(%s, kind=%s, depth=%d, children=%s)" % [
		id, GFEnums.NodeKind.keys()[kind], depth, str(children)
	]
