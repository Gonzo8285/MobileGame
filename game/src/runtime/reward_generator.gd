extends RefCounted
class_name RewardGenerator

## RewardGenerator (B2.8) — builds the post-combat "pick 1 of 3" reward offer.
##
## Pure static functions. Stateless. Given a pool of Card resources, a faction
## bias (the active Warlord's faction), and a seeded RNG, returns N distinct
## cards sampled with weight = faction_weight × rarity_weight.
##
## Weighting rationale (tuned for B2.8; numbers tweakable from one place):
##
##   Faction bias                       (multiplicative)
##     bias-faction cards     × 4.0     active Warlord's faction
##     other in-pool factions × 1.0     cross-faction fill
##     neutral cards          × 2.0     always useful, never the dominant slot
##
##   Rarity                              (multiplicative)
##     COMMON     ×10
##     UNCOMMON   × 5
##     RARE       × 2
##     EPIC       × 0   excluded — reserved per GFEnums
##     LEGENDARY  × 0   excluded — Warlord-signature tier per GFEnums
##
## Distinctness: a single offer never contains two copies of the same card id.
## Pool-too-small fallback: if fewer than `count` distinct draftable cards
## remain after filtering, returns whatever is available (caller sees a
## thinner offer rather than a crash — anti-P2W: the reward path must always
## reach the player).
##
## Anti-P2W invariants:
##   - Generator never reads any monetisation state. Boosters / Battle Pass
##     do not bias what cards appear. (XP boosters live in GameState; reward
##     rolls are pure RNG + design weights.)
##   - The generator never grants the card itself. It returns 3 candidates; the
##     player's `choose()` call is what actually adds anything to the deck.

const FACTION_WEIGHT_BIAS: float = 4.0
const FACTION_WEIGHT_OTHER: float = 1.0
const FACTION_WEIGHT_NEUTRAL: float = 2.0

const RARITY_WEIGHT_COMMON: float = 10.0
const RARITY_WEIGHT_UNCOMMON: float = 5.0
const RARITY_WEIGHT_RARE: float = 2.0
# EPIC + LEGENDARY excluded entirely — see _rarity_weight().

const DEFAULT_OFFER_COUNT: int = 3


# ============================================================================
# Public entry point
# ============================================================================

## Build a reward offer.
##
## `pool` is the full draftable card universe (callers typically pre-load
## from `res://data/cards/`). `faction_bias` is the active Warlord's faction;
## pass GFEnums.Faction.NEUTRAL to disable the faction bonus entirely.
##
## `rng` must be supplied (the caller is responsible for seeding for
## replay/test determinism — same pattern as Deck.shuffle).
##
## Returns an Array[Card] of length ≤ `count`. Length < count only when the
## filtered pool was smaller than `count`.
static func generate(
		pool: Array[Card],
		faction_bias: int,
		rng: RandomNumberGenerator,
		count: int = DEFAULT_OFFER_COUNT
) -> Array[Card]:
	var picked: Array[Card] = []
	if pool.is_empty() or rng == null or count <= 0:
		return picked

	# Candidate filtering: keep only draftable, non-excluded-rarity cards.
	# De-dup by id so a pool that accidentally holds two copies of the same
	# resource can't smuggle both into the same offer.
	var candidates: Array[Card] = []
	var weights: Array[float] = []
	var seen: Dictionary = {}
	for c in pool:
		if c == null or not c.is_draftable:
			continue
		if seen.has(c.id):
			continue
		var w := _card_weight(c, faction_bias)
		if w <= 0.0:
			continue
		seen[c.id] = true
		candidates.append(c)
		weights.append(w)

	if candidates.is_empty():
		return picked

	# Sample N distinct cards. After each pick we zero its weight so the same
	# card can't be picked twice. (Removing from the array would also work but
	# zero-then-skip keeps indices stable and avoids array-copy churn.)
	var remaining := count
	while remaining > 0:
		var idx := _weighted_pick(weights, rng)
		if idx < 0:
			break  # All weights have been zeroed — pool exhausted.
		picked.append(candidates[idx])
		weights[idx] = 0.0
		remaining -= 1

	return picked


