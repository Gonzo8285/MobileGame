extends RefCounted
class_name Hand

## Player's current hand of Card resources.
##
## Hand size is capped (default 10 — same as Slay the Spire convention; revisit
## per Warlord variant in W2). Drawing into a full hand emits `overflowed` so
## the caller can route the overflow to discard ("burn" rule).
##
## Mulligan rule: at the start of combat (or as a once-per-combat ability),
## the entire hand is shuffled back into the deck and re-drawn at the same
## size. See `mulligan()` below.

const DEFAULT_CAPACITY: int = 10

var _cards: Array[Card] = []
var capacity: int = DEFAULT_CAPACITY

signal added(card: Card)
signal removed(card: Card)
signal overflowed(card: Card)


func _init(initial_capacity: int = DEFAULT_CAPACITY) -> void:
	capacity = initial_capacity


## Number of cards currently in hand.
func size() -> int:
	return _cards.size()


func is_empty() -> bool:
	return _cards.is_empty()


func is_full() -> bool:
	return _cards.size() >= capacity


## Snapshot of current hand. Duplicated so external mutation can't corrupt state.
func cards() -> Array[Card]:
	return _cards.duplicate()


## Add a card to hand. Returns true on success; false if the hand was full
## (the card is then emitted via `overflowed` and the caller should route it
## to the discard pile).
func add(card: Card) -> bool:
	if is_full():
		overflowed.emit(card)
		return false
	_cards.append(card)
	added.emit(card)
	return true


## Remove a specific card instance from hand. Returns the card on success,
## null if the card was not in hand. Used by the play-card flow.
func remove(card: Card) -> Card:
	var idx := _cards.find(card)
	if idx == -1:
		return null
	var removed_card: Card = _cards.pop_at(idx)
	removed.emit(removed_card)
	return removed_card


## Remove and return all cards in hand. Used by mulligan and end-of-turn
## discard-hand effects.
func clear() -> Array[Card]:
	var all := _cards.duplicate()
	_cards.clear()
	return all


## Mulligan: send the entire hand back into the deck, shuffle, then redraw the
## same number of cards that were in hand. Returns the new hand contents in
## draw order. If the deck is shorter than the hand was, draws what's available.
##
## Cards are pushed to the top of the deck before shuffle (their position is
## randomised by the shuffle, so the order doesn't matter — but doing it this
## way keeps the deck `cards()` array clean for inspection).
##
## Per Slay the Spire convention this is currently unrestricted; the W2
## per-Warlord tier system may layer "1 mulligan per combat" on top later.
func mulligan(deck: Deck) -> Array[Card]:
	var n := _cards.size()
	for c in _cards:
		deck.add_to_top(c)
	_cards.clear()
	deck.shuffle()
	var drawn: Array[Card] = []
	for _i in range(n):
		var card: Card = deck.draw_one()
		if card == null:
			break
		if add(card):
			drawn.append(card)
	return drawn
