# Phase 3 scheduled tasks — install-ready prompts

When the design phase wraps and Phase 3 (build) starts, these prompts spin up the parallel work tracks that produce code, assets, and CI in parallel. Each is bite-sized, stop-after-one-task, mirrored on the existing Cowork + Claude Code heartbeat patterns.

## Tasks in this folder

| File | Cadence | Runs in | Owns |
|---|---|---|---|
| `build_orchestrator.md` | every 4–6 h | Cowork | Engine code (Godot scenes, scripts, configs) |
| `asset_pipeline.md` | daily, off-peak | Cowork | Image + audio generation jobs |
| `ci_watch.md` | every 30 min during active dev | Cowork | Reads GitHub Actions logs (via Claude Code), opens "investigate" backlog items on red builds |
| `balance_pass.md` | weekly (TBA) | Cowork | Card / Warlord balance simulations |
| `store_prep.md` | TBA (near soft launch) | Cowork | ASO copy, screenshot frames, store listing assets |

(Only the first three are needed at Phase 3 kickoff. The last two get authored as we approach the relevant milestones.)

## Install order

When Paul says "go" on Phase 3:
1. **Install `build_orchestrator.md`** as a new Cowork scheduled task (every 4 h).
2. **Install `asset_pipeline.md`** as a new Cowork scheduled task (daily 02:00 local).
3. **Install `ci_watch.md`** as a new Cowork scheduled task (every 30 min — disable when not actively iterating).
4. The existing `gaming-app-heartbeat` (Cowork) and `gaming-app-git-heartbeat` (Claude Code) keep running unchanged.

## Why pre-staged
Each scheduled task in Cowork costs Paul one approval-on-first-run. Pre-authoring the prompts means he just pastes a one-liner per track when ready, rather than designing the prompt himself. Total effort to spin up Phase 3 = ~3 minutes of clicks.
