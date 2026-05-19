#!/usr/bin/env python3
"""
integrate_card_art.py — stage generated card art into the Godot project.

Step 1 of the B3 art-integration (the other steps are populate_art_path.py and
the card_view.gd render change). Authoring only — does NOT git commit/push
(that's the Claude Code courier's role per docs/CONTRIBUTING.md).

For every card .tres under game/data/cards/<faction>/:
  - pick its canonical source image, precedence:
      1. art_iterations/_showcase/v2/**     (Paul-approved hero/showcase set)
      2. art_iterations/_showcase/full/**   (Juggernaut full-deck run)
  - resize to a mobile-correct 512x768 (keeps the 2:3 of the 832x1216 source)
  - save webp q82 -> game/assets/cards/<faction>/<ID>.webp  (~100KB each,
    ~20-25MB total vs ~650MB raw — essential for the constrained git courier
    and correct for a 1080x1920 mobile target)

Cards with no source image are reported and skipped (placeholder fallback in
card_view handles them).
"""
import re
import sys
from pathlib import Path
from collections import defaultdict

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
CARDS_DIR = ROOT / "game" / "data" / "cards"
OUT_ROOT = ROOT / "game" / "assets" / "cards"
SHOWCASE = ROOT / "art_iterations" / "_showcase"

TARGET = (512, 768)
WEBP_Q = 82

ID_RE = re.compile(r"^([a-zA-Z]+\d+)_")
TRES_ID_RE = re.compile(r'id = &"(\w+)"')


def index_sources():
    """id (upper) -> chosen Path, precedence v2 (warlords first) then full."""
    v2, full = defaultdict(list), defaultdict(list)
    v2_root = SHOWCASE / "v2"
    full_root = SHOWCASE / "full"
    if v2_root.exists():
        for p in v2_root.rglob("*.png"):
            m = ID_RE.match(p.name)
            if m:
                v2[m.group(1).upper()].append(p)
    if full_root.exists():
        for p in full_root.rglob("*.png"):
            m = ID_RE.match(p.name)
            if m:
                full[m.group(1).upper()].append(p)

    def pick(cands):
        # Prefer a 'warlords' path, else shortest filename (plain over _seed/_0.9vae)
        w = [c for c in cands if "warlords" in c.parts]
        pool = w or cands
        return sorted(pool, key=lambda c: len(c.name))[0]

    chosen = {}
    for cid in set(v2) | set(full):
        if cid in v2:
            chosen[cid] = ("v2", pick(v2[cid]))
        else:
            chosen[cid] = ("full", pick(full[cid]))
    return chosen


def main():
    if not CARDS_DIR.exists():
        sys.exit(f"FATAL: {CARDS_DIR} not found")
    sources = index_sources()
    OUT_ROOT.mkdir(parents=True, exist_ok=True)

    done, missing, total_bytes = [], [], 0
    for tres in sorted(CARDS_DIR.rglob("*.tres")):
        m = TRES_ID_RE.search(tres.read_text(encoding="utf-8", errors="replace"))
        if not m:
            continue
        cid = m.group(1).upper()
        faction = tres.parent.name
        if cid not in sources:
            missing.append(cid)
            continue
        tier, src = sources[cid]
        out_dir = OUT_ROOT / faction
        out_dir.mkdir(parents=True, exist_ok=True)
        out = out_dir / f"{cid}.webp"
        try:
            with Image.open(src) as im:
                im = im.convert("RGB")
                im = im.resize(TARGET, Image.LANCZOS)
                im.save(out, "WEBP", quality=WEBP_Q, method=6)
            total_bytes += out.stat().st_size
            done.append((cid, tier, faction))
        except Exception as e:
            missing.append(f"{cid}(err:{type(e).__name__})")

    by_tier = defaultdict(int)
    for _, t, _ in done:
        by_tier[t] += 1
    print(f"staged: {len(done)} card images -> {OUT_ROOT.relative_to(ROOT)}")
    print(f"  source tier: {dict(by_tier)}")
    print(f"  total size: {total_bytes/1e6:.1f} MB "
          f"(avg {total_bytes/max(1,len(done))/1024:.0f} KB)")
    print(f"  no source (placeholder fallback): {len(missing)} -> {missing}")


if __name__ == "__main__":
    main()
