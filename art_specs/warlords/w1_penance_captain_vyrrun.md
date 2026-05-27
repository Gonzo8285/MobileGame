# Per-card art spec — Penance-Captain Vyrrun

---

## Card identity

- **card_id:** W1
- **display_name:** Penance-Captain Vyrrun
- **faction:** iron_penitents
- **card_type:** WARLORD
- **rarity:** LEGENDARY
- **role:** warlord_signature

---

## Subject description (max ~30 words)

```
led a flagellant column from cathedral ruins, believing he bleeds answers
from the gallows-tree, monarchy-era execution mask in tarnished brass,
hooded, flayed back showing scar-runes, hammer-and-rope chest plate
```

---

## Resolved prompt

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
brass execution-mask iconography, hooded zealot, flagellant chains,
phyrexian-adjacent body-horror (implied not explicit), rust-red accent,
hammer and rope motif, religious dread, ash-and-cinder background,
led a flagellant column from cathedral ruins, believing he bleeds answers
from the gallows-tree, monarchy-era execution mask in tarnished brass,
hooded, flayed back showing scar-runes, hammer-and-rope chest plate,
upper body portrait, three-quarter pose, looking-into-camera,
single focal figure dominating frame, atmospheric blurred background,
volumetric haze, no text overlay, no logo, no watermark,
extremely detailed, sharp focus, professional, intricate brushwork,
volumetric lighting, oil-paint texture visible in highlights,
8k, hyper-detailed, masterpiece quality
```

## Negative prompt overrides

```
[empty — uses baseline]
```

---

## Pipeline parameters (LOCKED unless override)

- **checkpoint:** juggernautXL_v9
- **loras:**
  - `ClassipeintXL` v2.1 @ 0.8
  - `Dark Fantasy LORA` v1 @ 0.8
  - `Elden Ring Style` v1.0 @ 0.5
  - `RPGNightmareXL` v1.0 @ 0.4   ← Iron Penitents faction LoRA, cap 0.4 for PEGI 12
- **sampler:** DPM++ 2M Karras
- **steps:** 30
- **cfg:** 6.5
- **width × height:** 832 × 1216
- **clip skip:** 2

> _empty — uses master defaults_

---

## Seed

- **seed:** 14242
- **rationale:** Warlord #1, formula `warlord_number × 10000 + 4242` (per `_template.md` Warlord rule). Sits clear of all five faction common-card seed ranges.

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/warlords/w1_penance_captain_vyrrun.png`
- **iterations_path:** `art_iterations/W1_penance_captain_vyrrun/`
- **alt_arts:** ["mastery_skin"]   ← Tier-4 mastery cosmetic per `warlord_tiers_v0.md` (W1)
- **idle_loop_frames:** 4           ← Warlords get 4 per `art_direction.md` §3
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed14242_v1 | first pass — accept / iterate |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — rust-red accent, not magenta or pink
- [ ] Body-horror tolerance — Phyrexian implication present, no explicit gore
- [ ] Composition — focal figure dominates, atmospheric depth in background
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px (the in-hand card size)
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **Warlord-signature flagship presence** — silhouette readable from across the screen, costume / props clearly faction-coded
- [ ] **APPROVED** — Paul's signature once landed
