# Actionable Components — 2026-05-22

_Authored 2026-05-22 by Controller (round-4 readiness agent). Phone-readable sorted to-do list pulling: round-2 inventory outstanding items + round-3 wobbles + Phase G mobile spec + competitive-landscape synthesis + Paul's "real-world graphic testing soon" pressure. Ranked by blocks-graphic-testing × effort × needs-Paul × priority._

**Status:** v0. Read in 3 min on mobile. Pick top P0s to action next.

---

## Legend

| Column | Values |
|---|---|
| **Blocks GT?** | Y/N — does this block the "real-world graphic testing" milestone (M1 placeholder ship)? |
| **Eff** | S = ≤1 day / M = 2-5 days / L = 1-3 weeks |
| **Paul?** | Y/N — does this need Paul's decision/action before Cowork/.151 can move? |
| **Pri** | P0 = soft-launch-critical / P1 = strong-want / P2 = nice-to-have |

---

## P0 — soft-launch-critical (do these first)

| # | Item | Blocks GT? | Eff | Paul? | Source |
|---|---|---|---|---|---|
| 1 | **Run B3.0a SDXL smoke test on RunPod** — single Iron-Penitent render, tick 6-point acceptance | **Y** | S | **Y** | art_pipeline_readiness_v0 §8 |
| 2 | **Extend placeholder fallback in `card_view.gd` to Warlord + Boss + Event views** — no missing-texture errors anywhere | **Y** | S | N | art_pipeline_readiness §7 M1 |
| 3 | **Approve M1 placeholder-ship acceptance criteria** — play full run with no asset errors | **Y** | S | **Y** | art_pipeline_readiness §7 M1 |
| 4 | **Tutorial flow live UX validation** — paper spec is not enough; need 5 real users on phones | N | M | partial | competitive_landscape §2.3 |
| 5 | **Mobile UX touch-test with 5 users** — catch fat-finger / readability / hit-region failures | N | M | partial | competitive_landscape §2.3 |
| 6 | **Card balance audit confirmed by 10+ runs telemetry** — patch top 5 outlier win-rates | N | M | N | competitive_landscape §2.3 |
| 7 | **Author 3 missing card art specs (C41 / C42 / P41)** — half a Cowork heartbeat | partial | S | N | art_pipeline_readiness §2.2 + ART_INTEGRATION §1 |
| 8 | **Author 8 boss art specs** — currently only prose in `bosses_*.md` | N (M2) | M | N | art_pipeline_readiness §2.2 |
| 9 | **Author 7 owed token art specs** (TKN-2, 3, 7, 8, 9, 10, 11) | N (M2) | M | N | tokens_v0 §5 + art_pipeline_readiness §2.2 |
| 10 | **Author 6 board background specs OR commit to tinted-tilemap placeholder** | N (M2) | M | **Y** (decision) | art_pipeline_readiness §2.2 |
| 11 | **Unblock git OneDrive lock contention** — pending P0 item #16 in task list | partial | S | partial | task list #16 |
| 12 | **Commit CANON_PATCHES_APPLIED + deliverables 2-4 once git unblocked** | N | S | N | git_unblock_oneliner.md |
| 13 | **TAUNT E1 wiring + assertion test** — 6 cards tagged, 3 new turn_engine_test assertions | N | S | N | inventory GP-3 |
| 14 | **Anti-stall / mana-flood rule** — after turn 12, +1 dmg/turn from curse closing in | N | S | **Y** (sign-off) | inventory GP-5 |
| 15 | **Engine field `Card.token_spawn_cap_per_combat` + `Combat.spawn_token()` cap check** — per CANON_PATCHES_APPLIED W1 | N | S | N | CANON_PATCHES_APPLIED §"Files NOT patched" |
| 16 | **Engine field on Vyrrun Self-Scourge for +6 ATK/combat cap** — per CANON_PATCHES_APPLIED W2 | N | S | N | CANON_PATCHES_APPLIED §"Files NOT patched" |
| 17 | **Engine wiring: W11 unlock fires at Ch8 boss clear (not Ch3)** — per CANON_PATCHES_APPLIED W3 | N | S | N | CANON_PATCHES_APPLIED §"Files NOT patched" |
| 18 | **Audio production — render at least placeholder leitmotif tracks (5 factions + Hanging Hour sting)** | N | M | partial | competitive_landscape §2.3, audio_production_brief |
| 19 | **Soft-launch playtester recruitment in PH/CA/NZ** — start cohort outreach | N | M | **Y** | competitive_landscape §2.1 #9 |
| 20 | **Settings / Options screen** — sound, haptics, graphics, accessibility | N | S | N | inventory INT-4 |
| 21 | **Pause / phone-call resume — serialize Combat on app pause** — mobile reality | N | S | N | inventory INT-6 |
| 22 | **GP-1 keyword resolver — CLEAVE / PIERCE / FEAR / ROOT / SLOW / SMOKE / DREAD / SHIELD** | N | L | N | inventory GP-1 |
| 23 | **GP-8 Hanging Hour visual + audio cue spec** — single most evocative beat | partial | S | N | inventory GP-8 |
| 24 | **Run-victory boss path + chapter complete state** | N | M | N | inventory GP-6 |
| 25 | **Mulligan v1 — strategic, not free reroll** | N | S | **Y** (rule sign-off) | inventory GP-7 |

