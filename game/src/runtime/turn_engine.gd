extends RefCounted
class_name TurnEngine

## TurnEngine (B2.7) — pure resolution functions for the per-turn rhythm.
##
## Static methods only. Stateless: every call takes the lanes (and other
## zones) as inputs, mutates them, and returns a Dictionary describing what
## happened. The Combat node calls these in fixed order from
## `_on_turn_started` and `_on_turn_ended`.
##
## Phase contract:
##
## TURN START (process_turn_start):
##   1. Decay duration-tagged statuses on enemies (FEAR/SLOW/SMOKE per-tile)
##   2. Tick cooldowns down by 1 on every friendly unit (so units that just
##      came in last turn are ready to act)
##   3. Draw 1 card if turn > 1 (turn 1's hand is the opening draw set in
##      Combat.start before GameState.start_combat fires turn 1)
##
## TURN END (process_turn_end):
##   1. DoT tick — BLEED (decay 1/stack) + POISON (sticky) on enemies and
##      friendlies. Damage applied through the standard take_damage paths
##      so any future shield/armor logic layers in cleanly.
##   2. Friendly attacks — every alive friendly with cooldown=0 picks the
##      lowest-tile (closest-to-base) enemy in lane within attack_range and
##      deals current_attack() damage; on-hit BLEED/POISON keywords on the
##      attacker apply +1 stack to the target. Cooldown resets per card.
##   3. Cull dead enemies — emits enemy_killed; combat may queue follow-on
##      effects elsewhere.
##   4. Enemy "stand attacks" — every enemy whose tile coincides with a
##      friendly's tile deals enemy.attack damage to that friendly. (We
##      check this AFTER friendly attacks so the player has initiative.)
##   5. (Lane.advance_all() is called by Combat between TurnEngine steps —
##      see combat.gd._on_turn_ended for the exact ordering. Advance lives
##      in Lane to keep the base-damage signal wiring clean.)
##   6. Cull dead friendlies — emits unit_killed; Combat captures Persist
##      candidates here via the unit_killed signal, then calls
##      `drain_persists` below.
##   7. drain_persists — return Persist-eligible units to their origin
##      tile (or nearest empty in row) at -1 ATK, mark has_persisted.
##
## Return shape from each phase function:
##   {
##     "turn":         int,    # the turn number being processed
##     "draws":        int,    # cards drawn this phase
##     "dot_damage":   int,    # total HP removed by DoTs this tick
##     "friendly_atk": int,    # number of friendly attacks resolved
##     "enemy_atk":    int,    # number of enemy attacks resolved
##     "kills_enemy":  int,    # enemies killed this phase
##     "kills_friend": int,    # friendlies killed this phase
##     "persisted":    int,    # friendlies returned via Persist this phase
##   }


# ============================================================================
# TURN START
# ============================================================================

## Run the start-of-turn phase. Decay durations, tick cooldowns, draw 1.
## `turn_num` should be the new turn number (already incremented by GameState).
static func process_turn_start(
		lanes: Array[Lane],
		hand: Hand,
		deck: Deck,
		discard: Discard,
		turn_num: int
) -> Dictionary:
	var result := _empty_result(turn_num)

	for lane in lanes:
		_decay_durations_in_lane(lane)
		_tick_unit_cooldowns_in_lane(lane)

	# Draw 1 card on every turn after the first; turn 1 gets the opening hand
	# elsewhere (Combat.start drew the opener before GameState.start_combat).
	if turn_num > 1 and hand != null and deck != null:
		var card: Card = deck.draw_one(discard)
		if card != null:
			# Hand.add fires `overflowed` on a full hand and the caller should
			# route to discard ("burn" rule per cards_v0.md). The Combat node
			# wires overflowed → discard.add at start; if it's not wired, this
			# silently drops the card, which matches the design intent of
			# "burn-mill".
			if hand.add(card):
				result["draws"] = 1
			else:
				if discard != null:
					discard.add(card)

	return result


# ============================================================================
# TURN END
# ============================================================================

## Run the end-of-turn phase up to (but not including) `lane.advance_all()`.
## Combat is responsible for calling `lane.advance_all()` between this and
## `process_turn_end_after_advance`, so the base-damage signal wiring stays
## centralised. See combat.gd._on_turn_ended for the canonical order.
static func process_turn_end_pre_advance(lanes: Array[Lane]) -> Dictionary:
	var result := _empty_result(0)

	# 1. DoT tick on both sides
	for lane in lanes:
		result["dot_damage"] += _tick_dots_in_lane(lane)

	# 2. Friendly attacks (player initiative)
	for lane in lanes:
		var n: int = _resolve_friendly_attacks_in_lane(lane)
		result["friendly_atk"] += n

	# 3. Cull dead enemies (post-friendly-attack sweep)
	for lane in lanes:
		result["kills_enemy"] += lane.cull_dead()

	return result


