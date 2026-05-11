extends Node

## GameState — autoload singleton holding the player's current run state.
##
## Registered in `project.godot` under [autoload] as `GameState` so any script
## can do `GameState.start_combat()`, `GameState.spend_mana(2)`, etc.
##
## Holds three layers of state:
##   - **Run-level** (lives across combats): seed, chapter, node, ash, keys,
##     modifiers, active Warlord, the player's deck/hand/discard zones.
##   - **Combat-level** (resets per combat): turn counter, mana, mana ceiling.
##   - **Player vitals** (run-level but combat-mutated): base HP, max HP.
##
## NOT held here (delegated):
##   - Card resolution / effect engine — lives in B2.6 card-play system.
##   - Combat board state (lanes, units in play) — lives in B2.5 combat scene.
##   - Map node graph — lives in B2.9 map screen.
##
## Lifecycle: `start_run()` → loops {`start_combat()` → `next_turn()` n times → result}
##           → `advance_node()` → next combat or `end_run()`.

# ---------- Run-level state -------------------------------------------------

var run_seed: int = 0
var active_warlord_id: StringName = &""
var current_phase: GFEnums.RunPhase = GFEnums.RunPhase.MAP
var chapter: int = 1
var current_node: int = 0

# Player zones — created by start_run, mutated by combat / reward systems.
var deck: Deck = null
var hand: Hand = null
var discard: Discard = null

# Run economy
var ash: int = 0          ## generic run currency (shop, reroll)
var keys: int = 0         ## chest keys / event gates
var modifiers: Array[StringName] = []  ## active curse/boon tags

# ---------- Combat-level state ---------------------------------------------

var turn: int = 0
var mana: int = 0
var max_mana: int = 3     ## per-turn refill ceiling. Grows with chapter (TBD per balance).
const MANA_OVERFLOW_CAP: int = 5  ## allow temp overflow above max_mana up to this much

# ---------- Player vitals --------------------------------------------------

var base_hp: int = 30
var max_base_hp: int = 30

# ---------- Signals ---------------------------------------------------------

signal phase_changed(old_phase: GFEnums.RunPhase, new_phase: GFEnums.RunPhase)
signal run_started(seed_value: int, warlord_id: StringName)
signal run_ended(victory: bool)
signal turn_started(turn_num: int)
signal turn_ended(turn_num: int)
signal mana_changed(new_mana: int, ceiling: int)
signal hp_changed(new_hp: int, max_hp: int)
signal node_advanced(new_node: int, chapter_num: int)

# Warlord XP + tier system (W5) — see warlord_tiers_v0.md, monetisation_map.md §13,
# and warlord_select_ui_v0.md §8 for the contract these signals fulfil.
signal warlord_xp_gained(warlord_id: StringName, amount: int, multiplier_applied: float)
signal warlord_tier_changed(warlord_id: StringName, new_tier: int)
signal xp_multiplier_changed(source_id: StringName, value: float)
signal xp_multiplier_consumed(source_id: StringName)


# ---------- Warlord XP + tier registry (W5) --------------------------------

## Cumulative XP thresholds per warlord_tiers_v0.md §2.2.
## Index = tier; value = cumulative XP needed to *reach* that tier.
## T1 at 0 XP. T2 at 1,800. T3 at 4,800. T4 at 10,800.
const TIER_THRESHOLDS: Array[int] = [0, 1800, 4800, 10800]

## XP-booster cap per warlord_tiers_v0.md §2.3 + monetisation_map.md §13.
## Multipliers stack multiplicatively; effective = min(this cap, product).
## Whale ceiling ~25 wins to T4 vs free floor ~72 — same destination, different speed.
const XP_MULTIPLIER_CAP: float = 3.0

## warlord_id (StringName) → cumulative XP earned (int).
## Initialised lazily on first gain_warlord_xp() call for that Warlord.
var warlord_xp: Dictionary = {}

## source_id (StringName) → multiplier value (float, e.g. 1.25 for +25% XP).
## See monetisation_map.md §13 for canonical source IDs:
##   "battle_pass_premium" / "battle_pass_free_lvl25" / "daily_quest_warlord_<id>"
##   / "starter_bundle" / "event_weekend" / "equipped_skin_<warlord_id>"
var xp_multiplier_sources: Dictionary = {}

