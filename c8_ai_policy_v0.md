# C8.D2 — AI heuristic policy v0 (Phase 2.15)

**Author:** Controller (hourly backlog cycle #10)
**Date:** 2026-05-27 02:25Z
**Status:** SPEC ONLY — no `.py`, no `.gd`, no `.tres` edits. D3 (`outputs/c8_sim_runner.py`) implements against this spec, gated separately on Paul Q1 (Option β endorsement) per `c7_v0_2_balance_audit.md` §2.
**Supersedes:** `c8_playtest_sim_charter.md` §2.6 (5-rule stub).
**Inputs:**
- `c8_playtest_sim_charter.md` (D1, 2026-05-27 01:20Z) — §2.6 policy rule stubs
- `archetypes_v0.md` v0.2.1 — 15 archetype spines (identity / payoff / 2-3-4 spine cards)
- `cards_<faction>_v1.md` × 5 — card stats, keywords, effect_text
- `game/src/runtime/turn_engine.gd` + `card_play.gd` — engine truth for legal-action surface
- `keywords/persist_v0.md`, `keywords/taunt_v0.md` — keyword semantics the policy must respect

**Authority:** spec-doc lane only. Grid-agnostic — does not depend on Q1 Option-β endorsement. Mirror-policy convention (both seats run the same policy) per charter §7 Q2 recommendation.

---

## 1. Scope

Defines the deterministic per-turn decision policy for the sim opponent (and, under mirror-policy convention, for the sim player). The policy is **heuristic, not learned** — no rollouts, no minimax, no MCTS. Each turn the policy reads the current game state and produces an ordered action list for the turn-end resolver to apply.

Out of scope for v0:
- **Learned policy / RL.** Deferred to v2+.
- **Asymmetric skill modelling.** Both seats use the same policy; player-skill asymmetry is the v1 sweep (charter §4).
- **Look-ahead beyond current turn.** No "save mana for next-turn combo" reasoning.
- **Card-knowledge / hand-tracking of opponent.** Sim is open-information at design level but policy reads only own-hand + visible board.
- **Mulligan policy.** One rule only — redraw any opening hand without a 2-cost card (charter §2.3). No mid-game mulligans.
- **Treatment / cosmetic state.** Anti-P2W invariant: policy MUST NOT read `card_instance.treatment_id`.

---

## 2. Inputs the policy reads

The policy is a pure function `decide_turn(state) -> Array[Action]`. State surface available:

| Input | Source | Notes |
|---|---|---|
| `hand` | `GameState.hand.cards: Array[Card]` | Own hand only |
| `mana` | `GameState.mana_current` | Current spendable mana |
| `lanes[0..2]` | `Combat.lanes: Array[Lane]` | Tile occupancy, friendly UnitInstance, enemy EnemyInstance, range to player base |
| `traps[0..2]` | `Combat.lane_traps` + per-tile `Trap` instances | Active trap cards in lane |
| `lane_effects[0..2]` | `Combat.lane_effects` | M2 C42 Black Mire Pact style lane-wide passives |
| `friendly_hp` | `GameState.hp` | Sim player base HP |
| `enemy_hp` | `Combat.enemy_base_hp` | Boss/wave base HP |
| `turn_num` | `Combat.turn_num` | For Hanging Hour pre/post detection |
| `archetype_id` | Sim config | Drives spine_priority + lane_bias lookup |
| `discard` | `GameState.discard.cards` | For C3 Sacrifice-Combo and Glean (W2 T3 alt-fire) reasoning |
| `pending_persists` | `Combat._pending_persists` | M1 PERSIST queue inspection |

The policy MUST NOT read: opponent hand, opponent deck, opponent discard, `treatment_id`, `unlock_tag`, `warlord_tier`, `acquired_via`, any monetisation state.

---

## 3. Outputs the policy produces

`decide_turn(state)` returns an ordered `Array[Action]` consumed by the sim's turn resolver. Each Action is one of:

| Action | Args | Engine equivalent |
|---|---|---|
| `PLAY_UNIT` | card_id, lane_idx, tile_idx | `CardPlay.play_card` UNIT path |
| `PLAY_SPELL` | card_id, target (lane / unit / enemy / global) | `CardPlay.play_card` SPELL path |
| `PLAY_TRAP` | card_id, lane_idx, tile_idx | `CardPlay.play_card` TRAP path |
| `ACTIVATE_WARLORD_ABILITY` | ability_id, args | T1 default; T2/T3 deferred to v1 |
| `END_TURN` | — | Terminates action list; required final entry |

Actions are resolved in list order. After each Action the policy's preconditions (mana, hand contents, lane state) MUST hold or the resolver SKIPs the Action with a warning. The resolver does NOT re-invoke `decide_turn` mid-turn (one-shot policy, no in-turn reactivity).

---

## 4. Decision algorithm — 5 numbered rules

Charter §2.6's 5 rules, expanded into concrete decision procedures.

### Rule 1 — Play priority (cost-descending, spine-weighted)

For each turn, iterate hand in **priority order**:

1. **Compute affordability set** `H_aff = {c ∈ hand : c.cost ≤ mana_current}`.
2. **Partition** `H_aff` into three buckets:
   - `H_spine` = cards in archetype's `payoff_cards` list (per `archetypes_v0.md` archetype block — identity card + payoff card + 2-3-4 spine).
   - `H_synergy` = cards that gain a value bump from current board state (e.g. P3 Crowned Martyr if any friendly Mourner just died; L41 Banner-Bearer if a friendly banner stands in any row).
   - `H_filler` = everything else.
3. **Sort each bucket cost-descending**, ties broken by:
   - Higher base stats (HP + ATK) first
   - Then UNIT > SPELL > TRAP (bias toward board presence)
4. **Play order** = `H_spine ⊕ H_synergy ⊕ H_filler`. Iterate; stop when no more affordable cards remain or `END_TURN` triggers (Rule 5).

**Tie-breaking for `H_spine` deep ties:** prefer cards that ALSO appear in archetype's `identity_card` field over `payoff_card`, and `payoff_card` over plain spine. This gives identity cards turn-1 priority when they're affordable, which matches the M7 "by turn 4 the strategy should be recognisable" cohesion target.

**Mana waste cap.** If end-of-iteration the policy would END_TURN with `mana_unspent ≥ 3`, fall back to: play the highest-cost affordable filler. If still ≥3 unspent and hand has affordable trap or buff spells, play them. Prevents the "stuck on 4-cost openers" pattern that distorts win-rate signal.

### Rule 2 — Lane choice

Per archetype, lane choice follows an `archetype_lane_bias` flag (computed from `archetypes_v0.md`):

| Bias | Rule | Archetypes using it |
|---|---|---|
| `SPREAD` | Play in lane with **fewest friendly bodies** (count UNIT only, not Tokens). Tie → leftmost lane (deterministic). | A1 Bleed-Stack (wants Bleed targets across rows), B3 Trap-Control (wants traps spread), C2 Bog-Spawn Swarm (token density across lanes), E3 Beast-Summon (Wolf-Token spread), D2 Tempo-Echo (Echo replays benefit from cleaner lanes) |
| `STACK` | Play in lane with **most friendly bodies** (UNIT + Token both count). Tie → leftmost lane. | D1 Rally-Formation (adjacency triggers), D3 Banner-Buff (banner row payoff), A3 Cleave-Melee (Cleave needs adjacent enemy density to land), B2 Resurrect-Spam (recursion benefits from concentrated graveyards), C3 Sacrifice-Combo (sac-feeders concentrate value) |
| `THREAT_RESPONSE` | Play in lane with **highest enemy HP within 3 tiles of base**. Tie → fewest friendly bodies in that lane. | B1 Smoke-Fear Control, A2 Sacrifice-Penance (Self-Mortification wants enemies present), C1 Poison-Stack (Poison ramps faster vs high-HP), E1 Big-Monster (single big body in the threat lane), E2 Transformation (single transformed body in threat lane) |

**Tile choice within lane:** UNITs spawn on **rearmost empty tile** (closest to player base) — matches `combat.gd.handle_drop` default and avoids putting a 1-HP body in front of an advancing enemy. TRAPs spawn on **middle tile** (tile 3 of 6) — maximises trigger probability across enemy advance paths. SPELLs targeting tiles use the threat-lane's most-forward enemy (Rule 3 below for timing).

### Rule 3 — Spell timing

Spells split into 4 timing buckets by tag-inspection on `effect_text`:

| Bucket | Detection | Timing rule |
|---|---|---|
| **Trap-laying spells** | `card_type == TRAP` OR `effect_text` contains "trap" / "set" | Play **turn 1** if affordable; otherwise as soon as affordable. Pre-empt enemy advance. |
| **Removal spells** | `effect_text` contains "destroy" / "kill" / "deal N damage to enemy" (regex on enemy-target keywords) | **Hold until enemy unit hits the 3-tile mark** (tile index ≤ 3 from base). If multiple enemies qualify, target highest-ATK first. If no enemy at 3-tile mark, hold (do not waste). |
| **Buff spells** | `effect_text` contains "+N ATK" / "Shield" / "Pierce" / "gain" applied to friendly target | Play **immediately** on a friendly UNIT in lane (priority: friendly with highest current ATK already, to maximise stacking). |
| **Utility / card-draw / mana** | `effect_text` contains "draw" / "summon" / "gain mana" (no enemy interaction) | Play **immediately** if affordable. |

**Removal-spell exception:** if the policy holds removal and the player base would take lethal damage from advancing enemies in the next turn (compute: sum enemy ATK in any single lane within range >= friendly_hp), **break the hold** and fire removal at the lethal source. Failsafe; prevents "policy held removal and died" pathology.

### Rule 4 — Resource trade-offs (sacrifice / Persist / Glean)

If hand contains a **sacrifice-payoff card** (per `cards_iron_penitents_v1.md` + `cards_coven_v1.md` archetype blocks — P9 Procession of Nails, C5 Briar-Hag, P41 Last Vows, C41 Bog-Bargain Recall, etc.):

1. **Identify sac fodder.** Lowest-HP friendly UNIT in lane, EXCLUDING tokens (Cub / Wolf / Bog-Spawn) — wait, EXCEPT for C3 Sacrifice-Combo archetype where Tokens ARE the preferred fodder.
2. **Resolve sacrifice outlet.** Play the sac-payoff card; engine processes sacrifice trigger.
3. **Order matters:** sac-feed BEFORE playing new high-cost units this turn — fresh bodies are not desirable fodder.

**Persist interaction (M1):** if a friendly UNIT with PERSIST keyword (`Keyword.PERSIST` in card.keywords) is about to die in current turn's enemy attack phase, the policy should NOT sac-feed it — let PERSIST's natural end-of-turn return-1-ATK trigger fire instead. The persist queue carries inherent value Rule 4 should not pre-empt.

**Hanging Hour pre-positioning:** at `turn_num == 3` (one turn before boss-encounter Hanging Hour at turn 4) or `turn_num == 4` (one turn before standard Hanging Hour at turn 5), the policy SHOULD intentionally allow low-HP friendly UNITs to die in the enemy attack phase IF those UNITs have PERSIST — Hanging Hour will return them at FULL stats per `keywords/hanging_hour_persist_v0.md`. Equivalent to: don't waste defensive plays the turn before Hanging Hour.

**Glean (W2 T3 alt-fire, deferred):** policy can use Glean if Warlord = Sieren AND `tier >= 3` AND `discard` contains a UNIT with cost ≤ (mana_current - 3). Spec-only — v0 sim runs at Tier 1 default passive per charter §4. Tier-3 alt-fire support deferred to v1 sweep.

### Rule 5 — End-of-turn pass

Policy emits `END_TURN` when:

1. `mana_current < min(c.cost for c in hand)` — no affordable card remains, OR
2. All affordable cards have been played AND the residual mana waste is < 3 (Rule 1 cap), OR
3. The remaining affordable cards would actively harm board state (e.g. playing P7 Self-Mortification with no friendly UNITs in lane — self-damage with no payoff). Hand-prune: drop these from `H_aff` before Rule 1 iteration.

The resolver appends `END_TURN` automatically if the policy returns an empty Action list. Belt-and-braces; never an infinite loop.

---

## 5. Per-archetype spine + payoff lookup table

The policy needs `archetype_id → {identity_card, payoff_card, spine_cards}` lookups. Derived from `archetypes_v0.md` v0.2.1 + Phase 2.13 commons. Authoritative source = `archetypes_v0.md`; this table is a Python-mirror convenience extract that D3 should regenerate on sim start (do not hard-code; parse the markdown).

| ID | Archetype | Identity | Payoff | 2-3-4 spine + 2026-05 adds |
|---|---|---|---|---|
| A1 | Bleed-Stack | P10 Lord-Penitent of the Crowned Cross (4c R) | P14 Vow of Endless Penance (6c R) | P3, P4, P5, P8 + P41 Last Vows |
| A2 | Sacrifice-Penance | P10 Lord-Penitent of the Crowned Cross (4c R) | P14 Vow of Endless Penance (6c R) | P9, P5, P3, P7 + P41 Last Vows |
| A3 | Cleave-Melee | P10 Lord-Penitent of the Crowned Cross (4c R) | P14 Vow of Endless Penance (6c R) | P4, P5, P8, P3 |
| B1 | Smoke-Fear Control | M14 Fear-Caller (4c R) | M8 Cinder Tide (4c R, treated as payoff) | M3, M2, M4, M1 |
| B2 | Resurrect-Spam | M12 Necrologist (3c R promoted to identity) | M24 Choir of the Long Dead (5c R) | M2, M1, M4, M3 + M41 Wraith-Caller of the Dirge |
| B3 | Trap-Control | M14 Fear-Caller (4c R, dual-use) | M11 Funeral Bell (3c R trap as payoff) | M9, M10, M2, M4 |
| C1 | Poison-Stack | C5 Briar-Hag (4c U promoted to identity) | C6 Mother Quag, Twice-Drowned (5c R) | C3, C5, C4, C8 |
| C2 | Bog-Spawn Swarm | C2 Bog-Witch Initiate (1c, identity-via-ubiquity) | C6 Mother Quag, Twice-Drowned (5c R) | C2, C4, C5 (Tokens treated as fodder) |
| C3 | Sacrifice-Combo | C5 Briar-Hag (4c U) | C42 Black Mire Pact (2c C TRAP lane-wide) | C5, C3, C4 + C41 Bog-Bargain Recall + C42 Black Mire Pact |
| D1 | Rally-Formation | (Foundry-Sworn Pikeman 2c C, identity-by-density) | L33 Banner-Captain of the Crowned Anvil (4c R) | Foundry-Sworn Pikeman, Iron Bayonet Drill, Forge-Conscript |
| D2 | Tempo-Echo | L18 Echo-Sergeant (3c R) | L18 Echo-Sergeant (self-payoff via ECHO) | L4, L7, L18, L25 |
| D3 | Banner-Buff | L33 Banner-Captain of the Crowned Anvil (4c R) | L34 Crowned Anvil Standard (5c R artifact-unit) | L30, L31, L33, L34 + L41 Banner-Bearer of the Crowned Anvil |
| E1 | Big-Monster | W4 Bear-Skin Hierophant (4c R) | W8 Thrask the Bear-Who-Was-King (6c R) | W4, W8 (spine intentionally thin — single big bodies) |
| E2 | Transformation | W19 Wyrd-Shifter of the Cinderwood (4c R) | W19 (self-payoff via transform proc) | W19 + transformation-tagged commons |
| E3 | Beast-Summon | W31 Pelt-Bound Shaman (4c R) | W34 Den-Mother (4c R) | W27, W28 (tokens), W31 + W41 Pack-Caller Initiate + W42 Den-Mother of the Cinderwood |

**Note on identity overlaps:** Iron Penitents has one Rare identity card serving all 3 archetypes (P10 Lord-Penitent / P14 Vow); v0.2 deck construction (charter §2.3) splits the 20-card pseudodeck so identity card draw rate is comparable across archetypes despite the shared anchor. D3 enforces.

---

## 6. Anti-P2W invariants (restated)

The policy MUST NOT branch on, read, or compute from:
1. `treatment_id` on any CardInstance — cosmetic-only per `treatment_definitions.tres` design lock
2. `acquired_via` field — provenance is collection metadata, not gameplay
3. Warlord `tier` beyond Tier 1 default passive at v0 — T2/T3/T4 variants live in v1 sweep
4. `xp_multiplier_sources` or `warlord_xp` — XP boosters are monetisation surfaces, never combat inputs
5. Any field on the `MonetisationMap` / `BattlePass` / `Shop` resources

Combat is deterministic against (card stats + keywords + effect_text + board state + RNG seed). Nothing else. If the policy accidentally reads cosmetic state, D3 enforcement: fail the sim with a hard error rather than producing a tainted result.

---

## 7. Determinism + reproducibility

- Policy is a **pure function** — no internal state between turn calls.
- All RNG draws (e.g. tie-breaking when 2 cards have identical priority) use the matchup-seeded RNG per `c8_playtest_sim_charter.md` §2.4 (`seed = matchup_index × 1000 + game_index`).
- Tie-break order: per Rule 1 (stats → type), then per-lane leftmost (Rule 2), then card_id ascending (lexicographic).
- Re-running the sim with the same seed MUST produce byte-identical Action sequences.

---

## 8. Engine-truth verification gates (D3 implementation guardrails)

When D3 implements this spec as a Python mirror, the implementation MUST:

1. **Re-derive the legal-action surface from `card_play.gd` + `turn_engine.gd` semantics** — do not invent new actions or short-circuit existing engine rules (mana cost deduction, keyword application, attack order).
2. **Validate against `turn_engine_test.gd`'s established invariants** — Persist round-trip, BLEED DoT cascade, friendly attack priority. The mirror's results on a single combat MUST match the engine's results on the same combat within the assertion set.
3. **Surface drift loudly.** If a Python-mirror combat result diverges from a Godot-engine result on the same seed + same deck + same hands, fail loud with the diff. Don't silently absorb engine evolution.
4. **No hard-coded archetype data.** Parse `archetypes_v0.md` + `cards_<faction>_v1.md` at sim startup. Spec table in §5 of this doc is a reference, not a fallback hard-code.

---

## 9. Open questions

1. **Identity-overlap deck construction (Iron Penitents).** A1, A2, A3 all share P10 Lord-Penitent identity. Should each Penitents archetype's 20-card pseudodeck include P10, or rotate identity per archetype (A1 always has P10, A2 substitutes a different Rare)? Recommendation: **include P10 in all 3 — design intent per faction_bible is "the Lord-Penitent embodies all three Penitent paths"; pseudo-deck reflects that.**

2. **D2 Tempo-Echo self-payoff loop.** L18 Echo-Sergeant is both identity AND payoff (ECHO replays itself). Rule 1's "identity first" + "payoff first" both point at the same card — fine. But Rule 4 might also trigger on it (post-PIERCE attack pattern). Should the policy explicitly track L18 turn-deployment count to avoid over-stacking? Recommendation: **no — let the natural mana curve + once-per-turn ECHO engine-side limit cap it. Policy stays simple; engine truth is authoritative.**

3. **Bog-Spawn Token as "fodder" exception.** Rule 4 sac-fodder excludes Tokens for most archetypes but C3 Sacrifice-Combo treats Tokens as preferred fodder. Should the spec carve out a `archetype_sac_fodder_tokens_ok` bool, or wire this into `archetype_lane_bias`'s STACK semantics (C3 uses STACK so tokens accumulate)? Recommendation: **explicit flag on archetype lookup table — STACK bias is about lane choice, not fodder selection; conflating risks accidentally allowing all STACK archetypes to feed Tokens (B2 Resurrect doesn't want to).**

