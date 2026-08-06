extends RefCounted
class_name GFCombatResolver

## ============================================================================
## SIM-SIDE COMBAT RESOLVER — APPROXIMATION, NOT THE SHIPPING ENGINE.
## ============================================================================
## The live engine (as of B2.6) spawns, advances and routes base damage, but the
## unit<->enemy attack exchange is B2.7 and NOT yet built. So that the balance
## simulator can produce win/loss outcomes and per-card damage stats TODAY, this
## file models a minimal exchange each turn:
##
##   1. Every ready friendly unit attacks the nearest enemy within its range
##      (MELEE=1, SHORT=2, LONG=3 tiles), dealing card.attack, then resets its
##      cooldown. Not-ready units tick their cooldown down.
##   2. Dead enemies are culled.
##   3. Any enemy sharing a tile with a friendly unit deals its attack to that
##      unit (attrition). Dead units are culled.
##
## When .151 builds the real B2.7 resolver, replace the body of resolve_turn()
## with a call into it — the simulator and telemetry keys stay the same.
## ============================================================================

const RANGE_TILES: Dictionary = {
	GFEnums.AttackRange.NONE: 0,
	GFEnums.AttackRange.MELEE: 1,
	GFEnums.AttackRange.SHORT: 2,
	GFEnums.AttackRange.LONG: 3,
}

## Resolve one turn of unit<->enemy combat across all lanes, recording per-card
## telemetry into `telem` (keyed by card id string).
static func resolve_turn(lanes: Array[Lane], telem: Dictionary) -> void:
	for lane: Lane in lanes:
		# 1. Friendly units act.
		for u: UnitInstance in lane.friendly_units:
			if u.card_data == null:
				continue
			if u.can_attack():
				var rng: int = int(RANGE_TILES.get(u.card_data.attack_range, 1))
				var target: EnemyInstance = _nearest_enemy(lane, u.tile, rng)
				if target != null:
					var dealt: int = target.take_damage(u.card_data.attack)
					_telem_add(telem, String(u.card_data.id), "damage", dealt)
					if not target.is_alive():
						_telem_add(telem, String(u.card_data.id), "kills", 1)
					u.reset_cooldown()
			else:
				u.tick_cooldown()
		lane.cull_dead()
		# 2. Enemies retaliate against a unit on their tile.
		for e: EnemyInstance in lane.enemies:
			var blocker: UnitInstance = _unit_on_tile(lane, e.tile)
			if blocker != null:
				blocker.take_damage(e.enemy_data.attack if e.enemy_data != null else 0)
		lane.cull_dead_units()

static func _nearest_enemy(lane: Lane, from_tile: int, rng: int) -> EnemyInstance:
	var best: EnemyInstance = null
	var best_dist: int = 1 << 30
	for e: EnemyInstance in lane.enemies:
		if not e.is_alive():
			continue
		var dist: int = absi(e.tile - from_tile)
		if dist <= rng and dist < best_dist:
			best_dist = dist
			best = e
	return best

static func _unit_on_tile(lane: Lane, tile: int) -> UnitInstance:
	for u: UnitInstance in lane.friendly_units:
		if u.is_alive() and u.tile == tile:
			return u
	return null

static func _telem_add(telem: Dictionary, card_id: String, key: String, amt: int) -> void:
	if not telem.has(card_id):
		telem[card_id] = {"drawn": 0, "played": 0, "damage": 0, "kills": 0}
	var row: Dictionary = telem[card_id]
	row[key] = int(row.get(key, 0)) + amt
