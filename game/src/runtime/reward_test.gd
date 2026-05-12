extends Node

## Smoke test for B2.8 — RewardGenerator + RewardOffer + GameState.start_reward.
##
## Covers:
##   - load_pool returns a non-empty pool from res://data/cards/
##   - generate() returns exactly 3 distinct cards from a healthy pool
##   - all returned cards are draftable AND have rarity in {COMMON, UNCOMMON, RARE}
##     (EPIC/LEGENDARY must be filtered out by weight)
##   - same seed → same offer (determinism contract)
##   - faction-bias materially shifts the distribution: over 200 rolls with
##     IRON_PENITENTS bias, ≥40% of *picked* cards are Penitents (with the 4×
##     weight + ~1/3 of the pool being Penitents, the expected share is ~70%
##     — the 40% floor is a deliberately loose envelope to absorb run-to-run
##     RNG variance in CI)
##   - tiny pool fallback — count=3 against a 2-card pool returns 2 cards,
##     no crash
##   - RewardOffer.choose() emits resolved once with the right card
##   - RewardOffer.skip() emits resolved(null) once
##   - double-choose/skip is a no-op (idempotency invariant)
##   - GameState.start_reward → choose() → deck grows by exactly 1
##   - GameState.start_reward → skip() → deck size unchanged
##   - Pool with EPIC/LEGENDARY-only cards yields an empty offer (excluded by
##     weight, not by an explicit filter — proves the weight contract holds)
##
## All assertions PASS = 0 errors. Wired into main.gd alongside the other
## dev tests (after warlord_test).

const POOL_ROOTS: Array = [
	"res://data/cards/",
	"res://data/cards/iron_penitents/",
	"res://data/cards/ash_mourners/",
	"res://data/cards/coven/",
]


func _ready() -> void:
	var rc := _run()
	if rc == 0:
		print("[reward_test] PASS")
	else:
		printerr("[reward_test] FAIL — %d errors" % rc)


