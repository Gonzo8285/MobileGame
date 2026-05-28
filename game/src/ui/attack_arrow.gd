extends Line2D
class_name AttackArrow

## AttackArrow — short-lived red line from attacker to target during combat.
##
## MTG Arena pattern: every attack draws a brief arrow so players can see
## the combat lines, not just the result. Combat.gd doesn't currently emit
## per-attack pairs, so we instead detect attacks from the lane.enemy_hit
## signal (fires when a friendly damages an enemy) and pair the most-recent
## attacker that's in range — heuristic but visually correct most of the time.
##
## Lifespan: 0.45s, fading from full red to 0 alpha.

const LIFETIME: float = 0.45


static func spawn(parent: Node, from_pos: Vector2, to_pos: Vector2,
		colour: Color = Color(1, 0.35, 0.25, 0.9)) -> AttackArrow:
	var arrow := AttackArrow.new()
	arrow.default_color = colour
	arrow.width = 5.0
	arrow.add_point(from_pos)
	arrow.add_point(to_pos)
	arrow.mouse_filter = Control.MOUSE_FILTER_IGNORE if arrow is Control else 0
	parent.add_child(arrow)
	# Pulse alpha to 0 then queue_free.
	var t := arrow.create_tween()
	t.tween_property(arrow, "modulate:a", 0.0, LIFETIME)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_callback(arrow.queue_free)
	return arrow
