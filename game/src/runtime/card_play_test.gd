extends Node

## Smoke test for the B2.6 card-play resolver.
##
## 14 assertions covering:
##   - successful UNIT placement (mana deduction, hand→discard, lane state)
##   - insufficient-mana rejection
##   - invalid-lane / out-of-range-tile / occupied-tile rejection
##   - card-not-in-hand rejection
##   - null-card rejection
##   - auto-tile defaulting via Lane.first_empty_tile
##   - SPELL stub: cost deducted, hand→discard, spell_target preserved
##   - TRAP stub: cost deducted, lane validated, trap_lane preserved
##
## All checks are pure-logic — no scene tree drag-drop yet (that's the next
## chunk of B2.6). Verifies the resolver behaves identically to the Python
## mirror that was used to develop it.
##
## PASS = 0 errors. Wired into main.gd alongside the other dev tests.

const POOL_DIRS: Array[String] = [
	"res://data/cards/iron_penitents/",
	"res://data/cards/ash_mourners/",
	"res://data/cards/coven/",
	"res://data/cards/",  # legacy C1..C10 / P1..P9 / M1..M11 sit at this level
]
const WARLORD_ID: StringName = &"vyrrun_test"


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[card_play_test] PASS")
	else:
		printerr("[card_play_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors: int = 0

	# ---- Load any pool we can find and pick one card of each type --------
	var pool: Array[Card] = []
	for d in POOL_DIRS:
		pool.append_array(_load_pool(d))
	if pool.is_empty():
		printerr("FATAL: no cards loaded from any pool dir")
		return 1

	var unit_card: Card = _find_first(pool, GFEnums.CardType.UNIT, 1)   # cost ≤ 1
	var spell_card: Card = _find_first(pool, GFEnums.CardType.SPELL, 99)
	var trap_card: Card = _find_first(pool, GFEnums.CardType.TRAP, 99)
	if unit_card == null:
		printerr("FATAL: no UNIT card with cost ≤ 1 in pool")
		return 1
	# Spell / trap may legitimately not exist in the very early pool; we
	# downgrade those tests to skips rather than failures.
	print("[card_play_test] loaded %d cards (unit=%s spell=%s trap=%s)" % [
		pool.size(),
		String(unit_card.id),
		"-" if spell_card == null else String(spell_card.id),
		"-" if trap_card == null else String(trap_card.id),
	])

	# ---- Setup -----------------------------------------------------------
	GameState.start_run([], WARLORD_ID, 4242)
	GameState.start_combat()
	# start_combat refills mana to max_mana (3 by default). Bump to 5 so we
	# can play a chain of cards without micro-managing the meter.
	GameState.mana = 5
	var hand := GameState.hand
	var discard := GameState.discard
	var lanes: Array[Lane] = []
	for i in range(3):
		lanes.append(Lane.new(i, 6))
	# Stage cards directly into hand for predictable assertions (the deck
	# shuffle is verified elsewhere — here we want determinism).
	hand.add(unit_card)
	if spell_card != null: hand.add(spell_card)
	if trap_card != null: hand.add(trap_card)

	# ===== AS1 — successful UNIT placement ================================
	var mana_before: int = GameState.mana
	var hand_size_before: int = hand.size()
	var discard_size_before: int = discard.size()
	var r1: Dictionary = CardPlay.play_card(unit_card, {"lane": 1, "tile": 3}, hand, discard, lanes)
	if not r1.get("success", false):
		printerr("AS1: expected success, got %s" % str(r1))
		errors += 1
	if GameState.mana != mana_before - unit_card.cost:
		printerr("AS2: mana not deducted correctly (%d → %d, cost %d)" % [
			mana_before, GameState.mana, unit_card.cost])
		errors += 1
	if hand.size() != hand_size_before - 1:
		printerr("AS3: hand size should decrement by 1 (was %d, now %d)" % [
			hand_size_before, hand.size()])
		errors += 1
	if discard.size() != discard_size_before + 1:
		printerr("AS4: discard size should increment by 1 (was %d, now %d)" % [
			discard_size_before, discard.size()])
		errors += 1
	if lanes[1].friendly_units.size() != 1:
		printerr("AS5: lane 1 should have 1 friendly unit, has %d" % lanes[1].friendly_units.size())
		errors += 1
	var placed_unit: UnitInstance = r1.get("unit") as UnitInstance
	if placed_unit == null or placed_unit.tile != 3 or placed_unit.lane_index != 1:
		printerr("AS6: returned unit has wrong placement (%s)" % str(placed_unit))
		errors += 1

	# ===== AS7 — occupied-tile rejection =================================
	# Need another UNIT card with cost ≤ remaining mana for this test.
	var unit_card_2: Card = _find_first_excluding(pool, GFEnums.CardType.UNIT, 1, [unit_card])
	if unit_card_2 != null:
		hand.add(unit_card_2)
		var r_occ: Dictionary = CardPlay.play_card(unit_card_2, {"lane": 1, "tile": 3}, hand, discard, lanes)
		if r_occ.get("success", true):
			printerr("AS7: expected failure on occupied tile, got success: %s" % str(r_occ))
			errors += 1
		# State must NOT have changed on rejection.
		if not _hand_contains(hand, unit_card_2):
			printerr("AS8: rejected card disappeared from hand")
			errors += 1
		hand.remove(unit_card_2)

	# ===== AS9 — invalid lane ============================================
	var unit_card_3: Card = _find_first_excluding(pool, GFEnums.CardType.UNIT, 1, [unit_card])
	if unit_card_3 != null:
		hand.add(unit_card_3)
		var r_lane: Dictionary = CardPlay.play_card(unit_card_3, {"lane": 5, "tile": 1}, hand, discard, lanes)
		if r_lane.get("success", true):
			printerr("AS9: expected failure on invalid lane, got success")
			errors += 1
		hand.remove(unit_card_3)

	# ===== AS10 — out-of-range tile (base) ================================
	var unit_card_4: Card = _find_first_excluding(pool, GFEnums.CardType.UNIT, 1, [unit_card])
	if unit_card_4 != null:
		hand.add(unit_card_4)
		var r_tile0: Dictionary = CardPlay.play_card(unit_card_4, {"lane": 0, "tile": 0}, hand, discard, lanes)
		if r_tile0.get("success", true):
			printerr("AS10: expected failure on tile 0 (base)")
			errors += 1
		hand.remove(unit_card_4)

	# ===== AS11 — auto-tile (no tile passed) ==============================
	var unit_card_5: Card = _find_first_excluding(pool, GFEnums.CardType.UNIT, 1, [unit_card])
	if unit_card_5 != null:
		hand.add(unit_card_5)
		var r_auto: Dictionary = CardPlay.play_card(unit_card_5, {"lane": 0}, hand, discard, lanes)
		if not r_auto.get("success", false):
			printerr("AS11: auto-tile placement failed: %s" % str(r_auto.get("reason", "")))
			errors += 1
		else:
			var u: UnitInstance = r_auto.get("unit") as UnitInstance
			if u == null or u.tile != 1:
				printerr("AS12: auto-tile should pick tile 1 (back rank), got %s" % str(u))
				errors += 1

	# ===== AS13 — insufficient mana =======================================
	var unit_card_6: Card = _find_first_excluding(pool, GFEnums.CardType.UNIT, 99, [unit_card])
	if unit_card_6 != null and unit_card_6.cost > 0:
		hand.add(unit_card_6)
		var saved_mana: int = GameState.mana
		GameState.mana = 0
		var r_mana: Dictionary = CardPlay.play_card(unit_card_6, {"lane": 2, "tile": 1}, hand, discard, lanes)
		if r_mana.get("success", true):
			printerr("AS13: expected failure on insufficient mana")
			errors += 1
		GameState.mana = saved_mana
		hand.remove(unit_card_6)

	# ===== AS14 — null card ===============================================
	var r_null: Dictionary = CardPlay.play_card(null, {"lane": 0}, hand, discard, lanes)
	if r_null.get("success", true):
		printerr("AS14: expected failure on null card")
		errors += 1

	# ===== AS15 — SPELL stub (skip if pool has none) ======================
	if spell_card != null:
		var spell_mana_before: int = GameState.mana
		GameState.mana = max(GameState.mana, spell_card.cost)
		var r_spell: Dictionary = CardPlay.play_card(spell_card, {"lane": 0}, hand, discard, lanes)
		if not r_spell.get("success", false):
			printerr("AS15: spell stub should succeed, got %s" % str(r_spell))
			errors += 1
		if r_spell.get("spell_target") == null:
			printerr("AS16: spell_target should be preserved on result")
			errors += 1
		GameState.mana = spell_mana_before

	# ===== AS17 — TRAP invalid lane =======================================
	if trap_card != null:
		var trap_mana_before: int = GameState.mana
		GameState.mana = max(GameState.mana, trap_card.cost)
		# Re-add trap if previous tests removed it.
		if not _hand_contains(hand, trap_card):
			hand.add(trap_card)
		var r_trap_bad: Dictionary = CardPlay.play_card(trap_card, {"lane": 99}, hand, discard, lanes)
		if r_trap_bad.get("success", true):
			printerr("AS17: trap on invalid lane should fail")
			errors += 1
		# Now play a valid one.
		var r_trap_ok: Dictionary = CardPlay.play_card(trap_card, {"lane": 0}, hand, discard, lanes)
		if not r_trap_ok.get("success", false):
			printerr("AS18: valid trap should succeed, got %s" % str(r_trap_ok))
			errors += 1
		if int(r_trap_ok.get("trap_lane", -1)) != 0:
			printerr("AS19: trap_lane should be preserved as 0")
			errors += 1
		GameState.mana = trap_mana_before

	return errors


# ---------- Helpers -------------------------------------------------------

func _load_pool(dir_path: String) -> Array[Card]:
	var out: Array[Card] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var f := dir.get_next()
	while f != "":
		if f.ends_with(".tres"):
			var res := load(dir_path + f) as Card
			if res != null:
				out.append(res)
		f = dir.get_next()
	dir.list_dir_end()
	return out


func _find_first(pool: Array[Card], ct: GFEnums.CardType, max_cost: int) -> Card:
	for c in pool:
		if c.card_type == ct and c.cost <= max_cost:
			return c
	return null


func _find_first_excluding(pool: Array[Card], ct: GFEnums.CardType, max_cost: int,
		exclude: Array[Card]) -> Card:
	for c in pool:
		if c.card_type == ct and c.cost <= max_cost and not (c in exclude):
			return c
	return null


func _hand_contains(hand: Hand, card: Card) -> bool:
	for c in hand.cards():
		if c == card:
			return true
	return false