## Run the end-of-turn phase after `lane.advance_all()` has moved enemies.
## Resolves enemy stand-attacks, culls dead friendlies (which is where Combat
## captures Persist candidates via the unit_killed signal), then returns the
## tally so Combat can decide whether to drain the Persist queue.
static func process_turn_end_post_advance(lanes: Array[Lane]) -> Dictionary:
	var result := _empty_result(0)

	# 4. Enemy stand-attacks against any friendly on the same tile
	for lane in lanes:
		var n: int = _resolve_enemy_attacks_in_lane(lane)
		result["enemy_atk"] += n

	# 5. Cull dead friendlies — fires unit_killed signal; Combat enqueues
	# Persist candidates from there.
	for lane in lanes:
		result["kills_friend"] += lane.cull_dead_units()

	return result


# ============================================================================
# PERSIST drain (M1)
# ============================================================================

## Return Persist-eligible units to their origin tile at -1 ATK.
## Combat owns the queue (UnitInstance entries captured at unit_killed signal
## time). Each entry resolves independently; failures are silent per M1 spec.
##
## Returns the number of units actually persisted (i.e. successfully placed).
static func drain_persists(lanes: Array[Lane], queue: Array) -> int:
	var resurrected: int = 0
	for entry in queue:
		var dead_unit: UnitInstance = entry as UnitInstance
		if dead_unit == null or dead_unit.card_data == null:
			continue
		if dead_unit.is_token or dead_unit.has_persisted:
			continue  # M1: tokens excluded; once-per-combat lock
		if dead_unit.lane_index < 0 or dead_unit.lane_index >= lanes.size():
			continue
		var lane: Lane = lanes[dead_unit.lane_index]
		# Try origin tile first; if occupied, find first empty in row.
		var target_tile: int = dead_unit.tile
		if lane.is_tile_occupied(target_tile) or not lane.is_tile_in_range(target_tile):
			target_tile = lane.first_empty_tile()
		if target_tile == -1:
			continue  # M1: no empty tile = silent fail
		var revived: UnitInstance = lane.place_unit(dead_unit.card_data, target_tile)
		if revived == null:
			continue
		# M1: -1 ATK floor 0, full HP, fresh cooldown, has_persisted lock,
		# self-buffs/auras NOT carried (place_unit makes a fresh instance —
		# the only thing we copy over is the Persist marker + ATK offset).
		revived.atk_offset = -1
		revived.has_persisted = true
		# is_token stays default (false) — a persisted unit is NOT a token,
		# even if the original was somehow flagged. Defensive: we already
		# excluded tokens above.
		resurrected += 1
	return resurrected


# ============================================================================
# Helpers — internal only
# ============================================================================

static func _empty_result(turn_num: int) -> Dictionary:
	return {
		"turn": turn_num,
		"draws": 0,
		"dot_damage": 0,
		"friendly_atk": 0,
		"enemy_atk": 0,
		"kills_enemy": 0,
		"kills_friend": 0,
		"persisted": 0,
	}


# ----- DoT tick -------------------------------------------------------------

static func _tick_dots_in_lane(lane: Lane) -> int:
	var total: int = 0
	for e in lane.enemies:
		if not e.is_alive():
			continue
		var bleed: int = e.get_status(GFEnums.Keyword.BLEED)
		if bleed > 0:
			total += e.take_damage(bleed)
			# BLEED decays 1 stack per tick (short-burst flavour).
			e.status[GFEnums.Keyword.BLEED] = bleed - 1
		var poison: int = e.get_status(GFEnums.Keyword.POISON)
		if poison > 0:
			total += e.take_damage(poison)
			# POISON does NOT decay — sticky grind per Coven design.
	for u in lane.friendly_units:
		if not u.is_alive():
			continue
		var bleed: int = u.get_status(GFEnums.Keyword.BLEED)
		if bleed > 0:
			total += u.take_damage(bleed)
			u.status[GFEnums.Keyword.BLEED] = bleed - 1
		var poison: int = u.get_status(GFEnums.Keyword.POISON)
		if poison > 0:
			total += u.take_damage(poison)
	return total


# ----- Friendly attacks -----------------------------------------------------

static func _resolve_friendly_attacks_in_lane(lane: Lane) -> int:
	var attacks: int = 0
	for u in lane.friendly_units:
		if not u.can_attack():
			continue
		var target: EnemyInstance = _pick_target_in_range(lane, u)
		if target == null:
			continue
		var dmg: int = u.current_attack()
		var dealt: int = lane.apply_damage_to_enemy(target, dmg)
		# On-hit keyword application — only BLEED/POISON for B2.7. Other
		# on-hit keywords (CLEAVE, PIERCE) are deferred to a balance pass.
		# All keyword checks go via UnitInstance.has_keyword() (not the raw
		# card_data) so aura-granted keywords fire too (AURA.E1, 2026-05-27)
		# — e.g. a Wolf-Token under W42's aura should heal-on-attack even
		# though its base Card has no keywords.
		if u.card_data != null:
			if u.has_keyword(GFEnums.Keyword.BLEED):
				target.add_status(GFEnums.Keyword.BLEED, 1)
			if u.has_keyword(GFEnums.Keyword.POISON):
				target.add_status(GFEnums.Keyword.POISON, 1)
			# LIFESTEAL (keywords/lifesteal_v0.md) — heal attacker for
			# damage_dealt, capped at max HP via UnitInstance.heal(). Only
			# triggers on positive damage (Shield/Pierce already resolved
			# inside apply_damage_to_enemy / take_damage). No friendly-fire
			# or self-target case — friendly attacks always target enemies.
			if u.has_keyword(GFEnums.Keyword.LIFESTEAL) and dealt > 0:
				u.heal(dealt)
		u.reset_cooldown()
		attacks += 1
	return attacks


