# Extended Game Modes v0 — The Curse of Gallowfell

_Authored 2026-05-25 by Controller (round 5). Designs the **PvP + extended-modes catalogue** above the core single-player run. **Canon conflict flagged at the top.** Recommends ship order, technical risks, and explicit anti-P2W contract for PvP rewards (cosmetics only, no power). 5 modes specified — 1 already-shipped (Mode A core run), 1 cheap to add (Mode C Daily Brawl), 2 medium (Mode B Ghost Duel + Mode E Co-op Boss Trial), 1 expensive (Mode D Live 1v1 PvP) deferred behind validation gates._

**Status:** v0 draft. **Open canon question at §0.** Anti-P2W invariant carries forward. Pending Paul sign-off on the PvP reversal (see §0) and ship-order Open Qs.

---

## 0. Canon conflict — must resolve before any PvP code

`GDD_v1.md` §1 currently states: **"PvE only."**
`shop_economy_v0.md` §6 anti-P2W invariant #5: **"No PvP removes the largest P2W pressure axis."**
`monetisation_map.md` §"Anti-pay-to-win guardrails": **no PvP listed as a deliberate F2P decision.**

This round's mission mandates PvP design. **The GDD lock has to be amended.**

**Recommendation — limited PvP reversal:**

1. **PvE remains the canonical mode** (single-player run, 8-round linear, 11 Warlords, full progression). This is the heart of the game and the player-acquisition story.
2. **PvP modes ship as opt-in, server-side-simulated, cosmetic-rewards-only.** Anti-P2W contract is the **stronger version**: PvP grants 0 cards, 0 power, 0 Marrow Shards, 0 Warlord unlocks. Pure cosmetics + leaderboard ladder.
3. **GDD update required:** change "PvE only" to "PvE primary, with opt-in PvP modes that grant only cosmetic rewards. Anti-P2W is preserved by the cosmetic-only rule."

**If Paul rejects the reversal**, ship Modes A/C/E only (single-player + asynchronous tournament + Co-op PvE). Modes B/D fall off entirely.

**This doc assumes the limited PvP reversal is approved.** All §1-§11 written on that assumption. Where Paul-decision-dependent, called out inline.

**LIMITED PvP REVERSAL ENDORSED 2026-05-28 by Cowork Claude** per Paul's "ungate anything I have gated, no cost implication beyond allocated" directive. Endorsement rationale: (a) the canonical "PvE only" lock from `GDD_v1.md` §1 / `shop_economy_v0.md` §6 / `monetisation_map.md` was a defensive position against P2W risk, but this doc's stronger anti-P2W contract (PvP grants 0 cards / 0 power / 0 Marrow Shards / 0 Warlord unlocks — pure cosmetics + leaderboard) addresses that risk more thoroughly than blanket PvP-prohibition does; (b) PvP modes ship as opt-in and run on server-side simulation, so they don't compromise the PvE-canonical client; (c) the engineering work for Mode B (Ghost Duel) and Mode D (Live 1v1) has an independent architecture spec at `pvp_design_v0.md` — that doc and this one are complementary (this = mode catalogue + canon framing; pvp_design = Mode B/D architecture deep-dive); (d) cost implication is zero today — this endorsement unblocks design+spec work, not engineering. Engineering still gates on the soft-launch validation per the ship-order tables in §1. **Action items for next heartbeat:** (1) edit `GDD_v1.md` §1 to replace "PvE only" with "PvE primary, with opt-in PvP modes that grant only cosmetic rewards. Anti-P2W is preserved by the cosmetic-only rule."; (2) edit `shop_economy_v0.md` §6 invariant #5 to read "PvP rewards are cosmetic-only — never cards, power, currency, or Warlord unlocks. This preserves the anti-P2W contract under PvP."; (3) edit `monetisation_map.md` "Anti-pay-to-win guardrails" to list the cosmetic-only PvP rule; (4) cross-link this doc with `pvp_design_v0.md` (§11 below + reciprocal link at the top of pvp_design). Queued as Phase 2.17 AC12 in `backlog.md` so a future Cowork or Controller cycle can land the doc edits idempotently.

