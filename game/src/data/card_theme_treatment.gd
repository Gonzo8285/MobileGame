extends Resource
class_name CardThemeTreatment

## CardThemeTreatment — per-card-per-theme presentation override.
##
## Carries the themed art, name, flavour, and frame variant that the player sees when this
## theme is equipped for a given card. Mechanics are NEVER changed by this resource —
## combat code reads `Card`, not `CardThemeTreatment`.
##
## Authoring layout: nested as a sub-resource inside the parent ThemePack `theme.tres` under
## `card_theme_treatments`. A theme can ship as few as one entry (stubbed themes ship a name
## override only) or as many as ~342 (one per launch card, art-complete theme).
##
## Resolution priority is owned by ThemePackManager:
##     per-card override → deck-wide theme → canonical (Card.display_name / Card.art_path)

@export var card_id: StringName = &""          ## FK to Card.id — stable underlying mechanic id
@export var theme_pack_id: StringName = &""    ## FK to ThemePack.id (self-reference; convenience field)

## Themed presentation. All optional individually — a stub theme ships display_name only.
@export var art_path: String = ""              ## res:// path to themed 832×1166 illustration
@export var display_name: String = ""          ## Player-facing themed name (e.g. "The Pyre-Piper")
@export var flavour_text: String = ""          ## ≤120 chars, theme-flavoured
@export var frame_variant: StringName = &""    ## Themed frame id (e.g. &"grimm_bramble", &"iron_crusade_heraldic")
@export var sfx_variant: StringName = &""      ## Optional audio override id (per Theme Audio Pack add-on)
@export var icon_path: String = ""             ## Optional themed icon (hand/deck-list view)


## True if this entry carries only a name swap (no themed art). Drives the UI "Themed name —
## full art coming in patch X.Y" badge on stubbed themes per theme_packs_system_v0.md §5.3.
func is_stubbed() -> bool:
	return art_path == ""


## Validation hook. Required-field rules are deliberately permissive — a name-only entry is
## valid because stubbed themes are a first-class shipping shape.
func validate() -> Array[String]:
	var errors: Array[String] = []
	if card_id == &"":
		errors.append("CardThemeTreatment has no card_id")
	if display_name == "" and art_path == "" and frame_variant == &"":
		errors.append("CardThemeTreatment for '%s' overrides nothing — drop the entry instead" % card_id)
	return errors
