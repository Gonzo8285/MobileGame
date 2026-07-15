extends Control
class_name DeckBuilder

## Pre-run deck assembly (DB-3 logic + DB-4 UI). Faction-scoped to the active
## Warlord; produces a 20-card singleton deck (v0 rules) and hands it to
## GameState to start the run. Programmatic UI per the title.gd / map_view.gd
## convention (no fragile .tscn tree — built in code). Spec:
## DECKBUILDER_SPEC_2026-06-01.md.
##
## The deck MODEL (add/remove/filter/auto-fill/clear + id output) is UI-agnostic
## and exercised headless by deck_builder_test.gd (DB-6); the UI refreshers all
## no-op when their nodes are null so the model is testable without a viewport.

const DECK_SIZE := 20
const MAX_COPIES := 1                          ## v0 singleton; raise for v1 multi-copy

# ---- Model state -----------------------------------------------------------
var _faction: int = GFEnums.Faction.NEUTRAL
var _warlord_id: StringName = &""
var _available: Array[Card] = []               ## draftable pool for faction (+ Neutral)
var _deck: Dictionary = {}                     ## StringName id -> int count
var _filter_type: int = -1                     ## -1 = all; else GFEnums.CardType
var _search: String = ""

# ---- UI references (built in _build_ui; null in headless tests) ------------
var _count_label: Label = null
var _validation_label: Label = null
var _collection_grid: GridContainer = null
var _deck_list: VBoxContainer = null
var _start_btn: Button = null
var _filter_group: ButtonGroup = ButtonGroup.new()


## Call before adding to the tree: which Warlord/faction this builder serves.
func setup(warlord_id: StringName, faction: int) -> void:
	_warlord_id = warlord_id
	_faction = faction
	# If the UI is already built (setup called after _ready), re-resolve the pool
	# for the new faction. With the RunController/test path setup runs BEFORE
	# add_child, so _ready does the initial load with the right faction.
	if _collection_grid != null:
		_reload_pool()


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	_build_ui()
	_reload_pool()


func _reload_pool() -> void:
	_available = CardDatabase.draftable_for([_faction, GFEnums.Faction.NEUTRAL])
	_refresh_all()


# ============================================================================
# Deck model (DB-3) — pure logic, no UI dependency
# ============================================================================

func _deck_count() -> int:
	var n := 0
	for c in _deck.values():
		n += int(c)
	return n


func _can_add(card: Card) -> bool:
	if card == null:
		return false
	return _deck_count() < DECK_SIZE and int(_deck.get(card.id, 0)) < MAX_COPIES


func _add(card: Card) -> void:
	if _can_add(card):
		_deck[card.id] = int(_deck.get(card.id, 0)) + 1
		_refresh_all()


func _remove(id: StringName) -> void:
	if _deck.has(id):
		_deck[id] = int(_deck[id]) - 1
		if int(_deck[id]) <= 0:
			_deck.erase(id)
		_refresh_all()


func _passes_filter(c: Card) -> bool:
	if _filter_type != -1 and c.card_type != _filter_type:
		return false
	if _search != "" and not c.display_name.to_lower().contains(_search.to_lower()):
		return false
	return true


## Deck ids sorted by cost then name — stable display + output order.
func _sorted_deck_ids() -> Array:
	var ids := _deck.keys()
	ids.sort_custom(func(a, b):
		var ca: Card = CardDatabase.get_by_id(a)
		var cb: Card = CardDatabase.get_by_id(b)
		if ca == null or cb == null:
			return false
		return ca.cost < cb.cost if ca.cost != cb.cost else ca.display_name < cb.display_name)
	return ids


## Ordered id list, expanding copy counts (singleton -> one id each).
func _deck_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for id in _sorted_deck_ids():
		for _i in range(int(_deck[id])):
			ids.append(id)
	return ids


func _autofill() -> void:
	_deck.clear()
	# Bias toward a playable curve: UNITs first, then top up with anything.
	for c in _available:
		if _deck_count() >= DECK_SIZE:
			break
		if c.card_type == GFEnums.CardType.UNIT and int(_deck.get(c.id, 0)) < MAX_COPIES:
			_deck[c.id] = 1
	for c in _available:
		if _deck_count() >= DECK_SIZE:
			break
		if int(_deck.get(c.id, 0)) < MAX_COPIES:
			_deck[c.id] = 1
	_refresh_all()


