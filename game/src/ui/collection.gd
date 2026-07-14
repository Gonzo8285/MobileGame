extends Control
class_name Collection

## Collection / Codex (A3) — read-only gallery of every card. Reuses CardDatabase
## (all_cards / by_faction / counts_by_faction). Never writes game state, no
## monetisation hooks (anti-P2W). Programmatic UI (title.gd convention).
## Spec: COLLECTION_SPEC_2026-06-01.md.
##
## The detail overlay (§4) is built in-code here for v0; DB-7's long-press zoom
## can later extract it to a shared scenes/card_detail.tscn.

const _FACTIONS := [
	GFEnums.Faction.IRON_PENITENTS, GFEnums.Faction.ASH_MOURNERS, GFEnums.Faction.COVEN,
	GFEnums.Faction.LAST_LEGION, GFEnums.Faction.SKINWARD_PACT, GFEnums.Faction.NEUTRAL,
]
const _KEYWORD_BLURBS := {
	"LIFESTEAL": "On a successful attack, heal the attacker for the damage dealt.",
	"TAUNT": "Enemies sharing this tile strike this unit before any other.",
	"CLEAVE": "Attack damage splashes to adjacent enemies.",
	"PIERCE": "Attacks ignore a portion of the target's defence.",
	"BLEED": "Target suffers stacking damage over following turns.",
	"POISON": "Target suffers stacking damage each turn.",
	"SHIELD": "Absorbs the next instance of incoming damage.",
	"SUMMON": "Spawns one or more token units into the lane.",
	"FEAR": "Afflicted enemy may fail to act while feared.",
	"RESURRECT": "Returns a fallen unit to the lane.",
	"SACRIFICE": "Consumes a friendly unit to power the effect.",
	"PERSIST": "Survives where it would normally be removed.",
}

var _active_faction: int = -1                  ## -1 = All
var _search: String = ""
var _grid: GridContainer = null
var _count_label: Label = null


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	_build_ui()
	_rebuild_grid()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	bg.color = Color(0.05, 0.05, 0.08, 1)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var root := VBoxContainer.new()
	root.anchor_right = 1.0
	root.anchor_bottom = 1.0
	root.offset_left = 24
	root.offset_top = 24
	root.offset_right = -24
	root.offset_bottom = -24
	root.add_theme_constant_override("separation", 14)
	add_child(root)

	# Header: Back | COLLECTION | count
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 16)
	root.add_child(top)
	var back := Button.new()
	back.text = "◀ Back"
	back.add_theme_font_size_override("font_size", 26)
	back.pressed.connect(func(): GameState.request_title())
	top.add_child(back)
	var title := Label.new()
	title.text = "COLLECTION"
	title.add_theme_font_size_override("font_size", 32)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	top.add_child(title)
	_count_label = Label.new()
	_count_label.add_theme_font_size_override("font_size", 26)
	top.add_child(_count_label)

	# Faction tabs (All + 6).
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 8)
	root.add_child(tabs)
	var tab_group := ButtonGroup.new()
	_add_tab(tabs, tab_group, "All", -1)
	for f in _FACTIONS:
		_add_tab(tabs, tab_group, _faction_short(f), f)

	# Search.
	var search := LineEdit.new()
	search.placeholder_text = "Search…"
	search.add_theme_font_size_override("font_size", 22)
	search.text_changed.connect(func(t): _search = t; _rebuild_grid())
	root.add_child(search)

	# Scrollable grid.
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_child(scroll)
	_grid = GridContainer.new()
	_grid.columns = 5
	_grid.add_theme_constant_override("h_separation", 10)
	_grid.add_theme_constant_override("v_separation", 10)
	_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_grid)


func _add_tab(parent: HBoxContainer, group: ButtonGroup, label: String, faction: int) -> void:
	var b := Button.new()
	b.text = label
	b.toggle_mode = true
	b.button_group = group
	b.button_pressed = (faction == _active_faction)
	b.add_theme_font_size_override("font_size", 20)
	b.pressed.connect(func():
		_active_faction = faction
		_rebuild_grid())
	parent.add_child(b)


func _cards_in_view() -> Array:
	var src: Array = CardDatabase.all_cards() if _active_faction == -1 \
			else CardDatabase.by_faction(_active_faction)
	var out: Array = []
	for c in src:
		if _search != "" and not c.display_name.to_lower().contains(_search.to_lower()):
			continue
		out.append(c)
	return out


func _rebuild_grid() -> void:
	if _grid == null:
		return
	for child in _grid.get_children():
		child.queue_free()
	var cards := _cards_in_view()
	for c in cards:
		_grid.add_child(_make_tile(c))
	if _count_label != null:
		_count_label.text = "%d" % cards.size()


func _make_tile(c: Card) -> Control:
	var tile := Button.new()
	tile.custom_minimum_size = Vector2(168, 200)
	tile.clip_text = true
	var badge := ""
	if not c.is_draftable:
		badge = "  [Token/Relic]"
	var stats := ""
	if c.card_type == GFEnums.CardType.UNIT:
		stats = "\nATK %d / HP %d" % [c.attack, c.hp]
	tile.text = "[%d]  %s%s\n%s%s" % [c.cost, c.display_name, badge, _type_short(c.card_type), stats]
	var sb := StyleBoxFlat.new()
	sb.bg_color = _faction_tint(c.faction)
	sb.set_border_width_all(2)
	sb.border_color = Color(1, 1, 1, 0.2)
	sb.set_corner_radius_all(10)
	sb.set_content_margin_all(8)
	tile.add_theme_stylebox_override("normal", sb)
	tile.add_theme_stylebox_override("hover", sb)
	tile.add_theme_stylebox_override("pressed", sb)
	tile.pressed.connect(func(): _show_detail(c))
	return tile


