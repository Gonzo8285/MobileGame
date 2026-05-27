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

## Per-instance ATK modifier. Stacks with card_data.attack and is clamped at 0.
## Persist (M1) writes -1 here when a unit returns from death. Other transient
## buffs (Banner-buff aura, Penance triggers) write positive values. NEVER
## persists across combats — `Combat.cleanup()` discards the instance entirely.
var atk_offset: int = 0

## True iff this instance has already been re-summoned via PERSIST this combat.
## M1 lock: a unit can Persist at most once per combat. Reset between combats
## along with the rest of the instance (a fresh `place_unit` makes a new one).
var has_persisted: bool = false

## True iff this unit was created by a SUMMON / RESURRECT effect (not played
## from hand). Tokens cannot Persist, cannot drop loot, and don't count for
## "play X cards"-style triggers. M1 spec: tokens are excluded from Persist
## resolution. Set explicitly by the spawner; default false matches a normal
## hand-played unit.
var is_token: bool = false

## AURA.E1 (keywords/aura_v0.md) — runtime grants from active aura sources.
## Each entry is keyed by the *source* UnitInstance so partial revoke is
## clean: when one of N sources leaves lane, only its contribution is
## stripped. Multiple sources stack additively for stats (verified by
## scene F4); keyword grants form a set-union (multiple sources granting
## the same keyword keep it present until ALL grant-sources are revoked).
## Derived state — never serialised; recomputed by lane._reapply_auras()
## on save/load. See aura_v0.md open-Q3.
var runtime_keywords: Dictionary = {}    ## { source: Array[int] (keyword enum values) }
var aura_stats: Dictionary = {}          ## { source: { "atk": int, "hp": int } }


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
	return is_alive() and cooldown_counter <= 0 and current_attack() > 0


## Effective attack — base ATK from the Card resource plus any per-instance
## modifier (Persist's -1, Banner buffs, etc.) plus the sum of aura ATK
## contributions, clamped at 0. Use this whenever resolving damage; never
## read `card_data.attack` directly from combat code.
func current_attack() -> int:
	if card_data == null:
		return 0
	return maxi(0, card_data.attack + atk_offset + _aura_atk_sum())


## Effective max HP — base HP from the Card resource plus the sum of aura
## HP contributions. Used by heal() to clamp current_hp on heals/auras.
## AURA.E1 — without this, heal() would clamp to base HP and never realise
## aura-granted extra HP. See aura_v0.md.
func max_hp() -> int:
	if card_data == null:
		return 0
	return card_data.hp + _aura_hp_sum()


## OR of card-native keywords + any aura-granted keywords. Combat code that
## branches on keywords (LIFESTEAL heal-on-attack, TAUNT redirect, PIERCE
## shield-bypass) should call THIS not `card_data.has_keyword()` so it sees
## runtime grants from auras like W42 Den-Mother's Wolf-Token LIFESTEAL push.
func has_keyword(kw: GFEnums.Keyword) -> bool:
	if card_data != null and card_data.has_keyword(kw):
		return true
	for granted_list in runtime_keywords.values():
		if granted_list.has(int(kw)):
			return true
	return false


# ============================================================================
# AURA.E1 — runtime aura grants (keywords/aura_v0.md)
# ============================================================================

## Apply an aura grant from `source` to this unit. Stats are stored separately
## per-source (so partial revoke is clean when one of multiple sources leaves
## lane). If `source` already has an entry, the new grant REPLACES it (auras
## don't double-stack from the same source — see aura_v0.md "Multi-source rules").
##
## Positive `hp_buff` also raises current_hp by the same amount (the player
## sees the aura "heal" them up to the new ceiling), matching standard CCG
## expectations. Negative hp_buff is rejected — auras grant, they don't drain.
func apply_aura_grant(source: UnitInstance, atk_buff: int, hp_buff: int,
		keywords: Array) -> void:
	if source == null:
		return
	# Replace (don't stack) — atomic. Existing source entries are overwritten
	# wholesale; HP delta is reconciled by the post-write clamp below.
	aura_stats[source] = { "atk": atk_buff, "hp": maxi(0, hp_buff) }
	var kw_ints: Array = []
	for k in keywords:
		kw_ints.append(int(k))
	runtime_keywords[source] = kw_ints
	# Raise current_hp by the new grant's hp_buff so the player "gains" HP.
	if hp_buff > 0:
		current_hp += hp_buff
	# Clamp to post-grant max (handles the replace-existing case cleanly).
	current_hp = mini(current_hp, max_hp())
	if current_hp < 1:
		current_hp = 1


## Remove a single source's contribution. Called when the source leaves lane,
## dies, or its trigger condition fails. Stats shrink; current_hp is clamped
## at the new max with a floor of 1 (revoke never kills — see aura_v0.md
## "HP buff handling on revoke" for the design rationale).
func revoke_aura_grant(source: UnitInstance) -> void:
	if source == null:
		return
	if not aura_stats.has(source):
		return
	aura_stats.erase(source)
	runtime_keywords.erase(source)
	var new_max := max_hp()
	if new_max < 1:
		new_max = 1
	current_hp = mini(current_hp, new_max)
	if current_hp < 1:
		current_hp = 1


## Internal: sum aura ATK contributions.
func _aura_atk_sum() -> int:
	var total: int = 0
	for entry in aura_stats.values():
		total += int(entry.get("atk", 0))
	return total


## Internal: sum aura HP contributions.
func _aura_hp_sum() -> int:
	var total: int = 0
	for entry in aura_stats.values():
		total += int(entry.get("hp", 0))
	return total


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


## Heal up to max_hp() (base card HP + aura contributions). AURA.E1 — clamps
## at max_hp() instead of card_data.hp so a Wolf-Token under W42's +1/+1
## aura can heal up to its aura-boosted 3 HP, not just its base 2.
## Returns actual healing done.
func heal(amount: int) -> int:
	if amount <= 0 or card_data == null:
		return 0
	var before := current_hp
	current_hp = mini(max_hp(), current_hp + amount)
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
