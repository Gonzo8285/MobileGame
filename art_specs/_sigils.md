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

## S2 — Ash-Mourners (AUTHORED 2026-05-14 — heartbeat)

**card_id:** sigil_ash_mourners
**faction:** ash_mourners (tag 5)
**seed:** 200500
**native_size:** 1024×1024
**output_size:** 96×96
**output_path:** `art/sigils/ash_mourners_sigil.png`

**Subject description (≤30 words):**
Two raven-quills crossed in saltire over a shrouded skull, court-shroud pleat draped beneath. Iconic, symbol-like, instantly readable as Ash-Mourner funeral-clerks at thumbnail scale.

**Resolved positive prompt:**
```
flat vector icon, silhouette logo, single solid colour, heraldic emblem,
minimal graphic design, faction sigil glyph, centred composition,
isolated on transparent background,
two raven-quills crossed in saltire (X-shape) over a hooded skull draped in court-shroud pleat,
shroud falling in two clean folds beneath the chin line, skull viewed front-on,
quill-feather-tips pointing upward-outward, nib-points downward-inward,
funerary court-clerk iconography, mourning-order seal aesthetic,
clean negative space, no internal shading, no texture,
thick clean silhouette readable at 96 pixels,
single accent colour dusk-purple on parchment-cream,
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
explicit gore, severed limbs, exposed organs, blood pools, exposed brain,
deformed, extra limbs, malformed face, screaming skull, jaw agape,
blurry, low quality, jpeg artifacts, low resolution
```

**LoRA stack:** none (prompt-only first pass; faction LoRAs explicitly bypassed — they drive painterly texture which fights the flat-silhouette goal).

**Validation checklist (S2-specific):**
1. Quills cross cleanly in saltire (X), not parallel or single — must read as two-feather crossing.
2. Quill feather-tips point upward-outward, nibs point downward-inward (heraldic standard).
3. Skull reads as skull beneath shroud, not as a generic hooded figure or executioner's mask (kept distinct from Iron Penitents S1).
4. Shroud-pleat visible as two clean folds — single drape would lose the "court-shroud" cue; more than two muddies at 96×96.
5. Silhouette is one continuous shape (or ≤2 high-contrast layers) — no gradient fills, no painterly brush.
6. Accent colour reads as dusk-purple on parchment-cream, NOT royal-blue and NOT magenta-pink.
7. Body-horror restraint: skull is symbol-iconographic, no jaw agape, no exposed teeth, no implied scream — PEGI-12.
8. Thumbnail test: downsample to 96×96 and view at 1× UI scale; must still read "two crossed quills over a shrouded skull".

**Deviation notes:**
- Same divergence from `pipeline_spec.md` §3.1 / §3.4 as S1 — flat-vector silhouette, not painterly portrait. Sigil-specific composition tier `sigil_glyph` applies.
- Skull-iconography choice intentionally restrained vs. the painterly card-hero Ash-Mourner motifs (censer-smoke, catacomb-vault, raven-feather drift) — those don't survive 96×96 downscale. Quill-cross-over-skull is the single legible cue at thumbnail scale.
- Universal prefix `{UNIVERSAL_PREFIX}` from `IMAGE-GEN-SHOTLIST.md` §5 frame-pack template NOT applied — the sigil-specific prefix above replaces it (same convention as S1).

---

## S3 — Coven of the Black Mire (AUTHORED 2026-05-15 — heartbeat)

**card_id:** sigil_coven
**faction:** coven (tag 6)
**seed:** 200600
**native_size:** 1024×1024
**output_size:** 96×96
**output_path:** `art/sigils/coven_sigil.png`

**Subject description (≤30 words):**
A demon-coin disc inscribed with a single hex-sign at centre, encircled by a closed briar wreath. Iconic, symbol-like, instantly readable as Coven swamp-witch pact-magic at thumbnail scale.

**Resolved positive prompt:**
```
flat vector icon, silhouette logo, single solid colour, heraldic emblem,
minimal graphic design, faction sigil glyph, centred composition,
isolated on transparent background,
demon-coin disc at centre stamped with a single hex-sign mark,
closed briar wreath encircling the coin, thorn-and-tangle ring,
three thorn points evenly spaced around the wreath perimeter,
coin-and-thorns motif, pact-magic seal aesthetic, folkloric grotesque iconography,
clean negative space, no internal shading, no texture,
thick clean silhouette readable at 96 pixels,
single accent colour bog-green on bone-white,
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
pentagram, satanic imagery, inverted cross, occult symbols of real-world religion,
deformed, extra limbs, malformed face,
blurry, low quality, jpeg artifacts, low resolution
```

**LoRA stack:** none (prompt-only first pass; faction LoRAs explicitly bypassed — they drive painterly texture which fights the flat-silhouette goal).