## Full-screen detail overlay for one card. Read-only. Public so a headless test
## (and DB-7's zoom) can invoke it.
func _show_detail(c: Card) -> void:
	if c == null:
		return
	var overlay := Panel.new()
	overlay.name = "DetailOverlay"
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	var osb := StyleBoxFlat.new()
	osb.bg_color = Color(0.03, 0.03, 0.05, 0.97)
	overlay.add_theme_stylebox_override("panel", osb)
	add_child(overlay)

	var box := VBoxContainer.new()
	box.anchor_right = 1.0
	box.anchor_bottom = 1.0
	box.offset_left = 60
	box.offset_top = 60
	box.offset_right = -60
	box.offset_bottom = -60
	box.add_theme_constant_override("separation", 14)
	overlay.add_child(box)

	var name_lbl := Label.new()
	name_lbl.text = c.display_name
	name_lbl.add_theme_font_size_override("font_size", 40)
	name_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	box.add_child(name_lbl)

	var meta := Label.new()
	meta.text = "%s · %s · cost %d" % [_faction_name(c.faction), _rarity_name(c.rarity), c.cost]
	meta.add_theme_font_size_override("font_size", 24)
	meta.modulate = Color(1, 1, 1, 0.8)
	box.add_child(meta)

	if c.card_type == GFEnums.CardType.UNIT:
		var stats := Label.new()
		stats.text = "HP %d   ATK %d   Range %s   Cooldown %d" % [
			c.hp, c.attack, _range_short(c.attack_range), c.cooldown]
		stats.add_theme_font_size_override("font_size", 24)
		box.add_child(stats)

	if not c.keywords.is_empty():
		var kw_names: Array[String] = []
		for kw in c.keywords:
			var n: String = String(GFEnums.Keyword.keys()[kw]) if kw >= 0 and kw < GFEnums.Keyword.size() else "?"
			kw_names.append(n)
		var kw_lbl := Label.new()
		kw_lbl.text = "Keywords: " + ", ".join(kw_names)
		kw_lbl.add_theme_font_size_override("font_size", 22)
		kw_lbl.modulate = Color(0.9, 0.8, 0.4)
		kw_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
		box.add_child(kw_lbl)
		# Blurbs for known keywords.
		for n in kw_names:
			if _KEYWORD_BLURBS.has(n):
				var blurb := Label.new()
				blurb.text = "  • %s — %s" % [n, _KEYWORD_BLURBS[n]]
				blurb.add_theme_font_size_override("font_size", 18)
				blurb.modulate = Color(1, 1, 1, 0.7)
				blurb.autowrap_mode = TextServer.AUTOWRAP_WORD
				box.add_child(blurb)

	if c.effect_text != "":
		var eff := Label.new()
		eff.text = c.effect_text
		eff.add_theme_font_size_override("font_size", 22)
		eff.autowrap_mode = TextServer.AUTOWRAP_WORD
		box.add_child(eff)

	if c.flavour_text != "":
		var flav := Label.new()
		flav.text = c.flavour_text
		flav.add_theme_font_size_override("font_size", 18)
		flav.modulate = Color(0.75, 0.75, 0.8)
		flav.autowrap_mode = TextServer.AUTOWRAP_WORD
		box.add_child(flav)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(spacer)

	var close := Button.new()
	close.text = "Close"
	close.add_theme_font_size_override("font_size", 26)
	close.pressed.connect(overlay.queue_free)
	box.add_child(close)


# ---- Cosmetic helpers ------------------------------------------------------

func _faction_short(f: int) -> String:
	match f:
		GFEnums.Faction.IRON_PENITENTS: return "Iron"
		GFEnums.Faction.ASH_MOURNERS: return "Ash"
		GFEnums.Faction.COVEN: return "Coven"
		GFEnums.Faction.LAST_LEGION: return "Legion"
		GFEnums.Faction.SKINWARD_PACT: return "Skin"
		GFEnums.Faction.NEUTRAL: return "Neut"
		_: return "?"


func _faction_name(f: int) -> String:
	match f:
		GFEnums.Faction.IRON_PENITENTS: return "Iron Penitents"
		GFEnums.Faction.ASH_MOURNERS: return "Ash-Mourners"
		GFEnums.Faction.COVEN: return "Coven of the Black Mire"
		GFEnums.Faction.LAST_LEGION: return "The Last Legion"
		GFEnums.Faction.SKINWARD_PACT: return "Skinward Pact"
		_: return "Neutral"


func _faction_tint(f: int) -> Color:
	match f:
		GFEnums.Faction.IRON_PENITENTS: return Color(0.40, 0.14, 0.14)
		GFEnums.Faction.ASH_MOURNERS: return Color(0.22, 0.18, 0.30)
		GFEnums.Faction.COVEN: return Color(0.14, 0.32, 0.22)
		GFEnums.Faction.LAST_LEGION: return Color(0.36, 0.30, 0.18)
		GFEnums.Faction.SKINWARD_PACT: return Color(0.24, 0.18, 0.12)
		_: return Color(0.18, 0.18, 0.20)


func _type_short(t: int) -> String:
	match t:
		GFEnums.CardType.UNIT: return "Unit"
		GFEnums.CardType.SPELL: return "Spell"
		GFEnums.CardType.TRAP: return "Trap"
		_: return "?"


func _rarity_name(r: int) -> String:
	var keys := GFEnums.Rarity.keys()
	return String(keys[r]).capitalize() if r >= 0 and r < keys.size() else "?"


func _range_short(r: int) -> String:
	match r:
		GFEnums.AttackRange.MELEE: return "Melee"
		GFEnums.AttackRange.SHORT: return "Short"
		GFEnums.AttackRange.LONG: return "Long"
		_: return "—"
