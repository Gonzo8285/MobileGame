# Per-card art spec — Crown of the Hanged Confessor

---

## Card identity

- **card_id:** P40
- **display_name:** Crown of the Hanged Confessor
- **faction:** iron_penitents
- **card_type:** RELIC
- **rarity:** RARE
- **role:** event

---

## Subject description (max ~30 words)

```
tarnished iron crown with noose-cord woven through its tines, hanging mid-air in a dark vault,
radiating faint command-field glow below to unseen allies, alone in the darkness
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
tarnished iron crown with noose-cord woven through its tines, hanging mid-air in a dark vault,
radiating faint command-field glow below to unseen allies, alone in the darkness,
wide establishing shot, no central figure, environment-led,
moody composition, painterly atmospheric perspective,
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

- **seed:** 44040
- **rationale:** card_id digits → 40, formula 40000 + 101 × 40

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/iron_penitents/p40_crown_of_the_hanged_confessor.png`
- **iterations_path:** `art_iterations/P40_crown_of_the_hanged_confessor/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed44040_v1 | first pass — accept / iterate |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — rust-red accent, not magenta or pink
- [ ] Body-horror tolerance — Phyrexian implication present, no explicit gore
- [ ] Composition — focal figure (or environment) dominates, atmospheric depth
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
