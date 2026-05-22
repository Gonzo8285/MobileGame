# Risk Register v0 — The Curse of Gallowfell

_Authored 2026-05-22 by Controller (round 3). Project + product risk register for the soft-launch through D+30 window and beyond. 19 entries. Builds on `GDD_v1.md` §10 (the 9-row high-level risk table) — this doc is the operational expansion._

**Status:** v0 register. Owners + statuses are first-pass; Paul confirms ownership + accepts/rejects mitigation at next review.

**Scoring scale:**

- Probability: **L** (≤ 15%) · **M** (15–50%) · **H** (> 50%)
- Impact: **L** (cosmetic / single-feature delay) · **M** (launch delay / one-week recovery) · **H** (brand-killing / launch-aborting / business-ending)
- Risk score: simple **P × I** matrix — L×L=1, L×M=2, L×H=3, M×L=2, M×M=4, M×H=6, H×L=3, H×M=6, H×H=9. Anything ≥ 6 is a top-priority watch.

| Status enum | Meaning |
|---|---|
| `open` | Identified, mitigation in flight or planned, not yet contained |
| `mitigated` | Mitigation in place + verified, residual risk acceptable |
| `accepted` | Cannot mitigate further or cost-benefit doesn't justify — explicitly accepted |
| `closed` | No longer relevant |

---

## R-001 — Apple App Store review rejection (guideline 4.3 / spam-clone)

| Field | Value |
|---|---|
| Category | Launch |
| Probability | M |
| Impact | H |
| Score | **6** |
| Owner | Paul |
| Mitigation in place | Original IP names, original card art, unique mechanical hook (Hanging Hour), grimdark setting differentiates from saturated CCG-mobile space. Submission notes preempt 4.3 by listing genre-novel design pillars. |
| Mitigation if it occurs | 4.3 rejection rebuttal template prepped; appeal via App Review Board; resubmit with annotated differentiator video clip. Worst case: rebrand surface (icon + screenshots + name) without engine changes. |
| Status | open |

## R-002 — Apple App Store review rejection (guideline 3.1.1 / IAP non-disclosure)

| Field | Value |
|---|---|
| Category | Launch / Legal |
| Probability | M |
| Impact | M |
| Score | **4** |
| Owner | Paul |
| Mitigation in place | Gacha pity (80 pulls) disclosed in storefront UX up-front, not buried in T&Cs. Treatment-only loot rule documented. EULA includes IAP restoration flow. Submission notes call out anti-P2W invariant. |
| Mitigation if it occurs | Surface pity-counter + per-banner odds in pre-purchase modal. Re-submit with documented odds. App Store Review Guidelines 3.1.1(d) gacha-disclosure compliance pack on file. |
| Status | open |

## R-003 — Google Play policy rejection (gambling-mechanic adjacency)

| Field | Value |
|---|---|
| Category | Launch / Legal |
| Probability | M |
| Impact | H |
| Score | **6** |
| Owner | Paul |
| Mitigation in place | Gacha is **cosmetic-only**; no real-money loot box for power (logged in `monetisation_map.md` §"Anti-P2W"). Play policy on "Real-Money Gambling and Games" inapplicable but adjacent policy on "Gambling-Style" requires odds disclosure. Pity at 80 pulls disclosed. Per-banner odds disclosed. Min-age 13 enforced. |
| Mitigation if it occurs | Add explicit "no real-money gambling" copy to storefront. Pre-emptively engage with Play policy team prior to submission. Worst case: pull gacha-banner UI; switch to direct-purchase cosmetics only (revenue dip, anti-burn). |
| Status | open |

## R-004 — UK / EU age-rating misclassification (PEGI 12 → PEGI 16)

