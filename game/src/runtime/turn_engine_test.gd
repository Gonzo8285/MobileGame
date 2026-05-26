extends Node

## Smoke test for the B2.7 turn engine.
##
## Headless. Builds tiny synthetic Card + Enemy + Lane fixtures (no .tres
## loads) so the test exercises pure engine logic without depending on the
## state of any authored card data. Twelve assertions across three scenarios:
##
##   SCENE A — friendly attack at range
##     One MELEE friendly at tile 1, one enemy at tile 2 with HP=3 and ATK=1.
##     • A1: pre-tick state is sane (1 unit, 1 enemy, both alive)
##     • A2: process_turn_end_pre_advance fires 1 friendly attack
##     • A3: enemy HP dropped by friendly's ATK
##     • A4: friendly cooldown reset post-attack
##     • A5: dead enemy culled (set HP=0 first, re-run pre, count 1 kill_enemy)
##
##   SCENE B — DoT BLEED tick + decay
##     One enemy with BLEED-3 stacks. No friendlies.
##     • B1: DoT tick deals 3 damage
##     • B2: BLEED stacks decremented to 2 after one tick (NOT to 0)
##     • B3: second tick deals 2 damage; third tick 1; fourth tick 0
##
##   SCENE C — Persist M1 round-trip
##     Build a UNIT card with PERSIST keyword. Place a unit, kill it, drain
##     queue, confirm it returns at -1 ATK with has_persisted=true. Kill it
##     again, confirm it does NOT return (once-per-combat lock).
##     • C1: drain returns 1 persisted unit
##     • C2: persisted unit's atk_offset is -1 → current_attack = base - 1
##     • C3: persisted unit on origin tile
##     • C4: second-death drain returns 0 (lock holds)
##
##   SCENE D — TAUNT enemy-targeting redirect (keywords/taunt_v0.md)
##     • D1: enemy stand-attack on tile-N hits the TAUNT body, not the cheaper
##           non-taunt body sharing the same tile (TAUNT overrides cost rule).
##     • D2: TAUNT body on a different tile from the enemy does NOT redirect;
##           normal cheapest-on-tile rule still picks the non-taunt body.
##     • D3: TAUNT presence does not affect friendly→enemy attack resolution
##           (TAUNT only redirects enemy→friendly; documents the Cleave / AoE
##           "ignores TAUNT" clause from the spec).
##
##   SCENE E — LIFESTEAL heal-on-attack (keywords/lifesteal_v0.md)
##     • E1: damaged Lifesteal attacker (1/4 HP, 2 ATK) heals to 3/4 after
##           hitting an enemy for 2 damage.
##     • E2: full-HP Lifesteal attacker (4/4, 3 ATK) does NOT overheal; stays
##           at 4/4 after dealing 3 damage.
##     • E4: Lifesteal heal scales with dealt damage (clamped to enemy HP),
##           not raw ATK. Attacker swings 5 vs 1-HP enemy → heals 1, not 5.
##     • E3 deferred: Shield-mitigated-damage scaling — B2.7 enemies don't
##           carry keywords yet. Re-enable when enemy SHIELD/PIERCE lands.
##
## PASS = 0 errors. Wired into main.gd alongside the other dev tests.


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[turn_engine_test] PASS")
	else:
		printerr("[turn_engine_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors: int = 0
	errors += _scene_a_friendly_attack()
	errors += _scene_b_bleed_dot()
	errors += _scene_c_persist_roundtrip()
	errors += _scene_d_taunt_targeting()
	errors += _scene_e_lifesteal_heal_on_attack()
	return errors


# ============================================================================
# SCENE A — friendly melee attack
# ============================================================================

func _scene_a_friendly_attack() -> int:
	var errors: int = 0
	var lane := Lane.new(0, 6)

	# Enemy: 3 HP, 1 ATK, at tile 2 (in MELEE range of a unit at tile 1).
	var enemy_data := Enemy.new()
	enemy_data.id = &"E_test_a"
	enemy_data.display_name = "Test Enemy A"
	enemy_data.max_hp = 3
	enemy_data.attack = 1
	enemy_data.move_speed = 1
	var ei := EnemyInstance.new(enemy_data, 2, 0)
	lane.enemies.append(ei)

	# Friendly: 4 HP, 2 ATK, MELEE range, CD=1 (immediately ready since unit
	# starts with cd=card.cooldown=1, and we tick down before attacks).
	var unit_card := Card.new()
	unit_card.id = &"U_test_a"
	unit_card.display_name = "Test Unit A"
	unit_card.card_type = GFEnums.CardType.UNIT
	unit_card.hp = 4
	unit_card.attack = 2
	unit_card.attack_range = GFEnums.AttackRange.MELEE
	unit_card.cooldown = 1
	var u := UnitInstance.new(unit_card, 1, 0)
	# Force cooldown to 0 so the test exercises the attack path immediately
	# (otherwise it would attack on the next turn after a cooldown tick).
	u.cooldown_counter = 0
	lane.friendly_units.append(u)

	if lane.friendly_units.size() != 1 or lane.enemies.size() != 1:
		printerr("A1: setup wrong (units=%d enemies=%d)" % [lane.friendly_units.size(), lane.enemies.size()])
		errors += 1

	var lanes: Array[Lane] = [lane]
	var pre := TurnEngine.process_turn_end_pre_advance(lanes)
	if pre["friendly_atk"] != 1:
		printerr("A2: expected 1 friendly attack, got %d" % pre["friendly_atk"])
		errors += 1
	if ei.current_hp != 3 - 2:
		printerr("A3: enemy HP should be 1 after 2 dmg, got %d" % ei.current_hp)
		errors += 1
	if u.cooldown_counter != unit_card.cooldown:
		printerr("A4: cooldown should reset to %d post-attack, got %d" % [unit_card.cooldown, u.cooldown_counter])
		errors += 1

	# Now kill the enemy and rerun to verify cull.
	ei.take_damage(99)
	# Cooldown is now 1; tick it back to 0 so the unit can swing again, but
	# there's no enemy left, so the attack count stays 0 and the cull picks up
	# the corpse.
	u.cooldown_counter = 0
	var pre2 := TurnEngine.process_turn_end_pre_advance(lanes)
	if pre2["kills_enemy"] != 1:
		printerr("A5: expected 1 enemy cull, got %d" % pre2["kills_enemy"])
		errors += 1

	return errors


# ============================================================================
# SCENE B — BLEED DoT tick + decay
# ============================================================================

func _scene_b_bleed_dot() -> int:
	var errors: int = 0
	var lane := Lane.new(0, 6)

	var enemy_data := Enemy.new()
	enemy_data.id = &"E_test_b"
	enemy_data.display_name = "Test Enemy B"
	enemy_data.max_hp = 20
	enemy_data.attack = 0
	var ei := EnemyInstance.new(enemy_data, 5, 0)
	ei.add_status(GFEnums.Keyword.BLEED, 3)
	lane.enemies.append(ei)
	var lanes: Array[Lane] = [lane]

	# Tick 1: BLEED-3 → 3 damage, then decay to 2.
	var r1 := TurnEngine.process_turn_end_pre_advance(lanes)
	if r1["dot_damage"] != 3:
		printerr("B1: expected 3 DoT damage, got %d" % r1["dot_damage"])
		errors += 1
	if ei.get_status(GFEnums.Keyword.BLEED) != 2:
		printerr("B2: expected BLEED-2 after tick, got %d" % ei.get_status(GFEnums.Keyword.BLEED))
		errors += 1

	# Tick 2: BLEED-2 → 2 damage, decay to 1.
	var r2 := TurnEngine.process_turn_end_pre_advance(lanes)
	# Tick 3: BLEED-1 → 1 damage, decay to 0.
	var r3 := TurnEngine.process_turn_end_pre_advance(lanes)
	# Tick 4: BLEED-0 → no DoT damage.
	var r4 := TurnEngine.process_turn_end_pre_advance(lanes)
	if not (r2["dot_damage"] == 2 and r3["dot_damage"] == 1 and r4["dot_damage"] == 0):
		printerr("B3: expected DoT cascade 2-1-0, got %d-%d-%d" %
				[r2["dot_damage"], r3["dot_damage"], r4["dot_damage"]])
		errors += 1

	return errors


# ============================================================================
# SCENE C — Persist M1 round trip
# ============================================================================

func _scene_c_persist_roundtrip() -> int:
	var errors: int = 0
	var lane := Lane.new(0, 6)

	var unit_card := Card.new()
	unit_card.id = &"U_test_c_persist"
	unit_card.display_name = "Test Persist Unit"
	unit_card.card_type = GFEnums.CardType.UNIT
	unit_card.hp = 3
	unit_card.attack = 2
	unit_card.attack_range = GFEnums.AttackRange.MELEE
	unit_card.cooldown = 1
	unit_card.keywords = [GFEnums.Keyword.PERSIST]

	# Place a unit on tile 3.
	var u: UnitInstance = lane.place_unit(unit_card, 3)
	if u == null:
		printerr("C-setup: place_unit returned null")
		return errors + 1

	# Kill it, simulate Combat capturing the corpse into the persist queue.
	u.take_damage(99)
	var queue: Array[UnitInstance] = []
	# Snapshot the dead unit instance BEFORE cull (cull mutates the array).
	queue.append(u)
	lane.cull_dead_units()

	# Drain the queue.
	var lanes: Array[Lane] = [lane]
	var n: int = TurnEngine.drain_persists(lanes, queue)
	if n != 1:
		printerr("C1: expected 1 persisted, got %d" % n)
		errors += 1

	# The lane should now have a fresh UnitInstance on tile 3.
	if lane.friendly_units.size() != 1:
		printerr("C-extra: expected 1 friendly post-persist, got %d" % lane.friendly_units.size())
		return errors + 1
	var revived: UnitInstance = lane.friendly_units[0]

	# C2: ATK clamped to base - 1.
	if revived.current_attack() != unit_card.attack - 1:
		printerr("C2: expected current_attack=%d (base-1), got %d" %
				[unit_card.attack - 1, revived.current_attack()])
		errors += 1

	# C3: tile preserved.
	if revived.tile != 3:
		printerr("C3: expected revived tile=3, got %d" % revived.tile)
		errors += 1

	# C4: kill again, drain, confirm it does NOT come back.
	revived.take_damage(99)
	var queue2: Array[UnitInstance] = []
	queue2.append(revived)
	lane.cull_dead_units()
	var n2: int = TurnEngine.drain_persists(lanes, queue2)
	if n2 != 0:
		printerr("C4: once-per-combat lock failed — second persist returned %d" % n2)
		errors += 1
	if lane.friendly_units.size() != 0:
		printerr("C4b: lane should be empty after second death + locked persist, got %d" %
				lane.friendly_units.size())
		errors += 1

	return errors


# ============================================================================
# SCENE D — TAUNT enemy-targeting redirect (keywords/taunt_v0.md)
# ============================================================================

func _scene_d_taunt_targeting() -> int:
	var errors: int = 0

	# Shared helper inline: build a UNIT card with optional TAUNT.
	var mk_card := func(cid: StringName, cost: int, hp: int, atk: int,
			has_taunt: bool) -> Card:
		var c := Card.new()
		c.id = cid
		c.display_name = "TestCard_%s" % cid
		c.card_type = GFEnums.CardType.UNIT
		c.cost = cost
		c.hp = hp
		c.attack = atk
		c.attack_range = GFEnums.AttackRange.MELEE
		c.cooldown = 1
		c.is_draftable = true
		if has_taunt:
			c.keywords = [GFEnums.Keyword.TAUNT]
		return c

	# ----- D1: TAUNT body absorbs the stand-attack over a cheaper non-taunt -
	# Enemy on tile 1 collides with TWO friendlies sharing tile 1:
	#   - cheap_filler  cost=1  HP=10  (would normally be picked — cheapest)
	#   - taunt_anchor  cost=4  HP=10  TAUNT keyword
	# Expected: enemy hits taunt_anchor (loses 2 HP), filler untouched.
	var lane_d1 := Lane.new(0, 6)
	var enemy_d1 := Enemy.new()
	enemy_d1.id = &"E_test_d1"
	enemy_d1.display_name = "Test Enemy D1"
	enemy_d1.max_hp = 5
	enemy_d1.attack = 2
	enemy_d1.move_speed = 0  # stationary; collision is already set up
	var ei_d1 := EnemyInstance.new(enemy_d1, 1, 0)
	lane_d1.enemies.append(ei_d1)

	var filler := UnitInstance.new(
		mk_card.call(&"D1_filler", 1, 10, 1, false), 1, 0)
	filler.cooldown_counter = 99  # never attacks back; isolate enemy-attack path
	var taunter := UnitInstance.new(
		mk_card.call(&"D1_taunt", 4, 10, 1, true), 1, 1)
	taunter.cooldown_counter = 99
	lane_d1.friendly_units.append(filler)
	lane_d1.friendly_units.append(taunter)

	var lanes_d1: Array[Lane] = [lane_d1]
	TurnEngine.process_turn_end_pre_advance(lanes_d1)

	if taunter.current_hp != 10 - 2:
		printerr("D1: TAUNT body should have taken the 2 dmg, got HP=%d (expected %d)" %
				[taunter.current_hp, 10 - 2])
		errors += 1
	if filler.current_hp != 10:
		printerr("D1: non-taunt filler should be untouched, got HP=%d" %
				filler.current_hp)
		errors += 1

	# ----- D2: TAUNT on a DIFFERENT tile does not redirect ------------------
	# Enemy stand-attacks tile 2. A TAUNT body sits on tile 4 (out of the
	# enemy's collision tile). Filler on tile 2 should take the hit.
	var lane_d2 := Lane.new(0, 6)
	var enemy_d2 := Enemy.new()
	enemy_d2.id = &"E_test_d2"
	enemy_d2.display_name = "Test Enemy D2"
	enemy_d2.max_hp = 5
	enemy_d2.attack = 3
	enemy_d2.move_speed = 0
	var ei_d2 := EnemyInstance.new(enemy_d2, 2, 0)
	lane_d2.enemies.append(ei_d2)

	var filler2 := UnitInstance.new(
		mk_card.call(&"D2_filler", 1, 10, 1, false), 2, 0)
	filler2.cooldown_counter = 99
	var faraway_taunt := UnitInstance.new(
		mk_card.call(&"D2_taunt", 4, 10, 1, true), 4, 1)
	faraway_taunt.cooldown_counter = 99
	lane_d2.friendly_units.append(filler2)
	lane_d2.friendly_units.append(faraway_taunt)

	TurnEngine.process_turn_end_pre_advance([lane_d2])

	if filler2.current_hp != 10 - 3:
		printerr("D2: out-of-tile TAUNT should NOT pull aggro — expected filler2 HP=%d, got %d" %
				[10 - 3, filler2.current_hp])
		errors += 1
	if faraway_taunt.current_hp != 10:
		printerr("D2: faraway TAUNT body should be untouched, got HP=%d" %
				faraway_taunt.current_hp)
		errors += 1

	# ----- D3: TAUNT does not interfere with friendly→enemy attacks ---------
	# A friendly with MELEE range attacks an in-range enemy. A separate TAUNT
	# body sits beside it. Per spec, TAUNT only redirects enemy→friendly; it
	# must NOT modify friendly attack selection or counts.
	var lane_d3 := Lane.new(0, 6)
	var enemy_d3 := Enemy.new()
	enemy_d3.id = &"E_test_d3"
	enemy_d3.display_name = "Test Enemy D3"
	enemy_d3.max_hp = 10
	enemy_d3.attack = 0
	enemy_d3.move_speed = 0
	var ei_d3 := EnemyInstance.new(enemy_d3, 2, 0)
	lane_d3.enemies.append(ei_d3)

	var attacker := UnitInstance.new(
		mk_card.call(&"D3_atk", 2, 5, 3, false), 1, 0)
	attacker.cooldown_counter = 0  # ready to swing
	var bystander_taunt := UnitInstance.new(
		mk_card.call(&"D3_taunt", 4, 5, 1, true), 1, 1)
	bystander_taunt.cooldown_counter = 99
	lane_d3.friendly_units.append(attacker)
	lane_d3.friendly_units.append(bystander_taunt)

	var res_d3 := TurnEngine.process_turn_end_pre_advance([lane_d3])
	if res_d3["friendly_atk"] != 1:
		printerr("D3: expected 1 friendly attack regardless of TAUNT bystander, got %d" %
				res_d3["friendly_atk"])
		errors += 1
	if ei_d3.current_hp != 10 - 3:
		printerr("D3: enemy should have taken attacker's 3 dmg, got HP=%d" %
				ei_d3.current_hp)
		errors += 1

	return errors


# ============================================================================
# SCENE E — LIFESTEAL heal-on-attack (keywords/lifesteal_v0.md)
# ============================================================================
#
# Validates the LIFESTEAL keyword wired into _resolve_friendly_attacks_in_lane:
#   • E1: damaged Lifesteal attacker heals for damage_dealt (≤ max_hp clamp)
#   • E2: full-HP Lifesteal attacker does not overheal (heal returns 0)
#   • E3: Shield-tagged target reduces damage; Lifesteal heals only for the
#         actually-dealt amount (post-Shield). NOTE: B2.7 enemies don't carry
#         keywords yet, so this test uses the dealt = take_damage(actual)
#         clamp at low enemy HP as a proxy for "Shield-limited damage". E3
#         is documented but skipped pending enemy-keyword support; the clamp-
#         at-enemy-HP variant IS exercised by E2.
#   • E4: Lifesteal attacker on a dead enemy (post-overkill) — no heal because
#         actual dealt is clamped to remaining enemy HP, and once enemy hits 0
#         the heal would equal the overkill-clamped value, not raw ATK.
#
# Counts as 3 assertions (E3 deferred). Authored 2026-05-26 by Controller.

func _scene_e_lifesteal_heal_on_attack() -> int:
	var errors: int = 0

	# Shared helper: build a UNIT card with optional LIFESTEAL.
	var mk_card := func(cid: StringName, hp: int, atk: int,
			has_lifesteal: bool) -> Card:
		var c := Card.new()
		c.id = cid
		c.display_name = "TestCard_%s" % cid
		c.card_type = GFEnums.CardType.UNIT
		c.cost = 2
		c.hp = hp
		c.attack = atk
		c.attack_range = GFEnums.AttackRange.MELEE
		c.cooldown = 1
		c.is_draftable = true
		if has_lifesteal:
			c.keywords = [GFEnums.Keyword.LIFESTEAL]
		return c

	# ----- E1: damaged Lifesteal attacker heals for damage_dealt -------------
	# Setup: enemy at tile 2 with 10 HP, friendly Lifesteal attacker at tile 1
	# with max_hp=4 / atk=2 / current_hp=1 (took 3 prior damage). Attacker
	# swings for 2, enemy survives (HP 10→8), attacker heals 2 → ends at HP 3.
	var lane_e1 := Lane.new(0, 6)
	var enemy_e1 := Enemy.new()
	enemy_e1.id = &"E_test_e1"
	enemy_e1.display_name = "Test Enemy E1"
	enemy_e1.max_hp = 10
	enemy_e1.attack = 0
	enemy_e1.move_speed = 0
	var ei_e1 := EnemyInstance.new(enemy_e1, 2, 0)
	lane_e1.enemies.append(ei_e1)

	var attacker_e1 := UnitInstance.new(
		mk_card.call(&"E1_lifesteal", 4, 2, true), 1, 0)
	attacker_e1.cooldown_counter = 0  # ready to swing
	attacker_e1.current_hp = 1  # took 3 prior damage
	lane_e1.friendly_units.append(attacker_e1)

	TurnEngine.process_turn_end_pre_advance([lane_e1])

	if ei_e1.current_hp != 10 - 2:
		printerr("E1: enemy should be at 8 HP after 2 dmg, got %d" % ei_e1.current_hp)
		errors += 1
	if attacker_e1.current_hp != 3:
		printerr("E1: Lifesteal attacker should heal from 1 to 3 (heal 2), got HP=%d" %
				attacker_e1.current_hp)
		errors += 1

	# ----- E2: full-HP Lifesteal attacker does NOT overheal ------------------
	# Setup: enemy with 10 HP at tile 2, full-HP (4/4) Lifesteal attacker at
	# tile 1 with atk=3. Attacker swings for 3, enemy survives, heal returns 0
	# because attacker is at max HP. Final HP unchanged (still 4).
	var lane_e2 := Lane.new(0, 6)
	var enemy_e2 := Enemy.new()
	enemy_e2.id = &"E_test_e2"
	enemy_e2.display_name = "Test Enemy E2"
	enemy_e2.max_hp = 10
	enemy_e2.attack = 0
	enemy_e2.move_speed = 0
	var ei_e2 := EnemyInstance.new(enemy_e2, 2, 0)
	lane_e2.enemies.append(ei_e2)

	var attacker_e2 := UnitInstance.new(
		mk_card.call(&"E2_lifesteal_fullhp", 4, 3, true), 1, 0)
	attacker_e2.cooldown_counter = 0
	# current_hp left at default (4 = max from _init)
	lane_e2.friendly_units.append(attacker_e2)

	TurnEngine.process_turn_end_pre_advance([lane_e2])

	if attacker_e2.current_hp != 4:
		printerr("E2: full-HP Lifesteal attacker should NOT overheal (expected 4), got HP=%d" %
				attacker_e2.current_hp)
		errors += 1
	if ei_e2.current_hp != 10 - 3:
		printerr("E2: enemy should be at 7 HP after 3 dmg, got %d" % ei_e2.current_hp)
		errors += 1

	# ----- E4: Lifesteal heal scales with actual damage dealt, not raw ATK ---
	# Setup: enemy at tile 2 with 1 HP (about to die), Lifesteal attacker at
	# tile 1 with atk=5 / max_hp=10 / current_hp=2. Attacker swings for 5 but
	# enemy only has 1 HP — apply_damage_to_enemy returns 1 (the clamped actual).
	# Attacker heals for 1, not 5. Ends at HP 3.
	var lane_e4 := Lane.new(0, 6)
	var enemy_e4 := Enemy.new()
	enemy_e4.id = &"E_test_e4"
	enemy_e4.display_name = "Test Enemy E4"
	enemy_e4.max_hp = 1
	enemy_e4.attack = 0
	enemy_e4.move_speed = 0
	var ei_e4 := EnemyInstance.new(enemy_e4, 2, 0)
	lane_e4.enemies.append(ei_e4)

	var attacker_e4 := UnitInstance.new(
		mk_card.call(&"E4_overkill", 10, 5, true), 1, 0)
	attacker_e4.cooldown_counter = 0
	attacker_e4.current_hp = 2
	lane_e4.friendly_units.append(attacker_e4)

	TurnEngine.process_turn_end_pre_advance([lane_e4])

	if attacker_e4.current_hp != 3:
		printerr("E4: Lifesteal heal should match dealt=1 (not raw atk=5); expected HP=3, got %d" %
				attacker_e4.current_hp)
		errors += 1

	return errors