4. **PERSIST-aware sacrifice exclusion.** Rule 4 says "don't sac PERSIST cards because they'll naturally return at -1 ATK". But for sacrifice-payoff archetypes (P9 Procession of Nails, C5 Briar-Hag), the sac IS the payoff trigger. Should the policy ALLOW sac of PERSIST cards if the sac-payoff card is in hand THIS turn? Recommendation: **YES, but only on `turn_num >= 5` (post-Hanging-Hour) — pre-Hanging-Hour, Persist's free-return is more valuable than the sac payoff for most matchups.**

5. **W2 T3 Glean Tier-3 alt-fire wiring.** Rule 4 spec includes Glean conditionally (`tier >= 3`). v0 sim runs T1 only per charter §4 + this doc §1. Should the Glean spec be in this v0 doc at all? Recommendation: **YES — spec is forward-compatible; v1 sweep activates when warlord_tier is parameterised into sim config. Leaving Glean undocumented makes v1 the spec-writing cycle; better to document now.**

6. **Mana-waste cap threshold.** Rule 1 sets `mana_unspent ≥ 3` as the "play a filler" trigger. 3 mana = could-play-a-3-cost-card-but-didn't, a real signal of policy underplay. Is 3 the right threshold, or should it be 2 (tighter, plays more cards per turn) or 4 (looser, holds back more)? Recommendation: **start at 3, adjust based on D4 results — if average mana_waste per game >2 across factions, tighten to 2.**

