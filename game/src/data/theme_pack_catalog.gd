extends Resource
class_name ThemePackCatalog

## ThemePackCatalog — single resource holding every ThemePack in the game.
##
## Authoring file: `game/data/themes/theme_pack_definitions.tres`
## Mirrors `treatment_catalog.gd` shape — Card collection + treatment-catalog convention.
##
## Lookup at runtime via `get_by_id(&"grimm_reaping")`. Used by ThemePackManager to resolve
## the active theme(s) and by the Cosmetic Library / Theme Packs tab (collection_ui_v0.md +
## variants_system_v0.md §10.2 extension).
##
## Adding a new theme = add the ThemePack sub-resource entry here AND author a
## `game/data/themes/<id>/theme.tres` for the per-theme content. The catalog only carries
## metadata + price + status; per-card treatments live on the per-theme `theme.tres`.

@export var themes: Array[ThemePack] = []


func get_by_id(id: StringName) -> ThemePack:
	for t in themes:
		if t != null and t.id == id:
			return t
	return null


## Returns every theme matching a given IP category. Used by the shop filter ("only
## public-domain themes") and by the IP-audit smoke check.
func get_by_category(category: GFEnums.ThemePackCategory) -> Array[ThemePack]:
	var out: Array[ThemePack] = []
	for t in themes:
		if t != null and t.category == category:
			out.append(t)
	return out


## Returns every art-complete theme. Drives the "Themed (full art)" filter on the storefront.
func get_art_complete() -> Array[ThemePack]:
	var out: Array[ThemePack] = []
	for t in themes:
		if t != null and t.status == GFEnums.ThemePackStatus.ART_COMPLETE:
			out.append(t)
	return out


## Returns the canonical (always-owned, free) theme. Falls back to the first theme in the
## catalog if none is flagged — but `validate()` will yell if that ever happens.
func get_canonical() -> ThemePack:
	for t in themes:
		if t != null and t.always_owned:
			return t
	return themes[0] if not themes.is_empty() else null


## Validation hook — runs every theme's validate() plus catalog-level checks.
## Returns empty array when clean. Cheap; safe to wire into a CI smoke test.
func validate() -> Array[String]:
	var errors: Array[String] = []
	var seen: Dictionary = {}
	var canonical_count: int = 0
	var licensed_blocked_in_shop: bool = false

	for t in themes:
		if t == null:
			errors.append("ThemePackCatalog has a null entry")
			continue
		if seen.has(t.id):
			errors.append("Duplicate theme id '%s'" % t.id)
		seen[t.id] = true
		errors.append_array(t.validate())
		if t.always_owned:
			canonical_count += 1
		# Hard IP guard — a LICENSED_BLOCKED entry with a non-zero price is a packaging mistake.
		if t.category == GFEnums.ThemePackCategory.LICENSED_BLOCKED and t.price_tier_gbp > 0.0:
			licensed_blocked_in_shop = true

	if canonical_count == 0:
		errors.append("ThemePackCatalog has no always_owned canonical theme (need at least 1)")
	if canonical_count > 1:
		errors.append("ThemePackCatalog has %d always_owned themes — should be exactly 1" % canonical_count)
	if licensed_blocked_in_shop:
		errors.append("ThemePackCatalog has a LICENSED_BLOCKED theme priced for sale — IP audit fail")

	return errors
