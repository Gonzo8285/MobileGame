extends Resource
class_name CardTreatment

## CardTreatment — catalog entry for a single cosmetic treatment.
##
## See art_direction.md §2 for the canonical Snap-style treatment system. Treatments
## are visual-only — they NEVER alter gameplay (cost, stats, keywords, effect text).
## See the anti-P2W audit in art_direction.md §2.
##
## Authored entries live in `game/data/treatments/treatment_definitions.tres`
## (a TreatmentCatalog resource). Runtime player-owned cosmetic state lives on
## CardInstance (game/src/runtime/card_instance.gd), NOT on the gameplay Card resource.

@export var id: StringName = &""              ## Stable id (e.g. &"foil", &"gold", &"frame_iron_penitents")
@export var display_name: String = ""          ## Player-facing name
@export var tier: GFEnums.TreatmentTier = GFEnums.TreatmentTier.DEFAULT

## Acquisition + economy. Mirrors the price-tier column in art_direction.md §2.
@export_group("Economy")
@export var price_usd: float = 0.0             ## 0.0 = free / earned
@export var unlock_method: String = ""         ## Human-readable: "gacha + low-tier IAP", "season pass premium", etc.
@export var is_event_limited: bool = false     ## True for Cursed (14-day window) and similar event-exclusives
@export var event_window_days: int = 0         ## Length of the limited window when is_event_limited

## Visual-stack hooks. Shaders themselves are authored in T2 (Phase 2.10); these are
## the parameter slots the engine will hand to the CardView shader pipeline. T1's job is
## to lock the data shape so retrofits aren't needed.
@export_group("Visual stack")
@export var shader_path: String = ""           ## res:// path to the treatment shader (filled in T2)
@export var alt_art_id: StringName = &""       ## Optional alt-art binding (Ink monochrome, future variants)
@export var faction_filter: GFEnums.Faction = GFEnums.Faction.NEUTRAL  ## Used by FACTION_FRAME entries; NEUTRAL = applies to any
@export var stack_layer: int = 0               ## Render order: lower = closer to base art, higher = top overlay
@export var animated: bool = false             ## True = per-frame shader (battery cost; UI may downgrade on low-power mode)

## Combination treatments (Ultimate = Gold base + Prism overlay + animated highlight per art_direction.md §2).
## Engine reads this list, looks each id up in the TreatmentCatalog, and stacks them in stack_layer order.
@export_group("Combo")
@export var combines: Array[StringName] = []

@export_multiline var description: String = ""

## Validation hook — call from a unit test or editor tool. Returns empty array if valid,
## otherwise a list of human-readable problems.
func validate() -> Array[String]:
	var errors: Array[String] = []
	if id == &"":
		errors.append("CardTreatment has no id")
	if display_name == "":
		errors.append("CardTreatment '%s' has no display_name" % id)
	if price_usd < 0.0:
		errors.append("CardTreatment '%s' has negative price (%.2f)" % [id, price_usd])
	if is_event_limited and event_window_days <= 0:
		errors.append("CardTreatment '%s' is event_limited but event_window_days is %d" % [id, event_window_days])
	if tier == GFEnums.TreatmentTier.FACTION_FRAME and faction_filter == GFEnums.Faction.NEUTRAL:
		errors.append("CardTreatment '%s' is FACTION_FRAME but faction_filter is NEUTRAL" % id)
	return errors
