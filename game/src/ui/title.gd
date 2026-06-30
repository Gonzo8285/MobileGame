extends Control
class_name TitleScreen

## Title — minimal IMV-1 entry screen. Pick a Warlord (one of 3) → starts the run.
##
## Loads the starter card pool from the IMV-1 factions and seeds the run.
## Emits no signals — directly calls GameState.start_run, which the
## RunController's phase_changed handler picks up to swap to MAP scene.

const WARLORDS_DIR: String = "res://data/warlords/"
const POOL_DIRS: Array[String] = [
	"res://data/cards/iron_penitents/",
	"res://data/cards/ash_mourners/",
	"res://data/cards/coven/",
	"res://data/cards/last_legion/",
	"res://data/cards/skinward_pact/",
]
const STARTER_DECK_SIZE: int = 12  # IMV-1 starter pool size per faction


func _ready() -> void:
	custom_minimum_size = Vector2(1080, 1700)
	_build()


func _build() -> void:
	var title := Label.new()
	title.text = "The Curse of Gallowfell"
	title.add_theme_font_size_override("font_size", 56)
	title.position = Vector2(40, 200)
	title.size = Vector2(1000, 80)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var sub := Label.new()
	sub.text = "Internal MVP (IMV-1) — pick a Warlord"
	sub.add_theme_font_size_override("font_size", 22)
	sub.modulate = Color(1, 1, 1, 0.7)
	sub.position = Vector2(40, 300)
	sub.size = Vector2(1000, 40)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sub)

	# Three warlord buttons.
	var warlords := [
		{"id": &"vyrrun", "name": "Penance-Captain Vyrrun", "faction": "Iron Penitents", "colour": Color(0.55, 0.10, 0.10)},
		{"id": &"vey",    "name": "Lord-Justiciar Vey",     "faction": "Ash-Mourners",   "colour": Color(0.30, 0.15, 0.35)},
		{"id": &"quag",   "name": "Mother Quag",            "faction": "Coven of the Black Mire", "colour": Color(0.18, 0.30, 0.22)},
		{"id": &"sergeant_smith_vikar", "name": "Sergeant-Smith Vikar", "faction": "The Last Legion", "colour": Color(0.45, 0.32, 0.12)},
		{"id": &"thrask", "name": "Thrask the Bear-Who-Was-King", "faction": "Skinward Pact", "colour": Color(0.40, 0.22, 0.10)},
	]
	# Two-row grid: 3 across the top, 2 centred underneath. 1080px viewport.
	var btn_w: float = 320.0
	var btn_h: float = 340.0
	var gap: float = 20.0
	var top_row_count: int = 3
	var top_row_w: float = top_row_count * btn_w + (top_row_count - 1) * gap
	var top_x_start: float = (1080.0 - top_row_w) * 0.5
	var bot_row_count: int = warlords.size() - top_row_count
	var bot_row_w: float = bot_row_count * btn_w + (bot_row_count - 1) * gap
	var bot_x_start: float = (1080.0 - bot_row_w) * 0.5
	for i in range(warlords.size()):
		var w: Dictionary = warlords[i]
		var btn := _make_warlord_button(w)
		if i < top_row_count:
			btn.position = Vector2(top_x_start + i * (btn_w + gap), 440)
		else:
			var j: int = i - top_row_count
			btn.position = Vector2(bot_x_start + j * (btn_w + gap), 440 + btn_h + gap)
		btn.size = Vector2(btn_w, btn_h)
		add_child(btn)

	# Footer.
	var foot := Label.new()
	foot.text = "Once in combat: drag a card → lane. Press C = win combat, X = lose combat (IMV-1 placeholder)."
	foot.add_theme_font_size_override("font_size", 16)
	foot.modulate = Color(1, 1, 1, 0.5)
	foot.position = Vector2(40, 1170)
	foot.size = Vector2(1000, 40)
	foot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(foot)


func _make_warlord_button(w: Dictionary) -> Button:
	var btn := Button.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = w["colour"]
	sb.set_border_width_all(2)
	sb.border_color = Color(1, 1, 1, 0.5)
	sb.corner_radius_top_left = 16
	sb.corner_radius_top_right = 16
	sb.corner_radius_bottom_left = 16
	sb.corner_radius_bottom_right = 16
	btn.add_theme_stylebox_override("normal", sb)
	btn.text = ""
	btn.pressed.connect(func(): _start_run_with(w["id"]))
	btn.tree_entered.connect(func(): _populate_warlord_button(btn, w))
	return btn


func _populate_warlord_button(btn: Button, w: Dictionary) -> void:
	var name_lbl := Label.new()
	name_lbl.text = String(w["name"])
	name_lbl.add_theme_font_size_override("font_size", 22)
	name_lbl.position = Vector2(14, 20)
	name_lbl.size = Vector2(252, 80)
	name_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	btn.add_child(name_lbl)

	var fac := Label.new()
	fac.text = String(w["faction"])
	fac.add_theme_font_size_override("font_size", 16)
	fac.modulate = Color(1, 1, 1, 0.85)
	fac.position = Vector2(14, 120)
	fac.size = Vector2(252, 40)
	btn.add_child(fac)

	var start_lbl := Label.new()
	start_lbl.text = "▶  Start run"
	start_lbl.add_theme_font_size_override("font_size", 20)
	start_lbl.position = Vector2(14, 290)
	start_lbl.size = Vector2(252, 40)
	btn.add_child(start_lbl)


func _start_run_with(warlord_id: StringName) -> void:
	# DB-5: route to the deck-builder instead of auto-starting. RunController
	# listens for deck_build_requested and swaps to the builder; the old random
	# starter-deck path now lives behind the builder's Auto-fill button.
	GameState.active_warlord_id = warlord_id
	GameState.request_deck_build(warlord_id, _faction_for_warlord(warlord_id))


## Map a Warlord id → its faction. Mirrors run_controller._get_active_warlord_faction;
## WL-5 will unify both via WarlordDatabase.faction_of.
func _faction_for_warlord(id: StringName) -> int:
	match id:
		&"vyrrun": return GFEnums.Faction.IRON_PENITENTS
		&"vey": return GFEnums.Faction.ASH_MOURNERS
		&"quag": return GFEnums.Faction.COVEN
		&"sergeant_smith_vikar": return GFEnums.Faction.LAST_LEGION
		&"thrask": return GFEnums.Faction.SKINWARD_PACT
		_: return GFEnums.Faction.NEUTRAL
