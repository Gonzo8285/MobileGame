# Per-card art spec — Last Vows

---

## Card identity

- **card_id:** P41
- **display_name:** Last Vows
- **faction:** iron_penitents
- **card_type:** SPELL
- **rarity:** COMMON
- **role:** standard

---

## Subject description (max ~30 words)

```
a hooded penitent kneeling at the foot of a gallows-tree, hands clasped
together over a brass executioner's mask, blood pooling at his knees, two
hovering accusing wraiths bound to him by rust-red bleed-ties
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
a hooded penitent kneeling at the foot of a gallows-tree, hands clasped
together over a brass executioner's mask, blood pooling at his knees, two
hovering accusing wraiths bound to him by rust-red bleed-ties,
wide establishing shot, no central figure, environment-led,
moody composition, painterly atmospheric perspective,
no text overlay, no logo, no watermark,
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
  - `mtg-style-sdxl` @ 0.85
  - `dark-fantasy-oil-painting-sdxl` @ 0.7
  - `elden-ring-concept-sdxl` @ 0.5
  - `phyrexian-corruption-sdxl` @ 0.5
- **sampler:** DPM++ 2M Karras
- **steps:** 30
- **cfg:** 6.5
- **width × height:** 832 × 1216
- **clip skip:** 2

---

## Seed

- **seed:** 44141
- **rationale:** Iron Penitents faction tag (4) × 10000 + 101 × N (41) = 44141. Clear of Warlord 4 = 44242. No collision.

---

## Output

- **output_path:** `art/iron_penitents/P41_last_vows.png`
- **iterations_path:** `art_iterations/P41_last_vows/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-19 | seed44141_v1 | first pass — accept / iterate. Added beyond original 40-card pool as part of M2 sacrifice-and-return hardening. 0-mana sacrifice outlet — composition emphasises the sacrifice motif (penitent at gallows-foot, bleed-ties to wraiths). |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — rust-red is the accent, not magenta or pink
- [ ] Body-horror tolerance — Phyrexian implication present, no explicit gore (blood-pool kept low/atmospheric)
- [ ] Composition — environment-led, sacrifice motif clear (kneeling figure + gallows-tree + mask)
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools (atmospheric blood OK)
- [ ] **APPROVED** — Paul's signature once landed
