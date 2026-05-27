#!/usr/bin/env python3
"""
fetch_icons.py — B3 step #2: pull the 21 stat+keyword UI icons from
game-icons.net (CC-BY 3.0) as Gallowfell-brass, transparent SVG.

game-icons.net only serves FIXED colour combos (arbitrary hex 404s), so we
fetch black-on-transparent and recolour black -> Gallowfell brass ourselves:
  https://game-icons.net/icons/000000/transparent/1x1/<author>/<slug>.svg
SVG kept as-is so Godot 4 rasterises crisp at any size.

Per concept we try a few candidate author/slug pairs and keep the first that
returns a real <svg>. Misses are reported for a second pass. Faction sigils
are NOT here — they're bespoke (see _sigils.md), handled separately.

Authoring only — no git ops (split-brain courier pushes). Attribution for
CC-BY is written to game/assets/icons/CREDITS.md.
"""
import re
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "game" / "assets" / "icons"
BRASS = "c9a24b"  # Gallowfell brass accent

# concept -> ordered candidate "author/slug" guesses (first valid wins)
CANDIDATES = {
    # stat icons
    "stat_mana":      ["sbed/water-drop", "lorc/water-drop", "delapouite/water-drop"],
    "stat_health":    ["sbed/health-normal", "delapouite/health-normal", "lorc/hearts"],
    "stat_power":     ["lorc/crossed-swords", "lorc/sword-brandish", "delapouite/sword-wound"],
    "stat_range":     ["lorc/high-shot", "delapouite/high-shot", "lorc/bow-arrow"],
    "stat_cooldown":  ["lorc/sands-of-time", "delapouite/hourglass", "lorc/hourglass"],
    # keyword icons
    "kw_cleave":      ["lorc/axe-swing", "lorc/sword-slice", "lorc/wide-arrow-dunk"],
    "kw_pierce":      ["lorc/spear-hook", "delapouite/spears", "lorc/thrust-bend"],
    "kw_bleed":       ["sbed/bleeding-wound", "lorc/blood", "lorc/bleeding-heart"],
    "kw_poison":      ["lorc/poison-bottle", "delapouite/poison-gas", "lorc/skull-crossed-bones"],
    "kw_root":        ["lorc/root-tip", "delapouite/vine-whip", "lorc/tree-roots"],
    "kw_fear":        ["lorc/terror", "lorc/screaming", "lorc/despair"],
    "kw_shield":      ["sbed/shield", "lorc/checked-shield", "delapouite/shield"],
    "kw_resurrect":   ["lorc/raise-zombie", "delapouite/raise-zombie", "lorc/angel-wings"],
    "kw_summon":      ["lorc/summon", "delapouite/portal", "lorc/magic-portal"],
    "kw_sacrifice":   ["lorc/sacrificial-dagger", "lorc/bleeding-heart", "delapouite/animal-skull"],
    "kw_penance":     ["lorc/prayer", "delapouite/prayer-beads", "lorc/pray"],
    "kw_dread":       ["lorc/spectre", "lorc/screaming", "lorc/evil-moon"],
    "kw_smoke":       ["lorc/smoking-orb", "delapouite/smoke-bomb", "lorc/cloudy"],
    "kw_slow":        ["lorc/snail", "delapouite/turtle", "lorc/turtle"],
    "kw_persist":     ["lorc/cycle", "delapouite/return-arrow", "lorc/clockwise-rotation"],
    "kw_taunt":       ["lorc/shouting", "delapouite/talk", "lorc/megaphone"],
}


def fetch(url):
    r = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    return urllib.request.urlopen(r, timeout=20).read().decode("utf-8", "replace")


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    got, missing, credits = [], [], []
    for key, cands in CANDIDATES.items():
        ok = False
        for cand in cands:
            url = f"https://game-icons.net/icons/000000/transparent/1x1/{cand}.svg"
            try:
                svg = fetch(url)
            except Exception:
                continue
            if "<svg" in svg and len(svg) > 200:
                # Recolour the black icon shape to Gallowfell brass.
                svg = re.sub(r"#0{3}(?:0{3})?\b", f"#{BRASS}", svg,
                             flags=re.I)
                svg = svg.replace('fill="black"', f'fill="#{BRASS}"')
                (OUT / f"{key}.svg").write_text(svg, encoding="utf-8")
                got.append((key, cand))
                credits.append(f"- {key}.svg — game-icons.net `{cand}` (CC-BY 3.0)")
                ok = True
                break
        if not ok:
            missing.append(key)

    if credits:
        (OUT / "CREDITS.md").write_text(
            "# Icon attribution\n\nIcons from game-icons.net, CC-BY 3.0 "
            "(https://creativecommons.org/licenses/by/3.0/), recoloured to "
            "the Gallowfell brass palette.\n\n" + "\n".join(sorted(credits)) +
            "\n", encoding="utf-8")

    print(f"icons fetched: {len(got)}/{len(CANDIDATES)} -> "
          f"{OUT.relative_to(ROOT)}")
    for k, c in got:
        print(f"  {k:14s} <- {c}")
    if missing:
        print(f"MISSING (need a 2nd-pass slug): {missing}")
    print("\nNOTE: 6 faction sigils are bespoke (see _sigils.md) — not here.")


if __name__ == "__main__":
    main()
