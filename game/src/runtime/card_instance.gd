extends RefCounted
class_name CardInstance

## CardInstance — a player's owned copy of a card, with cosmetic state.
##
## The Card Resource (game/src/data/card.gd) stays gameplay-only and is shared across
## every player who owns this card; cosmetic per-instance state (treatment, alt-art,
## acquisition metadata) lives here. Two players can both own card P1 with different
## treatments without the gameplay resource branching.
##
## Combat code only ever reads `card` — the gameplay layer never touches treatment_id.
## UI code reads `treatment_id` + `alt_art_id` to assemble the shader stack via
## TreatmentCatalog.
##
## Spec: backlog.md Phase 2.10 T1. Visual stack: backlog.md T2. Collection UI: T4.

var card: Card
var treatment_id: StringName = &"default"
var alt_art_id: StringName = &""

## Acquisition metadata — drives the collection-screen "new!" badge, drop-rate analytics,
## and limited-edition serial flex. Cheap; never surfaced to combat.
var acquired_at: int = 0           ## Unix timestamp of first acquisition
var acquired_via: StringName = &"" ## &"starter", &"reward_pick", &"shop", &"gacha", &"battle_pass", &"event_cursed"
var serial: int = 0                ## Limited-run print serial (Cursed-tier collector flex). 0 = not numbered.


func _init(p_card: Card,
		p_treatment_id: StringName = &"default",
		p_alt_art_id: StringName = &"",
		p_acquired_via: StringName = &"") -> void:
	card = p_card
	treatment_id = p_treatment_id
	alt_art_id = p_alt_art_id
	acquired_via = p_acquired_via


## True if this instance has no cosmetic upgrades — i.e. plain default frame, no alt art.
## Used by the collection screen to grey-out un-treated cards.
func is_default_cosmetic() -> bool:
	return treatment_id == &"default" and alt_art_id == &""


## Equality-by-cosmetic — used to dedupe display when a player owns multiple identical
## copies of a card with the same treatment. Different treatments = separate display entries.
func cosmetic_key() -> String:
	return "%s|%s|%s" % [card.id, treatment_id, alt_art_id]


## Snapshots the instance for save-game serialisation. Card itself is referenced by id —
## resolved against the global card pool on load to avoid persisting gameplay state.
func to_dict() -> Dictionary:
	return {
		"card_id": card.id,
		"treatment_id": treatment_id,
		"alt_art_id": alt_art_id,
		"acquired_at": acquired_at,
		"acquired_via": acquired_via,
		"serial": serial,
	}
