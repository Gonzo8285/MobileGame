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

# Map graph (B2.9). `current_map_graph` is built by MapGenerator.generate(chapter,
# run_seed) when the chapter begins (enter_chapter()). `current_node_id` is the
# StringName of the tile the player is currently AT — i.e. the node whose
# encounter has just resolved; choose_next_node() picks one of its children.
# Pre-B2.9 callers that only touched `current_node: int` keep working — that
# field is now a co-maintained counter the UI can ignore once it switches to
# the graph-aware path.
var current_map_graph: MapGraph = null
var current_node_id: StringName = &""

# Player zones — created by start_run, mutated by combat / reward systems.
var deck: Deck = null
var hand: Hand = null
var discard: Discard = null

# Deck persistence (DB-2). The last deck the player assembled in the deck-builder,
# as an ordered id list, so the builder can offer "Use last deck". In-memory for
# now — like the gem economy below, cross-session restore is IMV-2 (needs a save).
var last_deck_ids: Array[StringName] = []

# Run economy
var ash: int = 0          ## generic run currency (shop, reroll)
var keys: int = 0         ## chest keys / event gates
var modifiers: Array[StringName] = []  ## active curse/boon tags

# IMV-1 gem economy (Paul, 2026-05-18). Gems are the retry currency: earned by
# winning rounds, spent to restart a failed combat. Within IMV-1 they live on
# GameState (run-scoped). Persistence across runs is IMV-2 (requires save).
# Daily-login + IAP top-up are IMV-2 — for now starter_gems seeds each run.
const STARTER_GEMS: int = 3                ## seeded into each new run
const RETRY_COST_BY_ROUND: Array[int] = [
	1, 1, 2, 2, 3, 3, 4, 5  ## rounds 1-8; rises gently so late retries hurt
]
const GEM_REWARD_NORMAL: int = 2
const GEM_REWARD_ELITE: int = 3
const GEM_REWARD_HORDE: int = 5
const GEM_REWARD_BOSS: int = 10
var gems: int = 0
var retries_taken: int = 0


# ---------- Combat-level state ---------------------------------------------

var turn: int = 0
var mana: int = 0
var max_mana: int = 3     ## per-turn refill ceiling. Ramps +1/turn during a combat (see next_turn).
const MANA_OVERFLOW_CAP: int = 5  ## allow temp overflow above max_mana up to this much
const MANA_FLOOR: int = 3         ## start-of-combat mana ceiling (resets here each fight)
const MANA_CAP: int = 8           ## ramp cap — Paul, 2026-05-18 design call

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
signal gems_changed(new_amount: int)
signal retry_consumed(round_num: int, cost: int)

# Map graph signals (B2.9). `chapter_started` fires once when the player enters
# a chapter (graph is built; UI listens to render the map). `map_node_entered`
# fires every time the player commits to a tile (replaces the old int-counter
# `node_advanced` for graph-aware UIs; both still fire for back-compat).
signal chapter_started(chapter_num: int, graph: MapGraph)
signal map_node_entered(node: MapNode)

# Reward screen (B2.8) — fired by start_reward() / when the player resolves the
# offer. UI listens to `reward_offered` to show the picker; gameplay code
# listens to `reward_resolved` for post-pick effects (e.g. analytics events).
signal reward_offered(offer: RewardOffer)
signal reward_resolved(card: Card)  ## card == null on skip

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


# ---------- M41 Wraith-Caller cost-discount trigger (Phase 2.16 M41.E1) -----
#
# Per Phase 2.13 N1 + Phase 2.16 M41.E1: "When a friendly Mourner dies, the
# next Mourner you play this turn costs 1 less. Cap once per turn."
#
# Two-flag model enforces strict cap-once-per-turn:
#   - `mourner_discount_armed` — is a discount currently sitting on the next
#     Ash-Mourner play? Set by Combat._on_unit_killed when a friendly Ash-Mourner
#     dies AND a friendly M41 is alive in the same lane. Cleared by CardPlay
#     when consumed at play-time. Cleared at turn_started regardless.
#   - `_mourner_discount_fired_this_turn` — has the trigger fired (armed OR
#     consumed) yet this turn? Prevents re-arming after consume. Cleared at
#     turn_started.
#
# Not an aura — discrete event trigger; ships independently of AURA.E1.
var mourner_discount_armed: bool = false
var _mourner_discount_fired_this_turn: bool = false

