# Launch Checklist v0 — The Curse of Gallowfell

_Authored 2026-05-22 by Controller (round 3). T-14 days pre-launch through D+30 operational checklist. Builds on `soft_launch_playbook_v0.md` (cohort-side) and `risk_register_v0.md` (risk-side). Every item: short, actionable, verifiable. 92 items across 10 groups._

**Status:** v0 checklist. Pre-soft-launch.

**Verification glyph:** every item is shaped so a single check (link / screenshot / response email / git tag) confirms it. Use the **Verify** column to log how it was checked.

**Owner key:** `P` = Paul · `S` = Studio (AI staff, Controller-driven) · `PL` = Platform (Apple / Google) · `EXT` = External (third party — composer / lawyer / press)

---

## A. Builds + binaries (10)

| # | Item | Owner | Verify |
|---|---|---|---|
| A-1 | iOS release build tagged `v1.0.0-rc1` in `Gonzo8285/gallowfell` | S | git tag + .ipa artefact in CI |
| A-2 | Android release build tagged `v1.0.0-rc1` — .aab signed with prod upload-key | S | .aab in CI + sha256 |
| A-3 | TestFlight build uploaded to App Store Connect, processed | S | TestFlight build-no. visible in ASC |
| A-4 | Play Console Internal track build uploaded + promoted to Closed Testing | S | Play Console build-no. visible |
| A-5 | Production .ipa promoted from TestFlight to App Store submission | P | ASC "Ready for Submission" |
| A-6 | Production .aab promoted to Play Console Production track | P | Play Console "Pending publication" |
| A-7 | Debug overlays + FPS counter + test-cards stripped from release build | S | grep `DEBUG_OVERLAY` returns 0 in tagged build |
| A-8 | App-icon adaptive (Android) + 1024×1024 master (iOS) shipped per GFX-7 | S | Icon visible on test device |
| A-9 | Splash screen + per-faction loading flavour text shipped per GFX-6 | S | Splash visible on cold-start |
| A-10 | Crashlytics + Firebase + GameAnalytics SDKs initialised on cold start | S | Test crash visible in Crashlytics dashboard |

---

## B. Store pages (12)

| # | Item | Owner | Verify |
|---|---|---|---|
| B-1 | App Store title final ("The Curse of Gallowfell") + subtitle (≤30 chars) | P | ASC field saved |
| B-2 | Play Store short description (≤80 chars) + full description (≤4000 chars) | P | Play Console saved |
| B-3 | 8 launch screenshots per `marketing_screenshots_brief_v0.md` uploaded to ASC + Play | S | All 8 visible on store preview |
| B-4 | 60-second trailer (16:9, 9:16, 1:1) uploaded to ASC App Preview + Play feature graphic | S | Preview plays in store sandbox |
| B-5 | Promotional text on ASC (170 chars) — updates per season, doesn't require resubmission | P | ASC field saved |
| B-6 | Keywords (ASC, 100 chars total) — "roguelite, deckbuilder, lane defence, grimdark, dark fantasy, gallows, card game, indie" | P | ASC field saved |
| B-7 | What's New text on both stores for v1.0.0 ("Launch day. The town is open.") | P | Both stores saved |
| B-8 | Age rating questionnaire — IARC + ASC — matches PEGI 12 / Teen 13+ target per R-004 | P | ASC + Play Console rating green |
| B-9 | Region availability locked — soft-launch geos (PH, UK, CA) at v0.9; full geos at v1.0 | P | ASC + Play Console region matrix matches plan |
| B-10 | Pricing schedule — free + IAP — set per `shop_economy_v0.md` ladder | P | All IAP SKUs visible in ASC + Play Console |
| B-11 | IAP catalogue uploaded — 6 gem packs + Starter Bundle + 5 faction bundles + Marrow Pass + Marrow Pass+ + Ascendant Pact + 5 paid Warlords + treatment SKUs | P | All SKUs "Ready to Submit" |
| B-12 | App Store + Play Store editorial team notification (1 month before launch, optional ML2 pitch) | P | Email sent + delivery confirmation |

---

## C. Legal (10)