func _clear() -> void:
	_deck.clear()
	_refresh_all()


## DB-7: fill the deck from GameState.last_deck_ids, keeping only cards draftable
## for this faction (skips off-faction / unknown ids, and stops at DECK_SIZE).
func _use_last_deck() -> void:
	_deck.clear()
	for id in GameState.last_deck_ids:
		var card: Card = CardDatabase.get_by_id(id)
		if card != null and _is_available(card) and _can_add(card):
			_deck[card.id] = int(_deck.get(card.id, 0)) + 1
	_refresh_all()


func _is_available(card: Card) -> bool:
	for c in _available:
		if c.id == card.id:
			return true
	return false


func _on_start() -> void:
	if _deck_count() != DECK_SIZE:
		return
	var ids := _deck_ids()
	GameState.set_last_deck(ids)
	GameState.start_run_from_ids(ids, _warlord_id, 0)  # 0 = random seed
	GameState.enter_chapter(1)


func _on_back() -> void:
	# Route back through the RunController scene router (WL-4). NOT
	# change_scene_to_file — the builder is RunController's child, so that would
	# replace RunController itself. Back → Warlord select.
	GameState.request_warlord_select()


# ============================================================================
# UI (DB-4) — programmatic, built once in _ready
# ============================================================================

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
	root.add_theme_constant_override("separation", 16)
	add_child(root)

	# ---- Top bar: Back | title | count ------------------------------------
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 16)
	root.add_child(top)
	var back := Button.new()
	back.text = "◀ Back"
	back.add_theme_font_size_override("font_size", 26)
	back.pressed.connect(_on_back)
	top.add_child(back)
	var title := Label.new()
	title.text = "Build your deck — %s" % _faction_name(_faction)
	title.add_theme_font_size_override("font_size", 30)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	top.add_child(title)
	_count_label = Label.new()
	_count_label.add_theme_font_size_override("font_size", 30)
	top.add_child(_count_label)

	# ---- Filter chips + search -------------------------------------------
	var filt := HBoxContainer.new()
	filt.add_theme_constant_override("separation", 10)
	root.add_child(filt)
	_add_filter_chip(filt, "All", -1)
	_add_filter_chip(filt, "Units", GFEnums.CardType.UNIT)
	_add_filter_chip(filt, "Spells", GFEnums.CardType.SPELL)
	_add_filter_chip(filt, "Traps", GFEnums.CardType.TRAP)
	var search := LineEdit.new()
	search.placeholder_text = "Search…"
	search.add_theme_font_size_override("font_size", 24)
	search.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	search.text_changed.connect(func(t): _search = t; _rebuild_collection())
	filt.add_child(search)

	# ---- Middle: collection grid (left) | deck list (right) --------------
	var mid := HBoxContainer.new()
	mid.add_theme_constant_override("separation", 16)
	mid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(mid)

	var coll_scroll := ScrollContainer.new()
	coll_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	coll_scroll.size_flags_stretch_ratio = 2.0
	coll_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	mid.add_child(coll_scroll)
	_collection_grid = GridContainer.new()
	_collection_grid.columns = 4
	_collection_grid.add_theme_constant_override("h_separation", 10)
	_collection_grid.add_theme_constant_override("v_separation", 10)
	_collection_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	coll_scroll.add_child(_collection_grid)

	var deck_panel := VBoxContainer.new()
	deck_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	deck_panel.size_flags_stretch_ratio = 1.1
	mid.add_child(deck_panel)
	var deck_hdr := Label.new()
	deck_hdr.text = "Your deck"
	deck_hdr.add_theme_font_size_override("font_size", 24)
	deck_panel.add_child(deck_hdr)
	var deck_scroll := ScrollContainer.new()
	deck_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	deck_panel.add_child(deck_scroll)
	_deck_list = VBoxContainer.new()
	_deck_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	deck_scroll.add_child(_deck_list)

	# ---- Bottom bar: Auto-fill | Clear | validation | Start --------------
	var bottom := HBoxContainer.new()
	bottom.add_theme_constant_override("separation", 16)
	root.add_child(bottom)
	var auto := Button.new()
	auto.text = "Auto-fill"
	auto.add_theme_font_size_override("font_size", 26)
	auto.pressed.connect(_autofill)
	bottom.add_child(auto)
	var clear := Button.new()
	clear.text = "Clear"
	clear.add_theme_font_size_override("font_size", 26)
	clear.pressed.connect(_clear)
	bottom.add_child(clear)
	var last := Button.new()
	last.text = "Use Last"
	last.add_theme_font_size_override("font_size", 26)
	last.disabled = GameState.last_deck_ids.is_empty()
	last.pressed.connect(_use_last_deck)
	bottom.add_child(last)
	_validation_label = Label.new()
	_validation_label.add_theme_font_size_override("font_size", 22)
	_validation_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_validation_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bottom.add_child(_validation_label)
	_start_btn = Button.new()
	_start_btn.text = "Start Run ▶"
	_start_btn.add_theme_font_size_override("font_size", 28)
	_start_btn.pressed.connect(_on_start)
	bottom.add_child(_start_btn)


