extends GFTest

## CardPlay.play_card validation + resolution for UNIT cards.

var _hand: Hand
var _discard: Discard
var _lanes: Array[Lane]

func before_each() -> void:
	_hand = Hand.new()
	_discard = Discard.new()
	_lanes = []
	for i: int in range(3):
		_lanes.append(Lane.new(i, 6))
	GameState.max_mana = 3
	GameState.mana = 3

func test_play_unit_places_and_spends_mana() -> void:
	var card: Card = GFFactory.unit_card(&"U1", 2, 4, 2)
	_hand.add(card)
	var r: Dictionary = CardPlay.play_card(card, {"lane": 1, "tile": 3}, _hand, _discard, _lanes)
	assert_true(r["success"], "play succeeded: %s" % r["reason"])
	assert_eq(GameState.mana, 1, "mana deducted by cost 2")
	assert_eq(_hand.size(), 0, "card left hand")
	assert_eq(_discard.size(), 1, "card went to discard")
	assert_eq(_lanes[1].unit_count(), 1, "unit placed in lane 1")

func test_not_enough_mana_rejected() -> void:
	GameState.mana = 1
	var card: Card = GFFactory.unit_card(&"U2", 3, 4, 2)
	_hand.add(card)
	var r: Dictionary = CardPlay.play_card(card, {"lane": 0}, _hand, _discard, _lanes)
	assert_false(r["success"], "should reject unaffordable card")
	assert_eq(_hand.size(), 1, "card stays in hand on rejection")
	assert_eq(GameState.mana, 1, "no mana spent on rejection")

func test_card_not_in_hand_rejected() -> void:
	var card: Card = GFFactory.unit_card(&"U3", 1, 4, 2)
	var r: Dictionary = CardPlay.play_card(card, {"lane": 0}, _hand, _discard, _lanes)
	assert_false(r["success"], "reject card not in hand")

func test_invalid_lane_rejected() -> void:
	var card: Card = GFFactory.unit_card(&"U4", 1, 4, 2)
	_hand.add(card)
	var r: Dictionary = CardPlay.play_card(card, {"lane": 9}, _hand, _discard, _lanes)
	assert_false(r["success"], "reject out-of-range lane")

func test_occupied_tile_rejected() -> void:
	var a: Card = GFFactory.unit_card(&"A", 1, 4, 2)
	var b: Card = GFFactory.unit_card(&"B", 1, 4, 2)
	_hand.add(a)
	_hand.add(b)
	assert_true(CardPlay.play_card(a, {"lane": 0, "tile": 2}, _hand, _discard, _lanes)["success"], "first placement ok")
	GameState.mana = 3
	var r: Dictionary = CardPlay.play_card(b, {"lane": 0, "tile": 2}, _hand, _discard, _lanes)
	assert_false(r["success"], "reject occupied tile")