| Field | Value |
|---|---|
| Category | Legal / Launch |
| Probability | M |
| Impact | M |
| Score | **4** |
| Owner | Paul |
| Mitigation in place | Game is spec'd for PEGI 12 per `GDD_v1.md` §10. Horror tone is implied not graphic (no on-screen blood-sprays, no torture imagery; gallows-tree silhouetted not corpse-detailed). Tutorial cold-open sells fantasy without front-loading horror. IARC self-rating questionnaire pre-filled to map to PEGI 12. |
| Mitigation if it occurs | Two paths: (a) accept PEGI 16 — narrows TAM, hurts CPI, otherwise unchanged. (b) Edit on-screen frames — recolour Reanimation rise sequence, tone-down Black-Bell-Choir gore, dim Bleed VFX. Path (a) preferred; (b) is a 1-2 day art delta. |
| Status | open |

## R-005 — GDPR consent flow non-compliance (analytics + crash reporting)

| Field | Value |
|---|---|
| Category | Legal |
| Probability | M |
| Impact | H |
| Score | **6** |
| Owner | Paul |
| Mitigation in place | First-run consent modal pre-spec'd in `tutorial_flow_v0.md` (TBC). Firebase Analytics + Crashlytics + GameAnalytics all opt-in by default in EU geos. ATT prompt on iOS. Privacy policy URL live before submission. Data Processing Agreement with Google / Firebase on file. Cohort sourcing email collects consent for soft-launch telemetry. |
| Mitigation if it occurs | Hot-patch consent modal; pause non-essential analytics in EU geos pending fix. ICO notification within 72h if a data incident triggers reporting threshold. Privacy-policy versioning in place — easy rollback. |
| Status | open |

## R-006 — Single-developer bus factor (Paul out for ≥ 2 weeks)

| Field | Value |
|---|---|
| Category | Technical / Commercial |
| Probability | M |
| Impact | H |
| Score | **6** |
| Owner | Studio (Paul + Controller) |
| Mitigation in place | Memory-MD index in `MEMORY.md` keeps context recoverable. `HANDOVER.md` is a re-entry point. Controller + .151 + Claude Code seats are all redundant operators on the codebase. AI staff can continue routine work (heartbeat-driven art pipeline, lore expansion, audio briefs) without Paul-action during short outages. Documented PAT + repo access in `secrets/`. |
| Mitigation if it occurs | Controller auto-pivots non-FF queue. Soft-launch can be paused (no live customers yet). Pre-launch: dependent decisions queue in `project_pending_ops.md`. Post-launch: live-ops cadence falls to bare minimum (auto-renewing season pass, no event launches). |
| Status | open — bus-factor inherent to single-developer model, accepted as a structural condition with active mitigation. |

## R-007 — IAP fraud / chargeback wave on launch

| Field | Value |
|---|---|
| Category | Commercial |
| Probability | L |
| Impact | M |
| Score | **2** |
| Owner | Platform (Apple + Google) + Paul |
| Mitigation in place | All IAP processed through Apple StoreKit / Google Play Billing — no direct card data handled. StoreKit-side fraud protection automatic. Server-side receipt validation planned (see TBD-Tech-3). Cosmetic-only IAP reduces fraudster incentive (no resaleable in-game wealth). Spend caps (soft warning £100/mo, hard cap option £500/mo) per `shop_economy_v0.md`. |
| Mitigation if it occurs | StoreKit refund flow auto-handles, chargebacks revert IAP entitlements server-side. Anomaly detection (one account, >5 chargebacks/week) auto-suspends account pending review. |
| Status | open |

## R-008 — Server / backend cost scaling (Firebase + cloud GPU + analytics)

| Field | Value |
|---|---|
| Category | Commercial |
| Probability | M |
| Impact | M |
| Score | **4** |
| Owner | Paul |
| Mitigation in place | Firebase free-tier headroom is ~50K MAU before cost begins; soft-launch cohort is 50 testers. Cloud GPU (RunPod) for art pipeline is heartbeat-driven, not user-facing — cost is bounded by Paul-controlled cadence. Analytics (Firebase + GameAnalytics) within free tier at soft-launch scale. Sentry / Crashlytics within free tier. Cost-monitor cron: weekly check at 09:00 UK Monday. |
| Mitigation if it occurs | At 10K DAU: migrate analytics to GameAnalytics-only (Firebase opt-out non-essential events). At 50K MAU: BigQuery quotas; archive >90-day events. Cost-budget alarm at £100/mo for non-art infrastructure; £500/mo total infra cap pre-Series-A revenue. |
| Status | open |

