extends Control
class_name CardView

## CardView (B2.6 UI + IMV-1 visual pass) — visual representation of one
## card in hand with playability cues.
##
## Holds a Card resource reference. Renders name + prominent cost orb +
## stats + faction-coloured background. Listens to GameState.mana_changed
## to dim itself when the player can't afford it. Implements Godot's
## drag-and-drop API for placement on lanes.
##
## Visuals are still placeholder (no art). What changed in IMV-1:
##   - Cost is now a big orb instead of a tiny label
##   - Faction tint + 2px border for quick identification
##   - Dim + red cost when unplayable; bright + amber when playable
##   - Range indicator (M/S/L) on UNITs

signal play_attempted(result: Dictionary)
signal consumed

@export var card_data: Card = null

const CARD_WIDTH: float = 200.0
const CARD_HEIGHT: float = 280.0

@onready var name_label: Label = $NameLabel
@onready var cost_label: Label = $CostLabel  ## kept for back-compat, hidden in IMV-1
@onready var type_label: Label = $TypeLabel
@onready var stats_label: Label = $StatsLabel
@onready var bg: ColorRect = $BG

# IMV-1 visual additions, built in _ready (no .tscn edit needed):
var _cost_orb: Panel = null
var _cost_orb_label: Label = null
var _border: Panel = null
var _effect_label: Label = null
var _range_label: Label = null
# B3 art pass: portrait + a legibility scrim behind the text. Falls back to
# the faction-tint `bg` when art_path is empty OR the texture isn't imported
# yet (safe before the Godot asset-import handoff is done).
var _art: TextureRect = null
var _scrim: ColorRect = null
# B3 icon pass: brass keyword glyphs (bottom strip) + stat glyphs. All
# load res://assets/icons/*.svg; if an icon isn't imported yet they no-op
# and the existing text labels stay (safe before the Godot-import handoff).
var _kw_strip: HBoxContainer = null
var _stat_row: HBoxContainer = null
const _ICON_DIR := "res://assets/icons/"
# GFEnums.Keyword order -> icon file stem (1:1 with fetch_icons.py keys).
const _KW_FILE := [
	"kw_cleave", "kw_pierce", "kw_bleed", "kw_poison", "kw_root", "kw_fear",
	"kw_shield", "kw_resurrect", "kw_summon", "kw_sacrifice", "kw_penance",
	"kw_dread", "kw_smoke", "kw_slow", "kw_persist", "kw_taunt",
]


func _icon_tex(stem: String) -> Texture2D:
	var p := _ICON_DIR + stem + ".svg"
	if ResourceLoader.exists(p):
		return load(p) as Texture2D
	return null

var _is_playable: bool = true
var _mana_cb: Callable


