extends RefCounted
class_name CardPlay

## CardPlay (B2.6) — central "play a card from hand" resolver.
##
## All card-play paths (drag-drop in B2.6 UI, AI auto-play in future, scripted
## tutorial moves) funnel through `play_card()`. Keeps the validation +
## resolution logic in one place; the UI just collects {card, target} and
## hands the work to this module.
##
## Validation order (fail fast — no state mutation on any rejection):
##   1. card non-null and in `hand`
##   2. cost ≤ GameState.mana
##   3. type-specific target validation:
##        UNIT  → target.lane in range, target.tile playable, tile unoccupied
##        SPELL → no target validation in B2.6 stub (effect engine = B2.7+)
##        TRAP  → target.lane in range; tile defaults to 1 (back rank)
##
## On success: deduct mana → remove from hand → apply effect → add to
## discard → emit-side-effects via lane signals.
##
## On failure: return reason string, no state changed anywhere.
##
## Returns Dictionary:
##   { success: bool,
##     reason: String,                  # populated on failure or "ok" on success
##     unit: UnitInstance OR null,      # populated for UNIT placements
##   }

# ============================================================================
# Public entry point
# ============================================================================

## target dict examples:
##   UNIT  → {"lane": 1, "tile": 3}        (tile optional; defaults to first
##                                           empty tile via lane.first_empty_tile)
##   SPELL → {"lane": 1} or {} for no-target spells
##   TRAP  → {"lane": 1, "tile": 1}        (tile optional; defaults to 1)
static func play_card(
		card: Card,
		target: Dictionary,
		hand: Hand,
		discard: Discard,
		lanes: Array[Lane]
) -> Dictionary:
	# 1. Sanity
	if card == null:
		return _fail("card is null")
	if hand == null or discard == null:
		return _fail("hand/discard not bound")
	if not _hand_contains(hand, card):
		return _fail("card not in hand")

	# 2. Cost — read effective cost via GameState.compute_play_cost so any
	# active discount triggers (Phase 2.16 M41.E1 Wraith-Caller for Ash-Mourners,
	# future trigger cards) are honoured at the mana check + spend. The discount
	# is consumed AFTER a successful commit, never on rejected plays.
	var effective_cost: int = GameState.compute_play_cost(card)
	if effective_cost > GameState.mana:
		return _fail("not enough mana (cost %d, have %d)" % [effective_cost, GameState.mana])

	# 3. Type-specific target validation
	match card.card_type:
		GFEnums.CardType.UNIT:
			var lane_idx: int = int(target.get("lane", -1))
			if lane_idx < 0 or lane_idx >= lanes.size():
				return _fail("invalid lane %d (have %d lanes)" % [lane_idx, lanes.size()])
			var lane: Lane = lanes[lane_idx]
			var tile_idx: int = int(target.get("tile", lane.first_empty_tile()))
			if tile_idx < 0:
				return _fail("lane %d has no empty tile" % lane_idx)
			if not lane.is_tile_in_range(tile_idx):
				return _fail("tile %d out of range" % tile_idx)
			if lane.is_tile_occupied(tile_idx):
				return _fail("tile %d already occupied" % tile_idx)
			# All checks passed — commit.
			GameState.spend_mana(effective_cost)
			var removed: Card = hand.remove(card)
			if removed == null:
				# Defensive: should never trigger thanks to step 1 check, but
				# if hand state changed mid-call we surface it cleanly rather
				# than corrupting mana.
				GameState.gain_mana(effective_cost)  # refund
				return _fail("hand.remove returned null (race)")
			var unit: UnitInstance = lane.place_unit(card, tile_idx)
			if unit == null:
				# Belt-and-braces: place_unit re-validated and bailed. Refund.
				GameState.gain_mana(effective_cost)
				hand.add(card)
				return _fail("place_unit returned null (post-validation race)")
			discard.add(card)
			_consume_play_discounts(card)
			return _ok({"unit": unit})

		GFEnums.CardType.SPELL:
			# B2.6 placeholder: cost-spend + hand→discard. Until the proper
			# effect engine (planned B2.7+) parses per-spell effect text and
			# applies damage/buff/draw, every spell now does a generic
			# placeholder action so players SEE something happen:
			#   - If a lane is targeted, deal 2 damage to the lowest-tile
			#     (closest-to-base) enemy in that lane.
			#   - Otherwise no-op (still consumes mana per design — spells
			#     without targets are deck-thinning even at v0).
			var spell_lane_idx: int = int(target.get("lane", -1))
			GameState.spend_mana(effective_cost)
			var removed_s: Card = hand.remove(card)
			if removed_s == null:
				GameState.gain_mana(effective_cost)
				return _fail("hand.remove returned null (race)")
			discard.add(card)
			_consume_play_discounts(card)
			var dealt: int = 0
			if spell_lane_idx >= 0 and spell_lane_idx < lanes.size():
				var target_lane: Lane = lanes[spell_lane_idx]
				var lowest: EnemyInstance = null
				for e in target_lane.enemies:
					if e == null or not e.is_alive():
						continue
					if lowest == null or e.tile < lowest.tile:
						lowest = e
				if lowest != null:
					dealt = target_lane.apply_damage_to_enemy(lowest, 2)
			return _ok({"spell_target": target, "dealt": dealt})

		GFEnums.CardType.TRAP:
			# B2.6 stub: same as SPELL. The trap-as-lane-object representation
			# (a Trap class with an arming condition + a triggered effect)
			# lands in B2.7 alongside the turn engine. Validate lane though,
			# since traps care which lane they sit in.
			var lane_idx_t: int = int(target.get("lane", -1))
			if lane_idx_t < 0 or lane_idx_t >= lanes.size():
				return _fail("invalid trap lane %d" % lane_idx_t)
			GameState.spend_mana(effective_cost)
			var removed_t: Card = hand.remove(card)
			if removed_t == null:
				GameState.gain_mana(effective_cost)
				return _fail("hand.remove returned null (race)")
			discard.add(card)
			_consume_play_discounts(card)
			return _ok({"trap_lane": lane_idx_t})

		_:
			return _fail("unknown card_type %d" % card.card_type)


# ============================================================================
# Helpers
# ============================================================================

static func _fail(reason: String) -> Dictionary:
	return {
		"success": false,
		"reason": reason,
		"unit": null,
	}


static func _ok(extra: Dictionary = {}) -> Dictionary:
	var r: Dictionary = {
		"success": true,
		"reason": "ok",
		"unit": null,
	}
	for k in extra.keys():
		r[k] = extra[k]
	return r


static func _hand_contains(hand: Hand, card: Card) -> bool:
	for c in hand.cards():
		if c == card:
			return true
	return false


## After a successful play, consume any active per-card-faction discounts.
## Currently only the Phase 2.16 M41.E1 Ash-Mourner discount (Wraith-Caller of
## the Dirge). Centralised here so future faction-discount triggers slot into
## the same hook (one if-branch per trigger). Pure dispatch — GameState owns
## the state mutation + signal emission.
static func _consume_play_discounts(card: Card) -> void:
	if card == null:
		return
	if card.faction == GFEnums.Faction.ASH_MOURNERS \
			and GameState.mourner_discount_armed:
		GameState.consume_mourner_discount()