## R-009 — Music licence edge case (Suno-generated track redistribution rights)

| Field | Value |
|---|---|
| Category | Legal / IP |
| Probability | M |
| Impact | M |
| Score | **4** |
| Owner | Paul |
| Mitigation in place | Per `audio_production_brief_v1.md`: bespoke composition either hand-composed (work-for-hire contract, all rights to ML2) **or** Suno-generated on Suno's paid tier (commercial-use rights subject to Suno T&Cs at generation time). Sonniss CC0 SFX library is commercial-use unlimited. Style-reference pillar tracks (Mick Gordon / Wardruna / Hozier) are NEVER used directly — referenced for tone, score is original. |
| Mitigation if it occurs | If Suno T&Cs change retroactively to restrict commercial redistribution: fallback to hand-composed track via freelance composer at £400-1,200 (per audio brief). Lead time: 2-4 weeks. Pre-launch: have at least 5 of 15 leitmotif variants hand-composed to insulate against Suno-only risk. |
| Status | open |

## R-010 — Real-world cult / satanic-panic blowback (review-bomb risk)

| Field | Value |
|---|---|
| Category | Commercial / Brand |
| Probability | L |
| Impact | M |
| Score | **2** |
| Owner | Studio (Paul + Controller) |
| Mitigation in place | Tone is **gallows-folklore + grimdark fantasy**, not occult-real-world. Faction symbology is deliberately fictional (no real religious sigils, no pentagrams, no inverted crosses, no real cult iconography). Iron Penitents are flagellant-_inspired_ not a specific Catholic order; Coven is bog-witch-folkloric not Wiccan. PEGI 12 keeps the audience adult-supervised. Press materials lead with "folklore + horror + roguelite" framing, never "satanic" / "occult" / "demonic" framing. (`marketing_press_kit_v0.md` is explicit on this.) |
| Mitigation if it occurs | Pre-prepared one-paragraph statement: "Gallowfell is a work of grimdark fantasy informed by gallows-folklore traditions across European history; it does not represent or endorse any real-world religious or occult practice." Disable user-review section temporarily if review-bombing exceeds 100 reviews/day. Engage platform moderation teams (Apple + Google have anti-coordinated-review-attack tools). |
| Status | open |

## R-011 — IP overlap — "Gallowfell" name pre-claimed on Steam / Itch / trademark

| Field | Value |
|---|---|
| Category | IP / Legal |
| Probability | M |
| Impact | H |
| Score | **6** |
| Owner | Paul |
| Mitigation in place | Working title only at present. Pre-launch trademark search planned (Paul-action: USPTO + UKIPO + EUIPO + IPO-AU). Steam Search + Itch.io search + Google domain search for "Gallowfell" and "Curse of Gallowfell" and "The Curse of Gallowfell" — flagged in `warlords_v1.md` open Qs as a heartbeat-task. Domain `gallowfell.ml2consulting.com` reserved as a fallback subdomain. |
| Mitigation if it occurs | Rename surface (logo + wordmark + storefront listing) without engine changes. Engine-side string `Gallowfell` exists in 30+ files — sed-replace + commit. Estimated cost: 1 day of design + 1 day of engineering. Pre-canned candidate names (TBD) cached for fast rebrand. |
| Status | **OPEN — Paul action needed: run trademark + storefront-search pass before printing any external asset with the name.** |

## R-012 — Hanging Hour mechanic is opaque to first-run players

