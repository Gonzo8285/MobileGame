#!/usr/bin/env python3
"""
build_full_manifest.py — turn art_specs/**/*.md into runnable manifests,
applying the prompt-structure lessons proven on the 12-tile showcase:

  * CHARACTER cards (card_type WARLORD/UNIT/ENEMY, role standard|
    warlord_signature): the spec's Resolved prompt validated well with
    Juggernaut+hires — used as-is. Creature-ish units get anti-"pretty"
    negatives (the C1 fix).
  * EVENT/OBJECT cards (card_type SPELL/TRAP/RELIC, role event): the spec
    Resolved prompts carry the M39/L40 defect (figure descriptors +
    "no central figure" in the *positive*, which SDXL ignores). Rebuilt
    around the concise Subject description as a figureless environment/
    still-life, with figure-exclusion moved into the *negative*.

Outputs (pipeline_setup/):
  _full_<faction>.json      one manifest per faction (pod-budget sized)
  _full_validation.json     cross-section: N per faction x card_type
Render params (sampler/steps/cfg/wxh/seed) read from each spec.
Outputs land in art_iterations/_showcase/full/<faction>/ (the batch script's
OUTPUT_ROOT is _showcase; "full/<faction>" survives its split()).
"""
import json
import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SPECS = ROOT.parent / "art_specs"
SHOWCASE = ROOT / "showcase_manifest.json"

NEG_BASELINE = json.loads(SHOWCASE.read_text(encoding="utf-8"))["negative_baseline"]

QUALITY_TAIL = ("extremely detailed, sharp focus, professional, intricate "
                "brushwork, volumetric lighting, oil-paint texture visible in "
                "highlights, 8k, hyper-detailed, masterpiece quality")

# Figure-exclusion appended to negatives for event/object cards (the proven
# M39/L40 fix — SDXL only honours this in the negative, not the positive).
EVENT_NEG_ADD = (", person, people, figure, human, character, portrait, face, "
                 "hands, crowd, silhouette of a person, group of people")

# Light heuristic: UNIT/ENEMY subjects that read as non-human creatures get
# anti-"pretty" negatives so Juggernaut doesn't render a glamour model (C1 fix).
CREATURE_WORDS = re.compile(
    r"\b(spawn|larva|beast|horror|wretch|maw|thing|fiend|hound|swarm|"
    r"abomination|grub|husk|crawler|broodling|monstros|creature|ghoul|"
    r"revenant|wraith|leech|tendril|carrion|gore-?beast|chimera)\b", re.I)
CREATURE_NEG_ADD = (", beautiful woman, attractive female, glamour model, "
                    "pretty face, makeup, smooth flawless skin, fashion "
                    "portrait, elegant, supermodel, humanoid pin-up, human, "
                    "humanoid, man, woman, person, standing person, robed "
                    "figure, orc, goblin, elf, knight, soldier")
CREATURE_POS_ANCHOR = ("a feral non-humanoid monster, bestial creature with "
                       "animal anatomy, aberrant beast, not a person, no "
                       "humanoid form, ")

# Universal preamble shared by every spec's resolved prompt. The text AFTER
# this anchor is faction-specific style — and for event/object cards that
# block is the figure-leak source (court-shroud robes, ink-stained hands,
# swamp-witch, ...). The proven M39/L40 fix drops it entirely.
GENERIC_ANCHOR = "in the style of Steve Argyle and Volkan Baga,"
FIGURE_WORDS = re.compile(
    r"\b(figure|figures|mourner|mourners|witch|robed|robe|robes|hood|hooded|"
    r"cloak|cloaked|kneeling|person|people|hands|monk|priest|pilgrim|acolyte|"
    r"congregation|crowd|standing|zealot|confessor|warden|knight|soldier|"
    r"man|woman|child|body|corpse|figureheads?)\b", re.I)
EVENT_FIGURELESS = ("deserted empty environment, abandoned scene, absolutely "
                    "no people, no figures, unpopulated, still-life of objects "
                    "and architecture, ")

SAMPLER_MAP = {
    "dpm++ 2m karras": ("dpmpp_2m", "karras"),
    "dpm++ 2m sde karras": ("dpmpp_2m_sde", "karras"),
    "dpm++ 2m": ("dpmpp_2m", "normal"),
    "euler a": ("euler_ancestral", "normal"),
    "euler": ("euler", "normal"),
}


def field(text, name):
    m = re.search(rf"\*\*{re.escape(name)}:\*\*\s*(.+)", text)
    return m.group(1).strip() if m else None


def fenced_block(text, header):
    """Return the first ``` ``` block after a '## <header>' heading."""
    m = re.search(rf"##\s*{re.escape(header)}.*?```(.*?)```", text, re.S | re.I)
    return m.group(1).strip() if m else None


def slugify(name):
    return re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_")


