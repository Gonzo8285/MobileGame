# Phase 1 brief — Gaming app

_One-page condensed summary of all R1–R14 research. Read this before Phase 2 GDD work._
_Drafted 2026-04-29 by heartbeat. Source: research_notes.md._

## The market (R1–R3)
2026 mobile money still concentrates in **midcore strategy / RPG / 4X / casino / match-3**. Hyper-casual is dying; **hybrid-casual** (simple loop + meta progression + IAP) is the live winner. Our roguelite TD deckbuilder sits in **midcore-light**: deeper than hybrid-casual, lighter than 4X. The ten-mechanic addictive toolkit (variable rewards, daily streaks, loss aversion, FOMO, etc.) all belong in this game; we build them in from day one.

## Engine & pipeline (R4–R6)
**Engine: Godot 4** — free, MIT-licensed, scriptable headless, iOS+Android export, Claude can drive end-to-end. Asset pipeline: Stable Diffusion local + Kenney.nl placeholders + freesound + Suno (paid tier at launch) + ElevenLabs free. Total dev-phase tooling cost: $0/mo.

## Monetisation (R7)
Stack: **AppLovin MAX** (primary mediator) + **AdMob** (demand source). Free SDKs. Rewarded video capped 5–8/session, opt-in only, 30–50% of IAP value. IAP ladder $0.99 / 2.99 / 4.99 / 9.99 / 19.99 / 49.99 / 99.99 — $9.99 sweet spot. Always-on first-purchase 3× offer + weekly bundle refresh.

## Retention (R8)
D1 ≥40% via rigged-easy first run + Warlord unlock. D7 ≥15% via 28-day calendar + faction favour + battle pass. D30 ≥5% via meta unlocks at D14, monthly events, returner bonus, mastery/collection chase. Push notifs capped 1/day, smart-time, skipped if already played.

## Storefronts (R9–R10)
- **Apple Dev:** $99/yr individual. Paul does enrolment + KYC + tax forms in person. Claude preps everything else. iOS builds need a Mac → Codemagic free tier.
- **Google Play:** $25 one-time + KYC. **Personal accounts must run a 14-day closed test with ≥12 testers before first prod release** — bake this into the schedule. AAB only, privacy policy URL mandatory.

## ASO & launch (R11–R12)
30/30/100-char fields on iOS, 30/80/4000 on Play. Screenshot order: hook → fantasy → depth → social → CTA. Native A/B tests on both stores, free. **Soft-launch markets: CA + AU + PH.** Gates to global: D1 ≥38%, D7 ≥14%, D30 ≥5%, ARPDAU ≥$0.18, crash-free ≥99.5%. Soft-launch budget $500–$2000/mo for 8–12 weeks.

## CI/CD (R13)
**Android builds: GitHub Actions Linux (free).** **iOS builds: Codemagic (500 macOS min/mo free).** Both headless, Claude-drivable via API tokens once secrets are in repo. **Paul's only one-time tasks:** create Play service-account JSON + App Store Connect .p8 API key, paste into repo secrets. After that, hands-off.

## AI tooling (R14)
Stable Diffusion local + Leonardo free + freesound + Suno + ElevenLabs free + Firebase + GameAnalytics + AppFollow. Total launch-phase cost ~$15/mo. **Highest-leverage MCP to add: GitHub MCP** (resolves the corporate firewall + sandbox-proxy block on github.com). After that: image-gen MCP, Codemagic API, Play & App Store Connect APIs.

## What's blocking Claude from going fully autonomous
1. **GitHub network gate** — sandbox proxy + corporate firewall both block github.com push. Already in memory. Resolves with GitHub MCP install OR Anthropic allowlist.
2. **Apple Dev enrolment** — Paul-only, $99 + KYC.
3. **Google Play enrolment** — Paul-only, $25 + KYC.
4. **Service-account creds** — Paul logs in once to each console, generates keys, pastes into repo secrets.

After those four one-time gates, Claude can ship builds, run experiments, and tune live ops with no further Paul input required for build/release operations. Paul stays in the creative-direction & sign-off loop.

## What's next (Phase 2 — already unlocked)
G4 (1-page GDD) → G5 (name) → G6 (factions) → G7 (30-card starter pool) → G8 (monetisation surface map) → G9 (10 Warlords). Heartbeat will work these in order.