**Validation checklist (S3-specific):**
1. Coin reads as a coin (round disc, ringed edge) — not as a generic shield, seal, or full medallion.
2. Hex-sign stamped at the coin's centre reads as folkloric/witch-mark, not as a five-pointed pentagram or any real-world occult symbol (PEGI-12 + IP-clean — see negative prompt explicit exclusions).
3. Briar wreath fully encircles the coin (closed ring) — broken wreath would read as olive-laurel and lose Coven flavour.
4. Three thorn points visibly project around the wreath perimeter — fewer reads as plain ring, more muddies at 96×96. (Threes are a Coven motif — three-shadows-cast, per `pipeline_spec.md` §3.2.)
5. Silhouette is one continuous shape (or ≤2 high-contrast layers) — no gradient fills, no painterly brush.
6. Accent colour reads as bog-green on bone-white, NOT lime-green and NOT neon-green (matches the Coven palette guard from `art_specs/coven/` A-SPEC-3 validation lines).
7. Body-horror restraint: no fungal growths, no eyes-in-the-coin, no dripping ichor — the sigil is symbolic shorthand for pact-magic, not a body-horror illustration. PEGI-12.
8. Thumbnail test: downsample to 96×96 and view at 1× UI scale; must still read "coin inside thorn-wreath".

**Deviation notes:**
- Same divergence from `pipeline_spec.md` §3.1 / §3.4 as S1/S2 — flat-vector silhouette, not painterly portrait. Sigil-specific composition tier `sigil_glyph` applies.
- Hex-sign chosen over a faction-letter or pictographic stamp on the coin face to keep the silhouette legible at 96×96 — a letter would read as text (negative-prompted) and a pictograph would compete with the briar wreath for shape weight.
- Negative prompt explicitly excludes `pentagram, satanic imagery, inverted cross, occult symbols of real-world religion` — Coven aesthetic per `cards_coven_v1.md` + `lore_gallowfell.md` is folkloric-grotesque (swamp witch, hexes, three-shadows), NOT modern-occult; this guard keeps SDXL from drifting toward the wrong reference cluster and keeps PEGI-12 clean of religious-controversy flags.
- Universal prefix `{UNIVERSAL_PREFIX}` from `IMAGE-GEN-SHOTLIST.md` §5 frame-pack template NOT applied — the sigil-specific prefix above replaces it (same convention as S1/S2).

---

## S4 — The Last Legion (AUTHORED 2026-05-15 — heartbeat)

**card_id:** sigil_last_legion
**faction:** last_legion (tag 7)
**seed:** 200700
**native_size:** 1024×1024
**output_size:** 96×96
**output_path:** `art/sigils/last_legion_sigil.png`

**Subject description (≤30 words):**
Two ironwood batons crossed in saltire over a brass officer's gorget, single foundry-rivet at the gorget centre. Iconic, symbol-like, instantly readable as Last Legion command-cadre at thumbnail scale.

**Resolved positive prompt:**
```
flat vector icon, silhouette logo, single solid colour, heraldic emblem,
minimal graphic design, faction sigil glyph, centred composition,
isolated on transparent background,
two ironwood batons crossed in saltire (X-shape) over a brass officer's gorget,
gorget curved as a half-moon collar plate beneath the baton crossing,
single foundry-rivet stamped at the gorget centre,
baton tips capped with brass ferrules pointing upward-outward, butt-ends downward-inward,
batons-and-gorget motif, military command-cadre seal aesthetic, foundry-order iconography,
clean negative space, no internal shading, no texture,
thick clean silhouette readable at 96 pixels,
single accent colour smoke-blackened brass on coal-grey,
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
modern military insignia, nazi iconography, real-world military rank symbols,
swastika, iron cross, real-world flags, real-world unit patches,
deformed, extra limbs, malformed face,
blurry, low quality, jpeg artifacts, low resolution
```

**LoRA stack:** none (prompt-only first pass; faction LoRAs explicitly bypassed — they drive painterly texture which fights the flat-silhouette goal).

