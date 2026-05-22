# Soft-Launch Playbook v0 — The Curse of Gallowfell

_Authored 2026-05-22 by Controller (round 2). Operational playbook for the 14-day soft-launch window. Covers cohort sourcing, TestFlight + Play Console internal track setup, daily KPI check-ins, the pass/fail bar to open to broader test, store screenshot brief, and pricing/region notes. Builds on `GDD_v1.md` §9 (high-level KPI table) — this doc is the operational expansion._

**Status:** v0 spec. Pending: Paul Apple Developer enrolment (per `GALLOWFELL_BACKLOG_INVENTORY_2026-05-21.md` TOOL-5), Google Play Console enrolment ($25 one-off), 50-tester cohort sourced.

---

## 1. Soft-launch goal

A 14-day, geo-limited, invite-only test that proves:

1. **Retention bars hold** (D1 ≥ 40%, D3 ≥ 25%, D7 ≥ 15%) → the game is fun to come back to.
2. **Monetisation funnels work** (IAP conversion D7 ≥ 2.5%, ARPDAU ≥ £0.10) → the shop loop converts.
3. **Crashes are sub-1%** → engine is shippable.
4. **Tutorial completion is ≥ 85%** → first 3 min holds.
5. **No P2W complaints** → anti-P2W invariant survives contact with real wallets.

If 3 of 4 retention bars + 1 monetisation bar hold AND crashes <1% AND tutorial-completion ≥ 85%, **open to broader test** (Play Console open beta + larger TestFlight cohort). Otherwise **pause for tuning patch**, re-run cohort.

---

## 2. Build infrastructure

### 2.1 iOS — TestFlight

- **Account:** Apple Developer Program enrolment ($99/yr — Paul-action, blocked-on-Paul per `GALLOWFELL_BACKLOG_INVENTORY_2026-05-21.md` TOOL-5).
- **Build pipeline:** GitHub Actions builds Godot iOS export → uploads .ipa to App Store Connect via `xcrun altool` → TestFlight processes (~10 min) → invite list notified by email.
- **Build cadence during soft-launch:** every 3 days minimum. Hot-patch within 24 hr for any P0 crash bug.
- **Invite mechanism:** TestFlight public link (max 10,000) OR email invite list (max 100 internal, 10,000 external). For 50-tester cohort: email invite (more control).
- **App Store Connect setup:**
  - App name: "Gallowfell" (test build) — final name TBD
  - Bundle ID: `com.ml2.gallowfell.beta`
  - SKU: `gallowfell-beta`
  - Privacy policy URL: required — Paul-action, draft at `secrets/privacy_policy_draft.md`
  - Test info: contact email = `Paul.mccann@rtkeedwellgroup.co.uk`

### 2.2 Android — Play Console internal track

- **Account:** Google Play Console ($25 one-off — Paul-action).
- **Build pipeline:** GitHub Actions builds Godot Android export → signs with upload key → uploads .aab via Google Play Developer API → "Internal track" auto-promotes to invite list.
- **Build cadence:** match iOS (every 3 days).
- **Invite mechanism:** Google Group with the 50 testers' Gmail addresses. Tester opt-in link distributed via Google Group invite.
- **Play Console setup:**
  - Package name: `com.ml2.gallowfell.beta`
  - Internal testing track: enabled
  - Closed testing track (post-internal): prepared but disabled
  - Privacy policy URL: same as iOS
  - Test info: contact email = `Paul.mccann@rtkeedwellgroup.co.uk`

### 2.3 Analytics + crash reporting

- **Firebase Analytics** wired (HANDOVER §6).
- **Crashlytics** wired (HANDOVER §6).
- **GameAnalytics** wired (HANDOVER §6) for funnel-specific dashboards.
- **Daily cron job (Cowork heartbeat-style):** at 09:00 UK, pull yesterday's KPIs from Firebase + GameAnalytics, post to `G:\My Drive\ClaudeBridge\projects\gaming-app\softlaunch\daily_kpi_<DATE>.md`.

---

## 3. Cohort — 50 testers

### 3.1 Target profile

- **Geographies:** UK 25 + Philippines 15 + Canada 10 (English-language, low-cost CPI markets, time-zone spread for 24-hour drop-off visibility).
- **Platform:** 30 Android + 20 iOS (Android cheaper to recruit, iOS skews payer-favourable for monetisation reads).
- **Demographics target:** 60% age 25-45, 30% age 18-24, 10% age 45+. M/F 65/35. Mobile-game-savvy (has played at least one of: Slay the Spire mobile, Marvel Snap, Backpack Hero, Inscryption).
- **Time commitment:** 14 days, ≥ 30 min per day on 10 of 14 days. Daily KPI check-in optional but encouraged (Discord channel).