signal mourner_discount_armed_changed(armed: bool)  ## HUD hint for play-cost overlay


# ---------- W41 Pack-Caller Initiate Wolf-Token draw trigger (Phase 2.16 W41.E1)
#
# Per Phase 2.13 N3 + Phase 2.16 W41.E1: "When a friendly Wolf-Token is summoned
# in your lane, draw 1 card. Once per turn."
#
# Discrete event trigger (not an aura). Single-flag model — there is no
# "armed waiting for next play" state because the draw resolves immediately on
# placement; we just need to know whether the trigger has fired this turn.
#   - `_wolf_summon_draw_fired_this_turn` — set when try_trigger_wolf_summon_draw()
#     successfully draws. Cleared at turn_started. Acts as the cap-once-per-turn
#     lock.
#
# Combat._on_unit_placed calls `try_trigger_wolf_summon_draw()` when a Wolf-Token
# (card.id == &"W28") is placed in a lane that contains an alive friendly W41.
# Anti-P2W invariant: no monetisation state involved. Pure combat trigger.
var _wolf_summon_draw_fired_this_turn: bool = false

signal wolf_summon_draw_triggered  ## HUD hint for "Pack-Caller drew" overlay


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
	gems = STARTER_GEMS
	retries_taken = 0
	gems_changed.emit(gems)

	deck = Deck.new(starter_pool, run_seed)
	hand = Hand.new()
	discard = Discard.new()
	deck.shuffle()

	run_started.emit(run_seed, warlord_id)
	set_phase(GFEnums.RunPhase.MAP)


## Record the deck the player assembled (DB-2), as an ordered id list. Stored so
## the deck-builder can offer "Use last deck". In-memory this session; a future
## save system (IMV-2) will persist it across launches.
func set_last_deck(ids: Array[StringName]) -> void:
	last_deck_ids = ids.duplicate()


## Start a run from an ordered id list (DB-2). Thin wrapper over start_run that
## resolves ids -> deep-copied Cards via CardDatabase, so the deck-builder works
## in ids while combat keeps receiving Array[Card]. start_run stays untouched.
func start_run_from_ids(ids: Array, warlord_id: StringName, seed_value: int = 0) -> void:
	start_run(CardDatabase.resolve_deck(ids), warlord_id, seed_value)


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
	max_mana = MANA_FLOOR   # per-combat reset; mana ramp restarts each fight

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
	# Mana ramp (Paul, 2026-05-18 design call): max_mana grows +1 each turn
	# from its starting value (3), capping at MANA_CAP. Classic Hearthstone /
	# Slay-the-Spire ramp curve. Per-combat reset happens in start_combat()
	# which resets max_mana back to 3, so each fight starts at the ramp floor.
	if max_mana < MANA_CAP:
		max_mana += 1
	mana = max_mana
	# M41.E1 — reset the Wraith-Caller cost-discount trigger at turn start.
	# Any armed-but-unconsumed discount is dropped; the "fired this turn" lock
	# clears so a fresh trigger window opens for the new turn.
	var had_discount := mourner_discount_armed
	mourner_discount_armed = false
	_mourner_discount_fired_this_turn = false
	if had_discount:
		mourner_discount_armed_changed.emit(false)
	# W41.E1 — reset the Pack-Caller Wolf-Token draw trigger at turn start.
	# Cap-once-per-turn lock clears so a fresh trigger window opens.
	_wolf_summon_draw_fired_this_turn = false
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
##
## Legacy int-counter path — kept for pre-B2.9 callers (B2.5 combat_test etc.).
## Graph-aware callers should use enter_chapter() / choose_next_node() instead;
## those still bump current_node so this method remains a valid manual-advance.
func advance_node() -> void:
	current_node += 1
	node_advanced.emit(current_node, chapter)
	set_phase(GFEnums.RunPhase.MAP)


## Build the chapter map and seat the player at the start tile. Emits
## chapter_started so the map-screen UI can render the graph. Does NOT fire
## map_node_entered yet — the player is "at the start node" but hasn't
## committed yet; the encounter resolves when they tap to advance.
##
## `chapter_num` defaults to the current `chapter` field. Pass an explicit
## value when re-entering for tests or replay-from-save.
func enter_chapter(chapter_num: int = 0) -> MapGraph:
	if chapter_num <= 0:
		chapter_num = chapter
	chapter = chapter_num
	current_map_graph = MapGenerator.generate(chapter_num, run_seed)
	current_node_id = current_map_graph.start_id
	current_node = 0
	set_phase(GFEnums.RunPhase.MAP)
	chapter_started.emit(chapter_num, current_map_graph)
	return current_map_graph