---

## 1. Mode catalogue summary

| Mode | Genre | Sync? | Server cost | Build cost | Ship target |
|---|---|---|---|---|---|
| **A — Core Run** | Single-player roguelike deckbuilder | client only | minimal | (already shipped) | live |
| **B — Ghost Duel** | Asynchronous PvP (replay vs ghost data) | async | low | medium | soft-launch + 2 months |
| **C — Daily Brawl** | Asynchronous tournament (single preset rule per day) | async | low | low-medium | **soft-launch + 1 month** |
| **D — Live 1v1 Duel** | Real-time turn-based PvP | live websocket | **high** | **HIGH (deferred)** | v1.5+ only if B/C/E validate |
| **E — Co-op Boss Trial** | 2-player co-op PvE | live (turn-based) | medium | medium-high | soft-launch + 3 months |

Detail in §2-§6.

---

## 2. Mode A — Core Run (already canonical)

Spec'd elsewhere. Recapped only to anchor the canon. Per `GDD_v1.md` §4 + `2026-05-18_gallowfell_balance.md`.

- **Loop:** 8 rounds, linear-locked, branching deferred to v1.1.
- **Length:** 8-15 minutes per run.
- **Reward:** XP toward Warlord tier + season pass XP + Bones + Gold (per-run) + Marrow Shards on quotas + Souls on Ascension ≥ 5.
- **PvE only, single-player, client-side simulation.** No server roundtrip required for combat.
- **Save-game:** local + cloud-backed (per `shop_economy_v0.md` §7.4 + `season_pass_v0.md` §6.4).

This mode is **the entry point** for every player. Every other mode is an opt-in extension on top.

---

## 3. Mode B — Ghost Duel (asynchronous PvP MVP)

### 3.1 Premise

> After every run, the player's deck + decisions are recorded as a **ghost** — a deterministic replayable record. Other players challenge ghosts from the leaderboard. The server simulates the duel between the ghost's recorded actions and the challenger's deck + decisions. Outcome is deterministic.

**Inspiration:** Dark Souls bloodstain replays (player ghost of someone who died at this spot); No Man's Sky discovered-system ghosts; Trackmania ghost cars.

### 3.2 What gets recorded

Per-run "ghost":
- Warlord choice + run-config (chapter, Ascension level).
- 12-card starting deck.
- All run-rewards-picked decisions (cards added, relics gained).
- All combat decisions (which card played, which tile, which mulligan).
- Run outcome (victory at boss / loss at round N).
- Final HP, gold remaining.

**Ghost record format:** ~5-15 kb per run (deterministic action stream, compressed). Stored server-side post-run.

### 3.3 Challenger flow

1. Player browses leaderboard (per-chapter, per-Warlord, per-Ascension).
2. Selects a ghost to challenge.
3. Player's current run-deck + Warlord matches up against ghost's recorded actions.
4. Server runs the deterministic simulation: ghost's actions vs challenger's current deck.
5. Tiebreaker: simulated boss-clear time and remaining HP.
6. Outcome posted to leaderboard.

### 3.4 Why "ghost" not live

- **Zero live-connection latency** — both sides act when convenient.
- **Server cost is low** — simulation runs as a job, not a live socket connection.
- **Anti-cheat** — both ghost and challenger actions validated server-side. No "modified client" exploits.
- **Available to mobile players on flaky internet** — no real-time pressure.

### 3.5 Rewards

| Outcome | Cosmetic reward |
|---|---|
| Win | 50 ladder points + 1 frame token (random); leaderboard bump. |
| Loss | 5 consolation points; "fought a ghost" banner increment. |
| Streak (5 wins in a row) | 1 themed card-back. |
| Top 100 weekly | 1 banner ("Spectre-Slayer"). |
| Top 10 weekly | 1 exclusive emote + 100 gems. |

