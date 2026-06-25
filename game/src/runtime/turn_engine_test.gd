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
##   SCENE F — AURA dispatch (keywords/aura_v0.md, AURA.E1)
##     W42 Den-Mother + Wolf-Token plumbing as the representative outbound-
##     aura case. Other aura cards W4 / banner spine ride the same paths.
##     • F1: W42 placed in lane with two existing Wolf-Tokens → both tokens
##           become 2/3 with LIFESTEAL.
##     • F2: A new Wolf-Token placed after W42 already in lane → gets the
##           grant on-enter.
##     • F3: W42 dies and is culled → all tokens revert to base 1/2, no
##           LIFESTEAL, runtime_keywords / aura_stats empty.
##     • F4: Two W42s in lane → tokens stack additively to 3/4 with
##           LIFESTEAL (single keyword set-union). One W42 dies → tokens
##           revert to 2/3, still LIFESTEAL from the survivor.
##     • F5: Full-HP token (4/4) under double W42. One W42 dies → HP clamps
##           to new max (3), not killed.
##     • F6: Token at 1/4 HP under double W42. Both die → HP floors at 1
##           (never killed by aura revoke per aura_v0.md spec).
##
##   SCENE G — L41 SELF-AURA (keywords/aura_v0.md, L41.E1)
##     L41 Banner-Bearer of the Crowned Anvil — first self-aura in the
##     engine. Grants self +1 ATK + PIERCE while a friendly banner (v0
##     predicate = L34 Crowned Anvil Standard) is in lane.
##     • G1: L41 enters lane alone → no banner present → no grant
##           (runtime_keywords / aura_stats empty).
##     • G2: L34 then enters the same lane → re-evaluate fires → L41 gains
##           +1 ATK + PIERCE (verified via current_attack() + has_keyword).
##     • G3: L34 dies and is culled → re-evaluate revokes → L41 reverts to
##           base ATK without PIERCE.
##
##   SCENE H — W4 Bear-Skin Hierophant DYNAMIC OUTBOUND aura (W4.E1)
##     First dynamic-target aura — the holder of the +2 HP + CLEAVE grant
##     shifts as lane composition changes. Predicate: unique max-cost
##     Skinward Pact unit in lane, excluding W4 itself; tie-break = lowest
##     tile (closest to base).
##     • H1: W4 alone in lane → no eligible target → no grant projected.
##     • H2: A 3-cost Wilds enters the lane → it becomes the holder,
##           gaining +2 HP + CLEAVE.
##     • H3: A 5-cost Wilds enters later → grant SHIFTS to the 5c, the
##           3c reverts to base.
##     • H4: Two 5-cost Wilds at different tiles. Lower-tile wins the
##           grant by the determinism tie-break.
##     • H5: The current holder dies → grant moves to the next-highest
##           Wilds in lane via re_evaluate_dynamic_outbound_auras.
##
##   SCENE I — LD3 Banner-Buff spine batch (L30 + L34 dispatch, LD3.E1)
##     L27-L40 spine survey: only L30 + L34 fit clean self/outbound aura
##     patterns this heartbeat can wire — rest defer (BANNER_TOKEN spawners,
##     SHIELD aura, FEAR immunity, on-death events, traps, spells, relics).
##     • I1: L30 alone in lane → no banner → no grant. L34 then enters →
##           three things resolve in one place_unit: (a) L34's outbound
##           grants +1 ATK to L30 (friendly Legion in lane), (b) L30's self-
##           aura now sees banner-presence and grants itself +1 ATK,
##           (c) L34 itself doesn't self-grant. Net: L30 sits at base+2 ATK.
##     • I2: L34 grants +1 ATK to multiple friendly Legion in lane (3 cards),
##           skipping non-Legion friendlies.
##     • I3: L34 dies and is culled → L30 reverts to base (banner condition
##           lost) AND all other Legion units lose L34's +1 ATK outbound grant.
##
##   SCENE J — M41 Wraith-Caller cost-discount trigger (M41.E1)
##     Tests the GameState.arm_mourner_discount + compute_play_cost +
##     consume_mourner_discount path. The combat.gd lane.unit_killed
##     subscriber is exercised indirectly — these scenes drive the GameState
##     API directly to keep the test headless (Combat scene-tree wiring is
##     covered by combat_test.gd).
##     • J1: flag clear → compute_play_cost(M-card) returns base cost
##     • J2: arm_mourner_discount → compute_play_cost(M-card) returns base-1
##           (floor 0); non-Mourner card still returns base
##     • J3: consume_mourner_discount clears the flag; second M-card same
##           turn pays base cost (cap once/turn)
##     • J4: arm again same turn → no-op (already-fired lock holds)
##
##   SCENE K — W41 Pack-Caller Initiate draw trigger (W41.E1)
##     Tests the GameState.try_trigger_wolf_summon_draw path. Combat.gd
##     subscriber is exercised in combat_test.gd; here we drive GameState
##     directly with a synthetic deck + hand.
##     • K1: try_trigger with deck having ≥1 card → returns true, hand grows
##           by 1, fired-this-turn flag set
##     • K2: second try_trigger same turn → returns false (cap), hand unchanged
##     • K3: empty deck + empty discard → returns false, fired-flag stays
##           clear (failed attempts don't burn the per-turn window)
##
## PASS = 0 errors. Wired into main.gd alongside the other dev tests.


