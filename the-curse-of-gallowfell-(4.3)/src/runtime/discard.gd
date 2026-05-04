extends RefCounted
class_name Discard

## Discard pile.
##
## Cards land here when:
##   - played from hand (post-resolution)
##   - end-of-turn auto-discard (TBD per turn engine in B2.7)
##   - milled by `Deck.mill()`
##   - sacrificed-and-spent (some Sacrifice payoffs go to discard not exile)
##   - overflowed from a full hand (`Hand.add()` returns false, caller routes here)
##
## When a Deck is empty and a draw is requested, the deck reshuffles from this
## pile (see `Deck.draw_one()` / `Deck.reshuffle_from()`).

var _cards: Array[Card] = []

signal added(card: Card)
signal cleared


func size() -> int:
	return _cards.size()


func is_empty() -> bool:
	return _cards.is_empty()


## Snapshot of discard pile, top-of-pile = last index. Duplicated.
func cards() -> Array[Card]:
	return _cards.duplicate()


## Append a card to the top of the discard pile.
func add(card: Card) -> void:
	_cards.append(card)
	added.emit(card)


## Empty the pile and return the cards (caller takes ownership). Used by
## `Deck.reshuffle_from()` when the deck is empty.
func clear_all() -> Array[Card]:
	var pulled := _cards.duplicate()
	_cards.clear()
	cleared.emit()
	return pulled


## Look up a specific card in the pile by id. Returns null if absent. Used
## by card effects that scry / re-summon a discarded unit (e.g. P39 Pyre Echo
## design hook from `cards_iron_penitents_v1.md`).
func find_by_id(card_id: StringName) -> Card:
	for c in _cards:
		if c.id == card_id:
			return c
	return null


## Remove a specific card instance and return it. Returns null if absent.
## Used by re-summon effects that pull a card back into play from discard.
func remove(card: Card) -> Card:
	var idx := _cards.find(card)
	if idx == -1:
		return null
	var removed_card: Card = _cards.pop_at(idx)
	return removed_card