| # | Item | Owner | Verify |
|---|---|---|---|
| C-1 | Privacy policy URL live at `ml2consulting.com/gallowfell/privacy` | P | URL returns 200 + policy content visible |
| C-2 | Terms of Service URL live at `ml2consulting.com/gallowfell/terms` | P | URL returns 200 |
| C-3 | EULA URL live at `ml2consulting.com/gallowfell/eula` | P | URL returns 200 |
| C-4 | GDPR consent flow first-run modal — opt-in for analytics + crash reporting in EU geos | S | First-run on EU-IP test device shows modal |
| C-5 | Age gate on first-run — DOB entry or 13+ confirm — required for IAP unlock | S | Test under-13 simulated user blocked from IAP |
| C-6 | Refund policy URL live (links to platform refund flow) | P | URL returns 200 |
| C-7 | DPA (Data Processing Agreement) on file with Firebase / Google / Apple | P | PDFs in `secrets/legal/` |
| C-8 | CCPA "Do Not Sell My Info" link (US-CA users) | P | Setting menu shows toggle |
| C-9 | UK Online Safety Act compliance review — children's content + harmful content | P | Self-cert checklist in `secrets/legal/osa.md` |
| C-10 | Trademark search complete for "Gallowfell" + "The Curse of Gallowfell" per R-011 — USPTO + UKIPO + EUIPO + Steam + Itch | P | Search report PDF in `secrets/legal/tm-search-2026-05.pdf` |

---

## D. Platform compliance (10)

| # | Item | Owner | Verify |
|---|---|---|---|
| D-1 | App Store Review Guidelines 3.1.1 (IAP) — pre-flight self-audit complete | P | Self-audit checklist signed off |
| D-2 | App Store Review Guidelines 3.1.2 (Subscriptions — Ascendant Pact) — auto-renew disclosure + free-trial UX | P | UX matches HIG; in-app screen verified |
| D-3 | App Store Review Guidelines 4.3 (spam / clone) — submission notes preempt with differentiator paragraph | P | Submission notes draft in `secrets/asc/4_3_rebuttal.md` |
| D-4 | App Store Review Guidelines 5.1 (privacy — data collection) — `App Privacy` ASC section filled per actual collection | S | All sections green in ASC |
| D-5 | App Tracking Transparency (ATT) prompt shown on iOS launch if tracking enabled | S | ATT prompt visible on first launch |
| D-6 | Play Console "Data safety" form filled — matches privacy policy | P | Play Console Data Safety green |
| D-7 | Play Console "Target API Level" meets requirement (Android API 34+) | S | manifest target-SDK = 34 |
| D-8 | Play Console "Game Type" tag = Card / Strategy | P | Tag saved |
| D-9 | Play Console "Real-Money Gambling" question answered "No" + gacha-disclosure pack on file per R-003 | P | Form answered + pack at `secrets/play/gacha-disclosure.pdf` |
| D-10 | App Store Connect Game Center setup (achievements + leaderboards for Ascension) | S | 20 achievements + per-Warlord leaderboard live in sandbox |

---

## E. Analytics + observability (10)

| # | Item | Owner | Verify |
|---|---|---|---|
| E-1 | Firebase Analytics — all 40 game events firing per `pipeline_spec.md` event taxonomy | S | Firebase debug-view shows all events on test device |
| E-2 | `tutorial_complete` event fires on round-1 reward-pick per `GDD_v1.md` §8 | S | Firebase event visible after tutorial run |
| E-3 | GameAnalytics — funnel + retention + ARPDAU dashboards configured | S | Dashboard URLs in `Controller project_/dashboards.md` |
| E-4 | Crashlytics — test crash logged + symbol files uploaded | S | Test crash with full stack visible |
| E-5 | Sentry (optional but planned) — error reporting wired for non-fatal errors | S | Test error visible in Sentry |
| E-6 | Daily KPI cron — 09:00 UK pull from Firebase + GA → `softlaunch/daily_kpi_<DATE>.md` | S | First daily file exists |
| E-7 | LiveOps dashboard URL live + mobile-readable | S | Dashboard URL responds + readable on phone |
| E-8 | IAP event funnel verified end-to-end on sandbox iOS + Android | S | Test purchase shows in funnel |
| E-9 | A/B test framework wired (Firebase Remote Config) — feature flags for Hanging-Hour tooltip duration etc. | S | Test flag toggles on device |
| E-10 | Server-side IAP receipt validation endpoint live per R-007 | S | Sandbox receipt validated server-side |