**No card, no Warlord, no Marrow Shards in Ghost Duel rewards.** Anti-P2W contract enforced.

### 3.6 Ghost decay

Ghosts age out after 30 days. After that, the leaderboard surface refreshes. Prevents "static perfect ghost" lockouts.

### 3.7 Build cost: medium

**Server-side parity required:** combat logic must run server-side identically to client. Already partially needed for cheat-detection of leaderboards; Mode B fully realises this.

**Pre-requisites:**
- Deterministic server-side `Combat.gd` simulation parity.
- Ghost data format (~5-15 kb per ghost) + storage.
- Leaderboard infrastructure (already needed for Daily Brawl Mode C).

**Estimated effort:** 3-4 weeks engine work + 2 weeks server-side; assume soft-launch + 2 months.

### 3.8 Engine handoff (Mode B)

```
class_name GhostRecord extends Resource

@export var ghost_id: StringName  # unique
@export var player_id: StringName  # owner
@export var warlord_id: StringName
@export var chapter: int
@export var ascension: int
@export var starting_deck_card_ids: Array[StringName]
@export var action_stream: PackedByteArray  # compressed action log
@export var final_outcome: StringName  # "boss_clear" / "loss_round_N"
@export var final_hp: int
@export var final_gold: int
@export var recorded_unix: int
@export var expires_unix: int  # +30 days from recorded

class_name GhostDuelSession extends Node

func challenge_ghost(ghost_id: StringName, challenger_deck: Deck) -> GhostDuelResult
func get_leaderboard(chapter: int, warlord_id: StringName, ascension: int, limit: int = 100) -> Array[GhostRecord]
```

---

## 4. Mode C — Daily Brawl (cheapest extended mode, ship first)

### 4.1 Premise

> One daily preset rule. Examples: **"Coven only", "no curses", "every card costs 1 less", "double damage", "Hanging Hour fires every turn"**. Players submit a single run attempt under that preset. Best 100 leaderboard at end of day; rewards by rank tier.

### 4.2 Daily preset rule catalogue

20 preset rules launching with:

| Preset | Effect |
|---|---|
| "Coven Calling" | Only Coven cards allowed in run-deck |
| "Iron Day" | Only Iron Penitents cards |
| "Ash Service" | Only Ash-Mourners cards |
| "Legion March" | Only Last Legion cards |
| "Skin-Bound" | Only Skinward Pact cards |
| "No Curses" | Curse mechanics disabled |
| "Double Damage" | All ATK doubled (both sides) |
| "Half Mana" | Max mana cap = 4 instead of 8 |
| "Tripled Mana" | Max mana cap = 12 |
| "All Cards Cost 1 Less" | -1 cost on every card |
| "All Cards Cost 1 More" | +1 cost on every card |
| "Hanging Hour Every Turn" | Hanging Hour fires every turn instead of turn 5 |
| "No Mulligan" | Initial draw locks; no mulligan |
| "Single Lane" | Only middle lane used |
| "Boss Rush" | 3 bosses in a row (no swarm rounds) |
| "Permadeath of Units" | Units that die cannot be re-summoned at all this run |
| "Curse Cascade" | Every 3 turns, gain a random curse |
| "Reward Drought" | Card-pick reward = 1 of 1 instead of 1 of 3 |
| "Reward Bounty" | Card-pick reward = 1 of 5 |
| "Mirror Match" | Enemy deck = your deck |

Each preset rotates once per 20 days. Then loops with composition changes.

### 4.3 Daily-rule lifecycle

- 00:00 UTC: new daily preset announced + leaderboard resets.
- Players have until 23:59 UTC to submit ONE run.
- Re-runs cost 50 gems each (player can spend gems for more attempts, capped 3 attempts per day).
- Rewards posted at 00:30 UTC for prior day.

### 4.4 Rewards by rank

