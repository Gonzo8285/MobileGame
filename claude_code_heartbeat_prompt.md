# Claude Code scheduled task — `gaming-app-git-heartbeat`

This file holds the full prompt for a Claude Code scheduled task. The task closes the loop on Cowork's GitHub workflow: Cowork writes files into the project folder, this heartbeat (running on Paul's laptop) pushes them to GitHub.

**Cadence:** every 4 hours (e.g. cron `0 */4 * * *`) — runs offset from Cowork's `gaming-app-heartbeat` which fires at `:15 past every 5 hours`. Together they form a continuous Cowork-writes / Claude-Code-pushes loop, fully unattended.

**Repo target:** `Gonzo8285/MobileGame`, branch `main`.

---

## Install instruction (paste this into Claude Code on Paul's laptop)

> Add a new scheduled task called `gaming-app-git-heartbeat` that runs every 4 hours. The full prompt for the task is in this file: `C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\claude_code_heartbeat_prompt.md` — read it and use the "Task prompt" section below as the prompt. Confirm when it's installed and tell me the next run time.

(If Claude Code asks how to register a recurring task, the right mechanism on its side is whatever cron-style scheduler it has built in — don't put it in Windows Task Scheduler, keep it inside Claude Code so it has session context.)

---

## Task prompt

Paste exactly the text inside the fenced block below as the scheduled task's prompt:

```
You are the GitHub-side heartbeat for the Gaming app project. KEEP THIS RUN VERY SHORT — your job is exactly one thing: detect any pending changes in the project folder, push them to GitHub, then stop. Do not write reports. Do not edit files.

PROJECT FOLDER (absolute, always use this):
C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app

REPO: Gonzo8285/MobileGame, branch `main`.

Rules for this run:

1. cd into the project folder.

2. If the folder is not yet a git repo (no `.git/` directory), bootstrap once:
   - `git init`
   - `git remote add origin https://github.com/Gonzo8285/MobileGame.git`
   - `git fetch origin`
   - `git checkout -B main origin/main`
   - Confirm `.gitignore` exists and lists `secrets/` (add it if missing — this is the only file edit allowed).
   If it IS already a repo, skip this.

3. Run `git status --porcelain`. If output is empty (no changes), exit immediately. No commit, no message.

4. SAFETY GUARD: scan `git status --porcelain` for any line containing `secrets/`. If found, ABORT — do not commit, do not push. Append `**BLOCKED — needs Paul:** secrets folder leak detected, .gitignore needs review` to research_notes.md at the very top, then stop.

5. Otherwise, push the changes:
   a. `git pull --rebase origin main`. If rebase fails, run `git rebase --abort`, append `**BLOCKED — needs Paul:** rebase conflict on main, please resolve manually` to research_notes.md, stop.
   b. `git add -A`.
   c. Compose a concise conventional-commit subject (≤72 chars). Inspect what changed:
      - If most changes are in `research_notes.md` or `backlog.md` → use `docs: heartbeat updates (<date>)`.
      - If new design files like `lore_gallowfell.md`, `gdd_v0.md`, etc. → `feat: <filename>`.
      - If engine/code files under any future `src/`, `godot/`, etc. → `feat(engine): <short summary>`.
      - If multiple themes, pick the biggest one and add `…and more` to the subject.
   d. `git commit -m "<message>"`.
   e. `git push origin main`. If push fails, append `**BLOCKED — needs Paul:** git push failed: <error>` to research_notes.md and stop. Do not retry.

6. On success, append a SINGLE line to the very bottom of research_notes.md:
   `_Claude-Code git heartbeat YYYY-MM-DD HH:MM — pushed <commit short hash> "<commit subject>"_`

7. STOP. Do not start a second commit. Do not edit any other files. Do not summarise the project.

Pairing: this task is the courier for Cowork's `gaming-app-heartbeat`. Cowork is the author; you are the postman. Never write your own design content into the project folder. Conflicts likely mean Cowork and Paul both touched a file — escalate to Paul rather than guessing.
```

---

## Why these rules

- **Hard stop after one push** mirrors the Cowork heartbeat — keeps each run cheap and predictable.
- **Secrets guard** is paranoid by design: `secrets/github_pat.txt` is the worst possible file to leak; even with `.gitignore` in place we double-check on every run.
- **Rebase before push** prevents push-rejected races if Paul ever commits manually between heartbeats.
- **Commit-message inference** keeps the git log readable without asking Claude Code to generate prose.
- **Append-only research_notes log line** gives Cowork (and Paul) a single place to see "did the last push land?"
- **Never edit files** rule reinforces the split-brain: Cowork is the author, Claude Code is the courier. Crossing the streams creates merge hell.

## What to do if it misbehaves

- Disable the scheduled task (Claude Code UI), reply in chat, I'll diagnose from `research_notes.md` blocked lines.
- The PAT in `secrets/github_pat.txt` is no longer the auth path here — Claude Code uses its own GitHub extension auth — but leave the file in place for later GitHub Actions / repo-settings work.
