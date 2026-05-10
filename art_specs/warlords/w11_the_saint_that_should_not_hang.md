# Per-card art spec — The Saint That Should Not Hang

---

## Card identity

- **card_id:** W11
- **display_name:** The Saint That Should Not Hang
- **faction:** ash_mourners
- **card_type:** WARLORD
- **rarity:** LEGENDARY
- **role:** warlord_signature

---

## Subject description (max ~30 words)

```
young woman wrongfully hanged at the founding of the gallows-town,
noose-frayed white shift, eyes painted shut so her image cannot judge,
bare feet leaving no print, faint rope-mark always visible at the throat
(iconographic, PEGI-12 safe), gallows-tree silhouette behind her
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
young woman wrongfully hanged at the founding of the gallows-town,
noose-frayed white shift, eyes painted shut so her image cannot judge,
bare feet leaving no print, faint rope-mark always visible at the throat
(iconographic, PEGI-12 safe), gallows-tree silhouette behind her,
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
  - `Dark Gothic Fantasy` 3.01 @ 0.5   ← Ash-Mourners faction LoRA
- **sampler:** DPM++ 2M Karras
- **steps:** 30
- **cfg:** 6.5
- **width × height:** 832 × 1216
- **clip skip:** 2

> **Deviation note:** Lore-locked / curse-bound Warlord — she predates the factions. Closest existing
pipeline_spec faction style is Ash-Mourners (Victorian mourning + no-shadow
figures). Faction LoRA stack stays Ash-Mourners for reproducibility. PEGI-12
guard is sharper here: rope-mark MUST read as iconography, not injury — flag
for re-roll if the first pass produces visible bruising or trauma.

---

## Seed

- **seed:** 114242
- **rationale:** Warlord #11, formula `warlord_number × 10000 + 4242` (per `_template.md` Warlord rule). Sits clear of all five faction common-card seed ranges.

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/warlords/w11_the_saint_that_should_not_hang.png`
- **iterations_path:** `art_iterations/W11_the_saint_that_should_not_hang/`
- **alt_arts:** ["mastery_skin"]   ← Tier-4 mastery cosmetic per `warlord_tiers_v0.md` (W1)
- **idle_loop_frames:** 4           ← Warlords get 4 per `art_direction.md` §3
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed114242_v1 | first pass — accept / iterate |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — dusk-purple accent, not blue or fuchsia
- [ ] Body-horror tolerance — no-shadow / Victorian-mourning-grotesque present, no explicit gore
- [ ] Composition — focal figure dominates, atmospheric depth in background
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px (the in-hand card size)
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **Warlord-signature flagship presence** — silhouette readable from across the screen, costume / props clearly faction-coded
- [ ] **APPROVED** — Paul's signature once landed