| Field | Value |
|---|---|
| Category | Product / Retention |
| Probability | M |
| Impact | M |
| Score | **4** |
| Owner | Studio (Paul + Controller) |
| Mitigation in place | Per `gameplay_keywords_resolution_v0.md` §"Hanging Hour UX lock" — full-screen ash-tint + bell-toll SFX + diegetic clock 23:59 → 00:00 + 1.5s pause. Tutorial cold-open (per `tutorial_flow_v0.md`) introduces the lore before mechanic. Onboarding overlay tip fires on first-encounter Hanging Hour. |
| Mitigation if it occurs | Hot-patch onboarding-tooltip duration (extend to 4 sec). Add "What is the Hanging Hour?" tappable info-modal on the gallows-bell HUD icon. A/B test in soft-launch cohort. |
| Status | open |

## R-013 — Mobile control feel (drag-to-lane is fiddly on small screens)

| Field | Value |
|---|---|
| Category | Product / Retention |
| Probability | M |
| Impact | H |
| Score | **6** |
| Owner | Studio (Paul + Controller) |
| Mitigation in place | Per `interaction_touch_v0.md` v0 — gesture inventory locked, hold-to-inspect at 350ms, drag-snap to lane tile. Mobile-first build target throughout — every gesture tested on phone-size before tablet. IMV-1 playtest gate includes a "drag-feel pass" with Paul holding a phone. |
| Mitigation if it occurs | Tap-to-deploy as fallback gesture (tap card → tap target lane). Add per-lane "drop-zone halo" highlight on card pickup. Hot-patch within 24h if soft-launch D1 funnel shows drag-fail rate > 15%. |
| Status | open |

## R-014 — Art pipeline can't keep up with ~205 cards + 5 leitmotifs + frame pack

| Field | Value |
|---|---|
| Category | Technical / Launch |
| Probability | H |
| Impact | M |
| Score | **6** |
| Owner | Studio (Paul + AI-art seat) |
| Mitigation in place | AI-gen pipeline locked in `pipeline_spec.md`. Sonniss CC0 + Freesound CC0 fallback for SFX. Suno for music gen. RTX-2050 hardware gap mitigated by RunPod cloud GPU. Stage A (anchor renders) gates Stage B (commons). 5 frame PSDs spec'd in `faction_frames_v0.md` but authoring not started — explicitly tracked as GFX-3. |
| Mitigation if it occurs | Ship soft-launch with 40% alt-art fill (per `variants_system_v0.md` §3.2). Y1 catch-up via heartbeat-driven generation queue. Cards launch with canonical art only (zero alt-arts) if Stage B rerolls exceed bandwidth — alt-arts become a v1.1+ vertical. Acceptable degraded launch. |
| Status | open |

## R-015 — Lore-deep grimdark turns off mass-market mobile audience (TAM ceiling)

| Field | Value |
|---|---|
| Category | Commercial |
| Probability | M |
| Impact | M |
| Score | **4** |
| Owner | Studio (Paul + Controller) |
| Mitigation in place | PEGI 12 (not 16+) keeps reach wide. Gallows-humour register softens edges. Tutorial cold-open sells fantasy in 40 sec without front-loading horror. Store screenshots (per `marketing_screenshots_brief_v0.md`) lead with mechanic + roster, not with the darkest visuals. Soft-launch CPI test in Philippines / UK / Canada will surface CPI floor early. |
| Mitigation if it occurs | If CPI exceeds £2.50: re-test creatives with softer hero-frames (Skinward Cinderwood instead of Cathedral Ruins). Two paid-social ad-set variants pre-authored — "system-led" (deckbuild + roster) vs "tone-led" (Hanging Hour). Run both. |
| Status | open |

## R-016 — Subscription (Ascendant Pact) drowns out Marrow Pass / cannibalises pass revenue

| Field | Value |
|---|---|
| Category | Commercial |
| Probability | L |
| Impact | M |
| Score | **2** |
| Owner | Paul |
| Mitigation in place | Subscription gated to post-D14 of soft-launch milestone per `CONFLICTS_RESOLVED_2026-05-22.md` §"Conflict 6". Soft-launch ships with Marrow Pass only — subscription is dark. Once switched on, subscription benefits are XP-multiplier + cosmetic-trickle, not pass-content overlap. |
| Mitigation if it occurs | A/B subscription off in 50% of cohort. If Marrow Pass conversion drops by >15% in the subscription-on arm, gate the subscription tighter (T2-only Warlord, longer-cohort cooldown). |
| Status | mitigated (gated to post-D14) |

