extends Node
## DB-1 test — CardDatabase autoload scans the pool and its accessors behave.
##
## Asserts:
##   - the boot scan indexed the expected pool (>= 200; we author ~207)
##   - all 5 playable factions present with non-zero counts
##   - get_by_id round-trips a real card; unknown id returns null
##   - draftable_for excludes non-draftables (tokens/relics) + stays on-faction,
##     sorted by cost
##   - resolve_deck deep-copies (distinct instance, same id), handles repeats,
##     and skips unknown ids
##
## Wired into main.gd after game_state_test.


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[card_database_test] PASS")
	else:
		printerr("[card_database_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors: int = 0

	# ---- Pool scanned ------------------------------------------------------
	var all := CardDatabase.all_cards()
	if all.size() < 200:
		errors += 1; printerr("expected >= 200 cards indexed, got %d" % all.size())

	# ---- All 5 playable factions present with cards -----------------------
	var counts := CardDatabase.counts_by_faction()
	for fac in [GFEnums.Faction.IRON_PENITENTS, GFEnums.Faction.ASH_MOURNERS,
			GFEnums.Faction.COVEN, GFEnums.Faction.LAST_LEGION, GFEnums.Faction.SKINWARD_PACT]:
		if int(counts.get(fac, 0)) <= 0:
			errors += 1; printerr("faction %s has no cards" % GFEnums.Faction.keys()[fac])

	# ---- get_by_id round-trip + unknown id --------------------------------
	var sample: Card = all[0] if not all.is_empty() else null
	if sample != null:
		var fetched := CardDatabase.get_by_id(sample.id)
		if fetched == null or fetched.id != sample.id:
			errors += 1; printerr("get_by_id failed to round-trip %s" % sample.id)
	if CardDatabase.get_by_id(&"__no_such_card__") != null:
		errors += 1; printerr("get_by_id returned non-null for an unknown id")

	# ---- draftable_for excludes non-draftables, stays on-faction, sorted ---
	var draftable := CardDatabase.draftable_for(
			[GFEnums.Faction.IRON_PENITENTS, GFEnums.Faction.NEUTRAL])
	if draftable.is_empty():
		errors += 1; printerr("draftable_for(Iron+Neutral) returned empty")
	for c in draftable:
		if not c.is_draftable:
			errors += 1; printerr("draftable_for leaked a non-draftable card: %s" % c.id)
			break
		if c.faction != GFEnums.Faction.IRON_PENITENTS and c.faction != GFEnums.Faction.NEUTRAL:
			errors += 1; printerr("draftable_for leaked an off-faction card: %s" % c.id)
			break
	for i in range(1, draftable.size()):
		if draftable[i].cost < draftable[i - 1].cost:
			errors += 1; printerr("draftable_for not sorted by cost at index %d" % i)
			break

	# ---- resolve_deck deep-copies + handles repeats + skips unknowns -------
	if sample != null:
		var resolved := CardDatabase.resolve_deck([sample.id, sample.id])
		if resolved.size() != 2:
			errors += 1; printerr("resolve_deck([id,id]) size %d, expected 2" % resolved.size())
		elif resolved[0].get_instance_id() == sample.get_instance_id():
			errors += 1; printerr("resolve_deck returned the catalog instance, not a copy")
		elif resolved[0].id != sample.id:
			errors += 1; printerr("resolve_deck copy lost its id")
	if CardDatabase.resolve_deck([&"__nope__"]).size() != 0:
		errors += 1; printerr("resolve_deck kept an unknown id")

	return errors
