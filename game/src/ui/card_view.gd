extends Control
class_name CardView

## CardView (B2.6 UI) — visual representation of one card in hand.
##
## Holds a Card resource reference and draws name + cost + type. Implements
## Godot's drag-and-drop API via `_get_drag_data` so the player can pick the
## card up and drop it on a Lane drop zone.
##
## Visuals are placeholder (ColorRect + Labels). B3 art pass replaces the
## panel with the real card art. Layout target: portrait card ~200×280 px.
## Phase 2 we just want clarity, not polish.

signal play_attempted(result: Dictionary)
## Emitted by HandView after a successful play (so it can clean up the visual).
signal consumed

@export var card_data: Card = null

const CARD_WIDTH: float = 200.0
const CARD_HEIGHT: float = 280.0

@onready var name_label: Label = $NameLabel
@onready var cost_label: Label = $CostLabel
@onready var type_label: Label = $TypeLabel
@onready var stats_label: Label = $StatsLabel
@onready var bg: ColorRect = $BG


func _ready() -> void:
	custom_minimum_size = Vector2(CARD_WIDTH, CARD_HEIGHT)
	# CardView itself MUST be STOP — drag-detection only fires on the
	# topmost Control that consumes the click. PASS would forward the click
	# up to the parent HBoxContainer, which would absorb it without a
	# `_get_drag_data` override.
	mouse_filter = Control.MOUSE_FILTER_STOP
	# Children (BG ColorRect, all Labels) default to STOP and would each
	# eat the click before it reached CardView. Force IGNORE so clicks
	# pass through them and land on us.
	for child in get_children():
		if child is Control:
			(child as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
	_refresh()


func bind(card: Card) -> void:
	card_data = card
	if is_inside_tree():
		_refresh()


func _refresh() -> void:
	if card_data == null:
		name_label.text = "<empty>"
		cost_label.text = ""
		type_label.text = ""
		stats_label.text = ""
		return
	name_label.text = card_data.display_name
	cost_label.text = "%d" % card_data.cost
	type_label.text = _type_label_for(card_data.card_type)
	if card_data.card_type == GFEnums.CardType.UNIT:
		stats_label.text = "%d/%d" % [card_data.attack, card_data.hp]
	else:
		stats_label.text = ""
	bg.color = _faction_tint(card_data.faction)


# ============================================================================
# Drag-and-drop — Godot's built-in Control API
# ============================================================================

func _get_drag_data(_at_position: Vector2) -> Variant:
	if card_data == null:
		return null
	# The drag preview is a translucent copy of this card. Godot's drag
	# system handles the visual ghosting automatically once we set it.
	var preview := duplicate() as CardView
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


func _faction_tint(f: GFEnums.Faction) -> Color:
	# Placeholder palette — B3 art replaces. Each faction gets a tint
	# distinct enough to distinguish at a glance during dev.
	match f:
		GFEnums.Faction.IRON_PENITENTS: return Color(0.55, 0.18, 0.18, 1.0)  # rust-red
		GFEnums.Faction.WITHERED_COURT: return Color(0.30, 0.30, 0.40, 1.0)  # dusk-purple (Ash-Mourners)
		GFEnums.Faction.HOLLOW_PACT:    return Color(0.18, 0.40, 0.28, 1.0)  # bog-green (Coven)
		GFEnums.Faction.FERRUM_HOST:    return Color(0.42, 0.36, 0.20, 1.0)  # brass (Last Legion)
		GFEnums.Faction.SABLE_WILDS:    return Color(0.30, 0.22, 0.15, 1.0)  # bark (Skinward Pact)
		_: return Color(0.20, 0.20, 0.22, 1.0)