**Validation checklist (S4-specific):**
1. Batons cross cleanly in saltire (X), not parallel or single — must read as two-baton crossing (heraldic standard, mirrors S2 raven-quill saltire convention).
2. Baton tips point upward-outward with brass ferrules visible; butt-ends downward-inward. Ironwood haft thickness consistent along the full baton length — no taper that would read as spear or sword.
3. Gorget reads as a half-moon officer's collar plate beneath the crossing point, NOT as a full breastplate, full shield, or chain-mail bib. Curvature is the single legibility cue.
4. Single foundry-rivet stamped at gorget centre — visible as a small circular punch-mark, NOT multiple rivets (multi-rivet would muddy at 96×96 and read as armour pattern instead of unit insignia).
5. Silhouette is one continuous shape (or ≤2 high-contrast layers) — no gradient fills, no painterly brush.
6. Accent colour reads as smoke-blackened brass on coal-grey, NOT gold and NOT copper (matches Last Legion palette guard from `art_specs/last_legion/` A-SPEC-4 validation lines).
7. Body-horror restraint: gorget is the worn-officer-insignia symbol, no implied wound or decay-leak from beneath — the decayed-knight elden-ring scale that defines Legion card-hero art is deliberately absent at the sigil tier (sigils are command-cadre iconography, not battle-trauma vignettes). PEGI-12.
8. IP-clean guard: silhouette must NOT inadvertently echo any real-world military insignia, rank pip, unit patch, or 20th-century symbology — negative prompt explicitly excludes nazi/iron-cross/swastika/real-world-military markers. If a render reads as a real-world military badge, re-seed.
9. Thumbnail test: downsample to 96×96 and view at 1× UI scale; must still read "crossed batons over a half-moon gorget".

**Deviation notes:**
- Same divergence from `pipeline_spec.md` §3.1 / §3.4 as S1/S2/S3 — flat-vector silhouette, not painterly portrait. Sigil-specific composition tier `sigil_glyph` applies.
- Single-rivet choice over multi-rivet or rivet-row stamps on the gorget face to keep the silhouette legible at 96×96 — a row of rivets would compete with the baton-crossing line-weight and muddy the thumbnail.
- Decayed-knight motif intentionally restrained vs. the painterly card-hero Legion motifs (soot-blackened cuirass, chain-bound hair, foundry-rivet armour, smoke-and-coal background) — those don't survive 96×96 downscale. Batons-over-gorget is the single legible cue at thumbnail scale and reads cleanly as "command/officer" rather than "rank-and-file soldier".
- Negative prompt explicitly excludes real-world military insignia / nazi iconography / iron cross / swastika / unit patches — Last Legion aesthetic per `cards_last_legion_v1.md` + `pipeline_spec.md` §3.2 is grimdark-fantasy military order, NOT 20th-century military; this guard keeps SDXL from drifting toward the wrong reference cluster (military-emblem-tagged training data) and keeps PEGI-12 clean of real-world-controversy flags. Same protective-negative pattern as S3 used against pentagram/satanic drift.
- Universal prefix `{UNIVERSAL_PREFIX}` from `IMAGE-GEN-SHOTLIST.md` §5 frame-pack template NOT applied — the sigil-specific prefix above replaces it (same convention as S1/S2/S3).

---

## S5 — Skinward Pact (AUTHORED 2026-05-15 — heartbeat)

**card_id:** sigil_skinward_pact
**faction:** skinward_pact (tag 8)
**seed:** 200800
**native_size:** 1024×1024
**output_size:** 96×96
**output_path:** `art/sigils/skinward_pact_sigil.png`

**Subject description (≤30 words):**
Antler-crown sprouting over a bound seedling. Five antler points fan upward from a central horizontal binding cord that wraps a single upright sapling stem. Iconic, druidic, bark-brown silhouette.

**Resolved positive prompt:**
```
flat vector icon, silhouette logo, single solid colour, heraldic emblem,
minimal graphic design, faction sigil glyph, centred composition,
isolated on transparent background,
five-pointed antler crown fanning upward from a horizontal binding cord,
single upright sapling stem rising through the centre of the cord-binding,
two small leaves on the sapling stem (one left, one right, mid-height),
antler tines stylised as a heraldic crown (rack-of-five with central tine tallest),
binding-cord coil visible as three short bands at the crown's base,
antler-crown-and-seedling motif, druidic-wilds clan-mark aesthetic, beast-pact iconography,
clean negative space, no internal shading, no texture,
thick clean silhouette readable at 96 pixels,
single accent colour bark-brown on bone-white,
medieval guild crest, woodcut clarity,
sharp focus, high contrast, masterpiece quality
```

**Resolved negative prompt (sigil-specific override stack):**
```
oil paint texture, brushwork, painterly, photographic depth, atmospheric haze,
gradient, soft shading, volumetric lighting, 3d render, photographic, low-key lighting,
realistic skin, realistic eyes, anatomical detail, photoreal,
realistic animal, taxidermy, mounted antler, severed deer head, exposed skull,
multiple subjects, scene, background scenery, environment, landscape,
anime, cartoon, cel shaded, disney, pixar, chibi, kawaii,
text, watermark, signature, logo banner, frame, border, UI elements,
explicit gore, severed limbs, exposed organs, blood pools,
real-world hunting trophy, real-world taxidermy mount, real-world deer/elk photograph,
deformed, extra limbs, malformed face, extra antlers, asymmetric antler-rack,
blurry, low quality, jpeg artifacts, low resolution
```

**LoRA stack:** none (prompt-only first pass; faction LoRAs explicitly bypassed — they drive painterly texture which fights the flat-silhouette goal). Same protocol as S1–S4.

