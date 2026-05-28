extends Control
class_name RewardView

## RewardView — 3-card pick screen shown after a combat win.
##
## Listens to GameState.reward_offered → renders 3 cards as buttons.
## On click → calls offer.choose(index).
## On Skip → calls offer.skip().
## Either path emits offer.resolved(card_or_null) which GameState handles.
## Then emits `picked(node_or_null)` so the parent run controller can return
## to the map.

signal picked(card: Card)

const CARD_WIDTH: float = 280.0
const CARD_HEIGHT: float = 420.0
const CARD_GAP: float = 30.0

var _offer: RewardOffer = null
var _card_buttons: Array[Button] = []
var _skip_button: Button = null
var _title_label: Label = null


func _ready() -> void:
	custom_minimum_size = Vector2(1080, 1700)
	GameState.reward_offered.connect(_on_reward_offered)
	if GameState.current_phase == GFEnums.RunPhase.REWARD:
		# We arrived after the signal fired — rebuild from any active offer.
		_rebuild_from_current()


func _on_reward_offered(offer: RewardOffer) -> void:
	_offer = offer
	_build()


func _rebuild_from_current() -> void:
	# No public accessor; leave the screen blank if we missed the signal.
	_clear()
	var note := Label.new()
	note.text = "(Waiting for reward offer…)"
	note.position = Vector2(40, 80)
	note.size = Vector2(1000, 60)
	add_child(note)


func _clear() -> void:
	for child in get_children():
		child.queue_free()
	_card_buttons.clear()
	_skip_button = null
	_title_label = null


func _build() -> void:
	_clear()

	# Decorative banner background — Snap-style draws focus to the reveal.
	var banner_bg := ColorRect.new()
	banner_bg.position = Vector2(0, 0)
	banner_bg.size = Vector2(1080, 180)
	banner_bg.color = Color(0.13, 0.10, 0.15, 0.85)
	add_child(banner_bg)

	_title_label = Label.new()
	_title_label.text = "★  VICTORY REWARD  ★"
	_title_label.add_theme_font_size_override("font_size", 48)
	_title_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.7, 1))
	_title_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))
	_title_label.add_theme_constant_override("outline_size", 8)
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.position = Vector2(40, 40)
	_title_label.size = Vector2(1000, 60)
	add_child(_title_label)

	var sub := Label.new()
	sub.text = "Pick a card to add it to your deck — or skip to draw nothing."
	sub.add_theme_font_size_override("font_size", 22)
	sub.add_theme_color_override("font_color", Color(0.95, 0.92, 0.85, 0.85))
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.position = Vector2(40, 110)
	sub.size = Vector2(1000, 40)
	add_child(sub)

	if _offer == null:
		return

	# Lay out 3 cards horizontally, centred.
	var total_width: float = (CARD_WIDTH * _offer.cards.size()) + (CARD_GAP * (_offer.cards.size() - 1))
	var x_start: float = (1080.0 - total_width) * 0.5
	var y_top: float = 220.0

	for i in range(_offer.cards.size()):
		var card: Card = _offer.cards[i]
		var btn := _make_card_button(card, i)
		var final_pos := Vector2(x_start + i * (CARD_WIDTH + CARD_GAP), y_top)
		btn.position = final_pos + Vector2(0, 240)  # start below final
		btn.size = Vector2(CARD_WIDTH, CARD_HEIGHT)
		btn.modulate.a = 0.0
		add_child(btn)
		_card_buttons.append(btn)
		# Snap-style staggered reveal: each card flies up + fades in 100ms apart.
		var t := create_tween().set_parallel(true)
		t.tween_interval(0.10 * float(i))
		t.chain().tween_property(btn, "position", final_pos, 0.45)				.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t.parallel().tween_property(btn, "modulate:a", 1.0, 0.30)

	# Skip button at bottom.
	_skip_button = Button.new()
	_skip_button.text = "Skip — draw nothing"
	_skip_button.add_theme_font_size_override("font_size", 22)
	_skip_button.position = Vector2(380, y_top + CARD_HEIGHT + 80)
	_skip_button.size = Vector2(320, 80)
	_skip_button.modulate = Color(0.85, 0.85, 0.9, 0.85)
	_skip_button.pressed.connect(_on_skip_pressed)
	add_child(_skip_button)


func _make_card_button(card: Card, index: int) -> Button:
	var btn := Button.new()
	var faction_colour := _faction_colour(card.faction)
	var sb := StyleBoxFlat.new()
	sb.bg_color = faction_colour
	sb.border_color = _rarity_border_colour(card.rarity)
	sb.set_border_width_all(4)
	sb.corner_radius_top_left = 16
	sb.corner_radius_top_right = 16
	sb.corner_radius_bottom_left = 16
	sb.corner_radius_bottom_right = 16
	sb.shadow_color = _rarity_border_colour(card.rarity) * Color(1, 1, 1, 0.45)
	sb.shadow_size = 8
	btn.add_theme_stylebox_override("normal", sb)

	# Compose card body via a child container.
	btn.text = ""  # text goes into child Labels for layout control

	# Use deferred call to wait for the button to be in tree before adding labels.
	btn.tree_entered.connect(func(): _populate_card_button(btn, card))
	btn.pressed.connect(func(): _on_card_pressed(index))

	return btn


