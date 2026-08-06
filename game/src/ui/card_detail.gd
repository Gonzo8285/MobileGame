extends RefCounted
class_name CardDetail

## Shared full-card detail overlay (CO-3). The Collection codex and the
## deck-builder card-zoom both call CardDetail.show_over(parent, card) to add a
## self-closing full-screen overlay on top of `parent`. Read-only.

const KEYWORD_BLURBS := {
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


## Build + attach the overlay. Returns it (or null on bad input).
static func show_over(parent: Control, c: Card) -> Control:
	if parent == null or c == null:
		return null
	var overlay := Panel.new()
	overlay.name = "CardDetailOverlay"
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	var osb := StyleBoxFlat.new()
	osb.bg_color = Color(0.03, 0.03, 0.05, 0.97)
	overlay.add_theme_stylebox_override("panel", osb)
	parent.add_child(overlay)

	var box := VBoxContainer.new()
	box.anchor_right = 1.0
	box.anchor_bottom = 1.0
	box.offset_left = 60
	box.offset_top = 60
	box.offset_right = -60
	box.offset_bottom = -60
	box.add_theme_constant_override("separation", 14)
	overlay.add_child(box)

	_line(box, c.display_name, 40, Color.WHITE, true)
	_line(box, "%s · %s · cost %d" % [_faction_name(c.faction), _rarity_name(c.rarity), c.cost],
			24, Color(1, 1, 1, 0.8), false)
	if c.card_type == GFEnums.CardType.UNIT:
		_line(box, "HP %d   ATK %d   Range %s   Cooldown %d" % [
				c.hp, c.attack, _range_short(c.attack_range), c.cooldown], 24, Color.WHITE, false)
	if not c.keywords.is_empty():
		var names: Array[String] = []
		for kw in c.keywords:
			names.append(_kw_name(kw))
		_line(box, "Keywords: " + ", ".join(names), 22, Color(0.9, 0.8, 0.4), true)
		for n in names:
			if KEYWORD_BLURBS.has(n):
				_line(box, "  • %s — %s" % [n, KEYWORD_BLURBS[n]], 18, Color(1, 1, 1, 0.7), true)
	if c.effect_text != "":
		_line(box, c.effect_text, 22, Color.WHITE, true)
	if c.flavour_text != "":
		_line(box, c.flavour_text, 18, Color(0.75, 0.75, 0.8), true)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(spacer)
	var close := Button.new()
	close.text = "Close"
	close.add_theme_font_size_override("font_size", 26)
	close.pressed.connect(overlay.queue_free)
	box.add_child(close)
	return overlay


static func _line(box: VBoxContainer, text: String, size: int, colour: Color, wrap: bool) -> void:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.modulate = colour
	if wrap:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD
	box.add_child(l)


static func _kw_name(kw: int) -> String:
	var keys := GFEnums.Keyword.keys()
	return String(keys[kw]) if kw >= 0 and kw < keys.size() else "?"


static func _faction_name(f: int) -> String:
	match f:
		GFEnums.Faction.IRON_PENITENTS: return "Iron Penitents"
		GFEnums.Faction.ASH_MOURNERS: return "Ash-Mourners"
		GFEnums.Faction.COVEN: return "Coven of the Black Mire"
		GFEnums.Faction.LAST_LEGION: return "The Last Legion"
		GFEnums.Faction.SKINWARD_PACT: return "Skinward Pact"
		_: return "Neutral"


static func _rarity_name(r: int) -> String:
	var keys := GFEnums.Rarity.keys()
	return String(keys[r]).capitalize() if r >= 0 and r < keys.size() else "?"


static func _range_short(r: int) -> String:
	match r:
		GFEnums.AttackRange.MELEE: return "Melee"
		GFEnums.AttackRange.SHORT: return "Short"
		GFEnums.AttackRange.LONG: return "Long"
		_: return "—"