def parse_spec(path):
    t = path.read_text(encoding="utf-8", errors="replace")
    card_id = field(t, "card_id")
    if not card_id:
        return None
    disp = field(t, "display_name") or card_id
    # Canonical faction = folder name (the spec `faction:` field is inconsistent
    # — coven vs coven_of_the_black_mire, last_legion vs the_last_legion).
    faction = path.parent.name
    ctype = (field(t, "card_type") or "").upper()
    role = (field(t, "role") or "").lower()
    subject = fenced_block(t, "Subject description (max ~30 words)") or \
        fenced_block(t, "Subject description") or ""
    subject = " ".join(subject.split())
    resolved = fenced_block(t, "Resolved prompt") or ""
    resolved = " ".join(resolved.split())
    neg_over = fenced_block(t, "Negative prompt overrides") or ""
    seed_m = re.search(r"\*\*seed:\*\*\s*(\d+)", t)
    seed = int(seed_m.group(1)) if seed_m else (abs(hash(card_id)) % 90000 + 10000)
    steps = int((field(t, "steps") or "30").split()[0])
    cfg = float((field(t, "cfg") or "6.5").split()[0])
    wh = field(t, "width × height") or field(t, "width x height") or "832 × 1216"
    wm = re.findall(r"(\d+)", wh)
    width, height = (int(wm[0]), int(wm[1])) if len(wm) >= 2 else (832, 1216)
    samp_raw = (field(t, "sampler") or "DPM++ 2M Karras").lower().strip()
    sampler, scheduler = SAMPLER_MAP.get(samp_raw, ("dpmpp_2m", "karras"))
    return dict(card_id=card_id, display_name=disp, faction=faction,
                card_type=ctype, role=role, subject=subject, resolved=resolved,
                neg_override=neg_over, seed=seed, steps=steps, cfg=cfg,
                width=width, height=height, sampler=sampler,
                scheduler=scheduler, spec_path=str(path.relative_to(ROOT.parent)))


def style_prefix(resolved, subject):
    """Everything in the resolved prompt up to where the subject text begins
    = the generic + faction style block. Robust anchor: first 4 subject words."""
    head = " ".join(subject.split()[:4])
    if head:
        i = resolved.lower().find(head.lower())
        if i > 40:
            return resolved[:i].rstrip(", ").strip() + ", "
    # Fallback: cut at the standard framing boilerplate.
    for marker in ("upper body portrait", "wide establishing shot",
                   "single focal figure"):
        i = resolved.lower().find(marker)
        if i > 40:
            return resolved[:i].rstrip(", ").strip() + ", "
    return resolved[:600].rstrip(", ") + ", "


def generic_preamble(resolved):
    """Universal style block only (drop faction-specific style that leaks
    figures for object cards)."""
    i = resolved.lower().find(GENERIC_ANCHOR.lower())
    if i >= 0:
        return resolved[:i + len(GENERIC_ANCHOR)].strip() + " "
    return ("masterpiece, magic the gathering card art, oil painting, "
            "painterly, cinematic, atmospheric, dark fantasy, grimdark, "
            "muted earth-tone palette, in the style of Steve Argyle and "
            "Volkan Baga, ")


def scrub_figures(subject):
    """Drop comma-clauses dominated by figure words; keep object/scene
    clauses so an event card reads as a place/effect, not a portrait."""
    kept = []
    for clause in subject.split(","):
        c = clause.strip()
        if not c:
            continue
        words = re.findall(r"[a-zA-Z'-]+", c)
        if not words:
            continue
        fig = sum(1 for w in words if FIGURE_WORDS.fullmatch(w))
        # Drop clause if figure words are a meaningful share of it.
        if fig and fig / len(words) >= 0.34:
            continue
        kept.append(c)
    return ", ".join(kept).strip(", ")


def build_prompts(s):
    """Return (positive, negative) applying role-aware transforms."""
    base_neg = NEG_BASELINE if "[empty" in s["neg_override"] or not \
        s["neg_override"] else s["neg_override"]

    if s["role"] == "event" or s["card_type"] in ("SPELL", "TRAP", "RELIC"):
        # Drop faction style block (figure-leak source); lead hard figureless;
        # use figure-scrubbed subject. Mirrors the proven M39/L40 rewrite.
        subj = scrub_figures(s["subject"]) or \
            "the card's central object, relic or magical effect"
        pos = (generic_preamble(s["resolved"]) + EVENT_FIGURELESS +
               subj + ", the focal object/effect as the unmistakable central "
               "subject, wide establishing shot, environment-led, deserted, "
               "moody atmospheric composition, painterly atmospheric "
               "perspective, " + QUALITY_TAIL)
        return pos, base_neg + EVENT_NEG_ADD + EVENT_NEG_ADD

    if s["card_type"] in ("UNIT", "ENEMY") and CREATURE_WORDS.search(
            s["subject"] + " " + s["display_name"]):
        # Force non-humanoid: anchor anatomy before the subject + hard negs.
        pre = generic_preamble(s["resolved"])
        rest = s["resolved"][len(pre):] if s["resolved"].startswith(pre) \
            else s["resolved"]
        pos = pre + CREATURE_POS_ANCHOR + rest
        return pos, base_neg + CREATURE_NEG_ADD

    # character — spec resolved prompt as-is (validated strong)
    return s["resolved"], base_neg


