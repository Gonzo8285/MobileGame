# Gallowfell — Outstanding Work Inventory (2026-05-21)

_Authored 2026-05-21 by Controller. Single source of truth for outstanding Gallowfell work, grouped by Paul's named categories. Reads `backlog.md` + `HANDOVER.md` + `Controller project_/_master/02_Gallowfell.md` + the 2026-05-18 progress/balance/how-to-test triad as input. Items inherited from `backlog.md` keep their original IDs (V1, R*, C*, M*, T*, W*, B*, D-LORA*, D-WORKFLOW*, A-SPEC*) so they cross-reference cleanly. Net-new items invented by this inventory are prefixed `INV-`._

## Reading guide

- **State:** `not started` / `partial` / `spec'd` (design doc exists but no engine wiring) / `blocked-on-Paul` / `IMV-2 deferred`
- **Effort:** S (≤2 hr design-doc), M (≤1 day), L (multi-day or multi-file)
- **Priority:** **P0** (Paul-named commercial-loop-critical: Shop / Season Pass / Upgrade / Variants) · **P1** (Gameplay / Interaction / Graphics) · **P2** (Design infill, audio, events, bosses 2-3) · **P3** (research, infra, deferred to IMV-2)

## Inventory headline

| Category | P0 | P1 | P2 | P3 | TOTAL |
|---|---|---|---|---|---|
| Design | — | — | 11 | 2 | 13 |
| Gameplay | — | 7 | 3 | — | 10 |
| Interaction (UI/UX flow) | — | 6 | 2 | — | 8 |
| Graphics (art + frames + VFX) | — | 5 | 4 | 4 | 13 |
| **Shop** | **6** | — | — | — | **6** |
| **Season Pass** | **5** | — | — | — | **5** |
| **Upgrade** | **5** | — | — | — | **5** |
| **Variants** | **6** | — | — | — | **6** |
| Events / Shrines / Rests | — | 2 | 3 | — | 5 |
| Bosses (incl. chapters 2-3) | — | 2 | 3 | — | 5 |
| Factions / Cards / Keywords | — | 4 | 2 | — | 6 |
| Audio | — | — | 3 | — | 3 |
| Tooling / Build pipeline | — | 1 | — | 4 | 5 |
| Art pipeline | — | — | — | 6 | 6 |
| **TOTAL** | **22** | **27** | **31** | **16** | **96** |

P0 count = 22 — the four commercial-loop tracks Paul named explicitly. This inventory is the source these get worked from in Phase 2.

---

## Shop (P0 — Paul-named, commercial-loop-critical)

