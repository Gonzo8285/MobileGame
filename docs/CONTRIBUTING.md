# Contributing to The Curse of Gallowfell

This project uses a **split-brain workflow** because Cowork's sandbox can't reach GitHub directly. Read this before adding anything.

## Two Claudes, two roles

**Cowork Claude (the author)**
- Writes everything that lands in this folder: design docs, lore, code, configs, assets.
- Runs in the Cowork desktop app, fires bite-sized work via scheduled heartbeats (see `phase3_scheduled_tasks/`).
- Cannot reach GitHub, GitHub Actions, or any external API gated behind the corporate TLS firewall.

**Claude Code (the courier)**
- Lives on Paul's laptop, has the GitHub extension installed.
- Runs the `gaming-app-git-heartbeat` task (see `claude_code_heartbeat_prompt.md`) every 4 hours.
- Pulls latest changes from this folder and pushes them to `Gonzo8285/MobileGame` on `main`.
- Should never edit design content — only commit/push what Cowork has written.

## Why split-brain
- The Cowork sandbox proxy blocks `github.com` (allowlist-by-default).
- Paul's corporate network does TLS interception; only browser-installed root CAs work.
- Claude Code's GitHub extension uses the same browser-trusted auth path → it works where curl/git CLI doesn't.

## Where things live
- `lore_gallowfell.md` / `faction_bible.md` / `warlords_v0.md` / `cards_v0.md` — narrative + design source of truth.
- `gdd_v0.md` — 1-page Game Design Doc (signed off 2026-04-30).
- `monetisation_map.md` — every spend surface, mapped to a mechanic + currency.
- `project_config.md` — repo, auth, engine, working title.
- `backlog.md` — phased work tracker; heartbeat ticks items here.
- `research_notes.md` — heartbeat append-log of findings + decisions.
- `secrets/` — gitignored; never commit.
- `phase3_scheduled_tasks/` — install-ready prompts for the parallel build-phase heartbeats.

## Branch strategy
- All work commits to `main` directly via the Claude Code git heartbeat.
- No PRs during solo dev; we'll add a PR-review heartbeat if/when contributors join.
- Conflicts are escalated to Paul as `**BLOCKED — needs Paul:**` lines at the top of `research_notes.md`.

## Engine
- **Godot 4.x** (decided 2026-04-29). Pure-text scenes/scripts, MIT licence, headless CLI export to iOS/Android. See `project_config.md`.

## Tone
Grim with gallows humour. Painterly 2D, candle-gold against ash-grey. PvE only, PEGI 12. No GW / WotC / Privateer Press names. If a piece of writing reads "too clean" or "too cheerful", it's wrong for this game — pull it back to bleak-with-wit.