func _populate_card_button(btn: Button, card: Card) -> void:
	# Cost (top-left)
	var cost := Label.new()
	cost.text = "%d" % card.cost
	cost.add_theme_font_size_override("font_size", 32)
	cost.position = Vector2(12, 8)
	cost.size = Vector2(48, 48)
	btn.add_child(cost)

	# Name (top, centred)
	var name_lbl := Label.new()
	name_lbl.text = card.display_name
	name_lbl.add_theme_font_size_override("font_size", 20)
	name_lbl.position = Vector2(60, 14)
	name_lbl.size = Vector2(CARD_WIDTH - 70, 60)
	name_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	btn.add_child(name_lbl)

	# Type + rarity
	var type_lbl := Label.new()
	var type_name: String = GFEnums.CardType.keys()[card.card_type]
	var rarity_name: String = GFEnums.Rarity.keys()[card.rarity]
	type_lbl.text = "%s · %s" % [type_name, rarity_name]
	type_lbl.add_theme_font_size_override("font_size", 14)
	type_lbl.modulate = Color(1, 1, 1, 0.75)
	type_lbl.position = Vector2(14, 80)
	type_lbl.size = Vector2(CARD_WIDTH - 28, 24)
	btn.add_child(type_lbl)

	# Stats (UNITs only — HP/ATK/Rng/CD)
	if card.card_type == GFEnums.CardType.UNIT:
		var stats := Label.new()
		var rng_names: Array = ["—", "M", "S", "L"]
		var range_label: String = String(rng_names[card.attack_range]) if card.attack_range < rng_names.size() else "?"
		stats.text = "HP %d   ATK %d   %s   CD %d" % [card.hp, card.attack, range_label, card.cooldown]
		stats.add_theme_font_size_override("font_size", 16)
		stats.position = Vector2(14, 110)
		stats.size = Vector2(CARD_WIDTH - 28, 28)
		btn.add_child(stats)

	# Effect text
	var effect := Label.new()
	effect.text = card.effect_text
	effect.add_theme_font_size_override("font_size", 14)
	effect.position = Vector2(14, 150)
	effect.size = Vector2(CARD_WIDTH - 28, 200)
	effect.autowrap_mode = TextServer.AUTOWRAP_WORD
	btn.add_child(effect)

	# Flavour
	var flavour := Label.new()
	flavour.text = card.flavour_text
	flavour.add_theme_font_size_override("font_size", 12)
	flavour.modulate = Color(1, 1, 1, 0.6)
	flavour.position = Vector2(14, CARD_HEIGHT - 80)
	flavour.size = Vector2(CARD_WIDTH - 28, 60)
	flavour.autowrap_mode = TextServer.AUTOWRAP_WORD
	btn.add_child(flavour)


func _rarity_border_colour(rarity: int) -> Color:
	match rarity:
		GFEnums.Rarity.COMMON:    return Color(0.8, 0.8, 0.85, 0.6)    # silver-grey
		GFEnums.Rarity.UNCOMMON:  return Color(0.4, 0.85, 0.5, 0.85)  # green glow
		GFEnums.Rarity.RARE:      return Color(0.4, 0.6, 1.0, 0.95)   # blue glow
		GFEnums.Rarity.EPIC:      return Color(0.85, 0.4, 1.0, 1.0)   # purple
		GFEnums.Rarity.LEGENDARY: return Color(1.0, 0.85, 0.3, 1.0)   # gold
		_: return Color(0.7, 0.7, 0.75, 0.6)


func _faction_colour(faction: int) -> Color:
	match faction:
		GFEnums.Faction.IRON_PENITENTS: return Color(0.30, 0.10, 0.10)
		GFEnums.Faction.ASH_MOURNERS: return Color(0.20, 0.10, 0.25)
		GFEnums.Faction.COVEN:    return Color(0.10, 0.20, 0.15)
		GFEnums.Faction.LAST_LEGION:    return Color(0.18, 0.18, 0.20)
		GFEnums.Faction.SKINWARD_PACT:    return Color(0.15, 0.20, 0.10)
		_: return Color(0.18, 0.18, 0.22)


func _on_card_pressed(index: int) -> void:
	if _offer == null or _offer.is_resolved():
		return
	var card: Card = _offer.choose(index)
	if card != null:
		picked.emit(card)


func _on_skip_pressed() -> void:
	if _offer == null or _offer.is_resolved():
		return
	_offer.skip()
	picked.emit(null)
