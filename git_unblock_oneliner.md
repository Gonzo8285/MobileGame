# Git unblock — one-liner for Paul to paste in Claude Code

_Authored 2026-05-22 by Controller. The previous heartbeat reported 12 uncommitted Gallowfell spec files stuck behind a Windows OneDrive lock on `.git/index.lock` + `.git/HEAD.lock` that the Linux mount couldn't clear. As of 2026-05-22 09:00 the locks are no longer visible from the Linux side — they may have already cleared, or they may re-appear when OneDrive next contends with a write. This doc gives Paul a single PowerShell command that handles both cases + a fallback ladder if the locks persist._

**Status:** copy-paste-ready. Paste into Claude Code (which runs natively on Windows, not via the Linux mount). Do NOT paste into the Cowork bash shell — Cowork can't reliably clear Windows file locks held by OneDrive's sync engine.

---

## 1. The primary one-liner

Paste this in Claude Code (PowerShell). It handles everything in one shot — clears locks if present, adds the new spec files, commits, and reports the clean working tree:

```powershell
cd "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app"; Remove-Item -Force -ErrorAction SilentlyContinue ".git\index.lock", ".git\HEAD.lock"; git add CONFLICTS_RESOLVED_2026-05-22.md GDD_v1.md bosses_chapters_4_to_8_v0.md audio_production_brief_v1.md tutorial_flow_v0.md soft_launch_playbook_v0.md git_unblock_oneliner.md; git commit -m "docs(gallowfell): round-2 design pass — GDD v1, Ch4-8 bosses, audio prod brief, tutorial flow, soft-launch playbook, conflicts resolved"; git status
```

**What it does, step by step:**

1. `cd "...\Gaming app"` — anchors the shell at the workspace root.
2. `Remove-Item -Force -ErrorAction SilentlyContinue ".git\index.lock", ".git\HEAD.lock"` — clears both lock files if they exist. The `-ErrorAction SilentlyContinue` flag means it doesn't error if the files aren't there (the typical case if OneDrive has already released).
3. `git add <list of 7 new files>` — stages the 7 new specs from this 2026-05-22 round-2 session.
4. `git commit -m "..."` — single Conventional Commits message covering all 7 files.
5. `git status` — confirms the clean working tree (post-commit) so Paul sees the success state.

**Expected output if it works:**

```
[main XXXXXXX] docs(gallowfell): round-2 design pass — GDD v1, Ch4-8 bosses, audio prod brief, tutorial flow, soft-launch playbook, conflicts resolved
 7 files changed, ~3200 insertions(+)
 create mode 100644 CONFLICTS_RESOLVED_2026-05-22.md
 create mode 100644 GDD_v1.md
 create mode 100644 bosses_chapters_4_to_8_v0.md
 create mode 100644 audio_production_brief_v1.md
 create mode 100644 tutorial_flow_v0.md
 create mode 100644 soft_launch_playbook_v0.md
 create mode 100644 git_unblock_oneliner.md
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)
```

**Then push** (manual step — separate one-liner so Paul can verify the local commit looks clean first):

```powershell
git push origin main
```

---

## 2. If the primary one-liner fails — fallback ladder

Run these IN ORDER until one works. Stop at the first success.

### 2.1 Fallback A — Close OneDrive sync, retry

OneDrive sync agent holds files open while syncing. Pause it, retry, re-enable.

```powershell
# Pause OneDrive sync (right-click systray icon → Pause for 2 hours), then re-run the primary one-liner above.
# Or programmatically:
Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 5; cd "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app"; Remove-Item -Force -ErrorAction SilentlyContinue ".git\index.lock", ".git\HEAD.lock"; git add CONFLICTS_RESOLVED_2026-05-22.md GDD_v1.md bosses_chapters_4_to_8_v0.md audio_production_brief_v1.md tutorial_flow_v0.md soft_launch_playbook_v0.md git_unblock_oneliner.md; git commit -m "docs(gallowfell): round-2 design pass — GDD v1, Ch4-8 bosses, audio prod brief, tutorial flow, soft-launch playbook, conflicts resolved"; git status; Start-Process "C:\Users\Paul McCann\AppData\Local\Microsoft\OneDrive\OneDrive.exe" -ErrorAction SilentlyContinue
```