## P1 — strong-want (do these after P0)

| # | Item | Blocks GT? | Eff | Paul? | Source |
|---|---|---|---|---|---|
| 26 | **Battle Pass 50-tier reward inventory (free + premium tracks)** — single biggest missing spec for £4.99 SKU value | N | L | partial | inventory BP-1 |
| 27 | **Ancestor Tree meta-progression (30-40 nodes, Bones-priced)** — "what does Bones unlock" answer | N | L | N | inventory UPG-1 |
| 28 | **Relic catalogue — 30 relics for IMV-2 minimum** | N | L | N | inventory UPG-5 |
| 29 | **Per-card mastery / catalogue progression (per-card XP)** | N | M | N | inventory UPG-2 |
| 30 | **Card-inspect modal (hold-to-zoom)** — small phone screens | N | S | N | inventory INT-2 |
| 31 | **Hand fan + auto-arrange (replace flat HBoxContainer)** | N | M | N | inventory INT-3 |
| 32 | **Faction-mixing in starter decks** — Monster Train's central lesson | N | M | N | competitive_landscape §2.1 #6 |
| 33 | **Daily challenge content runway — 7 days authored** | N | M | N | competitive_landscape §2.4 + inventory GP-10 |
| 34 | **Faction sigils S2-S5 (heartbeat queue)** — 4 sigils outstanding | partial | M | N | ART_INTEGRATION §2 + art_pipeline_readiness §2.2 |
| 35 | **Warlord Ascension full A1..A20 ladder** — StS convention | N | M | N | inventory UPG-4 |
| 36 | **In-run shop catalogue + pricing + rarity weights** | N | M | N | inventory SHOP-3 |
| 37 | **IAP price ladder + bundle compositions** — soft launch needs concrete SKUs | N | M | partial | inventory SHOP-4 |
| 38 | **Live-ops bundle templates — returner / event / faction-war / whale** | N | M | N | inventory SHOP-5 |
| 39 | **Anti-pay-to-win audit + spend caps + parental gate UX** | N | S | **Y** (policy) | inventory SHOP-6 |
| 40 | **Engine: drop-rate transparency for cosmetic gacha** — published rates, no FOMO timers | N | S | N | competitive_landscape §2.5 #1 |
| 41 | **Reanimation curse % chance tuning per chapter (5/8/12%)** | N | S | partial | inventory GP-9 |
| 42 | **Publisher / platform-relations outreach** — Devolver / Annapurna / Raw Fury | N | M | **Y** | competitive_landscape §2.1 #5 |

## P2 — nice-to-have (post-soft-launch acceptable)

