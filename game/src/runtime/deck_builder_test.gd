extends Node
## DB-6 — deck-builder model logic (headless).
##
## Instantiates DeckBuilder (its UI builds invisibly headless) and exercises the
## deck MODEL through its public-ish surface:
##   - pool is faction-locked (active + NEUTRAL) and draftable-only (no tokens/relics)
##   - singleton enforced (MAX_COPIES = 1)
##   - deck size capped at DECK_SIZE (20); a 21st add is refused
##   - auto-fill produces a legal 20-card singleton deck; clear empties
##   - _deck_ids() round-trips through CardDatabase.resolve_deck
##   - _on_start wires GameState (deck of 20 + last_deck_ids of 20)
##
## Wired into main.gd after card_database_test. PASS = 0 errors.


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[deck_builder_test] PASS")
	else:
		printerr("[deck_builder_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors := 0

	var db := DeckBuilder.new()
	db.setup(&"vyrrun", GFEnums.Faction.IRON_PENITENTS)
	add_child(db)  # triggers _ready -> populates _available + builds UI (headless OK)

	# ---- Pool: faction-locked + draftable-only ----------------------------
	if db._available.is_empty():
		errors += 1; printerr("available pool empty")
	for c in db._available:
		if not c.is_draftable:
			errors += 1; printerr("pool leaked non-draftable %s" % c.id); break
		if c.faction != GFEnums.Faction.IRON_PENITENTS and c.faction != GFEnums.Faction.NEUTRAL:
			errors += 1; printerr("pool leaked off-faction %s" % c.id); break

	if db._available.size() < DeckBuilder.DECK_SIZE:
		printerr("FATAL: pool too small (%d) to test deck rules" % db._available.size())
		db.queue_free()
		return errors + 1

	# ---- Singleton enforcement -------------------------------------------
	var card: Card = db._available[0]
	db._add(card)
	db._add(card)  # second copy must be refused
	if int(db._deck.get(card.id, 0)) != 1:
		errors += 1
		printerr("singleton not enforced: count=%d" % int(db._deck.get(card.id, 0)))

	# ---- Size cap (no 21st card) -----------------------------------------
	db._clear()
	if db._deck_count() != 0:
		errors += 1; printerr("clear did not empty the deck")
	var i := 0
	while db._deck_count() < DeckBuilder.DECK_SIZE and i < db._available.size():
		db._add(db._available[i])
		i += 1
	if db._deck_count() != DeckBuilder.DECK_SIZE:
		errors += 1; printerr("could not reach 20, got %d" % db._deck_count())
	if i < db._available.size():
		db._add(db._available[i])  # 21st add must be refused
		if db._deck_count() != DeckBuilder.DECK_SIZE:
			errors += 1; printerr("size cap exceeded: %d" % db._deck_count())

	# ---- Auto-fill produces a legal 20-card singleton deck ----------------
	db._autofill()
	if db._deck_count() != DeckBuilder.DECK_SIZE:
		errors += 1; printerr("auto-fill produced %d, expected 20" % db._deck_count())
	for id in db._deck:
		if int(db._deck[id]) > DeckBuilder.MAX_COPIES:
			errors += 1; printerr("auto-fill broke singleton on %s" % id); break

	# ---- _deck_ids round-trips through CardDatabase -----------------------
	var ids := db._deck_ids()
	if ids.size() != db._deck_count():
		errors += 1; printerr("_deck_ids size %d != deck_count %d" % [ids.size(), db._deck_count()])
	var resolved := CardDatabase.resolve_deck(ids)
	if resolved.size() != ids.size():
		errors += 1
		printerr("resolve_deck round-trip lost cards: %d -> %d" % [ids.size(), resolved.size()])

	# ---- _on_start wires GameState ---------------------------------------
	db._on_start()
	var deck_size: int = 0 if GameState.deck == null else GameState.deck.size()
	if deck_size != DeckBuilder.DECK_SIZE:
		errors += 1; printerr("_on_start: GameState.deck size %d, expected 20" % deck_size)
	if GameState.last_deck_ids.size() != DeckBuilder.DECK_SIZE:
		errors += 1
		printerr("_on_start: last_deck_ids size %d, expected 20" % GameState.last_deck_ids.size())

	db.queue_free()
	return errors