**Why it works:** killing the OneDrive process releases all its file handles, then we restart it after the git work. The `-ErrorAction SilentlyContinue` on Start-Process handles the case where OneDrive is in a non-standard location.

### 2.2 Fallback B — Reboot, retry

If 2.1 fails, OneDrive may be in a deeper hung state (sync queue backed up). Reboot, then immediately run the primary one-liner:

1. Save work in other apps.
2. Restart Windows.
3. **Before** OneDrive's full sync kicks in (~30 sec after login), open Claude Code and paste the primary one-liner from §1.

### 2.3 Fallback C — Nuclear: reinit git (only if A + B fail)

This is destructive of git history. Only if locks really won't clear AND `git status` keeps showing locked-file errors after reboot.

**Do not use this without Paul's explicit OK** — it loses local-only branches and commits not yet pushed.

```powershell
cd "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app"
# 1. Back up the existing .git folder
Copy-Item -Recurse -Path ".git" -Destination ".git.bak"
# 2. Verify the backup
Get-ChildItem ".git.bak" | Select-Object -First 3
# 3. Re-init
Remove-Item -Recurse -Force ".git"
git init
git branch -M main
git remote add origin https://github.com/Gonzo8285/MobileGame.git
# 4. Auth — copy the PAT from secrets folder
$pat = Get-Content "secrets\github_pat.txt"
# 5. Fetch remote
git fetch origin
git reset --soft origin/main
# 6. Now run the primary commit one-liner from §1.
```

After this works, the `.git.bak` folder can be deleted (or kept for a week as paranoia).

**Why it's nuclear:** re-init throws away local-only history. The `git reset --soft origin/main` then re-aligns the index with remote, so the working tree (including our 7 new files) becomes the "uncommitted" state. The primary one-liner from §1 then commits cleanly.

### 2.4 Fallback D — Skip git entirely, hand-deliver files

Last resort if all of A, B, C fail. The 7 new files are safe in OneDrive — they're synced to Paul's other devices already. Cowork can read them. Paul can manually copy them to a clean repo clone elsewhere:

```powershell
# 1. Clone the repo somewhere fresh:
cd C:\Users\Paul McCann\Desktop
git clone https://github.com/Gonzo8285/MobileGame.git gallowfell-clean
cd gallowfell-clean
# 2. Copy the 7 new files from OneDrive workspace:
$src = "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app"
Copy-Item "$src\CONFLICTS_RESOLVED_2026-05-22.md", "$src\GDD_v1.md", "$src\bosses_chapters_4_to_8_v0.md", "$src\audio_production_brief_v1.md", "$src\tutorial_flow_v0.md", "$src\soft_launch_playbook_v0.md", "$src\git_unblock_oneliner.md" -Destination .
# 3. Commit from clean clone:
git add CONFLICTS_RESOLVED_2026-05-22.md GDD_v1.md bosses_chapters_4_to_8_v0.md audio_production_brief_v1.md tutorial_flow_v0.md soft_launch_playbook_v0.md git_unblock_oneliner.md
git commit -m "docs(gallowfell): round-2 design pass — GDD v1, Ch4-8 bosses, audio prod brief, tutorial flow, soft-launch playbook, conflicts resolved"
git push origin main
```

This bypasses the locked working tree entirely. The OneDrive workspace's broken git state stays broken until the lock releases (likely overnight), then the next git heartbeat will sort it out.

---

## 3. Why this happened — context

