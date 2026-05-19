extends Control
class_name MapView

## MapView (IMV-1 — Paul, 2026-05-18) — horizontal 8-pip strip for the linear
## gauntlet. Each pip shows round number, kind icon, and state (visited /
## current / locked). One click on the current-+1 pip advances to that round.

signal node_selected(node_id: StringName)

const PIP_SIZE: float = 110.0
const PIP_GAP: float = 12.0
const TOP_OFFSET: float = 280.0
const KIND_STYLE: Dictionary = {
	GFEnums.NodeKind.COMBAT:  {"label": "⚔",    "name": "Combat",  "colour": Color(0.55, 0.20, 0.20)},
	GFEnums.NodeKind.ELITE:   {"label": "⚔⚔",  "name": "Elite",   "colour": Color(0.75, 0.20, 0.20)},
	GFEnums.NodeKind.HORDE:   {"label": "✦✦✦", "name": "Horde",   "colour": Color(0.55, 0.40, 0.15)},
	GFEnums.NodeKind.BOSS:    {"label": "☠",    "name": "BOSS",    "colour": Color(0.85, 0.10, 0.30)},
	GFEnums.NodeKind.EVENT:   {"label": "?",    "name": "Event",   "colour": Color(0.45, 0.20, 0.50)},
	GFEnums.NodeKind.SHOP:    {"label": "$",    "name": "Shop",    "colour": Color(0.20, 0.40, 0.55)},
	GFEnums.NodeKind.SHRINE:  {"label": "△",    "name": "Shrine",  "colour": Color(0.55, 0.45, 0.20)},
	GFEnums.NodeKind.REST:    {"label": "z",    "name": "Rest",    "colour": Color(0.20, 0.55, 0.30)},
}

var _graph: MapGraph = null
var _pip_buttons: Dictionary = {}


func _ready() -> void:
	custom_minimum_size = Vector2(1080, 1700)
	GameState.chapter_started.connect(_on_chapter_started)
	GameState.map_node_entered.connect(_on_map_node_entered)
	GameState.gems_changed.connect(_on_gems_changed)
	GameState.hp_changed.connect(_on_hp_changed)
	if GameState.current_map_graph != null:
		_build(GameState.current_map_graph)


func _on_chapter_started(_chapter_num: int, graph: MapGraph) -> void:
	_build(graph)


func _on_map_node_entered(_node: MapNode) -> void:
	_repaint()


func _on_gems_changed(_amount: int) -> void:
	_refresh_hud()


func _on_hp_changed(_new_hp: int, _max_hp: int) -> void:
	_refresh_hud()


func _build(graph: MapGraph) -> void:
	_graph = graph
	for child in get_children():
		child.queue_free()
	_pip_buttons.clear()

	# Title.
	var title := Label.new()
	title.text = "The Gauntlet — 8 rounds"
	title.add_theme_font_size_override("font_size", 36)
	title.position = Vector2(40, 60)
	title.size = Vector2(1000, 50)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var sub := Label.new()
	sub.text = "Win all 8 in a row to claim victory. Each loss costs gems to retry."
	sub.add_theme_font_size_override("font_size", 18)
	sub.modulate = Color(1, 1, 1, 0.65)
	sub.position = Vector2(40, 120)
	sub.size = Vector2(1000, 30)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sub)

	# HUD: HP, Gems, Warlord, Seed.
	var hud := Label.new()
	hud.name = "Hud"
	hud.add_theme_font_size_override("font_size", 22)
	hud.position = Vector2(40, 170)
	hud.size = Vector2(1000, 60)
	hud.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(hud)

	# Sorted round order — by depth.
	var ordered: Array = []
	for d in range(graph.max_depth + 1):
		for n in graph.nodes_at_depth(d):
			ordered.append(n)

	# Pip strip layout — centred row, wraps to second row if needed.
	# 8 pips × (110+12) ≈ 976 — fits 1080-wide easily.
	var total_w: float = float(ordered.size()) * (PIP_SIZE + PIP_GAP) - PIP_GAP
	var x_start: float = (1080.0 - total_w) * 0.5
	for i in range(ordered.size()):
		var node: MapNode = ordered[i]
		var pip := _make_pip(node, i + 1)
		pip.position = Vector2(x_start + i * (PIP_SIZE + PIP_GAP), TOP_OFFSET)
		pip.size = Vector2(PIP_SIZE, PIP_SIZE * 1.3)
		add_child(pip)
		_pip_buttons[node.id] = pip

		# Connector line between pips.
		if i < ordered.size() - 1:
			var line := Line2D.new()
			var midY: float = TOP_OFFSET + PIP_SIZE * 0.5
			line.add_point(Vector2(x_start + i * (PIP_SIZE + PIP_GAP) + PIP_SIZE, midY))
			line.add_point(Vector2(x_start + (i + 1) * (PIP_SIZE + PIP_GAP), midY))
			line.default_color = Color(0.5, 0.5, 0.55)
			line.width = 3.0
			add_child(line)
			move_child(line, 0)

	# Legend across the bottom of the strip.
	var legend_y: float = TOP_OFFSET + PIP_SIZE * 1.3 + 40
	for i in range(ordered.size()):
		var node: MapNode = ordered[i]
		var label := Label.new()
		var style: Dictionary = KIND_STYLE.get(node.kind, {"name": "?"})
		label.text = String(style["name"])
		label.add_theme_font_size_override("font_size", 13)
		label.modulate = Color(1, 1, 1, 0.7)
		label.position = Vector2(x_start + i * (PIP_SIZE + PIP_GAP), legend_y)
		label.size = Vector2(PIP_SIZE, 20)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(label)

	_refresh_hud()
	_repaint()


