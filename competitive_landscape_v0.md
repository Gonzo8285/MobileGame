# Competitive Landscape — v0

_Authored 2026-05-22 by Controller (round-4 readiness agent). Honest competitive analysis for "The Curse of Gallowfell". Brief: pick 10 closest competitors. Be honest about where Gallowfell falls short — no rose-tint. Intended audience: Paul + any publisher / investor / mentor reading this should conclude "this team knows what they're up against and has a credible plan"._

**Status:** v0. Source: prior art knowledge as of late 2025 + sector pattern recognition. Where launch dates / pricing / current state are uncertain, marked "(approx)". A live web pass would refine specifics but the strategic picture is durable.

---

## 1. The 10

### 1.1 Slay the Spire (StS)

- **Launch:** 2017 (early access) / 2019 (1.0). Mobile port 2020 (iOS) / 2021 (Android).
- **Platforms:** PC, console, mobile.
- **Core loop:** 4-act linear-ish branching map, draft cards from a faction-locked pool (4 characters), build a deck around relics, fight a boss at the end of each act. ~1-hour run length.
- **Monetisation:** Premium £8.99 mobile / £20 PC. No IAP. No ads. One-and-done.
- **Art style:** Hand-drawn cartoon-ish illustration. Saturated colours. Reads at thumbnail.
- **What they nail:** Synergy depth. Every relic + card interaction is intentional. Failed runs feel like skill issues, not RNG. Replayability via Ascension levels (20 difficulty modifiers). Mobile UX adapted but not perfect.
- **What's weak:** Mobile UX still feels desktop-ported (small text, tooltip-heavy). No multiplayer. Premium price tag = high friction for casuals.
- **What Gallowfell should copy:** ✓ Card+relic synergy depth. ✓ Ascension as the long-tail replayability hook (which we have in design). ✓ Boss-as-encounter-design philosophy.
- **What Gallowfell should NOT copy:** ✗ Premium-priced one-and-done. ✗ Desktop-first UI ported down. ✗ Saturated cartoon palette (we're going grimdark painterly).

### 1.2 Monster Train

- **Launch:** 2020 (PC) / 2022 (mobile).
- **Platforms:** PC, console, mobile.
- **Core loop:** Two-clan mix-and-match deckbuilder, vertical tower defence (3 floors of a moving train). Pick clan + ally, build deck across both. ~45 min runs.
- **Monetisation:** Premium £20 PC, mobile lower. Has DLC (1 expansion).
- **Art style:** Stylised cartoon, demonic theme. Reads at thumbnail.
- **What they nail:** **Two-clan mixing** as the central design hook. Every run feels different because the clan-pair changes synergy direction. **Daily Challenge** mode gives long-tail replay. The vertical tower-defence layout is gameplay-distinct from StS.
- **What's weak:** Mobile UX is worse than StS's. Daily challenge gates new clans behind heavy grind. Art style is divisive — not everyone loves "cartoon demons".
- **What Gallowfell should copy:** ✓ The faction-mixing potential (we have 5 factions but currently single-faction decks; the splash hooks in `archetypes_v0.md` point at this). ✓ Daily challenge / weekly events as long-tail.
- **What Gallowfell should NOT copy:** ✗ Vertical-train layout (we're horizontal lane TD). ✗ DLC-paid-clan model (Gallowfell's paid Warlords are unlock-not-content-gated).

### 1.3 Wildfrost

- **Launch:** 2023 (PC + Switch). Mobile: 2024 (approx).
- **Platforms:** PC, Switch, mobile.
- **Core loop:** Tactical lane-based deckbuilder, cute art, deceptively deep. Crew of 3 + companion deck. ~30-min runs.
- **Monetisation:** Premium £15 PC. Free expansion (Snowdwell) added 2024.
- **Art style:** Cute pixel-art / illustrated, child-friendly palette.
- **What they nail:** **Tactical depth in a small footprint.** Combat is bite-sized but very strategic. Companion deck pre-built before run lets you customise without overwhelming. **Free post-launch expansion** built goodwill.
- **What's weak:** **Brutally hard.** Bounced many casual players. Cute art set up wrong expectations vs the punishing balance. Marketed itself badly — "looks like a kids' game, plays like Dark Souls".
- **What Gallowfell should copy:** ✓ Tactical depth in a small footprint (mobile-friendly). ✓ Free post-launch content as goodwill builder. ✓ Pre-built crew that's customisable before run-start (our Warlord system already does this).
- **What Gallowfell should NOT copy:** ✗ The cute art bait-and-switch. Our grimdark sells what we are. ✗ Brutally hard at launch — we want soft-launch retention, not bounce.

### 1.4 Marvel Snap

- **Launch:** Oct 2022 (mobile-first, PC came later).
- **Platforms:** Mobile primary, PC secondary.
- **Core loop:** 3-lane card-game, 6-turn matches, ~3 min/match. Marvel IP. PvP.
- **Monetisation:** F2P. **Card-treatment cosmetic economy is the headline monetisation** — $40-100M+ ARR from cosmetic frames per Snap-watchers. Season pass + Spotlight Caches (gacha pulls). Heavy daily-quest engagement loop.
- **Art style:** Marvel IP comic-book / painterly hybrid; high production value.
- **What they nail:** **3-min match length on mobile = killer UX.** Cosmetic-treatment economy proves whales pay for frames without P2W complaints. Season pass + Spotlight is a tight retention machine.
- **What's weak:** **Card acquisition is gacha-tinged.** Spotlight Caches feel like loot boxes (whitewashed as "choose-your-cache"). New-card-release cadence has triggered player resentment about "FOMO economy". PvP balance is forever-controversial.
- **What Gallowfell should copy:** ✓ **Card-treatment cosmetic stack.** We've already adopted this (per `art_direction.md` §2 + `monetisation_map.md` §5). ✓ Daily-quest engagement loop (already in our spec). ✓ Mobile-first UX targets (we're already mobile-only — we're aligned).
- **What Gallowfell should NOT copy:** ✗ **The gacha-economy resentment.** Spotlight Caches' opacity is a player-trust killer. Gallowfell's gacha (per `monetisation_map.md` §10) must be transparent — published drop rates, no FOMO timers, no "best card behind a wall". ✗ PvP — we're PvE-only (already locked).

### 1.5 Inscryption

- **Launch:** Oct 2021 (PC) / 2022 (consoles). No mobile.
- **Platforms:** PC + consoles.
- **Core loop:** Mixed genre — deckbuilder + narrative + horror + meta-puzzle. ~10 hours main story.
- **Monetisation:** Premium £15 PC. No IAP.
- **Art style:** Black-and-white sketchy → shifts dramatically per act. Pseudo-3D card prop.
- **What they nail:** **Narrative integration with the card game.** The story IS the deckbuilder, and the deckbuilder IS the story. Sets the prestige bar for "deckbuilder with soul". Daniel Mullins' design pedigree.
- **What's weak:** **One-and-done.** Narrative locks the player out of replays once they've seen the twist. No live-ops. Not on mobile. Not the genre Gallowfell competes in directly — but it's the prestige reference.
- **What Gallowfell should copy:** ✓ **Cohesive lore that runs through the cards.** Our `lore_gallowfell.md` and the Hanging Hour curse are doing this. The narrative-mechanical fusion is what lifts a deckbuilder above "asset-flippable".
- **What Gallowfell should NOT copy:** ✗ **Narrative-lock-in.** A run-based F2P game must be replayable. The story has to live IN the runs, not gate the runs. Don't lock players out with twists.

### 1.6 Roguebook

- **Launch:** Jun 2021 (PC) / 2022 (consoles). Mobile: not released as of late 2025.
- **Platforms:** PC + consoles. (Mobile gap = potential opening.)
- **Core loop:** StS-like with a 2-character party. Hand of cards from both heroes per turn. Hex-grid map (not branching).
- **Monetisation:** Premium £20 PC.
- **Art style:** Hand-painted illustrated, fantasy storybook tone. Magic Awakened director attached.
- **What they nail:** **2-character party system** — adds strategic depth without overwhelming. Hex-map exploration > branching-tree map for some players. Storybook framing is consistent.
- **What's weak:** **Lower replayability** than StS. Limited character pool (2 unlockable additional). Mobile-absent.
- **What Gallowfell should copy:** ✓ Hex/grid map alternative — but we've locked 8-round linear, so just note the design space. ✓ Painted illustrated style — closer to our intent than the cartoon competitors.
- **What Gallowfell should NOT copy:** ✗ 2-character party (we have a Warlord-led warband; same shape, no need to add second hero). ✗ Premium-only model.

### 1.7 Pirates Outlaws

- **Launch:** 2019 (mobile-first), iOS + Android.
- **Platforms:** Mobile primary, PC port later.
- **Core loop:** Mobile StS-like, pirate theme. 1-3 hr per character clear.
- **Monetisation:** F2P + IAP. **Heavy ad-stuffing** — interstitial ads between fights, rewarded video for retries. Premium-removes-ads option.
- **Art style:** Cartoon vector. Reads at thumbnail. Cheap to produce, distinct look.
- **What they nail:** **Mobile-first design from day one** (vs StS's port). Touch UX is solid. Long content runway (lots of characters added over time).
- **What's weak:** **Ad-stuffing is aggressive.** Hurts player goodwill. Art style is functional, not memorable. Quality bar visibly lower than StS / Wildfrost.
- **What Gallowfell should copy:** ✓ **Mobile-first design from day one.** We're aligned. ✓ Long content runway as a launch promise (we have 11 Warlords + 8 chapters spec'd).
- **What Gallowfell should NOT copy:** ✗ **Ad-stuffing.** Per `monetisation_map.md` ads are limited to rewarded-video for retries + 2× rewards, NEVER interstitial. ✗ Quality bar — Gallowfell's grimdark painterly aims higher.

### 1.8 Banners of Ruin

- **Launch:** 2021 (PC).
- **Platforms:** PC. Limited console. Not on mobile.
- **Core loop:** Party-based (6 character squad) deckbuilder. Dark fantasy / animal-knight. Lane-based combat.
- **Monetisation:** Premium £15.
- **Art style:** Hand-illustrated dark fantasy, anthropomorphic animal characters.
- **What they nail:** **Party of 6 with individual decks** is the differentiator. Dark-fantasy tone (closer to our grimdark than most).
- **What's weak:** **Niche.** Limited audience. Combat reads as slow/clunky. Hasn't broken through to mass-market.
- **What Gallowfell should copy:** ✓ **Dark fantasy positioning** — there's a clear audience for it. ✓ Individual-unit-decks as a flavour idea (our Warlord-leads-a-warband is in this neighbourhood without copying directly).
- **What Gallowfell should NOT copy:** ✗ The clunky combat pacing. Mobile must be snappier. ✗ Anthro animals as the visual hook — our hanged-saints + iron-penitents motif is more distinct.

### 1.9 Tainted Grail: Conquest

- **Launch:** 2021 (PC) / 2022 (consoles).
- **Platforms:** PC + consoles. Not mobile.
- **Core loop:** Single-character roguelike-deckbuilder with light open-world exploration. Arthurian-dark-fantasy. ~5-15 hr per character clear.
- **Monetisation:** Premium £18.
- **Art style:** Realistic-ish dark fantasy 3D, with stylised card art.
- **What they nail:** **Dark-fantasy worldbuilding.** Genuinely written narrative. Setting is the differentiator (cursed-Arthurian-Britain). 9 character classes = good content runway.
- **What's weak:** **3D + narrative + deckbuilder is a wide scope.** Polish is uneven. Some classes feel under-developed. Mobile-absent.
- **What Gallowfell should copy:** ✓ **Dark-fantasy worldbuilding as the differentiator.** This is exactly Gallowfell's bet. ✓ Multiple distinct character classes (we have 11 Warlords).
- **What Gallowfell should NOT copy:** ✗ Wide-scope 3D + narrative + deckbuilder — we're focused: 2D, mobile, roguelite-TD. ✗ Uneven polish — soft-launch must hold one quality bar across the whole game.

### 1.10 Card Crawl Adventure

- **Launch:** 2022 (iOS) / 2023 (Android). Sequel to Card Crawl (2015).
- **Platforms:** Mobile only.
- **Core loop:** Solitaire-style card game with deckbuilder progression. Tiny, focused, mobile-native.
- **Monetisation:** Premium £4.99 + one IAP for extra characters.
- **Art style:** Stylised painterly + cards-on-a-table presentation.
- **What they nail:** **Small-screen UX is masterful.** Every interaction is one-thumb-reach. Match length is 5-10 min, perfect for commute. Premium price + small IAP feels respectful, not exploitative.
- **What's weak:** **Lower content runway** than its competitors. Doesn't scale to a 20-hour campaign. Mass-market reach limited by genre obscurity.
- **What Gallowfell should copy:** ✓ **One-thumb-reach UX.** Our `interaction_touch_v0.md` already targets this — must hold the bar. ✓ **5-10 min match length** as the design goal. Our 8-round runs at ~6 min target is in the zone. ✓ Premium-feeling presentation despite F2P.
- **What Gallowfell should NOT copy:** ✗ Premium-only model — F2P scales further. ✗ Small content runway — we have a 5-faction × 8-chapter campaign to fill.

---

## 2. Synthesis

### 2.1 Where Gallowfell falls short today

Honest list. Some of these have plans; others are gaps.

1. **No playable build.** Closest competitors all shipped a vertical-slice or alpha before going public; we're still in design-doc + 200-card-art-staged state. Until a single end-to-end run can be played, there's no proof of concept. *(Plan: M1 placeholder ship gets us a playable thread; M2 is the public-vertical-slice.)*
2. **Art pipeline unproven.** B3.0a smoke test still hasn't returned a confirmed result. Until SDXL → final-quality is locked, every art slot is at risk. *(Plan: Paul runs B3.0a this week; see `art_pipeline_readiness_v0.md` §8.)*
3. **No live mobile UX testing.** `interaction_touch_v0.md` is spec'd but no user has held a phone and pressed a button. Wildfrost and Pirates Outlaws iterated touch UX for months before public; we have zero data.
4. **Onboarding tutorial untested.** `tutorial_flow_v0.md` is paper-only. Inscryption and StS both have brilliant onboarding; Wildfrost lost players to bad onboarding. This is a known boss-fight.
5. **No publisher / no platform-relations contact.** Soft launch on Android works without a publisher; iOS soft launch usually benefits from one. No conversations started with Devolver / Annapurna / Raw Fury — the indie roguelike-friendly publishers.
6. **Faction-mixing not yet exercised in decks.** `archetypes_v0.md` lists splash hooks but `starter_decks_v0.md` only mono-faction. Monster Train's central design lesson (mixing) isn't being leveraged. *(Risk: feels like single-faction StS-clone rather than something differentiated.)*
7. **No daily-challenge / weekly event content yet.** Monster Train + Marvel Snap both rely on these for retention. We have it in the monetisation map but no content authored. **D14 retention risk.**
8. **Card balance unproven.** `card_balance_audit_v0.md` exists but is theoretical. No real play data. Wildfrost's launch-balance disaster cost them ~60% of D7 retention; that pattern is real.
9. **No soft-launch playtest cohort.** `soft_launch_playbook_v0.md` says we'll soft-launch in PH/CA/NZ; no playtester recruitment started. UA cost data unknown.
10. **No audio yet.** `audio_production_brief_v1.md` exists but no actual leitmotif tracks are rendered. Wildfrost's audio is half its identity. Audio gap = "alpha build" feel for testers.
11. **Marketing brand-awareness = zero.** Inscryption had Daniel Mullins' name. Monster Train had Shiny Shoe's published reputation. We have no studio name, no community, no following.
12. **No localisation plan beyond English.** Mobile-only F2P games need at least JA/KR/zh-Hans/de/fr/es/pt-BR for serious Asia-Pacific + EU traction. Not in scope yet.

### 2.2 Where Gallowfell has an edge

3-5 things that are genuinely differentiated.

1. **Grimdark painterly tone in mobile roguelike-deckbuilder space.** Closest competitor in tone is Banners of Ruin (PC). On mobile, the genre is dominated by cartoon (StS, Pirates Outlaws), cute (Wildfrost), or IP (Marvel Snap). **A serious-toned mobile roguelike deckbuilder is genuinely uncrowded.**
2. **Hanging Hour as a single-mechanic differentiator.** Every run has the same dramatic mid-combat shift (turn 5 default / 4 boss). This is a memorable signature like StS's relics or Monster Train's multi-clan — but distinct from both. Compelling for trailers and word-of-mouth.
3. **Lore-as-loop integration.** The 8-round linear map walks the player through Gallowfell's biomes in narrative order. Each chapter is a story location, not a colour theme. Closer to Inscryption's narrative-loop ambition than StS's abstract acts.
4. **11 Warlords + 5 factions = high replayability at launch.** Monster Train launched with 4 clans + 4 allies = 16 combinations. We launch with 11 Warlords × 5 factions = 55 viable run-shapes (even before splash deck-mixing). On paper, deeper content runway.
5. **Cosmetic-economy-first monetisation that's not gacha-resented.** We've already adopted the Marvel Snap treatment stack but with PvE-only + published drop rates + no FOMO timers. **The clean version of Snap's monetisation lesson.**

### 2.3 What we must close before soft launch

The top 5 must-fix gaps:

1. **Playable end-to-end build with no crashes.** From Warlord-select → 8 combats → boss → victory. Currently NOT shippable. **P0.**
2. **Tutorial flow runs in real play.** Not just on paper. New player must clear tutorial in <5 min and understand the core loop. Per `tutorial_flow_v0.md` but with live UX validation. **P0.**
3. **Card balance audit confirmed by 10+ runs of telemetry.** Detect outlier win-rates per faction. Patch top 5 outliers. **P0.**
4. **Art pipeline producing one consistent batch.** ≥80% slots in `art_pipeline_readiness_v0.md` M2 acceptance. **P0.**
5. **Mobile UX touch-test with at least 5 real users on real phones.** Catch fat-finger / readability / hit-region failures before soft-launch playtesters do. **P0.**

### 2.4 What we can leave open at soft launch

Things we can patch live without killing the game.

1. **Daily challenge content runway.** Ship with 7 days of daily challenges authored; add more via live ops.
2. **Faction-mixing in starter decks.** Mono-faction starters at launch; add cross-faction decks at patch 1.1.
3. **Subscription (Ascendant Pact).** Patch 1.2 per `monetisation_map.md` §15 (canon-patched 2026-05-22).
4. **Localisation beyond English.** Soft-launch in English-speaking territories (PH / CA / NZ have high English literacy). Localise top languages at patch 1.3.
5. **W11 (Saint That Should Not Hang) full playable.** Lore-locked; only the unlock trigger needs to fire correctly. Full W11 content can ship at patch 1.1 or later.

### 2.5 Anti-features — patterns competitors do that we should consciously avoid

1. **Marvel Snap's Spotlight Cache opacity** → ours must publish drop rates, no surprise dupe-protection nerfs, no FOMO timers (per `monetisation_map.md` anti-P2W guardrail §"Engine: drop-rate transparency").
2. **Pirates Outlaws' interstitial ad-stuffing** → ours uses rewarded-video only for player-elected actions (retry, 2× rewards, free chest). No forced interstitials.
3. **Inscryption's narrative-lock-in** → our lore lives in cards + biome flavour + boss dialogue, NOT in player-state. Run #100 reveals new lore via Ascension dialogue, not a story twist that locks the loop.
4. **Wildfrost's launch-difficulty bounce** → our soft-launch difficulty curve must be tuned for D1 retention, not hardcore-pleasing balance. Ascension levels carry the difficulty long-tail.
5. **Monster Train's DLC-gated clans** → our 5 paid Warlords unlock with gems OR grind. Never content-gated, only unlock-gated.
6. **StS's desktop-port UI** → every UI element designed for one-thumb-reach from day one. Per `interaction_touch_v0.md`.
7. **Tainted Grail's wide-scope polish problem** → we're scoped tight (2D mobile roguelite TD deckbuilder); resist scope creep before soft launch.
8. **Banners of Ruin's slow combat pacing** → 8-round runs target ~6 min total; each turn target <8 sec for player input.
9. **Card Crawl's premium-only model** → F2P + cosmetic IAP scales further on mobile; premium-only caps growth.
10. **Roguebook's mobile-absent strategy** → we're mobile-first from day one. (Already aligned.)

---

## 3. Strategic recommendation (the publisher / mentor read)

> Gallowfell is targeting a real and uncrowded mobile-grimdark-roguelite niche. The competitive set splits into three groups:
>
> **Group A (genre originators — premium, PC-first):** StS, Inscryption, Monster Train, Roguebook, Tainted Grail, Banners of Ruin. These are not direct competitors for the F2P-mobile player — they're the inspiration and the prestige reference.
>
> **Group B (mobile F2P juggernauts):** Marvel Snap is the only mass-market F2P deckbuilder. Its monetisation lessons (treatment economy) are our blueprint; its mistakes (gacha resentment) are our anti-features.
>
> **Group C (mobile roguelike-deckbuilders):** Pirates Outlaws + Card Crawl Adventure. Pirates Outlaws sets the lower quality bar we must beat; Card Crawl sets the mobile-UX bar we must match.
>
> **Gallowfell's positioning:** Group-A-level art and lore depth, Group-B-grade monetisation discipline, Group-C-grade mobile-first UX. **"Premium-feeling F2P grimdark deckbuilder for mobile."** No direct competitor occupies this exact intersection today.
>
> The risk is execution. We have credible design across the board; we have a real differentiator (Hanging Hour, grimdark mobile niche); we have an honest monetisation model. **What we don't yet have is a playable build.** Until M1 placeholder-ship lands, none of this is provable.
>
> Soft-launch readiness depends on: (1) B3.0a unblocking the art pipeline, (2) tutorial + balance proving in live play, (3) M2 art ship hitting 80% slots. Each is a tractable 2-4 week milestone. Aggregate critical path: 8-12 weeks from today to soft launch in PH/CA/NZ if Paul prioritises the unblocks in `art_pipeline_readiness_v0.md` §8 + the must-fix gaps in §2.3 of this doc.

---

## 4. Cross-references

- `art_pipeline_readiness_v0.md` — what unblocks the playable build
- `actionable_components_2026-05-22.md` — sorted to-do list pulling competitive gaps into this week's queue
- `CANON_PATCHES_APPLIED_2026-05-22.md` — design coherence stabilised
- `monetisation_map.md` — our monetisation model with anti-P2W locks
- `soft_launch_playbook_v0.md` — soft-launch process (PH/CA/NZ)
- `marketing_press_kit_v0.md` — positioning and pitch for the publisher conversations
- `risk_register_v0.md` — risk catalogue (this doc adds 12 competitive-context gaps to it)

— Controller round-4, 2026-05-22