OneDrive's "files-on-demand" sync engine holds exclusive locks on files while syncing. When the Cowork sandbox (Linux container with the OneDrive folder bind-mounted) attempts `git add`, it sometimes races against OneDrive's write-lock on the corresponding Windows-side file, and Git creates `.git/index.lock` to serialise its own operations. If the Cowork-side process is killed mid-add (e.g. session timeout), the lock file isn't cleaned up, and Cowork can't `rm` it without OneDrive's cooperation.

This is **not a corruption** — it's a sync-race. Resolution path is always: kill OneDrive's lock by either (a) waiting for it to release, (b) restarting OneDrive, or (c) operating on the files outside the OneDrive-watched folder.

**Permanent mitigation (recommend Paul ask Claude Code to enable):** add the Gallowfell repo path to OneDrive's "Excluded folders" list so OneDrive stops watching the working tree. The .git folder can still be inside the OneDrive folder; just exclude the subdirectory. This stops the race condition.

```
Setting → OneDrive → Choose folders to sync → uncheck "Gaming app/.git"
```

After that, only the working-tree files sync (which is what we actually want) — the git internals stop racing with sync.

---

## 4. Caveat — the 266 mass-modified files

As of 2026-05-22 09:00, `git status` shows 266 files modified beyond the 7 new ones. These are not real edits — they appear to be **line-ending churn** (CRLF on Windows vs LF on Linux mount) introduced by cross-platform file access. Sample diff shows `^M` characters absent on the Linux side that exist on the Windows side.

**Do not include these in the commit.** The primary one-liner in §1 only adds the 7 named new files, not `git add .` — so this is safe.

**Recommend Paul (separately, not in this commit):** add a `.gitattributes` file that locks line endings to LF for `.md` and `.tres` files:

```
*.md  text eol=lf
*.tres text eol=lf
*.gd  text eol=lf
*.tscn text eol=lf
```

Plus configure git globally:

```powershell
git config --global core.autocrlf false
git config --global core.eol lf
```

This permanently resolves the cross-platform churn. **Defer to a separate commit; do not bundle with this design-doc commit.**

---

## 5. Quick reference — copy-paste targets

**Primary one-liner** (§1):

```powershell
cd "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app"; Remove-Item -Force -ErrorAction SilentlyContinue ".git\index.lock", ".git\HEAD.lock"; git add CONFLICTS_RESOLVED_2026-05-22.md GDD_v1.md bosses_chapters_4_to_8_v0.md audio_production_brief_v1.md tutorial_flow_v0.md soft_launch_playbook_v0.md git_unblock_oneliner.md; git commit -m "docs(gallowfell): round-2 design pass — GDD v1, Ch4-8 bosses, audio prod brief, tutorial flow, soft-launch playbook, conflicts resolved"; git status
```

**Push** (separate, after primary succeeds):

```powershell
git push origin main
```

**OneDrive-kill version** (§2.1):

```powershell
Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 5; cd "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app"; Remove-Item -Force -ErrorAction SilentlyContinue ".git\index.lock", ".git\HEAD.lock"; git add CONFLICTS_RESOLVED_2026-05-22.md GDD_v1.md bosses_chapters_4_to_8_v0.md audio_production_brief_v1.md tutorial_flow_v0.md soft_launch_playbook_v0.md git_unblock_oneliner.md; git commit -m "docs(gallowfell): round-2 design pass — GDD v1, Ch4-8 bosses, audio prod brief, tutorial flow, soft-launch playbook, conflicts resolved"; git status; Start-Process "C:\Users\Paul McCann\AppData\Local\Microsoft\OneDrive\OneDrive.exe" -ErrorAction SilentlyContinue
```

---

## 6. Cross-references

- HANDOVER.md §2.4 — repo URL + PAT location.
- HANDOVER.md §3 — split-brain workflow (Claude Code is the git executor, not Cowork).
- `project_gaming_app_network.md` (memory) — full split-brain context.
- `feedback_act_then_report.md` (memory) — bias for action; this is a reversible operation.

— Controller, 2026-05-22
