# B3 Art Integration — status & handoff

Authored by Cowork Claude. Per `docs/CONTRIBUTING.md` this is **authored, not
pushed** — the Claude Code courier carries it to `Gonzo8285/MobileGame`.

## 1. Card art — DONE (authoring), 1 manual step remains

**What landed:**
- 200 card portraits staged at `game/assets/cards/<faction>/<ID>.webp`
  — resized to 512×768, webp q82, **7.9 MB total** (≈38 KB each; raw was
  ~650 MB — this size is deliberate for the constrained git courier + the
  1080×1920 mobile target).
  - Source precedence: Paul-approved `_showcase/v2/` (11 warlords) >
    Juggernaut `_showcase/full/` (189).
- `art_path` populated in those 200 card `.tres` (→ `res://assets/cards/…`).
- `game/src/ui/card_view.gd` now renders the portrait + a legibility scrim,
  with a **safe fallback**: if `art_path` is empty *or the texture isn't
  imported yet*, it shows the existing faction-tint placeholder. Nothing
  breaks pre-import.

**The one manual step (cannot be automated here — no Godot binary in Cowork):**
> Open `game/project.godot` in **Godot 4.6 Mobile** once. The editor will
> import the 200 new `.webp` (generates `.import` sidecars + `.godot/imported`
> entries). After that, cards show real art. Commit the generated `.import`
> files via the normal courier flow.

**Reproduce/refresh:** `python pipeline_setup/integrate_card_art.py` then
`python pipeline_setup/populate_art_path.py` (both idempotent, no git ops).

**Known gap:** 3 cards have no art — `C41` Bog-Bargain Recall, `C42` Black
Mire Pact, `P41` Last Vows (added beyond the P/M/C 1–40 art-spec range).
They keep the placeholder. Needs: author art specs for these 3 + a 3-tile
generation run (cheap) — tracked as a follow-up.

## 2. Icon set — SPEC (production next)

Grounded in `enums.gd` + the card `.tres` schema. **~27 icons**, one
consistent flat style, transparent PNG, legible at 16–24 px, Gallowfell
brass/grimdark palette:

**Stat icons (5):** mana/`cost`, health/`hp`, power/`attack`,
`attack_range` (1 icon or 4: none/melee/short/long), `cooldown`
("rounds before it can act").

**Keyword icons (16):** Cleave, Pierce, Bleed, Poison, Root, Fear, Shield,
Resurrect, Summon, Sacrifice, Penance, Dread, Smoke, Slow, Persist, Taunt.

**Faction sigils (6):** Iron Penitents (S1 part-spec'd in `_sigils.md`),
Withered Court, Hollow Pact, Ferrum Host, Sable Wilds, Neutral.

**DONE — 21 stat+keyword icons:** sourced from game-icons.net (CC-BY 3.0),
fetched black-on-transparent and recoloured to Gallowfell brass `#c9a24b`,
saved as **SVG** at `game/assets/icons/*.svg` (Godot 4 imports SVG natively
and rasterises crisp at any size). Attribution in
`game/assets/icons/CREDITS.md`. Reproduce: `python pipeline_setup/fetch_icons.py`
(idempotent, no git ops).

**Faction sigils (6) — NOT done here, by design.** These are a separate,
already-running heartbeat workstream: `art_specs/_sigils.md` defines a
bespoke SDXL flat-vector pipeline (own seeds/workflow/conventions, 1 sigil
spec authored per heartbeat cycle). Only **S1 Iron Penitents** is authored;
S2–S5 await future heartbeat cycles. Generating them ad hoc would collide
with that documented process — left to the heartbeat.

**Remaining wiring (engine, follow-on):** populate the card `.tres`
`icon_path` + a `card_view` pass that draws keyword icons and swaps the
text stat labels for the stat icons. Same shape as the card-art change.
Covered by the SAME Godot-import handoff as §1 (the SVGs import alongside
the card webps when the project is opened in Godot 4.6).

## 3. Not started (need Paul's steer)
- PvP environment + competition rewards — separate project, needs its own
  design/architecture doc before any estimate. Not in any current scope doc.
