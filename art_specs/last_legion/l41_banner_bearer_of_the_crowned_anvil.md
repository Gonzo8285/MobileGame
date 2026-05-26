# Per-card art spec — Banner-Bearer of the Crowned Anvil

---

## Card identity

- **card_id:** L41
- **display_name:** Banner-Bearer of the Crowned Anvil
- **faction:** last_legion
- **card_type:** UNIT
- **rarity:** UNCOMMON
- **role:** spine (Phase 2.13 N2 — D3 Banner-Buff keystone)

---

## Subject description (max ~30 words)

```
Banner-Bearer of the Crowned Anvil — soot-blackened legionnaire hoisting a hammered-brass standard, anvil-sigil crown atop pole, brass officer gorget, chain-bound polearm braced for advance, foundry-rivet armour
```

---

## Resolved prompt

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
soot-blackened cuirass, brass officer gorget, ironwood baton,
chain-bound hair, foundry-rivet armour, decayed-knight elden-ring scale,
brass accent, smoke-and-coal background,
Banner-Bearer of the Crowned Anvil — soot-blackened legionnaire hoisting a hammered-brass standard, anvil-sigil crown atop pole, brass officer gorget, chain-bound polearm braced for advance, foundry-rivet armour,
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
  - `ArmorSentinel medieval armor style` v2 @ 0.6   ← Last Legion faction LoRA
- **sampler:** DPM++ 2M Karras
- **steps:** 30
- **cfg:** 6.5
- **width × height:** 832 × 1216
- **clip skip:** 2

> _empty — uses master defaults_

---

## Seed

- **seed:** 74141
- **rationale:** card_id digits → 41, formula 70000 + 101 × 41 (Last Legion faction tag = 7)

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/last_legion/l41_banner_bearer_of_the_crowned_anvil.png`
- **iterations_path:** `art_iterations/L41_banner_bearer_of_the_crowned_anvil/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-26 | spec_authored | Phase 2.13 N2 — art spec authored by Controller. Card .tres at `game/data/cards/last_legion/L41.tres`. Banner reads as anvil-crown silhouette (matches "Crowned Anvil" flavour) — same banner-as-object motif as L13/L32/L33/L36/L37/L40 so the row-buff trigger is visually legible. |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — brass accent, not gold or copper
- [ ] Banner-as-object dominates upper third of frame (so D3 Banner-Buff lane-trigger reads at thumbnail size)
- [ ] Composition — focal figure dominates, atmospheric depth
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
