extends Control
class_name UnitView

## UnitView (B2.6 UI) — placeholder visual for one friendly unit on a lane.
##
## Spawned by Combat when a UnitInstance is placed; auto-positions itself
## based on the unit's lane_index + tile. Pure placeholder — a tinted
## rectangle with the card name + ATK/HP. B3 art replaces with the real
## unit sprite + idle animation.

const UNIT_WIDTH: float = 150.0
const UNIT_HEIGHT: float = 130.0

# Geometry must mirror the lane visuals in combat.tscn:
#   Lane 0: x = 20..360   (midpoint 190)
#   Lane 1: x = 370..710  (midpoint 540)
#   Lane 2: x = 720..1060 (midpoint 890)
#   Lanes vertical span: y = 80..1180  (height 1100, 6 tile slots)
const LANE_X_CENTERS: Array[float] = [190.0, 540.0, 890.0]
const LANE_TOP: float = 80.0
const LANE_HEIGHT: float = 1100.0
const TILE_COUNT: int = 6

var unit: UnitInstance = null


func _ready() -> void:
	custom_minimum_size = Vector2(UNIT_WIDTH, UNIT_HEIGHT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_position_for_unit()
	_build_visuals()


func bind(u: UnitInstance) -> void:
	unit = u
	if is_inside_tree():
		_position_for_unit()
		_build_visuals()


# ============================================================================
# Layout
# ============================================================================

func _position_for_unit() -> void:
	if unit == null:
		return
	var lane_x: float = LANE_X_CENTERS[clamp(unit.lane_index, 0, 2)]
	# Tile 0 = base (bottom of lane); tile_count = spawn line (top).
	# Friendly tile 1 = closest to base, tile_count-1 = furthest forward.
	var per_tile: float = LANE_HEIGHT / float(TILE_COUNT)
	var tile_center_y: float = (LANE_TOP + LANE_HEIGHT) - (float(unit.tile) + 0.5) * per_tile
	position = Vector2(lane_x - UNIT_WIDTH * 0.5, tile_center_y - UNIT_HEIGHT * 0.5)


func _build_visuals() -> void:
	# Wipe any previous children (re-bind) and rebuild simple labels.
	for c in get_children():
		c.queue_free()
	if unit == null or unit.card_data == null:
		return
	var bg := ColorRect.new()
	bg.size = Vector2(UNIT_WIDTH, UNIT_HEIGHT)
	bg.color = Color(0.85, 0.85, 0.92, 0.95)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	var name_l := Label.new()
	name_l.text = unit.card_data.display_name
	name_l.position = Vector2(6, 4)
	name_l.size = Vector2(UNIT_WIDTH - 12, 60)
	name_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_l.add_theme_color_override("font_color", Color.BLACK)
	name_l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(name_l)
	var stats_l := Label.new()
	stats_l.text = "%d/%d" % [unit.card_data.attack, unit.current_hp]
	stats_l.position = Vector2(6, UNIT_HEIGHT - 30)
	stats_l.size = Vector2(UNIT_WIDTH - 12, 24)
	stats_l.add_theme_color_override("font_color", Color.BLACK)
	stats_l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stats_l)