### 3.2 Sourcing plan

| Source | Target count | Mechanism | Cost | Risk |
|---|---|---|---|---|
| **Paul's network** | 8 | Direct outreach by Paul — friends, family, JSM colleagues who play mobile games | £0 | Bias toward friendly feedback; need to actively solicit harsh comments |
| **Discord — r/Slaythespire community** | 12 | Post in their #beta-tests channel (mod-approved). Offer free game on launch. | £0 + 12 launch codes | Slow recruitment, ~3-day lag |
| **Subreddit r/MobileGaming** | 8 | Post in their weekly "beta test sign-up" megathread | £0 + 8 launch codes | Some sign-ups bail before D1 |
| **Subreddit r/incremental_games** | 6 | Similar weekly thread | £0 + 6 launch codes | Audience skew (incremental ≠ deckbuilder; mixed-fit) |
| **Discord — r/roguelikes / r/deckbuilders** | 10 | Post in #showcase or #playtest-requests | £0 + 10 launch codes | Best-fit audience; will give harshest feedback |
| **TestFlight directory boards** (e.g. testflight.io listings) | 6 | Free listing | £0 | High abandon rate — TestFlight directories full of "collect every beta" users who don't actually play |
| **TOTAL** | **50** | | **£0 cash + 42 launch codes (=£0 — game is F2P)** | — |

### 3.3 Sourcing timeline

- **T-14 to T-10 days (before soft-launch start):** post recruitment threads to all 6 sources. Reach 100 sign-ups. Filter to 60 with brief Google Form (age, region, platform, mobile-game experience).
- **T-9 to T-6 days:** screen the 60 → 55 (drop bot-likes and zero-engagement responses).
- **T-5 days:** send TestFlight / Play Console invites to top 55 (10% redundancy buffer for invite-never-redeemed).
- **T-3 days:** first build live in TestFlight + Play Console. Build #1 = "preview build" (Hub + tutorial + first run only — checks plumbing).
- **T-1 day:** build #2 = full soft-launch build (all 8 chapters, IAP wired, analytics wired). 50 testers redeem.
- **Day 0:** soft-launch starts at 10:00 UK time. Discord channel `#gallowfell-soft-launch` opens.

### 3.4 Tester support

- **Discord channel** with 3 sub-channels:
  - `#bugs-and-crashes` — moderated, structured template (steps to reproduce, device, OS version, screenshot)
  - `#feedback-and-discussion` — open chat
  - `#playthrough-clips` — voluntary video uploads
- **Direct contact:** Paul email + Controller heartbeat checks Discord every 4 hours.
- **Tester rewards:**
  - 14-day completion: 1,000 gems + exclusive "Beta Tester" card-back cosmetic at v1.0 launch
  - 5 high-quality bug reports: +500 gems each
  - Top 3 "constructive feedback contribution": permanent Tier-4 mastery skin on choice of free Warlord

---

## 4. 14-day soft-launch schedule + daily KPI check-in

| Day | Window | Activity | KPI focus |
|---|---|---|---|
| Day 0 | Launch day | 50 testers redeem. Discord opens. Build #2 live. First plays start. | Install rate; crash-free rate; tutorial start |
| Day 1 | Morning | Pull D0 / D1 funnel data. Triage Discord bug-reports. | **D1 retention** (first KPI to land) |
| Day 2 | All-day | Hot-patch any P0 crash. | Crash rate, D1 |
| Day 3 | Morning | First retention checkpoint. | **D3 retention.** ARPDAU. |
| Day 4 | All-day | Build #3 ships (bug-fixes + tuning if needed). | — |
| Day 5 | Morning | Mid-week pulse. | D3 trajectory. IAP funnel. |
| Day 6 | All-day | — | — |
| Day 7 | Morning | Week-1 milestone. | **D7 retention. IAP conversion at D7.** ARPDAU. |
| Day 8 | All-day | Build #4 ships if tuning patch needed. | — |
| Day 9 | Morning | Pulse. | D7 trajectory. Session length. |
| Day 10 | All-day | — | — |
| Day 11 | Morning | Pulse. | All KPIs |
| Day 12 | All-day | Build #5 (final soft-launch build). | — |
| Day 13 | All-day | Survey sent to all testers. | Qualitative feedback collection |
| Day 14 | All-day | **Wrap-up + pass/fail call.** Aggregate all metrics. Decision: broader test OR tuning patch. | All KPIs |

