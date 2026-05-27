extends Resource
class_name ThemePack

## ThemePack — a complete card-art + frame + name + flavour-text re-skin layered over the
## mechanically-identical underlying cards. Mechanics never change — only presentation.
## See `theme_packs_system_v0.md` §1 + §2 for the full design spec.
##
## Authored entries live in `game/data/themes/theme_pack_definitions.tres`
## (a ThemePackCatalog resource) plus one `theme.tres` per theme under
## `game/data/themes/<theme_id>/`.
##
## IP rule (theme_packs_system_v0.md §0): the `category` field is mandatory. Anything tagged
## `LICENSED_BLOCKED` is a design-reference-only entry and MUST NOT ship under that name.
## TM-clean naming policy (§5.1) — names must not be franchise words / characters / titles.
##
## Anti-P2W invariant: combat code reads `Card`, never `ThemePack` or `CardThemeTreatment`.
## PvP `card_id` and tooltip canonical name remain queryable regardless of theme.

@export var id: StringName = &""              ## Stable theme id (e.g. &"grimm_reaping")
@export var display_name: String = ""          ## Player-facing name (e.g. "The Grimm Reaping")
@export var category: GFEnums.ThemePackCategory = GFEnums.ThemePackCategory.ORIGINAL
@export var era: String = ""                   ## Free-form era tag ("fairytale_folk_horror", "norse", "lovecraftian", etc)
@export var status: GFEnums.ThemePackStatus = GFEnums.ThemePackStatus.ART_STUBBED

## Visual identity. Used by the theme-preview UI + per-theme palette painting.
@export_group("Visual identity")
@export var palette: Array[Color] = []         ## 5-7 hex anchors per theme_packs_system_v0.md §2.1
@export var fonts: Dictionary = {}             ## { &"card_title": res-path, &"card_body": res-path }
@export var frame_default_variant: StringName = &""  ## Default frame_variant id used when a per-card override is absent
@export var preview_art_path: String = ""      ## Single hero illustration shown in the theme picker

## Economy. Mirrors `theme_packs_system_v0.md` §6.1 price ladder.
@export_group("Economy")
@export var price_tier_gbp: float = 0.0        ## 0.0 (canonical, free) / 3.99 / 5.99 / 7.99
@export var bundle_includes_board: bool = false
@export var bundle_includes_back: bool = false
@export var bundle_includes_avatar_frame: bool = false
@export var pass_plus_free_in_season: StringName = &""  ## e.g. &"season_1" — auto-grant to Pass+ owners
@export var subscription_quarterly_free: bool = false   ## True = surfaced in Ascendant Pact quarterly free pick

## Ownership defaults. Canonical Gallowfell ships always-owned.
@export_group("Ownership defaults")
@export var always_owned: bool = false         ## True for canonical Gallowfell only
@export var owned_at_account_create: bool = false  ## Free-default themes (none at launch besides canonical)

## Per-card treatments authored for this theme. Sparse — a stubbed theme can ship with
## the canonical art retained and only `display_name` swapped per card; full art comes later.
@export_group("Per-card content")
@export var card_theme_treatments: Array[CardThemeTreatment] = []

@export_multiline var pitch: String = ""       ## 1-paragraph pitch from theme_packs_system_v0.md §3
@export_multiline var ip_notes: String = ""    ## Internal IP audit notes; never surfaced to players


## Returns the per-card override for a given canonical card id, or null if this theme has no
## treatment for that card (i.e. caller falls back to canonical art + themed name only).
## TEST: every art-complete theme should resolve a treatment for every card in cards_*_v1.md.
func get_treatment_for(card_id: StringName) -> CardThemeTreatment:
	for t in card_theme_treatments:
		if t != null and t.card_id == card_id:
			return t
	return null


func is_free() -> bool:
	return always_owned or owned_at_account_create or price_tier_gbp == 0.0


## Validation hook — matches the Card.validate() pattern. Catches authoring slips.
## TEST: should reject LICENSED_BLOCKED entries unless `ip_notes` is populated (audit guard).
func validate() -> Array[String]:
	var errors: Array[String] = []
	if id == &"":
		errors.append("ThemePack has no id")
	if display_name == "":
		errors.append("ThemePack '%s' has no display_name" % id)
	if price_tier_gbp < 0.0:
		errors.append("ThemePack '%s' has negative price_tier_gbp (%.2f)" % [id, price_tier_gbp])
	if category == GFEnums.ThemePackCategory.LICENSED_BLOCKED and ip_notes == "":
		errors.append("ThemePack '%s' is LICENSED_BLOCKED but has no ip_notes audit trail" % id)
	if status == GFEnums.ThemePackStatus.ART_COMPLETE and card_theme_treatments.is_empty():
		errors.append("ThemePack '%s' marked ART_COMPLETE but card_theme_treatments is empty" % id)
	if always_owned and price_tier_gbp > 0.0:
		errors.append("ThemePack '%s' is always_owned but price_tier_gbp > 0" % id)
	# Per-card treatments each validate themselves.
	for t in card_theme_treatments:
		if t == null:
			errors.append("ThemePack '%s' has a null CardThemeTreatment entry" % id)
			continue
		errors.append_array(t.validate())
	return errors
