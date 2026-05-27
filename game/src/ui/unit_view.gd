extends Control
class_name UnitView

## UnitView (B2.6 UI + IMV-1 visuals pass) — placeholder visual for one
## friendly unit on a lane. Now: HP bar, faction tint, lane geometry matches
## current combat.tscn layout, repositions on turn_resolved.

const UNIT_WIDTH: float = 150.0
const UNIT_HEIGHT: float = 120.0

# Lane geometry — matches current combat.tscn (lanes y=80..970, x as below).
const LANE_X_CENTERS: Array[float] = [190.0, 540.0, 890.0]
const LANE_TOP: float = 80.0
const LANE_HEIGHT: float = 890.0
const TILE_COUNT: int = 6

var unit: UnitInstance = null
var _hp_bar: ColorRect = null
var _hp_bar_bg: ColorRect = null
var _stats_label: Label = null
var _name_label: Label = null
var _last_atk: int = -1   ## tracks stat changes for pulse animation
var _last_hp: int = -1
var _last_max_hp: int = -1


func _ready() -> void:
	custom_minimum_size = Vector2(UNIT_WIDTH, UNIT_HEIGHT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_visuals()
	_position_for_unit()
	_refresh_display()
	# Listen for combat tick to refresh display (HP after enemy attacks).
	var combat: Node = _find_combat()
	if combat != null and combat.has_signal("turn_resolved"):
		combat.turn_resolved.connect(_on_turn_resolved)
	# Flash on hit — subscribe to lane signals via combat root.
	if combat != null and unit != null:
		var lane: Lane = combat.lanes[unit.lane_index] if combat.get("lanes") != null and unit.lane_index < combat.lanes.size() else null
		if lane != null:
			lane.unit_hit.connect(_on_unit_hit)


func bind(u: UnitInstance) -> void:
	unit = u
	if is_inside_tree():
		_position_for_unit()
		_refresh_display()


func _find_combat() -> Node:
	var n: Node = get_parent()
	while n != null:
		if n.has_method("handle_drop"):
			return n
		n = n.get_parent()
	return null


func _on_turn_resolved(_turn: int, _summary: Dictionary) -> void:
	_refresh_display()


# ============================================================================
# Layout
# ============================================================================

func _position_for_unit() -> void:
	if unit == null:
		return
	var lane_x: float = LANE_X_CENTERS[clamp(unit.lane_index, 0, 2)]
	# Tile 0 = base (bottom of lane); tile_count-1 = furthest forward.
	var per_tile: float = LANE_HEIGHT / float(TILE_COUNT)
	var tile_center_y: float = (LANE_TOP + LANE_HEIGHT) - (float(unit.tile) + 0.5) * per_tile
	position = Vector2(lane_x - UNIT_WIDTH * 0.5, tile_center_y - UNIT_HEIGHT * 0.5)


func _build_visuals() -> void:
	for c in get_children():
		c.queue_free()

	# Background — pale tint so unit stands out from dark lane.
	var bg := ColorRect.new()
	bg.size = Vector2(UNIT_WIDTH, UNIT_HEIGHT)
	bg.color = Color(0.92, 0.94, 0.98, 0.95)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# Faction colour strip at top.
	var faction_strip := ColorRect.new()
	faction_strip.size = Vector2(UNIT_WIDTH, 8)
	faction_strip.position = Vector2(0, 0)
	if unit != null and unit.card_data != null:
		faction_strip.color = _faction_colour(unit.card_data.faction)
	else:
		faction_strip.color = Color(0.5, 0.5, 0.6)
	faction_strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(faction_strip)

	# Name label.
	_name_label = Label.new()
	_name_label.position = Vector2(6, 12)
	_name_label.size = Vector2(UNIT_WIDTH - 12, 40)
	_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_name_label.add_theme_color_override("font_color", Color(0.05, 0.05, 0.10))
	_name_label.add_theme_font_size_override("font_size", 12)
	_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_name_label)

	# HP bar background.
	_hp_bar_bg = ColorRect.new()
	_hp_bar_bg.position = Vector2(6, UNIT_HEIGHT - 36)
	_hp_bar_bg.size = Vector2(UNIT_WIDTH - 12, 12)
	_hp_bar_bg.color = Color(0.20, 0.10, 0.10)
	_hp_bar_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_hp_bar_bg)

	# HP bar fill.
	_hp_bar = ColorRect.new()
	_hp_bar.position = Vector2(6, UNIT_HEIGHT - 36)
	_hp_bar.size = Vector2(UNIT_WIDTH - 12, 12)
	_hp_bar.color = Color(0.30, 0.75, 0.30)
	_hp_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_hp_bar)

	# Stats label (ATK / HP numerals under bar).
	_stats_label = Label.new()
	_stats_label.position = Vector2(6, UNIT_HEIGHT - 22)
	_stats_label.size = Vector2(UNIT_WIDTH - 12, 22)
	_stats_label.add_theme_color_override("font_color", Color(0.10, 0.10, 0.15))
	_stats_label.add_theme_font_size_override("font_size", 13)
	_stats_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stats_label)


