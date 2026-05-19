#!/usr/bin/env python3
"""
populate_art_path.py — step 2 of B3 art integration.

For every card .tres that has a staged webp at
game/assets/cards/<faction>/<ID>.webp, set its `art_path` to the matching
res:// path. Idempotent + precise: only rewrites the single `art_path = "..."`
line, never touches icon_path/other fields, skips if already correct, skips
cards with no staged image (placeholder fallback stays).

Authoring only — no git ops (split-brain courier handles push).
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CARDS_DIR = ROOT / "game" / "data" / "cards"
ASSETS = ROOT / "game" / "assets" / "cards"

ID_RE = re.compile(r'id = &"(\w+)"')
ART_RE = re.compile(r'^art_path = ".*?"$', re.M)


def main():
    changed = skipped_set = skipped_noimg = errors = 0
    for tres in sorted(CARDS_DIR.rglob("*.tres")):
        text = tres.read_text(encoding="utf-8", errors="replace")
        m = ID_RE.search(text)
        if not m:
            continue
        cid = m.group(1)
        faction = tres.parent.name
        webp = ASSETS / faction / f"{cid.upper()}.webp"
        if not webp.exists():
            skipped_noimg += 1
            continue
        res_path = f'res://assets/cards/{faction}/{cid.upper()}.webp'
        new_line = f'art_path = "{res_path}"'
        if not ART_RE.search(text):
            errors += 1
            print(f"  WARN no art_path line in {tres.name}")
            continue
        if f'art_path = "{res_path}"' in text:
            skipped_set += 1
            continue
        new_text, n = ART_RE.subn(new_line, text, count=1)
        if n == 1 and new_text != text:
            tres.write_text(new_text, encoding="utf-8")
            changed += 1
    print(f"art_path set: {changed} | already-correct: {skipped_set} | "
          f"no-image skip: {skipped_noimg} | warnings: {errors}")


if __name__ == "__main__":
    main()
