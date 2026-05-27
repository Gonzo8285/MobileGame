extends Node

## ThemePackManager — autoload singleton tracking per-account theme ownership + equipped
## state, resolving a card_id at render time into the correct presentation surface.
##
## Registered in `project.godot` under [autoload] as `ThemePackManager`. UI code calls
## `ThemePackManager.resolve_render(card_instance)` to get the bundle of (art_path,
## display_name, frame_variant, flavour_text) — anywhere a CardView is drawn.
##
## See `theme_packs_system_v0.md` §2.3 GameState extensions + §7 engine handoff. The
## ManagerPattern (singleton + signals) matches the existing GameState autoload shape.
##
## Anti-P2W invariant: combat code reads `Card`, NEVER calls into this manager. PvP
## simulation strips the theme layer server-side; clients render themed only.

const CATALOG_PATH: String = "res://data/themes/theme_pack_definitions.tres"

# ---------- Owned + equipped state ------------------------------------------

var catalog: ThemePackCatalog = null

## Owned themes by id. Canonical theme is auto-added on first load.
var owned_theme_packs: Array[StringName] = []

## Sparse per-card override map: { card_id: theme_pack_id }. Only present for cards the
## player has explicitly themed. Otherwise the deck-wide theme applies.
var equipped_theme_per_card: Dictionary = {}

## Deck-wide theme. Defaults to canonical Gallowfell. Empty StringName = no override.
var equipped_theme_deck_wide: StringName = &"gallowfell_canon"

## Theme application mode toggle. Either &"per_card" or &"deck_wide".
var theme_application_mode: StringName = &"deck_wide"


# ---------- Signals --------------------------------------------------------

signal theme_pack_acquired(id: StringName, source: StringName)
signal theme_pack_equipped(card_id: StringName, theme_pack_id: StringName)
signal theme_pack_applied_deck_wide(theme_pack_id: StringName)
signal theme_application_mode_changed(mode: StringName)


func _ready() -> void:
	_load_catalog()
	_ensure_canonical_ownership()


func _load_catalog() -> void:
	if ResourceLoader.exists(CATALOG_PATH):
		catalog = load(CATALOG_PATH) as ThemePackCatalog
	else:
		push_warning("ThemePackManager: catalog not found at %s — running with empty catalog" % CATALOG_PATH)
		catalog = ThemePackCatalog.new()


## Canonical Gallowfell theme is always owned. Idempotent — safe to call repeatedly.
func _ensure_canonical_ownership() -> void:
	var canonical := catalog.get_canonical() if catalog else null
	if canonical == null:
		return
	if not owned_theme_packs.has(canonical.id):
		owned_theme_packs.append(canonical.id)
	if equipped_theme_deck_wide == &"":
		equipped_theme_deck_wide = canonical.id


# ---------- Ownership ------------------------------------------------------

## Grants a theme. Used by season-pass unlocks (Pass+ free theme of season), gift acceptance,
## shop purchase, and the Returning Seeker pack. `source` is free-form telemetry.
func grant(theme_id: StringName, source: StringName = &"unknown") -> bool:
	if owned_theme_packs.has(theme_id):
		return false
	var theme := catalog.get_by_id(theme_id) if catalog else null
	if theme == null:
		push_warning("ThemePackManager: grant() unknown theme '%s'" % theme_id)
		return false
	owned_theme_packs.append(theme_id)
	theme_pack_acquired.emit(theme_id, source)
	return true


func owns(theme_id: StringName) -> bool:
	return owned_theme_packs.has(theme_id)


# ---------- Equipping -----------------------------------------------------

## Per-card equip path. Validates ownership before committing.
func equip_for_card(card_id: StringName, theme_id: StringName) -> bool:
	if not owns(theme_id):
		push_warning("ThemePackManager: cannot equip un-owned theme '%s' for card '%s'" % [theme_id, card_id])
		return false
	equipped_theme_per_card[card_id] = theme_id
	theme_pack_equipped.emit(card_id, theme_id)
	return true


