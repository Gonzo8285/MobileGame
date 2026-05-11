extends Node

## Smoke test for the Warlord XP + tier system (B2.7/W5).
##
## Exercises:
##   - tier_for_xp() boundary math against warlord_tiers_v0.md §2.2 thresholds
##   - get_effective_xp_multiplier() stacking + cap clamp at 3.0
##   - gain_warlord_xp() awards, signal emission, tier-cross detection
##   - set/clear/consume of multiplier sources
##   - One-shot mark_one_shot_for_consume → self-unregister flow
##   - Anti-pay-to-win invariants (rejects zero/negative base XP)
##   - TierContent.validate() + Warlord.validate() shape checks
##
## All expected values Python-verified before commit (see W5 heartbeat notes
## in research_notes.md for the verification log). PASS = 0 errors.

func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[warlord_test] PASS")
	else:
		printerr("[warlord_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors := 0

	# Reset GameState's XP machinery so this test is independent of any prior
	# test runs in the same launch. game_state_test runs first and leaves
	# GAME_OVER phase + drained run state, but warlord_xp / sources are
	# defaults-only at startup so we just clear them defensively.
	GameState.warlord_xp.clear()
	GameState.xp_multiplier_sources.clear()
	GameState._xp_pending_consume.clear()

	# Wire signal log so we can assert what fired.
	var signal_log: Array[String] = []
	var log_xp := func(wid: StringName, amt: int, mult: float):
		signal_log.append("xp_gained:%s:%d:%.4f" % [wid, amt, mult])
	var log_tier := func(wid: StringName, tier: int):
		signal_log.append("tier_changed:%s:%d" % [wid, tier])
	var log_mult := func(sid: StringName, val: float):
		signal_log.append("mult_changed:%s:%.4f" % [sid, val])
	var log_consume := func(sid: StringName):
		signal_log.append("mult_consumed:%s" % sid)
	GameState.warlord_xp_gained.connect(log_xp)
	GameState.warlord_tier_changed.connect(log_tier)
	GameState.xp_multiplier_changed.connect(log_mult)
	GameState.xp_multiplier_consumed.connect(log_consume)

	# ---- Tier-threshold boundary math (W1 §2.2) ------------------------
	errors += _expect_eq("tier_for_xp(0)", GameState._tier_for_xp(0), 1)
	errors += _expect_eq("tier_for_xp(1799)", GameState._tier_for_xp(1799), 1)
	errors += _expect_eq("tier_for_xp(1800)", GameState._tier_for_xp(1800), 2)
	errors += _expect_eq("tier_for_xp(4799)", GameState._tier_for_xp(4799), 2)
	errors += _expect_eq("tier_for_xp(4800)", GameState._tier_for_xp(4800), 3)
	errors += _expect_eq("tier_for_xp(10800)", GameState._tier_for_xp(10800), 4)
	errors += _expect_eq("tier_for_xp(99999)", GameState._tier_for_xp(99999), 4)

	# ---- Empty multiplier registry ------------------------------------
	errors += _expect_eq("effective_mult empty", GameState.get_effective_xp_multiplier(), 1.0)
	errors += _expect_eq("vyrrun tier @ 0 xp", GameState.get_warlord_tier(&"vyrrun"), 1)
	errors += _expect_eq("vyrrun xp @ start", GameState.get_warlord_xp(&"vyrrun"), 0)
	errors += _expect_eq("xp_to_next @ 0", GameState.get_xp_to_next_tier(&"vyrrun"), 1800)

	# ---- gain_warlord_xp w/ no multiplier ------------------------------
	GameState.gain_warlord_xp(&"vyrrun", 100)
	errors += _expect_eq("xp after gain(100)", GameState.get_warlord_xp(&"vyrrun"), 100)
	errors += _expect_eq("still T1 after gain(100)", GameState.get_warlord_tier(&"vyrrun"), 1)

	# ---- Single source 1.25 (BP premium) ------------------------------
	GameState.set_xp_multiplier_source(&"battle_pass_premium", 1.25)
	errors += _expect_eq("mult after BP+25%", GameState.get_effective_xp_multiplier(), 1.25)
	GameState.gain_warlord_xp(&"vyrrun", 100)
	errors += _expect_eq("xp after BP gain(100)", GameState.get_warlord_xp(&"vyrrun"), 100 + 125)

	# ---- Stack BP + starter (1.25 × 1.5 = 1.875) ----------------------
	GameState.set_xp_multiplier_source(&"starter_bundle", 1.5)
	errors += _expect_eq("mult stacked 1.875",
			GameState.get_effective_xp_multiplier(), 1.875)
	# 100 * 1.875 = 187.5 → 188 (half-away-from-zero, matches GDScript round())
	var before_stack: int = GameState.get_warlord_xp(&"vyrrun")
	GameState.gain_warlord_xp(&"vyrrun", 100)
	errors += _expect_eq("awarded with 1.875 stack",
			GameState.get_warlord_xp(&"vyrrun") - before_stack, 188)

	# ---- Stack overflow clamp at 3.0 ----------------------------------
	GameState.set_xp_multiplier_source(&"event_weekend", 2.0)
	GameState.set_xp_multiplier_source(&"daily_quest_vyrrun", 1.5)
	GameState.set_xp_multiplier_source(&"equipped_skin_vyrrun", 1.05)
	# Raw product = 1.25 * 1.5 * 2.0 * 1.5 * 1.05 = 5.90625 — must clamp to 3.0.
	errors += _expect_eq("mult clamps to 3.0",
			GameState.get_effective_xp_multiplier(), 3.0)
	var before_clamp: int = GameState.get_warlord_xp(&"vyrrun")
	GameState.gain_warlord_xp(&"vyrrun", 100)
	errors += _expect_eq("awarded with cap",
			GameState.get_warlord_xp(&"vyrrun") - before_clamp, 300)

	# ---- Clear one source, multiplier recomputes ----------------------
	GameState.clear_xp_multiplier_source(&"event_weekend")
	# Remaining: 1.25 * 1.5 * 1.5 * 1.05 = 2.9531... — uncapped now.
	var recomputed: float = GameState.get_effective_xp_multiplier()
	errors += _expect_within("mult after clear event",
			recomputed, 2.9531, 0.001)

	# Clear all sources for the rest of the suite
	for sid in GameState.xp_multiplier_sources.keys().duplicate():
		GameState.clear_xp_multiplier_source(sid)
	errors += _expect_eq("mult empty after clear-all",
			GameState.get_effective_xp_multiplier(), 1.0)

	# ---- One-shot consume flow ----------------------------------------
	# Register a single 2.0 daily-quest source, mark it one-shot, gain XP.
	# The source should be active for THIS gain, then unregister.
	GameState.warlord_xp.clear()  # reset Vyrrun's XP for clean assertions
	GameState.set_xp_multiplier_source(&"daily_quest_vyrrun", 2.0)
	GameState.mark_one_shot_for_consume(&"daily_quest_vyrrun")
	errors += _expect_eq("source present pre-gain",
			GameState.xp_multiplier_sources.has(&"daily_quest_vyrrun"), true)

	var consume_log_size_before: int = signal_log.size()
	GameState.gain_warlord_xp(&"vyrrun", 100)
	errors += _expect_eq("awarded under one-shot 2.0",
			GameState.get_warlord_xp(&"vyrrun"), 200)
	errors += _expect_eq("source gone after one-shot",
			GameState.xp_multiplier_sources.has(&"daily_quest_vyrrun"), false)
	errors += _expect_eq("mult back to 1.0",
			GameState.get_effective_xp_multiplier(), 1.0)
	# Verify xp_multiplier_consumed fired.
	var found_consume: bool = false
	for i in range(consume_log_size_before, signal_log.size()):
		if signal_log[i].begins_with("mult_consumed:daily_quest_vyrrun"):
			found_consume = true
			break
	errors += _expect_eq("consumed signal fired", found_consume, true)

	# ---- Tier-cross detection -----------------------------------------
	GameState.warlord_xp.clear()
	# gain(1799) leaves Vyrrun at T1; gain(1) more crosses to T2.
	GameState.gain_warlord_xp(&"vyrrun", 1799)
	errors += _expect_eq("Vyrrun T1 @ 1799", GameState.get_warlord_tier(&"vyrrun"), 1)
	var tier_log_before: int = signal_log.size()
	GameState.gain_warlord_xp(&"vyrrun", 1)
	errors += _expect_eq("Vyrrun T2 @ 1800", GameState.get_warlord_tier(&"vyrrun"), 2)
	# Verify exactly ONE tier_changed fired in the +1 gain
	var tier_signals: int = 0
	for i in range(tier_log_before, signal_log.size()):
		if signal_log[i].begins_with("tier_changed:vyrrun"):
			tier_signals += 1
	errors += _expect_eq("tier_changed fired once on cross", tier_signals, 1)

	# ---- Skip-tier (T1 → T4 in one massive gain) ----------------------
	# Verifies tier_changed fires with the final tier, not intermediate ones.
	# (e.g. a debug-grant of 10,800 XP from T1 emits a single
	# tier_changed(:4), not three signals.)
	GameState.warlord_xp.clear()
	var skip_log_before: int = signal_log.size()
	GameState.gain_warlord_xp(&"sieren", 10800)
	errors += _expect_eq("Sieren T4 after gain(10800)",
			GameState.get_warlord_tier(&"sieren"), 4)
	var sieren_tier_signals: int = 0
	var sieren_final_tier: int = 0
	for i in range(skip_log_before, signal_log.size()):
		if signal_log[i].begins_with("tier_changed:sieren"):
			sieren_tier_signals += 1
			# Parse "tier_changed:sieren:N"
			var parts: Array = signal_log[i].split(":")
			if parts.size() >= 3:
				sieren_final_tier = int(parts[2])
	errors += _expect_eq("Sieren one tier_changed on skip", sieren_tier_signals, 1)
	errors += _expect_eq("Sieren tier_changed payload = 4", sieren_final_tier, 4)

	# ---- get_xp_to_next_tier at all bands -----------------------------
	GameState.warlord_xp.clear()
	errors += _expect_eq("next-tier @ 0", GameState.get_xp_to_next_tier(&"vyrrun"), 1800)
	GameState.warlord_xp[&"vyrrun"] = 1800
	errors += _expect_eq("next-tier @ 1800", GameState.get_xp_to_next_tier(&"vyrrun"), 3000)
	GameState.warlord_xp[&"vyrrun"] = 4800
	errors += _expect_eq("next-tier @ 4800", GameState.get_xp_to_next_tier(&"vyrrun"), 6000)
	GameState.warlord_xp[&"vyrrun"] = 10800
	errors += _expect_eq("next-tier @ T4", GameState.get_xp_to_next_tier(&"vyrrun"), 0)

	# ---- Anti-P2W: reject zero/negative XP grants ---------------------
	GameState.warlord_xp.clear()
	GameState.gain_warlord_xp(&"vyrrun", 0)
	errors += _expect_eq("gain(0) is no-op", GameState.get_warlord_xp(&"vyrrun"), 0)
	GameState.gain_warlord_xp(&"vyrrun", -100)
	errors += _expect_eq("gain(-100) is no-op", GameState.get_warlord_xp(&"vyrrun"), 0)
	GameState.gain_warlord_xp(&"", 100)
	errors += _expect_eq("gain(empty id) is no-op",
			GameState.warlord_xp.has(&""), false)

	# ---- TierContent.validate() shape checks --------------------------
	var t1: Resource = load("res://src/data/tier_content.gd").new()
	t1.tier = 1
	errors += _expect_eq("T1 empty validates", t1.validate().size(), 0)

	var t1_bad: Resource = load("res://src/data/tier_content.gd").new()
	t1_bad.tier = 1
	t1_bad.variant_passives = [&"flagellant_rite", &"ash_vow"]
	errors += _expect_eq("T1 with variants fails", t1_bad.validate().size() > 0, true)

	var t2: Resource = load("res://src/data/tier_content.gd").new()
	t2.tier = 2
	t2.variant_passives = [&"flagellant_rite", &"ash_vow"]
	errors += _expect_eq("T2 with 2 variants validates", t2.validate().size(), 0)

	var t3: Resource = load("res://src/data/tier_content.gd").new()
	t3.tier = 3
	t3.variant_passives = [&"flagellant_rite", &"ash_vow"]
	# alt_fire_spell missing → should fail
	errors += _expect_eq("T3 without alt_fire fails", t3.validate().size() > 0, true)

	# ---- Warlord.validate() shape checks ------------------------------
	var w_ok: Resource = load("res://src/data/warlord.gd").new()
	w_ok.id = &"vyrrun"
	w_ok.display_name = "Penance-Captain Vyrrun"
	w_ok.faction = GFEnums.Faction.IRON_PENITENTS
	w_ok.is_free = true
	errors += _expect_eq("Warlord free-no-tiers validates",
			w_ok.validate().size(), 0)

	var w_paid_no_path: Resource = load("res://src/data/warlord.gd").new()
	w_paid_no_path.id = &"whelp"
	w_paid_no_path.display_name = "Whelp of the Pyre"
	w_paid_no_path.is_free = false
	# Missing both costs and unlock_tag → should fail
	errors += _expect_eq("Paid w/o unlock path fails",
			w_paid_no_path.validate().size() > 0, true)

	print("Warlord-test signals: %d total" % signal_log.size())
	return errors


# ---------- helpers ---------------------------------------------------------

func _expect_eq(label: String, actual, expected) -> int:
	if actual == expected:
		return 0
	printerr("FAIL %s — expected %s got %s" % [label, expected, actual])
	return 1


func _expect_within(label: String, actual: float, expected: float, tolerance: float) -> int:
	if absf(actual - expected) <= tolerance:
		return 0
	printerr("FAIL %s — expected %.4f (±%.4f) got %.4f" %
			[label, expected, tolerance, actual])
	return 1