## One-shot sources flagged to self-unregister after the next gain_warlord_xp().
## Used by daily-quest one-shots (per monetisation_map.md §11 + §13).
## Internal — callers use mark_one_shot_for_consume() / consume happens in _drain.
var _xp_pending_consume: Array[StringName] = []


func _ready() -> void:
	print("[GameState] autoload ready")


# ============================================================================
# Run lifecycle
# ============================================================================

## Start a new run. Builds the deck from `starter_pool`, sets the active Warlord,
## resets all combat state. Call this once per run from a "new game" or
## "continue from save" entry point.
func start_run(starter_pool: Array[Card], warlord_id: StringName, seed_value: int = 0) -> void:
	run_seed = seed_value if seed_value != 0 else randi()
	active_warlord_id = warlord_id
	chapter = 1
	current_node = 0
	base_hp = max_base_hp
	ash = 0
	keys = 0
	modifiers.clear()

	deck = Deck.new(starter_pool, run_seed)
	hand = Hand.new()
	discard = Discard.new()
	deck.shuffle()

	run_started.emit(run_seed, warlord_id)
	set_phase(GFEnums.RunPhase.MAP)


## End the current run. Emits `run_ended` and sets the terminal phase. The
## game-over screen / victory screen scenes (B2.10+) listen for this signal.
func end_run(victory: bool) -> void:
	set_phase(GFEnums.RunPhase.VICTORY if victory else GFEnums.RunPhase.GAME_OVER)
	run_ended.emit(victory)


# ============================================================================
# Phase transitions
# ============================================================================

func set_phase(new_phase: GFEnums.RunPhase) -> void:
	if new_phase == current_phase:
		return
	var old := current_phase
	current_phase = new_phase
	phase_changed.emit(old, new_phase)


# ============================================================================
# Combat lifecycle
# ============================================================================

## Begin a combat encounter. Resets turn, refunds hand/discard back into the
## deck so combat starts from a fresh shuffle, draws an opening hand, then
## advances to turn 1.
##
## `opening_hand_size` (B2.7): cards drawn from the freshly-shuffled deck into
## hand BEFORE turn 1 fires. Defaults to 0 so existing callers (B2.5 combat_test)
## see no behaviour change. Combat.start() passes Combat.OPENING_HAND_SIZE=5
## per the Slay-the-Spire convention. If the deck is shorter than the request,
## draws what's available; the player just opens with a thinner hand.
func start_combat(opening_hand_size: int = 0) -> void:
	set_phase(GFEnums.RunPhase.COMBAT)
	turn = 0
	mana = 0

	if hand != null and deck != null:
		for c in hand.clear():
			deck.add_to_top(c)
	if discard != null and deck != null:
		for c in discard.clear_all():
			deck.add_to_top(c)
	if deck != null:
		deck.shuffle()

	if opening_hand_size > 0 and hand != null and deck != null:
		for _i in range(opening_hand_size):
			var card: Card = deck.draw_one(discard)
			if card == null:
				break
			# Hand.add returns false on overflow + emits overflowed; we route
			# the overflow into discard here so the burn-mill rule applies
			# even to the opening draw (edge case: a Warlord ability could
			# pre-shrink the hand cap below opening_hand_size).
			if not hand.add(card) and discard != null:
				discard.add(card)

	next_turn()


## Advance to the next turn within the current combat. Refills mana to
## `max_mana`, increments the turn counter, fires both signals (turn_ended for
## the just-finished turn, then turn_started for the new one). Turn 0 is the
## "before combat" state — first call jumps from 0 → 1 with no turn_ended.
func next_turn() -> void:
	if turn > 0:
		turn_ended.emit(turn)
	turn += 1
	mana = max_mana
	mana_changed.emit(mana, max_mana)
	turn_started.emit(turn)


# ============================================================================
# Mana management
# ============================================================================

## Try to spend mana. Returns true if affordable (and deducts), false if not
## (no deduction; caller shows "not enough mana" UI).
func spend_mana(amount: int) -> bool:
	if amount < 0 or amount > mana:
		return false
	mana -= amount
	mana_changed.emit(mana, max_mana)
	return true


