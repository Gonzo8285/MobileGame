# Per-card art spec — Ash-Wraith

---

## Card identity

- **card_id:** E4
- **display_name:** Ash-Wraith
- **faction:** ash_mourners
- **card_type:** ENEMY
- **rarity:** UNCOMMON
- **role:** standard

---

## Subject description (max ~30 words)

```
drifting court-shroud trailing smoke-thread behind it, hollow coal-eyes
that watched the King hang, no body beneath the trailing robes, dusk-purple
mourning ribbons, cathedral-vault silhouette, no shadow cast
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
drifting court-shroud trailing smoke-thread behind it, hollow coal-eyes
that watched the King hang, no body beneath the trailing robes, dusk-purple
mourning ribbons, cathedral-vault silhouette, no shadow cast,
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

- **seed:** 90404
- **rationale:** card_id digits → 4, formula 90000 + 101 × 4 (Enemy faction tag = 9)

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/enemies/e4_ash_wraith.png`
- **iterations_path:** `art_iterations/E4_ash_wraith/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed90404_v1 | first pass — accept / iterate |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — dusk-purple accent, not blue or fuchsia
- [ ] Body-horror tolerance — Phyrexian implication present, no explicit gore
- [ ] Composition — focal figure dominates, atmospheric depth in background
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