---

## F. Marketing (10)

| # | Item | Owner | Verify |
|---|---|---|---|
| F-1 | Press kit live at `ml2consulting.com/gallowfell/press` per `marketing_press_kit_v0.md` | P | URL returns 200 + content matches |
| F-2 | 60-second trailer uploaded to YouTube — public, unlisted-until-launch | S | YouTube URL + view counter at 0 |
| F-3 | 30-second cut-down uploaded to TikTok / Reels / Shorts | S | URLs in `marketing_log.md` |
| F-4 | Game website live at `ml2consulting.com/gallowfell` — pitch + screenshots + press kit link + store badges | S | URL returns 200 + lighthouse a11y ≥ 90 |
| F-5 | Twitter / X account `@gallowfell_game` — handle reserved, bio set, 5 schedule-posts queued | P | Profile visible + queued posts in Buffer |
| F-6 | Bluesky account reserved — same handle | P | Profile visible |
| F-7 | Discord server set up with channels (general / bugs / lore / cosmetic-trades / mod-only) | P | Server invite URL valid + roles configured |
| F-8 | Reddit launch post drafted for r/RoguelikeDev + r/Roguelites + r/iosgaming + r/AndroidGaming | P | Draft in `marketing/reddit_posts/v1_launch.md` |
| F-9 | Steam / Itch optional store pages — coming-soon stubs reserved (no real product yet) | P | Steam coming-soon visible (optional Y1) |
| F-10 | Press distribution — 30 outlet email list curated (TouchArcade, PocketGamer, Eurogamer, RPS, IGN-mobile, IndieGameDev, etc.); embargo set for launch-day 09:00 UK | P | Email list in `marketing/press_outlets.csv` + draft email |

---

## G. Support (8)

| # | Item | Owner | Verify |
|---|---|---|---|
| G-1 | Support email `support@ml2consulting.com` alias live — forwards to Paul + Controller | P | Test email round-trip |
| G-2 | FAQ document live at `ml2consulting.com/gallowfell/faq` — covers ≥20 anticipated questions | S | URL returns 200 + ≥20 Qs listed |
| G-3 | In-game help screen wired — links to FAQ + glossary (per `gameplay_keywords_resolution_v0.md`) | S | Help screen accessible from Settings |
| G-4 | Discord moderator team (Paul + 2 trusted volunteers from cohort) onboarded with mod tools | P | Mod-team channel visible + roles assigned |
| G-5 | Refund policy text — links to Apple / Google flows, explains ML2 cannot directly refund | P | Policy live + linked from FAQ |
| G-6 | Bug-report template in Discord + email — version / device / steps / expected / actual / video | S | Template pinned in Discord #bugs + email autoresponder |
| G-7 | Support SLA published — 2 working days for first response | P | SLA visible in FAQ + support page |
| G-8 | Crash-rate alert — Crashlytics alert if crash-free-users < 99% | S | Alert configured + test ping |

---

## H. Day-zero ops (8)

| # | Item | Owner | Verify |
|---|---|---|---|
| H-1 | LiveOps dashboard reachable from phone | S | URL responds on mobile |
| H-2 | Monitoring on-call rota for D-1 / D / D+1 — Paul primary, Controller secondary | P | Rota in `Controller project_/oncall.md` |
| H-3 | Rollback plan documented — bad release? Pull from Play / pause from ASC | S | Plan in `Controller project_/rollback.md` |
| H-4 | Day-zero communications — Discord launch-post draft + Twitter thread draft + email to cohort | P | Drafts in `marketing/d0/` |
| H-5 | Server load test — synthetic 1000-DAU simulation passes without 5xx | S | Load-test artefact in `secrets/loadtest/` |
| H-6 | Currency starting balance for new accounts confirmed (10 gems / 0 bones / 0 shards / 100 gold) | S | New-account on test device shows correct |
| H-7 | Marrow Pass season 1 — content uploaded, cosmetic SKUs available, hero reward (Vyrrun Cursed Self-Scourge) staged | S | Pass visible in build |
| H-8 | Ascendant Pact DISABLED at launch — gated to post-D14 milestone per R-016 | S | Sub button hidden on launch build |