## Add temp mana (e.g. from C13 Ferryman of the Drowned Coin, C25 Coin-Drowner
## Acolyte's on-death). Caps at `max_mana + MANA_OVERFLOW_CAP` to prevent
## degenerate infinite-mana loops.
func gain_mana(amount: int) -> void:
	if amount <= 0:
		return
	mana = mini(mana + amount, max_mana + MANA_OVERFLOW_CAP)
	mana_changed.emit(mana, max_mana)


# ============================================================================
# HP management
# ============================================================================

## Apply damage to the player's base HP. Triggers `end_run(false)` on death.
## Returns the actual damage dealt (clamped to current HP).
func take_damage(amount: int) -> int:
	if amount <= 0:
		return 0
	var actual: int = mini(amount, base_hp)
	base_hp -= actual
	hp_changed.emit(base_hp, max_base_hp)
	if base_hp <= 0:
		end_run(false)
	return actual


## Heal the base. Clamped to `max_base_hp`.
func heal(amount: int) -> int:
	if amount <= 0:
		return 0
	var before := base_hp
	base_hp = mini(max_base_hp, base_hp + amount)
	hp_changed.emit(base_hp, max_base_hp)
	return base_hp - before


# ============================================================================
# Map navigation
# ============================================================================

## Advance to the next node. Caller (B2.9 map screen) decides which node and
## sets up the next phase (combat / reward / shop / event / boss). This method
## just bumps the counter and re-enters MAP phase; the actual node selection
## UI is the map screen's job.
func advance_node() -> void:
	current_node += 1
	node_advanced.emit(current_node, chapter)
	set_phase(GFEnums.RunPhase.MAP)


# ============================================================================
# Debug / inspection
# ============================================================================

## Returns a one-line state digest — handy for logging in the dev console.
func debug_summary() -> String:
	return ("turn=%d  mana=%d/%d  hp=%d/%d  ash=%d  keys=%d  phase=%s  warlord=%s" %
			[turn, mana, max_mana, base_hp, max_base_hp, ash, keys,
			GFEnums.RunPhase.keys()[current_phase], active_warlord_id])


# ============================================================================
# Warlord XP + tier system (W5)
# ============================================================================
#
# Wins-only XP. Multiplier boosters stack multiplicatively, clamp at
# XP_MULTIPLIER_CAP. Tier thresholds in TIER_THRESHOLDS. Calling
# gain_warlord_xp() applies the active stack, updates the per-Warlord total,
# emits warlord_xp_gained (always) and warlord_tier_changed (only on a
# threshold cross), then drains any one-shot sources flagged by
# mark_one_shot_for_consume() so they self-unregister.
#
# Anti-pay-to-win invariants (audit-tested in warlord_test.gd):
#   - gain_warlord_xp REJECTS negative or zero `base_amount` — no IAP path that
#     grants flat XP can exist by construction. Boosters multiply only.
#   - The effective multiplier is server-authoritative (clamped) at gain time.
#     Even if the client tampers with xp_multiplier_sources to insert a 99×
#     entry, get_effective_xp_multiplier() will clamp to 3.0.
#   - Tier transitions are computed from cumulative XP only. There is no
#     set_tier() / unlock_tier() API on this autoload.


## Award base XP for a win with this Warlord. Applies the current effective
## multiplier (clamped to XP_MULTIPLIER_CAP), updates the per-Warlord total,
## emits warlord_xp_gained, fires warlord_tier_changed if a tier was crossed,
## then drains any one-shot sources flagged for consumption.
##
## Per warlord_tiers_v0.md §2.1: wins-only by default. Losses give 0 XP — the
## caller (run-victory handler) decides whether to call this. No partial-XP path.
func gain_warlord_xp(warlord_id: StringName, base_amount: int) -> void:
	if warlord_id == &"" or base_amount <= 0:
		return  # anti-P2W: silently reject flat-XP grants and uninitialised callers
	var mult: float = get_effective_xp_multiplier()
	var awarded: int = int(round(float(base_amount) * mult))
	var before: int = int(warlord_xp.get(warlord_id, 0))
	var tier_before: int = _tier_for_xp(before)
	var after: int = before + awarded
	warlord_xp[warlord_id] = after
	warlord_xp_gained.emit(warlord_id, awarded, mult)
	var tier_after: int = _tier_for_xp(after)
	if tier_after != tier_before:
		warlord_tier_changed.emit(warlord_id, tier_after)
	_drain_pending_consumes()


