extends RefCounted
class_name UnitInstance

## UnitInstance (B2.6) — runtime mutable state for one friendly unit on a lane.
##
## Wraps a `Card` resource (the static archetype, must be card_type == UNIT)
## with per-fight data: current HP, current tile position, cooldown counter
## (turns until next attack), status stacks. Lives in `Lane.friendly_units`.
## Created by `CardPlay.play_card()` when a UNIT card resolves; removed by the
## lane when HP hits zero (or by Sacrifice cards explicitly consuming it).
##
## Mirrors `EnemyInstance` deliberately so B2.7's combat resolver can iterate
## both sides with a uniform interface (`alive`, `take_damage`, `tile`,
## `add_status`, `get_status`).

var card_data: Card = null
var current_hp: int = 0
var lane_index: int = 0
var tile: int = 0       ## 1..tile_count-1 valid for friendlies. Tile 0 is the base.
var cooldown_counter: int = 0  ## decremented each turn until 0 ⇒ ready to attack
var status: Dictionary = {}    ## { Keyword -> stack count }


func _init(card: Card = null, place_tile: int = 1, place_lane: int = 0) -> void:
	if card == null:
		return
	if card.card_type != GFEnums.CardType.UNIT:
		push_error("[UnitInstance] _init called with non-UNIT card '%s'" % card.id)
		return
	card_data = card
	current_hp = card.hp
	tile = place_tile
	lane_index = place_lane
	# Units enter play "fresh" — first attack is on the next turn the unit is
	# eligible to act. cooldown 0 = can attack this turn; 1 = next turn; etc.
	cooldown_counter = card.cooldown


# ============================================================================
# State queries
# ============================================================================

func is_alive() -> bool:
	return current_hp > 0


func can_attack() -> bool:
	return is_alive() and cooldown_counter <= 0


# ============================================================================
# Mutation
# ============================================================================

## Reduce current HP by `amount`. Status-keyword armor / shields can layer in
## later (B2.7); B2.6 keeps damage flat. Returns actual damage taken.
func take_damage(amount: int) -> int:
	if amount <= 0 or not is_alive():
		return 0
	var actual: int = mini(amount, current_hp)
	current_hp -= actual
	return actual


## Heal up to max (card.hp). Returns actual healing done.
func heal(amount: int) -> int:
	if amount <= 0 or card_data == null:
		return 0
	var before := current_hp
	current_hp = mini(card_data.hp, current_hp + amount)
	return current_hp - before


## Decrement the cooldown counter by 1 (call once per turn from the turn
## engine). Clamps at 0; never goes negative.
func tick_cooldown() -> void:
	if cooldown_counter > 0:
		cooldown_counter -= 1


## Reset cooldown after an attack fires (B2.7).
func reset_cooldown() -> void:
	if card_data != null:
		cooldown_counter = card_data.cooldown


func add_status(kw: GFEnums.Keyword, stacks: int = 1) -> void:
	if stacks <= 0:
		return
	status[kw] = int(status.get(kw, 0)) + stacks


func get_status(kw: GFEnums.Keyword) -> int:
	return int(status.get(kw, 0))


func _to_string() -> String:
	var name_str: String = card_data.display_name if card_data != null else "<no-card>"
	return "Unit(%s lane=%d tile=%d hp=%d cd=%d)" % [
		name_str, lane_index, tile, current_hp, cooldown_counter
	]