## Commit to a map node. Validates that `node_id` is a direct child of the
## current tile (or that we're seating at the start tile). On success:
##   - updates current_node_id
##   - bumps current_node (legacy counter — still emitted via node_advanced)
##   - emits map_node_entered(node) for graph-aware listeners
## On failure (illegal jump, unknown node, no graph loaded), returns false and
## emits no signals — caller shows a "can't go there" toast.
##
## The phase transition (combat / shop / event / etc.) is the CALLER's job —
## this method only handles the navigation bookkeeping. That keeps the
## "what scene runs" decision in one place (the map screen controller) instead
## of branching here on NodeKind.
func choose_next_node(node_id: StringName) -> bool:
	if current_map_graph == null:
		return false
	var target: MapNode = current_map_graph.get_node_by_id(node_id)
	if target == null:
		return false
	# Allow re-entering the start tile (e.g. first call after enter_chapter).
	# Otherwise require child-of relationship.
	var is_start_seat: bool = (current_node_id == current_map_graph.start_id and node_id == current_map_graph.start_id)
	if not is_start_seat and not current_map_graph.is_child_of(current_node_id, node_id):
		return false
	current_node_id = node_id
	current_node += 1
	node_advanced.emit(current_node, chapter)
	map_node_entered.emit(target)
	return true


# ============================================================================
# Reward lifecycle (B2.8)
# ============================================================================
#
# The map screen (B2.9) and combat-victory handler call `start_reward(offer)`
# after a win. start_reward:
#   1. transitions phase to REWARD
#   2. emits `reward_offered(offer)` so the picker UI shows itself
#   3. subscribes to the offer's `resolved` signal (one-shot)
#
# When the player taps a card (offer.choose) or skips (offer.skip), the
# subscribed handler:
#   - duplicates the chosen card and adds it to the top of the deck (skip = no-op)
#   - emits `reward_resolved(card_or_null)` for downstream listeners
#
# The deck is mutated in place — the run continues with the new card available
# from the next combat onwards. We don't reshuffle here; the next combat's
# start_combat() does its own reshuffle in the standard flow.


## Begin a reward pick. `offer` is built by RewardGenerator.generate_offer.
## Returns the offer so callers can chain (e.g. tests).
func start_reward(offer: RewardOffer) -> RewardOffer:
	if offer == null:
		return null
	set_phase(GFEnums.RunPhase.REWARD)
	# CONNECT_ONE_SHOT guarantees the handler fires exactly once even if
	# external code accidentally re-emits resolved (RewardOffer already
	# guards against this on its end; this is belt-and-braces).
	offer.resolved.connect(_on_reward_resolved, CONNECT_ONE_SHOT)
	reward_offered.emit(offer)
	return offer


func _on_reward_resolved(card: Card) -> void:
	if card != null and deck != null:
		# Duplicate so the deck owns a fresh instance — the pool's original
		# Card resource stays untouched and can be offered again later.
		deck.add_to_top(card.duplicate_card())
	reward_resolved.emit(card)


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



# ============================================================================
# Gem economy (IMV-1 — Paul, 2026-05-18)
# ============================================================================

## Award gems. Routed from combat-win handlers.
func gain_gems(amount: int) -> void:
	if amount <= 0:
		return
	gems += amount
	gems_changed.emit(gems)


## Spend gems for a retry. Returns true on success; false if insufficient.
## Caller (game_over flow) handles the retry-state setup; this only debits.
func spend_gems_for_retry(round_num: int) -> bool:
	var cost: int = retry_cost_for_round(round_num)
	if gems < cost:
		return false
	gems -= cost
	retries_taken += 1
	gems_changed.emit(gems)
	retry_consumed.emit(round_num, cost)
	return true


## Cost in gems to retry the given round (1-indexed). Bounded by array length.
func retry_cost_for_round(round_num: int) -> int:
	var idx: int = clampi(round_num - 1, 0, RETRY_COST_BY_ROUND.size() - 1)
	return RETRY_COST_BY_ROUND[idx]