# ----- Phase 2.13 bespoke trigger handlers — TODO follow-on heartbeat -------
# M41 Wraith-Caller of the Dirge — "When a friendly Mourner dies, the next
#   Mourner you play this turn costs 1 less (cap once/turn)." Needs:
#     (a) per-turn flag on game_state (mourner_discount_armed: bool),
#         reset on turn_started
#     (b) Combat-level subscriber on lane.unit_killed that checks
#         victim.card_data.faction == ASH_MOURNERS AND a friendly M41 is in
#         lane AND flag not yet armed this turn, then sets flag = true
#     (c) CardPlay.compute_play_cost() reads flag and applies -1 to the
#         next Ash-Mourner card resolved, then clears the flag
#   Defer to E-series heartbeat M41.E1.
#
# W41 Pack-Caller Initiate — "When you summon a Wolf-Token in your lane,
#   draw 1 card (cap once/turn)." Needs:
#     (a) per-turn flag (wolf_summon_draw_armed: bool), reset on turn_started
#     (b) hook on whatever spawns Wolf-Tokens (Pelt-Bound Shaman, Pack-Call,
#         Den-Mother end-of-turn, Whelping Burrow, etc) to check for a
#         friendly W41 in the same lane and trigger the draw
#     (c) call deck.draw(1) gated by the flag
#   Defer to E-series heartbeat W41.E1.
#
# W42 Den-Mother of the Cinderwood — "Friendly Wolf-Tokens in lane gain +1/+1
#   and Lifesteal while she is in lane." Needs (largest lift):
#     (a) `runtime_keywords: Array[int]` field on UnitInstance, queried by
#         has_keyword() AND-OR with card_data.has_keyword()
#     (b) `aura_buffs: Dictionary { source_unit -> { atk: int, hp: int,
#         keywords: Array[int] } }` on UnitInstance for stat aura
#     (c) aura-on-lane-enter / aura-on-lane-leave hooks fired from
#         lane.place_unit() and lane._cull_dead() — when W42 enters/leaves,
#         walk all friendly Wolf-Tokens in lane and apply/remove the grant;
#         when a NEW Wolf-Token enters with W42 already in lane, apply on
#         arrival.
#   This is the closest thing to a generic aura system in the engine and
#   should be designed as its own keyword/concept (keywords/aura_v0.md) so
#   future cards (Banner buff, Penance triggers, Bear-Skin Hierophant +2HP
#   grant) can ride the same plumbing. Defer to keyword-spec heartbeat then
#   W42.E1 implementation.
# ----------------------------------------------------------------------------


## Pick the closest-to-base (lowest-tile) enemy that the friendly can reach.
## Range conversion: NONE = 0 (cannot attack), MELEE = 1, SHORT = 2, LONG = 3.
## Friendly attacks DOWN the lane toward higher tile numbers (enemies advance
## from spawn = tile_count toward base = 0). So the unit at tile T can hit
## any enemy at tile in [T, T + range].
static func _pick_target_in_range(lane: Lane, unit: UnitInstance) -> EnemyInstance:
	var rng: int = _attack_range_to_tiles(unit.card_data.attack_range)
	if rng <= 0:
		return null
	var best: EnemyInstance = null
	for e in lane.enemies:
		if not e.is_alive():
			continue
		# Reachable tiles: [unit.tile, unit.tile + rng] inclusive
		if e.tile < unit.tile or e.tile > unit.tile + rng:
			continue
		# Prefer the lowest-tile enemy (most threatening — closest to base).
		if best == null or e.tile < best.tile:
			best = e
	return best


static func _attack_range_to_tiles(rng: GFEnums.AttackRange) -> int:
	match rng:
		GFEnums.AttackRange.NONE:  return 0
		GFEnums.AttackRange.MELEE: return 1
		GFEnums.AttackRange.SHORT: return 2
		GFEnums.AttackRange.LONG:  return 3
	return 0


# ----- Enemy attacks -------------------------------------------------------

## After enemies advance, any enemy whose tile coincides with a friendly's
## tile deals enemy.attack damage to the lowest-cost friendly on that tile
## (deterministic tie-break: cheapest card first, then lower lane_index).
##
## Enemies don't attack from range in B2.7 — they only "stand attack" on
## tile-collision. Ranged enemy archetypes are a future addition that will
## likely route through this same hook with a configurable range.
static func _resolve_enemy_attacks_in_lane(lane: Lane) -> int:
	var attacks: int = 0
	for e in lane.enemies:
		if not e.is_alive() or e.enemy_data == null:
			continue
		var atk: int = e.enemy_data.attack
	