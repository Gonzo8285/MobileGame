# Per-card art spec — Witch of the Bound Coin

---

## Card identity

- **card_id:** C11
- **display_name:** Witch of the Bound Coin
- **faction:** coven_of_the_black_mire
- **card_type:** UNIT
- **rarity:** RARE
- **role:** standard

---

## Subject description (max ~30 words)

```
binding-witch holding a coin tied to a long thread mid-ritual, demon-coin wreath ablaze with bog-green pyre, three shadows pointing at unseen marks, briar cloak
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
binding-witch holding a coin tied to a long thread mid-ritual, demon-coin wreath ablaze with bog-green pyre, three shadows pointing at unseen marks, briar cloak,
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

- **seed:** 61111
- **rationale:** card_id digits → 11, formula 60000 + 101 × 11 (Coven faction tag = 6)

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/coven/c11_witch_of_the_bound_coin.png`
- **iterations_path:** `art_iterations/C11_witch_of_the_bound_coin/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed61111_v1 | first pass — accept / iterate |

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
