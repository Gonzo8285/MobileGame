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
## deck so combat starts from a fresh shuffle, then advances to turn 1.
func start_combat() -> void:
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
