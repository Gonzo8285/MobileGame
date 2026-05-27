# C8 — Playtest sim charter (Phase 2.15)

**Author:** Controller (hourly backlog cycle #9)
**Date:** 2026-05-27 01:20Z
**Status:** CHARTER ONLY — execution gated on Paul Q1–Q5 from `c7_v0_2_balance_audit.md` + B2 build playable in editor (already cleared per backlog B2.1–B2.10 all `[x]`).
**Inputs:**
- `c7_v0_2_balance_audit.md` (C7-v0.2; 2026-05-27 00:25Z) — 7 open Qs + 8 recommended actions R1–R8
- `archetypes_v0.md` v0.2.1 grid (D2 counter swap) — Option β applied
- 5 cards_<faction>_v1.md spec docs (207-card pool)
- M5 TAUNT keyword spec + E1 .tres tags

**Authority:** spec-doc lane only. No `.tres` edits, no `.gd` edits, no engine wiring. Charter defines how the sim runs once Paul Q1–Q5 are dispositioned and a sim runner is built.

---

## 1. Purpose

Ground C7-v0.2's six judgment-call recommendations (R1, R2, R4, R5, R6, plus the implicit "Banner-Buff load-bearing" watch) in numbers rather than design intuition. Specifically answer:

1. **Is Option β's edge count enough?** Legion 4 deals / 2 receives + Skinward 2 deals / 2 receives — does this read as "playable but distinct" or as "Skinward + Mourners feel like fodder"?
2. **L18 ECHO cap — 1/turn vs 2/turn.** Is the projected ~62% vs ~68% win-rate split (C7-v0.2 §"Flag 1") borne out? At what cap does L18 stop dominating aggro matchups?
3. **L-Banner vs P-Bleed deterministic-draft risk.** Win-rate gap above 65/35 triggers L33 SHIELD-stack soften; below 60/40 = no action. Where does it actually land?
4. **L D1 Rally Forge-Conscript nerf** — does the 2 deal / 1 receive imbalance translate to >60% field win-rate, triggering the in-pocket nerf?
5. **Fear-Caller TAUNT-conditional buff impact.** Without the buff, does B1 Smoke-Fear win-rate vs L D1 Rally fall below 45%? (Justifies R5 acceptance.)
6. **E3 Beast-Summon viability.** With Pack-Caller + Den-Mother in the pool + Option β's edge into D2, does E3 hit ≥45% field win-rate? Below 45% triggers a Pack-Caller cap re-look.

Secondary purpose: surface emergent-design risks the v0.2 grid analysis didn't catch. Cross-faction interaction matrices over thousands of games often reveal counter relationships that single-card design review misses.

---

## 2. Methodology — 30-game pairwise sim

### 2.1 Matchup grid

15 archetypes × 15 archetypes = 225 ordered pairs (self-mirrors included as control). Drop the 15 self-mirrors → 210 distinct ordered pairs. Halve via symmetry assumption (player initiative not modelled at v1) → **105 unordered matchups**.

30 games per matchup → **3,150 games per full sim run**.

At 100ms per game on the Python mirror (estimate based on `combat_test.gd` execution time × game-loop multiplier), full sim = ~5 minutes wall-clock. Tractable to re-run after each card-tuning iteration.

### 2.2 Archetype list (canonical 15 per v0.2.1)

| # | Code | Faction | Archetype |
|---|---|---|---|
| 1 | A1 | Iron Penitents | Bleed-Stack |
| 2 | A2 | Iron Penitents | Sacrifice-Penance |
| 3 | A3 | Iron Penitents | Cleave-Melee |
| 4 | B1 | Ash-Mourners | Smoke-Fear |
| 5 | B2 | Ash-Mourners | Resurrect-Spam |
| 6 | B3 | Ash-Mourners | Trap-Control |
| 7 | C1 | Coven | Poison-Stack |
| 8 | C2 | Coven | Bog-Spawn Swarm |
| 9 | C3 | Coven | Sacrifice-Combo |
| 10 | D1 | Last Legion | Rally-Formation |
| 11 | D2 | Last Legion | Tempo-Echo |
| 12 | D3 | Last Legion | Banner-Buff |
| 13 | E1 | Skinward Pact | Big-Monster |
| 14 | E2 | Skinward Pact | Transformation |
| 15 | E3 | Skinward Pact | Beast-Summon |

### 2.3 Deck construction per archetype

Each archetype gets a 20-card faux-deck built from its faction's `.tres` files, weighted toward the archetype's spine + payoff cards:

- 12 cards = spine + identity + payoff cards from `cards_<faction>_v1.md` archetype block
- 6 cards = neutral-utility cards from the faction's pool (cost-curve fillers at 1c/2c)
- 2 cards = the archetype's known flex slots (e.g. P3 Cathedral Brother for A1 Bleed-Stack post-TAUNT)

Mulligan policy: redraw any opening hand without a 2-cost card. Standard CCG opener convention; avoids the "stuck on 4-cost openers" variance noise.

### 2.4 Game loop simulation

- HP: player 30, enemy 30 (placeholder boss stat, mirrors B2.5 Combat scaffold defaults)
- Mana curve: standard 1-mana/turn ramp, cap 10
- Lane model: 3 lanes × 6 tiles per lane (per `combat.tscn` default)
- Win condition: opponent HP ≤ 0 OR deck-out (mill = loss on draw from empty)
- Turn cap: 30 turns (matches Hanging Hour escalation — turn 5 standard, turn 4 boss, by turn 30 we've passed 6 Hanging-Hour fires worth of game)
- Random seed: 30 seeds per matchup, seeded `matchup_index × 1000 + game_index`. Deterministic re-runs.

### 2.5 Sim engine choice — programmatic mirror, not B2 build

Two routes available:
- **Route A (recommended):** Python mirror of `turn_engine.gd` + `card_play.gd` + `combat.gd` + AI policy module. Same pattern as the existing per-test Python mirrors (B2.7 turn_engine, B2.8 reward_mirror, B2.9 map_mirror). Headless, scriptable, cheap to re-run.
- **Route B:** Godot headless build invocation with scripted decks. Higher fidelity (uses the real engine) but slower iteration, requires Paul-laptop Godot env.

**Recommendation: Route A for v0 sim.** Validates the design layer cheaply. Route B becomes appropriate once Route A's results justify the time investment (or once a discrepancy emerges that suggests the mirror has drifted from engine truth).

### 2.6 AI policy module

Per-turn decision policy for the sim opponent — heuristic, not learned. Rules:

1. **Play priority:** play the highest-cost card affordable that fits the archetype's spine (look up against the archetype's `payoff_cards` list).
2. **Lane choice:** play the new unit in the lane with the fewest friendly bodies (spread bias for token archetypes, stack bias for Banner-Buff archetype — invert this rule for D3).
3. **Spell timing:** trap spells played turn 1 if affordable; removal spells held until enemy unit hits the 3-tile mark; buff spells played immediately on a friendly unit in lane.
4. **Resource trade-offs:** if a sacrifice outlet is available and a sacrifice-payoff card is in hand, prefer sacrificing low-cost expendables first.
5. **End-of-turn:** pass when no plays are affordable / sensible.

Document the policy in `c8_ai_policy_v0.md` (sub-deliverable, NOT in this cycle).

### 2.7 What gets measured

Per matchup (averaged over 30 games):
- Win-rate (player perspective)
- Average game length in turns
- Average damage dealt by turn 10 (mid-game tempo signal)
- Card-economy: average cards drawn vs cards played
- Mana waste (unused mana per turn)

Per archetype (aggregated across all 14 matchups + self-mirror control):
- Field win-rate (sum wins / total games × 100)
- Best matchup + worst matchup
- Mean game length

Per faction (aggregated across the faction's 3 archetypes):
- Faction win-rate
- Faction-vs-faction win-rate (averaged 9-cell sub-matrix)

---

## 3. Pass / fail criteria

C7-v0.2's six judgment calls map to specific numeric thresholds:

| Q | Action | Pass criterion (action confirmed) | Fail criterion (revisit) |
|---|---|---|---|
| Q1 | Option β symmetry | All 5 factions land in 45-55% field win-rate band | Any faction <40% or >60% |
| Q2 | L18 ECHO cap = 1/turn | L D2 Tempo-Echo win-rate vs aggro factions <60% | >65% confirms cap too loose |
| Q3 | L-Banner vs P-Bleed | Gap 55/45–60/40 | >65/35 triggers L33 SHIELD soften |
| Q4 | Fear-Caller TAUNT buff | With buff: B1 vs D1 ≥48%. Without: <45% | Without buff ≥48% means buff unnecessary |
| Q5 | Forge-Conscript hold | L D1 Rally field win-rate <60% | >60% triggers 3→4 row-fill nerf |
| Q7 | C8 charter execution itself | This doc + AI-policy doc + sim runner exist | If sim can't be built cheaply, defer to Route B |

The 6th judgment call (E3 Beast-Summon viability — implicit) maps to: E3 field win-rate ≥45% confirms Pack-Caller cap stays at 1-per-turn; <45% triggers a Pack-Caller cap re-look.

---

## 4. Out-of-scope (v0 sim)

Deliberately deferred to keep the v0 sim cheap and the conclusions interpretable:

- **Player skill modelling.** The AI policy is uniform across player and opponent. Asymmetric skill curves (e.g. "the player draws the strongest play 70% of the time, opponent 50%") are a v1 refinement.
- **Mulligan beyond opening-hand 2-cost.** No dynamic mulligan against meta knowledge.
- **Boss encounters.** Hanging Hour fires at turn 4/5 per spec but the boss-specific Toll-the-Bell mechanic (per `bosses_v0.md`) is not modelled — Chapter-1 boss design is for narrative-content runs, not balance grid.
- **Map node weighting.** Sim is pure 1v1 deck-vs-deck. Reward-pick / Shrine / Rest economy doesn't apply.
- **Treatment / cosmetic state.** Per anti-P2W invariant, treatment_id has zero combat effect — sim ignores it entirely.
- **Warlord tier progression.** Sim runs at Tier-1 default passive only. Tier 2-4 variants are a v1 sweep once T1 baseline is stable.

---

## 5. Deliverables (when execution unlocks)

| # | File | Purpose | Owner |
|---|---|---|---|
| D1 | `c8_playtest_sim_charter.md` | This doc | Controller |
| D2 | `c8_ai_policy_v0.md` | AI heuristic policy spec (per §2.6) | Controller (next heartbeat) |
| D3 | `outputs/c8_sim_runner.py` | Python sim mirror (per §2.5 Route A) | Controller, gated on Paul Q1 Option-β endorsement |
| D4 | `c8_results_v0.md` | Win-rate matrix + faction balance + flag dispositions | Controller, post-run |
| D5 | Tuning recommendations | Per matchup with delta >5pp from C7-v0.2 expected | Controller, post-run |

**D3 is the gated deliverable.** D2 (AI policy) is heartbeat-authorable in the next cycle if Paul wants the charter to keep moving without endorsing Option β yet — the policy doc is grid-agnostic.

---

## 6. Execution gates (recap from C7-v0.2)

This charter unlocks when:
1. **Paul Q1 disposition** — endorse Option β (D2 counter swap) OR pivot to Option γ (accept asymmetry) per `c7_v0_2_balance_audit.md` §2.
2. **B2 build playable in editor** — already cleared per backlog B2.1–B2.10 all `[x]`. Paul-confirm `[e2e_smoke_test] PASS` in editor console satisfies this gate.

If only Q1 is outstanding, D2 (AI policy) is still heartbeat-authorable. D3 (sim runner) needs both gates.

**Paul Q7 in C7-v0.2 itself** — "should C8 run a 30-game sim or defer until B2 build is playable?" — this charter argues YES, run the sim, Route A first; B2 build playability is already met. Defer-to-build is the Route B argument and not recommended at v0.

---

## 7. Open questions (this charter)

1. **Game count per matchup.** 30 games chosen for tractability (3,150 total games ≈ 5 min wall-clock). Statistical confidence on a 50% true win-rate with n=30 is ±18% at 95% CI — wide for borderline matchups. Should v0 sim raise to 100 games per matchup (±10% CI, ~17 min wall-clock) for tighter bounds on the close calls? Recommendation: **stay at 30 for v0, escalate to 100 only for matchups flagged borderline in the v0 results.**

2. **AI policy parity.** Should both seats use the same policy module, or should opponent use a "naive" policy (random-play-highest-cost) while player uses the spine-aware policy? Mirror-policy gives matchup signal; asymmetric-policy gives "Player skill matters" signal. Recommendation: **mirror-policy for v0, asymmetric for v1.**

3. **Mulligan complexity.** Opening-hand 2-cost-required is one rule. Should v0 also enforce "redraw if no spine-card by turn 4 of drawn cards"? Recommendation: **keep v0 to the one mulligan rule; over-engineering opener heuristics hides true card-strength signal.**

4. **Random-seed scheme.** Per §2.4, seeds = `matchup_index × 1000 + game_index`. Fine for reproducibility. Should we also publish a "seed-sweep" sub-run that re-uses the same 30 seeds across all 105 matchups, so that variance in player-1's opening hand is held constant matchup-to-matchup? Recommendation: **stage 2 nice-to-have; not v0.**

5. **TAUNT engine wiring assumption.** E1 (TAUNT engine wiring + `.tres` tagging) is marked DONE in backlog but Paul has not yet confirmed `[turn_engine_test] PASS` in editor. Does the sim assume TAUNT is wired (per spec) or fall back to no-TAUNT (per pre-E1 grid)? Recommendation: **assume TAUNT wired per spec; rerun the v0 sim with no-TAUNT as a control if Paul reports the test fails.**

6. **Phase 2.9 keywords scope.** PERSIST (M1) + Hanging Hour × Persist (M4) + Glean (M3) are all design-spec-only — engine wiring not yet attempted (no E-series item filed). Should v0 sim model Persist? Recommendation: **YES, Persist materially shifts Resurrect-Spam (B2) and Sacrifice (A2, C3) win-rates. Skipping it underestimates Mourners faction power.**

7. **Output format.** `c8_results_v0.md` should follow what template? Recommendation: **same template as `c7_v0_2_balance_audit.md` — section per emergent flag + recommendation table + open Qs. Familiar to the next heartbeat that reads it.**

---

## 8. Downstream implications

- **No card adds, no `.tres` edits at C8 charter level.** This is pure spec.
- **D2 (AI policy doc) is the next heartbeat-actionable item** — grid-agnostic; can author while Paul disposes Q1.
- **D3 (sim runner Python) is the gated heartbeat-actionable item** post Q1 endorsement.
- **B-series engine wiring (E1 already done, E2/E3 not yet filed) sits underneath this.** Sim assumes spec-compliant wiring; if engine drifts, sim mirror drifts with it (same pattern as B2.7 turn_engine_test + Python mirror).
- **M8/M9/M10 narrative content runs in parallel — unblocked by C7-v0.2.** C8 is a feedback loop on balance, not a gate on content authoring.

---

— Controller, 2026-05-27 01:20Z (hourly backlog cycle #9)
