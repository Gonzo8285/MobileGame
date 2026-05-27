# Game Design Document v1 — The Curse of Gallowfell

_Authored 2026-05-22 by Controller (round 2). Supersedes `gdd_v0.md` (drafted 2026-04-29, approved 2026-04-30) which is now deprecated. v1 reflects the 8-round linear lock from `2026-05-18_gallowfell_balance.md`, the full 11-Warlord roster from `warlords_v1.md`, the 2026-05-21 commercial-loop spec set (shop / season pass / upgrade trees / variants), and the keyword-resolution spec from `gameplay_keywords_resolution_v0.md`. Approximate length: 3,000 words. Deep mechanical specs are linked by filename, not rehashed._

**Status:** v1. Locks all canonical decisions to date for the IMV-2 → soft-launch path. Open questions for Paul listed in `CONFLICTS_RESOLVED_2026-05-22.md` and the 2026-05-21 inventory.

---

## 1. Pitch (one-liner)

**The Curse of Gallowfell** is a grimdark roguelite tower-defence deckbuilder for mobile. You pick a Warlord, build a 12-card deck, and march through eight escalating combats inside a cursed gallows-town that refuses to bury its dead. Permadeath per run; meta-progression between runs; persistent cosmetics; no pay-to-win. Mobile-first, free-to-play with microtransactions + 30-day Marrow Pass + an optional Ascendant Pact subscription. PEGI 12 / Teen 13+. PvE only.

The one-line elevator pitch:

> _"Slay the Spire's deck-pruning intensity meets Bloons TD's lane defence, wrapped in a grimdark gallows-folklore setting that gives you a reason to lose and a reason to come back."_

---

## 2. Player fantasy

You are a **Warlord** — a name, a robe, a death-debt — leading a doomed warband into a town the empire forgot. Gallowfell is the empire's national gallows. Centuries of executions cursed it; the dead refuse to leave; reality frays. You came for one of five reasons (pilgrimage, reclamation, demon-bargain, sealed orders, ancestral vengeance) — but the curse has its own plans, and every fight feels like the town is watching.

The fantasy is:

1. **Small army, big rituals.** You play five-to-twelve units across three lanes. They feel weighty. Each card placed is a sentence in a litany, not a number on a spreadsheet.
2. **The curse is bigger than you.** Every combat at turn 5 ("The Hanging Hour"), the empire's gallows-bell tolls — units gain +1 ATK, dead enemies sometimes rise. You learn to read it, not beat it.
3. **Decks tell stories.** A Penitent deck *bleeds* differently from a Coven deck. By turn 4 of a combat, the player should be able to name which sub-archetype the deck is leaning into without looking at a chart.
4. **You will die. The town will not.** Permadeath is on-tone. Run-end is a funeral, not a failure screen. The next run starts at a different angle of the same haunted place.

Visual register: MTG-painterly oil meets Elden Ring grandeur, with Phyrexian body-horror in the late chapters. Palette is ash-grey, candle-gold, blood-red. Audio is orchestral strings, dark choir, and industrial percussion — one leitmotif per faction (see `audio_production_brief_v1.md`).

---

## 3. Core loop — one page

```
┌───────────────────────────────────────────────────────────────┐
│  MICRO LOOP — 60-90s per combat (1 of 8 combats per run)      │
│                                                                │
│   ┌─────────┐    ┌──────────┐    ┌──────────┐    ┌────────┐  │
│   │ Draw    │ →  │ Pay mana │ →  │ Place /  │ →  │ Wave   │  │
│   │ 5 cards │    │ (3→8 cap)│    │ cast     │    │ resolves│  │
│   └─────────┘    └──────────┘    └──────────┘    └────────┘  │
│         ▲                                              │      │
│         └──────────── new turn, mana +1 ───────────────┘      │
│                                                                │
│   At turn 5 (turn 4 vs boss): THE HANGING HOUR fires.         │
│   +1 ATK to all units, Reanimation curse rolls, sometimes     │
│   the boss's signature passive triggers.                      │
└───────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌───────────────────────────────────────────────────────────────┐
│  RUN LOOP — 8-15 min per run                                  │
│                                                                │
│   Round 1 COMBAT  ─►  R2  ─►  R3  ─►  R4 ELITE                │
│        │                                    │                  │
│        ▼                                    ▼                  │
│   reward pick                          R5 HORDE               │
│   (1 of 3 cards)                            │                  │
│                                             ▼                  │
│                                        R6 COMBAT              │
│                                             │                  │
│                                             ▼                  │
│                                        R7 HORDE               │
│                                             │                  │
│                                             ▼                  │
│                                        R8 BOSS  ──► VICTORY    │
│                                                                │
│   Defeat at any round → game-over screen, retry (costs gems) │
│   or restart run (free).                                       │
└───────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌───────────────────────────────────────────────────────────────┐
│  META LOOP — multi-run                                        │
│                                                                │
│   Run-end → convert XP → Warlord tier + Marrow Pass XP        │
│           → spend Bones in Ancestor Tree                       │
│           → unlock new Warlords (Marrow Shards or Gems)        │
│           → unlock cosmetic treatments (gacha or season pass) │
│           → Ascension difficulty climb (A1-A20 per Warlord)    │
└───────────────────────────────────────────────────────────────┘
```

