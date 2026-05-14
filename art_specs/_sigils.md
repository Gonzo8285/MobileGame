# Faction sigil glyph spec — 96×96 flat silhouettes

Authored over the B3.0f heartbeat cycle (1 sigil per run). Source prose stubs: `IMAGE-GEN-SHOTLIST.md` §5 (lines 304, 326, 348, 370, 392). Universal prefix and negative-prompt baseline are *deliberately divergent* from `pipeline_spec.md` §3.1/§3.6 — those drive painterly oil-paint card heroes; sigils need to land as flat-vector silhouettes readable at 96×96 thumbnail.

## Generation conventions (apply to all 5)

- **Native render size:** 1024×1024 SDXL → centre-crop or LANCZOS down to 96×96 PNG-24 RGBA on transparent background.
- **Negative prompt overrides:** push away from the painterly stack — add `oil paint texture, brushwork, painterly, photographic depth, atmospheric haze, gradient, soft shading, 3d render, photographic, low-key lighting` on top of the standard PEGI/anti-distortion negatives.
- **LoRA stack:** none currently resolved. The shotlist's §"open Qs" line 466 flagged "simple silhouette icon LoRA TBD". For first-pass generation: run prompt-only (no LoRA loaders); rely on `flat vector icon, silhouette, single solid colour` in the positive prompt and `painterly, brushwork, gradient` in the negative. **If first batch reads too painterly,** queue a follow-on `D-LORA-SIGIL` to source a flat-vector / icon-style SDXL LoRA from Civitai (search terms: "flat icon", "silhouette logo", "minimal vector SDXL") and re-run.
- **Seed convention:** `200000 + (faction_tag × 100)`. Sigil seed range = 200400–200800. Clear of all existing ranges (commons 40000–94040, warlord 14242–114242, enemies 90000–94040).
- **Workflow file:** runs against `pipeline_setup/workflow_gallowfell_card.json` BUT with the entire LoRA chain bypassed (every LoraLoader weight zeroed) per the workflow's `extra.lora_weight_protocol` field. Sampler / steps / CFG locked unchanged: dpmpp_2m / karras / 30 / 6.5. EmptyLatentImage swap: 1024×1024 (not the card-default 832×1216).
- **Output path:** `art/sigils/<faction_id>_sigil.png` (96×96 crop) + `art_iterations/_sigils/<faction_id>_sigil_1024.png` (full-size archive).
- **Composition tier:** `sigil_glyph` (new tier; not in §3.4 — bypasses portrait/landscape composition entirely).

---

## S1 — Iron Penitents (AUTHORED 2026-05-14 09:17 UTC)

**card_id:** sigil_iron_penitents
**faction:** iron_penitents (tag 4)
**seed:** 200400
**native_size:** 1024×1024
**output_size:** 96×96
**output_path:** `art/sigils/iron_penitents_sigil.png`

**Subject description (≤30 words):**
Tarnished brass execution mask in profile, rope coiled once beneath the chin, hammer-haft crossed behind. Iconic, symbol-like, instantly readable as Penitent zealotry at thumbnail scale.

**Resolved positive prompt:**
```
flat vector icon, silhouette logo, single solid colour, heraldic emblem,
minimal graphic design, faction sigil glyph, centred composition,
isolated on transparent background,
tarnished brass execution-mask in strict profile facing left,
rope coiled once beneath the chin, hammer-haft crossed behind the mask,
hammer-and-rope motif, religious-order seal aesthetic, monastic iconography,
clean negative space, no internal shading, no texture,
thick clean silhouette readable at 96 pixels,
single accent colour rust-red on tarnished brass,
medieval guild crest, woodcut clarity,
sharp focus, high contrast, masterpiece quality
```

