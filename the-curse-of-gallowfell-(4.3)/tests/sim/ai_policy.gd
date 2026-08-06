extends RefCounted
class_name GFAIPolicy

## Scripted AI policy for the balance simulator. Deterministic (no rng) so a
## given seed reproduces exactly. Strategy: play the most expensive AFFORDABLE
## unit each step into the front-most empty tile of the most-threatened lane
## (the lane with the most advancing enemies). Returns one play at a time; the
## simulator loops until next_play() returns {} (nothing left to do).
##
## Swap this class to experiment with different play patterns (cheap-first,
## lane-spread, hold-mana) and compare win-rates in the report.

## Returns { "card": Card, "target": Dictionary } or {} when no play is sensible.
static func next_play(hand: Hand, lanes: Array[Lane], mana: int) -> Dictionary:
	var best_card: Card = null
	for c: Card in hand.cards():
		if c.card_type != GFEnums.CardType.UNIT:
			continue
		if c.cost > mana:
			continue
		if best_card == null or c.cost > best_card.cost:
			best_card = c
	if best_card == null:
		return {}
	var target: Dictionary = _best_target(lanes)
	if target.is_empty():
		return {}
	return {"card": best_card, "target": target}

## Most-threatened lane + its front-most empty tile (highest index, to intercept
## enemies as early as possible). Returns {} if every lane is full.
static func _best_target(lanes: Array[Lane]) -> Dictionary:
	var best_lane: int = -1
	var best_tile: int = -1
	var best_threat: int = -1
	for i: int in range(lanes.size()):
		var lane: Lane = lanes[i]
		var tile: int = _front_empty_tile(lane)
		if tile < 0:
			continue
		var threat: int = lane.enemy_count()
		if threat > best_threat:
			best_threat = threat
			best_lane = i
			best_tile = tile
	if best_lane < 0:
		return {}
	return {"lane": best_lane, "tile": best_tile}

## Highest-index empty, in-range tile (front rank), or -1 if none.
static func _front_empty_tile(lane: Lane) -> int:
	for t: int in range(lane.tile_count - 1, 0, -1):
		if lane.is_tile_in_range(t) and not lane.is_tile_occupied(t):
			return t
	return -1
