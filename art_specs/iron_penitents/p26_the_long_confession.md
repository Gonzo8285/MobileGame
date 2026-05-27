# Per-card art spec — The Long Confession

---

## Card identity

- **card_id:** P26
- **display_name:** The Long Confession
- **faction:** iron_penitents
- **card_type:** SPELL
- **rarity:** UNCOMMON
- **role:** event

---

## Subject description (max ~30 words)

```
confessor listening behind a grille as hooded penitents dissolve into mana-coin and card,
toll paid willingly, ledger filling itself, candlelight, stained-glass shadow
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
confessor listening behind a grille as hooded penitents dissolve into mana-coin and card,
toll paid willingly, ledger filling itself, candlelight, stained-glass shadow,
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

- **seed:** 42626
- **rationale:** card_id digits → 26, formula 40000 + 101 × 26

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/iron_penitents/p26_the_long_confession.png`
- **iterations_path:** `art_iterations/P26_the_long_confession/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed42626_v1 | first pass — accept / iterate |

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