---

## 4. The 8-round linear run (LOCKED)

Per `2026-05-18_gallowfell_balance.md` (the canonical balance doc), each chapter run is **8 sequential combats, no branching map.** Win all 8 = run victory. Locked for IMV-1 + IMV-2 + soft-launch. Branching ("Forked Roads of Gallowfell") is deferred to v1.1.

| Round | Kind | Reward (gems) | Pacing notes |
|---|---|---|---|
| 1 | COMBAT | +2 | Easy intro. 3-4 weak enemies. |
| 2 | COMBAT | +2 | Baseline. Mana ramp barely matters yet. |
| 3 | COMBAT | +2 | Mid-mana plays come online. |
| 4 | ELITE | +3 | First power gate. 1 elite + 2 normals. Elite is 2× HP / 1.5× ATK on round scaling. |
| 5 | HORDE | +5 | First swarm. 8-9 enemies at half stats. Bonus gems compensate stress. |
| 6 | COMBAT | +2 | Breather. Player consolidates. |
| 7 | HORDE | +5 | Second swarm. Curve is heavier. |
| 8 | BOSS | +10 | Single tough enemy (6× HP, 2× ATK) + 2 minions. Hanging Hour fires turn 4. |

**Perfect-run gem haul:** 31 gems.

**Reward-pick step** lives between each round: 1 of 3 cards from the faction-weighted pool. Card pool grows from 12 to ~20 by run end. Pruning at REST nodes (where authored) is a meta-skill.

**Scaling formula** per round:
- HP multiplier = `1.00 + 0.15 × (round − 1)` → R8 = 2.05×
- ATK multiplier = `1.00 + 0.10 × (round − 1)` → R8 = 1.70×

**Mana ramp** (Paul, 2026-05-18 call): start at 3 max, +1 per turn, cap at 8. Resets each combat.

**Chapter structure:** the game's metagame is **8 chapters**, each its own 8-round run. Chapter 1-3 are spec'd in `bosses_v0.md` + `bosses_chapters_2_3_v0.md`. Chapters 4-8 are spec'd in `bosses_chapters_4_to_8_v0.md` (this session). Each chapter has its own boss and chapter-tier relic pool. Difficulty escalates per chapter.

---

## 5. Meta loop

Three persistent systems run between runs. All anti-pay-to-win-bound per `monetisation_map.md` §"Anti-pay-to-win guardrails".

### 5.1 The Marrow Pass (Season Pass)

30-day seasons, 50 tiers, dual-track (free + premium). £4.99 premium, £9.99 Pass+ (+10 instant tiers). Free track gives card unlocks + small cosmetic + ×1.10 XP multiplier from tier 25. Premium gives gems, paid-Warlord shards, exclusive Cursed-treatment of one card per season, and ×1.25 XP multiplier the whole season. Full spec: `season_pass_v0.md`.

Season-1 hero reward (premium-track tier 50): the **first season-exclusive Cursed treatment of Penance-Captain Vyrrun's Self-Scourge** — a Hanging-Hour-themed alt-art with green-pyre VFX. Per `variants_system_v0.md` §"Alt-arts", this is the "single hero SKU" promise.

### 5.2 The Ancestor Tree (persistent upgrade)

Per `upgrade_trees_v0.md` §"Ancestor Tree". 30-40 node passive-tree, spent in Bones (run-end soft currency). Sideways power only — every node is a tradeoff (e.g. "+1 starting Gold, -1 starting HP"), never a flat strength gain. Built up over weeks of play. Soft retention hook for the F2P loop.