---

## I. Pre-launch checkpoints (T-14 → T-1) (10)

| # | Item | Owner | Verify |
|---|---|---|---|
| I-1 | T-14: soft-launch retention bars passed in PH / UK / CA cohort | P+S | KPI digest 3-of-4 retention bars green |
| I-2 | T-14: ARPDAU OR conversion bar passed per `soft_launch_playbook_v0.md` | P+S | KPI digest one monetisation bar green |
| I-3 | T-10: Apple submission accepted (first attempt or post-rebuttal) | P | "Ready for Sale" status in ASC |
| I-4 | T-10: Google Play production rollout pre-approved | P | "Ready for review" green |
| I-5 | T-7: trademark search clear or rebrand path documented per R-011 | P | TM search PDF current within 30 days |
| I-6 | T-7: press embargo sent — 30 outlets confirmed receipt | P | Email read-receipts logged |
| I-7 | T-5: privacy policy + terms reviewed by Paul + (if engaged) external counsel | P | Sign-off note in `secrets/legal/signoff.md` |
| I-8 | T-3: final QA pass — tutorial-completion + tutorial-skip path verified | P+S | QA log in `Controller project_/qa_t_minus_3.md` |
| I-9 | T-2: store screenshots + trailer final-verified visible on production stores | P | Screenshot check from Paul's phone |
| I-10 | T-1: communications dry-run — Discord post + Twitter draft + cohort email queued | P | All drafts queued in scheduler |

---

## J. Post-launch checkpoints (D+1, D+3, D+7, D+14, D+30) (14)

### D+1

| # | Item | Owner | Verify |
|---|---|---|---|
| J-1 | D+1: crash-free users ≥ 99% — pull from Crashlytics 09:00 UK | S | Dashboard snapshot |
| J-2 | D+1: tutorial-completion ≥ 80% | S | Funnel snapshot |
| J-3 | D+1: hot-patch ready if any P0 bug — TestFlight build pre-stamped | S | TestFlight build-no. visible |

### D+3

| # | Item | Owner | Verify |
|---|---|---|---|
| J-4 | D+3: D1 retention ≥ 40% reading from production | S | Dashboard snapshot |
| J-5 | D+3: IAP funnel converting — first paying users visible | S | IAP event count > 0 |
| J-6 | D+3: top 5 support issues triaged + responded | P | Support log < 48h average |

### D+7

| # | Item | Owner | Verify |
|---|---|---|---|
| J-7 | D+7: D3 retention ≥ 25% | S | Dashboard snapshot |
| J-8 | D+7: IAP conversion ≥ 2.5% | S | Dashboard snapshot |
| J-9 | D+7: Discord at ≥ 100 members | P | Discord member count |
| J-10 | D+7: post-launch update v1.0.1 — patch notes + bug fixes shipped | S | Tag `v1.0.1` pushed |

### D+14

| # | Item | Owner | Verify |
|---|---|---|---|
| J-11 | D+14: D7 retention ≥ 15% | S | Dashboard snapshot |
| J-12 | D+14: Ascendant Pact subscription enabled per R-016 | S | Sub visible in storefront |
| J-13 | D+14: launch retrospective written + posted to `Controller project_/launch_retro.md` | P+S | Retro doc + key learnings |

### D+30

| # | Item | Owner | Verify |
|---|---|---|---|
| J-14 | D+30: Marrow Pass season 1 closes; season 2 launches with new Cursed-treatment hero SKU | S | Season 2 visible + season 1 archived |

---

## Item count check

A=10 · B=12 · C=10 · D=10 · E=10 · F=10 · G=8 · H=8 · I=10 · J=14 = **102 items** (≥ 80 floor — comfortably over).

---

## Sign-off ladder

- **T-14:** Studio sign-off on A + E + H. Paul sign-off on B + C + D + F + G.
- **T-1:** Joint sign-off on I.
- **D+1 / D+3 / D+7 / D+14 / D+30:** Studio runs J checkpoints. Paul reviews J-13 retro.

---

## Version history

- v0 — 2026-05-22 — Controller round 3. 102-item flat checklist across 10 groups.

— Controller, 2026-05-22
