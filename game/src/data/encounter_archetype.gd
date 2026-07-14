extends Resource
class_name EncounterArchetype

## Encounter archetype (BM-1) — defines WHO you fight and HOW they behave for a
## combat / elite / horde map node, plus a map SYMBOL so the player reads the
## threat and tunes their deck before committing to a route.
## Spec: BRANCHING_MAP_SPEC_2026-06-01.md §2.
##
## Stat / keyword / density biases layer on top of WaveGenerator's round scaling
## (see WaveGenerator.for_node — BM-3). The catalog is code-defined below.

@export var id: StringName = &""
@export var display_name: String = ""          ## telegraph label, e.g. "Plague Tide"
@export var symbol: String = ""                ## map glyph (unicode v0; icon art in B3)
@export var blurb: String = ""                 ## one line on tap: how it plays
@export var density: int = 0                    ## enemy-count bias: -1 few / 0 normal / +1 many
@export var hp_bias: float = 1.0               ## stat multipliers over round scaling
@export var atk_bias: float = 1.0
@export var move_bias: int = 0                  ## faster(+) / slower(-) advance
@export var emphasise_keywords: Array[GFEnums.Keyword] = []   ## tactic = enemy keyword bias
@export var prefer_faction: GFEnums.Faction = GFEnums.Faction.NEUTRAL


# ============================================================================
# Catalog — v0 seven archetypes (code-defined, cached)
# ============================================================================

static var _catalog: Dictionary = {}


static func catalog() -> Dictionary:
	if _catalog.is_empty():
		_build_catalog()
	return _catalog


static func get_archetype(id: StringName) -> EncounterArchetype:
	return catalog().get(id)


static func ids() -> Array[StringName]:
	var out: Array[StringName] = []
	for k in catalog().keys():
		out.append(k)
	return out


static func _build_catalog() -> void:
	var list: Array = [
		_mk(&"swarm", "Brood Swarm", "∴",
			"Many weak, fast enemies — bring AoE / Cleave and lane control.",
			1, 0.7, 1.0, 1, []),
		_mk(&"bruisers", "Iron Vanguard", "▰",
			"Few, heavily-armoured bruisers — bring Pierce and big single hits.",
			-1, 1.8, 1.2, -1, []),
		_mk(&"plague", "Plague Tide", "☣",
			"Poison / bleed carriers — burst them before the stacks pile up.",
			0, 1.1, 1.0, 0, [GFEnums.Keyword.POISON, GFEnums.Keyword.BLEED]),
		_mk(&"volley", "Ranged Volley", "»",
			"Back-line ranged attackers — rush the line or bring Taunt / Shield.",
			0, 1.0, 1.3, 0, []),
		_mk(&"ambush", "Flanking Ambush", "↯",
			"Fast flankers with burst — hold board presence, punish the rush.",
			0, 0.9, 1.2, 1, []),
		_mk(&"summoners", "Wretch-Callers", "⊛",
			"Summons adds every turn — kill the source and win on tempo.",
			0, 1.0, 0.9, 0, [GFEnums.Keyword.SUMMON]),
		_mk(&"dread", "Dread Procession", "◓",
			"Fear / smoke / slow debuffers — bring resilient units and go wide.",
			0, 1.1, 0.9, -1, [GFEnums.Keyword.FEAR, GFEnums.Keyword.SMOKE, GFEnums.Keyword.SLOW]),
	]
	for a in list:
		_catalog[a.id] = a


static func _mk(p_id: StringName, p_name: String, p_symbol: String, p_blurb: String,
		p_density: int, p_hp: float, p_atk: float, p_move: int,
		p_kws: Array) -> EncounterArchetype:
	var a := EncounterArchetype.new()
	a.id = p_id
	a.display_name = p_name
	a.symbol = p_symbol
	a.blurb = p_blurb
	a.density = p_density
	a.hp_bias = p_hp
	a.atk_bias = p_atk
	a.move_bias = p_move
	a.emphasise_keywords.assign(p_kws)
	return a
