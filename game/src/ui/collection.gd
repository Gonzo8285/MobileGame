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
var _filter_type: int = -1                     ## -1 = all, else GFEnums.CardType
var _filter_rarity: int = -1                   ## -1 = all, else GFEnums.Rarity
var _filter_cost_bucket: int = -1              ## -1 = all, 0 = 0-2, 1 = 3-4, 2 = 5+
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

	# CO-4: type / rarity / cost dropdown filters.
	var filt := HBoxContainer.new()
	filt.add_theme_constant_override("separation", 10)
	root.add_child(filt)
	_add_dropdown(filt, [["All Types", -1], ["Units", GFEnums.CardType.UNIT],
			["Spells", GFEnums.CardType.SPELL], ["Traps", GFEnums.CardType.TRAP]],
			func(id: int): _filter_type = id)
	_add_dropdown(filt, [["All Rarities", -1], ["Common", GFEnums.Rarity.COMMON],
			["Uncommon", GFEnums.Rarity.UNCOMMON], ["Rare", GFEnums.Rarity.RARE]],
			func(id: int): _filter_rarity = id)
	_add_dropdown(filt, [["All Costs", -1], ["0-2", 0], ["3-4", 1], ["5+", 2]],
			func(id: int): _filter_cost_bucket = id)

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
		if _passes(c):
			out.append(c)
	return out


## CO-4: search + type/rarity/cost filter predicate.
func _passes(c: Card) -> bool:
	if _search != "" and not c.display_name.to_lower().contains(_search.to_lower()):
		return false
	if _filter_type != -1 and c.card_type != _filter_type:
		return false
	if _filter_rarity != -1 and c.rarity != _filter_rarity:
		return false
	if _filter_cost_bucket != -1 and _cost_bucket(c.cost) != _filter_cost_bucket:
		return false
	return true


func _cost_bucket(cost: int) -> int:
	if cost <= 2:
		return 0
	elif cost <= 4:
		return 1
	return 2


func _add_dropdown(parent: HBoxContainer, entries: Array, on_pick: Callable) -> void:
	var opt := OptionButton.new()
	for e in entries:
		opt.add_item(String(e[0]), int(e[1]))
	opt.add_theme_font_size_override("font_size", 18)
	opt.item_selected.connect(func(idx: int):
		on_pick.call(opt.get_item_id(idx))
		_rebuild_grid())
	parent.add_child(opt)


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
	# CO-3: delegate to the shared reusable overlay.
	CardDetail.show_over(self, c)


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
