# STAGE A — Warlord Anchor Generation Brief

_Authored 2026-05-26 by Controller. Single-handoff doc for the D-VALIDATE-1 Stage-A pass. The GPU operator (Paul, or .151 with a RunPod pod, or Claude Code) reads ONLY this file to run Stage A end-to-end. No cross-doc lookups required._

**Source of truth:** consolidated from `pipeline_spec.md` §2/§3/§5 + `art_direction.md` §1/§1a + `art_specs/warlords/w1..w5.md`.

**Cost / time envelope:** ~15 min GPU on RunPod A5000 24GB ($0.34/hr ≈ £0.07 total) or ~10 min on cloud Flux Dev ($0.025 × 5 = $0.125 ≈ £0.10). Local RTX 2050 is feasible but slow (~10 min per tile, 50 min total).

---

## 0. Pre-flight (operator confirms BEFORE first generation)

- [ ] ComfyUI live (local OR RunPod pod). If RunPod, smoke test B3.0a has passed (workflow runs end-to-end on the pod).
- [ ] Base checkpoint installed: **`juggernautXL_v9`** (Civitai 133005).
- [ ] Style LoRAs installed (apply to all 5 tiles):
    - `ClassipeintXL` v2.1 (Civitai 127139)
    - `Dark Fantasy LORA` v1 (Civitai 932379)
    - `Elden Ring Style` v1.0 (Civitai 457103)
- [ ] Faction LoRAs installed (per-tile, see each block):
    - `RPGNightmareXL` v1.0 (Civitai 182002) — W1 only
    - `gothic cathedral interior` v1.0 (Civitai 1904235) — W2 only
    - `Dark Gothic Fantasy` v3.01 (Civitai 293532) — W2 only
    - `Swamp people` v1.0 (Civitai 2134348) — W3 only
    - `Mythical Forest Style [SDXL]` v1.0 (Civitai 303030, trigger `ral-mytfrst`) — W3 + W5
    - `ArmorSentinel medieval armor style` v2 (Civitai 643451) — W4 only
    - `Mythical Creatures SDXL` (Civitai 218327) — W5 only
- [ ] Output dir `art_iterations/_anchors/` exists (and is empty for v1 pass).

If any of the above is "no", stop and resolve before generating.

---

## 1. Locked-for-this-batch common settings

These do **not** change per tile. If they need to change, the change is to `pipeline_spec.md` and the whole pipeline gets re-run — not a per-tile override.

| Param | Value |
|---|---|
| Checkpoint | `juggernautXL_v9` |
| Sampler | DPM++ 2M Karras |
| Steps | 30 |
| CFG | 6.5 |
| Width × Height | 832 × 1216 (0.685 portrait, matches card aspect) |
| Clip skip | 2 |
| Refiner | none |

### 1.1 Negative prompt (identical for every tile — paste verbatim)

```
anime, cartoon, cel shaded, disney, pixar, chibi, kawaii,
clean fantasy, bright saturated colours, oversaturated,
modern clothing, modern weapons, anachronisms,
text, watermark, signature, logo, frame, border, UI elements,
3d render, plastic, smooth skin, airbrushed, photoreal-realistic,
explicit gore, severed limbs, exposed organs, blood pools,
deformed hands, extra fingers, extra limbs, malformed face,
blurry, low quality, jpeg artifacts, low resolution
```

---

## 2. Tile A1 — Penance-Captain Vyrrun (Iron Penitents)

**Seed:** `14242` · **Output:** `art_iterations/_anchors/A1_w1_vyrrun_seed14242_v1.png`

**Faction LoRA stack** (layered on top of the 3 style LoRAs from §0):
- `RPGNightmareXL` v1.0 @ 0.4 _(cap 0.4 — PEGI 12)_