## Deck-wide equip path. Single tap "paint the whole deck" — hero / default mode.
func apply_deck_wide(theme_id: StringName) -> bool:
	if not owns(theme_id):
		push_warning("ThemePackManager: cannot apply un-owned theme '%s' deck-wide" % theme_id)
		return false
	equipped_theme_deck_wide = theme_id
	theme_application_mode = &"deck_wide"
	theme_pack_applied_deck_wide.emit(theme_id)
	theme_application_mode_changed.emit(theme_application_mode)
	return true


func clear_per_card_override(card_id: StringName) -> void:
	equipped_theme_per_card.erase(card_id)


func set_application_mode(mode: StringName) -> void:
	if mode != &"per_card" and mode != &"deck_wide":
		push_warning("ThemePackManager: unknown application mode '%s'" % mode)
		return
	theme_application_mode = mode
	theme_application_mode_changed.emit(mode)


# ---------- Resolution ----------------------------------------------------

## Returns the theme id that should be used to render a given card. Resolution order:
##     per-card override → deck-wide theme → canonical (catalog.get_canonical().id).
## Never returns &"" — the canonical theme is always available as the floor.
func resolve_theme_for_card(card_id: StringName) -> StringName:
	if theme_application_mode == &"per_card" and equipped_theme_per_card.has(card_id):
		return equipped_theme_per_card[card_id]
	if equipped_theme_deck_wide != &"":
		return equipped_theme_deck_wide
	var canonical := catalog.get_canonical() if catalog else null
	return canonical.id if canonical != null else &""


## Returns the per-card CardThemeTreatment for the currently-resolved theme, or null when
## the theme is canonical / stubbed for this card (caller falls back to the underlying Card).
func resolve_treatment_for_card(card_id: StringName) -> CardThemeTreatment:
	var theme_id := resolve_theme_for_card(card_id)
	if theme_id == &"":
		return null
	var theme := catalog.get_by_id(theme_id) if catalog else null
	if theme == null:
		return null
	return theme.get_treatment_for(card_id)


## Render bundle. UI consumes this to paint a CardView without caring about theme/treatment
## resolution internals. Returns canonical fields when no theme override exists.
## TEST: bundle should never return empty display_name — fallback to card.display_name guaranteed.
func resolve_render(card_instance, card: Card) -> Dictionary:
	# card_instance is duck-typed (CardInstance) — avoid hard dep so combat tests don't need this autoload.
	var card_id: StringName = card.id
	var treatment := resolve_treatment_for_card(card_id)
	var theme_id := resolve_theme_for_card(card_id)

	var bundle := {
		"theme_pack_id": theme_id,
		"art_path": card.art_path,
		"display_name": card.display_name,
		"flavour_text": card.flavour_text,
		"frame_variant": &"",
		"icon_path": card.icon_path,
	}
	if treatment != null:
		if treatment.art_path != "":
			bundle["art_path"] = treatment.art_path
		if treatment.display_name != "":
			bundle["display_name"] = treatment.display_name
		if treatment.flavour_text != "":
			bundle["flavour_text"] = treatment.flavour_text
		if treatment.frame_variant != &"":
			bundle["frame_variant"] = treatment.frame_variant
		if treatment.icon_path != "":
			bundle["icon_path"] = treatment.icon_path
	return bundle


# ---------- Save / load (stub — full save system is post-MVP) -------------

func to_dict() -> Dictionary:
	return {
		"owned": owned_theme_packs.duplicate(),
		"mode": String(theme_application_mode),
		"deck_wide_active": String(equipped_theme_deck_wide),
		"per_card_overrides": equipped_theme_per_card.duplicate(true),
	}


func from_dict(d: Dictionary) -> void:
	owned_theme_packs.clear()
	if d.has("owned"):
		for id in d["owned"]:
			owned_theme_packs.append(StringName(id))
	if d.has("mode"):
		theme_application_mode = StringName(d["mode"])
	if d.has("deck_wide_active"):
		equipped_theme_deck_wide = StringName(d["deck_wide_active"])
	if d.has("per_card_overrides"):
		equipped_theme_per_card = d["per_card_overrides"].duplicate(true)
	_ensure_canonical_ownership()
