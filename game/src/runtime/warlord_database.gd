extends Node
## WarlordDatabase (WL-2) — roster source of truth. Scans res://data/warlords/*.tres
## once at boot and indexes by id. Used by the Warlord-select screen (WL-3) and
## run-start warlord→faction resolution (replaces the hardcoded map in
## run_controller — WL-5). Registered as an autoload after GameState + CardDatabase.
##
## Only top-level .tres are roster entries; tier sidecars (`*_tiers.tres`) and the
## `_deprecated/` archive folder are skipped.

const WARLORDS_DIR := "res://data/warlords/"

var _by_id: Dictionary = {}                      ## StringName -> Warlord


func _ready() -> void:
	_scan()
	print("[WarlordDatabase] indexed %d warlords (%d free, %d paid)" %
			[_by_id.size(), free_warlords().size(), paid_warlords().size()])


func _scan() -> void:
	_by_id.clear()
	var dir := DirAccess.open(WARLORDS_DIR)
	if dir == null:
		push_error("[WarlordDatabase] cannot open %s" % WARLORDS_DIR)
		return
	for f in dir.get_files():                     # top-level only; skips _deprecated/
		if not (f.ends_with(".tres") or f.ends_with(".tres.remap")):
			continue
		if f.ends_with("_tiers.tres"):            # tier sidecars, not roster entries
			continue
		var w := load(WARLORDS_DIR + f.trim_suffix(".remap")) as Warlord
		if w != null and w.id != &"":
			_by_id[w.id] = w


func get_by_id(id: StringName) -> Warlord:
	return _by_id.get(id)


## Warlord → faction, NEUTRAL if the id is unknown.
func faction_of(id: StringName) -> int:
	var w: Warlord = _by_id.get(id)
	return w.faction if w != null else GFEnums.Faction.NEUTRAL


## Free (starter) Warlords, sorted by faction for a stable roster row.
func free_warlords() -> Array:
	var out: Array = []
	for w in _by_id.values():
		if w.is_free:
			out.append(w)
	out.sort_custom(func(a, b): return a.faction < b.faction)
	return out


## Purchasable Warlords (is_free == false, no lore-lock unlock_tag).
func paid_warlords() -> Array:
	var out: Array = []
	for w in _by_id.values():
		if not w.is_free and w.unlock_tag == &"":
			out.append(w)
	out.sort_custom(func(a, b): return a.faction < b.faction)
	return out