## Gem reward for winning a round of the given kind.
func gem_reward_for_kind(kind: int) -> int:
	match kind:
		GFEnums.NodeKind.HORDE: return GEM_REWARD_HORDE
		GFEnums.NodeKind.BOSS:  return GEM_REWARD_BOSS
		GFEnums.NodeKind.ELITE: return GEM_REWARD_ELITE
		_:                      return GEM_REWARD_NORMAL


# ============================================================================
# M41 Wraith-Caller cost-discount trigger (Phase 2.16 M41.E1)
# ============================================================================
#
# Combat._on_unit_killed calls `arm_mourner_discount()` when a friendly
# Ash-Mourner dies AND a friendly M41 (Wraith-Caller of the Dirge) is alive in
# the same lane AND the trigger has not yet fired this turn.
#
# CardPlay.play_card calls `compute_play_cost(card)` to read the effective
# cost (1 less for an Ash-Mourner if armed, floor 0), then
# `consume_mourner_discount()` after a successful play to clear the armed flag.
# Consume does NOT clear the "fired this turn" lock — that's a turn-start reset
# only, so re-arming after consume within the same turn is blocked.
#
# Anti-P2W invariant: no monetisation state involved. Pure combat trigger.


## Arm the Wraith-Caller cost discount on the next Mourner play this turn.
## No-op if already armed or already fired this turn. Idempotent.
func arm_mourner_discount() -> void:
	if mourner_discount_armed or _mourner_discount_fired_this_turn:
		return
	mourner_discount_armed = true
	_mourner_discount_fired_this_turn = true
	mourner_discount_armed_changed.emit(true)


## Consume the discount (call from CardPlay after a successful Ash-Mourner play).
## No-op if not armed. Leaves `_mourner_discount_fired_this_turn` set so the
## trigger cannot re-arm within the same turn.
func consume_mourner_discount() -> void:
	if not mourner_discount_armed:
		return
	mourner_discount_armed = false
	mourner_discount_armed_changed.emit(false)


## Effective play cost for `card` given current discount state.
## Returns base cost minus 1 (floor 0) if the discount is armed AND the card
## is faction == ASH_MOURNERS. Otherwise base cost. Pure read; does NOT consume.
## Used by CardPlay to compute mana-check + spend, and by UI to show the
## strike-through preview on hand cards.
func compute_play_cost(card: Card) -> int:
	if card == null:
		return 0
	var base_cost: int = card.cost
	if mourner_discount_armed and card.faction == GFEnums.Faction.ASH_MOURNERS:
		return maxi(0, base_cost - 1)
	return base_cost


# ============================================================================
# W41 Pack-Caller Initiate Wolf-Token draw trigger (Phase 2.16 W41.E1)
# ============================================================================
#
# Combat._on_unit_placed calls `try_trigger_wolf_summon_draw()` when a Wolf-Token
# (card.id == &"W28") is placed in a lane that contains an alive friendly W41
# (Pack-Caller Initiate). The function gates on the once-per-turn lock and,
# if eligible, draws 1 card from the deck into hand (overflow → discard via
# the standard hand.overflowed wiring set up by Combat.start).
#
# Returns true if a draw fired this call, false if blocked (already fired this
# turn, or deck+discard both empty so no card is available).
##
## Try to fire the W41 Pack-Caller Wolf-Token draw trigger.
## Returns true if a card was actually drawn; false if blocked (cap exhausted
## or no card available).
func try_trigger_wolf_summon_draw() -> bool:
	if _wolf_summon_draw_fired_this_turn:
		return false
	if deck == null or hand == null:
		return false
	var card: Card = deck.draw_one(discard)
	if card == null:
		# Deck + discard both empty — burn-mill terminal state; no draw fired
		# so we deliberately DO NOT set the fired flag. A later Wolf-Token
		# placement this turn won't get to retry either — but if a previous
		# discard-cycle reseeds the deck mid-turn (rare; spell effect), the
		# trigger can still fire because the flag is still clear. Matches the
		# M41 convention: failed attempts don't burn the per-turn window.
		return false
	_wolf_summon_draw_fired_this_turn = true
	# Route to hand; if hand is full, the hand.overflowed signal (wired by
	# Combat.start) sends the card to discard per the burn-mill rule.
	if not hand.add(card) and discard != null:
		discard.add(card)
	wolf_summon_draw_triggered.emit()
	return true
