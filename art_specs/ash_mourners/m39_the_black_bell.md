# Per-card art spec — The Black Bell

---

## Card identity

- **card_id:** M39
- **display_name:** The Black Bell
- **faction:** ash_mourners
- **card_type:** RELIC
- **rarity:** UNCOMMON
- **role:** event

---

## Subject description (max ~30 words)

```
ancient onyx hand-bell on a velvet cushion in a court-mourning reliquary, dusk-purple cloth, raven-quill arrangement, ink-stained tag, gothic-vault niche around it
```

---

## Resolved prompt

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
gothic-cathedral funerary aesthetic, court-shroud robes, ink-stained hands,
raven-quill flourishes, no-shadow figures, dusk-purple accent,
catacomb-vault background, Victorian mourning sensibility,
ancient onyx hand-bell on a velvet cushion in a court-mourning reliquary, dusk-purple cloth, raven-quill arrangement, ink-stained tag, gothic-vault niche around it,
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
  - `gothic cathedral interior` v1.0 @ 0.6   ← Ash-Mourners faction LoRA
  - `Dark Gothic Fantasy` v3.01 @ 0.5         ← Ash-Mourners faction LoRA
- **sampler:** DPM++ 2M Karras
- **steps:** 30
- **cfg:** 6.5
- **width × height:** 832 × 1216
- **clip skip:** 2

> _empty — uses master defaults_

---

## Seed

- **seed:** 53939
- **rationale:** card_id digits → 39, formula 50000 + 101 × 39 (Ash-Mourners faction tag = 5)

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/ash_mourners/m39_the_black_bell.png`
- **iterations_path:** `art_iterations/M39_the_black_bell/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed53939_v1 | first pass — accept / iterate |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — dusk-purple accent, not blue or fuchsia
- [ ] Body-horror tolerance — Phyrexian implication present, no explicit gore
- [ ] Composition — focal figure (or environment) dominates, atmospheric depth
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
