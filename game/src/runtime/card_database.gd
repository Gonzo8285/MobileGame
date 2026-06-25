extends Node
## CardDatabase (DB-1) — single source of truth for "what cards exist".
##
## Scans res://data/cards/** once at boot and indexes every Card resource by id
## and by faction. Shared by the deck-builder (draftable_for), the reward
## generator, the collection/codex screen, and run-start id->Card resolution.
##
## Registered as an autoload AFTER GameState (see project.godot [autoload]).

const CARDS_ROOT := "res://data/cards/"

var _by_id: Dictionary = {}              ## StringName -> Card
var _by_faction: Dictionary = {}         ## GFEnums.Faction (int) -> Array[Card]


func _ready() -> void:
	_scan()
	_print_smoke()


## Re-scan the card pool from disk. Idempotent — clears and rebuilds the indices.
func _scan() -> void:
	_by_id.clear()
	_by_faction.clear()
	var root := DirAccess.open(CARDS_ROOT)
	if root == null:
		push_error("[CardDatabase] cannot open %s" % CARDS_ROOT)
		return
	# Faction subfolders (iron_penitents/, ash_mourners/, coven/, ...).
	for sub in root.get_directories():
		var dir := DirAccess.open(CARDS_ROOT + sub)
		if dir == null:
			continue
		for f in dir.get_files():
			_try_index(CARDS_ROOT + sub + "/" + f)
	# Any loose .tres at the root (legacy / token spillover) — harmless if none.
	for f in root.get_files():
		_try_index(CARDS_ROOT + f)


## Load one file as a Card and index it. Accepts .tres and exported .tres.remap.
func _try_index(raw_path: String) -> void:
	if not (raw_path.ends_with(".tres") or raw_path.ends_with(".tres.remap")):
		return
	var path := raw_path.trim_suffix(".remap")
	var card := load(path) as Card
	if card == null or card.id == &"":
		return
	_by_id[card.id] = card
	if not _by_faction.has(card.faction):
		_by_faction[card.faction] = ([] as Array[Card])
	(_by_faction[card.faction] as Array[Card]).append(card)


func _print_smoke() -> void:
	var parts: Array[String] = []
	for fac in _by_faction.keys():
		parts.append("%s=%d" % [GFEnums.Faction.keys()[fac], (_by_faction[fac] as Array).size()])
	parts.sort()
	print("[CardDatabase] indexed %d cards across %d factions — %s" %
			[_by_id.size(), _by_faction.size(), ", ".join(parts)])


# ============================================================================
# Public API
# ============================================================================

func get_by_id(id: StringName) -> Card:
	return _by_id.get(id)


## Every indexed card (units, spells, traps, tokens, relics) — for the codex.
func all_cards() -> Array[Card]:
	var out: Array[Card] = []
	for c in _by_id.values():
		out.append(c)
	return out


## All cards of one faction (codex view — includes non-draftables).
func by_faction(faction: int) -> Array[Card]:
	var out: Array[Card] = []
	for c in _by_faction.get(faction, []):
		out.append(c)
	return out


## Per-faction total counts (codex tab headers / boot smoke).
func counts_by_faction() -> Dictionary:
	var out: Dictionary = {}
	for fac in _by_faction.keys():
		out[fac] = (_by_faction[fac] as Array).size()
	return out


## Draftable cards across a faction set (e.g. [active_faction, NEUTRAL]).
## Tokens/relics (is_draftable == false) excluded. Sorted by cost, then name.
func draftable_for(factions: Array) -> Array[Card]:
	var out: Array[Card] = []
	for fac in factions:
		for c in _by_faction.get(fac, []):
			if c.is_draftable:
				out.append(c)
	out.sort_custom(func(a, b):
		return a.cost < b.cost if a.cost != b.cost else a.display_name < b.display_name)
	return out


## Resolve an ordered id list into deep-copied Card resources for a run.
## Unknown ids are skipped. Repeated ids yield repeated copies (multi-copy ready).
func resolve_deck(ids: Array) -> Array[Card]:
	var out: Array[Card] = []
	for id in ids:
		var c: Card = _by_id.get(id)
		if c != null:
			out.append(c.duplicate_card())
	return out
