extends RefCounted
class_name EnemyInstance

## EnemyInstance (B2.5) — runtime mutable state for one enemy alive on a lane.
##
## Wraps an `Enemy` resource (the static archetype) with per-fight data:
## current HP, current tile position, status stacks. Lives in
## `Lane.enemies`. Created by the `WaveSpawner`, removed by the lane when HP
## hits zero or the enemy walks off the front (= reaches the base, deals
## damage to GameState, then despawns).
##
## Pure data + a few helpers — no scene-tree presence. The visual sprite that
## represents this enemy on screen is created/destroyed by the Combat node
## from this instance in B2.6/B2.7.

var enemy_data: Enemy = null
var current_hp: int = 0
var lane_index: int = 0
var tile: int = 0       ## 0 = base tile (player loses HP). Tile counts up away from base.
var status: Dictionary = {}  ## { Keyword -> stack count }


func _init(data: Enemy = null, spawn_tile: int = 0, spawn_lane: int = 0) -> void:
	if data == null:
		return
	enemy_data = data
	current_hp = data.max_hp
	tile = spawn_tile
	lane_index = spawn_lane


# ============================================================================
# State queries
# ============================================================================

func is_alive() -> bool:
	return current_hp > 0


func is_at_base() -> bool:
	return tile <= 0


# ============================================================================
# Mutation
# ============================================================================

## Reduce current HP by `amount` (after armor). Returns actual damage taken.
## Negative or zero `amount` is a no-op.
func take_damage(amount: int) -> int:
	if amount <= 0 or not is_alive():
		return 0
	var armor: int = enemy_data.armor if enemy_data != null else 0
	var net: int = maxi(amount - armor, 0)
	var actual: int = mini(net, current_hp)
	current_hp -= actual
	return actual


## Move this enemy `steps` tiles toward the base (lower tile numbers).
## Clamps at tile 0; doesn't apply base damage on its own (Lane / Combat
## decide what happens when an enemy reaches tile 0).
func advance(steps: int = 1) -> void:
	if steps <= 0 or not is_alive():
		return
	tile = maxi(tile - steps, 0)


## Add N stacks of a status keyword. Useful for B2.7 Bleed / Poison / Slow.
func add_status(kw: GFEnums.Keyword, stacks: int = 1) -> void:
	if stacks <= 0:
		return
	status[kw] = int(status.get(kw, 0)) + stacks


func get_status(kw: GFEnums.Keyword) -> int:
	return int(status.get(kw, 0))


func _to_string() -> String:
	var name_str: String = enemy_data.display_name if enemy_data != null else "<no-data>"
	return "Enemy(%s lane=%d tile=%d hp=%d)" % [name_str, lane_index, tile, current_hp]