### 4.1 Daily KPI dashboard shape

Each morning's dashboard tracks:

```
=== Gallowfell Soft-Launch Day <N> ===
Generated: 2026-MM-DD 09:00 UK

INSTALLS
  Day 0 installs: ___
  Cumulative installs: ___
  Active testers today: ___

RETENTION
  D1 retention: ___% (target ≥ 40%)
  D3 retention: ___% (target ≥ 25%)
  D7 retention: ___% (target ≥ 15%)

TUTORIAL FUNNEL
  Tutorial start rate: ___%
  Tutorial completion rate: ___% (target ≥ 85%)
  Tutorial skip rate: ___%

GAMEPLAY
  Average session length: ___ min (target 8-12 min)
  Sessions per DAU: ___ (target ≥ 2.5)
  Average runs per session: ___
  Run-victory rate (any chapter): ___%
  Boss-defeat rate per chapter: ___%

MONETISATION
  ARPDAU: £___ (target ≥ £0.10)
  Paying users today: ___
  IAP conversion rate (cumulative): ___% (target D7 ≥ 2.5%)
  Top SKU: ___
  Total revenue today: £___

CRASHES
  Crash-free user rate: ___% (target ≥ 99%)
  Top crash signature: ___
  Open P0 bugs: ___

DISCORD ACTIVITY
  Posts today: ___
  Open bug reports: ___
  Open feedback items: ___

DROP-OFF FUNNEL (find the leak)
  Splash → Cutscene: ___% lost
  Cutscene → Tutorial combat: ___% lost
  Tutorial combat → Reward pick: ___% lost
  Reward pick → Warlord pick: ___% lost
  Warlord pick → First map node: ___% lost
  First combat won: ___%
  First combat lost: ___%
```

This dashboard is posted to `G:\My Drive\ClaudeBridge\projects\gaming-app\softlaunch\daily_kpi_<DATE>.md` at 09:00 UK by a Cowork-scheduled task. Mirrored to Discord `#soft-launch-private` for Paul phone-readability.

---

## 5. Pass-fail bar for opening to broader test

Decision criteria at Day 14:

| Criterion | Pass threshold | Outcome if pass |
|---|---|---|
| D1 retention | ≥ 40% | Counts as 1 of 4 retention pass |
| D3 retention | ≥ 25% | Counts as 1 of 4 retention pass |
| D7 retention | ≥ 15% | Counts as 1 of 4 retention pass |
| Tutorial completion | ≥ 85% | Counts as 1 of 4 retention pass |
| ARPDAU | ≥ £0.10 | Counts as 1 of 2 monetisation pass |
| IAP conversion D7 | ≥ 2.5% | Counts as 1 of 2 monetisation pass |
| Crash-free user rate | ≥ 99% | Hard requirement (NOT countable) |
| No "pay-to-win" complaint themes in Discord | ≥ 80% complaint-free | Hard requirement |

**Pass = 3 of 4 retention bars + 1 of 2 monetisation bars + both hard requirements.**

If pass → open to broader test:
- Play Console **open beta** (10,000-user cap, no invite needed — discoverable via Play Store)
- TestFlight **public link** (10,000-user cap, no email gate)
- Marketing push on Twitter/X, Reddit, TikTok, indie game communities (~ £0 cost, organic + word-of-mouth)
- Target: 5,000 installs in week 1 of open beta

If fail → tuning patch + re-run:
- 2-week patch cycle to address top 3 KPI misses (analyse via dashboard drop-off funnel)
- Re-recruit half of the original cohort + 25 new
- 7-day mini-test to verify patch lands

---

## 6. Marketing screenshots — 8 store screenshots brief

Apple App Store + Google Play each require up to 10 screenshots (1080×1920 portrait or 1242×2208 for newer iPhones). **Author 8 store screenshots** — same set for both stores, retake at right resolution.

Each screenshot has: hero visual + overlay text (~3 words headline + ~5 words sub). Text in IM Fell English (UI font from `art_direction.md`).