### 5.3 Ascension (per-Warlord difficulty)

Per `upgrade_trees_v0.md` §"Ascension". A1-A20 ladder, per-Warlord. Each rung adds a modifier (enemy HP +5%, Hanging Hour fires earlier, retry cost doubled, etc). Milestone rungs (A5, A11, A16, A20) add Warlord-specific narrative beats. A20 is the highest difficulty per Warlord, unlocks a unique mastery cosmetic. Hardcore endgame.

---

## 6. The 11 Warlords + 5 factions

Per `warlords_v1.md` (canonical roster). **11 total: 5 free + 5 paid + 1 lore-locked.** Marketing copy: _"10 playable Warlords + 1 lore-locked W11"_. Design copy: _"11 Warlords"_.

Free roster (5, each anchors one faction + one playstyle):

| # | Warlord | Faction | Playstyle |
|---|---|---|---|
| 1 | Penance-Captain Vyrrun | Iron Penitents | Aggro |
| 2 | Court-Necromant Sieren | Ash-Mourners | Control |
| 3 | Marsh-Mother Eddra | Coven of the Black Mire | Swarm |
| 4 | Forge-Marshal Veska | The Last Legion | Tempo |
| 5 | Tree-Walker Mhar | Skinward Pact | Summoner |

Paid roster (5, cross-faction hybrids — never strictly stronger, sideways flexibility):

| # | Warlord | Hybrid | Unlock |
|---|---|---|---|
| 6 | The Vow-Broken Magus | Penitents × Mourners | 12k Marrow Shards or 1,200 gems |
| 7 | Warden Caspar Voll | Last Legion (boss-control) | 12k / 1,200 |
| 8 | The Saint of Gallowsmoke | Coven × Mourners | 15k / 1,500 |
| 9 | The Brass-Crowned Whelp | Skinward × Penitents | 18k / 1,800 |
| 10 | The Last Confessor | Neutral / flex | 25k / 2,500 |

Lore-locked:

| # | Warlord | Faction | Unlock |
|---|---|---|---|
| 11 | The Saint That Should Not Hang | Curse-bound | Beat campaign with all 10 others (no IAP path) |

Per `bosses_chapters_2_3_v0.md` §3, W11 unlock triggers specifically at the Chapter 3 boss victory once 10 unique-Warlord run-victories have been logged.

### 6.1 Factions

Per `faction_bible.md` v1 (canonical):

1. **Iron Penitents** — Cathedral Ruins. Aggro/sacrifice. Self-damage triggers, BLEED + PENANCE keywords.
2. **Ash-Mourners** — Catacombs / Ash Quarter. Control/debuff. PERSIST primary + Slow + Smoke + Resurrect.
3. **Coven of the Black Mire** — Bog of Bargains. Swarm/poison. Tokens (Bog-Spawn), POISON stacks, SACRIFICE.
4. **The Last Legion** — The Foundry. Tempo/formation. RALLY + ECHO + TAUNT + adjacency buffs.
5. **Skinward Pact** — Cinderwood. Summoner/monstrous. Transform-chains, big bodies, RESURRECT-once.

Each faction's flagship card and biome are locked in `faction_bible.md`.

---

## 7. Commercial loops

Four named tracks. Spec lives in dedicated docs; this section is the pointer index.

| Track | Spec | One-line summary |
|---|---|---|
| Shop economy | `shop_economy_v0.md` | 5 currencies (Gold / Bones / Marrow Shards / Gems / Souls). Permanent Hub storefront (gem packs, faction bundles, cosmetics) + in-run Shop nodes (gold sink). Anti-P2W guardrails locked. |
| Season Pass — Marrow Pass | `season_pass_v0.md` | 30-day, 50 tiers, dual-track, £4.99 + Pass+ £9.99. One Cursed-treatment-of-a-card per season is the headline SKU. |
| Upgrade trees | `upgrade_trees_v0.md` | Three systems: Warlord tier ladder (T1-T4), in-run REST card upgrades, Ancestor Tree meta-progression. Ascension A1-A20 per Warlord. |
| Variants | `variants_system_v0.md` | 7 card treatments (Default + Foil + Gold + Ink + Prism + Cursed + Ultimate) × 3 alt-arts per card × infinite Warlord skins + card-backs + board skins. Gacha + season pass + IAP + earn paths. |

