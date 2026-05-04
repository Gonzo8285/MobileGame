extends Resource
class_name Enemy

## Enemy Resource (B2.5) — declarative data for a single enemy archetype.
##
## Mirrors the shape of `Card` (see card.gd) so the same authoring pattern
## works: one `.tres` file per enemy, ID = filename, faction-scoped folders
## under `res://data/enemies/`. Concrete instances at runtime live in
## `enemy_instance.gd` and hold mutable per-fight state (HP, position).
##
## Stats here are the *base* values. Statuses, modifiers, and curse mechanics
## (Hanging Hour escalation, Reanimation) layer on at runtime in B2.7.

@export var id: StringName = &""
@export var display_name: String = ""

## Visual / lore flag. Currently informational; the boss escalation rules in
## B2.7 (Hanging Hour) will branch on this.
@export var is_boss: bool = false

# ---------- Combat stats ---------------------------------------------------

@export_range(1, 200) var max_hp: int = 6
@export_range(0, 99) var attack: int = 2
@export_range(0, 99) var armor: int = 0

## Tiles moved per turn-tick. 1 = standard advance. 0 = stationary (siege /
## emplacement). 2 = fast (rusher). Capped at 3 for sanity in the wave-builder.
@export_range(0, 3) var move_speed: int = 1

## How much HP the player base loses when this enemy reaches tile 0.
## Defaults to `attack` if 0; explicit override lets us make tankier enemies
## hit the base for more without giving them disproportionate combat ATK.
@export_range(0, 99) var base_damage_override: int = 0

# ---------- Tags / categorisation ------------------------------------------

@export var faction: GFEnums.Faction = GFEnums.Faction.NEUTRAL
@export var keywords: Array[GFEnums.Keyword] = []

## Free-text flavour for the card-text panel. Kept on the resource so
## designers can tweak without touching code.
@export_multiline var flavour: String = ""


# ============================================================================
# Convenience
# ============================================================================

func base_strike_damage() -> int:
	return base_damage_override if base_damage_override > 0 else attack


func has_keyword(kw: GFEnums.Keyword) -> bool:
	return keywords.has(kw)


func _to_string() -> String:
	return "Enemy(%s '%s' hp=%d atk=%d spd=%d)" % [
		id, display_name, max_hp, attack, move_speed
	]
