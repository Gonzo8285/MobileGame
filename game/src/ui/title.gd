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

	# WL-4: a single Play button opens the data-driven Warlord-select screen.
	# (The old hardcoded warlord grid is superseded by WarlordSelect; the
	# _make_warlord_button/_start_run_with helpers below are now dead code.)
	var play := Button.new()
	play.text = "▶  Play"
	play.add_theme_font_size_override("font_size", 44)
	play.position = Vector2(340, 540)
	play.size = Vector2(400, 130)
	play.pressed.connect(func(): GameState.request_warlord_select())
	add_child(play)

	var coll := Button.new()
	coll.text = "Collection"
	coll.add_theme_font_size_override("font_size", 30)
	coll.position = Vector2(340, 700)
	coll.size = Vector2(400, 90)
	coll.pressed.connect(func(): GameState.request_collection())
	add_child(coll)

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