In addition: **The Ascendant Pact** subscription (£4.99/mo, post-D14 soft-launch milestone) added per `CONFLICTS_RESOLVED_2026-05-22.md` §"Conflict 6".

### 7.1 What's paid (locked)

- Gem packs: £0.99 - £99.99 (6 tiers per `shop_economy_v0.md`)
- Starter bundle: £4.99 one-time (D2 trigger)
- Faction bundles: 5 × £9.99 (one per faction)
- Marrow Pass premium: £4.99/season; Pass+ £9.99/season
- Ascendant Pact: £4.99/mo subscription
- Paid Warlord SKUs: gems-only path (~£4.99-£19.99 effective per Warlord)
- Cosmetics: treatments £2.99-£49.99 (Ultimate tier)

### 7.2 What's never paid (locked)

- All 5 free Warlords
- W11 lore-locked Warlord (no IAP path)
- Souls (premium-earned-only currency)
- Soul-bound mastery skins (each Warlord has one, earned at T4 mastery)
- All gameplay-affecting cards
- Daily chest (1× free)
- Run rewards
- Ancestor Tree nodes (Bones-only, earn-only)

---

## 8. First-run / tutorial outline

Full screen-by-screen sequence: `tutorial_flow_v0.md`. Summary here for GDD canon.

First 3 minutes:

1. **00:00 — Splash + title.** "The Curse of Gallowfell". Sting plays. Tap to continue.
2. **00:10 — Cold-open cutscene (skippable).** 8 still frames + narration. Sets up Gallowfell, the gallows-tree, the curse. ~40 seconds.
3. **00:50 — Tutorial combat (forced).** Single-lane fight with Vyrrun (Iron Penitents starter). 3 enemies. Player learns: tap card → drag to lane → tile collision → SHIELD card → win. Overlay tips block input until the relevant action is performed.
4. **02:00 — Warlord pick screen.** All 5 free Warlords shown. Vyrrun pre-selected (the tutorial Warlord). Player can swap if they want; first-run nudge is to keep Vyrrun.
5. **02:20 — First map node.** 8-pip linear map appears. Player enters round 1. Standard combat with Vyrrun's starter deck (per `starter_decks_v0.md` §2.1).
6. **02:50 — First reward pick.** Card-reward screen demos the 1-of-3 mechanic + faction-weighted pool. Tap any card.
7. **03:00 — Free flow.** Player is now in the game proper.

Skip toggle in **Settings → Onboarding → Replay tutorial**. Analytics event: `tutorial_complete` fires on round 1 reward pick.

---

## 9. Soft launch + KPIs

Full plan: `soft_launch_playbook_v0.md`. Summary here.

