extends Control
class_name WarlordSelect

## Warlord-select roster screen (WL-3). Data-driven from WarlordDatabase.
## Free Warlords are selectable → deck-builder scoped to their faction; paid
## Warlords render locked (none authored yet). Programmatic UI (title.gd
## convention). Spec: WARLORDSELECT_SPEC_2026-06-01.md.
##
## v0: functional roster grid — each tile shows name + faction + archetype, tap
## a free tile to select. The bigger detail panel (art + signature names) and
## per-tile art are deferred polish; the core Title→Select→Build→run path works.

const _ARCHETYPE := {
	GFEnums.Faction.IRON_PENITENTS: "Aggro",
	GFEnums.Faction.ASH_MOURNERS: "Control",
	GFEnums.Faction.COVEN: "Swarm",
	GFEnums.Faction.LAST_LEGION: "Tempo",
	GFEnums.Faction.SKINWARD_PACT: "Summoner",
}


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	_build_ui()


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
	root.add_theme_constant_override("separation", 20)
	add_child(root)

	# ---- Header + Back ----------------------------------------------------
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 16)
	root.add_child(top)
	var back := Button.new()
	back.text = "◀ Back"
	back.add_theme_font_size_override("font_size", 26)
	back.pressed.connect(func(): GameState.request_title())
	top.add_child(back)
	var title := Label.new()
	title.text = "Choose your Warlord"
	title.add_theme_font_size_override("font_size", 34)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	top.add_child(title)
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(120, 0)
	top.add_child(spacer)

	# ---- FREE row ---------------------------------------------------------
	var free_lbl := Label.new()
	free_lbl.text = "FREE"
	free_lbl.add_theme_font_size_override("font_size", 22)
	free_lbl.modulate = Color(0.6, 1, 0.6)
	root.add_child(free_lbl)
	var free_grid := GridContainer.new()
	free_grid.columns = 5
	free_grid.add_theme_constant_override("h_separation", 12)
	free_grid.add_theme_constant_override("v_separation", 12)
	root.add_child(free_grid)
	for w in WarlordDatabase.free_warlords():
		free_grid.add_child(_make_warlord_tile(w, false))

	# ---- LOCKED row (paid — none authored yet) ----------------------------
	var paid := WarlordDatabase.paid_warlords()
	if not paid.is_empty():
		var lock_lbl := Label.new()
		lock_lbl.text = "LOCKED"
		lock_lbl.add_theme_font_size_override("font_size", 22)
		lock_lbl.modulate = Color(0.75, 0.75, 0.75)
		root.add_child(lock_lbl)
		var paid_grid := GridContainer.new()
		paid_grid.columns = 5
		paid_grid.add_theme_constant_override("h_separation", 12)
		paid_grid.add_theme_constant_override("v_separation", 12)
		root.add_child(paid_grid)
		for w in paid:
			paid_grid.add_child(_make_warlord_tile(w, true))

	var foot := Label.new()
	foot.text = "Tap a Warlord to build a deck for their faction."
	foot.add_theme_font_size_override("font_size", 18)
	foot.modulate = Color(1, 1, 1, 0.5)
	foot.size_flags_vertical = Control.SIZE_EXPAND_FILL
	foot.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	foot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(foot)


func _make_warlord_tile(w: Warlord, locked: bool) -> Control:
	var tile := Button.new()
	tile.custom_minimum_size = Vector2(196, 250)
	tile.clip_text = true
	var arch: String = _ARCHETYPE.get(w.faction, "—")
	var lock_line := "\n\n[ Unlock in IMV-2 ]" if locked else ""
	tile.text = "%s\n\n%s\n%s%s" % [w.display_name, _faction_name(w.faction), arch, lock_line]
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.12, 0.12, 0.14) if locked else _faction_tint(w.faction)
	sb.set_border_width_all(3)
	sb.border_color = Color(1, 1, 1, 0.25)
	sb.set_corner_radius_all(12)
	sb.set_content_margin_all(10)
	tile.add_theme_stylebox_override("normal", sb)
	tile.add_theme_stylebox_override("hover", sb)
	tile.add_theme_stylebox_override("pressed", sb)
	if locked:
		tile.modulate = Color(0.6, 0.6, 0.65)
		# IMV-2 stub — tapping a paid Warlord does nothing yet (no purchase flow).
	else:
		tile.pressed.connect(func(): _on_select(w))
	return tile


func _on_select(w: Warlord) -> void:
	GameState.active_warlord_id = w.id
	GameState.request_deck_build(w.id, w.faction)


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