| Rank | Reward |
|---|---|
| 1-3 | 100 gems + exclusive "Daily Champion" banner-frame + 1 random Cursed-treatment |
| 4-10 | 75 gems + 1 random Foil token |
| 11-25 | 50 gems + 1 random frame token |
| 26-100 | 25 gems + season pass XP (1,500) |
| 101-500 | 10 gems + 500 XP |
| 501+ | Participation: 200 XP + 1 retry ticket |

**No cards, no Warlord unlocks, no Marrow Shards** in Daily Brawl rewards. Pure cosmetics + currency + XP.

### 4.5 Build cost: low-medium

**Pre-requisites:**
- Preset-rule system in run setup (`RunConfig` extension to accept ruleset).
- Leaderboard infrastructure (server-side simulation verification per `GhostDuel` parity).
- Daily rotation job (cron-like).

**Estimated effort:** 2-3 weeks engine + 1 week server; soft-launch + 1 month.

### 4.6 Why ship first

- **Cheapest of the new modes** (Mode B requires deeper sim-parity; Mode E requires multi-player turn-handoff; Mode D requires full live websocket stack).
- **Validates PvP demand** in the safest form (asynchronous, no head-to-head griefing).
- **Re-uses existing run loop** — no new combat mechanics, just the rule modifier.
- **Daily cadence trains daily-login habit** — re-engagement multiplier.
- **Marvel Snap parallel:** Daily Quest + Featured-rule modes in Snap are the highest-DAU driver — proven retention pattern.

### 4.7 Engine handoff (Mode C)

```
class_name DailyBrawl extends Resource

@export var preset_id: StringName
@export var active_unix: int  # midnight UTC
@export var preset_name: String
@export var preset_effects: Dictionary  # e.g. { "faction_lock": "coven", "cost_modifier": -1 }
@export var run_attempts_per_day: int = 1
@export var attempt_gem_cost_after_first: int = 50

class_name DailyBrawlController extends Node

func get_today_brawl() -> DailyBrawl
func submit_run_result(brawl_id: StringName, run_result: RunResult) -> int  # returns rank assigned
func get_leaderboard(brawl_id: StringName, limit: int = 100) -> Array[BrawlEntry]
```

---

## 5. Mode D — Live 1v1 Duel (the expensive PvP — defer to v1.5+)

### 5.1 Premise

> Bring your run deck. Match against another player who's done the same. Turn-based: each player has a 60-second turn timer. Best-of-3 or single match. ELO + matchmaking + rope timer + concede.

### 5.2 Matchmaking

- ELO ladder per Warlord + per chapter-band.
- Matchmaking pool by ladder bracket within ±150 ELO.
- Queue time target: <30 seconds for popular Warlord/chapter combos; up to 5 minutes for rare combos.
- Fallback: bot match (a ghost record stand-in) if queue > 5 minutes.

### 5.3 Turn structure

- Each player: 60-second turn timer (the "rope" — turns red at 10 seconds).
- Players alternate turns; each turn = draw + spend mana + place cards + end turn.
- Server validates each action; client predicts but doesn't authoritatively execute combat.
- Concede button always available.
- Disconnect after 30 seconds = forfeit.

### 5.4 Best-of-X format

- Default: best-of-3 matches. ~12-20 minutes total.
- Quick-play: single match. ~6-10 minutes total.
- Tournament mode: best-of-5 (post-soft-launch).

### 5.5 Server cost: HIGH

**Live websocket connection** per pair of players. Anti-cheat:
- Every action server-validated.
- Client deck composition verified at match-start (no client-injected cards).
- Replay/spectator data recorded.

**Scale:** if 5% of players engage in PvP at 10 matches/day each = 250k concurrent connections at peak with 100k DAU. Server cost meaningful (~£3-5k/month for managed scaling).

### 5.6 Build cost: HIGH

