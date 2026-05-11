# HANDOVER — The Curse of Gallowfell

Single-source handover for any Claude project (or human) picking this up cold. Generated 2026-05-02 by Cowork Claude. Everything below uses **absolute paths** so it can be copy-pasted into a fresh shell or chat window without context.

---

## 1. What this build is

**The Curse of Gallowfell** — a grimdark roguelite tower-defence deckbuilder for mobile (iOS + Android). Player picks one of 10 Warlords, builds a 12-card deck of units/spells/traps, pushes through a 10-minute branching dungeon of TD-lane fights inside Gallowfell, the Monarchy's cursed gallows-town. PvE only, PEGI 12, free-to-play with microtransactions + battle pass.

**Owner:** Paul McCann (`Paul.mccann@rtkeedwellgroup.co.uk`, GitHub: `Gonzo8285`).
**Engine:** Godot 4.x (decided 2026-04-29).
**Phase:** Phase 3 — Build, in flight (B1 done, B2 partially done).

---

## 2. Paths a new Claude needs to know

### 2.1 Workspace folder (the canonical project files — synced via OneDrive)

```
C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app
```

This is the source of truth. Every design doc, the GDD, lore, faction bible, Warlord roster, card data, engine scaffold, and the `.docx` pitch all live here. Also where the git repo's working tree is — `.git\` is inside this folder.

### 2.2 Memory folder (Cowork's persistent memory for this space)

```
C:\Users\Paul McCann\AppData\Roaming\Claude\local-agent-mode-sessions\343244bc-cab4-4b88-b9f9-6573e14e08a3\4d6195cf-cece-44eb-944e-83b0f2b8cc83\spaces\1408b62d-ab09-496c-b423-2eab40f6286e\memory
```

Index = `MEMORY.md` in that folder. Each memory entry has its own `.md` file. **Read `MEMORY.md` first**, then any referenced file. Memory files used by this project:

- `MEMORY.md` — the index
- `user_paul.md` — Paul's working style, register, copy-paste preferences
- `project_gaming_app.md` — high-level project framing + Phase 3 scheduling plan
- `project_gaming_app_refs.md` — reference games, IP constraints, monetisation pillars, title, gameplay shape, deck-depth scope expansion, Warlord tier system, canonical faction names
- `project_gaming_app_network.md` — split-brain GitHub workflow
- `project_gaming_app_hardware.md` — Paul's local GPU (RTX 2050, ~4GB VRAM) — affects AI-art pipeline decisions
- `project_gaming_app_aesthetic.md` — locked visual style (MTG-painterly + Elden Ring + Phyrexian body-horror; death-rebirth through-line; Persist mechanic priority)

### 2.3 Scratch / outputs folder (Cowork session-local, ephemeral)

```
C:\Users\Paul McCann\AppData\Roaming\Claude\local-agent-mode-sessions\343244bc-cab4-4b88-b9f9-6573e14e08a3\4d6195cf-cece-44eb-944e-83b0f2b8cc83\local_96bb105c-a158-4eba-a241-8f2b6dade67f\outputs
```

Cleared between sessions. Useful only mid-session — the .docx build script lives here in the current session: `build_pitch_doc.js`. Anything that should persist must be written to the workspace folder.

### 2.4 GitHub repo

- **URL:** https://github.com/Gonzo8285/MobileGame
- **Branch:** `main`
- **Auth:** Fine-grained PAT stored at `C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\secrets\github_pat.txt` (expires ~2026-07-27, scoped to this single repo).
- **Routine git ops** are performed by Claude Code on Paul's laptop (via the GitHub extension), NOT by Cowork's sandbox (which is allowlist-blocked from github.com).

---

## 3. The split-brain workflow (critical to understand before doing any work)

Two Claude instances run in parallel and never call each other directly:

| Instance | Where it runs | What it does | What it cannot do |
|---|---|---|---|
| **Cowork Claude** | Desktop app, sandboxed Linux env | Authors design docs, code, lore, configs — writes them into the workspace folder | Cannot reach GitHub (sandbox proxy blocks github.com); cannot run Godot |
| **Claude Code** | Paul's laptop, native binary | Reads the workspace folder, runs `git add/commit/push` to GitHub, also runs Godot/build tools if asked | Doesn't author design content — only ships what Cowork wrote |