## Register or update an XP-multiplier source. Idempotent — calling with the
## same (source_id, value) is fine; the signal still fires so UI listeners
## can refresh on every claim (e.g. BP unlock writes 1.25 once at season start).
##
## See monetisation_map.md §13 for the canonical source-ID registry.
func set_xp_multiplier_source(source_id: StringName, value: float) -> void:
	if source_id == &"" or value <= 0.0:
		return
	xp_multiplier_sources[source_id] = value
	xp_multiplier_changed.emit(source_id, value)


## Remove a multiplier source (BP season ended, starter bundle expired, etc.).
## Safe to call for a source that isn't registered — no-op.
func clear_xp_multiplier_source(source_id: StringName) -> void:
	if not xp_multiplier_sources.has(source_id):
		return
	xp_multiplier_sources.erase(source_id)
	# Emit with 0.0 to signal "this source is now gone" — UI distinguishes
	# from a value-change by inspecting xp_multiplier_sources after the signal.
	xp_multiplier_changed.emit(source_id, 0.0)


## Flag a multiplier source for one-shot consumption: it stays active for the
## NEXT gain_warlord_xp() call, then self-unregisters. Used by daily-quest
## one-shots ("win with Warlord X" awards a ×1.5 multiplier that consumes on
## the first qualifying win — see monetisation_map.md §11). Idempotent.
func mark_one_shot_for_consume(source_id: StringName) -> void:
	if not xp_multiplier_sources.has(source_id):
		return
	if not _xp_pending_consume.has(source_id):
		_xp_pending_consume.append(source_id)


## Effective stacked multiplier across all registered sources, clamped to
## XP_MULTIPLIER_CAP. Returns 1.0 if no sources registered. Used by the
## warlord-select UI booster strip (warlord_select_ui_v0.md §7) AND by
## gain_warlord_xp internally — single source of truth for "what's the
## current XP boost?"
func get_effective_xp_multiplier() -> float:
	var product: float = 1.0
	for v in xp_multiplier_sources.values():
		product *= float(v)
	return minf(XP_MULTIPLIER_CAP, product)


## Current tier (1..4) for the given Warlord based on cumulative XP.
## Returns 1 for any Warlord with no XP recorded yet.
func get_warlord_tier(warlord_id: StringName) -> int:
	return _tier_for_xp(int(warlord_xp.get(warlord_id, 0)))


## XP earned by the given Warlord (cumulative). 0 if no XP recorded yet.
func get_warlord_xp(warlord_id: StringName) -> int:
	return int(warlord_xp.get(warlord_id, 0))


## XP delta from current cumulative to the next tier threshold.
## Returns 0 if the Warlord is already at T4 (no further tier to reach).
func get_xp_to_next_tier(warlord_id: StringName) -> int:
	var xp: int = int(warlord_xp.get(warlord_id, 0))
	var tier: int = _tier_for_xp(xp)
	if tier >= 4:
		return 0
	return TIER_THRESHOLDS[tier] - xp


# Internal: cumulative XP → tier (1..4) per TIER_THRESHOLDS.
func _tier_for_xp(xp: int) -> int:
	if xp >= TIER_THRESHOLDS[3]:
		return 4
	if xp >= TIER_THRESHOLDS[2]:
		return 3
	if xp >= TIER_THRESHOLDS[1]:
		return 2
	return 1


# Internal: drain queued one-shot multipliers AFTER the gain has been applied.
# Emits xp_multiplier_consumed per source so UI plays the consumed animation,
# then emits xp_multiplier_changed(source, 0.0) for the registry-watcher path
# (warlord_select_ui_v0.md §7 booster drawer).
func _drain_pending_consumes() -> void:
	if _xp_pending_consume.is_empty():
		return
	var to_consume: Array[StringName] = _xp_pending_consume.duplicate()
	_xp_pending_consume.clear()
	for sid in to_consume:
		if xp_multiplier_sources.has(sid):
			xp_multiplier_sources.erase(sid)
			xp_multiplier_consumed.emit(sid)
			xp_multiplier_changed.emit(sid, 0.0)