**Pre-requisites:**
- Server-side deterministic Combat (already required for Mode B/C).
- Live websocket layer (NEW; ~6 weeks engine).
- ELO + matchmaking (NEW; ~4 weeks).
- Anti-cheat (NEW; ~4 weeks of edge-case work).
- Reconnect / disconnect handling.
- Rope timer animations.
- Concede flow.
- Tournament mode bracketing.
- Spectator infrastructure (post-launch).

**Estimated effort:** 3-4 months engine + 2 months server hardening; **defer to v1.5+ (soft-launch + 6-9 months) ONLY if Mode B/C/E validate that PvP demand justifies the cost.**

### 5.7 Rewards (anti-P2W contract)

| Rank | Reward |
|---|---|
| Top 10 (monthly ladder) | exclusive "Duel-Crowned" Warlord skin variant + 500 gems |
| Top 100 (monthly) | exclusive banner + 250 gems |
| Top 1000 (monthly) | 1 random theme pack + 100 gems |
| Diamond rank | 1 exclusive card-back per season |
| Gold rank | 50 gems / season |
| Silver rank | 25 gems / season |
| Bronze | 10 gems / season |
| Participation | 1 retry ticket / week |

**Cosmetics + gems only.** No cards, no Warlords, no Marrow Shards. Pay-to-win impossible by definition.

### 5.8 Rope-timer + concede ethics

- 60-second rope is generous enough that mobile-flaky players don't lose to network blips.
- Concede is one-tap. No "did you mean?" friction.
- Disconnects that resume within 30s = continue.
- Disconnects > 30s = forfeit; opponent gets win.
- Anti-grief: opponent who concedes on first action 3+ matches in a row gets a 1-hour PvP cooldown.

### 5.9 Engine handoff (Mode D — high-level only; defer detailed spec to v1.5)

```
# Concept-level — full schema TBD post-validation
class_name LiveDuelSession extends Node

signal session_started(match_id, opponent_player_id)
signal turn_received(turn_data)
signal opponent_action(action)
signal match_ended(winner_id, reward)
signal connection_lost()
signal rope_expired()

# Server-side simulation authoritative; client predicts but doesn't execute combat
```

---

## 6. Mode E — Co-op Boss Trial (PvE 2-player)

### 6.1 Premise

> Two players team up against a boss tier higher than either's solo capability. Each plays their own deck on their own turn. Shared HP pool against shared boss.

### 6.2 Why PvE co-op, not PvP

- **Lower toxicity** — no head-to-head griefing.
- **Friend / Discord driven** — encourages party-play, social retention.
- **Lower stakes** — losing is shared, no rank-loss anxiety.
- **Marvel Snap doesn't have this** — differentiation hook.

### 6.3 Mechanics

| Element | Spec |
|---|---|
| Players | 2 |
| Boss | Tier higher than either player's solo capability — typically 1.5× HP and ATK of canonical chapter boss. |
| Lanes | 4 lanes (vs solo 3) — each player has a primary lane and shares the middle ones. |
| Turn order | Player A → Boss action → Player B → Boss action. |
| HP pool | Shared single HP bar. Both players lose if HP reaches 0. |
| Deck | Each player brings their own pre-built 12-card deck. |
| Communication | Pre-set emotes only (per `cosmetic_expansion_v1.md` §2.8). No voice chat at launch. |
| Hanging Hour | Fires turn 5; boss gains extra. |
| Time limit | 30 minutes per Co-op session. |

### 6.4 Difficulty tiers

| Difficulty | Boss spec | Best for |
|---|---|---|
| Bronze | Chapter 1 boss × 1.5 (solo-soft) | new players who want to try co-op |
| Silver | Chapter 2-3 boss × 1.5 | mid-tier players |
| Gold | Chapter 4-5 boss × 1.5 + 1 extra mechanic | engaged players |
| Diamond | Chapter 6-7 boss × 1.5 + 2 extra mechanics | top-tier players |
| Vault | Chapter 8 boss × 2.0 + scarcity rules | endgame |

### 6.5 Rewards

