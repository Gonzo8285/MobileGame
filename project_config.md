# Project config — Gaming app

Single source of truth for project IDs, repo, and store identifiers.

## GitHub
- **Owner:** Gonzo8285
- **Repo:** MobileGame
- **URL:** https://github.com/Gonzo8285/MobileGame
- **Auth:** PAT in `secrets/github_pat.txt` (fine-grained, 90-day expiry from 2026-04-28 → expires ~2026-07-27)
- **Verified:** 2026-04-29 — PAT confirmed in GitHub web UI: Active, expires 2026-07-27, scoped to Gonzo8285/MobileGame only, Read+Write on code/actions/workflows/secrets/etc, Read on metadata. (Direct CLI verification not possible from work laptop — corporate TLS interception blocks curl/git; browser confirmation accepted in lieu.)

## Apple Developer
- Not yet enrolled. Required before first iOS build.

## Google Play Console
- Not yet enrolled. Required before first Android build.

## Engine
- **Godot 4** (decided 2026-04-29 via R5). Reasoning: pure-text scenes for Claude-driveability, MIT licence, headless CLI builds, scope fits 2D painterly grimdark. Phaser+Capacitor is the fallback.

## Working title
- **The Curse of Gallowfell** (chosen by Paul 2026-04-30, overrides heartbeat shortlist). Setting: a Monarchy gallows-town the spirits cursed. Frames all 5 factions as different reasons to march into Gallowfell. Lore in `lore_gallowfell.md`.
