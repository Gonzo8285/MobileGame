extends Control
class_name MapView

## MapView (BM-4) — branching chapter map. Lays the MapGraph out as depth rows
## (START at top → BOSS at bottom), draws the edges, and shows an encounter
## symbol on each combat/elite node so the player can read the threat and pick a
## route. Reachable = every child of the current node; tapping a reachable node
## advances. Graph-driven, so it also renders the legacy linear graph fine.

signal node_selected(node_id: StringName)

const NODE_SIZE: float = 92.0
const TOP: float = 235.0
const ROW_H: float = 116.0
const MARGIN_X: float = 100.0

const KIND_STYLE: Dictionary = {
	GFEnums.NodeKind.COMBAT:  {"label": "⚔",   "name": "Combat", "colour": Color(0.45, 0.20, 0.20)},
	GFEnums.NodeKind.ELITE:   {"label": "⚔⚔", "name": "Elite",  "colour": Color(0.72, 0.20, 0.20)},
	GFEnums.NodeKind.HORDE:   {"label": "✦✦", "name": "Horde",  "colour": Color(0.55, 0.40, 0.15)},
	GFEnums.NodeKind.BOSS:    {"label": "☠",   "name": "BOSS",   "colour": Color(0.85, 0.10, 0.30)},
	GFEnums.NodeKind.EVENT:   {"label": "?",   "name": "Event",  "colour": Color(0.42, 0.20, 0.50)},
	GFEnums.NodeKind.SHOP:    {"label": "$",   "name": "Shop",   "colour": Color(0.20, 0.40, 0.55)},
	GFEnums.NodeKind.SHRINE:  {"label": "△",   "name": "Shrine", "colour": Color(0.52, 0.45, 0.20)},
	GFEnums.NodeKind.REST:    {"label": "z",   "name": "Rest",   "colour": Color(0.20, 0.55, 0.30)},
}

var _graph: MapGraph = null
var _node_buttons: Dictionary = {}
var _positions: Dictionary = {}
var _visited: Dictionary = {}


func _ready() -> void:
	custom_minimum_size = Vector2(1080, 1720)
	GameState.chapter_started.connect(_on_chapter_started)
	GameState.map_node_entered.connect(_on_map_node_entered)
	GameState.gems_changed.connect(_on_gems_changed)
	GameState.hp_changed.connect(_on_hp_changed)
	if GameState.current_map_graph != null:
		_build(GameState.current_map_graph)


func _on_chapter_started(_chapter_num: int, graph: MapGraph) -> void:
	_visited.clear()
	_build(graph)


func _on_map_node_entered(node: MapNode) -> void:
	if node != null:
		_visited[node.id] = true
	_repaint()


func _on_gems_changed(_amount: int) -> void:
	_refresh_hud()


func _on_hp_changed(_new_hp: int, _max_hp: int) -> void:
	_refresh_hud()


# ============================================================================
# Build
# ============================================================================

func _build(graph: MapGraph) -> void:
	_graph = graph
	for child in get_children():
		child.queue_free()
	_node_buttons.clear()
	_positions.clear()

	var title := Label.new()
	title.text = "Chapter Map"
	title.add_theme_font_size_override("font_size", 34)
	title.position = Vector2(40, 40)
	title.size = Vector2(1000, 46)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var sub := Label.new()
	sub.text = "Choose a route to the boss. Symbols show what you'll fight."
	sub.add_theme_font_size_override("font_size", 18)
	sub.modulate = Color(1, 1, 1, 0.65)
	sub.position = Vector2(40, 92)
	sub.size = Vector2(1000, 28)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sub)

	var hud := Label.new()
	hud.name = "Hud"
	hud.add_theme_font_size_override("font_size", 22)
	hud.position = Vector2(40, 150)
	hud.size = Vector2(1000, 40)
	hud.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(hud)

	# 1. Position every node by depth row + horizontal spread.
	var max_d: int = graph.max_depth
	for d in range(max_d + 1):
		var row: Array[MapNode] = graph.nodes_at_depth(d)
		var n: int = row.size()
		for i in range(n):
			var cx: float = MARGIN_X + (float(i) + 0.5) / float(n) * (1080.0 - 2.0 * MARGIN_X)
			var cy: float = TOP + float(d) * ROW_H
			_positions[row[i].id] = Vector2(cx, cy)

	# 2. Edges (drawn first so nodes sit on top).
	for nid in graph.nodes:
		var node: MapNode = graph.nodes[nid]
		var from: Vector2 = _positions.get(nid, Vector2.ZERO)
		for cid in node.children:
			if not _positions.has(cid):
				continue
			var line := Line2D.new()
			line.add_point(from)
			line.add_point(_positions[cid])
			line.default_color = Color(0.40, 0.40, 0.52, 0.6)
			line.width = 3.0
			add_child(line)

	# 3. Node buttons on top.
	for nid in graph.nodes:
		var node: MapNode = graph.nodes[nid]
		var center: Vector2 = _positions[nid]
		var btn := _make_node_button(node)
		btn.position = center - Vector2(NODE_SIZE * 0.5, NODE_SIZE * 0.5)
		btn.size = Vector2(NODE_SIZE, NODE_SIZE)
		add_child(btn)
		_node_buttons[nid] = btn

	_build_legend(max_d)
	_refresh_hud()
	_repaint()


