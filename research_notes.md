# Research notes — Gaming app

_(False alarm cleared 2026-04-28 — file exists, heartbeat was using a relative path. Fixed: backlog now uses absolute path. Next heartbeat will verify.)_

Heartbeat appends findings here, newest at the bottom.

---

## R1 — Top-grossing & most-downloaded mobile genres (heartbeat 2026-04-28)

**Top-grossing (revenue) — iOS + Google Play:**
- **Strategy / 4X base-building** (Whiteout Survival, Rise of Kingdoms, Clash of Clans) — deep progression + construction timers create compulsive IAP unlocks; whales spend £100s/month
- **RPG / Gacha** (Genshin Impact, Honkai Star Rail, AFK Journey) — randomised pull system drives massive per-player spend; high ARPDAU ($2–8); evergreen if content cadence holds
- **Casino / Slots** (Jackpot Party, Slotomania) — regulatory arbitrage + VIP whales; near-limitless IAP ceiling; legally complex in UK/EU
- **Match-3 Puzzle** (Royal Match, Candy Crush Saga) — enormous DAU, broad demographic, gentle IAP ladder ($0.99–$9.99), strong ad revenue from free players
- **Sports / Sports management** (EA FC Mobile, Golf Clash, Football Manager Mobile) — licensed IP drives installs; season-pass cadence; global audience

**Most downloaded (volume) — both stores:**
- Hyper-casual arcade/puzzle leads on installs (but monetises mostly via ads)
- Match-3 and word games (Wordle-alikes) dominate mid-tier
- Battle royale (PUBG Mobile, Free Fire) massive in SE Asia / LatAm
- Runner / endless games (Subway Surfers category) — evergreen, low-friction

**Take-away:** For a first game, Match-3 or casual strategy offers the best balance of proven revenue model, reachable production budget, and Claude-buildable scope.

---

## R2 — Genre cheat sheet: hyper-casual vs hybrid-casual vs casual vs midcore (heartbeat 2026-04-28)

| Genre | Dev cost | Time-to-ship | ARPDAU | Notes |
|---|---|---|---|---|
| **Hyper-casual** | $5k–50k | 2–8 weeks | $0.01–0.05 | Nearly 100% ad revenue; iOS ATT killed targeting → market contracting hard in 2025-26; avoid unless you have a CPI < $0.10 angle |
| **Hybrid-casual** | $30k–150k | 8–16 weeks | $0.08–0.25 | Casual skin + meta layer (collect/build/story); best CPI + ARPDAU ratio right now; Claude-buildable |
| **Casual** | $100k–500k | 4–12 months | $0.15–0.60 | Match-3, word, puzzle — proven LTV but crowded; needs good IP or hook to break through |
| **Midcore** | $500k–3M+ | 12–24 months | $0.50–2.00 | 4X, RPG, strategy — high whale spend but brutal competition and long runway |

**Take-away:** Hybrid-casual is the correct target for a Claude-built first game — lowest total risk, fastest to testable prototype, growing segment.

---

## Phase 2 unlocked — Paul's references logged 2026-04-28

**Reference games:** Tower Defence, Vampire Survivors, Marvel Snap, Hearthstone, Magic the Gathering, Baldur's Gate 3, D&D, Angry Birds, Temple Run.
**Aesthetic:** grimdark gothic-fantasy / Warhammer-style — but ORIGINAL faction names only (GW + WotC IP locked out).
**Required monetisation pillars:** microtransactions, bundles, time locks, resource locks, short-burst sessions.

**Three concept directions for heartbeat to develop into one-pagers (G2):**
1. Roguelite tower-defence deckbuilder — 10-min runs, deck of unit/spell cards, TD lanes, Warlord meta-progression.
2. 3-min auto-battler card duel — Snap-style PvP, grimdark factions, weekly meta cards.
3. Horde survivor with hero collection — VS-style 5-min runs, gacha heroes/relics, weekly bosses.

Heartbeat: skip ahead to Phase 2 G1+G2 once R3–R8 are done (need core mechanics/monetisation/retention research before pitching concepts properly). Then pause for Paul to pick a winner.

---

## R3 — Top 10 addictive mechanics (heartbeat 2026-04-28)

- **Variable reward / slot-machine loop** — randomise reward timing/size so players can't predict drops; implemented via weighted loot tables on run-end chest
- **Daily streak** — reward N-day login chains with escalating prizes; day 7 = premium currency spike; hard reset on miss to drive guilt-reinstall
- **Energy system** — cap free plays (e.g. 5 lives/hearts); refill 1 per 20 min or pay; creates natural re-engagement windows aligned with push notifications
- **Gacha / card pull** — sell randomised card packs; pity system at N pulls guarantees rare; "sparkle" animation on rare reveal is the dopamine hit
- **Battle pass** — sell 8-week seasonal pass (~£5); free track shows paid rewards just out of reach; XP grind drives daily engagement automatically
- **Loss aversion** — show "you almost won" screen after a close-run defeat; offer a revival gem purchase at the moment of maximum frustration
- **Social proof** — leaderboards, "your friend just unlocked X", "1.2M players online" ticker; makes the game feel alive and competitive
- **FOMO / limited-time offers** — rotating shop with 24h countdown; seasonal events with exclusive cosmetics never returning; creates urgency to spend now
- **Sunk cost escalation** — show cumulative time/gold invested before an optional IAP prompt; "you've built so much — don't lose it" framing
- **Near-miss** — in roguelite TD context: show the boss at 5 HP when the player loses; offer a gem-powered extra 10 seconds; statistically tuned to feel achievable

**For our roguelite TD deckbuilder — priority mechanics to wire in MVP:** Variable rewards (run-end loot), Battle pass, Energy cap on daily runs, Near-miss revival. Gacha on card packs in v1.1.

---

## R4 — Free game engines shortlist (heartbeat 2026-04-29 09:20)

Scored on: **Free?**, **AI/CLI-controllable?** (can Claude drive headless from a repo with no GUI babysitting), **iOS + Android export**, **Asset ecosystem**.

| Engine | Free? | AI / CLI-controllable | iOS + Android export | Asset ecosystem |
|---|---|---|---|---|
| **Unity 6** | Free under Personal tier (rev < $200k/yr); no per-install runtime fee since the 2024 reversal | **Strong.** Pure-text C# scripts, scene/prefab files are YAML-ish, headless batch builds via `-batchmode -executeMethod`, official MCP tooling exists. Editor still helpful but not required. | Best-in-class. Native iOS (Xcode project export) + Android (Gradle). Mature signing pipelines. | Largest of any engine. Asset Store huge (paid + free), great for placeholders → ship. |
| **Godot 4.x** | 100% free, MIT licence, no royalties, no rev cap | **Excellent.** Scenes/scripts are plain text (`.tscn`, `.gd`), git-friendly, headless export from CLI (`godot --export-release`), GDScript is concise and Claude-native. Very LLM-friendly. | Yes both. iOS export is solid in 4.3+; Android export is mature. C# also supported if preferred. | Smaller than Unity but growing fast. Plenty of free CC0 assets via Kenney/OpenGameArt. Fewer paid plugins. |
| **Defold** | Free, no royalties (King-owned, permissive licence) | **Good.** Lua scripts, text-based project files, CLI builds via `bob.jar`, headless CI well-documented. Less mainstream so fewer LLM training examples. | Yes both. Specifically tuned for mobile — small binary sizes, low RAM. | Smaller ecosystem; official asset portal modest. Best when you'll write most assets yourself. |
| **Phaser 3 / 4** | MIT, fully free | **Excellent for code, weak for visual tooling.** Pure JS/TS, no editor required, runs on Node, trivial to drive from Claude. But it's a 2D web framework — you wrap with Capacitor/Cordova for stores. | Indirect: build to web, wrap with **Capacitor** (preferred 2026) for iOS/Android. Extra signing/store steps. Performance fine for 2D card/TD scope. | Web/JS library ecosystem is massive; game-specific assets via Kenney etc. |
| **Cocos Creator 3.x** | Free, no royalties | **Mid.** TypeScript scripting + scene editor. CLI builds exist but the editor is more central than Godot/Unity. Less LLM training data than Unity/Godot. | Yes both, very good mobile perf (huge in CN market). | Decent, China-heavy. English docs improved but still patchier than Unity/Godot. |

**Quick scoring (out of 5):**

| | Free | AI/CLI | iOS+Android | Assets | **Total** |
|---|---|---|---|---|---|
| Unity 6 | 4 | 4 | 5 | 5 | **18** |
| Godot 4 | 5 | 5 | 4 | 3 | **17** |
| Defold | 5 | 4 | 5 | 2 | **16** |
| Phaser + Capacitor | 5 | 5 | 3 | 4 | **17** |
| Cocos Creator | 5 | 3 | 5 | 3 | **16** |

**Take-away for R5 next:** Unity vs Godot is the real fight for our roguelite TD deckbuilder. Unity wins on asset availability and store-tooling maturity; Godot wins on pure-text Claude-driveability and zero licence drama. Phaser+Capacitor is a dark horse if we want web-first iteration speed.

---

## R6 — Free asset pipelines (heartbeat 2026-04-29 09:40)

**2D art / sprites — for painterly grimdark style we need:**
- **Stable Diffusion (SDXL / Flux) — local, free.** Full control of style, runs on Paul's GPU or via Anthropic image gen MCP. Model output licences are permissive for commercial use on most current models (CreativeML Open RAIL-M / Apache 2.0). Primary art workhorse.
- **Kenney.nl** — CC0, fully commercial. Style is cute/clean, not grimdark — useful for placeholder UI tiles, icons, prototyping only.
- **OpenGameArt.org** — mixed CC licences (CC0, CC-BY, GPL). **Must check per-asset** before shipping. Good for ambient props.
- **itch.io free asset packs** — same warning, per-asset licences. Some grimdark packs are excellent.
- **Krita** (free, GPL) — open-source Photoshop-equivalent for hand-touching AI output. Aseprite (£17, one-off) only if we go pixel-art; LibreSprite is the free fork.

**SFX — punchy game sounds:**
- **Sonniss GDC bundles** — annual "GameAudioGDC" CC0 packs, professional studio quality, **fully free + commercial**. Single best free SFX source.
- **Freesound.org** — CC licences (CC0 to CC-BY-NC). Filter for CC0 or CC-BY only; never use NC for commercial.
- **Bfxr / ChipTone / SFXR** — free generative tools for retro/synth SFX. Output is yours to use.

**Music — atmospheric, dread-laden:**
- **Pixabay Music** — own licence, free + commercial, no attribution required. Smaller library; some grimdark-adjacent tracks.
- **Incompetech (Kevin MacLeod)** — CC-BY, free **with attribution** in credits. Massive catalogue, decent dark/cinematic tracks.
- **Suno / Udio (paid tier)** — generative AI music. **Free tier is non-commercial only** — need paid (~$10–20/month) for commercial rights on outputs. Worth budgeting.
- **Bensound** — free with attribution; paid tier removes attribution requirement. Limited grimdark.

**Voice (only if Warlords get VO later):**
- **ElevenLabs paid tier** — 2025 ToS updated, paid plans grant commercial rights to outputs. Free tier is preview-only.
- **Coqui TTS (open source)** — fully free, weaker quality, fine for placeholder.

**Fonts:**
- **Google Fonts** — SIL Open Font Licence, free commercial, no attribution needed. Grimdark-friendly families: **Cormorant, Cinzel, IM Fell English, UnifrakturCook, Pirata One**.
- **The League of Movable Type** — OFL, designer-curated free commercial fonts.
- **Font Squirrel** — curated free-commercial only; safer than Dafont.
- **Avoid:** Dafont (most fonts there are "free for personal use only" — easy licensing trap).

**Recommended stack for our game:**
- **Art:** Stable Diffusion (SDXL or Flux model) + Krita touch-ups → grimdark painterly style.
- **SFX:** Sonniss GDC bundles as base, Freesound CC0 for top-ups, Bfxr for UI blips.
- **Music:** Suno/Udio paid tier (~$15/mo) OR Pixabay Music (free). Recommend paid — music is the cheapest way to make a grimdark game *feel* expensive.
- **Fonts:** Cinzel (display/title) + IM Fell English (body/lore text) — both Google Fonts, OFL.

**Total monthly cost at this tier:** $0–15. The only paid line item I'd recommend is Suno/Udio for music; everything else is genuinely free for commercial use.

---

## R5 — Recommended engine: **Godot 4** (heartbeat 2026-04-29 09:25)

