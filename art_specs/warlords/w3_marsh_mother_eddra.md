# Per-card art spec — Marsh-Mother Eddra

---

## Card identity

- **card_id:** W3
- **display_name:** Marsh-Mother Eddra
- **faction:** coven
- **card_type:** WARLORD
- **rarity:** LEGENDARY
- **role:** warlord_signature

---

## Subject description (max ~30 words)

```
bartered her firstborn for the swamp's name, thirteenth body wearing all
the others, hunched, wreath of demon-coins, green pyre eyes, briar-cloak,
three teeth, three shadows
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
bartered her firstborn for the swamp's name, thirteenth body wearing all
the others, hunched, wreath of demon-coins, green pyre eyes, briar-cloak,
three teeth, three shadows,
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
  - `Swamp people` v1.0 @ 0.5   ← Coven faction LoRA
  - `Mythical Forest Style [SDXL]` v1.0 @ 0.5   ← Coven faction LoRA, trigger ral-mytfrst
- **sampler:** DPM++ 2M Karras
- **steps:** 30
- **cfg:** 6.5
- **width × height:** 832 × 1216
- **clip skip:** 2

> _empty — uses master defaults_

---

## Seed

- **seed:** 34242
- **rationale:** Warlord #3, formula `warlord_number × 10000 + 4242` (per `_template.md` Warlord rule). Sits clear of all five faction common-card seed ranges.

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/warlords/w3_marsh_mother_eddra.png`
- **iterations_path:** `art_iterations/W3_marsh_mother_eddra/`
- **alt_arts:** ["mastery_skin"]   ← Tier-4 mastery cosmetic per `warlord_tiers_v0.md` (W1)
- **idle_loop_frames:** 4           ← Warlords get 4 per `art_direction.md` §3
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed34242_v1 | first pass — accept / iterate |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — bog-green accent, not lime green or neon
- [ ] Body-horror tolerance — lorwyn-folkloric / Phyrexian-undertone present, no explicit gore
- [ ] Composition — focal figure dominates, atmospheric depth in background
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px (the in-hand card size)
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **Warlord-signature flagship presence** — silhouette readable from across the screen, costume / props clearly faction-coded
- [ ] **APPROVED** — Paul's signature once landed