7. **Removal-spell threat-mark.** Rule 3 fires removal when enemy is at tile index ≤ 3 from base. Lanes are 6 tiles long; 3 = halfway. Is halfway the right trigger, or earlier (≤4, fires sooner — wastes value on lower threats) or later (≤2, fires later — risks lethal)? Recommendation: **start at ≤3, escalate D4 if average "lethal-from-base" events per game >0.1.**

8. **Buff-spell stacking target.** Rule 3 priority: friendly with highest current ATK. Alternative: friendly with most HP (durability stacking) OR friendly with most relevant keyword for archetype (e.g. SHIELD-tagged for D3 Banner-Buff). Recommendation: **start with highest-ATK; archetype-aware targeting is a v1 refinement.**

None of these open Qs block D3 implementation — D3 picks the recommendation defaults and notes the alternatives in code comments.

---

## 10. Downstream / handoff

- **D3 (`outputs/c8_sim_runner.py`)** implements §4 + §5 against the engine-truth gates in §8. **Gated on Paul Q1 endorsement** (Option β confirms the v0.2.1 grid the sim runs against).
- **D4 (`c8_results_v0.md`)** runs the sim once D3 is built; flags any open-Q recommendation that the data invalidates.
- **D5 (tuning recommendations)** per matchup with delta >5pp from C7-v0.2 expected.
- **v1 sweep** (after IMV-1 Paul-playtest signoff): asymmetric policy (player-skill modelling), Tier 2-4 Warlord variants, MCTS lookahead at the decision layer, dynamic mulligan beyond opening-hand.
- **No engine wiring this cycle.** Policy lives in Python sim only at v0; if/when sim signal warrants moving to Route B (Godot headless per charter §2.5), the policy module ports across as a `.gd` AutoLoad with the same input/output contract.

---

— Controller, 2026-05-27 02:25Z (hourly backlog cycle #10)