1. **Pure-text project files** — `.tscn`, `.gd`, `.tres` all merge cleanly in git and read like config; Claude can author scenes without a GUI loop.
2. **Headless CLI builds** — `godot --headless --export-release "Android" build.apk` slots straight into GitHub Actions; no editor server, no licence dance.
3. **Zero licence/royalty risk** — MIT, no rev cap, no runtime-fee surprises like Unity's 2023 episode. Matters because we're optimising for "Paul never has to negotiate a contract."
4. **Scope fit** — 2D painterly grimdark, card UI, tower-defence grid: Godot's 2D node system is purpose-built for this; we don't need Unity's 3D firepower or asset-store breadth.
5. **Claude-driveability** — GDScript is concise and well-represented in training data; C# also available if we hit a perf wall.
6. **Trade-off accepted** — smaller paid-asset ecosystem than Unity. Mitigated because our art pipeline is AI-generated (Stable Diffusion / nano-banana / Kenney CC0 fillers), not asset-store-driven anyway.

**Verdict:** Godot 4 for B1 onwards. Phaser+Capacitor stays as the fallback if mobile export ever surprises us.

---

## V1 + V2 — completed 2026-04-29 (real-time with Paul)

- **V1 (PAT verification):** Confirmed via GitHub web UI. PAT is Active, expires 2026-07-27, scoped to `Gonzo8285/MobileGame` only, has Read+Write on code/actions/workflows/secrets/etc, Read on metadata. Direct CLI auth not possible — see network-environment note below.
- **V2 (repo bootstrap):** `.gitignore` + `README.md` authored in project folder, uploaded to repo by Paul via GitHub web UI, committed to main as "chore: bootstrap repo".
- **Network-environment note (important for all future build work):** R.T. Keedwell's corporate network does TLS interception (Schannel curl gets HTTP 000 on github.com, browser works fine because it has the corporate root CA via Group Policy). The Cowork sandbox's outbound proxy blocks github.com via allowlist (`X-Proxy-Error: blocked-by-allowlist`). So **neither Paul's laptop nor the sandbox can reach GitHub directly via CLI right now.** Implication: any future write to the repo from a heartbeat run will need either (a) a Cowork-side allowlist change, (b) a GitHub MCP connector (none in registry as of 2026-04-29), or (c) Paul as the manual courier via web UI. Phase 3 build work needs option (a) or (b) before it's automatable.

---

## V1 attempt — heartbeat 2026-04-29 09:16

- Sandbox is up, but its outbound proxy (`localhost:3128`) blocks `api.github.com` and `github.com` with `X-Proxy-Error: blocked-by-allowlist` (HTTP 403 at CONNECT).
- Result: cannot test the PAT or run `git ls-remote` from this sandbox at all — the request never reaches GitHub, so we can't tell if the token is good or bad.
- **Not a Paul blocker** (no evidence PAT is wrong). Treating this like "sandbox unavailable for V1" per heartbeat rules: V1 left unticked, retry next run in case the allowlist changes.
- If the next 2–3 heartbeats hit the same wall, escalate then — options would be (a) ask Paul to whitelist github.com on the sandbox if he can, or (b) shift V1/V2 verification to an out-of-sandbox path.

---


## R7 — Monetization stack (heartbeat 2026-04-29 18:20)

**Mediation networks (all free SDKs):**
- AdMob (Google): easiest setup, safest for Play Store, lower eCPMs, good fill. Best as a demand source, not as primary mediator in 2026.
- AppLovin MAX: industry-leading mediation in 2025-26, real-time bidding (MAX bidding), highest eCPMs in casual/midcore, engine-agnostic, strong dashboard. Free.
- Unity LevelPlay (ex-ironSource): Unity-native, strong rewarded performance, less relevant since engine = Godot 4.

**Pick:** AppLovin MAX as primary mediator + AdMob as a demand source in the waterfall. Rationale: best eCPMs, engine-agnostic (Godot), no fee.

**Rewarded video best practice:**
- Cap ~5-8 rewards/session to avoid devaluing soft currency.
- Placements: post-defeat continue, 2x end-of-run rewards, free daily chest, gacha bonus pull, energy refill, card-pack reroll.
- Always opt-in ("Watch ad to..."), never forced/interstitial-style block.
- Pre-load on session start; never gate core loop behind an ad load.
- Rewarded reward value ≈ 30-50% of equivalent IAP — preserves IAP funnel.

**IAP price ladder template (USD, store-localized):**
- $0.99 — starter pack (one-time, first 72h only, ~3x value)
- $2.99 — small gem pack / weekly mini-pass
- $4.99 — battle pass tier / small bundle
- $9.99 — medium pack (sweet-spot SKU, target ~40% of IAP revenue)
- $19.99 — large pack
- $49.99 — mega pack (whale tier)
- $99.99 — ultimate (whale ceiling, store max for many regions)
- 70/20/10 rev split typical: ~70% revenue from <5% of payers.
- Bundle > raw currency (perceived value, +Warlord/skin/cosmetic).
- Always run a first-purchase offer; refresh weekly bundles to drive habit.

**Compliance notes (PEGI 12, Apple/Google 2026):**
- Loot box odds must be disclosed in-store + in-game (Apple + Play policy).
- No paid-only gacha for under-12 surfaces; rewarded-video gacha is fine.
- ATT prompt on iOS, GDPR/UMP consent on Android — wire via MAX SDK.

## R8 — Retention systems blueprint (heartbeat 2026-04-29 18:21)

**D1 (target: 35-45% for casual/midcore):**
- Strong FTUE: first run is a guaranteed win (rigged easy), Warlord unlock at end, +1 card pack.
- Push notif at -22h: "Your warband marches at dawn — claim your daily relic."
- Day-1 quest: "Win 1 run" with juicy reward (rare card).
- Limited-time first-purchase offer pinned for 72h.

**D7 (target: 12-18%):**
- Daily login calendar (see template below) with a milestone reward on Day 7.
- Weekly battle pass mini-arc resets — 7-day cycle.
- Faction "favour" meter — pick a faction by D3, hits first reward at D7.
- Friend/clan onboarding nudge by D5 (even if PvE-only, social = guilds for co-op events).
- Push notif cadence: 1/day cap, smart-time, skipped if user already played that day.

**D30 (target: 4-7%):**
- Meta progression unlocks at D14 (e.g. 4th Warlord slot, "ascension" difficulty).
- Monthly battle pass premium track (~$4.99) with cosmetic + Warlord shard drip.
- Live ops calendar: 2 events/month (faction war, boss rush), each 5-7 days long.
- Returner bonus: lapsed >7d gets a "comeback" 3-day buff + free pack.
- Mastery / collection completion (300+ cards target by D30 — "gotta catch 'em all" pull).

**Daily reward calendar template (28-day cycle, monthly rotation):**
| Day | Free | Premium pass |
|-----|------|--------------|
| 1 | 50 gold | 100 gold + 1 common card |
| 2 | 30 gold | 60 gold + dust |
| 3 | 1 common pack | 1 rare pack |
| 4 | 50 gold | 100 gold + cosmetic shard |
| 5 | 30 gold | 60 gold + Warlord shard |
| 6 | 30 gold | 60 gold + dust |
| 7 | **1 rare pack + 200 gold** | **1 epic pack + cosmetic** |
| 14 | **1 epic pack** | **1 legendary card + 5 Warlord shards** |
| 21 | **1 legendary card** | **2 epic packs + skin** |
| 28 | **Warlord unlock token** | **Warlord skin + 1000 gold** |
- Streak preserve: 1 free skip / 14 days. Watch-rewarded-ad to restore streak.
- Reset on month boundary, but cumulative 28-day streak unlocks a permanent cosmetic.

## R9 — Apple Developer Program 2026 (heartbeat 2026-04-29 18:22)

**Cost:** $99/yr individual or organization (Organization needs a D-U-N-S number). Free tier exists but cannot ship to App Store — sideload/TestFlight only on dev's own devices, 7-day expiry.

**Recommended for Paul:** Individual ($99/yr) unless RT Keedwell Group should be the publisher (then Organization + D-U-N-S, +1-2 weeks lead time).

**What ONLY Paul can do (real blockers):**
- Enroll & pay the $99 with his Apple ID + 2FA on his own device.
- Verify identity (passport / driving licence) — Apple's KYC step.
- Sign Paid Apps Agreement + tax & banking forms in App Store Connect.
- Approve / accept any contract updates that pop up later.

**What Claude can prep (no Apple login needed):**
- Bundle ID naming, app metadata draft, store listing copy, screenshots, privacy policy text, age rating questionnaire answers.
- App Privacy "nutrition label" answers based on SDKs we wire (MAX, AdMob, Firebase).
- Export Compliance answers (we ship encryption only via standard HTTPS — exempt).

**Signing requirements (key constraint):**
- Code signing & uploads to App Store Connect REQUIRE macOS + Xcode (or a Mac CI runner).
- Paul has no Mac → use cloud Mac CI: **Codemagic (500 build min/month free)** or **GitHub Actions macOS runners (free for public repos / paid for private)**. Codemagic preferred — Godot 4 export templates supported, headless signing via fastlane match works, Claude can drive it.
- Need: Apple Distribution certificate + provisioning profile + App Store Connect API key (.p8). Claude can generate the .p8 via App Store Connect once Paul logs in once and clicks "create API key".

**Lead time to first TestFlight:** ~3-5 days from enrolment day (24-48h Apple verification + cert/profile setup + first build).

## R10 — Google Play Console 2026 (heartbeat 2026-04-29 18:23)

**Cost:** $25 one-time registration. Plus: identity verification mandatory since 2023 (passport/driving licence), and "developer verification" (D-U-N-S for orgs, gov ID for individuals) is enforced in 2026. Personal accounts must also have ≥12 testers run a closed test for ≥14 days before the first prod release (still in force 2026).

**Account choice:** Personal (Paul) is fine for now — cheaper, faster. Org account if RT Keedwell Group is publisher (D-U-N-S needed). Personal can be migrated to Org later.

**Testing tracks (use in this order):**
1. **Internal testing** — up to 100 testers, available within minutes. No review. Use for Claude's CI builds.
2. **Closed testing** — required: ≥12 opted-in testers actively testing for ≥14 consecutive days. Mandatory for new personal accounts before prod.
3. **Open testing** — public beta, listed on Play if you opt in. Soft-launch lever.
4. **Production** — global or staged country rollout (start 1-5%, ramp).

**Required artefacts (gathered before first upload):**
- Signed AAB (Android App Bundle, NOT APK) — Play App Signing handles key rotation.
- App icon: 512x512 PNG (32-bit). Feature graphic: 1024x500 PNG.
- Screenshots: phone (min 2, max 8), 7" tablet, 10" tablet (all optional but recommended).
- Short description (≤80 chars), full description (≤4000 chars).
- Privacy policy URL (mandatory, public, hosted — Paul needs a URL, can be a free GitHub Pages page).
- Data safety form (declares SDK data collection — Claude can prep based on MAX/AdMob/Firebase).
- Content rating: complete IARC questionnaire (PEGI 12 target).
- Target audience & content + ads declaration.
- Government / pricing / device categories.

