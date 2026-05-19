# Per-card art spec — Black Mire Pact

---

## Card identity

- **card_id:** C42
- **display_name:** Black Mire Pact
- **faction:** coven_of_the_black_mire
- **card_type:** TRAP
- **rarity:** COMMON
- **role:** standard

---

## Subject description (max ~30 words)

```
a lane-wide pact sigil burning bog-green across a sunken causeway, three
demon-coins arranged in a triangle at its centre, briar tendrils snaking
between them, a single bog-spawn larva crowning from the mud beneath
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
a lane-wide pact sigil burning bog-green across a sunken causeway, three
demon-coins arranged in a triangle at its centre, briar tendrils snaking
between them, a single bog-spawn larva crowning from the mud beneath,
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
  - `ClassipeintXL` v2.1 @ 0.8
  - `Dark Fantasy LORA` v1 @ 0.8
  - `Elden Ring Style` v1.0 @ 0.5
  - `Swamp people` v1 @ 0.5
  - `Mythical Forest Style [SDXL]` v1 @ 0.5
- **sampler:** DPM++ 2M Karras
- **steps:** 30
- **cfg:** 6.5
- **width × height:** 832 × 1216
- **clip skip:** 2

---

## Seed

- **seed:** 64343
- **rationale:** Coven faction tag (6) × 10000 + 101 × N (42) = 64242 collides with Warlord 6 seed (64242 from N × 10000 + 4242 formula). Bumped to 64343 (next free, no collision with any documented warlord or common-card seed). Deviation documented per template.

---

## Output

- **output_path:** `art/coven/C42_black_mire_pact.png`
- **iterations_path:** `art_iterations/C42_black_mire_pact/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-19 | seed64343_v1 | first pass — accept / iterate. Added beyond original 40-card pool as part of M2 sacrifice-and-return hardening. Lane-wide trap — composition emphasises lane scope (sigil burning across causeway), not tile scope. |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — bog-green accent, not lime green or neon
- [ ] Body-horror tolerance — Phyrexian / lorwyn-grotesque undertone present, no explicit gore
- [ ] Composition — lane-scope reads (sigil spans the frame width, not tile-bound)
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
