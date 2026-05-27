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
	# Made noticeably brighter (alpha 0.07 -> 0.22) so Paul can see lane scale.
	var tile_h: float = h / float(TILES_PER_LANE)
	for i in range(1, TILES_PER_LANE):
		var y: float = float(i) * tile_h
		draw_line(Vector2(0, y), Vector2(w, y), Color(1, 1, 1, 0.22), 1.0)
	# Mark each tile-slot occupancy: empty = faint green tint, occupied = faint
	# red tint. Helps Paul see at a glance which tiles are free for drops.
	var lane_full: bool = _is_lane_full()
	var occupied_tiles := _get_occupied_tile_set()
	var enemy_tiles := _get_enemy_tile_set()
	for t in range(1, TILES_PER_LANE):
		var tile_y: float = h - float(t + 1) * tile_h  # tile t = playable slot t
		var tile_top: float = tile_y
		var tile_bottom: float = tile_y + tile_h
		if occupied_tiles.has(t):
			draw_rect(Rect2(0, tile_top, w, tile_bottom - tile_top),
					Color(0.85, 0.30, 0.25, 0.10), true)
		if enemy_tiles.has(t):
			# Darker red tint for enemy presence — pull-the-eye warning marker.
			draw_rect(Rect2(0, tile_top, w, tile_bottom - tile_top),
					Color(0.90, 0.15, 0.15, 0.18), true)
			draw_line(Vector2(0, tile_top), Vector2(w, tile_top),
					Color(0.95, 0.30, 0.25, 0.55), 1.5)
	# "Back rank" indicator — auto-place tile (first empty starting from tile 1).
	var next_tile: int = _next_empty_tile()
	if next_tile > 0 and next_tile < TILES_PER_LANE:
		var back_y: float = h - float(next_tile + 1) * tile_h
		draw_rect(Rect2(0, back_y, w, tile_h), Color(0.3, 0.7, 0.3, 0.18), true)
		draw_line(Vector2(0, back_y), Vector2(w, back_y), Color(0.4, 0.85, 0.4, 0.50), 2.0)
	# Drag highlight — green when droppable, RED when lane is full.
	if _is_hovered_with_drag:
		if lane_full:
			draw_rect(Rect2(0, 0, w, h), Color(0.85, 0.25, 0.25, 0.22), true)
			draw_rect(Rect2(0, 0, w, h), Color(1.0, 0.45, 0.45, 0.8), false, 4.0)
			var full_lbl := "LANE FULL"
			var default_font := ThemeDB.fallback_font
			if default_font != null:
				draw_string(default_font, Vector2(w * 0.5 - 80, h * 0.5),
						full_lbl, HORIZONTAL_ALIGNMENT_CENTER, -1, 36,
						Color(1, 0.85, 0.85, 1))
		else:
			draw_rect(Rect2(0, 0, w, h), Color(0.4, 0.85, 0.4, 0.22), true)
			draw_rect(Rect2(0, 0, w, h), Color(0.5, 1.0, 0.5, 0.7), false, 3.0)


# ============================================================================
# Lane state queries — used by the visual to colour tile slots correctly
# ============================================================================

func _get_lane_obj() -> Lane:
	if combat_root == null:
		return null
	if not combat_root.get("lanes"):
		return null
	var arr = combat_root.lanes
	if lane_index < 0 or lane_index >= arr.size():
		return null
	return arr[lane_index] as Lane


func _is_lane_full() -> bool:
	var lane := _get_lane_obj()
	if lane == null:
		return false
	return lane.first_empty_tile() == -1


func _next_empty_tile() -> int:
	var lane := _get_lane_obj()
	if lane == null:
		return 1
	return lane.first_empty_tile()


func _get_occupied_tile_set() -> Dictionary:
	var out: Dictionary = {}
	var lane := _get_lane_obj()
	if lane == null:
		return out
	for u in lane.friendly_units:
		if u != null and u.is_alive():
			out[u.tile] = true
	return out


func _get_enemy_tile_set() -> Dictionary:
	var out: Dictionary = {}
	var lane := _get_lane_obj()
	if lane == null:
		return out
	for e in lane.enemies:
		if e != null and e.is_alive():
			out[e.tile] = true
	return out


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
	# Cheap once-per-frame redraw so tile-occupancy markers stay current as
	# units enter/die. Could be event-driven via lane signals but this is
	# 3 lanes × ~16 draws/sec for the highlighted lane, negligible cost.
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
