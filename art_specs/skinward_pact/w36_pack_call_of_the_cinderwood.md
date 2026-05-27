# Per-card art spec — Pack-Call of the Cinderwood

---

## Card identity

- **card_id:** W36
- **display_name:** Pack-Call of the Cinderwood
- **faction:** skinward_pact
- **card_type:** SPELL
- **rarity:** UNCOMMON
- **role:** event

---

## Subject description (max ~30 words)

```
great pack-call ritual in cinderwood-grove clearing, antler-crown ringed altar, hide cloak banners, smoke-trailing fires, bark-brown ash, mismatched moonlight, druidic phyrexian undertone summons
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
great pack-call ritual in cinderwood-grove clearing, antler-crown ringed altar, hide cloak banners, smoke-trailing fires, bark-brown ash, mismatched moonlight, druidic phyrexian undertone summons,
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

- **seed:** 83636
- **rationale:** card_id digits → 36, formula 80000 + 101 × 36 (Skinward Pact faction tag = 8)

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/skinward_pact/w36_pack_call_of_the_cinderwood.png`
- **iterations_path:** `art_iterations/W36_pack_call_of_the_cinderwood/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed83636_v1 | first pass — accept / iterate |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — bark-brown accent, not red-brown or olive
- [ ] Druidic-with-phyrexian-undertones present, no explicit gore
- [ ] Composition — focal figure (or environment) dominates, atmospheric depth
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
