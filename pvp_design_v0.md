# PvP design + architecture — v0 draft

**Status:** v0 draft authored 2026-05-26 by Cowork Claude. **Not yet locked.**
Captures the scope, architecture, and phasing required to add a player-vs-
player mode to *The Curse of Gallowfell*. Written cold from the live codebase
+ `gdd_v0.md` + `internal_mvp_scope.md` + `HOW_TO_TEST.md` so any Claude or
Paul can pick it up without context.

> **Why now.** Paul flagged the need to "build a PvP environment to allow
> players to test their decks and play against friends, likely with sudo-
> competition type rewards" — but the current build is single-player roguelike
> PvE (Slay-the-Spire-shaped), and PvP is **not in any current scope doc**
> (IMV-1 or IMV-2). This doc exists so that PvP gets the same disciplined
> scope-lock the IMV-1 build got, instead of slipping in ad hoc.

---

## 1. Premise — what PvP actually means here

The roguelike PvE loop (Title → Warlord → Map → Combat → Reward → repeat) is a
**single-player run** against the world. PvP is a fundamentally different
*shape* of session that shares the *same card pool and rules engine* but
**not** the run/reward loop.

The minimum sensible PvP unit of play is:

- Two players each choose a Warlord + a 12-card deck (constructed outside
  the roguelike run).
- They play a single match — fixed-length lane combat, same engine — against
  each other instead of against waves of AI enemies.
- Match resolves with one winner. Both decks return intact (no per-run
  attrition; PvP is **not** roguelike).

**Anti-goals (explicit non-features for the first pass):**

- ❌ Real-time async live netcode with sub-100ms latency requirements
- ❌ Cosmetic-monetised ladders / pay-for-cosmetic-edge
- ❌ Cross-faction draft-style improvisation (PvP uses pre-built decks)
- ❌ Replacing PvE as the headline mode (PvE roguelike remains the core)

---

## 2. Phasing — what ships when

PvP is a **separate workstream** from IMV-1/IMV-2 and slots in after IMV-1's
"feel" gate passes. Three phases, each a sensible stopping point.

### Phase PvP-1 — Friend-only async (target: post-IMV-1 sign-off)

The minimum thing that fulfils Paul's stated ask ("test their decks and play
against friends"). Local-network or invite-code based, no public matchmaking.

- **Mode:** async turn-by-turn (each player submits their turn within e.g.
  24h; opponent then plays theirs). Avoids real-time netcode entirely.
- **Match shape:** single match, fixed 8-round structure mirroring PvE
  combat. No multi-game series.
- **Deck construction:** simple deckbuilder UI — pick Warlord, fill 12 slots
  from the unlocked card pool. Save + load named decks.
- **No rewards.** Wins/losses logged to a local file; nothing unlocked.
- **No ladder, no matchmaking.** Friend codes only.

**Why async first:** removes networking-realtime-fairness as a Phase-1
problem. Each player's turn is a deterministic submission; the opponent's
client validates + applies the result. Sync is "next turn available" pings.

### Phase PvP-2 — Open queue + casual play

After PvP-1 proves the match shape is fun.

- **Open matchmaking** — players queue, a server pairs them. Skill-bucketed
  (basic MMR) but no ranked rewards yet.
- **Sync option:** real-time turn-by-turn (≤60s per turn, on-clock).
- **Multiple match formats:** Bo1, Bo3.
- **Spectator mode** for friends watching live matches.

### Phase PvP-3 — Competitive ladder + "sudo-competition" rewards

Only after PvP-2 has 200+ logged matches to inform balance.

- **Ranked ladder:** bronze/silver/gold/etc., seasonal reset.
- **Rewards:** strictly **cosmetic-only** (see §6 anti-P2W invariant). Card
  treatments (foil/gold/ink/prism from the existing system), unique sleeves,
  emotes, profile flair, season-pass cosmetic unlocks.
- **Anti-collusion / anti-smurfing:** seasonal account-link gates, win-trade
  detection.

---

## 3. Rules engine — what changes vs PvE

