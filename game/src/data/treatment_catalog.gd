extends Resource
class_name TreatmentCatalog

## TreatmentCatalog — single resource that holds every cosmetic CardTreatment in the game.
##
## Authoring file: `game/data/treatments/treatment_definitions.tres`
## Lookup at runtime via `get_by_id(&"foil")` etc. Used by the collection screen (T4) and
## the CardView shader pipeline (T2) to resolve a CardInstance's treatment_id into the
## actual visual stack.
##
## Adding a new treatment = new SubResource entry in treatment_definitions.tres + an enum
## value if it's a brand-new tier. Visual-only edits don't need code changes.

@export var treatments: Array[CardTreatment] = []


func get_by_id(id: StringName) -> CardTreatment:
	for t in treatments:
		if t != null and t.id == id:
			return t
	return null


## Returns every treatment matching a given tier. Mostly useful for the collection-screen
## tier filter (T4) and for the gacha drop-table (each pull rolls within a tier bucket).
func get_by_tier(tier: GFEnums.TreatmentTier) -> Array[CardTreatment]:
	var out: Array[CardTreatment] = []
	for t in treatments:
		if t != null and t.tier == tier:
			out.append(t)
	return out


## Returns the faction-specific frame for a faction (or null if not catalogued yet).
func get_faction_frame(faction: GFEnums.Faction) -> CardTreatment:
	for t in treatments:
		if t != null and t.tier == GFEnums.TreatmentTier.FACTION_FRAME and t.faction_filter == faction:
			return t
	return null


## Validation hook — runs every treatment's own validate() plus catalog-level checks
## (duplicate ids, missing default entry, broken combo references). Returns empty array
## when clean. Cheap; safe to wire into a CI smoke test.
func validate() -> Array[String]:
	var errors: Array[String] = []
	var seen: Dictionary = {}
	var ids: Dictionary = {}

	for t in treatments:
		if t == null:
			errors.append("TreatmentCatalog has a null entry")
			continue
		if seen.has(t.id):
			errors.append("Duplicate treatment id '%s'" % t.id)
		seen[t.id] = true
		ids[t.id] = true
		errors.append_array(t.validate())

	if not ids.has(&"default"):
		errors.append("TreatmentCatalog is missing the 'default' entry (every card must resolve to something)")

	# Combo references must point at real ids — flags typos and stale references early.
	for t in treatments:
		if t == null:
			continue
		for ref in t.combines:
			if not ids.has(ref):
				errors.append("Treatment '%s' combines unknown id '%s'" % [t.id, ref])

	return errors
