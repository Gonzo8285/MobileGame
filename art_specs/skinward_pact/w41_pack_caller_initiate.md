# Per-card art spec — Pack-Caller Initiate

---

## Card identity

- **card_id:** W41
- **display_name:** Pack-Caller Initiate
- **faction:** skinward_pact
- **card_type:** UNIT
- **rarity:** UNCOMMON
- **role:** spine (Phase 2.13 N3 — E3 Beast-Summon mid-game velocity)

---

## Subject description (max ~30 words)

```
Pack-Caller Initiate — young druid-warrior mid-howl, two-part horn raised to lips, wolf-pelt half-cloak across one shoulder, antler-fragment necklace, bark-brown war-paint, twilight cinderwood grove
```

---

## Resolved prompt

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
antler-crown sprouting through bone, hide cloak layered, mismatched eyes,
smoke-trailing fingers, druidic shaman with phyrexian undertones,
bark-brown accent, cinderwood-grove background,
Pack-Caller Initiate — young druid-warrior mid-howl, two-part horn raised to lips, wolf-pelt half-cloak across one shoulder, antler-fragment necklace, bark-brown war-paint, twilight cinderwood grove,
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
  - `Mythical Forest Style [SDXL]` @ 0.5   ← Skinward Pact faction LoRA (shared with Coven)
  - `Mythical Creatures` SDXL @ 0.5         ← Skinward Pact faction LoRA
- **sampler:** DPM++ 2M Karras
- **steps:** 30
- **cfg:** 6.5
- **width × height:** 832 × 1216
- **clip skip:** 2

> _empty — uses master defaults_

---

## Seed

- **seed:** 84141
- **rationale:** card_id digits → 41, formula 80000 + 101 × 41 (Skinward Pact faction tag = 8)

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/skinward_pact/w41_pack_caller_initiate.png`
- **iterations_path:** `art_iterations/W41_pack_caller_initiate/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-26 | spec_authored | Phase 2.13 N3 — art spec authored by Controller. Card .tres at `game/data/cards/skinward_pact/W41.tres`. Two-part horn motif matches the flavour text "The call is two parts" — visual hook for the once-per-turn draw trigger. |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — bark-brown accent, not red-brown or olive
- [ ] Druidic-with-phyrexian-undertones present, no explicit gore
- [ ] Composition — focal figure dominates, atmospheric depth
- [ ] Two-part horn legible (so flavour-mechanic tie reads at thumbnail size)
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