The existing engine (`game/src/runtime/turn_engine.gd`) is already structured
as static pure functions over `Lane` resources — that's a near-perfect fit for
PvP because it means the same authoritative logic runs identically on both
clients given identical inputs. But several PvE-specific shortcuts need
**either preserving as PvE-only or generalising for PvP**:

| Subsystem | PvE today | PvP requirement |
|---|---|---|
| **Enemy spawns** | Map node defines a wave script; the game seeds + spawns enemies | PvP has *no enemies* in the PvE sense — both sides field *units played from hand* into lanes. Wave spawner is bypassed; enemy slot is the opposing player's units. |
| **Hand RNG** | Deck shuffled with run seed; deterministic but private | Must be **server-authoritative** in PvP (or each client commits a hash + reveals after) to prevent client-side reshuffling. |
| **Initiative** | PvE: player attacks first per turn (`_resolve_friendly_attacks_in_lane` before `_resolve_enemy_attacks_in_lane`) | PvP needs **alternating initiative** or a "both-resolve simultaneously" rule. Locked-in design choice — recommend alternating (less variance). |
| **Hanging Hour** | Boss trigger at turn 4 (per `keywords/hanging_hour_persist_v0.md`) | Mirror as a both-sides global trigger (e.g. turn 5 in PvP — less brutal without boss escalation). |
| **Persist / Resurrect** | Once-per-combat lock | Same rule per-side; mirror the locked-once logic per-player. |
| **TAUNT** (just-landed, this doc's sibling) | Single-side friendly redirect | Each player's TAUNT only redirects the *opposing* player's attacks against *their own* units. No cross-side interaction needed. |
| **Map / events / rewards** | Whole post-combat loop | **Disabled in PvP** — there is no map, no shop, no event picker, no reward screen. Match-over goes straight to result screen. |
| **Relics** | Run-modifying meta items | **Disabled in PvP-1.** Allowed in PvP-2/3 if and only if all relics are unlocked by both players (no pay-gated competitive advantage). |

### 3.1 Determinism contract

Every PvP match must satisfy: **given the same deck inputs + the same RNG
seed + the same play order, both clients produce byte-identical lane state
after every turn.** That's the only way client-validation works.

The engine already runs as static functions over passed-in `Lane` objects,
so this is largely true today — the work is:

1. **Audit `RandomNumberGenerator` usage** in the engine. Any `randi()` /
   `randf()` calls that take from the default global RNG break determinism
   under PvP. Replace with seeded RNG threaded through the turn-state.
2. **Lock float-arithmetic order** in the rare places it appears (e.g.
   range-tile calculations). GDScript's `int` math is already deterministic;
   anything `float` needs verification.
3. **Card data is content** — both clients ship the same `.tres` files; the
   server validates by `id` + version hash to prevent client tampering.

### 3.2 Authority model

**Phase PvP-1:** peer-to-peer with client-validation (each turn a struct of
"plays" submitted; opponent's client replays the turn through the engine and
checks state-after matches). Cheap, but doesn't prevent both-clients-cheat
collusion — acceptable for friend-match.

**Phase PvP-2+:** **server-authoritative.** A thin Godot-Headless server (or
even a serverless function) holds the canonical match state and runs the
engine; clients submit intents and receive deltas. Same engine code, just
hosted. This eliminates client tampering and is required before any ranked
ladder.

---

## 4. Deck construction (new feature, no PvE equivalent)

The PvE roguelike *picks* cards via map nodes — there is no "build a deck
ahead of time" UI today. PvP needs one:

- **Deck slots:** 12 cards (matches PvE deck size from `gdd_v0.md`).
- **Warlord lock:** picking a Warlord restricts the legal card pool to that
  Warlord's faction(s) — currently 3 in-faction Warlords + future neutral
  cards if the design allows.
- **Per-faction caps:** mirror PvE — if PvE has "no more than 2 copies of
  any card", PvP does too.
- **Save slots:** N named decks per player (suggest 8 to start).
- **Validation:** illegal decks (wrong size, banned cards, locked Warlord)
  rejected at submit.
- **Import/export:** decklist-as-string (base64 of card-id list) for sharing
  + bug-report attachment.

This is a **moderate UI build** (a deckbuilder scene + a deck-storage
resource). Reusable for future Conquest / draft modes.

---

## 5. Networking architecture

### 5.1 PvP-1 (friend-only async)

- **Transport:** invite-code based. Each player generates a code; the other
  pastes it; the game exchanges decks + match-id over a lightweight
  endpoint (Firebase / Supabase free tier, or a tiny self-hosted relay).
- **State sync:** turn-by-turn JSON blobs (the player's plays for that
  turn). ~5 KB per turn. No real-time pressure.
- **Connectivity:** turn submissions queued locally if the player is
  offline; reconciled on next connect.

### 5.2 PvP-2/3 (open + ranked)

- **Transport:** WebSocket to a Godot-Headless authoritative server.
- **Latency budget:** <300 ms turn-submit RTT acceptable (turn-based, not
  twitch).
- **Scaling:** match server is single-match-per-process; horizontal scale =
  just more server processes (each session is isolated).
- **Disconnect handling:** 30-second reconnect window; after that, the
  disconnected player concedes.

---

## 6. Rewards + anti-P2W invariant

The brief asked for "sudo-competition type rewards for X number of games
or X results we can determine later". This is the highest-risk area for the
game's existing **anti-P2W invariant** (`pipeline_spec.md`, `keywords/*.md`).

**Locked rule:** PvP rewards are **never** anything that affects gameplay.

| Reward category | OK in PvP? | Why |
|---|---|---|
| Card treatments (foil/gold/ink/prism) | ✅ yes | Visual-only; `card_view.gd` reads treatment_id; engine never branches on it |
| Card-back sleeves | ✅ yes | Visual-only |
| Emotes / avatars / banner flair | ✅ yes | Visual-only |
| XP toward seasonal cosmetic track | ✅ yes | Unlocks more cosmetics |
| New playable cards | ❌ no | Would gate competitive options behind ladder grind |
| Stat-boosting consumables | ❌ no | Direct gameplay edge |
| Extra deck slots | ⚠️ neutral | Convenience only; arguably fine |

**Practical reward shape for PvP-3:**

- "Play 5 PvP matches" → cosmetic profile flair
- "Win 10 PvP matches in a season" → seasonal foil treatment for a
  faction-themed card
- Reach Silver/Gold/etc. tier → tier-specific avatar/banner

All achievements log to the existing local save (extended for PvP).

---

## 7. Monetisation considerations

PvP-3 is the natural surface for the **battle pass** (already on the roadmap
in `monetisation_map.md`). The pass sells *cosmetic* tracks that PvP play
progresses faster than PvE play — that's the legitimate monetisation hook
without breaking the anti-P2W invariant.

What PvP **must not** do: sell ladder rank, sell deck slots that affect
competitive play, sell card unlocks that aren't available through normal
play. (These are common F2P PvP traps; this game's stated values reject
them.)

---

## 8. Engine + code surfaces affected

| Area | Today | PvP work |
|---|---|---|
| `game/src/runtime/turn_engine.gd` | Pure functions over Lane — already deterministic-shaped | Audit RNG; thread seeded RNG via turn-state; verify float ops |
| `game/src/data/card.gd` | Schema includes `is_starter`, `is_draftable`, no PvP flags | Add `is_pvp_legal: bool = true` for cards that should never appear in PvP (event-only effects, story cards) |
| `game/src/ui/card_view.gd` | Renders single-player hand cards | Add an "opponent's hand" stub (back-facing cards, count visible only) |
| `game/scenes/combat.tscn` | PvE combat scene | Variant `pvp_combat.tscn` that wires the opponent slot to the network adapter instead of the wave spawner |
| `game/src/runtime/run_controller.gd` | Roguelike loop | Add a sibling `pvp_match_controller.gd` for PvP-1 sessions; no map / rewards |
| **NEW:** `game/src/runtime/net/match_client.gd` | (does not exist) | Network adapter — friend-code transport in PvP-1, WebSocket in PvP-2 |
| **NEW:** `game/src/ui/deck_builder.gd` + scene | (does not exist) | Pre-match deckbuilder |
| **NEW:** server (PvP-2+) | (does not exist) | Godot-Headless auth server |

Estimated work distribution (no commitment to a number yet — Paul reviews
this doc first):

- PvP-1: **~3–4 weeks of focused dev** (deckbuilder UI + friend transport +
  PvE combat → PvP combat fork + result screen + RNG determinism audit).
- PvP-2: **~6–8 weeks** on top of PvP-1 (auth server + matchmaking + open
  queue + reconnect handling).
- PvP-3: **~4–6 weeks** on top of PvP-2 (ladder + season system + cosmetic
  reward plumbing + anti-collusion).

These are wall-clock-with-the-current-cadence estimates, not engineering
labour-hours, and they assume IMV-1 has shipped and is stable. Real numbers
require Paul to commit to the scope + the cadence.

---

## 9. Risks + open questions for Paul

1. **Does PvP belong in this game at all?** The IMV-1 scope doc was explicit:
   "PvE only, PEGI 12, free-to-play with microtransactions + battle pass."
   Adding PvP shifts the design footprint meaningfully and is roughly
   **2–3× the engineering surface of IMV-1**. The honest answer to "when can
   we test decks PvP?" is "after a deliberate scope-lock that says PvP is
   officially in." This doc is the first step of that.
2. **Friend-async vs real-time.** PvP-1 specs async — is that the right
   first-fun? Some players will want live play immediately. Counter-argument:
   async is far cheaper to ship, and "let me play 5 turns then come back
   tomorrow" is a legitimate mobile-friendly format.
3. **Cards locked behind PvE roguelike progression.** If a player has
   unlocked W4 Forge-Marshal Veska via roguelike play but their PvP opponent
   hasn't, is the match legal? Recommend: **no Warlord unlocks gate PvP** —
   all 11 Warlords are PvP-legal from the start, with the unlock systems
   only affecting PvE roguelike runs.
4. **Cross-platform parity.** iOS ↔ Android PvP is fine; iOS ↔ Web ? Locked
   down in PvP-2.
5. **EULA / TOS for PvP.** Player-vs-player adds moderation/abuse surface
   (reporting, mute/block, account suspension). Needs a TOS pass before
   PvP-2 (open queue) ships.
6. **The "sudo-competition" framing.** Paul's wording suggests rewards
   should *feel* meaningful without being competitively destabilising. The
   cosmetic-only path in §6 fits, but the actual reward cadence (how many
   wins = what reward) wants design + tuning playtest, deferred to PvP-3.

---

## 10. What this doc does NOT do

- Commit a delivery date.
- Pick a backend vendor (Firebase / Supabase / self-hosted Godot server —
  needs cost + ops review).
- Spec the deckbuilder UI in detail (separate v0 doc when PvP-1 unlocks).
- Spec individual achievements or reward cards.
- Address PvE-PvP card-balance divergence (some cards may need separate
  PvP balance numbers; tracked as a future design item once PvP-1 lands).

---

## 11. Recommended next step

**Paul reads this doc and decides:**

1. Is PvP in? If yes, slot PvP-1 as a workstream **after IMV-1 ships and the
   "feel" gate passes**. If no, archive this doc and move on — at least the
   thinking is captured if it comes back later.
2. If PvP-1 is in: who owns the deckbuilder UI design + the network transport
   choice? Both are blocker-shaped before any engine work begins.
3. Confirm the §6 anti-P2W reward ceiling is acceptable (cosmetic-only).

Until that happens, this doc stays v0 / draft and **nothing in `game/`
changes for PvP.** PvE roguelike (IMV-1 → IMV-2) remains the focus.

---

*Authored autonomously by Cowork Claude to unblock the recurring "when can we
PvP test?" question without further Paul-time. Edit the rough edges as needed
— this is a starting point, not a verdict.*