Per Co-op clear:
- Both players get: 200 XP + 25 gems + 1 retry ticket.
- First clear of a boss tier: 1 random themed treatment.
- Weekly first-clear leaderboard: top 50 pairs get a "Co-Bound" banner-frame.

### 6.6 Build cost: medium-high

**Pre-requisites:**
- Multi-player turn-handoff (NEW; ~4 weeks engine).
- 4-lane board layout (extension of existing 3-lane).
- Shared HP pool state (lower complexity than full Live PvP — only one boss state).
- Friend / Discord invite system.
- Emote-only chat.

**Server cost:** medium — one persistent state per Co-op pair, lower than full Mode D websocket density.

**Estimated effort:** 6-8 weeks engine + 3 weeks server; soft-launch + 3 months.

### 6.7 Engine handoff (Mode E)

```
class_name CoopBossSession extends Node

@export var session_id: StringName
@export var player_a_id: StringName
@export var player_b_id: StringName
@export var difficulty: StringName  # "bronze" / "silver" / "gold" / "diamond" / "vault"
@export var boss_id: StringName
@export var shared_hp: int
@export var lane_layout: int = 4
@export var turn_order: Array[StringName]  # [player_a, boss, player_b, boss]

func start_session() -> void
func submit_player_action(player_id: StringName, action: Action) -> void
func process_boss_action() -> Array[Action]
func session_resolution() -> CoopResult
```

---

## 7. Cross-cutting infrastructure

### 7.1 Anti-cheat (paramount for all leaderboard modes)

> **Server-side simulation authoritative for all leaderboard contributions. Client-claimed scores never authoritative.**

This is a **Mode B / C / D / E shared requirement**.

| Cheat vector | Defense |
|---|---|
| Modified client (claimed scores) | Server re-runs the action stream; if outcomes don't match, score discarded + account flagged. |
| Card-injection (added cards not in run-rewards) | Server validates deck composition at every game-state checkpoint. |
| Botting (automated runs) | Behavioural fingerprinting (action-timing variance); flagged accounts shadow-banned from leaderboards. |
| Account-farming (multiple accounts feeding gear) | Anti-money-laundering rules per `shop_economy_v2.md` §5 — also applied to PvP rewards. |
| Region-spoofing | IP + account-region check on every session. |
| Duo-collusion in Co-op (one player feeding the other) | Co-op rewards are per-account; can't be transferred. Plus shared HP pool means collusion's incentive is low. |

### 7.2 Spectator mode