func _ready() -> void:
	custom_minimum_size = Vector2(CARD_WIDTH, CARD_HEIGHT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	# Children inherited from .tscn — turn off their mouse so clicks land on us.
	for child in get_children():
		if child is Control:
			(child as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Hide the legacy tiny cost label — we draw a proper orb instead.
	if cost_label != null:
		cost_label.modulate = Color(1, 1, 1, 0)

	_build_visuals()
	_refresh()
	_refresh_playability()

	# Subscribe to mana changes so playability dimming updates live.
	_mana_cb = Callable(self, "_on_mana_changed")
	if not GameState.mana_changed.is_connected(_mana_cb):
		GameState.mana_changed.connect(_mana_cb)

	# Hover preview: when mouse rests over the card, spawn a 2x-scaled
	# read-only popup near the top of the screen so the player can read
	# effect text without squinting. MTG Arena pattern.
	mouse_entered.connect(_on_card_hover_enter)
	mouse_exited.connect(_on_card_hover_exit)


func _exit_tree() -> void:
	if _mana_cb.is_valid() and GameState.mana_changed.is_connected(_mana_cb):
		GameState.mana_changed.disconnect(_mana_cb)
	_close_hover_preview()


# ============================================================================
# Hover preview popup (MTG Arena pattern)
# ============================================================================

var _hover_preview: CardView = null

func _on_card_hover_enter() -> void:
	if card_data == null or _hover_preview != null:
		return
	var viewport_root := get_tree().root
	if viewport_root == null:
		return
	var preview_scene: PackedScene = load("res://scenes/card_view.tscn")
	var preview: CardView = preview_scene.instantiate() as CardView
	preview.scale = Vector2(1.6, 1.6)
	preview.position = Vector2(540, 100)  # Top-centre of 1080-wide viewport
	preview.modulate = Color(1, 1, 1, 0.95)
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	viewport_root.add_child(preview)
	preview.bind(card_data)
	_hover_preview = preview


func _on_card_hover_exit() -> void:
	_close_hover_preview()


func _close_hover_preview() -> void:
	if _hover_preview != null and is_instance_valid(_hover_preview):
		_hover_preview.queue_free()
	_hover_preview = null


func bind(card: Card) -> void:
	card_data = card
	if is_inside_tree():
		_refresh()
		_refresh_playability()


# ============================================================================
# Visual build (constructed once on first _ready)
# ============================================================================

func _build_visuals() -> void:
	# Portrait — added first so it sits just above the faction-tint `bg`
	# but below the border / orb / text overlays. Hidden until a valid
	# texture is bound (placeholder `bg` shows through meanwhile).
	_art = TextureRect.new()
	_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_art.anchor_right = 1.0
	_art.anchor_bottom = 1.0
	_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_art.visible = false
	add_child(_art)

	# Dark gradient-ish scrim behind the lower text block so effect/name
	# stay legible over a busy portrait. Only shown when art is shown.
	_scrim = ColorRect.new()
	_scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_scrim.offset_left = 0
	_scrim.offset_top = 70
	_scrim.anchor_right = 1.0
	_scrim.anchor_bottom = 1.0
	_scrim.color = Color(0.02, 0.02, 0.03, 0.55)
	_scrim.visible = false
	add_child(_scrim)

	# 2px coloured border for faction identification + playable state.
	_border = Panel.new()
	_border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_border.anchor_right = 1.0
	_border.anchor_bottom = 1.0
	var border_sb := StyleBoxFlat.new()
	border_sb.bg_color = Color(0, 0, 0, 0)
	border_sb.set_border_width_all(3)
	border_sb.border_color = Color(1, 1, 1, 0.4)
	border_sb.corner_radius_top_left = 8
	border_sb.corner_radius_top_right = 8
	border_sb.corner_radius_bottom_left = 8
	border_sb.corner_radius_bottom_right = 8
	_border.add_theme_stylebox_override("panel", border_sb)
	add_child(_border)

	# Cost orb — big circle, top-left.
	_cost_orb = Panel.new()
	_cost_orb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cost_orb.offset_left = 8
	_cost_orb.offset_top = 8
	_cost_orb.offset_right = 64
	_cost_orb.offset_bottom = 64
	var orb_sb := StyleBoxFlat.new()
	orb_sb.bg_color = Color(0.92, 0.65, 0.20)  # warm amber for playable
	orb_sb.corner_radius_top_left = 28
	orb_sb.corner_radius_top_right = 28
	orb_sb.corner_radius_bottom_left = 28
	orb_sb.corner_radius_bottom_right = 28
	orb_sb.set_border_width_all(2)
	orb_sb.border_color = Color(0.2, 0.1, 0.0)
	_cost_orb.add_theme_stylebox_override("panel", orb_sb)
	add_child(_cost_orb)

	_cost_orb_label = Label.new()
	_cost_orb_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cost_orb_label.anchor_right = 1.0
	_cost_orb_label.anchor_bottom = 1.0
	_cost_orb_label.add_theme_font_size_override("font_size", 28)
	_cost_orb_label.add_theme_color_override("font_color", Color(0.05, 0.02, 0.0))
	_cost_orb_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cost_orb_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_cost_orb.add_child(_cost_orb_label)

	# Effect text (2-line snippet, middle of card).
	_effect_label = Label.new()
	_effect_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_effect_label.offset_left = 8
	_effect_label.offset_top = 80
	_effect_label.offset_right = 192
	_effect_label.offset_bottom = 220
	_effect_label.add_theme_font_size_override("font_size", 12)
	_effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	_effect_label.clip_text = true
	add_child(_effect_label)

	# Range indicator (small label, top-right).
	_range_label = Label.new()
	_range_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_range_label.offset_left = 150
	_range_label.offset_top = 12
	_range_label.offset_right = 192
	_range_label.offset_bottom = 40
	_range_label.add_theme_font_size_override("font_size", 16)
	_range_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.7))
	_range_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(_range_label)

	# Stat glyph row (ATK / HP / CD) — just above the keyword strip.
	_stat_row = HBoxContainer.new()
	_stat_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stat_row.offset_left = 8
	_stat_row.offset_top = 224
	_stat_row.offset_right = 192
	_stat_row.offset_bottom = 244
	_stat_row.add_theme_constant_override("separation", 10)
	add_child(_stat_row)

	# Keyword glyph strip — bottom edge.
	_kw_strip = HBoxContainer.new()
	_kw_strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_kw_strip.offset_left = 8
	_kw_strip.offset_top = 252
	_kw_strip.offset_right = 192
	_kw_strip.offset_bottom = 270
	_kw_strip.add_theme_constant_override("separation", 4)
	add_child(_kw_strip)


