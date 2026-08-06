extends GFTest

## Data-integrity gate: every card and enemy .tres loads, passes its own
## validate(), ids are unique, and the starter pool is non-empty. Cheapest,
## highest-value CI guard — catches a bad .tres before combat ever sees it.

const CARDS_DIR: String = "res://data/cards/"
const ENEMIES_DIR: String = "res://data/enemies/"

func _load_all(dir_path: String) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var f: String = dir.get_next()
	while f != "":
		if not dir.current_is_dir() and f.ends_with(".tres"):
			out.append({"path": dir_path + f, "res": load(dir_path + f)})
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