func _make_node_button(node: MapNode) -> Button:
	var style: Dictionary = KIND_STYLE.get(node.kind, {"label": "?", "name": "?", "colour": Color.WHITE})
	var glyph: String = String(style.get("label", "?"))
	var info_name: String = String(style.get("name", "?"))
	var blurb: String = ""
	# Combat/elite nodes show the encounter symbol + telegraph instead of ⚔.
	if node.encounter_id != &"":
		var arch: EncounterArchetype = EncounterArchetype.get_archetype(node.encounter_id)
		if arch != null:
			glyph = arch.symbol
			info_name = arch.display_name
			blurb = arch.blurb

	var btn := Button.new()
	btn.tooltip_text = info_name if blurb == "" else "%s\n%s" % [info_name, blurb]
	var sb := StyleBoxFlat.new()
	sb.bg_color = style.get("colour", Color.WHITE)
	sb.set_corner_radius_all(14)
	sb.set_border_width_all(3)
	sb.border_color = Color(1, 1, 1, 0.4)
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_stylebox_override("hover", sb)
	btn.add_theme_stylebox_override("disabled", sb)
	btn.pressed.connect(func(): node_selected.emit(node.id))
	btn.tree_entered.connect(func(): _populate_node(btn, glyph))
	return btn


func _populate_node(btn: Button, glyph: String) -> void:
	var icon := Label.new()
	icon.text = glyph
	icon.add_theme_font_size_override("font_size", 34)
	icon.anchor_right = 1.0
	icon.anchor_bottom = 1.0
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(icon)


func _build_legend(max_d: int) -> void:
	var y: float = TOP + float(max_d + 1) * ROW_H + 6.0
	var parts: Array[String] = []
	for aid in EncounterArchetype.ids():
		var a: EncounterArchetype = EncounterArchetype.get_archetype(aid)
		if a != null:
			parts.append("%s %s" % [a.symbol, a.display_name])
	var legend := Label.new()
	legend.text = "Encounters:  " + "   ·   ".join(parts)
	legend.add_theme_font_size_override("font_size", 15)
	legend.modulate = Color(1, 1, 1, 0.6)
	legend.position = Vector2(40, y)
	legend.size = Vector2(1000, 60)
	legend.autowrap_mode = TextServer.AUTOWRAP_WORD
	legend.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(legend)


# ============================================================================
# Repaint — current / reachable / visited state
# ============================================================================

func _repaint() -> void:
	if _graph == null:
		return
	var cur: StringName = GameState.current_node_id
	var reachable: Dictionary = {}
	if _graph.nodes.has(cur):
		for cid in (_graph.nodes[cur] as MapNode).children:
			reachable[cid] = true
	elif _graph.start_id != &"":
		reachable[_graph.start_id] = true

	for nid in _node_buttons:
		var btn: Button = _node_buttons[nid]
		var is_cur: bool = (nid == cur)
		var is_reach: bool = reachable.has(nid)
		var is_visited: bool = _visited.has(nid) or is_cur

		btn.disabled = not is_reach
		if is_cur:
			btn.modulate = Color(1.45, 1.45, 0.7, 1.0)
		elif is_reach:
			btn.modulate = Color(1, 1, 1, 1.0)
		elif is_visited:
			btn.modulate = Color(1, 1, 1, 0.55)
		else:
			btn.modulate = Color(1, 1, 1, 0.32)

		var sb := btn.get_theme_stylebox("normal") as StyleBoxFlat
		if sb != null:
			sb.border_color = Color(0.4, 1.0, 0.5, 0.95) if is_reach else Color(1, 1, 1, 0.4)


func _refresh_hud() -> void:
	var hud: Label = get_node_or_null("Hud")
	if hud == null:
		return
	hud.text = "%s   HP %d/%d   Gems: %d" % [
		String(GameState.active_warlord_id),
		GameState.base_hp, GameState.max_base_hp, GameState.gems]