**Validation checklist (S5-specific):**
1. Antler rack is heraldic-stylised five-point with the central tine tallest — NOT a realistic deer/elk antler. Asymmetric racks fail (heraldic crown must read as balanced).
2. Binding cord at the antler base visible as ≤3 short horizontal bands — NOT a knot, NOT a continuous wrap, NOT a chain. The cord is the "bound" cue.
3. Sapling stem rises through the cord-binding from below into the crown above — a single continuous vertical line, two small leaves flanking the stem mid-height. NOT a tree, NOT a branch fork, NOT a flower.
4. Silhouette is one continuous shape — antlers + cord + sapling read as a single emblem. The eye should not have to track three separate motifs at thumbnail scale.
5. Accent colour reads as bark-brown on bone-white, NOT red-brown and NOT olive (matches Skinward Pact palette guard from `art_specs/skinward_pact/` A-SPEC-5 validation line).
6. Body-horror restraint: NO realistic skull/decay under the antler, NO blood at the cord-binding, NO severed-head iconography. The Phyrexian-undertones that define Skinward card-hero art are absent at sigil tier — sigils are clan-mark iconography, not transformation-trauma vignettes. PEGI-12.
7. IP-clean guard: silhouette must NOT inadvertently echo any real-world hunting brand, taxidermy mount, or deer-head trophy aesthetic — negative prompt explicitly excludes these clusters. If the render reads as a hunting-club logo or a mounted-deer-head photograph, re-seed.
8. Druidic-clan reading: the motif should suggest "people who bind to beasts" via the cord-and-antler combination, not "trophy hunter" via decorative antler-display. The single sapling reinforces wilds-stewardship over predation.
9. Thumbnail test: downsample to 96×96 and view at 1× UI scale; must still read "antler-crown over a bound seedling".

**Deviation notes:**
- Same divergence from `pipeline_spec.md` §3.1 / §3.4 as S1–S4 — flat-vector silhouette, not painterly portrait. Sigil-specific composition tier `sigil_glyph` applies.
- Five-point antler chosen over three-point or seven-point: three reads as "young buck" (too soft for a faction silhouette), seven reads as "elk" (drifts toward real-world taxidermy reference cluster). Five is the heraldic standard for "stag crown" and tests well at 96×96.
- Horizontal cord binding chosen over a vertical wrap or a knot: a knot at thumbnail scale reads as a blob and muddies the silhouette; a vertical wrap competes with the sapling stem for centre-line authority. Three short horizontal bands give a clean read at downsample.
- Sapling chosen over a leaf, a seed, or a young tree: leaf reads as Skinward's faction colour banner (already covered by accent); a seed-only motif loses the wilds-stewardship cue; a young tree at thumbnail looks like a branch. Sapling-stem with two small flanking leaves hits the "bound seedling" prose stub precisely.
- Druidic-with-Phyrexian-undertones motif from `pipeline_spec.md` §3.2 deliberately restrained at sigil tier per the same logic as S4: Phyrexian undertone is faction-canonical at card-hero tier but at 96×96 it would drift into body-horror territory which fails PEGI-12 and muddies the silhouette. Reserved for card art, not sigil iconography.
- Negative prompt explicitly excludes hunting/taxidermy clusters because SDXL's antler-tagged training data over-indexes on those reference photos — without the negative guard the silhouette often skews toward "mounted deer head" which is both off-brand and IP-fraught (real-world hunting brands).
- Universal prefix `{UNIVERSAL_PREFIX}` from `IMAGE-GEN-SHOTLIST.md` §5 frame-pack template NOT applied — the sigil-specific prefix above replaces it (same convention as S1–S4).

---


## Open questions (B3.0f → flag for Paul)

1. **LoRA route confirmation.** First-pass = prompt-only, no LoRA. Acceptable, or queue `D-LORA-SIGIL` immediately to source a flat-vector/icon SDXL LoRA before any sigil renders?
2. **Hand-author fallback.** If SDXL flat-icon output looks painterly even with overridden negatives, fall back to Photopea/Krita hand-author from a single SDXL reference render? (Shotlist Q4 explicitly offered this route — cheaper than chasing a LoRA.)
3. **Crop method.** Centre-crop 1024×1024 → 96×96, or LANCZOS downsample? Centre-crop preserves silhouette weight; LANCZOS gives smoother edges but can blur narrow features (rope coil, antler tine). Default = LANCZOS unless 96×96 reads muddy, then re-render at 256×256 native and centre-crop.
4. **Sigil composition tier addition.** Introduce `sigil_glyph` as a new composition tier in `pipeline_spec.md` §3.4 explicitly, or keep it as a sigils-file-only convention? Either works; explicit-in-§3.4 is more discoverable for future contributors.