**Resolved negative prompt (sigil-specific override stack):**
```
oil paint texture, brushwork, painterly, photographic depth, atmospheric haze,
gradient, soft shading, volumetric lighting, 3d render, photographic, low-key lighting,
realistic skin, realistic eyes, anatomical detail, photoreal,
multiple subjects, scene, background scenery, environment, landscape,
anime, cartoon, cel shaded, disney, pixar, chibi, kawaii,
text, watermark, signature, logo banner, frame, border, UI elements,
explicit gore, severed limbs, exposed organs, blood pools,
deformed, extra limbs, malformed face,
blurry, low quality, jpeg artifacts, low resolution
```

**LoRA stack:** none (prompt-only first pass; faction LoRAs explicitly bypassed — they drive painterly texture which fights the flat-silhouette goal).

**Validation checklist (S1-specific):**
1. Mask reads as execution-mask, not generic helmet or skull. Profile orientation faces left.
2. Rope visible coiled beneath chin (single coil — multi-coil would muddy at 96×96).
3. Hammer-haft visibly crossed behind the mask, not in front.
4. Silhouette is one continuous shape (or ≤2 high-contrast layers) — no gradient fills, no painterly brush.
5. Accent colour reads as rust-red on tarnished brass, NOT gold and NOT pure red.
6. Body-horror restraint: mask is the symbol, no face beneath, no implied wound — PEGI-12.
7. Thumbnail test: downsample to 96×96 and view at 1× UI scale; must still read "execution mask".

**Deviation notes:**
- Departs from `pipeline_spec.md` §3.1 painterly global style by design. Sigils are UI-tier flat icons, not card hero art.
- Bypasses §3.4 portrait/landscape composition entirely — uses `sigil_glyph` composition tier (new).
- Universal prefix `{UNIVERSAL_PREFIX}` from `IMAGE-GEN-SHOTLIST.md` §5 frame-pack template is the painterly card prefix — NOT applied here. The sigil-specific prefix above replaces it.

---

## S2 — Ash-Mourners (PENDING — next heartbeat)

Prose stub source: `IMAGE-GEN-SHOTLIST.md` line 326 — "raven-quill crossed over a shrouded skull, 96×96 silhouette."

Seed: 200500. Accent: dusk-purple on parchment-cream.

---

## S3 — Coven of the Black Mire (PENDING — next heartbeat)

Prose stub source: `IMAGE-GEN-SHOTLIST.md` line 348 — "demon-coin disc inside a hex-sign briar wreath, 96×96."

Seed: 200600. Accent: bog-green on bone-white.

---

## S4 — The Last Legion (PENDING — next heartbeat)

Prose stub source: `IMAGE-GEN-SHOTLIST.md` line 370 — "crossed ironwood batons over a brass gorget, 96×96."

Seed: 200700. Accent: smoke-blackened brass on coal-grey.

---

## S5 — Skinward Pact (PENDING — next heartbeat)

Prose stub source: `IMAGE-GEN-SHOTLIST.md` line 392 — "antler-crown over a bound seedling, 96×96."

Seed: 200800. Accent: bark-brown on bone-white.

---

## Open questions (B3.0f → flag for Paul)

1. **LoRA route confirmation.** First-pass = prompt-only, no LoRA. Acceptable, or queue `D-LORA-SIGIL` immediately to source a flat-vector/icon SDXL LoRA before any sigil renders?
2. **Hand-author fallback.** If SDXL flat-icon output looks painterly even with overridden negatives, fall back to Photopea/Krita hand-author from a single SDXL reference render? (Shotlist Q4 explicitly offered this route — cheaper than chasing a LoRA.)
3. **Crop method.** Centre-crop 1024×1024 → 96×96, or LANCZOS downsample? Centre-crop preserves silhouette weight; LANCZOS gives smoother edges but can blur narrow features (rope coil, antler tine). Default = LANCZOS unless 96×96 reads muddy, then re-render at 256×256 native and centre-crop.
4. **Sigil composition tier addition.** Introduce `sigil_glyph` as a new composition tier in `pipeline_spec.md` §3.4 explicitly, or keep it as a sigils-file-only convention? Either works; explicit-in-§3.4 is more discoverable for future contributors.