func _run() -> int:
	var errors: int = 0

	# ---- pool load ---------------------------------------------------------
	var pool: Array[Card] = RewardGenerator.load_pool(POOL_ROOTS)
	if pool.is_empty():
		printerr("FATAL: load_pool returned empty — check res://data/cards/")
		return 1
	if pool.size() < 10:
		printerr("WARN: pool only has %d cards — distribution tests will be flaky" % pool.size())

	# ---- generate returns 3 distinct draftable non-EPIC/LEGENDARY cards -----
	var rng_a := RandomNumberGenerator.new()
	rng_a.seed = 12345
	var offer_a: Array[Card] = RewardGenerator.generate(pool, GFEnums.Faction.IRON_PENITENTS, rng_a, 3)
	if offer_a.size() != 3:
		errors += 1
		printerr("expected 3 cards, got %d" % offer_a.size())
	var ids: Dictionary = {}
	for c in offer_a:
		if not c.is_draftable:
			errors += 1; printerr("offer contained non-draftable card %s" % c.id)
		if c.rarity == GFEnums.Rarity.EPIC or c.rarity == GFEnums.Rarity.LEGENDARY:
			errors += 1; printerr("offer contained excluded-rarity card %s" % c.id)
		if ids.has(c.id):
			errors += 1; printerr("offer contained duplicate id %s" % c.id)
		ids[c.id] = true

	# ---- determinism: same seed → same offer ------------------------------
	var rng_b := RandomNumberGenerator.new()
	rng_b.seed = 12345
	var offer_b: Array[Card] = RewardGenerator.generate(pool, GFEnums.Faction.IRON_PENITENTS, rng_b, 3)
	if offer_b.size() != offer_a.size():
		errors += 1; printerr("determinism: size mismatch")
	else:
		for i in range(offer_a.size()):
			if offer_a[i].id != offer_b[i].id:
				errors += 1
				printerr("determinism: seed 12345 produced %s vs %s at index %d" %
					[offer_a[i].id, offer_b[i].id, i])

	# ---- faction-bias distribution ----------------------------------------
	var rng_dist := RandomNumberGenerator.new()
	rng_dist.seed = 99
	var penitent_hits: int = 0
	var total_picks: int = 0
	for _i in range(200):
		var roll: Array[Card] = RewardGenerator.generate(pool, GFEnums.Faction.IRON_PENITENTS, rng_dist, 3)
		for c in roll:
			total_picks += 1
			if c.faction == GFEnums.Faction.IRON_PENITENTS:
				penitent_hits += 1
	var share: float = float(penitent_hits) / float(max(1, total_picks))
	if share < 0.40:
		errors += 1
		printerr("faction-bias too weak: Penitents share %.2f (expected ≥0.40 with 4× weight)" % share)

	# ---- tiny pool fallback ------------------------------------------------
	var tiny_pool: Array[Card] = [pool[0], pool[1]]
	var tiny_rng := RandomNumberGenerator.new()
	tiny_rng.seed = 1
	var tiny_offer: Array[Card] = RewardGenerator.generate(tiny_pool, GFEnums.Faction.NEUTRAL, tiny_rng, 3)
	if tiny_offer.size() != 2:
		errors += 1; printerr("tiny pool: expected 2, got %d" % tiny_offer.size())

	# ---- empty pool / excluded-rarity-only pool ---------------------------
	# Build a synthetic pool of one LEGENDARY card; expect zero picks.
	var legendary_only: Array[Card] = []
	var legendary: Card = Card.new()
	legendary.id = &"X1_FAKE_LEGENDARY"
	legendary.display_name = "Fake Legendary"
	legendary.faction = GFEnums.Faction.NEUTRAL
	legendary.card_type = GFEnums.CardType.UNIT
	legendary.rarity = GFEnums.Rarity.LEGENDARY
	legendary.hp = 1
	legendary.attack = 1
	legendary.is_draftable = true
	legendary_only.append(legendary)
	var leg_rng := RandomNumberGenerator.new()
	leg_rng.seed = 7
	var leg_offer: Array[Card] = RewardGenerator.generate(legendary_only, GFEnums.Faction.NEUTRAL, leg_rng, 3)
	if leg_offer.size() != 0:
		errors += 1; printerr("LEGENDARY-only pool: expected 0 cards, got %d" % leg_offer.size())

	# ---- RewardOffer.choose / skip semantics ------------------------------
	var pick_offer := RewardOffer.new(offer_a)
	var caught_card: Array = [null]
	var fire_count: Array = [0]
	pick_offer.resolved.connect(func(c: Card) -> void:
		caught_card[0] = c
		fire_count[0] += 1
	)
	var chosen: Card = pick_offer.choose(1)
	if chosen == null or chosen.id != offer_a[1].id:
		errors += 1; printerr("choose(1) returned wrong card")
	if not pick_offer.is_resolved():
		errors += 1; printerr("choose() did not set is_resolved")
	if fire_count[0] != 1:
		errors += 1; printerr("choose: resolved fired %d times (expected 1)" % fire_count[0])
	# Double-choose / out-of-range — must NOT re-fire.
	pick_offer.choose(0)
	pick_offer.choose(99)
	pick_offer.skip()
	if fire_count[0] != 1:
		errors += 1; printerr("double-resolve: signal fired %d times (expected 1)" % fire_count[0])

	# Skip path
	var skip_offer := RewardOffer.new(offer_a)
	var skip_caught: Array = [Card.new()]  # sentinel non-null
	var skip_fire: Array = [0]
	skip_offer.resolved.connect(func(c: Card) -> void:
		skip_caught[0] = c
		skip_fire[0] += 1
	)
	skip_offer.skip()
	if skip_caught[0] != null:
		errors += 1; printerr("skip: resolved did not deliver null")
	if skip_fire[0] != 1:
		errors += 1; printerr("skip: resolved fired %d times (expected 1)" % skip_fire[0])

	# ---- GameState integration: start_reward + choose grows deck ----------
	# Make sure GameState has a clean deck/hand/discard to play with.
	GameState.start_run(_starter_cards(pool), &"reward_test_warlord", 4242)
	var deck_size_before: int = GameState.deck.size()
	var integ_rng := RandomNumberGenerator.new()
	integ_rng.seed = 555
	var integ_offer: RewardOffer = RewardGenerator.generate_offer(pool, GFEnums.Faction.IRON_PENITENTS, integ_rng, 3)
	GameState.start_reward(integ_offer)
	if GameState.current_phase != GFEnums.RunPhase.REWARD:
		errors += 1; printerr("start_reward: phase is %s, expected REWARD" % GameState.current_phase)
	integ_offer.choose(0)
	if GameState.deck.size() != deck_size_before + 1:
		errors += 1
		printerr("choose: deck size %d, expected %d" %
			[GameState.deck.size(), deck_size_before + 1])

	# Skip integration: deck size unchanged
	GameState.start_run(_starter_cards(pool), &"reward_test_warlord", 4242)
	var pre_skip: int = GameState.deck.size()
	var skip_rng := RandomNumberGenerator.new()
	skip_rng.seed = 556
	var skip_integ: RewardOffer = RewardGenerator.generate_offer(pool, GFEnums.Faction.NEUTRAL, skip_rng, 3)
	GameState.start_reward(skip_integ)
	skip_integ.skip()
	if GameState.deck.size() != pre_skip:
		errors += 1
		printerr("skip: deck size %d, expected unchanged %d" %
			[GameState.deck.size(), pre_skip])

	return errors


# Pull 5 cheap starter UNITs to give GameState a meaningful deck to compare
# size against — mirrors what sandbox.gd does.
func _starter_cards(pool: Array[Card]) -> Array[Card]:
	var out: Array[Card] = []
	for c in pool:
		if out.size() >= 5:
			break
		if c.card_type == GFEnums.CardType.UNIT and c.cost <= 3:
			out.append(c)
	return out