func _add_filter_chip(parent: HBoxContainer, label: String, type_val: int) -> void:
	var b := Button.new()
	b.text = label
	b.toggle_mode = true
	b.button_group = _filter_group
	b.button_pressed = (type_val == _filter_type)
	b.add_theme_font_size_override("font_size", 22)
	b.pressed.connect(func():
		_filter_type = type_val
		_rebuild_collection())
	parent.add_child(b)


func _rebuild_collection() -> void:
	if _collection_grid == null:
		return
	for child in _collection_grid.get_children():
		child.queue_free()
	for c in _available:
		if not _passes_filter(c):
			continue
		_collection_grid.add_child(_make_card_tile(c))


func _refresh_deck_panel() -> void:
	if _deck_list != null:
		for child in _deck_list.get_children():
			child.queue_free()
		for id in _sorted_deck_ids():
			var c: Card = CardDatabase.get_by_id(id)
			if c != null:
				_deck_list.add_child(_make_deck_row(c, int(_deck[id])))
	if _count_label != null:
		_count_label.text = "%d / %d" % [_deck_count(), DECK_SIZE]
	if _start_btn != null:
		_start_btn.disabled = _deck_count() != DECK_SIZE
	_refresh_validation()


func _refresh_validation() -> void:
	if _validation_label == null:
		return
	var n := _deck_count()
	if n < DECK_SIZE:
		_validation_label.text = "Need %d more" % (DECK_SIZE - n)
		_validation_label.modulate = Color(1, 0.82, 0.4)
	else:
		_validation_label.text = "%d / %d — ready" % [DECK_SIZE, DECK_SIZE]
		_validation_label.modulate = Color(0.5, 1, 0.5)


func _refresh_all() -> void:
	_rebuild_collection()
	_refresh_deck_panel()


# ---- Tiles / rows ----------------------------------------------------------

func _make_card_tile(c: Card) -> Control:
	var tile := Button.new()
	tile.custom_minimum_size = Vector2(168, 210)
	tile.clip_text = true
	var stats := ""
	if c.card_type == GFEnums.CardType.UNIT:
		stats = "\nATK %d / HP %d" % [c.attack, c.hp]
	tile.text = "[%d]  %s\n%s%s" % [c.cost, c.display_name, _type_short(c.card_type), stats]
	var in_deck := int(_deck.get(c.id, 0)) > 0
	var sb := StyleBoxFlat.new()
	sb.bg_color = _faction_tint(c.faction)
	sb.set_border_width_all(3)
	sb.border_color = Color(0.95, 0.8, 0.35) if in_deck else Color(1, 1, 1, 0.22)
	sb.set_corner_radius_all(10)
	sb.set_content_margin_all(8)
	tile.add_theme_stylebox_override("normal", sb)
	tile.add_theme_stylebox_override("hover", sb)
	tile.add_theme_stylebox_override("pressed", sb)
	tile.disabled = (not in_deck) and (not _can_add(c))
	tile.pressed.connect(func(): _add(c))
	return tile


func _make_deck_row(c: Card, count: int) -> Control:
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var lbl := Label.new()
	var cnt := "" if count <= 1 else "  x%d" % count
	lbl.text = "[%d]  %s%s" % [c.cost, c.display_name, cnt]
	lbl.add_theme_font_size_override("font_size", 20)
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.clip_text = true
	row.add_child(lbl)
	var rm := Button.new()
	rm.text = "–"
	rm.add_theme_font_size_override("font_size", 22)
	rm.pressed.connect(func(): _remove(c.id))
	row.add_child(rm)
	return row


# ---- Cosmetic helpers ------------------------------------------------------

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
