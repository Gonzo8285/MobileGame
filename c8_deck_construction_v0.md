# C8.D2.5 — Deck construction algorithm v0 (Phase 2.15)

**Author:** Controller (hourly backlog cycle #11)
**Date:** 2026-05-27 03:25Z
**Status:** SPEC ONLY — execution lives in D3 (`outputs/c8_sim_runner.py`), gated on Paul Q1 from `c7_v0_2_balance_audit.md`.
**Inputs:**
- `c8_playtest_sim_charter.md` §2.3 (5-line deck construction stub being expanded here)
- `c8_ai_policy_v0.md` §5 (per-archetype spine + payoff lookup table — 15 archetypes)
- `archetypes_v0.md` v0.2.1 grid
- 5 `cards_<faction>_v1.md` spec docs (207-card pool)

**Authority:** spec-doc lane only. No `.tres` / `.gd` / `.py` edits. Defines how D3's deck-builder turns the 207-card pool into 15 archetype pseudo-decks at sim startup.

**Why this exists:** charter §2.3 names the recipe in 5 lines (12 spine + 6 utility + 2 flex, mulligan on no-2-cost). That's enough for a designer but not enough for a Python implementer — there are 6+ judgment calls hiding in "what counts as a spine card", "which utility cards qualify as neutral", "how does the Penitents identity-overlap rule resolve", "what cards are the flex slots for each archetype". D2.5 spells those out so D3 doesn't have to re-derive them under a Paul Q1 endorsement deadline. Grid-agnostic — Option β changes the counter grid in `archetypes_v0.md`, not the deck composition, so this spec is stable across Paul's Q1 disposition.

---

## 1. Scope

### In-scope
- Deterministic algorithm that produces a 20-card pseudo-deck for each of the 15 v0.2.1 archetypes.
- Selection rules for spine / utility / flex slots derived from `archetypes_v0.md` + `cards_<faction>_v1.md`.
- Identity-overlap handling (Iron Penitents A1/A2/A3 share P10 Lord-Penitent / P14 Vow).
- Mulligan rule (carries from charter §2.3).
- Validation gates D3 enforces at sim startup.

### Out-of-scope
- Player-side deck-building (no UI / collection / draft-mode at v0).
- Asymmetric decks per player (mirror-policy convention per `c8_ai_policy_v0.md` §1).
- Warlord-tier deck-modifiers (T2/T3/T4 perks parameterise deck composition at v1; v0 is T1-only per charter §"Out-of-scope").
- Token cards as deckable entries — Tokens are spawn-only per `cards_skinward_pact_v1.md` W27/W28 + `cards_coven_v1.md` C2 conventions; deck-builder excludes them.
- Relic cards — `is_draftable=false` flag per Phase 2.6 C2–C6 convention; deck-builder excludes them at v0 (relic-slot system gated on Paul's open Q from cards_iron_penitents_v1.md §"Open questions").

---

## 2. Inputs the builder reads

At sim startup, D3 parses:

1. `archetypes_v0.md` v0.2.1 (the 5×5 counter grid + the 15-archetype roster).
2. `cards_<faction>_v1.md` × 5 (the per-faction card specs — distribution / rarity / archetype assignment).
3. Each card's `.tres` for the canonical stats (cost / hp / atk / range / cooldown / keywords / card_type / faction / rarity / draftable / is_token).

The builder ignores `treatment_id`, `acquired_via`, `xp_multiplier_sources`, `warlord_xp`, and any `MonetisationMap` / `Shop` / `BattlePass` resources per `c8_ai_policy_v0.md` §6 anti-P2W invariants.

---

## 3. The 20-card recipe

Per archetype, the builder assembles a 20-card pseudo-deck in three buckets:

| Bucket | Count | Selection rule |
|---|---|---|
| **Spine** | 12 | Identity card + payoff card + 2/3/4-cost spine cards from `c8_ai_policy_v0.md` §5; pad with archetype-tagged cards from `cards_<faction>_v1.md` until 12 distinct entries |
| **Utility** | 6 | Faction-neutral cost-curve fillers at 1c/2c — drawn from the same faction's pool, NOT from cards already in the Spine bucket |
| **Flex** | 2 | Archetype-specific flex slots per §5 below |
| **Total** | **20** | All distinct card IDs; no duplicates at v0 |

**v0 convention: no card duplicates within a deck.** Standard MTG / Hearthstone allow 2× / 3× per card; Gallowfell's v0 sim treats each card as singleton to keep the matchup signal clean. Multi-copy support is a v1 sweep (parameterise `max_copies_per_card: int = 1` on the deck-builder).

---

## 4. Spine bucket — 12-card selection

For each archetype, the spine is the identity card + payoff card + the 4-card 2/3/4 spine from `c8_ai_policy_v0.md` §5 (6 cards), plus 6 additional archetype-tagged cards to reach 12.

### Per-archetype spine selection (12 cards each)

Pulled from `c8_ai_policy_v0.md` §5 (identity + payoff + 2/3/4 spine = 6 cards explicit) + 6 archetype-tagged supporting cards from the faction's pool.

| ID | Archetype | Identity (1) | Payoff (1) | 2/3/4 spine + 2026-05 adds (4–5) | Supporting cast (5–6 from faction pool, archetype-tagged) |
|---|---|---|---|---|---|
| A1 | Bleed-Stack | P10 | P14 | P3, P4, P5, P8 + P41 | 6 from Iron Penitents Bleed-Stack §32 block (Units 8 → pick remaining 5, Spell §49 pick 1 from Bleed-tagged) |
| A2 | Sacrifice-Penance | P10 | P14 | P9, P5, P3, P7 + P41 | 6 from Sacrifice-Penance §66 block (Units 8 → pick remaining 5, Spell §83 pick 1) |
| A3 | Cleave-Melee | P10 | P14 | P4, P5, P8, P3 | 6 from Cleave-Melee §100 block (Units 8 → pick remaining 6) |
| B1 | Smoke-Fear Control | M14 | M8 | M3, M2, M4, M1 | 6 from Ash-Mourners Smoke-Fear block (Units pick remaining 6) |
| B2 | Resurrect-Spam | M12 | M24 | M2, M1, M4, M3 + M41 | 6 from Ash-Mourners Resurrect-Spam block (Units pick remaining 5, Spell pick 1) |
| B3 | Trap-Control | M14 | M11 | M9, M10, M2, M4 | 6 from Ash-Mourners Trap-Control block (Traps pick remaining, then Units to fill) |
| C1 | Poison-Stack | C5 | C6 | C3, C5, C4, C8 | 6 from Coven Poison-Stack block |
| C2 | Bog-Spawn Swarm | C2 | C6 | C2, C4, C5 (Tokens treated as fodder, NOT deckable) | 7 from Coven Bog-Spawn block — note: C2 Bog-Spawn-Token entries excluded; replace with on-curve Bog-Spawn-spawners (e.g. C7 Bog-Mire Acolyte) |
| C3 | Sacrifice-Combo | C5 | C42 | C5, C3, C4 + C41 + C42 | 5 from Coven Sacrifice-Combo block + 1 from cross-archetype splash if pool insufficient |
| D1 | Rally-Formation | Foundry-Sworn Pikeman (identity-by-density) | L33 | Foundry-Sworn Pikeman, Iron Bayonet Drill, Forge-Conscript | 7 from Last Legion Rally block (Units pick remaining, Spell pick 1–2) |
| D2 | Tempo-Echo | L18 | L18 (self-payoff) | L4, L7, L18, L25 | 6 from Last Legion Tempo-Echo block (Units pick remaining 5, Spell pick 1) |
| D3 | Banner-Buff | L33 | L34 | L30, L31, L33, L34 + L41 | 5 from Last Legion Banner-Buff block (Units pick remaining 4, Spell pick 1) |
| E1 | Big-Monster | W4 | W8 | W4, W8 (spine intentionally thin — 2 cards) | 8 from Skinward Pact Big-Monster block (Units pick remaining, then on-curve 3c/4c bodies) |
| E2 | Transformation | W19 | W19 (self-payoff via transform proc) | W19 + transformation-tagged commons | 7 from Skinward Pact Transformation block (transformation-tagged Units + 1–2 Spells) |
| E3 | Beast-Summon | W31 | W34 | W31 + W41 + W42 (Tokens W27/W28 excluded per §3) | 7 from Skinward Pact Beast-Summon block (Wolf-Token-spawners + Beast-tagged Units) |

### Identity-overlap rule (Iron Penitents)

Per `c8_ai_policy_v0.md` §5 note: A1, A2, A3 all share P10 Lord-Penitent as identity + P14 Vow as payoff. The v0 algorithm:

1. Includes both P10 and P14 in ALL THREE Penitents archetype decks.
2. The Penitents archetype-tagged supporting cast bucket is selected from the archetype-block UNITS first; if pool insufficient, draws from cross-archetype splash cards in `cards_iron_penitents_v1.md` §144.
3. This means A1/A2/A3 decks share ~4–5 cards (P10, P14, plus splash overlap like P3 / P5 which spec'd as multi-archetype). That's the design intent per faction_bible — "the Lord-Penitent embodies all three Penitent paths" — and the matchup signal correctly reflects "Penitents archetypes feel similar to play".

Recommendation: KEEP this behaviour at v0. If D4 results show A1/A2/A3 win-rates clustered within ±3pp (suggesting the shared-anchor noise dominates), raise as v1 refinement candidate (split identity per archetype).

### Empty-slot fallback

If the archetype block has fewer than 12 distinct archetype-tagged entries (e.g. E1 Big-Monster spine is intentionally thin at 2 cards), the builder fills the gap with on-curve generic units from the same faction in ascending-cost order (1c → 2c → 3c → 4c). Logs a `[deck_builder] FALLBACK: <archetype> spine short by N, padded with generics` warning to surface in D4.

---

## 5. Flex bucket — 2-card archetype-specific picks

| Archetype | Flex slot 1 | Flex slot 2 | Rationale |
|---|---|---|---|
| A1 Bleed-Stack | P3 Cathedral Brother | P-faction TAUNT card (P34) | Post-TAUNT pivot per c7_v0_2_balance_audit.md F2 |
| A2 Sacrifice-Penance | P9 Procession of Nails | P7 Confessor-At-Arms | Sac-payoff combo loop |
| A3 Cleave-Melee | P8 Headsman of the Long Aisle | P34 (TAUNT) | Cleave-ignores-TAUNT design synergy |
| B1 Smoke-Fear | M14 Fear-Caller (post-R5 conditional refresh) | M-faction TAUNT-counter spell if Q4 accepted | Buff-payoff trigger |
| B2 Resurrect-Spam | M12 Necrologist | M24 Choir of the Long Dead | Identity + payoff redundancy (Resurrect-Spam wants identity in opening hand) |
| B3 Trap-Control | M11 Funeral Bell | M-faction trap-payoff | Trap-density spike |
| C1 Poison-Stack | C5 Briar-Hag | C6 Mother Quag | Identity + payoff redundancy |
| C2 Bog-Spawn Swarm | C7 Bog-Mire Acolyte | C-faction swarm-payoff | Token-spawn velocity |
| C3 Sacrifice-Combo | C41 Bog-Bargain Recall | C42 Black Mire Pact | M2 sacrifice-loop adds |
| D1 Rally-Formation | L33 Banner-Captain | Forge-Conscript | Per-row density payoff |
| D2 Tempo-Echo | L18 Echo-Sergeant | L25 Echo-archetype spell | Identity-doubling for ECHO consistency |
| D3 Banner-Buff | L33 Banner-Captain | L41 Banner-Bearer | Per Phase 2.13 N2 spine hardening |
| E1 Big-Monster | W4 Bear-Skin Hierophant | W8 Thrask the Bear-Who-Was-King | Identity + payoff redundancy (E1 wants big bodies in opening hand) |
| E2 Transformation | W19 Wyrd-Shifter | W-faction transformation-trigger spell | Transform proc density |
| E3 Beast-Summon | W41 Pack-Caller Initiate | W42 Den-Mother of the Cinderwood | Per Phase 2.13 N3/N4 spine hardening |

Flex picks are deliberately spine-cards duplicated into the flex bucket — this is the v0 "no duplicates" rule's escape valve. The flex bucket lets identity/payoff cards appear at higher than 1-in-20 odds (effective 2-in-20 = 10% per card if it's in both Spine and Flex), which mirrors the real-game "I'd play 2 copies of my key card" intent without introducing full multi-copy support.

**Edge case — flex overlap with spine:** if a flex slot card is already in the Spine bucket (which is the common case per the table above), the builder enforces deck size = 20 by treating the duplicate as one card with `weight=2` in the shuffle deck (probability mass, not a second physical entry). The deck still has 20 distinct card IDs.

---

## 6. Utility bucket — 6 faction-neutral cost-curve fillers

The utility bucket fills the cost curve with cheap, faction-pool cards NOT in the Spine or Flex buckets.

### Selection rules

1. **All from the same faction as the archetype.** No cross-faction cards at v0 (cross-faction splash design exists per `cards_iron_penitents_v1.md` §154 but is a v1 deckbuilding feature).
2. **Cost bias: 1c / 2c only.** Standard CCG curve — opening hand needs cheap plays.
3. **Pick 6 distinct entries NOT in Spine or Flex.** If the faction's 1c/2c pool minus Spine/Flex < 6 entries, pad with 3c entries in ascending-cost order.
4. **Prefer Units over Spells/Traps for the utility bucket.** Spells without archetype-spine context don't read as "neutral" — they're either dead draws or accidental archetype-tagging. Units at 1c/2c are the cleanest "neutral filler".
5. **Exclude Tokens, Relics, faction-locked specials.** Per §3 out-of-scope.

### Worked example — A1 Bleed-Stack utility bucket

Iron Penitents 1c/2c pool minus A1 spine (P3, P4, P5, P8 already used) minus A1 flex (also P3, P34): pick 6 distinct 1c/2c cards from `cards_iron_penitents_v1.md` §32 Bleed + §66 Penance + §100 Cleave Units that aren't already in the Spine or Flex buckets. The algorithm picks in ascending cost-then-id order to keep selection deterministic.

If the pool dries up at 6 distinct picks, log `[deck_builder] FALLBACK: A1 utility bucket padded to 3c at slot N` to surface in D4.

---

## 7. Mulligan rule

Per charter §2.3:

> Redraw any opening hand without a 2-cost card.

Algorithm:

1. Draw 5 cards (StS-convention opening hand size per `game_state.gd.start_combat(opening_hand_size: int = 5)` in `c8_ai_policy_v0.md` §2 implicit).
2. If any drawn card has `cost == 2`, KEEP the hand. Proceed.
3. Else, return all 5 to the deck, shuffle (deterministic per seed), redraw 5.
4. KEEP the second hand regardless of cost composition. No second mulligan at v0 (avoids variance noise per charter §"Out-of-scope").

**Per `c8_ai_policy_v0.md` §7 determinism contract:** mulligan must be byte-identical on re-runs with the same seed. The seed used for shuffle on mulligan = `seed_base XOR 0xMULL_TAG` (where MULL_TAG is a sim-side constant, e.g. `0xMULL_2026 = 0x4D554C32 ^ 0x303236`) — D3 picks a constant and notes it in code comments.

---

## 8. Validation gates D3 enforces at sim startup

For each of the 15 archetype decks, D3 MUST validate before running any matchup:

1. **Deck size = 20.** Fail loud if not.
2. **All 20 cards have distinct IDs.** Fail loud on duplicate IDs (flex weighting is a probability-mass property, not a second physical card).
3. **Identity card present.** Fail loud if the archetype's identity card (per §4 table) is missing.
4. **Payoff card present.** Fail loud if the archetype's payoff card is missing.
5. **At least 4 cards at 1c or 2c.** Validates opening-hand viability.
6. **No Tokens, no Relics, no `is_draftable=false` cards.** Per §3 exclusions.
7. **All cards belong to the archetype's faction.** No cross-faction at v0.
8. **Phase 2.13 commons present in their respective spine decks** (M41 in B2, L41 in D3, W41 + W42 in E3). Per N1–N4 spine-hardening intent.
9. **Phase 2.9 M2 cards present in respective spine decks** (P41 in A1+A2, C41+C42 in C3). Per M2 sacrifice-loop hardening intent.
10. **Fallback warnings logged but NOT fatal.** §4 empty-slot fallback + §6 utility-bucket fallback warnings surface in D4 results doc as a "decks that needed padding" appendix.

If any FAIL-LOUD gate trips, the sim aborts with diagnostic output — no partial-result production. Per `c8_ai_policy_v0.md` §6 anti-P2W enforcement convention (fail rather than taint).

---

## 9. Determinism + reproducibility

- Deck-builder is a **pure function** of (archetype_id, source-doc parse state).
- Selection order within a bucket is deterministic: spine cards in `c8_ai_policy_v0.md` §5 table order; supporting cast in card_id ascending; utility bucket in cost-ascending-then-id-ascending order.
- Re-running with the same input docs MUST produce byte-identical deck composition.
- If the input docs change (e.g. M14 effect_text refreshed per c7_v0_2_balance_audit.md R5), the deck composition is stable (M14 is still in the spine block; its text-change doesn't affect bucket assignment).
- The shuffle seed for in-game draws comes from `c8_playtest_sim_charter.md` §2.4 (`matchup_index × 1000 + game_index`); the deck-builder doesn't shuffle, only assembles the ordered card list.

---

## 10. Engine-truth verification gates (D3 implementation guardrails)

Per `c8_ai_policy_v0.md` §8 contract, the deck-builder MUST:

1. **Parse `archetypes_v0.md` + `cards_<faction>_v1.md` + each card's `.tres` at sim startup** — do not hard-code archetype data. The tables in §4–§5 above are reference, not fallback hard-code.
2. **Verify pool integrity at parse-time** — count cards per faction, fail loud if any faction has fewer cards than the spine + flex + utility minimum (≈ 17 cards minimum per faction; all 5 factions sit well above per Phase 2.13 close).
3. **Surface drift loudly** — if a deck includes a card whose .tres `is_token=true` or `is_draftable=false`, fail loud. The .tres is engine truth; the .md spec docs may have drifted.
4. **No hard-coded card IDs** in the deck-builder logic itself — IDs come from parsing the source docs. Tables in §4–§5 are documentation, not code.

---

## 11. Open questions for Paul (D3 picks recommendation defaults; alternatives noted in code)

1. **Multi-copy support timing.** v0 is singleton (1 copy per card max). Standard CCG convention is 2–3 copies per card. Should v0 add `max_copies_per_card: int = 2` to mirror the design-intent "play 2 of your key card" pattern, or stay singleton for matchup-signal cleanliness? Recommendation: **stay singleton at v0; flex bucket's weight=2 trick already captures the "play extra copies of key cards" intent without introducing variance. Multi-copy is v1 sweep.**

2. **Opening hand size.** Charter §2.3 doesn't lock the opening hand size; `c8_ai_policy_v0.md` §2 references 5 (StS convention). Should v0 lock at 5 (recommended, matches `game_state.gd.start_combat(5)` default) or pull from `gdd_v0.md` if a different value lives there? Recommendation: **lock at 5 in `c8_deck_construction_v0.md` §7 step 1; document the source.**

3. **Mulligan: second-mulligan support.** v0 allows one mulligan. Real CCGs (HS / MTG / Snap) often allow conditional second mulligans (Snap: redraw 1 card on turn 1; MTG: full second mulligan with -1 hand size). Should v0 add a second-mulligan rule, or stay at one? Recommendation: **stay at one mulligan at v0 — matches charter §2.3 + reduces variance noise. Second-mulligan is v1.**

4. **Cross-archetype identity-overlap (Penitents).** A1/A2/A3 share P10 + P14 by design per §4. The 3 Penitents decks will share 4–5 cards (P10, P14, plus splash overlap). Should the v0 sim treat this as a feature (correctly reflects "Penitents archetypes feel similar") or as noise to control for (split identity per archetype)? Recommendation: **treat as feature at v0; raise as v1 refinement candidate IF D4 shows A1/A2/A3 win-rates clustered within ±3pp.**

5. **E2 Transformation self-payoff loop.** W19 Wyrd-Shifter is identity AND payoff. The spine table has W19 once; flex bucket has W19 again (effective weight=2). Should E2 also bias more transformation-tagged commons in the supporting cast, even at the cost of cost-curve smoothness? Recommendation: **YES — pull 5–6 transformation-tagged Units before non-transformation Units, even if they're cost-clumped. Transformation density is the archetype's actual win condition.**

6. **C2 Bog-Spawn Swarm Token treatment.** Tokens are spawn-only per §3 (excluded from deck). But C2 Bog-Spawn Swarm is THE Token archetype — the deck-builder substitutes Token-spawners (C7 Bog-Mire Acolyte etc.) instead. Does this faithfully model the archetype's actual game-state behaviour, or under-represent token velocity? Recommendation: **faithful enough at v0 — Tokens enter the game via spawners, not from hand, so the deck representation correctly reflects the player's actual deck content. If C2 win-rate is anomalously low in D4 (<35% field), revisit at v1.**

7. **D2 Tempo-Echo card-economy.** D2's spine is L4, L7, L18, L25 — only 4 named spine cards in `c8_ai_policy_v0.md` §5 (no Phase 2.13 add). The Spine bucket needs 12; with 4 named + 1 identity (L18, already in named) + 1 payoff (L18 again) = 4 distinct. Supporting cast needs to backfill 8 cards from the Tempo-Echo block. Is the Tempo-Echo block large enough to backfill 8 cards, or will the algorithm trigger §4 empty-slot fallback? Recommendation: **D3 logs an explicit count; if Tempo-Echo block has <8 backfill candidates, the fallback to generic Legion units is acceptable — Tempo-Echo's identity is L18 + ECHO mechanic, not spine-card density.**

8. **Validation gate failure mode.** §8 says "fail loud" on a gate trip. Should the failure abort the entire sim, or skip the offending archetype and run the other 14? Recommendation: **abort entire sim — D4 results with one missing archetype are misleading. Fail loud, fix the input doc, re-run.**

None of these open Qs block D3 implementation — D3 picks the recommendation defaults and notes the alternatives in code comments.

---

## 12. Downstream / handoff

- **D3 (`outputs/c8_sim_runner.py`)** implements §3–§10 against the engine-truth gates in §10. Deck-builder is one of three modules inside D3 (alongside AI policy from `c8_ai_policy_v0.md` and the game loop simulator). **Gated on Paul Q1 endorsement** (Option β confirms the v0.2.1 grid the sim runs against — but the deck-builder is grid-agnostic and can be implemented independently of Q1 if a phased D3 ship is preferred).
- **D4 (`c8_results_v0.md`)** includes a "decks that needed padding" appendix per §10 step 10. Surfaces archetype-pool depth gaps that should feed into v1 card-design priorities.
- **D5 (tuning recommendations)** per matchup with delta >5pp from C7-v0.2 expected — if any deck-construction choice in this spec proves wrong (e.g. Q4 Penitents shared-identity hides per-archetype power), D5 names it.
- **v1 sweep** (after IMV-1 Paul-playtest signoff): multi-copy support, asymmetric decks per player, Warlord-tier deck-modifiers, cross-faction splash, dynamic mulligan beyond opening-hand.
- **No engine wiring this cycle.** Deck-builder lives in Python sim only at v0; if/when sim signal warrants moving to Route B (Godot headless per charter §2.5), the deck-builder module ports across as a `.gd` AutoLoad with the same input/output contract.

---

— Controller, 2026-05-27 03:25Z (hourly backlog cycle #11)
