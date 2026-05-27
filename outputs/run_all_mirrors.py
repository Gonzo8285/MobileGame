#!/usr/bin/env python3
"""
Unified mirror test runner — Phase 2.16 Gallowfell engine verification.

Runs every Python mirror in `outputs/` and reports a single PASS/FAIL summary
with per-mirror status. Each mirror exits 0 on PASS, non-zero on FAIL.

Mirrors covered (2026-05-27):
  aura_mirror.py — AURA.E1 W42 outbound aura, F1-F6 scenes
  l41_mirror.py  — L41.E1 self-aura, G1-G4 scenes
  m41_mirror.py  — M41.E1 cost-discount state machine, S1-S7 scenes
  w41_mirror.py  — W41.E1 Wolf-Token draw trigger, J1-J8 scenes
  w4_mirror.py   — W4.E1 dynamic outbound aura, H1-H5 scenes

Usage:  python3 outputs/run_all_mirrors.py
Exit code: 0 if every mirror passes, 1 if ANY mirror fails.

Note: Python mirrors validate ENGINE LOGIC by re-implementing the relevant
state machines in pure Python and exercising them with the same assertions
as the GDScript test scenes. They do NOT validate GDScript syntax — that
requires running the project in Godot. If a Python mirror passes but the
GDScript test scene fails, the bug is likely a Godot syntax/typing issue
(call signature mismatch, missing import, etc.), not a logic issue.
"""

import subprocess
import sys
from pathlib import Path

MIRRORS = [
    ("aura_mirror.py",  "AURA.E1   W42 outbound aura          (F1-F6)"),
    ("l41_mirror.py",   "L41.E1    L41 self-aura              (G1-G4)"),
    ("m41_mirror.py",   "M41.E1    cost-discount state machine (S1-S7)"),
    ("w41_mirror.py",   "W41.E1    Wolf-Token draw trigger    (J1-J8)"),
    ("w4_mirror.py",    "W4.E1     dynamic outbound aura      (H1-H5)"),
]


def run_mirror(path: Path) -> tuple[int, str]:
    """Run a single mirror script. Returns (exit_code, captured_stdout_stderr)."""
    result = subprocess.run(
        [sys.executable, str(path)],
        capture_output=True,
        text=True,
        cwd=str(path.parent),
    )
    return result.returncode, (result.stdout + result.stderr)


def main() -> int:
    here = Path(__file__).resolve().parent
    print("=" * 72)
    print("Gallowfell engine — Phase 2.16 Python mirror suite")
    print("=" * 72)

    results = []
    for filename, label in MIRRORS:
        path = here / filename
        if not path.exists():
            print(f"  MISSING  {filename}  ({label})")
            results.append((filename, label, -1, "file not found"))
            continue
        code, output = run_mirror(path)
        if code == 0:
            print(f"  PASS     {label}")
        else:
            print(f"  FAIL     {label}  (exit {code})")
            # On fail, show the captured output to aid diagnosis
            for line in output.rstrip().split("\n")[-12:]:
                print(f"           {line}")
        results.append((filename, label, code, output))

    print("=" * 72)
    passes = sum(1 for _, _, c, _ in results if c == 0)
    fails = sum(1 for _, _, c, _ in results if c != 0)
    total = len(results)
    if fails == 0:
        print(f"OVERALL: PASS — {passes}/{total} mirrors green")
        return 0
    print(f"OVERALL: FAIL — {passes}/{total} green, {fails} failed")
    return 1


if __name__ == "__main__":
    sys.exit(main())