| # | Hero visual | Headline | Sub-text | Why this screenshot |
|---|---|---|---|---|
| 1 | Warlord-pick screen — all 5 free Warlords visible, Vyrrun centre | **"Eleven Warlords."** | "Pick your reason to march." | Roster sells variety. Hero image. |
| 2 | Combat scene mid-action — friendly units fighting Black-Bell Choir minions; bell-tolling VFX on screen | **"The bell tolls at midnight."** | "Every fight has a Hanging Hour." | Sells the signature mechanic. |
| 3 | Card-pick reward screen — 3 cards face-up, hover-zoom highlight on one | **"Two hundred cards."** | "Every deck builds a different curse." | Card variety + roguelike deck-build sell. |
| 4 | Map view — full 8-pip linear map with player at Ch4 boss | **"Eight chapters. Eight gallows."** | "Each chapter is a new town." | Sells campaign scope. |
| 5 | Card collection screen — treatments grid showing Foil + Gold + Prism + Cursed + Ultimate side-by-side | **"Seven treatments. Twenty-one variants."** | "Make your favourite card legendary." | Sells the cosmetic loop / Snap-style appeal. |
| 6 | Boss combat — Saint That Hangs cinematic shot, all 3 lanes lit, "The Drop" overlay text mid-animation | **"The Drop."** | "Turn 9. Nothing survives." | Sells boss drama. |
| 7 | Ascendant Pact subscription card + Marrow Pass tier 50 reward visible | **"No pay-to-win."** | "Cosmetics only. Always." | Sells anti-P2W positioning. CRUCIAL for trust. |
| 8 | Hub screen — clean overview showing all 5 factions' biomes as tiles | **"Gallowfell remembers everything."** | "And so will you." | Closing/aspirational image. Sells return. |

### 6.1 Variants per region

- **UK / Canada / US:** English text, as above.
- **Philippines:** English-language is dominant in PH mobile gaming. Same screenshots. (Future: Tagalog at v1.1.)

### 6.2 Animated promo (optional)

Apple App Store accepts 30-sec preview video. Google Play accepts featured video.

Recommend authoring a 30-sec gameplay teaser:
- 0:00-0:05 — splash + leitmotif fade in
- 0:05-0:15 — Warlord-pick reveal + combat scene
- 0:15-0:22 — Hanging Hour bell-toll + Toll the Bell resurrection
- 0:22-0:27 — boss defeat + reward
- 0:27-0:30 — title card "The Curse of Gallowfell"

Cost: ~£100-300 for a freelance editor on Fiverr, or £0 if Paul wants to author with iMovie / CapCut from gameplay clips.

---

## 7. Pricing + region notes

### 7.1 IAP price ladder

Per `shop_economy_v0.md` §3:

| SKU | UK price | US price | PH price | CA price |
|---|---|---|---|---|
| Gem Handful (100) | £0.99 | $0.99 | ₱49 | $1.39 |
| Gem Pouch (500) | £4.99 | $4.99 | ₱249 | $6.99 |
| Gem Sack (1,200) | £9.99 | $9.99 | ₱499 | $13.99 |
| Gem Casket (2,800) | £19.99 | $19.99 | ₱999 | $27.99 |
| Gem Hoard (7,500) | £49.99 | $49.99 | ₱2,499 | $69.99 |
| Gem Tribute (18,000) | £99.99 | $99.99 | ₱4,999 | $139.99 |
| Starter Bundle | £4.99 one-time | $4.99 | ₱249 | $6.99 |
| Marrow Pass premium | £4.99 / season | $4.99 | ₱249 | $6.99 |
| Marrow Pass Pass+ | £9.99 / season | $9.99 | ₱499 | $13.99 |
| Faction bundles (×5) | £9.99 each | $9.99 | ₱499 | $13.99 |
| Ascendant Pact subscription | £4.99 / month | $4.99 | ₱249 | $6.99 |

**Localisation strategy:** rely on Apple App Store / Google Play auto-localisation for tiers (each store maps £/$/etc to their local-tier ladder). Manual override only for PH (where auto often over-prices for purchasing power).

### 7.2 Tax + IAP commission

- Apple takes 30% of IAP (or 15% on small-business program — applicable if <$1M/yr in App Store revenue). ML2 Consulting will qualify for small-business 15% rate.
- Google takes 30% / 15% similarly under Play Billing.
- UK / EU VAT auto-handled by Apple + Google for in-app purchases.
- Net revenue per £4.99 SKU = ~£2.95 after store cut + VAT + processing (small-business tier).

### 7.3 Region-launch order (post-soft-launch)

| Phase | Geos | Why |
|---|---|---|
| Soft-launch (this doc) | UK + Philippines + Canada | English-language test markets, low CPI |
| Phase 1 open beta (T+14 from soft-launch end) | + USA + Australia + New Zealand | Anglo expansion |
| Phase 2 open beta (T+30) | + Germany + France + Spain + Italy + Netherlands + Nordics | EU expansion (English-only OK initially, localisation v1.1) |
| Global launch | + ALL App Store / Play Store regions | v1.0 worldwide |

