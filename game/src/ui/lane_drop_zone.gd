extends ColorRect
class_name LaneDropZone

## LaneDropZone (B2.6 UI + IMV-1 visual pass) — accepts dropped cards and
## forwards to Combat, with tile-grid drawing + drag highlighting.
##
## Attached to the lane ColorRect children of `combat.tscn`. Implements
## Godot's `_can_drop_data` / `_drop_data` so the engine routes drag-and-drop
## events from CardView straight into us.
##
## IMV-1 visual additions:
##   - Draws 6 horizontal tile-divider lines so the player can see lane scale
##   - Lane number label at the top
##   - Highlights green when a drag is hovering over us (drop target preview)

@export var lane_index: int = 0
const TILES_PER_LANE: int = 6

var combat_root: Node = null
var _is_hovered_with_drag: bool = false
var _lane_label: Label = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	if combat_root == null:
		combat_root = _find_combat_root()
	# Lane number label at top of the lane.
	_lane_label = Label.new()
	_lane_label.text = "Lane %d" % (lane_index + 1)
	_lane_label.add_theme_font_size_override("font_size", 18)
	_lane_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	_lane_label.offset_left = 8
	_lane_label.offset_top = 8
	_lane_label.offset_right = 200
	_lane_label.offset_bottom = 32
	_lane_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_lane_label)
	# Custom drawing for tile dividers.
	queue_redraw()


# ============================================================================
# Drag-drop API
# ============================================================================

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	var accepted: bool = data is Dictionary and data.get("kind", "") == "card"
	if accepted != _is_hovered_with_drag:
		_is_hovered_with_drag = accepted
		queue_redraw()
	return accepted


func _drop_data(at_position: Vector2, data: Variant) -> void:
	_is_hovered_with_drag = false
	queue_redraw()
	if combat_root == null or not (data is Dictionary):
		return
	var card: Card = data.get("card") as Card
	if card == null or not combat_root.has_method("handle_drop"):
		return
	combat_root.handle_drop(lane_index, card, at_position)


# ============================================================================
# Custom drawing — tile dividers + drag highlight
# ============================================================================

func _draw() -> void:
	var w: float = size.x
	var h: float = size.y
	# Tile dividers — TILES_PER_LANE evenly-spaced horizontal lines.
	var tile_h: float = h / float(TILES_PER_LANE)
	for i in range(1, TILES_PER_LANE):
		var y: float = float(i) * tile_h
		draw_line(Vector2(0, y), Vector2(w, y), Color(1, 1, 1, 0.07), 1.0)
	# "Back rank" indicator at the bottom — that's where dropped units spawn.
	var back_y: float = h - tile_h
	draw_rect(Rect2(0, back_y, w, tile_h), Color(0.3, 0.7, 0.3, 0.10), true)
	draw_line(Vector2(0, back_y), Vector2(w, back_y), Color(0.4, 0.85, 0.4, 0.35), 2.0)
	# Drag highlight — paint a green tint over the whole lane when we're hovered.
	if _is_hovered_with_drag:
		draw_rect(Rect2(0, 0, w, h), Color(0.4, 0.85, 0.4, 0.18), true)
		draw_rect(Rect2(0, 0, w, h), Color(0.5, 1.0, 0.5, 0.6), false, 3.0)


# ============================================================================
# Reset highlight if Godot doesn't send us a drop_exited (it doesn't, natively).
# ============================================================================

func _process(_delta: float) -> void:
	# When the user releases the mouse OUTSIDE this lane, _can_drop_data
	# isn't called again — we'd be stuck "hovered". Watch the global drag
	# state and clear ourselves when no drag is in progress.
	if _is_hovered_with_drag and not get_viewport().gui_is_dragging():
		_is_hovered_with_drag = false
		queue_redraw()


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