func _refresh() -> void:
	if card_data == null:
		name_label.text = "<empty>"
		if _cost_orb_label != null: _cost_orb_label.text = ""
		if _effect_label != null: _effect_label.text = ""
		if _range_label != null: _range_label.text = ""
		type_label.text = ""
		stats_label.text = ""
		return

	# Reposition name to clear the cost orb (top-right of the orb area).
	name_label.text = card_data.display_name
	name_label.offset_left = 72
	name_label.offset_top = 12
	name_label.offset_right = 192
	name_label.offset_bottom = 70
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	name_label.add_theme_font_size_override("font_size", 14)

	if _cost_orb_label != null:
		_cost_orb_label.text = "%d" % card_data.cost

	type_label.text = _type_label_for(card_data.card_type)
	if card_data.card_type == GFEnums.CardType.UNIT:
		stats_label.text = "ATK %d  HP %d" % [card_data.attack, card_data.hp]
		stats_label.add_theme_font_size_override("font_size", 14)
		if _range_label != null:
			_range_label.text = _range_short(card_data.attack_range)
	else:
		stats_label.text = ""
		if _range_label != null:
			_range_label.text = ""

	if _effect_label != null:
		_effect_label.text = card_data.effect_text

	bg.color = _faction_tint(card_data.faction)
	_refresh_art()
	_refresh_icons()


## Bind the portrait if the card has one AND it's actually importable.
## Any miss → hide art, fall back to the faction-tint placeholder (`bg`).
func _refresh_art() -> void:
	if _art == null:
		return
	var path: String = card_data.art_path if card_data != null else ""
	var tex: Texture2D = null
	if path != "" and ResourceLoader.exists(path):
		tex = load(path) as Texture2D
	if tex != null:
		_art.texture = tex
		_art.visible = true
		if _scrim != null:
			_scrim.visible = true
	else:
		_art.texture = null
		_art.visible = false
		if _scrim != null:
			_scrim.visible = false


## Build the stat + keyword glyph rows. Each glyph is a 22px brass SVG.
## If the icon set isn't imported yet every lookup returns null and the
## rows stay empty — the existing text labels (stats_label / effect_text)
## remain the source of truth, so this is safe pre-import.
func _refresh_icons() -> void:
	if _stat_row == null or _kw_strip == null or card_data == null:
		return
	for c in _stat_row.get_children():
		c.queue_free()
	for c in _kw_strip.get_children():
		c.queue_free()

	var drew_stats := false
	if card_data.card_type == GFEnums.CardType.UNIT:
		drew_stats = _add_stat(_stat_row, "stat_power", card_data.attack) or drew_stats
		drew_stats = _add_stat(_stat_row, "stat_health", card_data.hp) or drew_stats
		if card_data.cooldown > 0:
			drew_stats = _add_stat(_stat_row, "stat_cooldown", card_data.cooldown) or drew_stats
		var rng := _icon_tex("stat_range")
		if rng != null and card_data.attack_range != GFEnums.AttackRange.NONE:
			var r := TextureRect.new()
			r.texture = rng
			r.custom_minimum_size = Vector2(16, 16)
			r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			r.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_stat_row.add_child(r)
			# Hide the redundant text range cue when the glyph is shown.
			if _range_label != null:
				_range_label.text = ""
	# Dim the text stats line iff we actually drew glyph equivalents.
	if stats_label != null:
		stats_label.modulate.a = 0.0 if drew_stats else 1.0

	for kw in card_data.keywords:
		if kw < 0 or kw >= _KW_FILE.size():
			continue
		var t := _icon_tex(_KW_FILE[kw])
		if t == null:
			continue
		var ir := TextureRect.new()
		ir.texture = t
		ir.custom_minimum_size = Vector2(16, 16)
		ir.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ir.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ir.tooltip_text = GFEnums.Keyword.keys()[kw].capitalize()
		_kw_strip.add_child(ir)


func _add_stat(row: HBoxContainer, stem: String, value: int) -> bool:
	var tex := _icon_tex(stem)
	if tex == null:
		return false
	var ic := TextureRect.new()
	ic.texture = tex
	ic.custom_minimum_size = Vector2(16, 16)
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(ic)
	var lbl := Label.new()
	lbl.text = "%d" % value
	lbl.add_theme_font_size_override("font_size", 18)
	lbl.add_theme_color_override("font_color", Color(1, 1, 1, 0.92))
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(lbl)
	return true


# ============================================================================
# Playability — listen to GameState.mana and dim if unaffordable
# ============================================================================

func _on_mana_changed(_new_mana: int, _ceiling: int) -> void:
	_refresh_playability()