## R-017 — Anti-P2W invariant breaks under pressure to monetise harder

| Field | Value |
|---|---|
| Category | Brand / Commercial |
| Probability | M |
| Impact | H |
| Score | **6** |
| Owner | Paul |
| Mitigation in place | Locked in `monetisation_map.md` §"Anti-pay-to-win guardrails" + `shop_economy_v0.md` §"Anti-P2W invariant". Every PR that touches a money path must re-audit. Soft-launch playbook §"Pass-fail" includes "no P2W complaints" as a hard bar. Free-roster lock + Souls-earned-only + Ancestor-tree-Bones-only are structural firewalls. |
| Mitigation if it occurs | If soft-launch conversion misses target: experiment with cosmetic price (lower Foil to £1.99, raise Ultimate to £69.99) before _ever_ touching the gameplay/cosmetic firewall. Document any "experiment near the line" decision in `monetisation_map.md` audit log. |
| Status | open — structural risk, monitored every PR |

## R-018 — W11 lore-locked Warlord causes hidden-content frustration / forum drama

| Field | Value |
|---|---|
| Category | Commercial / Brand |
| Probability | L |
| Impact | L |
| Score | **1** |
| Owner | Studio |
| Mitigation in place | Discoverable via lore drops in events. Achievement-tracker shows "10 of 10 Warlord runs cleared" progress visible to player — unlock is signposted not hidden. No IAP path per design — players who complain on forum are correctly told "this is the no-IAP earned reward." Per `warlords_v1.md` open Qs, alternative unlock is "any 5 Warlords at A5+" — softer pivot reserved. |
| Mitigation if it occurs | Activate softer-unlock branch (any 5 Warlords at A5+) in v1.1 patch if Discord sentiment drops or completion-rate <2% by D90. |
| Status | open |

## R-019 — Soft-launch fails 3-of-4 retention bars or both monetisation bars

| Field | Value |
|---|---|
| Category | Launch |
| Probability | M |
| Impact | H |
| Score | **6** |
| Owner | Studio |
| Mitigation in place | Per `soft_launch_playbook_v0.md`: pause + tune + re-run cohort. Pass-bar is 3-of-4 retention + ARPDAU **OR** conversion (not both). Daily 09:00 UK KPI digest gives 24-hour signal on slope. Hot-patch cadence every 3 days enables tuning-during-cohort. |
| Mitigation if it occurs | Pause cohort, identify top-3 churn surfaces (likely: tutorial-completion, Hanging-Hour confusion, drag-to-lane fiddle, reward-pick-skip rate). Tune. Re-run with 30 fresh testers + 20 returning. Soft-launch window can extend to 28 days without business impact. |
| Status | open |

---

## Heat map (at a glance)

```
            Impact →
            L     M     H
P ↑   L     R-018 R-007 R-002
      M     R-008 R-004 R-001 · R-003 · R-005 · R-006
                              R-011 · R-013 · R-014 · R-015
                              R-016 · R-017 · R-019
      H                       —      —      —
```

(Score 6+ band has 11 entries. None at H/H or H/M — the model is small studio + tight scope + structural firewalls. Score-9 catastrophic cells are empty by design.)

---

## Review cadence

- **Weekly during soft-launch:** Paul + Controller review the open-status rows, update mitigation-in-place text, update status (open → mitigated where applicable).
- **Per-PR:** any code/spec touching monetisation re-audits R-017 and R-003.
- **Per-launch-milestone:** at D-14 / D-7 / D-1 / D+1 / D+7 / D+30 each open risk is re-scored.

---

## Version history

- v0 — 2026-05-22 — Controller round 3. 19 entries.

— Controller, 2026-05-22
