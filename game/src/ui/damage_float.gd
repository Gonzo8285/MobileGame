extends Label
class_name DamageFloat

## DamageFloat — small "-N" / "+N" label that rises and fades.
##
## Spawned by Combat on lane.enemy_hit / lane.unit_hit / heal signals.
## Lives ~0.9s then queue_frees. Marvel Snap / MTG Arena pattern: every
## damage event produces a visible floating number so the player can
## read damage flow without staring at HP bars.
##
## Style: bold red for damage, green for heals, white for buff numbers.

const RISE_DISTANCE: float = 60.0
const LIFETIME: float = 0.9


static func spawn_damage(parent: Node, world_pos: Vector2, amount: int) -> DamageFloat:
	return _spawn(parent, world_pos, "-%d" % amount, Color(1, 0.35, 0.25, 1))


static func spawn_heal(parent: Node, world_pos: Vector2, amount: int) -> DamageFloat:
	return _spawn(parent, world_pos, "+%d" % amount, Color(0.4, 1.0, 0.5, 1))


static func spawn_buff(parent: Node, world_pos: Vector2, text: String) -> DamageFloat:
	return _spawn(parent, world_pos, text, Color(0.85, 0.85, 1.0, 1))


static func _spawn(parent: Node, world_pos: Vector2, text: String,
		colour: Color) -> DamageFloat:
	var dmg := DamageFloat.new()
	dmg.text = text
	dmg.add_theme_font_size_override("font_size", 40)
	dmg.add_theme_color_override("font_color", colour)
	# Outline so red-on-red lane background stays legible.
	dmg.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	dmg.add_theme_constant_override("outline_size", 6)
	dmg.position = world_pos - Vector2(20, 20)
	dmg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(dmg)
	dmg._animate()
	return dmg


func _animate() -> void:
	var start_pos := position
	var end_pos := start_pos + Vector2(0, -RISE_DISTANCE)
	var t := create_tween().set_parallel(true)
	t.tween_property(self, "position", end_pos, LIFETIME)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "modulate:a", 0.0, LIFETIME)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.chain().tween_callback(queue_free)