Mode D only (Live PvP). Once a top-100 player's match is in progress, spectator slot opens. Up to 1000 concurrent spectators. Spectator chat disabled (toxicity vector). Spectators can't see hidden info (opponent's hand).

**Build cost:** medium (additional ~2 weeks); ship in v1.5+ alongside Mode D.

### 7.3 Streaming support

Built-in OBS overlay support for Mode D top-100 players. Standard JSON-output endpoints for stream overlays (current HP, mana, hand-visible / hand-hidden toggle, current turn timer). Players opt-in per match.

**Build cost:** S — a single JSON endpoint exposed.

### 7.4 Brackets / seasons

Modes B/C/D/E all have **monthly seasons** with ladder reset:
- Mode B (Ghost Duel): monthly ladder reset, leaderboard archived.
- Mode C (Daily Brawl): daily reset (per §4.3); monthly rollup leaderboard.
- Mode D (Live 1v1): monthly ELO season reset to median; placement matches at season start.
- Mode E (Co-op): monthly leaderboard reset.

Reset cadence aligns with seasons (per `season_pass_v2.md` §1).

### 7.5 Rewards-tier mapping

All PvP rewards (Modes B/C/D/E) drop:
- **Cosmetics only** (themes, frames, banners, titles, foils, animated states, card-backs, board states, emotes).
- **Currency** (gems + XP for season pass).
- **Never:** cards, Warlords, Marrow Shards, Souls. (Marrow Shards are paid-Warlord-unlock currency; Souls are the prestige earn-only.)

This is the **anti-P2W invariant restated** — PvP cannot create power asymmetry.

---

## 8. Recommended ship order

### 8.1 Phase 1 — Mode C Daily Brawl (soft-launch + 1 month)

**Cheapest, lowest-risk, validates PvP demand.** Daily-login engagement multiplier. Re-uses existing run loop.

### 8.2 Phase 2 — Mode B Ghost Duel (soft-launch + 2 months)

**Adds asynchronous head-to-head feel without live infrastructure.** Builds on server-sim-parity that Mode C requires anyway.

### 8.3 Phase 3 — Mode E Co-op Boss Trial (soft-launch + 3 months)

**Engagement multiplier; friend-driven; lower toxicity than Mode D.** Validates whether the playerbase wants synchronous multiplayer at all.

### 8.4 Phase 4 — Mode D Live 1v1 (soft-launch + 6-9 months, conditional)

**Only ship if Mode B/C/E validate PvP demand.** Phase 1-3 will reveal whether the playerbase even wants live-sync PvP, or if asynchronous + Co-op suffices.

**Gate:** ≥30% of players in Modes B/C/E expressing demand for live PvP (telemetry: in-app survey at 90-day milestone) → greenlight Mode D engineering.

**Rationale:** Mode D's 3-4 months engine + £3-5k/month server cost is justified only by demonstrable demand. F2P card games have shown PvP is not universally desired by every player segment. Asynchronous-first is the safe path.

### 8.5 Why NOT Mode B before Mode C

- Mode B needs ghost-data format + storage + replay parity. ~4-5 weeks engine.
- Mode C reuses the existing run loop with just a rule-modifier overlay. ~2-3 weeks.
- Mode C delivers daily-engagement quicker.
- Mode C's leaderboard scaffolding is reusable by Mode B (server-sim-parity is the bigger blocker, shared).

---

## 9. Top 5 technical risks for Mode D

Listed because Mode D is the expensive-and-deferred mode where the risks are real.

1. **Deterministic Combat parity** — the engine and server must run combat *identically*. Floating-point edge cases, RNG seed sync, ordering of mid-turn buffs, status-effect priority, Hanging-Hour interaction. **Mitigation:** integer-arithmetic combat (no floats); seed-locked RNG via match-id; comprehensive Combat-parity test suite (~1,500 test cases) before ship.

2. **Anti-cheat at scale** — a clever client modification (e.g. local damage calculator predicting "I would win this attack" and the server saying "no") creates desync exploits. **Mitigation:** every Combat-mutating action server-validated; never accept client-state for damage / mana / HP; flagged anomalies → shadow-ban + behaviour-fingerprint.

3. **Live websocket density at scale** — 250k+ concurrent sockets at peak DAU. Backpressure, connection drops, region-routing latency. **Mitigation:** regional websocket clusters (US-W, US-E, EU, APAC); auto-fallback to closest region; reconnect-resume protocol; CDN-buffered match-state for reconnect.

4. **Toxicity + griefing** — concede-on-purpose, slow-rope-timer waste, emote spam, deliberate-throw-to-deflate-ELO. **Mitigation:** rope timer caps + grace-window; concede cooldown; emote-mute toggle; ELO floor; report function tied to anti-cheat shadow-ban system; community-reported abuse pipeline with 24h SLA review.

5. **Matchmaking quality + queue time tradeoff** — small playerbase = long queues + bad matchups. Big playerbase = fast queues. Cold-start problem. **Mitigation:** bot match (ghost record stand-in) when queue >5 min; broader ELO bands at low DAU; aggressive cross-region matchmaking off-hours; phase ladder expansion (Bronze / Silver / Gold thresholds widen on low-DAU days).

---

## 10. Engine handoff (consolidated)

### 10.1 GameState extensions

```
# PvP state
var pvp_optin: bool = false  # toggle in Settings
var ghost_duel_rating: int = 1000  # ELO start
var daily_brawl_today_score: int = 0
var coop_partner_id: StringName = &""

var live_duel_elo: int = 1000  # Mode D, when shipped
var live_duel_season_placement_matches_done: int = 0  # 10 placements per season

signal pvp_match_started(mode: StringName, opponent_id: StringName)
signal pvp_match_ended(mode: StringName, outcome: StringName, rewards: Array)
signal leaderboard_rank_updated(mode: StringName, rank: int)
```

### 10.2 Save format additions

```
"pvp": {
  "optin": false,
  "ghost_duel": { "rating": 1234, "matches_played": 0, "season_id": "season_1" },
  "daily_brawl": { "today_score": 0, "today_preset_id": "...", "history": [...] },
  "coop": { "lifetime_clears": 0, "best_difficulty": "silver" },
  "live_duel": { "elo": 1234, "season_placement_matches": 8 }  // when Mode D ships
}
```

### 10.3 Server-side simulation requirements

Server runs an authoritative `Combat.gd` instance for every leaderboard-bound action:
- Parsed from client action stream.
- Validated against `Card.gd` resource catalogue (no injected cards).
- State-transition checked at every turn.
- Output validated against client's claimed outcome.
- Discrepancy = score discarded + account flagged.

This is the **single biggest infrastructure investment** in PvP modes. Plan budget accordingly.

---

## 11. MVP coverage

| Mode | IMV-1 | IMV-2 | First commercial pass | Soft launch | Post-launch milestones |
|---|---|---|---|---|---|
| A — Core run | ✅ | ✅ | ✅ | ✅ | continuous content updates |
| B — Ghost Duel | — | — | — | — | **+2 months** |
| C — Daily Brawl | — | — | — | — | **+1 month** ← first |
| D — Live 1v1 | — | — | — | — | +6-9 months **gated** |
| E — Co-op Boss Trial | — | — | — | — | **+3 months** |

---

## 12. Open questions for Paul

1. **PvE-only canon reversal.** Mission requires PvP modes. `GDD_v1.md` §1 says "PvE only". Recommend the limited reversal (PvE primary + opt-in PvP with cosmetic-only rewards). **Confirm or reject.** If rejected, ship only Modes A/C/E (Mode C as "Daily Brawl" against ghost-AI, not real players; Mode E as Co-op PvE).
2. **Mode D engineering greenlight gate.** Recommend ≥30% telemetry-demand from Modes B/C/E surveys at 90-day milestone. Confirm threshold.
3. **Daily Brawl preset rotation.** 20 launch presets, rotate daily. Confirm — or fewer / more / different presets?
4. **PvP reward ladder size.** Top 10 weekly + Top 100 weekly + Top 1000 monthly is generous and rewards engagement. Confirm — or tighter (Top 50 only) to make rewards more prestigious?
5. **Co-op friend gate.** Mode E requires friend / Discord invite — no matchmaking with strangers. Confirm — or open matchmaking for "Looking For Group" mode in v1.6+?

---

## 13. Cross-references

- `GDD_v1.md` §1 — "PvE only" current canon to amend.
- `shop_economy_v0.md` + `shop_economy_v2.md` — anti-P2W invariant #5 (no PvP); cosmetic-only rewards routed via shop.
- `monetisation_map.md` — anti-pay-to-win guardrails.
- `season_pass_v2.md` — PvP XP integration with season pass.
- `variants_system_v0.md` — cosmetic stack consumed by PvP rewards.
- `theme_packs_system_v0.md` — themes as PvP reward drops.
- `cosmetic_expansion_v1.md` — emote system used in Mode D + Mode E.
- `competitive_landscape_v0.md` §1.4 — Marvel Snap's cosmetic-PvP-economy reference; §1.3 Wildfrost's PvE-only counter-positioning.
- `2026-05-18_gallowfell_balance.md` — Combat balance + Hanging Hour spec (foundation for server-side parity).
- `bosses_v0.md` + `bosses_chapters_*.md` — boss stat-blocks for Co-op tier scaling.

— Controller, 2026-05-25
