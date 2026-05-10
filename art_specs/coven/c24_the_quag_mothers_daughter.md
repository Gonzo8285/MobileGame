# Per-card art spec — The Quag-Mother's Daughter

---

## Card identity

- **card_id:** C24
- **display_name:** The Quag-Mother's Daughter
- **faction:** coven_of_the_black_mire
- **card_type:** UNIT
- **rarity:** UNCOMMON
- **role:** standard

---

## Subject description (max ~30 words)

```
young quag-daughter cradling three newborn spawn at once, bog-green amniotic mud streaming, demon-coin necklace, three shadows mirroring the spawn
```

---

## Resolved prompt

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
swamp-witch silhouette, demon-coin wreaths, three-shadows-cast,
green pyre eyes, briar-tangled cloak, lorwyn-folkloric grotesque,
bog-green accent, fungal-grove background,
young quag-daughter cradling three newborn spawn at once, bog-green amniotic mud streaming, demon-coin necklace, three shadows mirroring the spawn,
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
  - `Swamp people` v1 @ 0.5            ← Coven faction LoRA
  - `Mythical Forest Style [SDXL]` v1 @ 0.5  ← Coven faction LoRA, trigger `ral-mytfrst`
- **sampler:** DPM++ 2M Karras
- **steps:** 30
- **cfg:** 6.5
- **width × height:** 832 × 1216
- **clip skip:** 2

> _empty — uses master defaults_

---

## Seed

- **seed:** 62424
- **rationale:** card_id digits → 24, formula 60000 + 101 × 24 (Coven faction tag = 6)

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/coven/c24_the_quag_mothers_daughter.png`
- **iterations_path:** `art_iterations/C24_the_quag_mothers_daughter/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed62424_v1 | first pass — accept / iterate |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — bog-green accent, not lime green or neon
- [ ] Body-horror tolerance — Phyrexian / lorwyn-grotesque undertone present, no explicit gore
- [ ] Composition — focal figure (or environment) dominates, atmospheric depth
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
