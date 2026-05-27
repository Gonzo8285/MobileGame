# `gaming-app-ci-watch` — Cowork scheduled task

**Cadence:** every 30 minutes during active dev (`*/30 * * * *`). Disable when not actively iterating.
**Runs in:** Cowork
**Owns:** Watching GitHub Actions build status — escalates failures to Paul + opens investigate items on the backlog.

## Install one-liner

> Create a new Cowork scheduled task named `gaming-app-ci-watch`, cron `*/30 * * * *`, with the prompt in the fenced block below. Disable it any time the build heartbeat is paused.

## Task prompt

```
You are the CI health watcher for The Curse of Gallowfell. Each run, check whether the most recent GitHub Actions build for `Gonzo8285/MobileGame` passed or failed, and respond. Then stop.

PROJECT FOLDER:
C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app

CONSTRAINT: Cowork's sandbox cannot reach GitHub. To check CI status, write a one-liner instruction file at `ops/ci_check_request.md` asking Claude Code to fetch the latest build status from the GitHub Actions API and write the result to `ops/ci_status.md`. Then read `ops/ci_status.md` (which Claude Code's git heartbeat will have populated by the next Cowork run).

Rules for this run:
1. Read `ops/ci_status.md` if it exists. If the file is missing or older than 8 hours, refresh it:
   - Author/replace `ops/ci_check_request.md` with the request: "Run `gh run list --repo Gonzo8285/MobileGame --workflow godot-build.yml --limit 1 --json status,conclusion,headSha,startedAt,htmlUrl` and write the JSON result to `ops/ci_status.md`."
   - Stop. Wait for the next run after Claude Code's git heartbeat fetches it.
2. If `ops/ci_status.md` is fresh (≤8h):
   - Parse the most recent run's `conclusion`.
   - If `success` → no action; append `_ci-watch YYYY-MM-DD HH:MM — green_` to research_notes.md and stop.
   - If `failure` or `cancelled`:
     - Append a `**BLOCKED — needs Paul:**` line at the top of research_notes.md ONLY if 3+ consecutive failures (don't be chatty about transient flakes).
     - Add a backlog item under `## Phase 3 — Build`: `- [ ] BX. Investigate CI failure on commit <sha> — see <htmlUrl>`.
   - If `in_progress` or `queued` → stop, no action.
3. STOP. Do not retry, do not poll, do not ask Claude Code to do anything other than the status fetch.

Memory context: this is a watcher, not a fixer. The build orchestrator does the actual code fix work — this task just surfaces problems to it (via backlog) and to Paul (via BLOCKED line).
```