**14-day pre-launch checklist:**
- Day -14: closed test launches with ≥12 testers (Paul to recruit — friends/family, or use Google's tester finder).
- Day -10: first crash-free target ≥99%, ANR <0.47%, all required forms green.
- Day -7: data safety, content rating, target-audience, ads declaration all submitted.
- Day -5: final store listing locked (screenshots, descriptions, localized copies).
- Day -3: pre-launch report (auto-run on closed track) reviewed — fix all "high severity" issues.
- Day -1: production release created in draft, country list set, staged rollout % = 5.
- Day 0: submit for review (review usually 1-3 days).

**Lead time:** Personal acct + 14-day closed test rule = realistic minimum 3 weeks from upload-ready to global production.

## R11 — ASO 2026 (heartbeat 2026-04-29 18:24)

**Apple App Store fields (iOS):**
- App Name: 30 chars (most-weighted in search ranking).
- Subtitle: 30 chars (highly weighted).
- Keywords: 100-char comma-separated list, hidden from users (highly weighted).
- Promotional Text: 170 chars, editable without resubmit (NOT indexed for search).
- Description: 4000 chars (NOT indexed by Apple — only first 3 lines visible above fold).
- In-App Events: indexed since iOS 15, drives discovery — use for live ops.

**Google Play fields (Android):**
- Title: 30 chars (heaviest weight).
- Short description: 80 chars (indexed).
- Full description: 4000 chars (FULLY indexed by Play — keyword density matters).
- Tags: pick 5 from Google's preset list (since 2023 — replaces old keyword field).

**Screenshot frame templates (the meta in 2026):**
- Slide 1 = hook ("ROGUELITE TD WITH CARDS" overlay + screenshot).
- Slide 2 = core fantasy ("BUILD YOUR WARBAND").
- Slide 3 = depth ("100+ CARDS, 10 WARLORDS").
- Slide 4 = social proof / award badge if any.
- Slide 5 = call to action ("PLAY FREE").
- Use 9:19.5 portrait, 1290x2796 for iPhone 6.7", 1080x1920 for Play.
- Auto-pipeline: Figma template + Claude generates per-locale variants.

**A/B test tooling:**
- Apple: native "Product Page Optimization" — 3 treatments, up to 90 days, 50% traffic split. Free.
- Google: native "Store Listing Experiments" — up to 5 variants, 90 days. Free.
- Third-party (paid): SplitMetrics, Storemaven — overkill for indie, skip.
- Test order: icon → screenshots 1-2 → subtitle → description. Icon CVR lift is biggest. Run one test at a time, ≥7 days each, need ≥1000 visitors/variant for significance.

**Quick keyword research (free):**
- AppFollow free tier, Sensor Tower free trial, Google Keyword Planner, Apple's own search-suggest.
- Target medium-volume / low-competition long-tails ("grimdark deckbuilder", "tower defense roguelite", "warband card game").

## R12 — Soft-launch playbook (heartbeat 2026-04-29 18:25)

**Soft-launch markets (English-speaking, lower CPI, mature mobile):**
- Tier-1 best for English midcore: **Canada**, **Australia**, **New Zealand**, **Ireland** — high payer behaviour mirrors US/UK, fraction of UA cost. Use these for monetisation tuning.
- Tier-2 for retention/scale tests: **Philippines**, **Malaysia**, **Vietnam** — cheap installs, big volume, but lower ARPDAU; use for retention/funnel debug not LTV.
- Tier-3 EU: **Netherlands**, **Sweden**, **Denmark** — payer behaviour close to UK, helpful for GDPR/UMP testing.

**Recommended 3-market combo for our game:** CA + AU + PH. CA+AU = LTV proxy, PH = retention/scale + cheap UA learning.

**KPI gates to global launch (must hit ALL before opening more markets):**
- D1 retention ≥ 38% (midcore deckbuilder benchmark).
- D7 retention ≥ 14%.
- D30 retention ≥ 5%.
- ARPDAU ≥ $0.18 (CA/AU blended).
- Crash-free sessions ≥ 99.5%.
- Tutorial completion ≥ 75%.
- Day-1 ad eCPM USD ≥ $20 (rewarded), $8 (interstitial).
- Payer conversion (D7) ≥ 2.0%.
- LTV-to-CPI break-even path < 180 days at modest UA spend.

**Soft-launch duration:** 8-12 weeks typical. Run 2-week iterative cycles: ship build → measure → tune → reship.

**UA budget for soft launch:** $500-$2000/month is enough to get statistically meaningful retention/ARPDAU signals in CA+AU+PH. Use Meta + Google App Campaigns. Don't bother with TikTok during soft-launch (noise).

**Decision tree post soft-launch:**
- All KPIs green → ramp to UK + US + DE + JP (top revenue markets).
- ARPDAU green but D7 weak → fix retention before scaling.
- D7 green but ARPDAU weak → tune monetisation surfaces, don't kill the game.
- Both red → pivot or pause; don't burn UA $ on a leaky bucket.

## R13 — CI/CD options Claude can drive headless (heartbeat 2026-04-29 18:26)

**The constraint:** iOS signing/upload requires macOS. Android signing can run anywhere. Claude needs a CI that exposes an API/CLI Claude can drive without Paul logging in for each build.

**Comparison:**

| Option | Free tier | macOS? | Godot 4? | Auth Claude can drive | Notes |
|---|---|---|---|---|---|
| **GitHub Actions** | 2000 min/mo private (Linux), 500 min/mo macOS for paid; free for public | Yes (paid for private repo) | Yes (community templates) | PAT + repo secrets | Strongest option if Paul accepts paid macOS minutes (~$0.08/min). Free for Linux Android builds. |
| **Codemagic** | 500 min/mo free (incl. macOS) | Yes | Yes (official Godot template) | API token | Best free option for iOS. Built for mobile. fastlane match supported. **Recommended for iOS.** |
| **EAS Build (Expo)** | Limited free tier | Yes | No (React Native only) | API token | Skip — wrong engine. |
| **Unity Cloud Build** | Tied to Unity license | Yes | No | API | Skip — wrong engine. |
| **Bitrise** | 200 min/mo free | Yes | Yes (custom) | API token | Decent backup, more complex. |
| **Fastlane (self-hosted)** | Free | Needs Mac | Yes | n/a | Needs a Mac box; not viable for Paul. |

**Recommended stack:**
- **Android builds + tests:** GitHub Actions (Linux, free minutes), godot-headless container, output AAB, upload to Play via `r0adkll/upload-google-play` action.
- **iOS builds:** Codemagic (free 500 min/mo macOS, official Godot 4 export template, fastlane match for cert mgmt, App Store Connect API key for upload).
- **Repo:** Gonzo8285/MobileGame (already created).
- **Secrets needed in CI:**
  - GITHUB_PAT (already have).
  - GOOGLE_PLAY_SERVICE_ACCOUNT_JSON (Paul creates once in Play Console).
  - APP_STORE_CONNECT_API_KEY_ID + ISSUER_ID + .p8 file (Paul creates once in App Store Connect).
  - APPLE_TEAM_ID, MATCH_PASSWORD (Claude generates).

**Auth-flow steps that REQUIRE Paul (one-time each):**
1. Create Play Console service account → download JSON key → paste into a secret.
2. Create App Store Connect API key → download .p8 → paste into a secret.
3. Once those are in repo secrets, Claude drives all subsequent builds & uploads headless.

**Cost reality:** Codemagic free 500 min/mo = ~25-40 iOS builds/month. Enough for soft-launch cadence. If we exceed, $0.038/min macOS (cheaper than GitHub).

## R14 — AI tools / MCPs worth connecting (heartbeat 2026-04-29 18:27)

**Image / sprite gen:**
- **Stable Diffusion (local via ComfyUI / Automatic1111)** — free, fully offline, FLUX & SDXL checkpoints, ControlNet for consistent character poses. Best for painterly grimdark style. Claude can drive via API if exposed. (Paul: free, local.)
- **Leonardo.ai** — generous free tier (150 tokens/day), good game-asset presets, API available on paid plans. Good fallback. (Free tier OK.)
- **Scenario.gg** — built for game art, custom-trained style models, paid only. Skip for now.
- **Krea / Recraft** — quick concept work, free tiers. Useful for moodboards.

**Audio gen:**
- **freesound.org** — CC-licensed SFX library, free, attribution. Workhorse.
- **ElevenLabs** — free tier 10k chars/mo, voice for Warlord barks/UI lines. Paid is fairly cheap.
- **Suno** — free 50 songs/day, AI music for menu/combat/boss themes. Licence permits commercial use on paid tier (~$8/mo). Free tier non-commercial only — must upgrade before launch.
- **Udio** — Suno alternative, similar tier.
- **AudioCraft (Meta, local)** — free, runs locally, lower quality than Suno.

**Analytics:**
- **Firebase Analytics + Crashlytics** — free, Google-owned, baseline. Wire on day 1.
- **GameAnalytics** — free, designed for games (funnels, DAU/MAU, ARPDAU, monetisation). Highly recommended alongside Firebase.
- **AppsFlyer** — paid attribution; defer until soft-launch with paid UA.
- **Adjust** — paid alt; defer.

**Store-listing / ASO tools:**
- **AppTweak / Sensor Tower / data.ai** — paid, free trials. Use during ASO research only.
- **AppFollow** — free tier covers reviews monitoring + basic keywords.
- **Apple's own search-suggest + Play's tag list** — free, surprisingly decent.

**MCPs Claude could plug into right now (priority order):**
1. **GitHub MCP** — unblocks the firewall problem (Paul note in memory: corp net + sandbox both block github.com). Highest leverage.
2. **Filesystem MCP** — already implicit via Cowork.
3. **A web-fetch MCP that bypasses sandbox proxy** — would fix the same firewall gap.
4. **Image gen MCP** (e.g. fal.ai, Replicate, or local ComfyUI bridge) — Claude can drive concept art autonomously.
5. **Codemagic MCP / API wrapper** — trigger iOS builds from chat.
6. **Google Play Publisher API MCP** — upload AABs from CI, manage tracks.
7. **App Store Connect API MCP** — upload IPAs, manage TestFlight.

**All free / freemium:** SD local, Leonardo free, freesound, ElevenLabs free, Suno free (dev only), Firebase, GameAnalytics, AppFollow free, Apple/Play native A/B. Total monthly $ during dev: $0. During launch: ~$8 Suno + ~$5 ElevenLabs + ~$0 everything else = ~$15/mo.

## R15 — 1-page condensed brief (heartbeat 2026-04-29 18:28)

Wrote Phase 1 summary to `phase1_brief.md` in the project folder. Covers R1–R14 in one page: market, engine, monetisation, retention, storefronts, ASO, soft-launch, CI/CD, AI tooling, blockers, what's next (G4 onwards).

**Phase 1 complete.** Heartbeat continues into Phase 2.

## G4 — 1-page GDD (heartbeat 2026-04-29 18:30)

Wrote `gdd_v0.md` in project folder. Covers pitch, core loop, run structure, card types, Warlord classes, 5 factions (placeholder names — formalised in G6), monetisation surfaces, MVP scope, out-of-scope, working titles, risks/open Qs.

**Open Qs for Paul** (flagged in GDD):
- Energy mechanic yes/no for MVP?
- BP at MVP or post-soft-launch?
- Local GPU for ComfyUI or paid Leonardo for art?
- Working title from G5 list?

**Phase 2 still needs Paul sign-off before Phase 3 unlock.** Heartbeat continues working through G5–G9 to give Paul a complete review package.

## G5 — Name candidates (heartbeat 2026-04-29 18:32)

Wrote `g5_names.md`. Findings from 2 web searches:
- **Gallowmarch** — clean, no app-store or trademark collisions found. Heartbeat top pick.
- **Penitent Lane** — clean but reads softer than grimdark mandate.
- **The Last Banner** — clash w/ "Tattered Banners" (Steam) + too generic. Drop.
- **Ashen Tide** — clash w/ "Ashen Legacy" + "Ashen" mobile. Drop.
- **Hollow Crown** — clash w/ "Hollow Knight" audience confusion. Drop.
- **Backups generated:** Carrionfall, Bonewatch, Nightcantor, Veilcleave, Ruinmarch.

**Needs Paul:** pick top 1 (Gallowmarch recommended) so heartbeat can lock it in `project_config.md` and use it for repo/build naming. Full TM filing happens pre-launch, not pre-build.

---

## G6 — Faction bible v0 (heartbeat 2026-04-30 04:17)

Wrote `faction_bible.md` — 5 factions fleshed with vibe, visual cue (silhouette + palette + motif), mechanical role, and a flagship unit each.

- **Iron Penitents** — aggro/sacrifice; oxblood + iron; nail-helms, chains.
- **Ash-Mourners** — control/debuff; charcoal + ember; censers, ash-painted faces.
- **Coven of the Black Mire** — swarm/poison; bog-green + leech-purple; antler crowns, drowned familiars.
- **The Last Legion** — tempo/formation; storm-blue + brass; tattered "Crowned Eagle Sundered" heraldry (original).
- **Skinward Pact** — summoner/monstrous; forest-black + ochre; beastfolk shamans, hide cloaks.

IP-boundary cross-check passed: no GW / WotC / Privateer Press collisions. Names cleared for use in G7 card design unless Paul vetoes.

**Next heartbeat:** G7 — 30-card starter pool across 3 factions (18 units / 8 spells / 4 traps).

---

## G7 — Card design v0 (heartbeat 2026-04-30)

Wrote `cards_v0.md` — 30-card starter pool. MVP factions: Iron Penitents, Ash-Mourners, Coven of the Black Mire. (Last Legion + Skinward Pact held for post-MVP unlocks.)

- **Distribution:** 18 units (6/6/6) + 8 spells (3/2/3) + 4 traps (0/3/1). Mourners hold the trap toolkit because Control wants it most.
- **Rarity skew:** 16 C / 11 U / 3 R / 0 E — accessible starter pool, room to slot Epics in v0.1.
- **Curve:** bottom-heavy by design (1-cost: 7 cards, 2-cost: 8) — TD opening waves need cheap plays.
- **Archetype anchors hit:** Penitent aggro (Hammer-Confessor + Procession of Nails), Mourner control (Last Censer-Bearer + Cinder Tide + 3 traps), Coven swarm (Toad-Caller + Mother Quag).
- **Cross-faction splash cards:** P5 Choir-Master (aggro→swarm bridge), M4 Funeral Drummer (control→aggro), C8 Antler Crown (sacrifice tool that talks to Penitent decks).
- **Keywords used:** Cleave, Pierce-not-yet, Bleed, Poison, Root, Fear, Shield, Resurrect, Summon, Sacrifice, Penance, Dread. Smoke + Slow used as plain status — flagged for promotion to keywords in GDD v0.1.

**Open Qs for Paul** (logged in `cards_v0.md`): rarity mix bump? Mire-Spawn draftable y/n? Promote Smoke/Slow to formal keywords?

**Next heartbeat:** G8 — Monetisation surface map (markdown diagram showing where IAP / bundles / energy / BP / rewarded video slot in).

---

## G7 v0.1 — Paul's resolutions applied (2026-04-30)

Paul answered the three open Qs from `cards_v0.md`. Updates landed:

- **Rarity:** Honest miscount caught — original v0 was 15C/11U/4R (not 16/11/3 as written). Paul asked to bump R, so promoted **M8 Cinder Tide U → R**. Final mix **15 C / 10 U / 5 R**. Slightly Mourner-heavy on Rares — flagged for v0.2 (consider promoting C5 Briar-Hag for symmetry).
- **C1 Mire-Spawn:** Now **draftable** at 0-cost in early Coven decks (was token-only). Plus art hook: ship a unique **"Beta Pull" alt-art skin** for early-access cohort — feeds founder/closed-beta retention narrative and gives a collectible flex item from day one. Action: log on B3 art pipeline backlog when Phase 3 unlocks.
- **Smoke + Slow:** Promoted to **permanent evergreen keywords**. Added formal definitions to `cards_v0.md` keyword block AND updated `gdd_v0.md` Keywords section to v0.1.
  - **Smoke** = zone status, Fear-1 + -1 ATK while inside, stacks with Dread.
  - **Slow-X** = unit movement -X tiles/turn, caps at Slow-3 (= Root), stacks with Poison/Bleed.

Files touched: `cards_v0.md` (now v0.1), `gdd_v0.md` (keyword section v0.1).

**Next heartbeat:** G8 — Monetisation surface map.

---

## G8 — Monetisation surface map (heartbeat 2026-04-30 14:16)

- Created `monetisation_map.md` — Mermaid player-journey diagram + 12 surface-by-surface entries.
- Key choices made (flagged for Paul to override if wanted):
  - Energy: OFF at launch, A/B-test only later.
  - BP price: $4.99 standard / $9.99 Pass+ (industry-standard).
  - Paid Warlords always also reachable via grind (Marrow Shards). No power locked to gacha.
  - Rewarded ads capped at 5/session, 8/day.
  - MVP monetisation = gold IAP + single rewarded daily chest. Everything else post-soft-launch.
- Anti-P2W guardrails restated as design constraints (PvE-only is doing most of the work here).
- 4 open questions appended to file for Paul's call.
- Next eligible item: G9 Warlord roster (10 chars).

---

## G9 — Warlord roster v0 (live session 2026-04-30 ~17:55)

- Created `warlords_v0.md`. 10 Warlords: 5 free spanning all 5 playstyles & all 5 factions, 5 paid as cross-faction/flavour archetypes.
- Free roster: Brother Ardent (aggro, Penitents), Mater Cinderis (control, Mourners), Hag Murielle (swarm, Coven), Magister Vellenne (tempo, Legion), Vren the Stitched (summoner, Pact).
- Paid roster: Marrow-Sage, Old Gaol, Saint of Smoke, Boy-King in Brass, Last Confessor.
- Unlock economy: 12k–25k Marrow Shards OR 1.2k–2.5k gems (maps to G8 IAP ladder, ~$9.99–$19.99 effective).
- MVP playable: 3 free Warlords (Ardent, Cinderis, Vren) — covers 3 most distinct fantasies; Hag + Vellenne in build 2.
- Anti-P2W audit run against G8 guardrails — every paid Warlord reachable via grind, no paid passive is strictly stronger.
- 4 open questions for Paul appended to file.
- **Phase 2 backlog now empty.** Once Paul signs off the GDD + warlords + monetisation map, Phase 3 unlocks.

---

## Workflow note (2026-04-30)

- `.gitignore` patched to also exclude `.secrets/` (legacy hidden dir from older setup) and any `**/github_pat.txt`. Belt-and-braces for the upcoming first push.
- GitHub workflow now lives in memory: Cowork = author, Claude Code (CLI, on Paul's laptop, with the GitHub extension) = git ops. Phase 3 build is unblocked.

Heartbeat 2026-04-30 18:05 — idle, awaiting Paul (Phase 2 complete; Phase 3 gated on Paul's sign-off of GDD)

---

## Phase 3 unlocked — 2026-04-30

Paul confirmed Phase 3 sign-off. Build phase begins. B1 (repo init / engine skeleton / CI) is next.

---

## B1 — Godot 4 skeleton + CI (2026-04-30)

- `game/project.godot` — Godot 4.3 Mobile, 1080×1920, canvas_items stretch, mobile renderer
- `game/icon.svg` — placeholder gallows-skull icon (grimdark, replace in B3)
- `game/scenes/main.tscn` — root Node2D with main.gd attached
- `game/src/main.gd` — hello-world `_ready()` print, entry point for B2 bootstrap
- `.github/workflows/ci.yml` — validates project structure on push/PR to main; no Godot binary needed yet (structure check only)
- **Action for Paul:** commit all new files and push to Gonzo8285/MobileGame main via Claude Code. CI will run automatically and should go green.

---

## G9 round 2 — Warlord roster respun for Gallowfell (live session 2026-04-30 ~18:00)

- Paul wrote `lore_gallowfell.md` — reframes factions: Iron Penitents kept, **Withered Court / Hollow Pact / Ferrum Host / Sable Wilds** replace v0 factions. Adds Hanging Hour and Reanimation curse mechanics. Names "The Curse of Gallowfell" as working title. Reserves an Innocent Saint as Warlord 11.
- Created `warlords_v1.md` — 11-Warlord roster aligned to Gallowfell. v0 deprecated (kept on disk for diff history).
- Free 5: Penance-Captain Vyrrun (aggro/Penitents), Court-Necromant Sieren (control/Court), Marsh-Mother Eddra (swarm/Pact), Forge-Marshal Veska (tempo/Host), Tree-Walker Mhar (summoner/Wilds).
- Paid 5: Vow-Broken Magus, Warden Caspar Voll the Empty Throne, Saint of Gallowsmoke, Brass-Crowned Whelp, Last Confessor.
- Warlord 11: **The Saint That Should Not Hang** — lore-locked secret, no IAP path. Mechanically fuses Hanging Hour + Reanimation. Unlocks on completing campaign with all 10 others.
- Anti-P2W audit re-run vs G8 — passes.
- Backlog reference updated to `warlords_v1.md`.

## Phase 2.5 sync work queued (2026-04-30)

faction_bible.md, gdd_v0.md, cards_v0.md still use the old faction names. Added S1–S4 to backlog as Phase 2.5. Will be picked up by heartbeat in order; Paul can override or do them faster manually.

## Phase 3 status (2026-04-30)

B1 ticked while we were respinning G9 — Claude Code (with the GitHub extension) handled the engine skeleton + CI hello-world push. Phase 3 is live. B2 is next: core loop prototype playable in editor. Will pick up once Phase 2.5 sync clears (or sooner if Paul says go).

---

## S1 — faction_bible.md Gallowfell sync (heartbeat 2026-04-30)

- Verified `faction_bible.md` is already at v1 with correct Gallowfell factions: Iron Penitents, Withered Court (Catacombs), Hollow Pact (Bog of Bargains), Ferrum Host (The Foundry), Sable Wilds (Cinderwood).
- Work was completed in the G9/lore session but the backlog item was not ticked. Ticked now.
- Note: `lore_gallowfell.md` biome section still uses v0 faction names (Ash-Mourners, Coven of the Black Mire, The Last Legion, Skinward Pact) due to its own reconciliation note. This is cosmetic only — `faction_bible.md` v1 is the authoritative source for faction names/vibes going into Phase 3.
- Next: S2 (update `gdd_v0.md`).

---

## Phase 2.5 sync complete (live session 2026-04-30 ~18:25)

### S1 — faction_bible.md
- Full rewrite to v1: Iron Penitents (kept), Withered Court, Hollow Pact, Ferrum Host, Sable Wilds. Each faction now has biome + lore reason to march on Gallowfell + IP-check entry. Carry-over keywords unchanged. Diff vs v0 included in-doc.

### S2 — gdd_v0.md
- Setting paragraph: district names rewired to canonical biomes (Catacombs, Bog of Bargains, Foundry, Cinderwood).
- New "Curse mechanics" section added: Hanging Hour + Reanimation as in-fiction systems.
- Faction list block: 5 new faction names + biome tag + role (one-liner each).
- Warlord classes block: now references `warlords_v1.md` and notes 5+5+1 roster shape including the lore-locked Innocent Saint.
- Title block already locked by Paul earlier; left untouched.

### S3 — cards_v0.md
- Section headers renamed (Ash-Mourners → Withered Court; Coven of the Black Mire → Hollow Pact). Iron Penitents unchanged.
- C1 token name: Mire-Spawn → Bog-Spawn (canonical). All references replaced.
- Cross-faction archetype anchors and rare-pull list updated to faction names.
- Card text untouched — "Mourner" / "Witch" / "Hag" remain valid unit-type tags within the renamed factions. **Phase 2.5 was a name pass, not a balance pass** — no HP/ATK/cost/keyword changed.
- Change log split into v0→v0.1 and v0.1→v1.0 sections.
- Verified: grep for old-faction terms returns only deliberate change-log/diff entries.

### S4 — Gallowfell availability check (surface level)
- WebSearch on "Gallowfell" + game/app/trademark + steam/itch — **no public hits.** No game, app, or trademark matches surface in basic search.
- This is a positive signal but **not legally conclusive.** Formal checks still required:
  - USPTO TESS search (US trademark)
  - EUIPO eSearch (EU trademark)
  - UKIPO trade-mark search (UK)
  - GoDaddy/Namecheap whois on `gallowfell.com`, `.app`, `.io`, `.game`
  - Apple App Store + Google Play search
- These are all reachable from Claude Code on Paul's laptop. Queued: Paul to run a "trademark + domain availability check on Gallowfell" prompt in Claude Code at his convenience. **No blocker** for B2 to proceed in parallel.

### Phase 2.5 outcome
All design docs now consistent with `lore_gallowfell.md`. v0 docs deprecated by content but kept on disk for diff history. No file deletions.

---

## Phase 3 unlocked

Phase 2 sign-off received from Paul 2026-04-30 (option "Approve everything except Warlord names" → resolved with `warlords_v1.md`). Phase 2.5 lore reconciliation completed in same session. **Heartbeat may now pick up Phase 3 items B2 onwards.** B1 already ticked (Claude Code shipped engine skeleton + CI).

---

## B2.1 — Data spine: Card resource + GFEnums (heartbeat 2026-05-01 00:19)

First bite of B2 done. Created two files under `game/src/data/`:

- `enums.gd` — `GFEnums` namespace (extends Object, class_name). Enums: Faction (5 + Neutral), CardType, Rarity (incl. reserved Epic/Legendary), AttackRange, Keyword (14 evergreen — matches cards_v0.md v1.0 incl. Smoke + Slow), RunPhase (7 states for the meta navigator).
- `card.gd` — `Card` Resource (extends Resource, class_name). Exports id, display_name, faction, card_type, rarity, cost, unit-stat group (hp/atk/range/cd), effects group (keywords array + effect/flavour text), presentation group (art/icon/sfx paths), meta group (draftable, starter, unlock_tag). Helpers: `duplicate_card()` for safe deck/hand/discard moves, `has_keyword()` predicate, `validate()` for CI gating.

Rationale: this is the data shape every other B2 sub-task hangs off (deck shuffling, hand UI, combat resolver, reward picker). Authored as Godot 4 `Resource` so designers can edit cards as `.tres` files in the editor without touching code — supports later iteration without code review.

Stable card-id convention recorded in `card.gd` header: `<faction-letter><number>` (P1, M5, C6 …). Never reuse a retired ID across balance passes.

Decomposed B2 into 10 sub-tasks (B2.1 → B2.10) in `backlog.md` so future heartbeats can chip away one bite per run. Next up: B2.2 — author the 30 starter cards from `cards_v0.md` as `.tres` files. That alone will likely take 2-3 heartbeats (10 cards each).

Verification: not run — no Godot in the sandbox. Pure GDScript with no exotic syntax; Claude Code on Paul's laptop (or the Godot editor on first open) will surface any parse errors. Files are isolated under `game/src/data/` so a parse error here doesn't break `main.gd` hello-world.

Push: as before, files are authored locally only. Git push handled by Claude Code on Paul's laptop or by Paul via the GitHub web UI when he next syncs.

## B2.2 — 30 starter cards authored (heartbeat 2026-05-01 09:42)

- Wrote 30 `.tres` files to `game/data/cards/` (P1–P9, M1–M11, C1–C10). Filename == `id`, per convention.
- Format: standard Godot 4 `[gd_resource]` resource referencing `res://src/data/card.gd`. Enums stored as ints (Faction/CardType/Rarity/AttackRange); keywords stored as `Array[int]` (e.g. `Array[int]([10])` for Penance). Empty keyword arrays use `Array[int]([])`.
- Stat data sourced verbatim from `cards_v0.md` v1.0. Counts verified: 18 units / 8 spells / 4 traps; 15 C / 10 U / 5 R; 9 Penitents / 11 Withered Court / 10 Hollow Pact. ID == filename for all 30.
- All marked `is_draftable = true` (incl. C1 Bog-Spawn per v0.1) and `is_starter = true`. `unlock_tag` empty across the board (Warlord-gated cards come later). Art/sfx paths blank — UI must placeholder until B3.
- Flavour text: added 1-liner per card in the gallows-humour register. Mechanically inert; stripped/swapped freely in localisation pass.
- Caveats — Godot will assign `uid://` headers on first editor open; no `uid` field set manually. Typed `Array[int]` should round-trip cleanly into `Array[GFEnums.Keyword]` since enums are ints under the hood — flag for verification when the editor first parses these (next sandbox-with-Godot run, or Paul opens project locally).
- Next eligible item: **B2.3** — Deck/Hand/Discard classes with shuffle, draw, mulligan, mill rules.

## C1 — Per-faction archetype briefs (heartbeat 2026-05-01 09:18)

- Wrote `archetypes_v0.md` — 5 factions × 3 sub-archetypes = 15 archetype spines. Each carries: 4c R identity, 5–6c R payoff, 2–3–4 cost spine, 1c cheap fuel, hard-counter (rival archetype), splash-into hook.
- Faction names: used the **Track A canonical lock** from L1 (Iron Penitents / Ash-Mourners / Coven of the Black Mire / The Last Legion / Skinward Pact). `faction_bible.md` v1 still uses Track B headers — that rename pass is L2 and is queued separately.
- Lore mapping: Track B → Track A is 1:1 (Withered Court → Ash-Mourners, Hollow Pact → Coven of the Black Mire, Ferrum Host → The Last Legion, Sable Wilds → Skinward Pact). Mechanical roles unchanged from `faction_bible.md` v1.
- Anti-synergy grid: full 15×1 in-doc; intentionally uneven so Skinward Pact reads as the wildcard / most-countered (matches the v1 plan to gate Wilds as a 4th-unlock mastery faction).
- Existing card-pool reuse: Penitents/Mourners/Coven archetypes lean heavily on `cards_v0.md` v1.0 cards (P1–P9, M1–M11, C1–C8). Legion/Pact archetypes are net-new — placeholder card names for C5/C6 to author.
- Net-new card stubs flagged for downstream authoring: Hierarch of the Open Wound, Saint of Cinders, Confessor-At-Arms, Procession Bleeds the Lane, Headsman of the Long Aisle, Necrologist of the Catacombs, Funeral Bellringer, Witch of the Bound Coin, Brood-Mother of the Mire, Ferryman of the Drowned Coin, Drowning of the Demon-Coin (Penitents/Mourners/Coven net-new) plus the full Legion/Pact rosters.
- Rarity-skew target per faction: ~24 C / ~12 U / ~4 R; per archetype ~10–12 cards (~1 R / 2–3 U / rest C).
- 4 open questions appended to the file for Paul: Mother Quag split y/n, M5 promotion 3c U → 4c R y/n, Wilds-as-wildcard balance call, identity-card naming veto round.
- Verification: in-doc checks only — anti-synergy grid covers all 15 archetypes (no dangling row), every faction appears as both a "counter" and "countered" at least once (no universal soft target), card-IDs cross-checked against `cards_v0.md` v1.0. No engine wiring this run.
- Next eligible heartbeat item: **C2** (Iron Penitents full ~40-card pool + `.tres` files). Note: C2 is large; expect 3–4 heartbeats to land.

## C1 v0.1 — Paul's resolutions applied (live session 2026-05-01)

Paul answered all 4 open questions; updates landed in `archetypes_v0.md` (v0.1 block at top + targeted edits below):

- **Mother Quag (C6):** stays as single dual-archetype 5c R (no split). C1 Poison-Stack and C2 Bog-Spawn Swarm entries both reference the same card. C4 downstream note updated.
- **M5 Last Censer-Bearer:** promoted 3c U → 4c R as Smoke-Fear identity. Statline reshape: 4/4 / Range-S / CD-2 / Dread-1 to all enemies in 2 tiles each turn. Propagates to `cards_v1.md` (TBD) and to C3 Ash-Mourners full pool.
- **Anti-synergy grid rebalanced:** restructured to symmetric in-degree=1 / out-degree=1 per archetype, 3 deals / 3 receives per faction. Three edges shifted: P-Penance→C-Poison ⟶ M-Trap→C-Poison; P-Cleave→S-Big ⟶ L-Echo→S-Big; L-Rally→C-Swarm ⟶ S-Beast→C-Swarm. Skinward Pact is now a normal participant in the rivalry web (was: most-countered wildcard).
- **New card names:** approved by Paul, no vetoes. Locked for use in C2–C6.

Verification: anti-synergy grid checked — every archetype appears as both dealer and receiver exactly once; per-faction tally is 3/3/3/3/3 deals and 3/3/3/3/3 receives. Mutual rivalries preserved: P-Bleed ↔ L-Banner and P-Penance ↔ C-Sacrifice-Combo.

Open thread: Paul gave "ok go ahead" on names. Asking him directly whether to start C2 in this session or wait for next heartbeat (C2 is ~40 cards + 40 `.tres` files — meaningful spend).

## C2 — Iron Penitents full pool, markdown design (live session 2026-05-01)

Took the "ok go ahead" to mean **proceed with C2**. Wrote `cards_iron_penitents_v1.md` — full 40-card design across the 3 archetypes per `archetypes_v0.md` v0.1.

- **Pool composition:** 24 units / 10 spells / 4 traps / 2 specials = 40 cards (60/25/10/5 distribution, hit exactly).
- **Per-archetype split:** 13 / 13 / 13 cards + 1 cross-archetype overlap (P4 Hammer-Confessor sits in both Cleave and Bleed splash).
- **Existing P1–P9 absorbed unchanged** (no stat changes in this pass — flagged as Q4 for Paul if he wants a v0-balance retune folded in).
- **31 net-new cards (P10–P40)** including:
  - Bleed identity P15 Hierarch of the Open Wound (4c R) and payoff P19 Procession Bleeds the Lane (6c U — held at U so Bleed decks see it consistently).
  - Penance identity P23 Saint of Cinders (4c R; payoff is existing P6 Crucified Saint).
  - Cleave identity P30 Confessor-At-Arms (4c R) and payoff P33 Headsman of the Long Aisle (5c R, Cleave-3 row-clearer).
  - 2 relic specials introduced (P39 Reliquary of Wounds, P40 Crown of the Hanged Confessor) — first time the game has run-persistent equippables in design.
- **Rarity skew:** 24 C / 12 U / 4 R = 60/30/10. 3 of 4 Rares are archetype identities; 1 is the Cleave payoff.
- **Splash coverage:** 5 cards splash cleanly into rival faction archetypes (P12, P25, P22, P19, P34) — meets C7's "≥2 splash hooks per faction" target.
- **4 open questions for Paul** appended to file: specials-as-relics model OK, Crucified Saint vs Hierarch tier coexistence, trap distribution, P1–P9 stat retune yes/no.

`.tres` file authoring (P10–P40 in `game/data/cards/iron_penitents/`) deferred to next heartbeat run — that's a 31-file mechanical conversion job, perfect bite-size for unmanned. C2 ticked partially: markdown is done; `.tres` files pending. Will tick C2 fully once `.tres` files land.

Verification: file written; no engine integration this turn (no `.tres` files yet). Card-IDs cross-checked against `cards_v0.md` v1.0 (no collisions: P1-P9 retained, new starts at P10). Faction names use canonical Track A throughout. Anti-synergy and splash hooks reference `archetypes_v0.md` v0.1.

Next eligible heartbeat item: **C2 (.tres authoring)** — 31 files for P10–P40, then optional migration of P1–P9 into the same subfolder. After that, C3 Ash-Mourners full pool.

## C2 — Iron Penitents `.tres` files (heartbeat 2026-05-01 04:30)

Closed out the second half of C2. Generated all 31 new card resources via a Python one-shot in the bash sandbox; wrote them to `game/data/cards/iron_penitents/P10.tres` … `P40.tres`.

- **Schema match:** cards round-trip the `Card` resource exactly (id / display_name / faction=0 / card_type / rarity / cost / hp / atk / range / cd / keywords[] / effect_text / flavour_text / is_draftable / is_starter / unlock_tag). Format mirrors the v0 P1–P9 files byte-for-byte modulo data.
- **Type/rarity tally (matches markdown):** 24 units (ctype=0) + 8 spells (ctype=1) + 4 traps (ctype=2) + 2 relic-flagged spells = 38 in this batch + 9 existing in `cards/` = 47 file presence (note: P10–P40 only authored here; P1–P9 still live one folder up). Net new files: 31.
- **Relic handling (P39, P40):** the `Card` schema has no `RELIC` `CardType`, so per Paul's still-open Q1 in `cards_iron_penitents_v1.md` I tagged them as `card_type=1` (SPELL) with `is_draftable=false` and `unlock_tag=&"relic_iron_penitents"`. Future relic-system work (or Paul's Q1 answer) can branch on `unlock_tag`. No data loss.
- **`is_starter`:** false for all P10–P40 (these are pool-pull cards, not the 30-card MVP starter set; P1–P9 keep `is_starter=true`).
- **Spot-checked** P15 (rare unit, Hierarch), P19 (6c spell payoff), P38 (trap with Root+Bleed keyword array), P40 (relic with `is_draftable=false`+`unlock_tag`). All four serialize cleanly.

Two structural notes for the next heartbeat (or Paul):
1. **Folder layout:** P1–P9 still live at `game/data/cards/*.tres` (alongside Withered Court / Hollow Pact starters), while the new P10–P40 sit in `game/data/cards/iron_penitents/`. This is intentional for now (the MVP loader can pick up either path), but a tidy-up pass could migrate P1–P9 into `iron_penitents/` once the loader is wiring-faction-aware. Flag for B2.x bookkeeping.
2. **Loader gap:** there is no card-registry / autoloader yet (`Deck` / `Hand` are still stubs per backlog B2.3). When B2.3 lands, point the registry at both `cards/*.tres` (existing v0) and `cards/iron_penitents/*.tres` (this batch), or migrate per the previous note.

C2 fully ticked on backlog. Next eligible: **C3 — Ash-Mourners full pool** (~40 cards). C3 has a known up-front design task (M5 Last Censer-Bearer promoted 3c U → 4c R per Paul's S2 lock) plus two new identity cards to author (Necrologist of the Catacombs B2 + Funeral Bellringer B3 + M11 repositioned as B3 payoff). Same 60/25/10/5 split, same 24/12/4 rarity target.

## C3 — Ash-Mourners full pool (live session 2026-05-01)

Closed both halves of C3 in one pass while Paul was in chat (he said "do what else you can just now"). Authored `cards_ash_mourners_v1.md` (40 cards) + generated all 29 new `.tres` files M12–M40 under `game/data/cards/ash_mourners/` + applied the M5 statline reshape in place.

- **Pool composition:** 24 units / 10 spells / 4 traps / 2 specials = 40 cards (60/25/10/5, exact). 24 C / 12 U / 4 R rarity skew (exact). Existing 11 v0 cards (M1–M11) absorbed; 29 net-new (M12–M40).
- **M5 statline reshape applied:** 3c U / 3 HP / 1 ATK → 4c R / 4 HP / 2 ATK. Range-S, CD-2, Dread aura unchanged. `M5.tres` edited in place (id stable, no card-ID churn).
- **New identities at U not R:** Necrologist (M12) and Funeral Bellringer (M13) sit at 4c U to keep the 4-R-per-faction budget clean. Existing R count after promotion: M5, M6, M8, M11 = 4. R-budget hit exactly. Flagged in markdown Q2 if Paul wants R-tier identity cards.
- **Per-archetype card density:** B1 Smoke-Fear 16 primary (heavy because of v0 weight), B2 Resurrect-Spam 13 primary, B3 Trap-Control 11 primary. Splash cards count toward both archetypes.
- **Relics M39/M40:** authored as `card_type=SPELL`, `is_draftable=false`, `unlock_tag=&"relic_ash_mourners"`. Same Q1-pending pattern as Iron Penitents.
- **Faction-name reconciliation note:** GFEnums.Faction.WITHERED_COURT remains the engine constant (faction=1) even though the player-facing name is Ash-Mourners per L1. Engine-wide rename queued under L2; no rush since the constant is internal-only.

Verification: 29 files generated, file count confirmed via `ls | wc -l`. Spot-checked M12 (rare-ish identity unit), M38 (multi-keyword trap with Fear+Slow keywords [5,13]), M39 (relic with `is_draftable=false`+`unlock_tag`), M5.tres (new statline). All four serialize cleanly.

C3 fully ticked on backlog. Next eligible: **C4 — Coven of the Black Mire full pool** (~40 cards). C4 has a Paul-locked decision: C6 Mother Quag stays as a single dual-archetype card (no split) per 2026-05-01 lock. New cards to author: Witch of the Bound Coin (C1 identity), Brood-Mother of the Mire (C2 identity), Ferryman of the Drowned Coin (C3 identity), Drowning of the Demon-Coin (C3 payoff spell).

## C4 — Coven of the Black Mire full pool (live session 2026-05-01)

Closed C4 in the same session pass. Authored `cards_coven_v1.md` (40 cards) + generated all 30 new `.tres` files C11–C40 under `game/data/cards/coven/`. Existing C1–C10 untouched — faction=2 already correct on all of them.

- **Pool composition:** 24 units / 10 spells / 4 traps / 2 specials = 40 (exact). 24 C / 12 U / 4 R rarity skew (exact). Existing 10 v0 cards (C1–C10) absorbed; 30 net-new (C11–C40).
- **C6 Mother Quag dual-archetype lock honoured:** single 5c R card serving both A1 Poison-Stack payoff AND A2 Bog-Spawn-Swarm payoff — no split. Documented in markdown's archetype sections; printed once in .tres files (existing C6.tres unchanged).
- **R-budget tuning:** 4 R total = C6 (existing dual payoff) + C11 Witch of the Bound Coin (A1 identity) + C12 Brood-Mother of the Mire (A2 identity) + C29 Drowning of the Demon-Coin (A3 payoff spell). Ferryman (A3 identity) demoted to U to keep budget clean. Same pattern as Iron Penitents' Saint of Cinders + Ash-Mourners' Necrologist/Bellringer — flagged in Q2 if Paul wants R-tier identities.
- **Per-archetype card density:** A1 Poison-Stack 18 primary (heavy because v0 had a poison-trap toolkit), A2 Bog-Spawn-Swarm 15 primary, A3 Sacrifice-Combo 10 primary (deliberately tighter — combo archetype wants pieces, not breadth).
- **Relics C39/C40:** authored as `card_type=SPELL`, `is_draftable=false`, `unlock_tag=&"relic_coven"`. Same Q1-pending pattern as Iron Penitents and Ash-Mourners. Paul's call on the relic-slot system applies uniformly across all three factions.
- **Faction-name reconciliation note:** GFEnums.Faction.HOLLOW_PACT remains the engine constant (faction=2). Player-facing name "Coven of the Black Mire" used throughout markdown + flavour text. L2 cleanup queued for the constants rename.

Verification: 30 files generated, count confirmed via `ls | wc -l`. Existing C1–C10 cards confirmed at faction=2 via `grep "faction = "` (single value across the directory). Spot-checked C11 (rare identity Witch of the Bound Coin) — keywords [3] = POISON, rarity=2=R, faction=2 = HOLLOW_PACT/Coven. Looks clean.

C4 fully ticked on backlog. **Three full faction pools now stand authored: Iron Penitents (P10–P40, 31 cards), Ash-Mourners (M12–M40, 29 cards + M5 reshape), Coven of the Black Mire (C11–C40, 30 cards). 90 net-new card resources in `.tres` form across this multi-task session, plus 3 markdown design docs, plus 1 in-place statline reshape (M5 promotion). MVP scope per C8 = these 3 factions × ~100 cards in playable form.** Next eligible: **C5 — The Last Legion full pool** (~40 cards, all net-new — no v0 base). Then C6 Skinward Pact (also net-new).

## L2 — Track-B faction-name rename pass (live session 2026-05-01)

Closed L2 in same multi-task session. Batch-renamed Track-B leftovers across player-facing docs to canonical Track-A names per L1 lock 2026-04-30.

- **Files touched (5 markdown + 1 .tres):**
  - `cards_v0.md` — 8 lines updated (Withered Court → Ash-Mourners; Hollow Pact → Coven of the Black Mire). Section headers + change log narrative + cross-faction archetype check.
  - `gdd_v0.md` — 6 lines updated (faction list + biome map references).
  - `faction_bible.md` — 4 lines updated (section headers H2 1–5 now match Track-A).
  - `warlords_v1.md` — 20 lines updated (faction tags on each warlord entry + intro paragraph). Plus one mechanical fix: "the Ferrum Host" → "the The Last Legion" produced a double-article that I cleaned to "the Last Legion".
  - `lore_gallowfell.md` — already on Track-A; no replacements needed (verified 0 remaining).
  - `game/data/cards/C1.tres` — 1 line: effect_text "Hollow Pact cards" → "Coven of the Black Mire cards".
- **Engine constants preserved:** `GFEnums.Faction.WITHERED_COURT / HOLLOW_PACT / FERRUM_HOST / SABLE_WILDS` in `enums.gd` are internal-only and were not touched (the regex `Withered Court` etc. didn't match underscore-separated identifiers — verified post-rename via grep on enums.gd). Per the engine rename plan in this same notes file: a follow-up enum-rename pass is queued but non-blocking, since the constant names are internal and don't affect player-facing UI.
- **Historical decision records preserved:** `backlog.md` (3 references in L2 description + S1 description + Track A/B comparison) and `research_notes.md` (7 references in heartbeat narration documenting prior renames + the L1 decision) both retain Track-B mentions intentionally — they explain the rename history, not active usage.
- **Verification:** post-rename grep across the project shows zero Track-B references in any active design, code, or data file. All 5 of those files now use the Track-A names exclusively.

L2 fully ticked on backlog. **Lore is now self-consistent across the entire docs+data stack.** The 3 MVP faction pools (Iron Penitents / Ash-Mourners / Coven of the Black Mire) plus their .tres serializations, plus the warlord roster, plus the GDD, plus the faction bible — all on canonical Track-A naming. Engine constants stay on the historical names until a separate enum-rename pass is run (post-MVP, since it would touch every .tres faction= field and require a code/data lock-step migration).

## Phase 3 unlocked

Paul signed off Phase 3 in chat 2026-05-01. Heartbeats may now pull from the B-series build items in `backlog.md`. B1, B2.1, B2.2 already done. Next eligible: B2.3 (Deck / Hand / Discard runtime classes).

## B2.3 — Deck / Hand / Discard runtime (live session 2026-05-01)

Authored four files under `game/src/runtime/`:
- **`deck.gd`** (126 LoC) — RefCounted draw pile. Typed `Array[Card]` storage, embedded `RandomNumberGenerator` for deterministic shuffles (seed-injectable from `_init`). Fisher-Yates in place. `draw_one(from_discard)` auto-reshuffles when the deck is empty and a discard pile is supplied (caller can pass `null` for "fail silently" semantics). `mill(n, into_discard)` moves n cards from top to discard, returns the milled list (no auto-reshuffle on mill — milling an empty deck is a no-op, by design). Signals: `drew_card`, `reshuffled`, `milled_cards`. `validate()` hook for CI.
- **`hand.gd`** (100 LoC) — RefCounted hand zone. `DEFAULT_CAPACITY=10` (Slay the Spire convention; revisit per W2 Warlord variants). Overflow rule: `add()` returns false + emits `overflowed(card)` so the caller can route to discard. `mulligan(deck)` empties hand into deck, shuffles, redraws the same count. Currently unrestricted — W2 may layer "1/combat" later.
- **`discard.gd`** (67 LoC) — RefCounted discard pile. `clear_all()` returns the cards (used by `Deck.reshuffle_from`). `find_by_id(StringName)` and `remove(card)` for the re-summon design hook from `cards_iron_penitents_v1.md` (P39 Pyre Echo style — "choose a Penitent that died this combat").
- **`card_zones_test.gd`** (153 LoC) — smoke-test runner. Loads the Iron Penitent .tres pool from `res://data/cards/iron_penitents/`, builds a deck, exercises shuffle / draw 5 / play 1 / mill 3 / mulligan / drain-and-reshuffle / overflow / determinism / conservation invariant. 10 distinct assertions. Wired into `main.gd` via `RUN_CARD_ZONES_TEST=true` flag — runs on engine launch.

`main.gd` updated to instantiate the test as a child Node when the flag is on, so the suite fires automatically on F5 in Godot.

**Verification:** No Godot in sandbox. Wrote a Python port of the algorithm (Fisher-Yates with the same loop bounds + same draw/mill/reshuffle/mulligan rules) and ran the same assertion suite against a 31-card mock pool. Initial run caught a real test bug (orphaned trigger card after the reshuffle assertion broke the conservation invariant). Fixed in BOTH the Python and the GDScript test by routing the trigger card to hand. Re-run: 0 errors / PASS. Logic is sound — only Godot-specific GDScript syntax remains untested. Paul to confirm in-engine on next F5.

**Design notes baked into the API:**
- Card resources flow through zones via ownership transfer (one zone holds a given card at a time). No two zones reference the same card concurrently — prevents stale-reference bugs when card resources gain per-instance state in B2.6+.
- Determinism: pass `seed_value != 0` to `Deck.new(pool, seed_value)` to get a reproducible shuffle. Used in tests; will also be useful for replay/seed runs in B2.9.
- Signals are zone-scoped (the deck signals deck events, the hand signals hand events). UI in B2.6 / B2.7 should connect to these directly rather than poll.

B2.3 fully ticked. Next eligible: **B2.4 — `GameState` autoload singleton** (run state: mana, turn, phase; signals for UI). Then B2.5 (combat scene scaffold) and onward through B2.10 end-to-end smoke test.

## B2.4 — GameState autoload (live session 2026-05-01)

Authored `game/src/runtime/game_state.gd` (222 LoC) and registered it as the `GameState` autoload in `project.godot`. Plus `game/src/runtime/game_state_test.gd` (159 LoC) wired into `main.gd` so it fires alongside the B2.3 zones test.

**State surface (3 layers):**
- Run-level: `run_seed`, `active_warlord_id`, `current_phase`, `chapter`, `current_node`, `deck`/`hand`/`discard` (built fresh by `start_run`), `ash`, `keys`, `modifiers`.
- Combat-level: `turn`, `mana`, `max_mana` (currently 3, will scale per-chapter in balance pass).
- Vitals: `base_hp`, `max_base_hp` (default 30 each).

**API surface (8 public methods):**
- `start_run(starter_pool, warlord_id, seed)` — builds zones, resets all state, fires `run_started` + `phase_changed`.
- `end_run(victory)` — terminal phase + `run_ended(bool)`.
- `set_phase(new_phase)` — gated transition (no-op if already in that phase), fires `phase_changed(old, new)`.
- `start_combat()` — refunds hand+discard back into deck, shuffles, advances to turn 1.
- `next_turn()` — fires `turn_ended(prev)` then `turn_started(new)`, refills mana to ceiling.
- `spend_mana(n)` / `gain_mana(n)` — int math with overflow cap (`MANA_OVERFLOW_CAP = 5`). `spend_mana` returns false on insufficient (no deduct).
- `take_damage(n)` / `heal(n)` — clamped, return actual delta, `take_damage` triggers `end_run(false)` on lethal.
- `advance_node()` — bumps map cursor, re-enters MAP phase, fires `node_advanced(node, chapter)`.
- `debug_summary()` — one-line digest for console logging.

**Signals (7):** `run_started`, `run_ended`, `phase_changed`, `turn_started`, `turn_ended`, `mana_changed`, `hp_changed`, `node_advanced`. Designed for B2.6+ UI to bind directly rather than poll.

**Smoke test (`game_state_test.gd`):** 16 explicit assertions covering: run setup → combat start → mana spend (legal + over-budget) → mana gain (incl. cap test) → turn advance → damage → heal (incl. cap test) → lethal damage triggers `run_ended` and GAME_OVER phase. Plus a signal-emission audit (counts each signal type via prefix-match on a captured signal log) to confirm at least the expected number of fires.

**Verification:** No Godot in sandbox. Code reviewed by hand; logic mirrors B2.3 zones test pattern (Node child fires `_ready()`-driven suite). One sandbox quirk noted: bash `cat`/`wc -l` on the OneDrive mount sometimes shows a stale shorter view of recently-edited files; the Read tool (Windows API direct) is authoritative — files on disk are complete. Paul to confirm both B2.3 and B2.4 suites pass on next F5.

B2.4 fully ticked. Next eligible: **B2.5 — combat scene scaffold** (3-lane grid, wave spawner, base HP, defeat/victory conditions). This is where the actual game starts to take visible shape — `main.tscn` becomes the combat scene, GameState owns the run state, lanes spawn enemies, the player drops cards.

**Session totals so far:** 4 backlog items closed before Phase 3 sign-off (C2 .tres, C3, C4, L2) + 2 closed after (B2.3, B2.4). 6 total this session. Engine code: 834 LoC across `src/runtime/` (4 runtime classes + 2 smoke-test runners + 1 main). Project is now at ~90 .tres card resources + a tested data-spine + a testable run-state singleton — ready for combat scaffolding.


## C5 — The Last Legion full pool (heartbeat 2026-05-01 19:23)

- Authored `cards_last_legion_v1.md` (~40 cards, L1–L40) covering Rally-Formation / Tempo-Echo / Banner-Buff archetypes per `archetypes_v0.md` v0.1 D1/D2/D3 spines.
- Generated 40 `.tres` files under `game/data/cards/last_legion/` (faction = `FERRUM_HOST` = 3 in code; engine constant unchanged this pass — L2 cleanup queue still applies).
- Distribution: 24 units / 10 spells / 4 traps / 2 relics (relics stored as `card_type=SPELL`, `is_draftable=false`, `unlock_tag=&"relic_last_legion"` — mirrors Coven C39/C40 pattern).
- Rarity: 24 C / 12 U / 4 R. Rares = L7 Sergeant-Smith Vikar (D1 identity), L18 Echo-Sergeant (D2 identity), L33 Banner-Captain of the Crowned Anvil (D3 identity), L34 Crowned Anvil Standard (D3 payoff — 5c R artifact-unit, 8 HP / 0 ATK / no-attack aura).
- Cost curve bottom-heavy (2c=10, 3c=10) — formation wants bodies in lane every turn; 4-cost is the identity-card cluster (3 of 4 Rares at 4c); single 5c R payoff (L34).
- Splashes (≥2 hooks per faction target): L4 Iron Bayonet Drill → IP Cleave-Melee; L9 Iron Standard Unfurled → SP Big-Monster; L24 Hammer-Cycle → AM Trap-Control; L31 Iron Choir-Standard → AM Smoke-Fear; L34 Crowned Anvil Standard → IP Sacrifice-Penance. Five splashes — meets brief.
- Anti-synergy hard counters wired (D1↔AM Smoke-Fear, D2↔Coven Poison-Stack, D3↔IP Bleed-Stack) per v0.1 grid.
- Naming register: foundry / iron / hammer / anvil / banner / drill cant. Three flagship characters: Vikar, Banner-Captain of the Crowned Anvil, Echo-Sergeant. Lord-Marshal name reserved for future Warlord-tier signature card (not used here).
- Echo flagged as **soft keyword** — used in card text on 9 cards (L9, L14, L16, L17, L19, L21, L22, L23, L24, L25, L26) but NOT in `GFEnums.Keyword` enum. Engine arrays empty for Echo-only cards. Recommend adding `ECHO = 14` to `enums.gd` before B2.5 wave-spawner work — affects on-attack resolution.
- Banner-Token flagged as **new lane-object class** — not modelled in current `GameState`. Needs lightweight HP-less, duration-based, untargetable lane-object system. Smaller scope than Trap/Unit but still needs a class. Flag for B2.6/B2.7 design.
- Open questions for Paul (carried in `cards_last_legion_v1.md` Open questions section): Q1 Echo-as-keyword, Q2 Banner-Token engine class, Q3 demote L34 Crowned Anvil Standard R→U if Rares should all be named-characters, Q4 specials/relic system unification, Q5 Echo-Sergeant 2c-or-less gate vs 1c-or-less.
- Verification: not run — no Godot in the sandbox. Generator script (`outputs/gen_last_legion_tres.py`) ran clean, type/rarity counters validated (24 UNIT / 12 SPELL / 4 TRAP — relics counted as SPELL by design; 24 C / 12 U / 4 R), all 40 IDs present. `.tres` files structurally identical to existing C40 reference.
- Push: as before, files authored locally only. Git push handled by Claude Code on Paul's laptop.
- Next backlog hop: **C6 — Skinward Pact full pool (~40 cards)**. Net-new faction in cards file. Identity/payoff cards from `archetypes_v0.md` (Bear-Skin Hierophant, Wyrd-Shifter of the Cinderwood, Pelt-Bound Shaman, Thrask the Bear-Who-Was-King, etc.) used as the spine. After C6, the C7 cross-faction balance pass + C8 internal-MVP scope update close out Phase 2.6.

---

## C6 — Skinward Pact full pool (heartbeat 2026-05-02 23:24 UTC)

- Authored `cards_skinward_pact_v1.md` (~40 cards, W1–W40) covering Big-Monster / Transformation / Beast-Summon archetypes per `archetypes_v0.md` v0.1 E1/E2/E3 spines.
- Generated 40 `.tres` files under `game/data/cards/skinward_pact/` (faction = `SABLE_WILDS` = 4 in code; engine constant unchanged this pass — L2 cleanup queue still applies).
- Distribution: 24 units / 10 spells / 4 traps / 2 relics (relics stored as `card_type=SPELL`, `is_draftable=false`, `unlock_tag=&"relic_skinward_pact"` — mirrors C5/C4/C3/C2 relic pattern). At engine-level: 24 UNIT / 12 SPELL / 4 TRAP.
- Rarity: 24 C / 12 U / 4 R. Rares = W4 Bear-Skin Hierophant (E1 identity 4c), W8 Thrask the Bear-Who-Was-King (E1 payoff 6c — 8/8 melee, on-summon exile-Wilds-from-hand to absorb keywords), W19 Wyrd-Shifter of the Cinderwood (E2 identity 4c), W31 Pelt-Bound Shaman (E3 identity 4c, summons 1/2 Wolf-Token / turn cap 3).
- Cost curve: 0c=4, 1c=4, 2c=11, 3c=7, 4c=6, 5c=6, 6c=2 = 40 ✓. 2c-heavy bottom-mid (Beast-Summon needs cheap chaff every turn). 4-cost cluster carries 3 of 4 Rares (the identity cards). 4 zero-costs = 2 token-shape draftables (Cub-Token, Wolf-Token) + 2 relics.
- Token-shape cards (W27 Cub-Token 0c 1/1, W28 Wolf-Token 0c 1/2) authored as draftable C — mirrors C1 Bog-Spawn from Coven. Also runtime-summoned by Pelt-Bound Shaman / Pack-Call / Cub-Cry / Den-Mother / Whelp-Caller / Hunter's Snare / Whelping Burrow.
- Splashes (≥2 hooks per faction target): W17 Half-Wolf Initiate → Last Legion Rally-Formation (Pierce); W6 Boneward Behemoth → Last Legion Banner-Buff (Shield-2 stacks with Banner Shield-1); W14 Cub of the Sundered Tree → Coven Sacrifice-Combo; W34 Den-Mother → Coven Bog-Spawn Swarm (token-summoner overlap); W26 Skin-Snare Trap → Ash-Mourners Trap-Control. Five splashes — meets brief.
- Anti-synergy hard counters wired (E1↔Last Legion Tempo-Echo, E2↔Ash-Mourners Resurrect-Spam, E3↔Last Legion Rally-Formation) per v0.1 grid.
- Naming register: bear / wolf / antler / pelt / hide / skin / cinder / wyrd / bone cant. Three flagship characters: Bear-Skin Hierophant, Wyrd-Shifter of the Cinderwood, Pelt-Bound Shaman + 1 named legendary unit (Thrask, the Bear-Who-Was-King). The Antler-King kept as a named-spell payoff (W24, 6c U) — flavour-king of the faction without occupying a 4th-Rare slot.
- Transformation flagged as **soft keyword** — used in card text on 9 cards (W14, W15, W18, W19, W20, W21, W22, W23, W24, W25). Recommend adding `TRANSFORM = 15` to `enums.gd` alongside `ECHO = 14` (C5 Q1) before B2.6 card-play loop work — affects on-play resolution. Engine arrays empty for Transformation-only cards this pass.
- Wilds-tag system flagged for engine work — Wraiths (Ash-Mourners tokens, faction-1) explicitly DON'T count as Wilds for transformation targeting. Smallest-scope option: hard-code "faction == 4 → is_wilds" in card-play loop. Bigger-scope option: add `tags: Array[StringName]` field to Card resource for cross-faction tags (Wilds, Beast, Token, Banner, etc.). Flag carried into Open Questions on `cards_skinward_pact_v1.md`.
- Open questions for Paul (carried in `cards_skinward_pact_v1.md` Open questions section): Q1 Transformation-as-keyword, Q2 Wilds-tag engine field vs faction lookup, Q3 token cards as draftable C vs token-only (would force 24→22 C, need 2× U→C re-promotions), Q4 Thrask exile-Wilds mechanic vs baked-in keywords (flavour vs implementation simplicity), Q5 relic-system unification (carried from C5), Q6 Lifesteal soft-keyword on W3 Cinderwood Stalker (single-card scope, low priority).
- Verification: not run — no Godot in the sandbox. Generator script (`/tmp/gen_skinward.py`) ran clean, type/rarity counters validated (24 UNIT / 12 SPELL / 4 TRAP; 24 C / 12 U / 4 R), all 40 IDs present, cost curve audited. Per-card validation enforces unit-hp>0 and non-unit-no-stray-stats. `.tres` files structurally identical to existing L40 reference.
- Push: as before, files authored locally only. Git push handled by Claude Code on Paul's laptop.
- Phase 2.6 remaining: C7 (cross-faction balance pass — validate v0.1 anti-synergy grid + rarity skew across all 5 factions × ~40 cards = 200 cards) and C8 (internal-MVP scope update — first build = 3 factions × ~100 cards). After C8 the deckbuilder pool is sign-off-ready. Phase 2.7 (Warlord tier system, W1–W5) and Phase 2.8 L3 (re-export pitch .docx after rename) remain open.

---

## C7 — Cross-faction balance pass (heartbeat 2026-05-02 04:17 UTC)

- **Rarity distribution — all 5 factions consistent.** Every faction file declares + counts 24 C / 12 U / 4 R (60/30/10). Penitents/Ash-Mourners/Coven/Last-Legion/Skinward all hit target exactly. Type split also consistent: 24 UNIT / 12 SPELL / 4 TRAP (relics stored as SPELL is_draftable=false everywhere). ✓ no skew.
- **Anti-synergy grid — symmetric, no orphan archetypes.** `archetypes_v0.md` v0.1 grid: 15 archetypes × in-degree 1 / out-degree 1. Per faction: 3 dealt / 3 received. Verified by re-counting deals/receives column-by-column from the v0.1 table. Two intentional mutual rivalries preserved (P-Bleed↔L-Banner, P-Penance↔C-Sacrifice-Combo). No archetype is unanswered. ✓
- **Snowball flags (need rule clarification, not redesign):**
  1. **Aura stacking unspecified.** Multiple +1 ATK auras (Iron Choir-Master P5, Saint of Cinders P23, Banner-Captain L33, Crowned Anvil Standard L34) can co-exist in lane. GDD `core mechanics` glossary covers Smoke/Slow stacking but not ATK auras. Default to MTG-style stacking gives Penitents +2/+3 in lane very fast. Recommend: add to GDD that **named ATK auras don't stack — highest applies; Bleed/Poison/Smoke/Dread continue to stack as written**. One-line rule, unblocks balance assumptions across Penitents Penance + Legion Banner combos.
  2. **Bleed has no per-unit cap (except Stigmata-Bearer's aura cap).** Hierarch (P15) once/turn + Wound-Tender (P11) on-attack + Sanguine Vow (P17) Bleed-3 + Crimson Banner (P20) trap-Bleed-2 + Bone-Lash Whipster (P12) can land 8+ Bleed stacks on a single enemy. Procession Bleeds the Lane (P19, 6c U) then deals row-wide damage = stack-count. Brake exists ("stacks expire on resolve") but pre-resolve burst can be 8+ × row-width = 24+ dmg single-spell. Recommend: cap **Bleed-5 per enemy** (matches Stigmata aura ceiling, signals to player when stacking is wasted).
  3. **Wyrd-Shifter ramp is the only Skinward chain without a hard ceiling.** Once-per-turn 3-mana transform +2 cost. Cub (1c) → 3c → 5c → 7c over 3 turns at constant 3-mana spend. Wyrd-Bind (1c spell) shaves 1 mana off transformation. Brake = once-per-turn cap. Confirms intended power curve (Big-Monster archetype payoff window) but flag for soft-launch tuning: if Wyrd-Bind drops Wyrd-Shifter to 2-mana cadence, the curve is fast. Recommend: **leave as-is for internal MVP playtest, monitor in B2.10 smoke tests.**
- **Splash audit (≥2 splash hooks per faction).** Penitents 3 (Bleed→Coven Poison, Penance→Skinward Beast, Cleave→Legion Rally). Ash-Mourners 3 (Smoke→Legion Banner, Resurrect→Penitents Penance, Trap→Legion Echo). Coven 3 (Poison→Mourners Smoke, Swarm→Skinward Beast, Sac-Combo→Skinward Transform). Last Legion 3 (Rally→Penitents Cleave, Echo→Mourners Trap, Banner→Mourners Smoke). Skinward 5 (Big→Legion Banner, Transform→Coven Sac-Combo, Beast→Coven Swarm, plus W17 Pierce + W26 Trap-splash + W34 Den-Mother token-overlap per C6 notes). ✓ all factions ≥2.
- **Verdict: pool is balance-ship-ready for internal MVP.** No archetype redesigns required. Three rule clarifications needed (aura-stacking, Bleed-cap, Wyrd-Shifter monitoring) — all 1-line GDD edits, no card changes. C7 closed; C8 next.
- **Open Qs for Paul (low-stakes, MVP-deferrable):** Q1 confirm "named auras don't stack" rule for GDD; Q2 confirm Bleed-5 cap; Q3 confirm Wyrd-Shifter monitor-don't-tune yet stance. None of these block C8 or B2.5+.

## C8 — Internal-MVP scope lock (heartbeat 2026-05-02 09:16)

- Wrote `internal_mvp_scope.md`. IMV-1 = 3 factions (Penitents + Mourners + Coven, ~120 cards already on disk) + 3 faction-locked Warlords + B2.5–B2.10 build slice. Last Legion + Skinward Pact card `.tres` files stay on disk but flipped `is_draftable=false` for IMV-1; flip back on for IMV-2.
- Deferred to IMV-2: Warlord tier system (W1–W5), real ad/IAP SDK (B4), AI art pipeline (B3), soft-launch CI (B5–B7), multi-chapter map.
- Validation gate = 5 subjective pass conditions Paul applies after a Godot-editor playthrough (draft-choice matters / sub-archetypes distinct / counter-play exists / death informative / one-more-run pull). All 5 must hit before IMV-2 unlocks.
- Engine impact ≈ zero. `Card.is_draftable` already exists and is already false on L*/W*/relic cards. Deckbuilder UI just needs a faction filter. No `Warlord` schema change in IMV-1.
- Heartbeat queue after this: **B2.5** (combat scene scaffold) → B2.6 (card-play loop) → B2.7 (turn engine) → B2.8 (reward) → B2.9 (map) → B2.10 (smoke test). W1–W5 + L3 + B3.0 can slot in around B2 progress without conflict.
- One open Q for Paul (non-blocking): IMV-1 starter Warlord trio = canonical free-3 from `warlords_v1.md` or bespoke IMV-1 trio? Default if silent = canonical free-3 (cheaper, no throwaway design).
- Verification: in-doc only — file written, no code touched, no enum changes, no .tres edits this run. Counts cross-checked against backlog (P/M/C pools confirmed at 40 each via `ls game/data/cards/{iron_penitents,ash_mourners,coven}/`).
- Next eligible heartbeat item: **B2.5** — Combat scene scaffold (3-lane grid + wave spawner + base HP + win/lose conditions).

## W1 — Warlord tier system design (heartbeat 2026-05-02 14:17 UTC)

Authored `warlord_tiers_v0.md` against the Phase 2.7 W1 spec.

- **XP curve (verified hits target bands):** T1→T2 = 1,800 XP (~12 A0 wins), T2→T3 = 4,800 XP (~32), T3→T4 = 10,800 XP (~72). Increment-per-tier: 1,800 / 3,000 / 6,000.
- **XP per win:** 100 base × (1.5 final-boss bonus stacked additively with Ascension +10%/level, ×2.0 cap at A10). A0 win ≈ 150 XP; A5 ≈ 225; A10 ≈ 300.
- **Tier 2 = variant passive A or B (default stays available)** — both spreadsheet-balanced sidegrades. Worked example: Vyrrun Mortify → Flagellant Rite (aggro twist) / Ash-Vow (defence twist).
- **Tier 3 = signature alt-fire**, same cost / same cooldown / opposite-axis effect. Worked example: Sieren's Funeral Writ (root + DoT) → Pall Writ (Smoke + Fear-1).
- **Tier 4 = mastery skin + lore reveal + title + Warlord-specific Ascension challenge slot.** Per-Warlord template authored; W2 fills the 11 entries.
- **Anti-P2W bound:** boosters multiply only, hard-capped ×3.0 stacked. Whale ceiling ~25 wins to T4; free floor ~72. Same destination.
- **Engine handoff sketched** for W5 — `Warlord.tier_unlocks: Array[TierContent]`, plus `GameState.warlord_xp` dict, multiplier field, and tier-changed signal.
- **6 open questions surfaced for Paul** (XP-on-loss, booster cap exception for live-ops, T2 default passive availability, W10/W11 A-slot difficulty, multiplier-display style, MVP-slice tier coverage).

Doc lands at `warlord_tiers_v0.md`, ~140 lines. Hands cleanly to W2 (per-Warlord content), W3 (XP-booster economy reflection in `monetisation_map.md`), W4 (tier-ladder UI mock), W5 (engine wiring after Phase 2.6 C1 lands).

## Repo push + Gallowfell scan (Claude Code on Paul's laptop, 2026-05-02)

**Pushed to `Gonzo8285/MobileGame@main`:**
- Commit 1: `feat: Godot 4.3 project scaffold + CI workflow` — 214 files (Godot project, all 5 faction card decks as `.tres`, runtime GDScript, GitHub Actions CI).
- Commit 2: `chore: phase 2.5 lore sync — Gallowfell faction names + GDD curse mechanics + warlords v1` — 28 lore/design docs.
- B1 is now physically on GitHub (was previously authored locally only). CI workflow will fire on next push.

**Gallowfell trademark + domain scan (S4 follow-up):**
| Check | Result |
|---|---|
| USPTO (TESS) | No web-visible hits. Programmatic API blocked. **Manual visit to tmsearch.uspto.gov still owed.** |
| EUIPO eSearch | No web-visible hits. Programmatic blocked. **Manual visit to euipo.europa.eu/eSearch still owed.** |
| UKIPO | No web-visible hits. **Manual visit to trademarks.ipo.gov.uk still owed.** |
| gallowfell.com | NXDOMAIN — appears unregistered |
| gallowfell.app | NXDOMAIN — appears unregistered |
| gallowfell.io | NXDOMAIN — appears unregistered |
| gallowfell.game | NXDOMAIN — appears unregistered |

**Bottom line:** zero web footprint for "Gallowfell" — no existing game, company, or product. All 4 candidate domains appear unregistered. Programmatic-level scan is clean. The three trademark registries block bots, so the formal sign-off requires Paul to log in manually to each. **Paul-action flagged in S4** — the only remaining gate before "Gallowfell" can be locked as the canonical title.

## B2.5 — Combat scene scaffold (heartbeat 2026-05-02 14:35 UTC)

Authored under green-light from Paul ("feel free to run some processes while we have allowances").

**New files (12):**
- `game/src/data/enemy.gd` — Enemy Resource (id, name, hp, atk, armor, move_speed, base_damage_override, faction, keywords, flavour). Mirrors Card pattern.
- `game/src/data/wave.gd` + `wave_spawn_entry.gd` — Wave Resource + sub-entry pair. Wave holds `Array[WaveSpawnEntry]` of {on_turn, lane, enemy}.
- `game/src/runtime/enemy_instance.gd` — RefCounted runtime for one enemy alive on a lane (data ref + current_hp + tile + statuses + take_damage/advance/add_status helpers).
- `game/src/runtime/lane.gd` — RefCounted, owns `enemies: Array[EnemyInstance]` + reserved `friendly_units` slot for B2.6. Tile convention: 0 = base, tile_count = spawn position. `advance_all()` moves every alive enemy by its move_speed and emits `enemy_reached_base(enemy, dmg)` for any that cross 0; despawns them.
- `game/src/runtime/wave_spawner.gd` — RefCounted, holds current_wave + lanes ref. `tick(turn)` reads spawn entries for that turn and spawns into lanes. `is_complete()` = wave turn_count reached AND all lanes empty.
- `game/src/runtime/combat.gd` — Node2D orchestrator. setup() builds lanes + spawner. start() binds GameState turn signals, kicks `start_combat()`. Turn signals route to `_on_turn_started` (spawner.tick) and `_on_turn_ended` (lanes advance + win/loss check). `_finish` disconnects signals + emits `combat_ended(victory)`. `cleanup()` for safe tear-down.
- `game/scenes/combat.tscn` — placeholder scene (3 ColorRect lanes + base ColorRect + status Label HUD). Sized for 1080×1920 portrait.
- `game/data/enemies/E1–E5.tres` — 5 placeholder enemy archetypes (Cathedral Flagellant melee / Carrion Hound rusher / Bog-Lurker tank / Ash-Wraith FEAR-debuffer / Reaper-Bell siege).
- `game/data/waves/act1_combat1.tres` — 5-spawn 10-turn wave for testing.
- `game/src/runtime/combat_test.gd` — 14-assertion smoke test, three fights: (1) load act1 wave + drive 10 turns + verify spawns/damage; (2) defeat path with low-HP base + over-tuned Reaper-Bell; (3) victory path by manually killing the lone enemy and ticking past wave.turn_count.
- `game/src/main.gd` — added third `_run_dev_test` line for `combat_test.gd`.

**Bugs caught and fixed in-flight:**
- Initial `combat.gd` self-called `GameState.next_turn()` from inside `_on_turn_ended`. That signal is itself fired by `next_turn()` → infinite recursion. Removed the auto-advance; B2.7 turn engine (or the test driver) is responsible for ticking. Added `is_over` guard so a stale signal connection can't double-handle.
- Between-fights signal leak: combat1's connections to GameState.turn_started/turn_ended persisted into fight 2, where combat1's lingering 6-tile-lane enemies would advance during fight 2's 2-tile-lane ticks. Added explicit `cleanup()` method, called between fights in the test.

**Verification:** Python mirror of lane + spawner + GameState + combat orchestration. All 14 assertions pass — fight 1 ends turn 10 with base_hp=24 (E1+E2 reach base for 6 dmg, E1-lane-2 + E3 + E4 still in-flight); fight 2 ends in 2 ticks with combat_ended(false) and base_hp=0; fight 3 ends in 3 ticks with combat_ended(true) and full HP. Engine syntax cannot be tested headless in this sandbox — Paul should run `main.gd` in Godot and confirm `[combat_test] PASS` appears.

**Hand-off to next heartbeat (B2.6 — card-play loop):**
- `lane.friendly_units: Array` is the slot UnitInstance lands in; class needs authoring next.
- Drag-drop input requires the placeholder Lane visuals to gain Area2D children for hit detection. ColorRects in combat.tscn are stand-ins for that.
- Card cost spend should route through `GameState.spend_mana()` (already returns bool — false = "not enough" UX hook).

**Open Qs surfaced:**
1. tile_count default = 6. Feels right for portrait but should mock once hand UI lands (B2.6) — fewer tiles = faster fights, more = more strategic depth.
2. Enemy keywords currently exposed but unused. B2.7 status-tick will consume them (FEAR/SLOW/BLEED apply to enemies; SMOKE/DREAD apply to lanes).
3. Wave .tres uses `Array[Resource]([SubResource(...)])` syntax for `spawns`. If Godot's parser is stricter than expected and needs `Array[WaveSpawnEntry](...)` instead, swap that one literal.
