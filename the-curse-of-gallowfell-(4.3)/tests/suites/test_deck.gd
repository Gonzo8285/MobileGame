extends GFTest

## Deck / Discard zone mechanics: draw, empty behaviour, deterministic shuffle,
## mill, and reshuffle-from-discard.

func _cards(n: int) -> Array[Card]:
	var out: Array[Card] = []
	for i: int in range(n):
		out.append(GFFactory.unit_card(StringName("U%d" % i), 1, 3, 2))
	return out

func test_size_and_draw() -> void:
	var d: Deck = Deck.new(_cards(3), 1)
	assert_eq(d.size(), 3, "3 cards in")
	var c: Card = d.draw_one()
	assert_not_null(c, "drew a card")
	assert_eq(d.size(), 2, "size drops after draw")

func test_draw_empty_returns_null() -> void:
	var d: Deck = Deck.new([], 1)
	assert_null(d.draw_one(), "empty deck draws null")

func test_shuffle_is_deterministic_with_seed() -> void:
	var a: Deck = Deck.new(_cards(8), 42)
	var b: Deck = Deck.new(_cards(8), 42)
	a.shuffle()
	b.shuffle()
	var ca: Array[Card] = a.cards()
	var cb: Array[Card] = b.cards()
	assert_eq(ca.size(), cb.size(), "same size")
	for i: int in range(ca.size()):
		assert_eq(ca[i].id, cb[i].id, "same seed → same order at %d" % i)

func test_mill_moves_to_discard() -> void:
	var d: Deck = Deck.new(_cards(5), 1)
	var disc: Discard = Discard.new()
	var milled: Array[Card] = d.mill(2, disc)
	assert_eq(milled.size(), 2, "milled 2")
	assert_eq(d.size(), 3, "deck reduced")
	assert_eq(disc.size(), 2, "discard grew")

func test_reshuffle_from_discard_on_empty_draw() -> void:
	var d: Deck = Deck.new(_cards(1), 1)
	var disc: Discard = Discard.new()
	disc.add(GFFactory.unit_card(&"X", 1, 3, 2))
	disc.add(GFFactory.unit_card(&"Y", 1, 3, 2))
	assert_not_null(d.draw_one(disc), "first draw from deck")
	# deck now empty; next draw should auto-reshuffle the 2 discard cards
	assert_not_null(d.draw_one(disc), "auto-reshuffle draw 1")
	assert_not_null(d.draw_one(disc), "auto-reshuffle draw 2")
	assert_eq(disc.size(), 0, "discard consumed by reshuffle")
