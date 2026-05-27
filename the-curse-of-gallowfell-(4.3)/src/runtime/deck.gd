extends RefCounted
class_name Deck

## Draw pile of Card resources for a single combat encounter.
##
## Owns the shuffle order. The discard pile is held by a separate Discard zone
## (clean ownership transfer when cards move between zones — never two zones
## referencing the same card concurrently).
##
## Determinism: the embedded RandomNumberGenerator is settable for replay/test
## use. Pass `seed_value != 0` in `_init` for reproducible shuffles.
##
## Mill rule (per `cards_v0.md` design): cards milled go to the discard, not
## "exiled". Reshuffle is automatic when `draw_one(from_discard)` is called on
## an empty deck and the discard has cards available.

var _cards: Array[Card] = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

signal drew_card(card: Card)
signal reshuffled
signal milled_cards(cards: Array[Card])


func _init(initial_cards: Array[Card] = [], seed_value: int = 0) -> void:
	_cards = initial_cards.duplicate()
	if seed_value != 0:
		rng.seed = seed_value
	else:
		rng.randomize()


## Number of cards remaining in the draw pile.
func size() -> int:
	return _cards.size()


func is_empty() -> bool:
	return _cards.is_empty()


## Snapshot of current draw-pile order (top-of-deck = last index, draw_one pops back).
## Returned as a duplicate so external mutation can't corrupt the deck.
func cards() -> Array[Card]:
	return _cards.duplicate()


## Fisher-Yates shuffle in place. Uses the embedded `rng` for determinism.
func shuffle() -> void:
	var n := _cards.size()
	for i in range(n - 1, 0, -1):
		var j := rng.randi_range(0, i)
		if j != i:
			var tmp: Card = _cards[i]
			_cards[i] = _cards[j]
			_cards[j] = tmp


## Add a card to the top of the deck (next to be drawn).
func add_to_top(card: Card) -> void:
	_cards.append(card)


## Add a card to the bottom of the deck (last to be drawn).
func add_to_bottom(card: Card) -> void:
	_cards.push_front(card)


## Draw one card from the top. Returns null if no card is available.
##
## If the deck is empty AND a Discard zone is supplied (and non-empty), the
## discard pile is auto-pulled into the deck and shuffled BEFORE drawing.
## Pass `null` for `from_discard` to disable the auto-reshuffle (e.g. for
## "draw if possible" effects that should fail silently on an empty deck).
func draw_one(from_discard: Discard = null) -> Card:
	if _cards.is_empty():
		if from_discard != null and from_discard.size() > 0:
			reshuffle_from(from_discard)
		else:
			return null
	var card: Card = _cards.pop_back()
	drew_card.emit(card)
	return card


## Move `n` cards from the top of the deck directly to the supplied discard.
## Returns the milled cards in mill-order (top of deck first).
##
## If the deck has fewer than `n` cards, mills what's available and returns
## the partial list. Mill does NOT auto-reshuffle from discard — milling an
## empty deck is a no-op.
func mill(n: int, into_discard: Discard) -> Array[Card]:
	var milled: Array[Card] = []
	var actual := mini(n, _cards.size())
	for _i in range(actual):
		var card: Card = _cards.pop_back()
		into_discard.add(card)
		milled.append(card)
	if not milled.is_empty():
		milled_cards.emit(milled)
	return milled


## Pull every card out of the supplied discard pile, append to the deck, and shuffle.
## Used by `draw_one` when the deck is empty, and exposed for explicit "shuffle
## discard back" effects (e.g. card effects that can recycle the pile mid-combat).
func reshuffle_from(discard: Discard) -> void:
	var pulled: Array[Card] = discard.clear_all()
	for c in pulled:
		_cards.append(c)
	shuffle()
	reshuffled.emit()


## Validation hook — call from a unit test or editor tool. Returns empty array
## if valid, otherwise a list of human-readable problems. Cheap to run.
func validate() -> Array[String]:
	var errors: Array[String] = []
	for i in range(_cards.size()):
		var c: Card = _cards[i]
		if c == null:
			errors.append("Deck has null card at index %d" % i)
			continue
		if c.id == &"":
			errors.append("Deck has card with empty id at index %d" % i)
	return errors