Pre-existing scaffolding: `monetisation_map.md` §1, §2, §3, §10, §12 + `collection_ui_v0.md` references "unlock detail panel = single-source storefront/season-pass/gacha/event-window route". Shop has been mentioned in 24 files but never spec'd as a single design doc. This is the load-bearing gap.

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| SHOP-1 | **Currency model — Gold / Bones / Souls / Marrow Shards / Gems** | partial (in monetisation_map.md and balance doc, scattered) | M | 5 currencies are referenced across docs; conversion + use surfaces never enumerated; need one canonical table | `shop_economy_v0.md` §"Currency model" — what each currency is, how it's earned, where it's spent, lock rules. Anti-P2W invariant per currency. |
| SHOP-2 | **Permanent storefront screen (Hub → Store tab)** | not started | M | Where IAP gem packs and bundles live. Currently only sketched in monetisation_map.md §1. Needs ASCII wireframe + section list. | Wireframe with 5 sections (Featured / Gem Packs / Bundles / Cosmetics / Battle Pass tile). Display rules, refresh cadence. |
| SHOP-3 | **In-run shop node — catalogue, pricing, rarity weights** | partial (NodeKind=SHOP added in B2.9, no content) | M | Existing engine NodeKind SHOP has zero stock data. Run-economy gold sink is core to roguelike pacing. | `shop_economy_v0.md` §"In-run shop" — full catalogue, slot count, refresh rules, gold pricing tier, faction-bias weights. |
| SHOP-4 | **IAP price ladder + bundle compositions** | partial (price tiers in monetisation_map.md §1 + §3; contents not spec'd) | M | 6-tier price ladder named but bundle SKU contents never defined per bundle. Soft-launch needs concrete SKUs. | Per-bundle SKU table: name, $price, contents (gems / cosmetics / Warlord shards), gating, frequency cap. |
| SHOP-5 | **Live-ops bundles — returner / event / faction-war / whale** | spec'd (sketch in §12) | M | Live-ops layer needs concrete bundle templates with trigger rules + frequency caps. | 4 template bundles with trigger conditions, segment, refresh cadence, anti-burnout caps. |
| SHOP-6 | **Anti-pay-to-win audit + spend caps** | partial (in §"Anti-P2W guardrails") | S | 6 guardrails listed but no monthly spend cap, no whale-protection rule. Required for app-store review in some markets. | Cap policy: soft warning at £100/mo, hard cap option at £500/mo, parental gate UX for under-18. |

**Single deliverable consolidating SHOP-1..6:** `shop_economy_v0.md`.

---

## Season Pass (P0 — Paul-named, commercial-loop-critical)

Pre-existing scaffolding: `monetisation_map.md` §6 ("Marrow Pass" 30-day, 50 levels, dual track, £4.99 / £9.99 Pass+, XP booster from level 25 free / season-long premium). Track contents never enumerated tier-by-tier.

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| BP-1 | **50-tier reward inventory (free + premium tracks)** | not started | L | The single biggest missing spec. £4.99 SKU needs concrete value perception to convert. | `season_pass_v0.md` §"Track rewards" — all 50 free tiers + 50 premium tiers, each with reward, currency value, tag. |
| BP-2 | **XP curve + earn-rate balance** | partial (target "~25 days at 1hr/day" in §6) | M | Curve never derived. Need per-tier XP cost + per-run XP yield + daily-cap rule. | Per-tier XP cost table, run-level XP yield, daily-quest XP, weekly-quest XP, total derivation showing ~25-day finish at 1hr/day. |
| BP-3 | **Season cadence, theming, archive** | not started | M | 30-day seasons need theme template, archive rules, retroactive purchase window. | Per-season template (theme, exclusive cosmetic, exclusive Cursed-treatment, faction focus, archive policy). 4-season runway (Y1 launch). |
| BP-4 | **Premium tier-skip economy (Pass+ + tier-skip IAP)** | partial (Pass+ named in §6 — "+10 levels + skin") | S | Tier-skip pricing absent. Whale conversion lever. | Gem cost per tier-skip, max skips per season cap, anti-FOMO cap rule. |
| BP-5 | **Engine handoff sketch — season state, reward claim, multiplier registry hook** | partial (booster registry exists in `warlord_tiers_v0.md` §13) | M | Engine needs lifecycle signals + claim API + season-state save/load shape. | Resource + GameState API extension, signal list, save-format additions. |

**Single deliverable consolidating BP-1..5:** `season_pass_v0.md`.

---

## Upgrade (P0 — Paul-named, commercial-loop-critical)

Three distinct upgrade systems exist or are implied across docs but are not unified anywhere:

1. **Warlord tier ladder** (T1 → T4) — fully spec'd in `warlord_tiers_full.md` for all 11 Warlords.
2. **Card upgrade via REST nodes** — sketched in `rests_v0.md` (in-run, per-CardInstance).
3. **Meta-progression / persistent player upgrade tree** — referenced in `gdd_v0.md` and `monetisation_map.md` ("Marrow Shards", "Bones") but no tree authored.

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| UPG-1 | **Meta-progression Ancestor Tree (persistent player upgrade)** | not started | L | The "what does Bones currency unlock" answer. Without this, the persistent currency loop is unmoored. | `upgrade_trees_v0.md` §"Ancestor Tree" — 30-40 node tree, costs in Bones, unlock prerequisites, sideways-only (anti-P2W). |
| UPG-2 | **Card mastery / catalogue progression (per-card XP)** | not started | M | Treatment unlocks need a play-driven path (e.g. play card 50 times → unlock Foil). Per-card mastery is the hook. | Per-card play-count XP table, 4-tier card-mastery (use → know → master → cherish), cosmetic + flavour rewards. |
| UPG-3 | **Run-level CardInstance upgrade (REST nodes — already sketched)** | spec'd in `rests_v0.md` | S | Wire-up only — confirm upgrade dispatch + stat-delta table per card type. | `upgrade_trees_v0.md` §"In-run upgrades" cross-reference. Confirm dispatch by `card.primary_stat` enum. |
| UPG-4 | **Warlord Ascension (post-T4 difficulty modifier ladder, A1..A20)** | spec'd at template level (`warlord_tiers_full.md` per-Warlord A11 slot) | M | A11 slot named for each Warlord but full A1..A20 ladder absent (StS convention). | `upgrade_trees_v0.md` §"Ascension" — generic 20-rung difficulty ladder + Warlord-flavoured A-slots at A5/A11/A16/A20. |
| UPG-5 | **Relic catalogue + relic acquisition paths** | partial (7 new relics named in events_v0; per-faction RELIC card_type exists; full catalogue absent) | L | Roguelike depth comes from relic variety. ~30 relics needed for IMV-2 minimum. | `upgrade_trees_v0.md` §"Relics" — 30-relic catalogue with rarity, acquisition path, anti-stack rules. |

**Single deliverable consolidating UPG-1..5:** `upgrade_trees_v0.md`.

---

## Variants (P0 — Paul-named, commercial-loop-critical)

Pre-existing scaffolding: Card-treatment system (T1-T4 — `collection_ui_v0.md`, `shader_stack_design.md`, `faction_frames_v0.md`, `game/data/treatments/treatment_definitions.tres`). Three other variant axes are referenced but unspec'd: alt-art variants, Warlord skins beyond mastery, board/card-back/VFX skins.

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| VAR-1 | **Alt-art variant system (3 alt-arts per card × 7 treatments = 21 versions)** | spec'd at concept level (`monetisation_map.md` §5 "Future: 3 alt-art variants × 7 treatments") | L | Per-card LTV ceiling depends on this. The "infinite content vertical" line in §5 requires authoring + acquisition + gacha rules. | `variants_system_v0.md` §"Alt-arts" — naming convention, slot count per rarity, acquisition (gacha / event / season pass), aesthetic guardrails. |
| VAR-2 | **Warlord skin pool beyond mastery (paid + event + seasonal)** | spec'd in `monetisation_map.md` §5 (single "mastery skin" + "Limited paid skins via live-ops") | M | Mastery cosmetic = 1 free per Warlord. Need 2-4 paid skins per Warlord for live-ops cadence over Y1. | Per-Warlord skin runway (4 slots Y1): mastery (free) + Cursed-event + paid live-ops + seasonal. Naming + acquisition table. |
| VAR-3 | **Card-back skins** | not started | M | Deferred in §5 to v1.1 — reconsider. Per-loadout cosmetic surface = high engagement signal. | `variants_system_v0.md` §"Card-backs" — 10 launch designs + 1 per season + 5 mastery rewards + faction set. |
| VAR-4 | **Board / lane-art skins** | not started | M | Same as VAR-3 — deferred but cheap cosmetic surface; one art asset per lane = high visibility. | `variants_system_v0.md` §"Board skins" — 5 faction-themed launch boards + 4 seasonal + 1 Curse-themed unlockable. |
| VAR-5 | **Summon-VFX skins** | not started | S | VFX swap on unit-play is high-impact, low-asset-cost (shader + particle preset). | `variants_system_v0.md` §"Summon VFX" — 4 launch VFX presets per faction. |
| VAR-6 | **Variant rarity, drop weights, gacha banner mechanics** | not started | M | Gacha for cosmetics is the primary "treatment whale" engine. Pity rules + banner cadence absent. | Treatment-gacha banner spec — pool composition, pity at 80 pulls, banner rotation (4-week cadence), featured-treatment mechanic. |

**Single deliverable consolidating VAR-1..6:** `variants_system_v0.md`.

---

## Gameplay (P1)

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| GP-1 | **Keyword resolution for CLEAVE / PIERCE / FEAR / ROOT / SLOW / SMOKE / DREAD / SHIELD** | not started (plumbing exists per B2.7 note; resolution deferred) | L | 8 keywords have enum slots and card-text references but no resolver. Cards parsing these are unplayable correctly. | `gameplay_keywords_resolution_v0.md` — per-keyword resolver pseudocode, ordering rule, stacking rule, edge cases (Persist+Bleed, Cleave+Taunt, Smoke+Fear chain). |
| GP-2 | **Unit attack timing + tile-collision** | partial (`turn_engine.gd` has friendly-attack + enemy-advance) | M | Edge cases not spec'd: friendly vs friendly tile-share, projectile LONG-range vs blocker, enemy stand-attacks on same tile as friendly. | `gameplay_combat_resolution_v0.md` — full per-tile resolution order. |
| GP-3 | **TAUNT E1 wiring + assertion test** | spec'd in `keywords/taunt_v0.md`; backlog E1 still open | S | Targeting filter for MELEE-in-range exists in spec but `.tres` arrays untouched on 6 cards. | Per backlog E1 acceptance — 6 cards tagged, 3 new turn_engine_test assertions, all PASS. |
| GP-4 | **HORDE wave kind — explicit mechanic spec** | partial (`enums.gd` HORDE added; balance doc round 5/7) | S | Stat-halving rule was inferred from balance doc. Need explicit "what makes a HORDE different from COMBAT" engine contract. | `gameplay_combat_resolution_v0.md` §"HORDE" — half-stat rule, spawn-rate rule, lane-distribution rule. |
| GP-5 | **Anti-stall / mana-flood rule** | not started | S | At 8-cap mana with 1-cost spam, an unkillable lane can stall the run. Need a graceful stall-break. | Rule: after turn 12, base HP takes +1 damage per turn from "the curse closing in". |
| GP-6 | **Run-victory boss path + chapter complete state** | partial (e2e_smoke_test handles defeat path only) | M | The "you won" path is asserted in spec but no narrative beat, no end-of-chapter screen, no inter-chapter persistent carry. | `gameplay_run_victory_v0.md` — what carries between chapters (HP, gold, relics, deck, gems), what resets. |
| GP-7 | **Mulligan v1 — strategic, not free reroll** | partial (`hand.gd` has mulligan; player UX unspec'd) | S | Mulligan rules per-combat absent. StS-style replace-up-to-1 vs full-redraw vs no-mulligan. | Rule: optional reroll of 1 card on opening hand, no cost; 2nd reroll costs 1 gold. |
| GP-8 | **Hanging Hour visual + audio cue** | partial (named in lore + `keywords/hanging_hour_persist_v0.md`) | S | The single most evocative beat. No spec for what the moment looks/sounds like. | `gameplay_hanging_hour_uxlock_v0.md` — full-screen ash-tint, bell-toll SFX, 1.5s pause, on-screen "23:59 → 00:00" diegetic clock. |
| GP-9 | **Reanimation curse — % chance tuning** | partial (named in `lore_gallowfell.md`) | S | "small % chance" never quantified. | Per-chapter table: ch1 = 5%, ch2 = 8%, ch3 = 12%; HP at 1, max 1× per enemy per combat. |
| GP-10 | **Daily challenge mode (post-IMV-2 hook)** | not started | M | Daily seeded run with fixed Warlord + leaderboard. Engagement spike + low dev cost. | Spec: seed-of-day rule, mods stack, async leaderboard, reward = cosmetic shard. |

---

## Interaction (P1 — UI/UX flow)

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| INT-1 | **Touch input gesture set — tap / hold / drag / pinch** | not started | M | Mobile-first build but only `_get_drag_data` (Godot drag-drop) referenced. No formal gesture inventory. | `interaction_touch_v0.md` — per-gesture intent, conflict resolution (tap-on-card vs tap-on-hand-empty), hold-to-inspect timing (350ms). |
| INT-2 | **Card-inspect modal (hold-to-zoom)** | not started | S | Card text small on phones; need zoom-to-read modal. | Spec: hold ≥ 350ms → modal, treatment-aware preview, tap-outside-dismiss. |
| INT-3 | **Hand fan + auto-arrange** | partial (`hand_view.gd` is HBoxContainer — flat list, not fanned) | M | Flat hand looks placeholder; fanned + arc layout reads "card game". | Fan-layout spec: 7-card fan, arc radius, overlap rules, hover-extract animation, drag-from-fan flow. |
| INT-4 | **Settings / Options screen** | not started | S | Sound, haptics, graphics, language, accessibility, account, clear-cache. Mobile required. | Wireframe + per-option default + persistence schema. |
| INT-5 | **Tutorial / onboarding (first-run)** | not started | M | First-run UX is the single biggest D0→D1 retention lever. Currently zero spec. | `interaction_onboarding_v0.md` — 4-screen onboard, 2 forced combats with overlay tips, skip path, re-trigger toggle in settings. |
| INT-6 | **Pause / interrupt / phone-call resume** | not started | S | Mobile reality: incoming calls / app-switch mid-combat. Engine needs save-state mid-combat. | Spec: serialize Combat to disk on `NOTIFICATION_APPLICATION_PAUSED`, restore on resume; offer "resume / restart combat / abandon run" prompt. |
| INT-7 | **HUD persistent — gem display affordance + tap-target** | partial (gem count in HUD per balance doc) | S | Gem icon shown but no tap behaviour. Tap-to-buy = standard mobile conversion. | Tap gem icon → opens storefront §"Gem Packs". Long-press → "Where do gems come from?" tooltip. |
| INT-8 | **Haptic feedback contract** | not started | S | Haptics make a roguelike feel premium. Need per-event haptic strength. | Per-event table: card-play = light tick, unit-death = medium, Hanging Hour = heavy double-pulse, boss-kill = success pattern. |

---

## Graphics (P1 — art, frames, VFX)

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| GFX-1 | **D-VALIDATE-1 Stage A — 5 Warlord anchor renders** | open in backlog (gated on B3.0a smoke) | S | The locked anchor set every common card style-tests against. | 5 PNG outputs in `art/warlords/` + `art_specs/_anchors/`, Paul + Cowork co-validation. |
| GFX-2 | **D-VALIDATE-1 Stage B — 4 common-card tiles** | open in backlog | S | Pipeline smoke. | 4 PNG outputs in `art_iterations/_commons_validation/`. |
| GFX-3 | **Frame pack — 5 PSDs (T3 spec-only currently)** | spec'd (`faction_frames_v0.md`) | L | Authoring not started; needs the 5 PSD assets per spec. | 5 frame PSDs + flattened PNGs delivered to `res://game/art/frames/`. |
| GFX-4 | **UI iconography pack (cost / HP / ATK / range / faction tag)** | not started | M | Currently text-only labels. Icons = legibility on phones. | 30-icon SVG sheet, monochrome + faction-tint variants, 2× density export. |
| GFX-5 | **Status-effect overlay VFX (Bleed / Poison / Smoke / Fear / Root / Shield / Persist marker)** | not started | M | Visual readability of combat state. | 8 VFX presets — particle + shader spec for each; mobile-perf budget noted. |
| GFX-6 | **Splash / loading screen + per-faction loading flavour text** | not started | S | App-launch is the first impression. | 1 splash image spec + 20 lines of faction-flavour loading text. |
| GFX-7 | **App icon — Adaptive (Android) + 1024×1024 master (iOS)** | not started | S | Required for store submission. | Icon SVG + masked exports per platform, 5 size variants. |
| GFX-8 | **Lane / board background art per biome** | not started (board skins separately under VAR-4) | M | 5 biomes × 1 launch board each. | 5 backgrounds 1080×1920 + parallax layer spec. |
| GFX-9 | **Hanging Hour full-screen VFX** | spec'd in GP-8 | S | One-shot moment but defines tone. | Shader + sequencer spec. |
| GFX-10 | **Card art consistency audit + reroll list** | not started — depends GFX-1/2 | M | After Stage B, the cards that don't read against the anchors need a reroll plan. | Audit doc with per-card pass/fail + reroll candidates. |
| GFX-11 | **Boss card art — Black-Bell Choir + future bosses** | not started | S | Boss premium art per `bosses_v0.md` open Q4. | Art spec for `art_specs/bosses/b1_black_bell_choir.md`. |
| GFX-12 | **Sigil glyph render — 5 faction sigils** | spec'd in `art_specs/_sigils.md` (S1-S5) | S | Spec done; renders not generated. | 5 PNG outputs at 96×96 to `res://game/art/sigils/`. |
| GFX-13 | **In-app store screenshot pack (5 device-frame screenshots × store)** | not started | M | Required for store listing. ASO. | 5 phone screenshots, sized per Apple + Play store specs, with overlay copy. |

---

## Design infill (P2)

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| DES-1 | **GDD v1 refresh** | partial (`gdd_v0.md` from 2026-05-01, pre-balance doc) | M | gdd_v0 references "16 nodes / 4 acts" but balance doc locked 8-round linear. Single canon out of date. | `gdd_v1.md` reflecting balance doc + post-Phase-2.9/2.12 keyword set. |
| DES-2 | **Lore expansion — chapters 2 + 3 biome arcs** | partial (5 biomes named in `lore_gallowfell.md`; arcs absent) | M | IMV-2 needs chapter-2 + chapter-3 arc beats. | `lore_chapters_v0.md` — 2 chapter arcs with per-biome event hook, boss reveal, faction-shift. |
| DES-3 | **Chapter-2 boss design** | not started | M | Currently only ch1 boss spec'd. | `bosses_v0.md` §"Chapter 2" — 1 new boss following Black-Bell Choir template. |
| DES-4 | **Chapter-3 boss + run-finale design** | not started | L | Final boss + post-victory narrative. | `bosses_v0.md` §"Chapter 3" — final boss + 3-screen narrative payoff. |
| DES-5 | **Curse catalogue + curse-removal economy** | partial (8 curses named in `events_v0.md`) | M | Curses are referenced widely but no canonical list, removal cost, expiry rules. | `curses_v0.md` — 20-entry catalogue, removal at REST/SHOP/EVENT cost, anti-perma-stack rule. |
| DES-6 | **Relic catalogue (cross-ref UPG-5)** | partial | L | See UPG-5 — 30-relic catalogue. | Combined with UPG-5 deliverable. |
| DES-7 | **Innocent Saint W11 unlock narrative** | partial (`warlords_v1.md` §11) | S | Unlock criterion named but reveal moment unspec'd. | `warlord_w11_unlock_narrative_v0.md` — what happens on the screen the first time you see her. |
| DES-8 | **Daily challenge run mode (cross-ref GP-10)** | spec'd at concept | S | See GP-10. | Combined. |
| DES-9 | **Faction-war live-op (cross-faction PvP-by-proxy event)** | not started | M | Annual live-op hook per `lore_gallowfell.md` "Gallows Day". | `live_ops_factionwar_v0.md` — 2-week event, contribution scoring, faction reward, anti-collusion. |
| DES-10 | **Reward-rate balance audit — gold / gems / shards / XP** | partial (gem rates in balance doc; others absent) | M | Need a single per-run yield table across all currencies. | `economy_yield_v0.md` — per-round yield, per-Warlord variance, per-difficulty multiplier. |
| DES-11 | **Difficulty curve audit — chapter 1 vs 2 vs 3** | partial (chapter 1 in balance doc) | M | Curves don't exist for ch2/ch3. | `difficulty_curve_v0.md` — enemy HP/ATK scaling per chapter, mana cap per chapter, boss scaling. |
| DES-12 | **Loadout / starter deck spec — per Warlord (12-card starter)** | partial (`internal_mvp_scope.md` says random 12-card slice for IMV-1; warlord-locked for IMV-2) | M | IMV-2 starter decks named but cards never picked. | `starter_decks_v0.md` — 11 Warlords × 12 cards each. |
| DES-13 | **Glossary + in-game help — keywords / icons / curses** | not started | M | Players need a non-condescending reference. | `glossary_v0.md` + in-game Help screen wireframe. |

---

## Events / Shrines / Rests (P2, except E1 / wiring which is P1)

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| EV-1 | **M8.E1 — engine wiring for the 10 events** | spec'd; not wired | M | Events authored but no `Event` Resource class, no choice-dispatch, no relic/curse stub. | Per `events_v0.md` implementation notes: 7 relic stubs + 8 curse stubs in card.gd / relic.gd; Event resource + EventScene + 27 choice handlers (10 events × ~3 choices). |
| EV-2 | **M9.E1 — engine wiring for shrines + rests** | spec'd in `shrines_v0.md`+`rests_v0.md` | M | 4 shrines + 2 rests authored; no Shrine / Rest Resource. | Per `shrines_v0.md` engine sketch: 8 ShrineEffect kinds, 2 RestEffect kinds, 3 GameState lifecycle signals. |
| EV-3 | **Event-card content v0.2 — expand from 10 → 25** | partial | M | 10 events = 2-3 repeats in a chapter. Need ≥20 for chapter variety. | `events_v0.md` §"v0.2 expansion" — 15 new events with same template. |
| EV-4 | **Shrine content v0.2 — expand from 4 → 8** | partial | S | 4 = 1 per faction-3 territory; 8 = 1 unique per biome slot per chapter. | `shrines_v0.md` §"v0.2 expansion" — 4 new shrines. |
| EV-5 | **Per-Warlord event-text variants** | not started | M | Currently faction-flavoured. Per-Warlord one-liner variants raise event-text quality. | `events_v0.md` §"v0.3 per-Warlord lines" — short alt-lines per Warlord. |

---

## Bosses (P2)

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| BOSS-1 | **M10.E1 — engine wiring for The Black-Bell Choir** | spec'd | M | Per `bosses_v0.md` engine sketch: new `Enemy.is_boss + signature_ability_id`, `BossAbilities` dispatch module, hook on `hanging_hour_struck`. | All 4 sub-tasks in `bosses_v0.md` "M10.E1" sketch. |
| BOSS-2 | **Boss minion roster** | partial (uses existing E1-E5) | S | Black-Bell uses existing minions for now; chapter 2/3 will need bespoke minion families. | Reusable; defer per chapter. |
| BOSS-3 | **Chapter 2 boss (cross-ref DES-3)** | not started | M | See DES-3. | Combined. |
| BOSS-4 | **Chapter 3 boss (cross-ref DES-4)** | not started | L | See DES-4. | Combined. |
| BOSS-5 | **Boss telegraph / pre-fight teaser screen** | not started | S | "You hear bells" pre-fight teaser sets tone + previews mechanic without spoiling. | Spec: per-boss 2-line teaser + signature-mechanic preview SFX. |

---

## Factions / Cards / Keywords (P1-P2)

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| CARD-1 | **E1 — TAUNT engine wiring + 6 .tres tagging** | open in backlog (cross-ref GP-3) | S | Last keyword wiring gap. | Per backlog E1. |
| CARD-2 | **M6 — Cross-faction synergy v0.2 (post-TAUNT audit)** | open in backlog | S | Anti-synergy grid not updated after TAUNT introduced. | Per backlog M6 description. |
| CARD-3 | **M7 — Sub-archetype cohesion audit (15 archetypes)** | open in backlog | M | Spine cards need 2+ shared keyword refs to deliver an identity by turn 4. | Per backlog M7 description. |
| CARD-4 | **Card balance audit v0.3 — post-mana-ramp (3-8) lock** | not started | M | Mana ramp locked at 3-start, 8-cap. Card pool was costed pre-lock. | Audit deck of all ~200 cards, flag cost / power outliers, suggest deltas. |
| CARD-5 | **Per-card art-text overflow audit** | not started | S | Mobile portrait card frame restricts text length to ~110 chars; some current cards exceed. | Per-card character-count audit, suggest abbreviation pass. |
| CARD-6 | **Token cards — explicit canonical list + draftable rules** | partial (Bog-Spawn / Cub-Token / Wolf-Token / Withered Servant / Familiar named) | S | Token-card system referenced across 20+ docs; no canonical token registry. | `tokens_v0.md` — registry, draftable=false rule, anti-Persist rule, summon source per token. |

---

## Audio (P2)

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| AUD-1 | **Per-faction leitmotif spec — 5 themes** | not started (referenced in HANDOVER §5: "Each faction has a leitmotif") | M | Audio identity. Procedural generation (Suno) viable per HANDOVER. | `audio_leitmotifs_v0.md` — per-faction key, tempo, instrumentation, 30-sec loop spec + 4-bar stinger. |
| AUD-2 | **SFX library spec — 40-event sound catalogue** | partial (3 SFX stubs in IMV-1 per `internal_mvp_scope.md`) | M | Per-event SFX list needed before SFX hunting. | `audio_sfx_v0.md` — 40-event table (card-play / unit-summon / unit-hit / unit-death / spell-cast / trap-trigger / shrine-pray / etc.) with source preference (Sonniss / Freesound / generated). |
| AUD-3 | **Hanging Hour sting + ambient bell-toll** | spec'd at concept (GP-8) | S | The signature audio moment. | 1 sting (2 sec) + 1 ambient loop (8 sec) spec'd. |

---

## Tooling / Build pipeline (P1-P3)

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| TOOL-1 | **PAT scope fix — add MobileGame + ml2-consulting** | blocked-on-Paul (per `2026-05-18_progress_gallowfell_ml2.md`) | S | Github push blocked. | Paul adds repos to PAT or generates classic PAT. |
| TOOL-2 | **B3.0a — first-pod smoke test** | not started — Paul-runnable | S | Gates all art generation. | Per backlog B3.0a. |
| TOOL-3 | **B3.0c — author workflow JSON** | not started — gated on B3.0a | S | Required for Stage A renders. | Per backlog B3.0c. |
| TOOL-4 | **B3.0d — RunPod automation script** | not started — gated on B3.0a | M | Per backlog B3.0d. | Per backlog B3.0d. |
| TOOL-5 | **B3.1 — Apple Developer enrolment** | blocked-on-Paul | S | iOS build gate. | Paul enrols, $99/yr. |

---

## Art pipeline (P3 — heartbeat-driven, deferred where possible)

| ID | Title | State | Effort | Why-it-matters | "Done" looks like |
|---|---|---|---|---|---|
| AP-1 | **A-SPEC-1..7** all complete | ✅ done | — | — | — |
| AP-2 | **D-WORKFLOW-1 + D-WORKFLOW-2** complete | ✅ done | — | — | — |
| AP-3 | **216-card validation against anchors (post Stage B)** | future — gated on GFX-1/2 | L | After validation, ~20-30% common-card rerolls expected. | Per-card pass/fail audit. |
| AP-4 | **Frame asset authoring (cross-ref GFX-3)** | spec'd | L | See GFX-3. | Combined. |
| AP-5 | **Sigil rendering (cross-ref GFX-12)** | spec'd | S | See GFX-12. | Combined. |
| AP-6 | **Cursed-treatment + Ultimate-treatment shader implementations** | partial (`shader_stack_design.md` defers shader bodies to T2.1-T2.9) | L | Treatments without shaders are placeholder UI. | Per `shader_stack_design.md` open Q1; needs faction-frame swap decision first. |

---

## CONFLICTS found (flagged for Paul)

| Code | Conflict | Resolution proposed |
|---|---|---|
| **CONFLICT: run structure** | `gdd_v0.md` says "16 nodes / 4 acts" with branching map. `2026-05-18_gallowfell_balance.md` locked "8 sequential combats, no branching". `monetisation_map.md` §journey-diagram shows "16 nodes / 4 acts" too. | Balance doc wins (most recent + IMV-1 lock). Refresh `gdd_v0.md` → `gdd_v1.md` (cross-ref DES-1). |
| **CONFLICT: card pool size** | `gdd_v0.md` says "300+ cards by D30". `internal_mvp_scope.md` says "120 cards" for IMV-1 + L1-L40 + W1-W40 on disk but hidden. | IMV-1 scope lock wins. Note: 200 cards (5 × 40) authored across `cards_*_v1.md`, plus P41, C41, C42 added later — true launch pool = ~203 + relics. |
| **CONFLICT: monetisation MVP coverage** | `monetisation_map.md` "What's in MVP" table = run-shop ✅ + gold IAP single SKU ✅. `internal_mvp_scope.md` says "Monetisation: stubbed only — IAP buttons present, no real SDK". | Resolve by stating: IMV-1 = IAP buttons only (no SDK). First-commercial-pass (post-IMV-1, pre-soft-launch) lights up the §"MVP" column of monetisation_map. |
| **CONFLICT: Warlord count** | `warlords_v0.md` = 10 Warlords. `warlords_v1.md` = 11 (incl. W11 lore-locked Saint That Should Not Hang). HANDOVER §5 says "10 Warlords". | warlords_v1.md wins (most recent, incorporates lore_gallowfell.md). Refresh HANDOVER §5. |
| **CONFLICT: Coven flagship card 3-shadows trigger** | `faction_bible.md` v1 says Mother Quag triggers "every 3rd enemy killed this turn". `archetypes_v0.md` and `cards_coven_v1.md` C6 may say "every 3 enemy kills this combat". | Resolve toward faction_bible (recent v1). Spot-check C6.tres + cards_coven_v1.md and harmonise. Flag for Paul; potentially mechanical implication. |
| **CONFLICT: subscription price + name** | `monetisation_map.md` doesn't surface the "Ascendant Pact" subscription. HANDOVER §5 mentions it at £4.99/mo. | Add §"Subscription" to `shop_economy_v0.md`. |

---

## Decisions Paul needs (Top 5)

1. **Currency naming lock.** 5 currencies (Gold / Bones / Souls / Marrow Shards / Gems) are referenced inconsistently. Lock the canonical names + 1-line role per currency.
2. **Season Pass core promise.** £4.99 for 50 tiers — what's the 1 hero reward per season that nails the SKU? (Skin? Alt-art? Warlord-shard cache? Exclusive Cursed treatment?)
3. **Variants — paid Warlord skin gate.** Open Q3 in `monetisation_map.md` §"Open questions" — does paying for a Warlord *skin* require also owning that paid Warlord? (Recommend: yes — skin is a topcoat, not a unlock.)
4. **Ascension ladder length.** StS = A20. Hades = 32 heat. Pick a lane (recommend A20 — industry-standard, well-understood) + whether per-Warlord modifiers exist at every rung or only on milestone rungs (A5/A11/A16/A20).
5. **Daily challenge** — yes / no for soft-launch? Engagement spike, but adds spec scope + leaderboard infra. (Recommend: no for soft-launch, yes for v1.1 patch — keep IMV scope tight.)

---

## How this inventory was built

- Read `backlog.md` (top-to-bottom)
- Read `HANDOVER.md` (top-to-bottom)
- Read `Controller project_/_master/02_Gallowfell.md` (current state header)
- Read `Controller project_/2026-05-18_gallowfell_balance.md` (locked IMV-1 numbers)
- Read `Controller project_/2026-05-18_progress_gallowfell_ml2.md` (M8 close + PAT block)
- Spot-read `monetisation_map.md` / `lore_gallowfell.md` / `faction_bible.md` / `warlords_v1.md` / `warlord_tiers_full.md` / `bosses_v0.md` / `events_v0.md` / `internal_mvp_scope.md` / `collection_ui_v0.md` for cross-reference
- Grep'd 2 queries (season pass / shop) across the project to find scattered references

— Controller, 2026-05-21