def classify(s):
    """character | event | creature — drives which transform + which run."""
    if s["role"] == "event" or s["card_type"] in ("SPELL", "TRAP", "RELIC"):
        return "event"
    if s["card_type"] in ("UNIT", "ENEMY") and CREATURE_WORDS.search(
            s["subject"] + " " + s["display_name"]):
        return "creature"
    return "character"


def to_tile(s):
    pos, neg = build_prompts(s)
    return {
        "tile_id": s["card_id"],
        "display_name": s["display_name"],
        "role": s["role"],
        "spec_path": s["spec_path"],
        "positive_prompt": pos,
        "negative_prompt": neg,
        "seed": s["seed"],
        "output_subdir": f"_showcase/full/{s['faction']}",
        "output_filename": f"{s['card_id'].lower()}_{slugify(s['display_name'])}.png",
        "width": s["width"],
        "height": s["height"],
        "steps": s["steps"],
        "cfg": s["cfg"],
        "sampler": s["sampler"],
        "scheduler": s["scheduler"],
    }


def manifest(tiles):
    base = json.loads(SHOWCASE.read_text(encoding="utf-8"))
    base["tiles"] = tiles
    base["generated_for"] = "full-set build_full_manifest.py"
    return base


def main():
    specs = [p for p in SPECS.rglob("*.md")
             if p.name not in ("_sigils.md", "_template.md")]
    parsed = [x for x in (parse_spec(p) for p in sorted(specs)) if x]
    by_faction = defaultdict(list)
    for s in parsed:
        by_faction[s["faction"]].append(s)

    summary = []
    for fac, items in sorted(by_faction.items()):
        tiles = [to_tile(s) for s in items]
        out = ROOT / f"_full_{fac}.json"
        out.write_text(json.dumps(manifest(tiles), indent=2,
                                  ensure_ascii=False), encoding="utf-8")
        ev = sum(1 for s in items if s["role"] == "event" or
                 s["card_type"] in ("SPELL", "TRAP", "RELIC"))
        summary.append((fac, len(tiles), ev, out.name))

    # Classify everything.
    cls = defaultdict(list)
    for s in parsed:
        cls[classify(s)].append(s)

    # CHARACTER set (proven good) -> pod-budget chunks (<=70 tiles/pod, well
    # under the script's ~90 ceiling at the 75-min cap). Stable card_id order.
    chars = sorted(cls["character"], key=lambda s: (s["faction"], s["card_id"]))
    CHUNK = 70
    char_chunks = [chars[i:i + CHUNK] for i in range(0, len(chars), CHUNK)]
    char_files = []
    for i, ch in enumerate(char_chunks, 1):
        fn = f"_char_{i:02d}.json"
        (ROOT / fn).write_text(json.dumps(manifest([to_tile(s) for s in ch]),
                               indent=2, ensure_ascii=False), encoding="utf-8")
        char_files.append((fn, len(ch)))

    # Event + creature sets kept separate for the transform-iteration loop.
    for kind in ("event", "creature"):
        items = sorted(cls[kind], key=lambda s: (s["faction"], s["card_id"]))
        (ROOT / f"_{kind}_all.json").write_text(
            json.dumps(manifest([to_tile(s) for s in items]), indent=2,
                       ensure_ascii=False), encoding="utf-8")
        # Small re-validation sample (<=3 per faction, cap 15).
        seen = defaultdict(int)
        samp = []
        for s in items:
            if seen[s["faction"]] < 3 and len(samp) < 15:
                seen[s["faction"]] += 1
                samp.append(to_tile(s))
        (ROOT / f"_{kind}_revalidate.json").write_text(
            json.dumps(manifest(samp), indent=2, ensure_ascii=False),
            encoding="utf-8")

    print(f"specs parsed: {len(parsed)}")
    for fac, n, ev, fn in summary:
        print(f"  {fac:16s} {n:3d} tiles ({ev:2d} event/object) -> {fn}")
    print(f"\nCLASSIFIED: character={len(cls['character'])} "
          f"event={len(cls['event'])} creature={len(cls['creature'])}")
    print("CHARACTER run chunks (proven config, ready now):")
    for fn, n in char_files:
        print(f"  {fn}: {n} tiles")
    print("Event/creature staged for transform iteration: "
          "_event_all.json _event_revalidate.json "
          "_creature_all.json _creature_revalidate.json")
    # Show a sample transformed prompt of each kind for eyeballing.
    for s in parsed:
        if s["role"] == "event":
            p, n = build_prompts(s)
            print("\n[EVENT sample]", s["card_id"], s["display_name"])
            print(" POS:", p[:300], "...")
            print(" NEG+:", n[len(NEG_BASELINE):][:120])
            break
    for s in parsed:
        if s["card_type"] in ("UNIT", "ENEMY") and CREATURE_WORDS.search(
                s["subject"] + " " + s["display_name"]):
            p, n = build_prompts(s)
            print("\n[CREATURE sample]", s["card_id"], s["display_name"])
            print(" NEG+:", n[len(NEG_BASELINE):][:120])
            break


if __name__ == "__main__":
    main()
