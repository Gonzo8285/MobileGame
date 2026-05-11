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
