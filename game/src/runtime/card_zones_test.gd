extends Node

## Smoke test for Deck / Hand / Discard runtime classes (B2.3).
##
## Attach to a Node and `_ready()` runs the suite, OR call `_run()` directly
## from any other script (e.g. `main.gd` in dev mode). It loads the Iron
## Penitent .tres pool, builds a deck, exercises shuffle / draw / play / mill /
## mulligan / reshuffle, and prints the state at each step. Returns 0 on pass,
## non-zero error count on fail.
##
## (Once a real test runner lands with B2.10, fold this into it.)

const SEED: int = 1234
const POOL_DIR: String = "res://data/cards/iron_penitents/"


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[card_zones_test] PASS")
	else:
		printerr("[card_zones_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors := 0

	# ---- Load the pool ---------------------------------------------------
	var pool: Array[Card] = _load_pool(POOL_DIR)
	if pool.is_empty():
		printerr("FATAL: no cards loaded from %s" % POOL_DIR)
		return 1
	print("Loaded %d cards from %s" % [pool.size(), POOL_DIR])

	# ---- Construct zones -------------------------------------------------
	var deck := Deck.new(pool, SEED)
	var hand := Hand.new()
	var discard := Discard.new()

	deck.shuffle()
	errors += _expect_eq("deck size after shuffle", deck.size(), pool.size())

	# ---- Draw 5 ----------------------------------------------------------
	for _i in 5:
		var c: Card = deck.draw_one(discard)
		if c == null:
			errors += 1
			printerr("draw_one returned null with deck not empty")
			continue
		hand.add(c)
	errors += _expect_eq("hand size after 5 draws", hand.size(), 5)
	errors += _expect_eq("deck size after 5 draws", deck.size(), pool.size() - 5)
	print("After draw 5 — hand:%d deck:%d discard:%d" % [hand.size(), deck.size(), discard.size()])

	# ---- Play 1 (hand → discard) ----------------------------------------
	var played: Card = hand.cards()[0]
	var removed_card: Card = hand.remove(played)
	errors += _expect_eq("hand.remove returned the same card", removed_card, played)
	discard.add(removed_card)
	errors += _expect_eq("hand size after play", hand.size(), 4)
	errors += _expect_eq("discard size after play", discard.size(), 1)
	print("Played %s — hand:%d discard:%d" % [played.id, hand.size(), discard.size()])

	# ---- Mill 3 ----------------------------------------------------------
	var deck_before_mill := deck.size()
	var milled: Array[Card] = deck.mill(3, discard)
	errors += _expect_eq("milled count", milled.size(), 3)
	errors += _expect_eq("deck size after mill", deck.size(), deck_before_mill - 3)
	errors += _expect_eq("discard size after mill", discard.size(), 4)
	print("Milled 3 — deck:%d discard:%d" % [deck.size(), discard.size()])

	# ---- Mulligan --------------------------------------------------------
	var hand_before_mull := hand.size()
	var new_hand_cards: Array[Card] = hand.mulligan(deck)
	errors += _expect_eq("hand size after mulligan", hand.size(), hand_before_mull)
	errors += _expect_eq("returned-drawn matches new hand", new_hand_cards.size(), hand.size())
	print("Mulligan — hand:%d deck:%d discard:%d" % [hand.size(), deck.size(), discard.size()])

	# ---- Drain deck → trigger reshuffle on next draw --------------------
	while not deck.is_empty():
		var c: Card = deck.draw_one()
		if c != null:
			discard.add(c)
	errors += _expect_eq("deck drained to empty", deck.size(), 0)
	var discard_pre_reshuffle := discard.size()

	var trigger: Card = deck.draw_one(discard)
	if trigger == null:
		errors += 1
		printerr("draw_one with full discard returned null — reshuffle did not fire")
	else:
		# After reshuffle: discard should be empty, deck should be discard_pre - 1
		errors += _expect_eq("discard empty after reshuffle", discard.size(), 0)
		errors += _expect_eq("deck size after reshuffle-then-draw",
				deck.size(), discard_pre_reshuffle - 1)
		hand.add(trigger)  # route the drawn card so the conservation check below holds
		print("Reshuffle fired — drew %s. deck:%d discard:%d" %
				[trigger.id, deck.size(), discard.size()])

	# ---- Conservation invariant -----------------------------------------
	# Every card from the original pool must always be in exactly one zone.
	var total: int = deck.size() + hand.size() + discard.size()
	errors += _expect_eq("conservation: total cards across zones == pool size",
			total, pool.size())

	# ---- Hand-overflow rule ---------------------------------------------
	var small_hand := Hand.new(2)
	small_hand.add(pool[0])
	small_hand.add(pool[1])
	var ok: bool = small_hand.add(pool[2])
	errors += _expect_eq("overflow add returns false", ok, false)
	errors += _expect_eq("overflowed hand size capped at capacity", small_hand.size(), 2)

	# ---- Determinism check (same seed → same first draw) ----------------
	var deck_a := Deck.new(pool, SEED)
	var deck_b := Deck.new(pool, SEED)
	deck_a.shuffle()
	deck_b.shuffle()
	var card_a: Card = deck_a.draw_one()
	var card_b: Card = deck_b.draw_one()
	errors += _expect_eq("deterministic shuffle: same seed → same first draw",
			card_a.id, card_b.id)

	return errors


# ---------- helpers -----------------------------------------------------------

func _load_pool(dir_path: String) -> Array[Card]:
	var pool: Array[Card] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		printerr("could not open %s" % dir_path)
		return pool
	dir.list_dir_begin()
	var fname := dir.get_next()
	while fname != "":
		if fname.ends_with(".tres"):
			var c: Card = load(dir_path + fname)
			if c != null:
				pool.append(c)
		fname = dir.get_next()
	dir.list_dir_end()
	return pool


## Returns 0 if equal, 1 if not (and prints the diff). Designed so the caller
## can sum return values to count errors.
func _expect_eq(label: String, actual, expected) -> int:
	if actual == expected:
		return 0
	printerr("FAIL %s — expected %s got %s" % [label, expected, actual])
	return 1