func _make_pip(node: MapNode, round_num: int) -> Button:
	var style: Dictionary = KIND_STYLE.get(node.kind, {"label": "?", "colour": Color.WHITE})
	var btn := Button.new()
	btn.tooltip_text = "Round %d — %s" % [round_num, String(style.get("name", "?"))]

	var sb := StyleBoxFlat.new()
	sb.bg_color = style["colour"]
	sb.corner_radius_top_left = 16
	sb.corner_radius_top_right = 16
	sb.corner_radius_bottom_left = 16
	sb.corner_radius_bottom_right = 16
	sb.set_border_width_all(3)
	sb.border_color = Color(1, 1, 1, 0.4)
	btn.add_theme_stylebox_override("normal", sb)
	btn.text = ""
	btn.pressed.connect(func(): _on_pip_clicked(node.id))

	# Inner labels — populate after tree_entered.
	btn.tree_entered.connect(func(): _populate_pip(btn, node, round_num, style))

	return btn


func _populate_pip(btn: Button, node: MapNode, round_num: int, style: Dictionary) -> void:
	var rnd := Label.new()
	rnd.text = str(round_num)
	rnd.add_theme_font_size_override("font_size", 18)
	rnd.position = Vector2(6, 4)
	rnd.size = Vector2(40, 24)
	rnd.modulate = Color(1, 1, 1, 0.85)
	btn.add_child(rnd)

	var icon := Label.new()
	icon.text = String(style.get("label", "?"))
	icon.add_theme_font_size_override("font_size", 38)
	icon.position = Vector2(0, 32)
	icon.size = Vector2(PIP_SIZE, 70)
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	btn.add_child(icon)


func _repaint() -> void:
	if _graph == null:
		return
	# Determine reachable (next round) — for a linear gauntlet that's the
	# single child of the current node; or the start_id at run-start.
	var reachable_id: StringName = &""
	if _graph.nodes.has(GameState.current_node_id):
		var cur: MapNode = _graph.nodes[GameState.current_node_id]
		if cur.children.size() > 0:
			reachable_id = cur.children[0]
	if reachable_id == &"":
		reachable_id = _graph.start_id

	# Mark visited up to current.
	for nid in _pip_buttons:
		var btn: Button = _pip_buttons[nid]
		var is_current: bool = (nid == GameState.current_node_id)
		var is_reachable: bool = (nid == reachable_id)
		var is_visited: bool = is_current or _is_past(nid)

		btn.disabled = not is_reachable
		var alpha: float = 1.0
		if is_reachable:
			alpha = 1.0
		elif is_visited:
			alpha = 0.55
		else:
			alpha = 0.35
		btn.modulate = Color(1, 1, 1, alpha)
		if is_current:
			btn.modulate = Color(1.4, 1.4, 0.7, 1.0)
		if is_reachable:
			# Pulsing border via stylebox border colour.
			var sb := btn.get_theme_stylebox("normal") as StyleBoxFlat
			if sb != null:
				sb.border_color = Color(0.4, 1.0, 0.5, 0.95)


func _is_past(nid: StringName) -> bool:
	# Walk start → current; if nid is between start and current, it's past.
	if _graph == null or _graph.start_id == &"":
		return false
	var walker: StringName = _graph.start_id
	var seen_current: bool = false
	while walker != &"":
		if walker == GameState.current_node_id:
			seen_current = true
		if not seen_current and walker == nid:
			return true
		var node: MapNode = _graph.nodes.get(walker, null)
		if node == null or node.children.is_empty():
			break
		walker = node.children[0]
	return false


func _refresh_hud() -> void:
	var hud: Label = get_node_or_null("Hud")
	if hud == null:
		return
	hud.text = "%s   HP %d/%d   Gems: %d" % [
		String(GameState.active_warlord_id),
		GameState.base_hp, GameState.max_base_hp,
		GameState.gems
	]


func _on_pip_clicked(node_id: StringName) -> void:
	node_selected.emit(node_id)
