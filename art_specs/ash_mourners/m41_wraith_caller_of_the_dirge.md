# Per-card art spec — Wraith-Caller of the Dirge

---

## Card identity

- **card_id:** M41
- **display_name:** Wraith-Caller of the Dirge
- **faction:** ash_mourners
- **card_type:** UNIT
- **rarity:** UNCOMMON
- **role:** spine (Phase 2.13 N1 — splash spine into Resurrect-Spam)

---

## Subject description (max ~30 words)

```
Wraith-Caller of the Dirge — hooded mourner mid-incantation, wraith-shape coalescing from her open palm, dirge-bell at her belt, dusk-purple smoke ribbons, court-shroud robe
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
Wraith-Caller of the Dirge — hooded mourner mid-incantation, wraith-shape coalescing from her open palm, dirge-bell at her belt, dusk-purple smoke ribbons, court-shroud robe,
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

- **seed:** 54141
- **rationale:** card_id digits → 41, formula 50000 + 101 × 41 (Ash-Mourners faction tag = 5)

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/ash_mourners/m41_wraith_caller_of_the_dirge.png`
- **iterations_path:** `art_iterations/M41_wraith_caller_of_the_dirge/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-26 | spec_authored | Phase 2.13 N1 — art spec authored by Controller. Card .tres at `game/data/cards/ash_mourners/M41.tres`. |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — dusk-purple accent, not red-purple or violet-blue
- [ ] Gothic-cathedral funerary aesthetic present, no explicit gore
- [ ] Composition — focal figure dominates, atmospheric depth
- [ ] Wraith-shape reads as nascent/coalescing (not full apparition) so card text intent is legible
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