**Positive prompt:**

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
brass execution-mask iconography, hooded zealot, flagellant chains,
phyrexian-adjacent body-horror (implied not explicit), rust-red accent,
hammer and rope motif, religious dread, ash-and-cinder background,
led a flagellant column from cathedral ruins, believing he bleeds answers
from the gallows-tree, monarchy-era execution mask in tarnished brass,
hooded, flayed back showing scar-runes, hammer-and-rope chest plate,
upper body portrait, three-quarter pose, looking-into-camera,
single focal figure dominating frame, atmospheric blurred background,
volumetric haze, no text overlay, no logo, no watermark,
extremely detailed, sharp focus, professional, intricate brushwork,
volumetric lighting, oil-paint texture visible in highlights,
8k, hyper-detailed, masterpiece quality
```

**Anchor target:** rust-red palette, brass execution-mask motif, flagellant readability, MTG-painterly density.

---

## 3. Tile A2 — Court-Necromant Sieren (Ash-Mourners)

**Seed:** `24242` · **Output:** `art_iterations/_anchors/A2_w2_sieren_seed24242_v1.png`

**Faction LoRA stack:**
- `gothic cathedral interior` v1.0 @ 0.6
- `Dark Gothic Fantasy` v3.01 @ 0.5

**Positive prompt:**

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
gothic-cathedral funerary aesthetic, court-shroud robes, ink-stained hands,
raven-quill flourishes, no-shadow figures, dusk-purple accent,
catacomb-vault background, Victorian mourning sensibility,
last court mage of the dying Monarchy, signing death-warrants in her own
blood for forty years, ink-stained fingers, raven-feather quill, no shadow,
court-robes worn to grave-shrouds,
upper body portrait, three-quarter pose, looking-into-camera,
single focal figure dominating frame, atmospheric blurred background,
volumetric haze, no text overlay, no logo, no watermark,
extremely detailed, sharp focus, professional, intricate brushwork,
volumetric lighting, oil-paint texture visible in highlights,
8k, hyper-detailed, masterpiece quality
```

**Anchor target:** dusk-purple palette, Liliana-of-the-Veil tone, court-shroud + raven-quill motif, atmospheric haze.

---

## 4. Tile A3 — Marsh-Mother Eddra (Coven of the Black Mire)

**Seed:** `34242` · **Output:** `art_iterations/_anchors/A3_w3_eddra_seed34242_v1.png`

**Faction LoRA stack:**
- `Swamp people` v1.0 @ 0.5
- `Mythical Forest Style [SDXL]` v1.0 @ 0.5 _(trigger phrase `ral-mytfrst` already in prompt? — no; the LoRA fires on weight)_

**Positive prompt:**

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

**Anchor target:** bog-green palette, Lorwyn folkloric-grotesque without crossing cute, three-shadows-cast motif.

---

## 5. Tile A4 — Forge-Marshal Veska (The Last Legion)

**Seed:** `44242` · **Output:** `art_iterations/_anchors/A4_w4_veska_seed44242_v1.png`

**Faction LoRA stack:**
- `ArmorSentinel medieval armor style` v2 @ 0.6

**Positive prompt:**

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
soot-blackened cuirass, brass officer gorget, ironwood baton,
chain-bound hair, foundry-rivet armour, decayed-knight elden-ring scale,
brass accent, smoke-and-coal background,
Marshal of the Last Legion sent to pacify Gallowfell six years ago,
soot-blackened cuirass, brass officer's gorget, ironwood baton,
hair bound with chain, the smoke now tastes like her own blood,
upper body portrait, three-quarter pose, looking-into-camera,
single focal figure dominating frame, atmospheric blurred background,
volumetric haze, no text overlay, no logo, no watermark,
extremely detailed, sharp focus, professional, intricate brushwork,
volumetric lighting, oil-paint texture visible in highlights,
8k, hyper-detailed, masterpiece quality
```

**Anchor target:** brass palette, Elden Ring decayed-knight scale, foundry-rivet armour, smoke-and-coal background.

---

## 6. Tile A5 — Tree-Walker Mhar (Skinward Pact)

**Seed:** `54242` · **Output:** `art_iterations/_anchors/A5_w5_mhar_seed54242_v1.png`

**Faction LoRA stack:**
- `Mythical Forest Style [SDXL]` v1.0 @ 0.5
- `Mythical Creatures SDXL` @ 0.5

**Positive prompt:**

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
antler-crown sprouting through bone, hide cloak layered, mismatched eyes,
smoke-trailing fingers, druidic shaman with phyrexian undertones,
bark-brown accent, cinderwood-grove background,
born at the foot of the felled god-tree, layered hide-cloak,
antler-crown sprouting fresh leaves through bone, mismatched eyes,
smoke trailing from his fingers, second heart replaced by a seed,
upper body portrait, three-quarter pose, looking-into-camera,
single focal figure dominating frame, atmospheric blurred background,
volumetric haze, no text overlay, no logo, no watermark,
extremely detailed, sharp focus, professional, intricate brushwork,
volumetric lighting, oil-paint texture visible in highlights,
8k, hyper-detailed, masterpiece quality
```

