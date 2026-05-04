extends ColorRect
class_name LaneDropZone

## LaneDropZone (B2.6 UI) — accepts dropped cards and forwards to Combat.
##
## Attached to the lane ColorRect children of `combat.tscn`. Implements
## Godot's `_can_drop_data` / `_drop_data` so the engine routes drag-and-drop
## events from CardView straight into us.
##
## On a valid drop, calls `combat_root.handle_drop(lane_index, card, pos)`.
## The Combat node owns the actual CardPlay invocation; this script is a
## thin "hit-test + forward" layer.

@export var lane_index: int = 0

## Set by Combat when it instantiates the lane visuals. If left null, the
## script walks up the tree and finds the first ancestor with a handle_drop
## method.
var combat_root: Node = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	if combat_root == null:
		combat_root = _find_combat_root()


# ============================================================================
# Drag-drop API
# ============================================================================

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# We accept anything tagged "card". The actual cost / target validation
	# happens in CardPlay; this just lets the cursor signal "yes, drop here".
	return data is Dictionary and data.get("kind", "") == "card"


func _drop_data(at_position: Vector2, data: Variant) -> void:
	if combat_root == null:
		push_warning("[LaneDropZone] no combat_root, drop ignored")
		return
	if not (data is Dictionary):
		return
	var card: Card = data.get("card") as Card
	if card == null:
		return
	if not combat_root.has_method("handle_drop"):
		push_warning("[LaneDropZone] combat_root has no handle_drop method")
		return
	combat_root.handle_drop(lane_index, card, at_position)


# ============================================================================
# Helpers
# ============================================================================

func _find_combat_root() -> Node:
	var n: Node = self
	while n != null:
		if n.has_method("handle_drop"):
			return n
		n = n.get_parent()
	return null
