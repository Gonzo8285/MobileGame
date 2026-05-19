# Per-card art spec — Bog-Bargain Recall

---

## Card identity

- **card_id:** C41
- **display_name:** Bog-Bargain Recall
- **faction:** coven_of_the_black_mire
- **card_type:** SPELL
- **rarity:** UNCOMMON
- **role:** standard

---

## Subject description (max ~30 words)

```
a witch's grasping hand reaching up from a mire pool, demon-coin offered in
exchange for a returning shade-figure being drawn down into bargained water,
three-shadows-cast on the silt
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
a witch's grasping hand reaching up from a mire pool, demon-coin offered in
exchange for a returning shade-figure being drawn down into bargained water,
three-shadows-cast on the silt,
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

- **seed:** 64141
- **rationale:** Coven faction tag (6) × 10000 + 101 × N (41) = 64141. Clear of Warlord 6 = 64242. No collision.

---

## Output

- **output_path:** `art/coven/C41_bog_bargain_recall.png`
- **iterations_path:** `art_iterations/C41_bog_bargain_recall/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-19 | seed64141_v1 | first pass — accept / iterate. Added beyond original 40-card pool as part of M2 sacrifice-and-return hardening. |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — bog-green accent, not lime green or neon
- [ ] Body-horror tolerance — Phyrexian / lorwyn-grotesque undertone present, no explicit gore
- [ ] Composition — environment-led, the bargain motif (hand + coin + returning shade) reads clearly
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