Bridge between them: **OneDrive auto-sync**. Cowork writes → OneDrive syncs to laptop → Claude Code picks up changes on its next heartbeat (every 4h) → commits and pushes. No manual paste needed once both heartbeats are running.

Full detail: `project_gaming_app_network.md` in memory folder.

---

## 4. Scheduled tasks running right now

### 4.1 Cowork side

- **`gaming-app-heartbeat`** — cron `15 */5 * * *` (every 5 hours at :15 past). Picks the top unchecked item from `backlog.md`, does one bite-sized chunk, appends to `research_notes.md`, ticks the item, stops.

### 4.2 Claude Code side (on Paul's laptop)

- **`gaming-app-git-heartbeat`** — cron `0 */4 * * *` (every 4 hours). Reads the workspace folder, commits any pending changes to `Gonzo8285/MobileGame`, pushes. Install prompt at `C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\claude_code_heartbeat_prompt.md`.

### 4.3 Pre-staged for Phase 3 (not yet installed)

- `phase3_scheduled_tasks\build_orchestrator.md` — engine code heartbeat (Cowork)
- `phase3_scheduled_tasks\asset_pipeline.md` — image/audio gen (Cowork, daily)
- `phase3_scheduled_tasks\ci_watch.md` — GitHub Actions health (Cowork)

To spin them up: each file contains an "install one-liner" for Cowork.

---

## 5. Canonical decisions (so you don't re-derive them)

- **Working title:** *The Curse of Gallowfell* (locked by Paul 2026-04-30).
- **Genre:** Roguelite TD deckbuilder, ~10-min runs, Slay-the-Spire branching map, 60-90s TD lane fights.
- **Tone:** Grim with gallows humour.
- **Art:** Painterly 2D (MTG-style oil + Elden Ring grandeur + Phyrexian body-horror); palette ash-grey + candle-gold + blood-red.
- **Audio:** Orchestral strings + dark choir + industrial percussion. Each faction has a leitmotif.
- **Multiplayer:** PvE only for v1. Async leaderboards.
- **Rating:** PEGI 12 / Teen 13+.
- **Canonical faction names (Track A, locked 2026-04-30):**
  1. **Iron Penitents** — aggro/sacrifice — Cathedral Ruins
  2. **Ash-Mourners** — control/debuff — Ash Quarter
  3. **Coven of the Black Mire** — swarm/poison — Black Mire
  4. **The Last Legion** — tempo/formation — Forgotten Parade
  5. **Skinward Pact** — summoner/monstrous — Cinderwood
  (Boss biome: Gallows Hill.) Any leftover Track-B names — Withered Court / Hollow Pact / Ferrum Host / Sable Wilds — are obsolete placeholders being globally renamed by heartbeat.
- **10 Warlords:** 5 free at unlock (one per faction, spans all 5 playstyles) + 5 paid (grind-or-skip via Marrow Shards or Souls/gems). Never strictly stronger — sideways power only.
- **Card pool target:** ~35-40 cards per faction × 5 = 175-200 launch cards. 3 sub-archetypes per faction (~10-12 cards each), synergy anchored on 2-3-4-cost spine.
- **Warlord tiers:** Tier 1 base → Tier 2 variant passive (~10-15 wins) → Tier 3 signature alt-fire (~30 wins) → Tier 4 mastery (~60-80 wins). Sideways power only.
- **Monetisation pillars:** microtxn, bundles, time locks, resource locks, short bursts. Battle pass £4.99/season. Subscription "Ascendant Pact" £4.99/mo. Three currencies: Gold (in-run only), Bones (persistent soft), Souls (premium).
- **Ad stack:** AppLovin MAX primary + AdMob demand source.

---

## 6. Tooling stack