**Anchor target:** bark-brown palette, druidic-with-phyrexian-undertones, antler-crown-through-bone, cinderwood-grove.

---

## 7. Post-render anchor validation (Paul + Controller co-review)

Lay out all 5 tiles in a 5-up grid. Tick each line. Do NOT proceed to Stage B until every line is ticked.

- [ ] **Same-game test.** Do all 5 read as the same game? Same brushwork era, same painterly density, same atmospheric depth.
- [ ] **Palette separation.** Rust-red ≠ brass ≠ bark-brown without bleed; dusk-purple ≠ bog-green even at thumbnail.
- [ ] **Faction lexicon lock.** Can each Warlord serve as the future "looks like a Vyrrun-faction card" instruction to a contractor? Palette + motif + tone unambiguous?
- [ ] **Body-horror tolerance.** Phyrexian undertone (Mhar, Eddra) and rope-mark iconography hold without crossing PEGI 12. No explicit gore, no severed limbs, no exposed organs.
- [ ] **Composition tier.** Focal figure dominates. Oil-paint texture reads as oil, not 3D render, not anime.
- [ ] **Brushwork.** Visible brush strokes. MTG-painterly density. Not smooth gradient-render.
- [ ] **Thumbnail-readable.** Each tile readable at 200×280 px (the in-hand card size).

If yes-to-all → **lock the 5 anchors**: copy from `art_iterations/_anchors/` to `art/warlords/` AND `art_specs/_anchors/` as the canonical faction reference. Proceed to Stage B (D-VALIDATE-1 second half: P1 Cathedral Brother / Self-Scourge / M Pall-Bearer / C1 Bog-Spawn).

If no-to-any → identify the failing tile (or axis), modify the relevant section of `pipeline_spec.md` OR the per-Warlord spec, regenerate the failing tile only. Do NOT proceed to Stage B with an unlocked anchor.

---

## 8. What I checked before writing this brief (audit log)

- All 5 prompt files (`art_specs/warlords/w1..w5.md`) present and structurally identical.
- Each has: card identity, subject description, resolved prompt, negative override (empty → baseline), pipeline parameters, seed, output paths, idle-loop frames = 4, validation checklist.
- All 5 use same checkpoint (`juggernautXL_v9`), same 3 style LoRAs (`ClassipeintXL` 0.8, `Dark Fantasy LORA` 0.8, `Elden Ring Style` 0.5), same sampler/steps/CFG/dims/clip-skip.
- Faction LoRAs differ per-tile and match `pipeline_spec.md` §2.2 exactly.
- Seeds follow `warlord_number × 10000 + 4242` rule: 14242, 24242, 34242, 44242, 54242. No collisions with the faction common-card seed ranges.
- Faction accents (rust-red / dusk-purple / bog-green / brass / bark-brown) match `art_direction.md` §0 locked palette and `pipeline_spec.md` §3.2.
- Negative-prompt baseline (§3.6 of pipeline_spec, inlined as §1.1 above) covers PEGI 12 (`explicit gore, severed limbs, exposed organs, blood pools`) + anti-anime/cartoon + anti-3D-render + anti-text/watermark.

**One cosmetic finding (non-blocking):** all 5 spec files carry the comment `← Tier-4 mastery cosmetic per warlord_tiers_v0.md (W1)` — the `(W1)` is a copy-paste artefact in w2..w5. Worth fixing in a future cleanup pass but does not affect generation.

— Controller, 2026-05-26
