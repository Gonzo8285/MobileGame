extends Control
class_name GameOverScreen

## Game-over / victory screen for IMV-1 with retry-gem support.
##
## On defeat:
##   - If GameState.gems >= retry_cost_for_round(current_round), show a
##     "Retry round (N gems)" button. Click → emit `retry_pressed`.
##   - Always show "Run again" to restart the whole gauntlet.
## On victory:
##   - Show summary + Run again.

signal restart_pressed
signal retry_pressed


func _ready() -> void:
	custom_minimum_size = Vector2(1080, 1700)
	var is_victory: bool = GameState.current_phase == GFEnums.RunPhase.VICTORY

	# Title.
	var title := Label.new()
	title.text = "Victory" if is_victory else "Defeated"
	title.add_theme_font_size_override("font_size", 64)
	title.modulate = Color(0.4, 0.9, 0.6) if is_victory else Color(0.9, 0.4, 0.4)
	title.position = Vector2(40, 300)
	title.size = Vector2(1000, 100)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	# Summary card.
	var current_round: int = _current_round_num()
	var summary := Label.new()
	summary.text = "Warlord: %s\nHP: %d/%d\nRound: %d / 8\nGems: %d\nRetries used: %d" % [
		String(GameState.active_warlord_id),
		GameState.base_hp, GameState.max_base_hp,
		current_round,
		GameState.gems,
		GameState.retries_taken
	]
	summary.add_theme_font_size_override("font_size", 22)
	summary.position = Vector2(40, 440)
	summary.size = Vector2(1000, 200)
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(summary)

	# Retry button (defeat only, and only if affordable).
	if not is_victory:
		var retry_cost: int = GameState.retry_cost_for_round(current_round)
		var can_retry: bool = GameState.gems >= retry_cost
		var retry := Button.new()
		retry.text = "Retry round %d  (-%d gems)" % [current_round, retry_cost]
		retry.add_theme_font_size_override("font_size", 24)
		retry.position = Vector2(280, 760)
		retry.size = Vector2(520, 80)
		retry.disabled = not can_retry
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.20, 0.55, 0.75) if can_retry else Color(0.35, 0.35, 0.40)
		sb.corner_radius_top_left = 10
		sb.corner_radius_top_right = 10
		sb.corner_radius_bottom_left = 10
		sb.corner_radius_bottom_right = 10
		retry.add_theme_stylebox_override("normal", sb)
		retry.pressed.connect(func(): retry_pressed.emit())
		add_child(retry)

		if not can_retry:
			var nope := Label.new()
			nope.text = "Not enough gems for retry — earn more next run, or restart"
			nope.add_theme_font_size_override("font_size", 14)
			nope.modulate = Color(1, 0.7, 0.7, 0.8)
			nope.position = Vector2(280, 850)
			nope.size = Vector2(520, 24)
			nope.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			add_child(nope)

	# Run again button.
	var btn := Button.new()
	btn.text = "Run again (new gauntlet)" if not is_victory else "Run again"
	btn.add_theme_font_size_override("font_size", 24)
	btn.position = Vector2(280, 900)
	btn.size = Vector2(520, 80)
	btn.pressed.connect(func(): restart_pressed.emit())
	add_child(btn)


func _current_round_num() -> int:
	if GameState.current_map_graph == null:
		return 1
	if not GameState.current_map_graph.nodes.has(GameState.current_node_id):
		return 1
	return GameState.current_map_graph.nodes[GameState.current_node_id].depth + 1