func _refresh_display() -> void:
	if unit == null or unit.card_data == null:
		return
	if not is_instance_valid(_name_label):
		return
	_name_label.text = unit.card_data.display_name
	# AURA.E1 — max HP includes runtime aura grants now, not just card.hp
	var max_hp: int = unit.max_hp() if unit.has_method("max_hp") else unit.card_data.hp
	var atk: int = unit.current_attack()
	var hp_frac: float = float(unit.current_hp) / float(max(max_hp, 1))
	if is_instance_valid(_hp_bar):
		_hp_bar.size.x = (UNIT_WIDTH - 12) * clamp(hp_frac, 0.0, 1.0)
		_hp_bar.color = _hp_bar_colour(hp_frac)
	if is_instance_valid(_stats_label):
		var cd_text: String = ""
		if unit.cooldown_counter > 0:
			cd_text = " (CD %d)" % unit.cooldown_counter
		_stats_label.text = "ATK %d  HP %d/%d%s" % [atk, unit.current_hp, max_hp, cd_text]
	# Stat-change pulse: green if ATK or max_hp went UP (aura grant landed),
	# red if current_hp went DOWN (took damage). Skip on first paint
	# (_last_* still at -1 sentinel).
	if _last_atk >= 0:
		if atk > _last_atk or max_hp > _last_max_hp:
			_pulse_stats(Color(0.4, 1.0, 0.5, 1))
		elif atk < _last_atk or max_hp < _last_max_hp:
			_pulse_stats(Color(1.0, 0.6, 0.3, 1))  # buff dropped — orange tint
	_last_atk = atk
	_last_hp = unit.current_hp
	_last_max_hp = max_hp
	# Reposition in case tile changed (rare for friendlies but defensive).
	_position_for_unit()


func _pulse_stats(tint: Color) -> void:
	if _stats_label == null or not is_instance_valid(_stats_label) or not is_inside_tree():
		return
	var t := create_tween()
	t.tween_property(_stats_label, "modulate", tint, 0.10)
	t.tween_property(_stats_label, "modulate", Color(1, 1, 1, 1), 0.40)


func _hp_bar_colour(frac: float) -> Color:
	if frac > 0.66: return Color(0.30, 0.75, 0.30)
	if frac > 0.33: return Color(0.90, 0.75, 0.20)
	return Color(0.85, 0.25, 0.20)


func _faction_colour(f: int) -> Color:
	match f:
		GFEnums.Faction.IRON_PENITENTS: return Color(0.55, 0.18, 0.18)
		GFEnums.Faction.ASH_MOURNERS: return Color(0.35, 0.25, 0.50)
		GFEnums.Faction.COVEN:    return Color(0.18, 0.50, 0.30)
		GFEnums.Faction.LAST_LEGION:    return Color(0.50, 0.42, 0.18)
		GFEnums.Faction.SKINWARD_PACT:    return Color(0.45, 0.30, 0.15)
		_: return Color(0.40, 0.40, 0.45)


func _on_unit_hit(hit_unit: UnitInstance, _damage: int) -> void:
	if hit_unit != unit:
		return
	_flash(Color(1.0, 0.3, 0.3, 1.0))
	_refresh_display()


func _flash(tint: Color) -> void:
	if not is_inside_tree():
		return
	var t := create_tween()
	t.tween_property(self, "modulate", tint, 0.08)
	t.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.22)