| # | Item | Blocks GT? | Eff | Paul? | Source |
|---|---|---|---|---|---|
| 43 | **Alt-art variant system (3 alt-arts × 7 treatments per card)** | N | L | N | inventory VAR-1 |
| 44 | **Per-Warlord paid skin runway (4 slots Y1)** | N | M | partial | inventory VAR-2 |
| 45 | **Card-back skins (10 launch + 1/season + 5 mastery)** | N | M | N | inventory VAR-3 |
| 46 | **Board / lane-art skins** | N | M | N | inventory VAR-4 |
| 47 | **Summon-VFX skins (4 presets per faction)** | N | S | N | inventory VAR-5 |
| 48 | **Ascendant Pact subscription patch-1.2 implementation** (post-D14) | N | M | partial | monetisation_map §15 |
| 49 | **W11 (Saint That Should Not Hang) full playable content** | N | L | N | competitive_landscape §2.4 #5 + warlords_v1 |
| 50 | **Localisation pass — JA/KR/zh-Hans/de/fr/es/pt-BR** | N | L | **Y** (vendor) | competitive_landscape §2.1 #12 |

---

## Top 5 — Paul's "do these this week" highlights

1. **#1 Run B3.0a smoke test on RunPod** (1 hour Paul time, ~£0.15). Single biggest unblock in the whole project.
2. **#3 Approve M1 placeholder-ship acceptance criteria** (15 min review of `art_pipeline_readiness_v0.md` §7).
3. **#10 Decide on board-background approach — bespoke art vs tinted-tilemap placeholder** (15 min decision).
4. **#19 Soft-launch playtester recruitment** — at least start the conversation with potential cohort sources (1 hour).
5. **#14 Sign off on anti-stall mana-flood rule** (5 min — read GP-5 in the inventory).

If Paul actions #1, #3, #10, #14 this week, Cowork / .151 can pick up #2, #4, #5, #7-9, #11-18, #20-25 in the same window. **M1 placeholder ship lands in ~2 weeks** on that cadence.

---

## What's blocking what

```
#1 B3.0a smoke test
  ├─→ #7 (3 missing card art specs)
  ├─→ #8 (8 boss art specs)
  ├─→ #9 (7 token art specs)
  ├─→ #34 (faction sigils S2-S5)
  └─→ All of M2 (generated art ship)

#2 + #3 Placeholder fallback
  └─→ M1 acceptance (playable end-to-end)

#11 Git OneDrive unlock
  └─→ #12 (commit + push all design docs since 2026-05-21)
       └─→ External visibility of CANON_PATCHES_APPLIED + 3 round-4 deliverables

#10 Board background decision
  └─→ #8 (if bespoke chosen, boss specs need matching backgrounds)

#15-17 Engine cap wiring (W1/W2/W3)
  └─→ Card balance audit telemetry (#6) reads clean values
```

---

## Stale items from round-2 inventory (no longer relevant or supersededed)

These were in `GALLOWFELL_BACKLOG_INVENTORY_2026-05-21.md` but are now closed / stale and should be marked DONE rather than continuing to bother the queue:

1. **CARD-6 token registry** — closed by `tokens_v0.md` (delivered 2026-05-21).
2. **Round-2 conflicts C1-C6** — closed by `CANON_PATCHES_APPLIED_2026-05-22.md` (this session).
3. **Round-3 wobbles W1-W3** — closed by `CANON_PATCHES_APPLIED_2026-05-22.md` (this session).
4. **Backlog items for `gdd_v0.md` line-edits** — closed by v0 deprecation banner; v0 is dead.
5. **Backlog items for `warlords_v0.md` count alignment** — closed by v0 deprecation banner.
6. **Mother Quag trigger ambiguity** — closed by `archetypes_v0.md` line 125 patch.
7. **Subscription absent from monetisation_map** — closed by `monetisation_map.md` §15.

Recommend round-5 of the inventory drops these.

---

## Cross-references

- `GALLOWFELL_BACKLOG_INVENTORY_2026-05-21.md` — full inventory (this doc cherry-picks outstanding items)
- `CONFLICTS_RESOLVED_2026-05-22.md` — round-2 conflicts (now closed by CANON_PATCHES_APPLIED)
- `CANON_PATCHES_APPLIED_2026-05-22.md` — round-4 canon stabilisation (this session)
- `art_pipeline_readiness_v0.md` — art pipeline readiness + M1 / M2 / M3 milestones
- `competitive_landscape_v0.md` — honest competitive analysis
- `card_balance_audit_v0.md` §19 — Self-Scourge × Hanging Hour wobble (now patched)

— Controller round-4, 2026-05-22