## Generate an offer wrapped in a RewardOffer. Convenience helper for the
## common case — most callers want the object, not the raw array.
static func generate_offer(
		pool: Array[Card],
		faction_bias: int,
		rng: RandomNumberGenerator,
		count: int = DEFAULT_OFFER_COUNT
) -> RewardOffer:
	var cards := generate(pool, faction_bias, rng, count)
	return RewardOffer.new(cards)


# ============================================================================
# Pool loaders — convenience for callers that don't want to walk dirs by hand
# ============================================================================

## Recursively load every Card .tres under the given res:// roots. Skips any
## file that fails to load as a Card. Used by reward_test.gd + (later) the
## map screen reward node.
##
## Default roots are the same set the sandbox/card-play test use. Pass an
## empty array to load nothing (rare; only useful in tests that build their
## own pool by hand).
static func load_pool(roots: Array = []) -> Array[Card]:
	var actual_roots := roots
	if actual_roots.is_empty():
		actual_roots = [
			"res://data/cards/",
			"res://data/cards/iron_penitents/",
			"res://data/cards/ash_mourners/",
			"res://data/cards/coven/",
		]
	var out: Array[Card] = []
	var ids_seen: Dictionary = {}
	for root in actual_roots:
		for c in _load_dir(String(root)):
			if c == null:
				continue
			if ids_seen.has(c.id):
				continue
			ids_seen[c.id] = true
			out.append(c)
	return out


# ============================================================================
# Internal helpers
# ============================================================================

static func _card_weight(card: Card, faction_bias: int) -> float:
	var fw := _faction_weight(card.faction, faction_bias)
	if fw <= 0.0:
		return 0.0
	var rw := _rarity_weight(card.rarity)
	if rw <= 0.0:
		return 0.0
	return fw * rw


static func _faction_weight(card_faction: int, bias_faction: int) -> float:
	if card_faction == GFEnums.Faction.NEUTRAL:
		return FACTION_WEIGHT_NEUTRAL
	if bias_faction == GFEnums.Faction.NEUTRAL:
		# No bias requested → all non-neutral factions weigh the same.
		return FACTION_WEIGHT_OTHER
	if card_faction == bias_faction:
		return FACTION_WEIGHT_BIAS
	return FACTION_WEIGHT_OTHER


static func _rarity_weight(rarity: int) -> float:
	match rarity:
		GFEnums.Rarity.COMMON:
			return RARITY_WEIGHT_COMMON
		GFEnums.Rarity.UNCOMMON:
			return RARITY_WEIGHT_UNCOMMON
		GFEnums.Rarity.RARE:
			return RARITY_WEIGHT_RARE
		_:
			# EPIC + LEGENDARY excluded from the reward pool by design.
			return 0.0


## Weighted index pick. Returns -1 if every weight is ≤ 0 (pool exhausted).
## O(n) per call — fine for offer pools in the low hundreds; if we ever need
## bigger pools we can switch to an alias table.
static func _weighted_pick(weights: Array[float], rng: RandomNumberGenerator) -> int:
	var total: float = 0.0
	for w in weights:
		if w > 0.0:
			total += w
	if total <= 0.0:
		return -1
	var roll: float = rng.randf() * total
	var acc: float = 0.0
	for i in range(weights.size()):
		var w: float = weights[i]
		if w <= 0.0:
			continue
		acc += w
		if roll <= acc:
			return i
	# Floating-point edge case — fall through to the last positive-weight slot.
	for i in range(weights.size() - 1, -1, -1):
		if weights[i] > 0.0:
			return i
	return -1


static func _load_dir(dir_path: String) -> Array[Card]:
	var out: Array[Card] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var f := dir.get_next()
	while f != "":
		if not dir.current_is_dir() and f.ends_with(".tres"):
			var res := load(dir_path + f) as Card
			if res != null:
				out.append(res)
		f = dir.get_next()
	dir.list_dir_end()
	return out
