#!/usr/bin/env python3
"""
art_inventory.py — Diff Gallowfell art_specs against art_iterations.

Walks every art_specs/<faction>/<card_id>_<name>.md file, looks for a matching
generated PNG anywhere under art_iterations/, and writes art_iterations/_owed.md
listing missing renders by faction with their spec file path.

Usage (from anywhere):
    python3 art_inventory.py
or via heartbeat one-liner:
    python3 "{PROJECT}\\scripts\\art_inventory.py"

Output:
    {PROJECT}/art_iterations/_owed.md         — markdown list of cards still owed
    {PROJECT}/art_iterations/_inventory.json  — machine-readable inventory

Exit codes:
    0 — ran cleanly, report written
    1 — missing art_specs or art_iterations folder
    2 — unexpected error

Authored 2026-05-13 by Controller. Heartbeat-safe (no network, no GPU).
"""

from __future__ import annotations

import json
import os
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

# ----- locate project folder ---------------------------------------------------

DEFAULT_PROJECT = Path(
    r"C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app"
)
# Bash mount alias used by Cowork sandbox:
SANDBOX_PROJECT = Path("/sessions/adoring-busy-lamport/mnt/Projects/Gaming app")


def find_project_root() -> Path:
    for candidate in (DEFAULT_PROJECT, SANDBOX_PROJECT, Path.cwd().parent, Path.cwd()):
        if (candidate / "art_specs").is_dir() and (candidate / "art_iterations").is_dir():
            return candidate
    print(
        "ERROR: could not locate the Gaming app project root. "
        "Pass it on argv[1] if running from an unusual location.",
        file=sys.stderr,
    )
    sys.exit(1)


# ----- spec discovery ----------------------------------------------------------

SPEC_FILENAME_RE = re.compile(r"^(?P<id>[a-z]\d+)_(?P<slug>[a-z0-9_]+)\.md$", re.IGNORECASE)


def discover_specs(specs_root: Path) -> list[dict]:
    """Walk art_specs/<faction>/ and return a list of card specs found."""
    specs: list[dict] = []
    for faction_dir in sorted(p for p in specs_root.iterdir() if p.is_dir()):
        faction = faction_dir.name
        for md in sorted(faction_dir.glob("*.md")):
            name = md.name
            if name.startswith("_"):
                continue  # _template.md etc.
            m = SPEC_FILENAME_RE.match(name)
            if not m:
                # Not a card spec — skip silently (e.g. notes)
                continue
            specs.append({
                "card_id": m.group("id").upper(),
                "slug": m.group("slug"),
                "faction": faction,
                "spec_path": str(md.relative_to(specs_root.parent)).replace("\\", "/"),
            })
    return specs


# ----- iteration discovery -----------------------------------------------------

IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".webp"}


def discover_iterations(iters_root: Path) -> dict[str, list[str]]:
    """Walk art_iterations/ and group image filenames by card_id heuristic.

    Heuristic: filename containing a card_id pattern (e.g. p1, m10, w3, c25)
    counts as a generated render for that card. Anything in _smoke/ or _anchors/
    counts as a development render, not a production one — bucketed separately.
    """
    by_id: dict[str, list[str]] = {}
    for path in iters_root.rglob("*"):
        if not path.is_file() or path.suffix.lower() not in IMAGE_EXTS:
            continue
        rel = str(path.relative_to(iters_root.parent)).replace("\\", "/")
        if "/_smoke/" in rel.replace("\\", "/") or "/_anchors/" in rel.replace("\\", "/"):
            continue  # dev renders, not production
        # find a card_id token in the filename
        for token in re.findall(r"[a-z]\d+", path.stem.lower()):
            if len(token) <= 4:
                by_id.setdefault(token.upper(), []).append(rel)
                break
    return by_id


# ----- report writers ----------------------------------------------------------

def write_owed_md(specs: list[dict], by_id: dict[str, list[str]], out_path: Path) -> dict:
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    owed: dict[str, list[dict]] = {}
    done: list[dict] = []
    for spec in specs:
        if by_id.get(spec["card_id"]):
            done.append({**spec, "renders": by_id[spec["card_id"]]})
        else:
            owed.setdefault(spec["faction"], []).append(spec)

    total = len(specs)
    n_done = len(done)
    n_owed = total - n_done

    lines: list[str] = []
    lines.append(f"# Gallowfell art — owed inventory")
    lines.append("")
    lines.append(f"_Generated {now} by `scripts/art_inventory.py`. Do not edit by hand — re-run the script._")
    lines.append("")
    lines.append(f"**Total specs:** {total}  ·  **Generated:** {n_done}  ·  **Owed:** {n_owed}")
    lines.append("")
    if not owed:
        lines.append("All card specs have at least one matching iteration. Nothing owed.")
    else:
        lines.append("## Owed by faction")
        lines.append("")
        for faction, items in sorted(owed.items()):
            lines.append(f"### {faction} ({len(items)})")
            lines.append("")
            for it in items:
                lines.append(f"- `{it['card_id']}` — {it['slug'].replace('_', ' ')} — `{it['spec_path']}`")
            lines.append("")

    lines.append("## Generated (last seen)")
    lines.append("")
    if done:
        lines.append("<details><summary>Show full list</summary>\n")
        for d in sorted(done, key=lambda x: x["card_id"]):
            renders = ", ".join(f"`{r}`" for r in d["renders"][:3])
            extra = "" if len(d["renders"]) <= 3 else f" (+{len(d['renders']) - 3} more)"
            lines.append(f"- `{d['card_id']}` — {d['slug'].replace('_', ' ')} — {renders}{extra}")
        lines.append("\n</details>")
    else:
        lines.append("_(None yet — see B3.0a smoke test in `backlog.md` and `IMAGE-GEN-SHOTLIST.md` §3.)_")

    out_path.write_text("\n".join(lines), encoding="utf-8")
    return {
        "total": total,
        "done": n_done,
        "owed": n_owed,
        "owed_by_faction": {f: len(v) for f, v in owed.items()},
        "generated_at": now,
    }


def write_json_inventory(summary: dict, out_path: Path) -> None:
    out_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")


# ----- main --------------------------------------------------------------------

def main() -> int:
    try:
        if len(sys.argv) > 1:
            project = Path(sys.argv[1])
            if not (project / "art_specs").is_dir():
                print(f"ERROR: {project} is not a Gallowfell project root.", file=sys.stderr)
                return 1
        else:
            project = find_project_root()

        specs_root = project / "art_specs"
        iters_root = project / "art_iterations"
        if not specs_root.is_dir() or not iters_root.is_dir():
            print("ERROR: art_specs/ or art_iterations/ missing.", file=sys.stderr)
            return 1

        specs = discover_specs(specs_root)
        by_id = discover_iterations(iters_root)

        owed_md = iters_root / "_owed.md"
        inventory_json = iters_root / "_inventory.json"

        summary = write_owed_md(specs, by_id, owed_md)
        write_json_inventory(summary, inventory_json)

        print(
            f"art_inventory: total={summary['total']} done={summary['done']} owed={summary['owed']} "
            f"→ {owed_md.relative_to(project)}"
        )
        return 0
    except Exception as exc:  # noqa: BLE001
        print(f"ERROR: art_inventory failed: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
