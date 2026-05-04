extends Resource
class_name Card

## Card resource — the single data shape for every card in The Curse of Gallowfell.
## Designed to round-trip cleanly between .tres files (editor-authored) and runtime instances
## (deck/hand/discard). Schema mirrors cards_v0.md v1.0.
##
## ID convention: `<faction-letter><number>` (e.g. "P1" Nail-Choir Flagellant, "M5" Last Censer-Bearer,
## "C6" Mother Quag). Stable across balance passes — never reuse a retired ID.

@export var id: StringName = &""              ## Stable card identifier (e.g. "P1")
@export var display_name: String = ""         ## Player-facing name
@export var faction: GFEnums.Faction = GFEnums.Faction.NEUTRAL
@export var card_type: GFEnums.CardType = GFEnums.CardType.UNIT
@export var rarity: GFEnums.Rarity = GFEnums.Rarity.COMMON
@export var cost: int = 0                     ## Mana cost to play

## Unit-only stats. Ignored when card_type != UNIT.
@export_group("Unit stats")
@export var hp: int = 0
@export var attack: int = 0
@export var attack_range: GFEnums.AttackRange = GFEnums.AttackRange.NONE
@export var cooldown: int = 0                 ## Turns between attacks; 1 = every turn

## Keywords + descriptive text. Keyword enum drives gameplay branches; effect_text is flavour/UI only.
@export_group("Effects")
@export var keywords: Array[GFEnums.Keyword] = []
@export_multiline var effect_text: String = ""
@export_multiline var flavour_text: String = ""

## Art / audio hooks. Empty until B3 art pass; UI must fall back to placeholder when null.
@export_group("Presentation")
@export var art_path: String = ""             ## res:// path to card portrait
@export var icon_path: String = ""            ## small icon for hand/deck list
@export var sfx_play: String = ""             ## sound on play
@export var sfx_death: String = ""            ## sound on death (units only)

## Draftability + economy flags.
@export_group("Meta")
@export var is_draftable: bool = true         ## False = token-only (e.g. summoned units)
@export var is_starter: bool = false          ## True = available in MVP starter decks
@export var unlock_tag: StringName = &""      ## Optional gate (e.g. &"warlord_iron_choirmaster")


## Deep copy of this card resource. Used when moving cards between deck/hand/discard so
## per-instance state (e.g. temp buffs from Procession of Nails) doesn't bleed across copies.
func duplicate_card() -> Card:
	var copy := duplicate(true) as Card
	return copy


## Convenience predicate — keeps call sites readable: `if card.has_keyword(GFEnums.Keyword.CLEAVE):`
func has_keyword(kw: GFEnums.Keyword) -> bool:
	return keywords.has(kw)


## Validation hook — call from a unit test or editor tool. Returns empty array if valid,
## otherwise a list of human-readable problems. Cheap to run; designed for CI gating.
func validate() -> Array[String]:
	var errors: Array[String] = []
	if id == &"":
		errors.append("Card has no id")
	if display_name == "":
		errors.append("Card '%s' has no display_name" % id)
	if cost < 0:
		errors.append("Card '%s' has negative cost (%d)" % [id, cost])
	if card_type == GFEnums.CardType.UNIT:
		if hp <= 0:
			errors.append("Unit '%s' has hp <= 0 (%d)" % [id, hp])
		if attack < 0:
			errors.append("Unit '%s' has negative attack (%d)" % [id, attack])
	else:
		# Non-units shouldn't carry combat stats — flags accidental data entry, not a hard failure.
		if hp != 0 or attack != 0 or cooldown != 0:
			errors.append("Non-unit '%s' has stray combat stats (hp=%d atk=%d cd=%d)" %
				[id, hp, attack, cooldown])
	return errors
