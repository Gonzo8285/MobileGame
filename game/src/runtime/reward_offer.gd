extends RefCounted
class_name RewardOffer

## RewardOffer (B2.8) — three-card pick presented after a combat win.
##
## Pure data + selection state. The picker UI (B2.10 mock, full art in later
## phase) reads `cards`, lets the player tap one, then calls `choose(index)`
## or `skip()`. Either path emits `resolved(card_or_null)` exactly once —
## GameState listens to that signal to add the chosen card to the run deck.
##
## Resolution is one-shot: once `is_resolved()` returns true, further `choose`
## or `skip` calls are no-ops and do NOT re-emit `resolved`. Keeps the signal
## contract clean (a UI bug that double-fires can't accidentally add the
## card twice).
##
## The offer holds *references* to the Card resources from the pool. The
## reward grant in GameState calls `Card.duplicate_card()` before adding to
## the deck so the deck owns its own instance.

signal resolved(card: Card)  ## Fires once. `card` is null on skip.

var cards: Array[Card] = []
var chosen_index: int = -1
var skipped: bool = false


func _init(offer_cards: Array[Card] = []) -> void:
	cards = offer_cards.duplicate()


## Pick one of the offered cards by index. Returns the chosen Card on success,
## null if the index is out of range or the offer is already resolved.
func choose(index: int) -> Card:
	if is_resolved():
		return null
	if index < 0 or index >= cards.size():
		return null
	chosen_index = index
	var c: Card = cards[index]
	resolved.emit(c)
	return c


## Skip the reward (no card added). Emits resolved(null) exactly once.
func skip() -> void:
	if is_resolved():
		return
	skipped = true
	resolved.emit(null)


## True once `choose` or `skip` has fired. UI uses this to disable the
## pick buttons after the player commits.
func is_resolved() -> bool:
	return chosen_index >= 0 or skipped


## The chosen card (or null on skip / unresolved).
func get_chosen() -> Card:
	if chosen_index < 0:
		return null
	return cards[chosen_index]


## Validation hook — returns empty array if shape is sane, otherwise human
## strings. Cheap to run; designed for use in dev tests.
func validate() -> Array[String]:
	var errors: Array[String] = []
	if cards.is_empty():
		errors.append("RewardOffer has no cards")
	for i in range(cards.size()):
		if cards[i] == null:
			errors.append("RewardOffer has null card at index %d" % i)
	# Duplicate-id check — generator should already enforce this.
	var seen: Dictionary = {}
	for c in cards:
		if c == null:
			continue
		if seen.has(c.id):
			errors.append("RewardOffer has duplicate card id %s" % c.id)
		seen[c.id] = true
	return errors