---

## 8. Risks + mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| 50-tester cohort under-recruits (only get 30) | Medium | Sourcing list is over-budgeted (target 100 sign-ups for 50 final). Slack accepted. |
| TestFlight invite rejection (low engagement) | Low | TestFlight has 1-year max test window; we're well inside |
| Apple Developer Program approval delay | Medium | Paul-action immediately; 24-48 hr approval typical |
| Crashlytics misses iOS-specific crashes | Low | Test on at least 3 iOS device-OS combos before soft-launch |
| KPIs miss but qualitative feedback is good | Medium | Recommend tune retention before opening beta; don't ignore numbers for vibes |
| Discord channel grief / spam | Low | Bot moderation + clear community rules in pinned post |
| Tester churn before Day 14 | Medium | Discord engagement + tester reward at D14 keeps cohort |
| Anti-P2W complaint appears | Low | Pre-empt by linking `monetisation_map.md` anti-P2W §7 in Discord welcome message |

---

## 9. Soft-launch -> open beta -> launch decision tree

```
                    ┌─────────────────────────┐
                    │  Day 14: KPI assessment │
                    └────────────┬────────────┘
                                 │
                ┌────────────────┴────────────────┐
                │                                 │
        PASS bar met                        FAIL bar met
                │                                 │
                ▼                                 ▼
    ┌───────────────────────┐         ┌──────────────────────────┐
    │ Open to broader test  │         │ Tuning patch + re-run    │
    │   - Play open beta    │         │   - 2 week patch cycle   │
    │   - TestFlight public │         │   - Re-cohort 25+25       │
    │   - 5k installs goal  │         │   - 7-day mini-test      │
    └───────────┬───────────┘         └──────────┬────────────────┘
                │                                 │
                ▼                                 ▼
    ┌──────────────────────────┐         ┌─────────────────┐
    │  D+30 open-beta milestone │         │  Re-test pass?  │
    │  - Crashes <0.5%          │         └────────┬─────────┘
    │  - Retention curves hold  │                  │
    │  - ARPDAU ≥ £0.15         │              ┌──┴───┐
    └───────────┬───────────────┘              │      │
                │                              ▼      ▼
                ▼                            yes     no
    ┌──────────────────────┐                  │     pause
    │  Global v1.0 launch  │                  ▼      project
    └──────────────────────┘            broader test
                                              (continue tree)
```

---

## 10. Open questions for Paul

1. **Cohort size — 50 right or stretch to 100?** Recommend 50 (manageable Discord support load, statistically OK for retention reads). Confirm.
2. **Geo mix.** UK + Philippines + Canada. Alternative: drop Canada, add USA (bigger market but pricier CPI). Recommend stay with current mix for soft-launch; USA comes in phase-1 open beta.
3. **Build cadence — every 3 days too aggressive?** Could go to every 5 days. Trade-off: faster iteration vs tester fatigue. Recommend 3 days.
4. **Tester rewards.** 1,000 gems + beta-tester card-back. Is that compelling enough? Could add: "free 1-month Ascendant Pact at launch" as a higher hook. Recommend add.
5. **30-sec promo video.** Author in-house (free, Paul-action with iMovie) or freelance (£100-300)? Recommend in-house for soft-launch; freelance polish for v1.0 global launch.
6. **Privacy policy.** Required for both stores. Draft at `secrets/privacy_policy_draft.md`. Should be reviewed by Paul before going live. Recommend use a template (TermsFeed or similar) + ML2 brand customisation.

---

## 11. Cross-references

- `GDD_v1.md` §9 — soft-launch KPI summary (this doc is the operational expansion).
- `monetisation_map.md` §"Anti-pay-to-win guardrails" — anti-P2W positioning for store screenshots.
- `shop_economy_v0.md` §3 — IAP price ladder.
- `tutorial_flow_v0.md` — tutorial-completion analytics events feed soft-launch KPI dashboard.
- `bosses_v0.md` + `bosses_chapters_2_3_v0.md` + `bosses_chapters_4_to_8_v0.md` — soft-launch ships Ch1-4 bosses playable.
- HANDOVER.md §6 — Firebase + Crashlytics + GameAnalytics tooling, AppLovin/AdMob ads (not in soft-launch — ads are v1.0).
- `GALLOWFELL_BACKLOG_INVENTORY_2026-05-21.md` TOOL-5 — Apple Developer Program enrolment (blocked-on-Paul).
- `GFX-13` — in-app store screenshot pack.

— Controller, 2026-05-22