func _ready() -> void:
	print("[turn_engine_test] LOAD OK — file parsed and _ready fired")
	var rc := _run()
	if rc == 0:
		print("[turn_engine_test] PASS")
	else:
		printerr("[turn_engine_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors: int = 0
	print("[turn_engine_test] scene A start"); errors += _scene_a_friendly_attack()
	print("[turn_engine_test] scene B start"); errors += _scene_b_bleed_dot()
	print("[turn_engine_test] scene C start"); errors += _scene_c_persist_roundtrip()
	print("[turn_engine_test] scene D start"); errors += _scene_d_taunt_targeting()
	print("[turn_engine_test] scene E start"); errors += _scene_e_lifesteal_heal_on_attack()
	print("[turn_engine_test] scene F start"); errors += _scene_f_aura_dispatch()
	print("[turn_engine_test] scene G start"); errors += _scene_g_l41_self_aura()
	print("[turn_engine_test] scene H start"); errors += _scene_h_w4_dynamic_outbound()
	print("[turn_engine_test] scene I start"); errors += _scene_i_ld3_banner_buff()
	print("[turn_engine_test] scene J start"); errors += _scene_j_m41_cost_discount()
	print("[turn_engine_test] scene K start"); errors += _scene_k_w41_wolf_summon_draw()
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
	# Enemy stand-attacks resolve in the POST-advance phase (friendly attacks go
	# in pre-advance). The enemy is pre-positioned on the collision tile, so we
	# call post-advance directly to exercise the redirect.
	TurnEngine.process_turn_end_post_advance(lanes_d1)

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

	TurnEngine.process_turn_end_post_advance([lane_d2])

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


# ============================================================================
# SCENE F — AURA dispatch (W42 Den-Mother + Wolf-Token, keywords/aura_v0.md)
# ============================================================================

func _scene_f_aura_dispatch() -> int:
	var errors: int = 0

	# Helper: build a Wolf-Token card matching the W28 dispatch target.
	var mk_wolf := func() -> Card:
		var c := Card.new()
		c.id = &"W28"
		c.display_name = "Wolf-Token"
		c.card_type = GFEnums.CardType.UNIT
		c.cost = 0
		c.hp = 2
		c.attack = 1
		c.attack_range = GFEnums.AttackRange.MELEE
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# Helper: build the W42 Den-Mother card matching the dispatch entry.
	var mk_den_mother := func() -> Card:
		var c := Card.new()
		c.id = &"W42"
		c.display_name = "Den-Mother of the Cinderwood"
		c.card_type = GFEnums.CardType.UNIT
		c.cost = 4
		c.hp = 4
		c.attack = 2
		c.attack_range = GFEnums.AttackRange.MELEE
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# ----- F1: W42 enters lane with 2 existing Wolf-Tokens ------------------
	var lane_f1 := Lane.new(0, 6)
	var wolf_a := lane_f1.place_unit(mk_wolf.call(), 1)
	var wolf_b := lane_f1.place_unit(mk_wolf.call(), 2)
	var den_mother := lane_f1.place_unit(mk_den_mother.call(), 3)
	if wolf_a == null or wolf_b == null or den_mother == null:
		printerr("F1: setup failed — place_unit returned null")
		return errors + 1
	# Both tokens should now be 2/3 with LIFESTEAL.
	if wolf_a.current_attack() != 2:
		printerr("F1: wolf_a current_attack should be 2 under aura, got %d" %
				wolf_a.current_attack())
		errors += 1
	if wolf_a.max_hp() != 3:
		printerr("F1: wolf_a max_hp should be 3 under aura, got %d" % wolf_a.max_hp())
		errors += 1
	if wolf_a.current_hp != 3:
		printerr("F1: wolf_a current_hp should be raised to 3 by aura grant, got %d" %
				wolf_a.current_hp)
		errors += 1
	if not wolf_a.has_keyword(GFEnums.Keyword.LIFESTEAL):
		printerr("F1: wolf_a should have LIFESTEAL from aura")
		errors += 1
	if wolf_b.current_attack() != 2 or wolf_b.max_hp() != 3:
		printerr("F1: wolf_b expected 2/3, got %d/%d" %
				[wolf_b.current_attack(), wolf_b.max_hp()])
		errors += 1

	# ----- F2: a new Wolf-Token enters after W42 is in lane -----------------
	var wolf_c := lane_f1.place_unit(mk_wolf.call(), 4)
	if wolf_c == null:
		printerr("F2: place_unit returned null for new wolf")
		errors += 1
	elif wolf_c.current_attack() != 2 or wolf_c.max_hp() != 3 \
			or not wolf_c.has_keyword(GFEnums.Keyword.LIFESTEAL):
		printerr("F2: new wolf should get aura grant on-enter, got %d/%d LIFESTEAL=%s" %
				[wolf_c.current_attack(), wolf_c.max_hp(),
				str(wolf_c.has_keyword(GFEnums.Keyword.LIFESTEAL))])
		errors += 1

	# ----- F3: W42 dies and is culled — all tokens revert -------------------
	den_mother.current_hp = 0
	lane_f1.cull_dead_units()
	if wolf_a.current_attack() != 1:
		printerr("F3: wolf_a should revert to ATK 1 after W42 cull, got %d" %
				wolf_a.current_attack())
		errors += 1
	if wolf_a.max_hp() != 2:
		printerr("F3: wolf_a should revert to max_hp 2 after W42 cull, got %d" %
				wolf_a.max_hp())
		errors += 1
	if wolf_a.has_keyword(GFEnums.Keyword.LIFESTEAL):
		printerr("F3: wolf_a should NOT have LIFESTEAL after W42 cull")
		errors += 1
	if not wolf_a.aura_stats.is_empty() or not wolf_a.runtime_keywords.is_empty():
		printerr("F3: wolf_a aura state should be empty after revoke (stats=%s kws=%s)" %
				[str(wolf_a.aura_stats), str(wolf_a.runtime_keywords)])
		errors += 1

	# ----- F4: two W42s in lane → stack additively, one dies ----------------
	var lane_f4 := Lane.new(0, 6)
	var w_f4 := lane_f4.place_unit(mk_wolf.call(), 1)
	var dm_1 := lane_f4.place_unit(mk_den_mother.call(), 2)
	var dm_2 := lane_f4.place_unit(mk_den_mother.call(), 3)
	if w_f4 == null or dm_1 == null or dm_2 == null:
		printerr("F4: setup failed")
		return errors + 1
	if w_f4.current_attack() != 3 or w_f4.max_hp() != 4:
		printerr("F4: wolf under double aura expected 3/4, got %d/%d" %
				[w_f4.current_attack(), w_f4.max_hp()])
		errors += 1
	if not w_f4.has_keyword(GFEnums.Keyword.LIFESTEAL):
		printerr("F4: wolf under double aura should have LIFESTEAL (set-union)")
		errors += 1
	# Kill one Den-Mother.
	dm_1.current_hp = 0
	lane_f4.cull_dead_units()
	if w_f4.current_attack() != 2 or w_f4.max_hp() != 3:
		printerr("F4: after one W42 dies expected 2/3, got %d/%d" %
				[w_f4.current_attack(), w_f4.max_hp()])
		errors += 1
	if not w_f4.has_keyword(GFEnums.Keyword.LIFESTEAL):
		printerr("F4: LIFESTEAL should remain from surviving Den-Mother")
		errors += 1

	# ----- F5: full-HP token under double aura — one source dies clamps HP --
	var lane_f5 := Lane.new(0, 6)
	var w_f5 := lane_f5.place_unit(mk_wolf.call(), 1)
	var dm_5a := lane_f5.place_unit(mk_den_mother.call(), 2)
	var dm_5b := lane_f5.place_unit(mk_den_mother.call(), 3)
	if w_f5 == null or dm_5a == null or dm_5b == null:
		printerr("F5: setup failed")
		return errors + 1
	# wolf should be at 4/4 under double aura
	if w_f5.current_hp != 4 or w_f5.max_hp() != 4:
		printerr("F5: pre-revoke wolf expected 4/4, got %d/%d" %
				[w_f5.current_hp, w_f5.max_hp()])
		errors += 1
	dm_5a.current_hp = 0
	lane_f5.cull_dead_units()
	# new max is 3, current_hp must clamp to 3
	if w_f5.current_hp != 3:
		printerr("F5: post-revoke wolf current_hp should clamp to 3, got %d" %
				w_f5.current_hp)
		errors += 1
	if not w_f5.is_alive():
		printerr("F5: wolf should still be alive after aura revoke")
		errors += 1

	# ----- F6: damaged token under double aura — both sources die clamp@1 ---
	var lane_f6 := Lane.new(0, 6)
	var w_f6 := lane_f6.place_unit(mk_wolf.call(), 1)
	var dm_6a := lane_f6.place_unit(mk_den_mother.call(), 2)
	var dm_6b := lane_f6.place_unit(mk_den_mother.call(), 3)
	if w_f6 == null or dm_6a == null or dm_6b == null:
		printerr("F6: setup failed")
		return errors + 1
	# Damage wolf down to 1 HP (took 3 damage from 4 max).
	w_f6.current_hp = 1
	# Kill both Den-Mothers.
	dm_6a.current_hp = 0
	dm_6b.current_hp = 0
	lane_f6.cull_dead_units()
	# Wolf max is back to 2; current_hp clamps but floors at 1 (never killed
	# by revoke). Must remain alive.
	if w_f6.current_hp != 1:
		printerr("F6: wolf at 1HP post-double-revoke should floor at 1, got %d" %
				w_f6.current_hp)
		errors += 1
	if not w_f6.is_alive():
		printerr("F6: wolf must still be alive after double aura revoke (revoke never kills)")
		errors += 1

	return errors


# ============================================================================
# SCENE G — L41 SELF-AURA (keywords/aura_v0.md, L41.E1)
# ============================================================================

func _scene_g_l41_self_aura() -> int:
	var errors: int = 0

	# Helper: build L41 Banner-Bearer card matching dispatch entry.
	var mk_l41 := func() -> Card:
		var c := Card.new()
		c.id = &"L41"
		c.display_name = "Banner-Bearer of the Crowned Anvil"
		c.card_type = GFEnums.CardType.UNIT
		c.cost = 3
		c.hp = 3
		c.attack = 2
		c.attack_range = GFEnums.AttackRange.SHORT
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# Helper: build L34 Crowned Anvil Standard — the v0 banner predicate.
	var mk_l34 := func() -> Card:
		var c := Card.new()
		c.id = &"L34"
		c.display_name = "Crowned Anvil Standard"
		c.card_type = GFEnums.CardType.UNIT
		c.cost = 5
		c.hp = 4
		c.attack = 0
		c.attack_range = GFEnums.AttackRange.NONE
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# ----- G1: L41 alone in lane — no banner — no grant --------------------
	var lane_g := Lane.new(0, 6)
	var l41 := lane_g.place_unit(mk_l41.call(), 1)
	if l41 == null:
		printerr("G1: L41 place_unit returned null")
		return errors + 1
	if l41.current_attack() != 2:
		printerr("G1: L41 should be base ATK=2 with no banner, got %d" %
				l41.current_attack())
		errors += 1
	if l41.has_keyword(GFEnums.Keyword.PIERCE):
		printerr("G1: L41 should NOT have PIERCE without banner")
		errors += 1
	if not l41.aura_stats.is_empty():
		printerr("G1: L41 aura_stats should be empty without banner condition met")
		errors += 1

	# ----- G2: L34 enters → re-evaluate fires → L41 gains buff -------------
	var l34 := lane_g.place_unit(mk_l34.call(), 2)
	if l34 == null:
		printerr("G2: L34 place_unit returned null")
		return errors + 1
	if l41.current_attack() != 3:
		printerr("G2: L41 should gain +1 ATK with banner present, got %d (expected 3)" %
				l41.current_attack())
		errors += 1
	if not l41.has_keyword(GFEnums.Keyword.PIERCE):
		printerr("G2: L41 should have PIERCE with banner present")
		errors += 1
	if not l41.aura_stats.has(l41):
		printerr("G2: L41 self-aura should be stored keyed on self")
		errors += 1

	# ----- G3: L34 dies → re-evaluate revokes → L41 reverts ----------------
	l34.current_hp = 0
	lane_g.cull_dead_units()
	if l41.current_attack() != 2:
		printerr("G3: L41 should revert to base ATK=2 after banner culled, got %d" %
				l41.current_attack())
		errors += 1
	if l41.has_keyword(GFEnums.Keyword.PIERCE):
		printerr("G3: L41 should NOT have PIERCE after banner culled")
		errors += 1
	if l41.aura_stats.has(l41):
		printerr("G3: L41 self-aura should be revoked after banner culled")
		errors += 1

	return errors


# ============================================================================
# SCENE H — W4 Bear-Skin Hierophant dynamic outbound aura (W4.E1)
# ============================================================================

func _scene_h_w4_dynamic_outbound() -> int:
	var errors: int = 0

	# Helper: build a Skinward Pact Wilds card at a given cost.
	var mk_wilds := func(cid: StringName, cost: int) -> Card:
		var c := Card.new()
		c.id = cid
		c.display_name = "TestWilds_%s" % cid
		c.card_type = GFEnums.CardType.UNIT
		c.faction = GFEnums.Faction.SKINWARD_PACT
		c.cost = cost
		c.hp = 3
		c.attack = 2
		c.attack_range = GFEnums.AttackRange.MELEE
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# Helper: build the W4 Bear-Skin Hierophant card.
	var mk_w4 := func() -> Card:
		var c := Card.new()
		c.id = &"W4"
		c.display_name = "Bear-Skin Hierophant"
		c.card_type = GFEnums.CardType.UNIT
		c.faction = GFEnums.Faction.SKINWARD_PACT
		c.cost = 4
		c.hp = 4
		c.attack = 3
		c.attack_range = GFEnums.AttackRange.SHORT
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# ----- H1: W4 alone — no eligible target — no grant -------------------
	var lane := Lane.new(0, 6)
	var w4 := lane.place_unit(mk_w4.call(), 1)
	if w4 == null:
		printerr("H1: W4 place_unit returned null")
		return errors + 1
	# W4 must not have granted to itself (aura_v0.md open-Q1 default).
	if not w4.aura_stats.is_empty():
		printerr("H1: W4 should not self-buff; aura_stats=%s" % str(w4.aura_stats))
		errors += 1

	# ----- H2: a 3-cost Wilds enters — becomes holder ---------------------
	var w_3c := lane.place_unit(mk_wilds.call(&"W_3c", 3), 2)
	if w_3c == null:
		printerr("H2: 3-cost Wilds place_unit returned null")
		return errors + 1
	if w_3c.max_hp() != 5:
		printerr("H2: 3-cost Wilds should be max_hp=5 under W4, got %d" %
				w_3c.max_hp())
		errors += 1
	if not w_3c.has_keyword(GFEnums.Keyword.CLEAVE):
		printerr("H2: 3-cost Wilds should have CLEAVE under W4")
		errors += 1
	if not w_3c.aura_stats.has(w4):
		printerr("H2: 3-cost Wilds aura_stats should be keyed on W4")
		errors += 1

	# ----- H3: a 5-cost Wilds enters — grant shifts -----------------------
	var w_5c := lane.place_unit(mk_wilds.call(&"W_5c", 5), 3)
	if w_5c == null:
		printerr("H3: 5-cost Wilds place_unit returned null")
		return errors + 1
	if not w_5c.has_keyword(GFEnums.Keyword.CLEAVE):
		printerr("H3: 5-cost Wilds should now hold the W4 grant (CLEAVE)")
		errors += 1
	if w_5c.max_hp() != 5:
		printerr("H3: 5-cost Wilds should be max_hp=5 under W4, got %d" %
				w_5c.max_hp())
		errors += 1
	if w_3c.has_keyword(GFEnums.Keyword.CLEAVE):
		printerr("H3: 3-cost Wilds should have LOST CLEAVE when 5c took the buff")
		errors += 1
	if w_3c.max_hp() != 3:
		printerr("H3: 3-cost Wilds should revert to base max_hp=3 after grant shift, got %d" %
				w_3c.max_hp())
		errors += 1

	# ----- H4: tie-break — two 5-cost Wilds, lower tile wins --------------
	var lane2 := Lane.new(0, 6)
	var w4_b := lane2.place_unit(mk_w4.call(), 1)
	var w_5a := lane2.place_unit(mk_wilds.call(&"W_5a", 5), 4)  # higher tile
	var w_5b := lane2.place_unit(mk_wilds.call(&"W_5b", 5), 2)  # lower tile (closer to base)
	if w4_b == null or w_5a == null or w_5b == null:
		printerr("H4: setup failed")
		return errors + 1
	# Both are 5-cost; lower-tile (w_5b at tile 2) wins per the tie-break.
	if not w_5b.has_keyword(GFEnums.Keyword.CLEAVE):
		printerr("H4: tile-2 5-cost should win tie-break and have CLEAVE")
		errors += 1
	if w_5a.has_keyword(GFEnums.Keyword.CLEAVE):
		printerr("H4: tile-4 5-cost should LOSE tie-break and NOT have CLEAVE")
		errors += 1

	# ----- H5: holder dies — grant moves to next-highest ------------------
	# Back to lane 1 (W4 + 3c + 5c). Kill the 5c; the 3c should pick up the grant.
	w_5c.current_hp = 0
	lane.cull_dead_units()
	if not w_3c.has_keyword(GFEnums.Keyword.CLEAVE):
		printerr("H5: 3-cost should regain CLEAVE after 5c holder died")
		errors += 1
	if w_3c.max_hp() != 5:
		printerr("H5: 3-cost should regain max_hp=5 after 5c died, got %d" %
				w_3c.max_hp())
		errors += 1

	return errors


# ============================================================================
# SCENE I — LD3 Banner-Buff spine batch (L30 + L34 dispatch, LD3.E1)
# ============================================================================

func _scene_i_ld3_banner_buff() -> int:
	var errors: int = 0

	# Helper: build L30 Crown-Anvil Veteran (self-aura while banner in lane).
	var mk_l30 := func() -> Card:
		var c := Card.new()
		c.id = &"L30"
		c.display_name = "Crown-Anvil Veteran"
		c.card_type = GFEnums.CardType.UNIT
		c.faction = GFEnums.Faction.LAST_LEGION
		c.cost = 3
		c.hp = 3
		c.attack = 2
		c.attack_range = GFEnums.AttackRange.SHORT
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# Helper: build L34 Crowned Anvil Standard (outbound faction-scoped + banner).
	var mk_l34 := func() -> Card:
		var c := Card.new()
		c.id = &"L34"
		c.display_name = "Crowned Anvil Standard"
		c.card_type = GFEnums.CardType.UNIT
		c.faction = GFEnums.Faction.LAST_LEGION
		c.cost = 5
		c.hp = 8
		c.attack = 0
		c.attack_range = GFEnums.AttackRange.NONE
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# Helper: a generic Legion unit (for L34 grant target).
	var mk_legion := func(cid: StringName, cost: int) -> Card:
		var c := Card.new()
		c.id = cid
		c.display_name = "TestLegion_%s" % cid
		c.card_type = GFEnums.CardType.UNIT
		c.faction = GFEnums.Faction.LAST_LEGION
		c.cost = cost
		c.hp = 3
		c.attack = 2
		c.attack_range = GFEnums.AttackRange.MELEE
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# Helper: a non-Legion friendly (excluded from L34's grant).
	var mk_neutral := func(cid: StringName) -> Card:
		var c := Card.new()
		c.id = cid
		c.display_name = "TestNeutral_%s" % cid
		c.card_type = GFEnums.CardType.UNIT
		c.faction = GFEnums.Faction.NEUTRAL
		c.cost = 2
		c.hp = 3
		c.attack = 2
		c.attack_range = GFEnums.AttackRange.MELEE
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# ----- I1: L30 alone (no banner) → no grant. L34 enters → L30 base+2 ATK --
	var lane := Lane.new(0, 6)
	var l30 := lane.place_unit(mk_l30.call(), 1)
	if l30 == null:
		printerr("I1: L30 place_unit returned null")
		return errors + 1
	if l30.current_attack() != 2:
		printerr("I1: L30 should be base ATK=2 without banner, got %d" %
				l30.current_attack())
		errors += 1
	var l34 := lane.place_unit(mk_l34.call(), 5)
	if l34 == null:
		printerr("I1: L34 place_unit returned null")
		return errors + 1
	# L30 should now have: base 2 + self-aura +1 (banner present) + L34's
	# outbound +1 = 4 total ATK.
	if l30.current_attack() != 4:
		printerr("I1: L30 should be ATK=4 (base 2 + self-aura 1 + L34 outbound 1) — got %d" %
				l30.current_attack())
		errors += 1
	# L34 itself doesn't self-grant (outbound aura excludes source).
	if not l34.aura_stats.is_empty():
		printerr("I1: L34 should NOT self-grant; aura_stats=%s" % str(l34.aura_stats))
		errors += 1

	# ----- I2: L34 grants to multiple Legion, skips non-Legion ---------------
	var lane2 := Lane.new(0, 6)
	var legion_a := lane2.place_unit(mk_legion.call(&"L_a", 2), 1)
	var legion_b := lane2.place_unit(mk_legion.call(&"L_b", 4), 2)
	var neutral := lane2.place_unit(mk_neutral.call(&"N_1"), 3)
	var l34_b := lane2.place_unit(mk_l34.call(), 5)
	if legion_a == null or legion_b == null or neutral == null or l34_b == null:
		printerr("I2: setup failed")
		return errors + 1
	# Both Legion units gain +1 ATK; neutral unaffected.
	if legion_a.current_attack() != 3:
		printerr("I2: legion_a expected ATK=3 (base 2 + L34 1), got %d" %
				legion_a.current_attack())
		errors += 1
	if legion_b.current_attack() != 3:
		printerr("I2: legion_b expected ATK=3 (base 2 + L34 1), got %d" %
				legion_b.current_attack())
		errors += 1
	if neutral.current_attack() != 2:
		printerr("I2: neutral should be unaffected by L34's faction-scoped grant; expected ATK=2, got %d" %
				neutral.current_attack())
		errors += 1

	# ----- I3: L34 dies → L30 reverts + Legion lose +1 outbound grant -------
	# Back to lane (lane1) — L30 at tile 1, L34 at tile 5, L30 currently at ATK=4.
	l34.current_hp = 0
	lane.cull_dead_units()
	if l30.current_attack() != 2:
		printerr("I3: L30 should revert to base ATK=2 after L34 dies (banner lost, outbound gone), got %d" %
				l30.current_attack())
		errors += 1
	# Also test lane2's Legion units lose the outbound grant.
	l34_b.current_hp = 0
	lane2.cull_dead_units()
	if legion_a.current_attack() != 2:
		printerr("I3: legion_a should revert to base ATK=2 after L34_b dies, got %d" %
				legion_a.current_attack())
		errors += 1
	if legion_b.current_attack() != 2:
		printerr("I3: legion_b should revert to base ATK=2 after L34_b dies, got %d" %
				legion_b.current_attack())
		errors += 1

	return errors


# ============================================================================
# SCENE J — M41 Wraith-Caller cost-discount trigger (M41.E1)
# ============================================================================
#
# Drives the GameState API directly (arm_mourner_discount / compute_play_cost
# / consume_mourner_discount) to keep the test headless. The combat.gd
# lane.unit_killed subscriber that calls arm_mourner_discount is exercised
# in combat_test.gd's integration tests.

func _scene_j_m41_cost_discount() -> int:
	var errors: int = 0

	# Helper: build a card with a given faction + cost.
	var mk_card := func(cid: StringName, faction_int: int, cost: int) -> Card:
		var c := Card.new()
		c.id = cid
		c.display_name = "TestCard_%s" % cid
		c.card_type = GFEnums.CardType.UNIT
		c.faction = faction_int
		c.cost = cost
		c.hp = 3
		c.attack = 2
		c.attack_range = GFEnums.AttackRange.MELEE
		c.cooldown = 1
		c.is_draftable = true
		c.keywords = []
		return c

	# Reset GameState flags to a clean slate (test ordering safety).
	GameState.mourner_discount_armed = false
	GameState._mourner_discount_fired_this_turn = false

	var mourner_card: Card = mk_card.call(&"M_test", GFEnums.Faction.ASH_MOURNERS, 3)
	var legion_card: Card = mk_card.call(&"L_test", GFEnums.Faction.LAST_LEGION, 3)

	# ----- J1: flag clear → compute_play_cost returns base ------------------
	var j1_cost := GameState.compute_play_cost(mourner_card)
	if j1_cost != 3:
		printerr("J1: expected base cost 3 with flag clear, got %d" % j1_cost)
		errors += 1

	# ----- J2: arm → Mourner discounted, non-Mourner full -------------------
	GameState.arm_mourner_discount()
	var j2_mourner := GameState.compute_play_cost(mourner_card)
	if j2_mourner != 2:
		printerr("J2: armed Mourner should cost 2, got %d" % j2_mourner)
		errors += 1
	var j2_legion := GameState.compute_play_cost(legion_card)
	if j2_legion != 3:
		printerr("J2: armed Legion (non-Mourner) should cost 3, got %d" % j2_legion)
		errors += 1

	# ----- J3: consume → next Mourner pays full (once/turn cap) ------------
	GameState.consume_mourner_discount()
	var j3_cost := GameState.compute_play_cost(mourner_card)
	if j3_cost != 3:
		printerr("J3: post-consume Mourner should cost 3 (cap held), got %d" % j3_cost)
		errors += 1

	# ----- J4: arm again same turn → no-op (fired-this-turn lock) ----------
	GameState.arm_mourner_discount()
	if GameState.mourner_discount_armed:
		printerr("J4: arm same turn after fire should be no-op; armed flag should stay false")
		errors += 1
	var j4_cost := GameState.compute_play_cost(mourner_card)
	if j4_cost != 3:
		printerr("J4: Mourner should still cost 3 after re-arm attempt, got %d" % j4_cost)
		errors += 1

	# Reset for any downstream test isolation.
	GameState.mourner_discount_armed = false
	GameState._mourner_discount_fired_this_turn = false

	return errors


# ============================================================================
# SCENE K — W41 Pack-Caller Wolf-Token draw trigger (W41.E1)
# ============================================================================

func _scene_k_w41_wolf_summon_draw() -> int:
	var errors: int = 0

	# Build a synthetic deck with 2 cards + an empty hand + empty discard so
	# we can drive try_trigger_wolf_summon_draw without the full Combat path.
	var deck := Deck.new()
	var hand := Hand.new()
	var discard := Discard.new()
	var c1 := Card.new()
	c1.id = &"K_filler1"
	c1.display_name = "Filler 1"
	c1.card_type = GFEnums.CardType.UNIT
	c1.cost = 1
	c1.hp = 1
	c1.attack = 1
	c1.attack_range = GFEnums.AttackRange.MELEE
	c1.cooldown = 1
	deck.add_to_top(c1)
	var c2 := Card.new()
	c2.id = &"K_filler2"
	c2.display_name = "Filler 2"
	c2.card_type = GFEnums.CardType.UNIT
	c2.cost = 1
	c2.hp = 1
	c2.attack = 1
	c2.attack_range = GFEnums.AttackRange.MELEE
	c2.cooldown = 1
	deck.add_to_top(c2)

	# Plug into GameState (the helpers read from it).
	var saved_deck = GameState.deck
	var saved_hand = GameState.hand
	var saved_discard = GameState.discard
	var saved_fired: bool = GameState._wolf_summon_draw_fired_this_turn
	GameState.deck = deck
	GameState.hand = hand
	GameState.discard = discard
	GameState._wolf_summon_draw_fired_this_turn = false

	# ----- K1: first try with deck non-empty → fires, hand+1 ----------------
	var k1_fired: bool = GameState.try_trigger_wolf_summon_draw()
	if not k1_fired:
		printerr("K1: first try_trigger should fire, returned false")
		errors += 1
	if hand.size() != 1:
		printerr("K1: hand should grow to 1 after fire, got %d" % hand.size())
		errors += 1
	if not GameState._wolf_summon_draw_fired_this_turn:
		printerr("K1: fired-flag should be set after first fire")
		errors += 1

	# ----- K2: second try same turn → blocked by cap ------------------------
	var k2_fired: bool = GameState.try_trigger_wolf_summon_draw()
	if k2_fired:
		printerr("K2: second try_trigger same turn should return false (cap)")
		errors += 1
	if hand.size() != 1:
		printerr("K2: hand should stay at 1 (no extra draw), got %d" % hand.size())
		errors += 1

	# ----- K3: empty deck+discard → failed attempt doesn't burn window ------
	GameState._wolf_summon_draw_fired_this_turn = false
	while deck.size() > 0:
		deck.draw_one(discard)
	discard.clear_all()
	var k3_fired: bool = GameState.try_trigger_wolf_summon_draw()
	if k3_fired:
		printerr("K3: empty deck+discard should not fire (no card available)")
		errors += 1
	if GameState._wolf_summon_draw_fired_this_turn:
		printerr("K3: failed attempt should NOT burn the per-turn window (fired-flag stays false)")
		errors += 1

	# Restore prior state.
	GameState.deck = saved_deck
	GameState.hand = saved_hand
	GameState.discard = saved_discard
	GameState._wolf_summon_draw_fired_this_turn = saved_fired

	return errors
