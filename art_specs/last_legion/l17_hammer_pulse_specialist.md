# Per-card art spec — Hammer-Pulse Specialist

---

## Card identity

- **card_id:** L17
- **display_name:** Hammer-Pulse Specialist
- **faction:** the_last_legion
- **card_type:** UNIT
- **rarity:** COMMON
- **role:** standard

---

## Subject description (max ~30 words)

```
specialist with hammer-pulse weapon braced, foundry-rivet armour, brass officer gorget, chain-bound hair, residual brass-glow at hammer head, smoke-and-coal forge-haze
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
specialist with hammer-pulse weapon braced, foundry-rivet armour, brass officer gorget, chain-bound hair, residual brass-glow at hammer head, smoke-and-coal forge-haze,
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

- **seed:** 71717
- **rationale:** card_id digits → 17, formula 70000 + 101 × 17 (Last Legion faction tag = 7)

> Locked once an accepted image is produced. Change prompt/LoRA weights, not the seed.

---

## Output

- **output_path:** `art/last_legion/l17_hammer_pulse_specialist.png`
- **iterations_path:** `art_iterations/L17_hammer_pulse_specialist/`
- **alt_arts:** []
- **idle_loop_frames:** 2
- **treatment_compatibility:** all

---

## Notes / iteration history

| Date | Iteration | Note |
|---|---|---|
| 2026-05-XX | seed71717_v1 | first pass — accept / iterate |

---

## Validation checklist

- [ ] Reads as Gallowfell — coherent with reference-sheet tiles
- [ ] Faction palette holds — brass accent, not gold or copper
- [ ] Decayed-knight elden-ring scale present, no explicit gore
- [ ] Composition — focal figure (or environment) dominates, atmospheric depth
- [ ] Brushwork — reads as oil painting, not 3D render or anime
- [ ] Thumbnail-readable at 200×280 px
- [ ] PEGI 12 compliant — no severed limbs / exposed organs / blood pools
- [ ] **APPROVED** — Paul's signature once landed