- **Geos:** Philippines + UK + Canada (low-cost CPI, English-language).
- **Window:** 14 days.
- **Cohort:** 50 testers (Discord + Subreddit + Paul's network sourcing).
- **Channels:** TestFlight (iOS) + Play Console internal track (Android).

KPI targets (industry-benchmarked midcore mobile):

| Metric | Soft-launch pass bar | v1.0 launch target |
|---|---|---|
| D1 retention | ≥ 40% | ≥ 45% |
| D3 retention | ≥ 25% | ≥ 30% |
| D7 retention | ≥ 15% | ≥ 20% |
| ARPDAU | ≥ £0.10 | ≥ £0.25 |
| IAP conversion (D7) | ≥ 2.5% | ≥ 4% |
| Tutorial-completion | ≥ 85% | ≥ 90% |
| Avg session length | 8-12 min | 10-15 min |
| Sessions / DAU | ≥ 2.5 | ≥ 3.5 |

Pass-fail: **3 of 4 retention bars + ARPDAU bar OR conversion bar.** If both retention and ARPDAU miss, the soft-launch is paused for a tuning patch before re-running.

---

## 10. Risks + mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Anti-P2W invariant breaks under pressure to monetise harder | Medium | Brand-killing | Locked in `monetisation_map.md` §"Anti-pay-to-win guardrails". Every PR that touches money paths must re-audit. |
| Mobile control feel is wrong (drag-to-lane is fiddly) | Medium | Retention-killing | `interaction_touch_v0.md` locks gestures. Playtest gate at IMV-1 includes "drag-feel pass". |
| Art pipeline can't keep up with ~205 cards | High | Soft-launch delay | AI-gen pipeline + Sonniss CC0 + Suno music. RTX 2050 hardware gap mitigated by RunPod cloud GPU per `pipeline_spec.md`. |
| Lore-deep grimdark turns off mass-market audience | Medium | TAM-capping | PEGI 12 (not 16+) keeps reach wide. Gallows-humour register softens edges. Tutorial cold-open sells fantasy in 40s without front-loading horror. |
| Hanging Hour mechanic is opaque to players | Medium | Confusion-driven churn | UI bell-toll + ash-tint sting + onscreen "23:59 → 00:00" diegetic clock (per `gameplay_keywords_resolution_v0.md` §"Hanging Hour UX lock"). |
| Roguelike depth too thin at launch | Medium | D7 retention miss | 11 Warlords × 5 factions × 3 sub-archetypes = 165 viable deck-leans. Ascension A1-A20 per Warlord adds long-tail. |
| Store-review rejection (P2W concerns, gambling-loot-boxes) | Low | Launch delay | Gacha pity at 80 pulls is documented + visible. No real-money loot boxes for power. Treatments are cosmetic-only. Anti-P2W audit log retained. |
| W11 lore-locked Warlord causes hidden-content frustration | Low | Forum drama | Discoverable via lore drops in events. Achievement-tracker shows "10 of 10 Warlord runs cleared" progress so unlock is visible. |
| Subscription (Ascendant Pact) launches too early and drowns out Marrow Pass | Low | ARPDAU dilution | Subscription gated to post-D14 milestone, not soft-launch. |

---

## 11. What this GDD does NOT cover (deep specs by reference)

This document is intentionally light on numbers. The following deep specs are the source of truth for their domains:

| Domain | Source |
|---|---|
| Per-currency rules + IAP price ladder | `shop_economy_v0.md` |
| Per-tier season pass rewards | `season_pass_v0.md` |
| Per-Warlord tier ladder + Ascension milestones | `upgrade_trees_v0.md`, `warlord_tiers_full.md` |
| All 7 card treatments + acquisition rules | `variants_system_v0.md` |
| Per-keyword resolver | `gameplay_keywords_resolution_v0.md` |
| Per-faction lore + flagship | `faction_bible.md` v1 |
| Per-Warlord backstory + abilities | `warlords_v1.md` |
| Per-Warlord starter deck | `starter_decks_v0.md` |
| Chapter 1 boss | `bosses_v0.md` |
| Chapters 2-3 bosses | `bosses_chapters_2_3_v0.md` |
| Chapters 4-8 bosses | `bosses_chapters_4_to_8_v0.md` |
| Curse catalogue + removal | `curses_v0.md` |
| Token registry | `tokens_v0.md` |
| Audio leitmotifs + SFX | `audio_direction_v0.md`, `audio_production_brief_v1.md` |
| Touch input + UI shotlist | `interaction_touch_v0.md`, `ui_shotlist_v0.md` |
| Tutorial flow | `tutorial_flow_v0.md` |
| Soft-launch ops | `soft_launch_playbook_v0.md` |

---

## 12. Open Qs (carried forward from inventory + 2026-05-21)

1. **Currency naming lock** — `shop_economy_v0.md` proposes 5 currencies (Gold / Bones / Marrow Shards / Gems / Souls). Confirm naming or veto specific entries.
2. **Season Pass core promise** — recommended: 1 season-exclusive Cursed-treatment-of-a-card per season as the headline SKU. Confirm.
3. **Paid Warlord skin gate** — recommend: yes, must own the paid Warlord to buy its skins. Confirm.
4. **Ascension ladder length** — recommend: A1-A20 (StS convention), with Warlord-specific modifiers at A5/A11/A16/A20. Confirm.
5. **Daily challenge mode** — recommend: defer to v1.1 patch, not soft-launch. Confirm.
6. **R-CH2-5 Wax-Sealed Sigil** — relic that ties gameplay to cosmetic state. Recommend redesign per `bosses_chapters_2_3_v0.md` Open Q 1.
7. **Chapter 3 boss "The Drop" turn** — turn 9 or turn 10? Recommend 9 per spec; 10 if playtest finds it too brutal.
8. **W11 unlock condition** — recommend confirm "beat campaign with all 10 others, ties to Chapter 3 boss victory".

---

## 13. Version history

- v0 — 2026-04-29, approved by Paul 2026-04-30. 16-node/4-act map. 10 Warlords. Deprecated 2026-05-22.
- v1 — 2026-05-22, this document. 8-round linear. 11 Warlords. Linked to deep specs.

— Controller, 2026-05-22
