# Per-card art spec — TEMPLATE

_Copy this file to `art_specs/<faction>/<card_id>_<lower_snake_name>.md` and fill in. ALL fields must be populated; the spec must be sufficient to regenerate the exact image with no extra information needed._

> **Reproducibility rule (from `pipeline_spec.md` §7):** if the image needs a tweak, edit THIS file and regenerate. Never paint over an output.

---

## Card identity

- **card_id:** P25                          ← stable from `cards_<faction>_v1.md`
- **display_name:** Penance-Captain Vyrrun
- **faction:** iron_penitents               ← lowercase, snake_case, matches folder
- **card_type:** UNIT | SPELL | TRAP | WARLORD | BOSS | ENEMY
- **rarity:** COMMON | UNCOMMON | RARE | EPIC | LEGENDARY
- **role:** standard | warlord_signature | boss | event ← drives composition variant

---

## Subject description (max ~30 words)

The card-specific anchor that goes into prompt layer §3.3. Pulled from the card's design document; tweak only if the design-doc description doesn't lead the image somewhere coherent.

```
led a flagellant column from cathedral ruins, believes he bleeds answers
from the gallows-tree, monarchy-era execution mask in tarnished brass,
hooded, flayed back showing scar-runes
```

---

## Resolved prompt (the assembled five layers)

This is what gets pasted into ComfyUI's prompt node. Concatenated from `pipeline_spec.md` §3.1 + §3.2 (faction) + §3.3 (subject above) + §3.4 (composition) + §3.5 (quality).

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
brass execution-mask iconography, hooded zealot, flagellant chains,
phyrexian-adjacent body-horror (implied not explicit), rust-red accent,
hammer and rope motif, religious dread, ash-and-cinder background,
led a flagellant column from cathedral ruins, believes he bleeds answers
from the gallows-tree, monarchy-era execution mask in tarnished brass,
hooded, flayed back showing scar-runes,
upper body portrait, three-quarter pose, looking-into-camera,
single focal figure dominating frame, atmospheric blurred background,
volumetric haze, no text overlay, no logo, no watermark,
extremely detailed, sharp focus, professional, intricate brushwork,
volumetric lighting, oil-paint texture visible in highlights,
8k, hyper-detailed, masterpiece quality
```

## Negative prompt overrides (rare)

Most cards use the locked baseline from `pipeline_spec.md` §3.6. Override here ONLY if a specific card needs an extra suppression. Document why.

```
[empty — uses baseline]
```

---

## Pipeline parameters (LOCKED unless override)

- **checkpoint:** juggernautXL_v9
- **loras:**
  - `mtg-style-sdxl` @ 0.85
  - `dark-fantasy-oil-painting-sdxl` @ 0.7
  - `elden-ring-concept-sdxl` @ 0.5
  - `phyrexian-corruption-sdxl` @ 0.5         ← faction-specific, Iron Penitents only
- **sampler:** DPM++ 2M Karras
- **steps:** 30
- **cfg:** 6.5
- **width × height:** 832 × 1216
- **clip skip:** 2

If any of these deviate from the master pipeline, write WHY here:

> _empty — uses master defaults_

---

## Seed

- **seed:** 42525                            ← deterministic. Pick a memorable number tied to the card.
- **rationale:** `card_id` digits → 25, base 4 prefix to avoid collisions

For Warlords, recommend seed = `<warlord_number>4242` (e.g. Vyrrun=14242, Sieren=24242).
For commons, recommend seed = digit-stripped card id × 100 + faction tag.

> Once a seed produces an accepted image, it's locked. Don't reroll on a whim — that defeats the reproducibility purpose. If image needs change, change the prompt or LoRA weights, not the seed.

---

## Output

- **output_path:** `art/iron_penitents/P25_penance_captain_vyrrun.png`
- **iterations_path:** `art_iterations/P25_penance_captain_vyrrun/`
- **alt_arts:** [list any planned alt-art variants — e.g. "boss_form", "ascended"]
- **idle_loop_frames:** 4                     ← per `art_direction.md` §3 — Warlords get 4, commons get 2
- **treatment_compatibility:** all            ← which Snap-style treatments are compatible (default = all)

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed42525_v1 | first pass — accept / iterate |
| ... | ... | ... |

---

## Validation checklist (Paul + Cowork sign-off after final render)

- [ ] Reads as Gallowfell — coherent with the other 8 reference-sheet tiles
- [ ] Faction palette holds — rust-red is the accent, not magenta or pink
- [ ] Body-horror tolerance — Phyrexian implication present, no explicit gore
- [ ] Composition — focal figure dominates, atmospheric depth in background
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px (the in-hand card size)
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