| Layer | Tool | Notes |
|---|---|---|
| Engine | **Godot 4.x** | MIT licence, headless CLI export, GDScript |
| Source control | **GitHub** (`Gonzo8285/MobileGame`) | Fine-grained PAT in workspace `secrets/` |
| CI/CD | **GitHub Actions** (Linux/Android) + **Codemagic** (iOS signing, 500 min/mo free) | Triggered by pushes to `main` |
| Ad mediation | **AppLovin MAX** primary, **AdMob** as demand source | Godot SDKs |
| Analytics | **Firebase Analytics** + **Crashlytics** + **GameAnalytics** | All free tier |
| Image gen | **Stable Diffusion** (cloud — Paul's RTX 2050 is 4GB, too small for SDXL/Flux local) | Decision in `project_gaming_app_hardware.md` |
| Audio gen | **Suno** or **Udio** paid (~$10/mo, commercial rights) | Per faction leitmotif |
| SFX | **Sonniss GDC bundles** (CC0) + **Freesound** (filter to CC0/CC-BY) | Free |
| Fonts | **Google Fonts** — Cinzel (display) + IM Fell English (body) + Cormorant SC (UI) | All OFL |
| Store accounts | **Apple Developer** ($99/yr) + **Google Play Console** ($25 one-off) | Not yet enrolled — Paul-only step before iOS/Android builds |

---

## 7. Phase status

- ✅ **Phase 0** — Infra (PAT, repo bootstrap)
- ✅ **Phase 1** — Research R1–R15 (genres, mechanics, engines, monetisation, retention, stores, ASO, soft launch, CI, tools)
- ✅ **Phase 2** — Design G1–G9 (concept, GDD, names, factions, cards v0, monetisation map, Warlord roster v0)
- ✅ **Phase 2.5** — Gallowfell lore reconciliation S1–S4
- ⏳ **Phase 2.6** — Deck depth expansion (~200 cards, 3 archetypes/faction) — in progress, Iron Penitents pool authored to P40, others queued
- ⏳ **Phase 2.7** — Warlord tier system (XP curve, variant passives, alt-fires, mastery)
- ⏳ **Phase 2.8** — Lore consistency rename (Track-B → Track-A, then re-export pitch .docx)
- ⏳ **Phase 3** — Build: B1 (engine skeleton) ✅, B2 (core-loop prototype) in flight, B3 (art pass), B4 (monetisation SDK), B5 (internal test), B6 (Play soft launch), B7 (TestFlight), B8 (KPI tuning), B9 (global launch)

Live backlog: `C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\backlog.md`
Live findings log: `C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\research_notes.md`

---

## 8. File map — what each file is for

(Read these in this order if you're bootstrapping cold.)

### Tier 1 — read first (in order)
1. `HANDOVER.md` (this file)
2. `project_config.md` — single source of truth for repo/auth/engine/title
3. `lore_gallowfell.md` — setting, premise, biome map, faction motivations
4. `gdd_v0.md` — 1-page Game Design Doc (signed off)
5. `faction_bible.md` — the 5 factions with vibe/visual/motif/mechanics/flagship
6. `warlords_v0.md` — 10 Warlord roster (5 free + 5 paid)
7. `cards_v0.md` — 30-card starter pool with full stats
8. `monetisation_map.md` — every spend surface, mapped to mechanic + currency
9. `backlog.md` — what's done, what's next, all phases
10. `research_notes.md` — heartbeat append-log of decisions + findings

### Tier 2 — read if you need them
- `archetypes_v0.md` — 3 sub-archetypes per faction (deck-depth plan)
- `phase1_brief.md` — 1-page condensed research brief
- `g5_names.md` — name shortlist analysis (historical; title now locked)
- `docs/CONTRIBUTING.md` — split-brain workflow rules
- `claude_code_heartbeat_prompt.md` — install prompt for the laptop-side git heartbeat
- `phase3_scheduled_tasks/*.md` — install prompts for the parallel Phase 3 tracks

### Tier 3 — engine code (Phase 3 in-progress)
- `game/scenes/main.tscn` — main scene scaffold
- `game/icon.svg` — placeholder icon
- `game/src/data/card.gd` — Card Resource class + GFEnums namespace
- `game/data/cards/*.tres` — card data files (P1–P9 Penitents, M1–M11 Mourners, C2–C10 Coven; iron_penitents/P10–P40 extended pool)
- `.github/workflows/ci.yml` — GitHub Actions Godot build workflow
- `.gitignore` — gitignore (covers `secrets/`, engine artefacts, build outputs)

### Public-facing
- `The Curse of Gallowfell - Pitch.docx` — pitch & design brief (~14 pages, shareable)
- `gallowfell_preview.docx` — earlier preview doc (may be redundant; check date)
- `README.md` — repo README

### Secrets (gitignored — never commit)
- `secrets/github_pat.txt` — the PAT
- `secrets/README.md` — secrets folder rules

---

## 9. Backup commands — PowerShell, copy-paste-ready

All commands assume a backup destination of `D:\Backups\Gallowfell` — change the destination to whatever drive/path you want.

### 9.1 Full backup of the project folder (mirror, with timestamps preserved)

```powershell
& robocopy "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app" "D:\Backups\Gallowfell\Gaming app" /MIR /COPY:DAT /R:2 /W:5 /XJ /LOG:"D:\Backups\Gallowfell\robocopy.log"
```

Flags: `/MIR` mirrors the tree, `/COPY:DAT` keeps data + attrs + timestamps, `/R:2 /W:5` retries twice with 5s waits, `/XJ` skips junction points, `/LOG` writes a log. Robocopy returns exit code 1 on success-with-copies — that's normal.

### 9.2 Full backup INCLUDING memory folder (recommended — memory has canonical decisions)

```powershell
& robocopy "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app" "D:\Backups\Gallowfell\Gaming app" /MIR /COPY:DAT /R:2 /W:5 /XJ
& robocopy "C:\Users\Paul McCann\AppData\Roaming\Claude\local-agent-mode-sessions\343244bc-cab4-4b88-b9f9-6573e14e08a3\4d6195cf-cece-44eb-944e-83b0f2b8cc83\spaces\1408b62d-ab09-496c-b423-2eab40f6286e\memory" "D:\Backups\Gallowfell\memory" /MIR /COPY:DAT /R:2 /W:5 /XJ
```

### 9.3 Zip-and-go (one timestamped archive of everything)

```powershell
$stamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$dst   = "D:\Backups\Gallowfell\gallowfell_$stamp.zip"
$src1  = "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app"
$src2  = "C:\Users\Paul McCann\AppData\Roaming\Claude\local-agent-mode-sessions\343244bc-cab4-4b88-b9f9-6573e14e08a3\4d6195cf-cece-44eb-944e-83b0f2b8cc83\spaces\1408b62d-ab09-496c-b423-2eab40f6286e\memory"
Compress-Archive -Path $src1, $src2 -DestinationPath $dst -CompressionLevel Optimal
Write-Host "Wrote $dst"
```

### 9.4 Verify the latest commit is in GitHub (sanity check via browser, not CLI — corp TLS blocks `gh`)

Open this URL in a browser to confirm the most recent commit landed:

```
https://github.com/Gonzo8285/MobileGame/commits/main
```

### 9.5 What to leave OUT of a public/shared backup

Before sharing a backup with anyone outside Paul's machine, delete or exclude:

- `secrets\` (contains the GitHub PAT — sensitive)
- `.git\objects\` (large, recoverable from the GitHub remote anyway)

Robocopy version of the public-safe backup:

```powershell
& robocopy "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app" "D:\Backups\Gallowfell-public\Gaming app" /MIR /COPY:DAT /R:2 /W:5 /XJ /XD "secrets" ".git"
```

---

## 10. Onboarding checklist for a fresh Claude project

Drop a new Claude into this project? Have it run through this in order:

1. Read `HANDOVER.md` (this file).
2. Read `C:\Users\Paul McCann\AppData\Roaming\Claude\local-agent-mode-sessions\343244bc-cab4-4b88-b9f9-6573e14e08a3\4d6195cf-cece-44eb-944e-83b0f2b8cc83\spaces\1408b62d-ab09-496c-b423-2eab40f6286e\memory\MEMORY.md` and follow its index — at minimum read `user_paul.md`, `project_gaming_app_refs.md`, `project_gaming_app_network.md`, `project_gaming_app_aesthetic.md`.
3. Read `C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\project_config.md`.
4. Read `C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\backlog.md` to see the live work tracker.
5. Read `C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\lore_gallowfell.md` + `faction_bible.md` + `warlords_v0.md` + `cards_v0.md` for game canon.
6. Read `C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\docs\CONTRIBUTING.md` for the workflow rules.

After step 6 you should have the full mental model. Default behaviour: act on the backlog, not on Paul's calendar — bite-sized chunks per heartbeat, always absolute paths, never push to GitHub directly from Cowork.

---

_Generated by Cowork Claude on 2026-05-02. Refresh this file whenever a phase boundary moves or a canonical decision changes — keep it the one place that's always true._
