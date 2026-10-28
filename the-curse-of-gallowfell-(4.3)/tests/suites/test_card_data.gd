extends GFTest

## Data-integrity gate: every card and enemy .tres loads, passes its own
## validate(), ids are unique, and the starter pool is non-empty. Cheapest,
## highest-value CI guard — catches a bad .tres before combat ever sees it.
##
## Cards live in per-faction subdirectories (data/cards/<faction>/); the
## loader therefore recurses. A card sitting loose at data/cards/ root is the
## exact drift the 2026-08-06 golden audit found, so placement is asserted.

const CARDS_DIR: String = "res://data/cards/"
const ENEMIES_DIR: String = "res://data/enemies/"

## dir name -> GFEnums.Faction ordinal, and the id prefix its cards must use.
const FACTION_DIRS: Dictionary = {
	"iron_penitents": {"faction": 0, "prefix": "P"},
	"ash_mourners": {"faction": 1, "prefix": "M"},
	"coven": {"faction": 2, "prefix": "C"},
	"last_legion": {"faction": 3, "prefix": "L"},
	"skinward_pact": {"faction": 4, "prefix": "W"},
}

func _load_all(dir_path: String, recurse: bool = true) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var f: String = dir.get_next()
	while f != "":
		if dir.current_is_dir():
			if recurse and not f.begins_with("."):
				out.append_array(_load_all(dir_path + f + "/", true))
		elif f.ends_with(".tres"):
			out.append({"path": dir_path + f, "res": load(dir_path + f)})
		f = dir.get_next()
	dir.list_dir_end()
	return out

func _files_at(dir_path: String) -> Array[String]:
	var out: Array[String] = []
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var f: String = dir.get_next()
	while f != "":
		if not dir.current_is_dir() and f.ends_with(".tres"):
			out.append(f)
		f = dir.get_next()
	dir.list_dir_end()
	return out

func test_all_cards_load_and_validate() -> void:
	var cards: Array[Dictionary] = _load_all(CARDS_DIR)
	assert_not_empty(cards, "expected at least one card .tres under %s" % CARDS_DIR)
	for entry: Dictionary in cards:
		var c: Card = entry["res"] as Card
		assert_not_null(c, "%s failed to load as Card" % entry["path"])
		if c != null:
			var errs: Array[String] = c.validate()
			assert_empty(errs, "%s invalid: %s" % [entry["path"], str(errs)])

func test_all_enemies_load_and_have_sane_stats() -> void:
	var enemies: Array[Dictionary] = _load_all(ENEMIES_DIR)
	assert_not_empty(enemies, "expected at least one enemy .tres under %s" % ENEMIES_DIR)
	for entry: Dictionary in enemies:
		var e: Enemy = entry["res"] as Enemy
		assert_not_null(e, "%s failed to load as Enemy" % entry["path"])
		if e != null:
			assert_ne(e.id, &"", "%s has empty id" % entry["path"])
			assert_gt(e.max_hp, 0, "%s max_hp must be > 0" % entry["path"])
			assert_ge(e.base_strike_damage(), 0, "%s base strike damage negative" % entry["path"])

func test_card_ids_are_unique() -> void:
	var cards: Array[Dictionary] = _load_all(CARDS_DIR)
	var seen: Dictionary = {}
	for entry: Dictionary in cards:
		var c: Card = entry["res"] as Card
		if c == null:
			continue
		assert_false(seen.has(c.id), "duplicate card id %s (%s)" % [c.id, entry["path"]])
		seen[c.id] = true

func test_starter_pool_non_empty() -> void:
	var cards: Array[Dictionary] = _load_all(CARDS_DIR)
	var starters: int = 0
	for entry: Dictionary in cards:
		var c: Card = entry["res"] as Card
		if c != null and c.is_starter:
			starters += 1
	assert_gt(starters, 0, "no cards flagged is_starter — a run cannot build a deck")

## --- placement gates (the drift the 2026-08-06 golden audit caught) --------

func test_no_cards_loose_at_cards_root() -> void:
	var loose: Array[String] = _files_at(CARDS_DIR)
	assert_empty(loose, "card .tres loose at %s (must live in a faction subdir): %s" % [CARDS_DIR, str(loose)])

func test_every_faction_dir_is_populated() -> void:
	for dir_name: String in FACTION_DIRS.keys():
		var found: Array[Dictionary] = _load_all(CARDS_DIR + dir_name + "/", false)
		assert_not_empty(found, "faction dir %s%s/ is empty or missing" % [CARDS_DIR, dir_name])

func test_cards_sit_in_the_subdir_matching_their_faction() -> void:
	for dir_name: String in FACTION_DIRS.keys():
		var spec: Dictionary = FACTION_DIRS[dir_name]
		for entry: Dictionary in _load_all(CARDS_DIR + dir_name + "/", false):
			var c: Card = entry["res"] as Card
			if c == null:
				continue
			assert_eq(int(c.faction), int(spec["faction"]),
				"%s is faction %d but sits in %s/ (expects %d)" % [entry["path"], int(c.faction), dir_name, int(spec["faction"])])
			assert_true(String(c.id).begins_with(String(spec["prefix"])),
				"%s has id %s — %s/ cards must use the '%s' prefix" % [entry["path"], c.id, dir_name, String(spec["prefix"])])

func test_no_card_id_gaps_within_a_faction() -> void:
	## Ports/relocations drop files silently; a numbering hole is the tell.
	for dir_name: String in FACTION_DIRS.keys():
		var spec: Dictionary = FACTION_DIRS[dir_name]
		var nums: Array[int] = []
		for entry: Dictionary in _load_all(CARDS_DIR + dir_name + "/", false):
			var c: Card = entry["res"] as Card
			if c == null:
				continue
			var n: String = String(c.id).substr(String(spec["prefix"]).length())
			if n.is_valid_int():
				nums.append(int(n))
		assert_not_empty(nums, "no parseable ids in %s/" % dir_name)
		nums.sort()
		for i: int in range(1, nums.size()):
			var gap: int = nums[i] - nums[i - 1]
			# the pool is intentionally split into a 1..N common block and a 41+
			# elite block, so tolerate exactly one large jump, never a small hole.
			assert_true(gap == 1 or nums[i - 1] < 40,
				"%s/ id gap: %s%d -> %s%d (missing card?)" % [dir_name, String(spec["prefix"]), nums[i - 1], String(spec["prefix"]), nums[i]])
