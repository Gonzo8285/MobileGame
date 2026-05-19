extends Control
class_name EnemyView

## EnemyView (IMV-1 — Paul, 2026-05-18) — placeholder visual for one enemy
## advancing on a lane. Spawned by Combat when Lane.enemy_spawned fires.
## Repositions every turn_resolved as enemies advance toward the player base.

const ENEMY_WIDTH: float = 150.0
const ENEMY_HEIGHT: float = 110.0

# Match combat.tscn lane geometry.
const LANE_X_CENTERS: Array[float] = [190.0, 540.0, 890.0]
const LANE_TOP: float = 80.0
const LANE_HEIGHT: float = 890.0
const TILE_COUNT: int = 6

var enemy: EnemyInstance = null
var _hp_bar: ColorRect = null
var _name_label: Label = null
var _stats_label: Label = null


func _ready() -> void:
	custom_minimum_size = Vector2(ENEMY_WIDTH, ENEMY_HEIGHT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_visuals()
	_position_for_enemy()
	_refresh_display()
	var combat: Node = _find_combat()
	if combat != null and combat.has_signal("turn_resolved"):
		combat.turn_resolved.connect(_on_turn_resolved)
	# Flash on hit (friendly attacks → enemy_hit signal on the lane).
	if combat != null and enemy != null:
		var lane: Lane = combat.lanes[enemy.lane_index] if combat.get("lanes") != null and enemy.lane_index < combat.lanes.size() else null
		if lane != null:
			lane.enemy_hit.connect(_on_enemy_hit)


func bind(e: EnemyInstance) -> void:
	enemy = e
	if is_inside_tree():
		_position_for_enemy()
		_refresh_display()


func _find_combat() -> Node:
	var n: Node = get_parent()
	while n != null:
		if n.has_method("handle_drop"):
			return n
		n = n.get_parent()
	return null


func _on_turn_resolved(_turn: int, _summary: Dictionary) -> void:
	if enemy == null or not enemy.is_alive():
		queue_free()
		return
	_position_for_enemy()
	_refresh_display()


func _position_for_enemy() -> void:
	if enemy == null:
		return
	var lane_x: float = LANE_X_CENTERS[clamp(enemy.lane_index, 0, 2)]
	# Same per-tile math as UnitView; enemies start at tile=6 (spawn line)
	# and advance toward tile 0 (player base).
	var per_tile: float = LANE_HEIGHT / float(TILE_COUNT)
	var tile_clamped: float = clamp(float(enemy.tile), 0.0, float(TILE_COUNT))
	var tile_center_y: float = (LANE_TOP + LANE_HEIGHT) - (tile_clamped + 0.5) * per_tile
	# Enemies render slightly off-centre (right) so a friendly + enemy on the
	# same tile are both visible.
	position = Vector2(lane_x - ENEMY_WIDTH * 0.5 + 6, tile_center_y - ENEMY_HEIGHT * 0.5)


func _build_visuals() -> void:
	for c in get_children():
		c.queue_free()

	# Dark red background to distinguish from friendly cream.
	var bg := ColorRect.new()
	bg.size = Vector2(ENEMY_WIDTH, ENEMY_HEIGHT)
	bg.color = Color(0.38, 0.10, 0.10, 0.95)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# Red top strip (matches enemy theme).
	var strip := ColorRect.new()
	strip.position = Vector2(0, 0)
	strip.size = Vector2(ENEMY_WIDTH, 8)
	strip.color = Color(0.85, 0.25, 0.25)
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(strip)

	# "ENEMY" tag bottom-left.
	var tag := Label.new()
	tag.text = "ENEMY"
	tag.position = Vector2(6, 12)
	tag.size = Vector2(80, 20)
	tag.add_theme_color_override("font_color", Color(1, 0.85, 0.85, 0.85))
	tag.add_theme_font_size_override("font_size", 11)
	tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(tag)

	# Name.
	_name_label = Label.new()
	_name_label.position = Vector2(6, 30)
	_name_label.size = Vector2(ENEMY_WIDTH - 12, 36)
	_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_name_label.add_theme_color_override("font_color", Color.WHITE)
	_name_label.add_theme_font_size_override("font_size", 12)
	_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_name_label)

	# HP bar.
	var hp_bg := ColorRect.new()
	hp_bg.position = Vector2(6, ENEMY_HEIGHT - 32)
	hp_bg.size = Vector2(ENEMY_WIDTH - 12, 10)
	hp_bg.color = Color(0.10, 0.05, 0.05)
	hp_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(hp_bg)

	_hp_bar = ColorRect.new()
	_hp_bar.position = Vector2(6, ENEMY_HEIGHT - 32)
	_hp_bar.size = Vector2(ENEMY_WIDTH - 12, 10)
	_hp_bar.color = Color(0.85, 0.30, 0.30)
	_hp_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_hp_bar)

	# Stats label.
	_stats_label = Label.new()
	_stats_label.position = Vector2(6, ENEMY_HEIGHT - 20)
	_stats_label.size = Vector2(ENEMY_WIDTH - 12, 20)
	_stats_label.add_theme_color_override("font_color", Color(1, 0.95, 0.92))
	_stats_label.add_theme_font_size_override("font_size", 12)
	_stats_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stats_label)


func _refresh_display() -> void:
	if enemy == null or enemy.enemy_data == null:
		return
	if not is_instance_valid(_name_label):
		return
	_name_label.text = enemy.enemy_data.display_name
	var max_hp: int = enemy.enemy_data.max_hp
	var hp_frac: float = float(enemy.current_hp) / float(max(max_hp, 1))
	if is_instance_valid(_hp_bar):
		_hp_bar.size.x = (ENEMY_WIDTH - 12) * clamp(hp_frac, 0.0, 1.0)
	if is_instance_valid(_stats_label):
		_stats_label.text = "ATK %d  HP %d/%d  Tile %d" % [
			enemy.enemy_data.attack, enemy.current_hp, max_hp, enemy.tile
		]


func _on_enemy_hit(hit_enemy: EnemyInstance, _damage: int) -> void:
	if hit_enemy != enemy:
		return
	_flash(Color(1.0, 0.95, 0.2, 1.0))  # yellow flash on enemies (taking friendly fire)
	_refresh_display()


func _flash(tint: Color) -> void:
	if not is_inside_tree():
		return
	var t := create_tween()
	t.tween_property(self, "modulate", tint, 0.08)
	t.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.22)