## Playability is 3-state for IMV-1:
##   NOW         — cost <= current mana          (green border, amber orb, full bright)
##   NEXT_TURN   — current < cost <= next max    (amber border, amber orb, slight dim)
##   UNAFFORDABLE— cost > next max               (red border, red orb, heavy dim)
##
## "Next max" = GameState.max_mana (the ceiling refilled at turn start).
enum PlayState { NOW, NEXT_TURN, UNAFFORDABLE }
var _play_state: int = PlayState.NOW

func _refresh_playability() -> void:
	if card_data == null:
		return
	var current_mana: int = GameState.mana
	var next_max: int = GameState.max_mana

	if card_data.cost <= current_mana:
		_play_state = PlayState.NOW
	elif card_data.cost <= next_max:
		_play_state = PlayState.NEXT_TURN
	else:
		_play_state = PlayState.UNAFFORDABLE
	_is_playable = _play_state == PlayState.NOW

	var orb_bg: Color
	var orb_border: Color
	var card_border: Color
	var mod: Color
	match _play_state:
		PlayState.NOW:
			orb_bg = Color(0.92, 0.65, 0.20)
			orb_border = Color(0.20, 0.10, 0.00)
			card_border = Color(0.40, 0.85, 0.40, 0.70)
			mod = Color(1, 1, 1, 1)
		PlayState.NEXT_TURN:
			orb_bg = Color(0.92, 0.78, 0.30)
			orb_border = Color(0.55, 0.40, 0.10)
			card_border = Color(0.95, 0.80, 0.30, 0.65)
			mod = Color(0.85, 0.85, 0.85, 1)
		_:  # UNAFFORDABLE
			orb_bg = Color(0.50, 0.15, 0.18)
			orb_border = Color(0.60, 0.20, 0.20)
			card_border = Color(0.85, 0.30, 0.30, 0.45)
			mod = Color(0.50, 0.50, 0.55, 1)

	modulate = mod
	if _cost_orb != null:
		var sb := _cost_orb.get_theme_stylebox("panel") as StyleBoxFlat
		if sb != null:
			sb.bg_color = orb_bg
			sb.border_color = orb_border
	if _border != null:
		var bsb := _border.get_theme_stylebox("panel") as StyleBoxFlat
		if bsb != null:
			bsb.border_color = card_border


# ============================================================================
# Drag-and-drop — only allow drag if playable
# ============================================================================

func _get_drag_data(_at_position: Vector2) -> Variant:
	if card_data == null:
		return null
	if not _is_playable:
		# Cheap nudge so the player notices the dim card isn't pickable.
		modulate = Color(0.7, 0.3, 0.3, 1)
		create_tween().tween_property(self, "modulate", Color(0.5, 0.5, 0.55, 1), 0.35)
		return null
	# Build the preview from the scene file (NOT duplicate()). duplicate()
	# copies the children but doesn't rebind the script's @onready / member
	# var references — so calling bind() on the duplicate ends up appending
	# a second set of icons to the ORIGINAL CardView's container, causing
	# the over-sized icon stack Paul reported. A fresh instance gets its
	# own _stat_row / _kw_strip references via _ready and renders cleanly.
	var preview_scene: PackedScene = load("res://scenes/card_view.tscn")
	var preview := preview_scene.instantiate() as CardView
	preview.modulate.a = 0.7
	preview.bind(card_data)
	set_drag_preview(preview)
	return {
		"kind": "card",
		"card": card_data,
		"source_view": self,
	}


# ============================================================================
# Helpers
# ============================================================================

func _type_label_for(t: GFEnums.CardType) -> String:
	match t:
		GFEnums.CardType.UNIT: return "UNIT"
		GFEnums.CardType.SPELL: return "SPELL"
		GFEnums.CardType.TRAP: return "TRAP"
		_: return "?"


func _range_short(r: GFEnums.AttackRange) -> String:
	match r:
		GFEnums.AttackRange.NONE: return ""
		GFEnums.AttackRange.MELEE: return "M"
		GFEnums.AttackRange.SHORT: return "S"
		GFEnums.AttackRange.LONG: return "L"
		_: return ""


func _faction_tint(f: GFEnums.Faction) -> Color:
	match f:
		GFEnums.Faction.IRON_PENITENTS: return Color(0.40, 0.14, 0.14, 1.0)
		GFEnums.Faction.ASH_MOURNERS: return Color(0.22, 0.18, 0.30, 1.0)
		GFEnums.Faction.COVEN:    return Color(0.14, 0.32, 0.22, 1.0)
		GFEnums.Faction.LAST_LEGION:    return Color(0.36, 0.30, 0.18, 1.0)
		GFEnums.Faction.SKINWARD_PACT:    return Color(0.24, 0.18, 0.12, 1.0)
		_: return Color(0.18, 0.18, 0.20, 1.0)
