# Per-card art spec — Cathedral Flagellant

---

## Card identity

- **card_id:** E1
- **display_name:** Cathedral Flagellant
- **faction:** iron_penitents
- **card_type:** ENEMY
- **rarity:** COMMON
- **role:** standard

---

## Subject description (max ~30 words)

```
gaunt flagellant lurching from cathedral ruin, self-scourge whip mid-swing,
hymn-cracked lips, blood between teeth, hooded grey habit shredded across
the spine, brass execution mask askew, advancing in a processional rush
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
gaunt flagellant lurching from cathedral ruin, self-scourge whip mid-swing,
hymn-cracked lips, blood between teeth, hooded grey habit shredded across
the spine, brass execution mask askew, advancing in a processional rush,
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

- **seed:** 90101
- **rationale:** card_id digits → 1, formula 90000 + 101 × 1 (Enemy faction tag = 9, distinct from Penitents 4 / Mourners 5 / Coven 6 / Last Legion 7 / Skinward 8)

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/enemies/e1_cathedral_flagellant.png`
- **iterations_path:** `art_iterations/E1_cathedral_flagellant/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed90101_v1 | first pass — accept / iterate |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — rust-red accent, not magenta or pink
- [ ] Body-horror tolerance — Phyrexian implication present, no explicit gore
- [ ] Composition — focal figure dominates, atmospheric depth in background
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
