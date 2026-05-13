# Gallowfell — image generation shotlist

_Authored 2026-05-13 by Controller (cross-portfolio Cowork). Single source of truth for what art is still owed, in what order, with prompts ready to drop into the SDXL pipeline. Mirror lives at `G:\My Drive\ClaudeBridge\projects\gaming-app\IMAGE-GEN-SHOTLIST.md`._

## TL;DR

**236 production images owed.** All blocked by one smoke test (B3.0a). Once SDXL output is confirmed PEGI-12-clean and on-style, the rest is throughput.

| Bucket | Count | Specs ready? | Prompts ready? | Status |
|---|---:|---|---|---|
| **B3.0a smoke test** | 1 | yes | yes (in `backlog.md` B3.0a) | **CRITICAL BLOCKER** — run first |
| Faction frames | 5 | yes (`faction_frames_v0.md`) | authored below | queued behind B3.0a |
| Warlord portraits | 11 | prose only — prompts authored below for first time | **NEW — authored in this doc** | queued behind B3.0a |
| Card heroes | 220 | yes (`art_specs/<faction>/`) | yes (resolved prompts in each spec) | batch behind B3.0a |
| Animation idle loops | 440–880 | derived from card heroes | template-only, per-card variation TBD | **DEFERRED** to post-B3.x |
| Faction sigils + corner accents | ~30 | partial (in `faction_frames_v0.md`) | embedded in frame prompts below | bundled with faction frames |
| UI elements (icons, badges) | ~30–50 | wireframe only (`collection_ui_v0.md`) | not authored | **DEFERRED** to IMV-2 polish |
| Background environments | 0 | not specced | n/a — combat is lane-grid, no background art needed for MVP | not in scope |

**Bottom-line queue order:** B3.0a (1) → Warlord portraits (11, parallel safe with frames) → Faction frames (5) → Card heroes batch (220) → Animation pass (post-launch acceptable).

---

## 1. Output format spec — one-look (locked)

Source: `art_direction.md` §3, `faction_frames_v0.md` §2.1, `project_config.md`.

| Asset class | Native render | Final canvas | Format | Crop / placement |
|---|---|---|---|---|
| Card hero art | 832 × 1216 (SDXL native) | 832 × 1166 | PNG-24 RGBA, sRGB, 72dpi | Crop 50px top + bottom; frame overlays after |
| Faction frame (composite) | n/a — built in PSD | 832 × 1166 | PNG-24 RGBA, sRGB | Exports to `res://game/art/frames/<faction_id>.png` |
| Faction sigil glyph | 96 × 96 | 96 × 96 | PNG-24 RGBA | Drops into `FACTION_SIGIL_NICHE` slot |
| Corner accent | 80 × 80 | 80 × 80 | PNG-24 RGBA | 4 corner slots in faction frame |
| Warlord portrait | 768 × 768 | 600 × 600 | PNG-24 RGBA | Roster grid + detail screens; centre-crop |
| Idle-loop frame | 832 × 1216 | 832 × 1166 | PNG-24 RGBA | 2–4 frames per unit, controlled-variation pass from hero |

**Hardware constraint:** 4GB VRAM target (per `project_config.md`). Use 768-tile SDXL with hi-res-fix at 1.5× rather than native 1024, to fit under the ceiling.

---

## 2. Pipeline parameters — baseline (locked unless override per spec)

Source: `art_specs/_template.md`. Reproduced here so the shotlist is self-contained.

```yaml
checkpoint: juggernautXL_v9
sampler: DPM++ 2M Karras
steps: 30
cfg_scale: 6.5
size: 832x1216  (hero) / 768x768 (warlord) / 1024x1024 (frame composites)
seed: -1 (random per generation; record actual seed in metadata)
loras_baseline:
  - ClassipeintXL v2.1 @ 0.8           # MTG painterly anchor
  - Dark Fantasy LORA v1 @ 0.8         # genre lock
  - Elden Ring Style v1.0 @ 0.5        # doomed-grandeur cinematography
  # Per-faction LoRAs layered on top (see each faction prompt)
```

**Universal positive prompt prefix** (prepend to every Gallowfell render):

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
```

**Universal negative prompt** (PEGI-12 guardrail + style discipline):

```
worst quality, low quality, jpeg artifacts, blurry, sketch, cel-shaded, cartoon,
anime, manga, watermark, signature, text, ui, hud, logo, frame, border,
nsfw, nudity, gore, exposed organs, severed limbs, dismemberment, fresh blood,
viscera, intestines, child, children, minor, cute, chibi, kawaii,
deformed, extra fingers, extra limbs, mutated hands, bad anatomy,
oversaturated, neon, modern clothing, contemporary setting, sci-fi, mecha
```

---

## 3. B3.0a — smoke test (THE blocker)

Source: `backlog.md` Phase 2.11 B3.0a.

**Goal:** prove the SDXL pipeline produces a recognisable, PEGI-12-clean, on-style Gallowfell render before any batch spend.

**Subject:** Iron-Penitent flagellant (any single P-spec — recommend P1 Nail Choir Flagellant since it's the canonical first card).

**Prompt:** use the resolved prompt from `art_specs/iron_penitents/p1_nail_choir_flagellant.md` verbatim.

**Acceptance checklist** (all must pass before unblocking the batch):

1. Recognisably MTG-painterly oil, not cartoon / anime / cel-shaded.
2. Rust-red accent visible; muted earth-tone palette overall.
3. Iron-Penitent visual cues (brass execution mask, hammer-and-rope motif, hooded silhouette).
4. No fresh blood, no exposed wounds, no gore — implication only.
5. Composition fits a 832×1166 crop with the subject readable inside the centre rectangle (56, 220, 720, 800) where the frame won't overlay.
6. Output is reproducible — same seed + same prompt yields the same result on the chosen GPU.

**Expected GPU cost:** ~£0.15, ~15–25 min on RunPod (per backlog notes).

**If fails:** triage by LoRA — disable one at a time, re-run, find the offender. If structural fail (style way off): revisit `art_direction.md` §1c and adjust the universal prefix before scaling.

---

## 4. Warlord portraits — 11 prompts (authored 2026-05-13)

These do not exist anywhere else. Each is built from the visual cue in `warlords_v1.md` + the universal prefix + a per-faction LoRA pack matching the Warlord's home faction. Render at 768×768, centre-crop to 600×600. Tier-1 priority (collection roster + marketing-friendly).

### W1 — Penance-Captain Vyrrun (Iron Penitents — Aggro — FREE)

```
{UNIVERSAL_PREFIX}
half-length portrait of a warlord, monarchy-era execution mask in tarnished brass
filling the centre of the face, hood drawn back, flayed bare back visible over the
shoulder, hammer-and-rope motif embossed on the brass chestplate, rust-red accent
on robe stitching, rope-bound wrists, cathedral-ruin background out of focus,
ash-fall in the air, sanctified-hangman aesthetic,
rust-red accent colour, ironwork detail, painterly brushwork,
volumetric lighting, oil-paint texture visible in highlights,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline + `iron mask portrait` @ 0.7, `cathedral ruin` @ 0.5.

### W2 — Court-Necromant Sieren (Ash-Mourners — Control — FREE)

```
{UNIVERSAL_PREFIX}
half-length portrait of a court necromancer, dusk-purple court robes turned to
grave-shrouds, ink-stained fingers holding a raven-quill, no-shadow figure
(no shadow cast on the wall behind her), gaunt aristocratic face, eyes lined
in soot, raven feathers caught in her hair, catacomb vault background with
hanging lanterns, dusk-purple accent colour,
ink and parchment, Victorian mourning sensibility,
painterly brushwork, volumetric lighting,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline + `gothic court robes` @ 0.7, `catacomb interior` @ 0.5.

### W3 — Marsh-Mother Eddra (Coven of the Black Mire — Swarm — FREE)

```
{UNIVERSAL_PREFIX}
half-length portrait of an old swamp witch, hunched silhouette, wreath of
demon-coins around her neck, eyes lit with pyre-green inner glow, briar-cloak
woven with bog-rushes, three visible teeth in a thin smile, three faint
overlapping shadows behind her, bog-mist background, bog-green accent colour,
hag-witch composition, painterly brushwork, gnarled hands holding a familiar
toad-thing, volumetric lighting,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline + `swamp witch` @ 0.7, `bog mire interior` @ 0.5.

### W4 — Forge-Marshal Veska (The Last Legion — Tempo — FREE)

```
{UNIVERSAL_PREFIX}
half-length portrait of a battle-marshal, soot-blackened brass cuirass,
brass officer's gorget at the throat, ironwood baton held across the chest,
hair bound in iron chain links, foundry-smoke background with red glow from
furnaces out of focus, smoke-blackened brass accent colour, weather-creased
soldier's face, oversized armour silhouette in the Elden Ring tradition,
painterly brushwork, volumetric lighting from forge-glow,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline + `military commander portrait` @ 0.7, `industrial foundry` @ 0.5.

### W5 — Tree-Walker Mhar (Skinward Pact — Summoner — FREE)

```
{UNIVERSAL_PREFIX}
half-length portrait of a forest-shaman warlord, antler-crown sprouting fresh
green leaves through cracked bone, layered hide-cloak of patched pelts,
mismatched eyes (one amber, one milk-white), smoke trailing from his fingertips,
visible ribcage seam where a second heart used to beat, bark-brown accent colour,
cinderwood background with charred standing trees, painterly brushwork,
druid-with-decay composition, volumetric lighting through smoke,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline + `druidic shaman` @ 0.7, `cinderwood forest` @ 0.5.

### W6 — The Vow-Broken Magus (Penitents × Ash-Mourners — Hybrid — PAID)

```
{UNIVERSAL_PREFIX}
half-length portrait of a fallen court mage, brass execution-mask split open
down the middle vertically to reveal a court-shroud face underneath, robes
half rust-red half dusk-purple sewn together along the central seam, broken
prayer-beads draped over one shoulder, raven-quill stuck through the brass-half
of the mask, hybrid Penitent/Mourner aesthetic, painterly brushwork,
volumetric lighting on the seam,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline + `iron mask portrait` @ 0.5, `gothic court robes` @ 0.5.

### W7 — Warden Caspar Voll, the Empty Throne (Last Legion — Tempo boss-control — PAID)

```
{UNIVERSAL_PREFIX}
half-length portrait of an aged warden, soot-blackened officer's cuirass with
a hollow circular cutout over the heart where a medal should be, brass gorget
tarnished, white side-whiskers, exhausted commanding eyes, ironwood baton
hanging at the hip, foundry-smoke background with an empty wooden throne
visible behind him out of focus, brass accent colour, "the man who failed
the post" composition, painterly brushwork, volumetric lighting,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline + `military commander portrait` @ 0.7, `industrial foundry` @ 0.4.

### W8 — The Saint of Gallowsmoke (Coven × Ash-Mourners — Smoke-swarm-control — PAID)

```
{UNIVERSAL_PREFIX}
half-length portrait of a half-revealed saint figure stepping out of dense
funeral smoke, dusk-purple shroud dissolving into bog-green smoke at the hem,
demon-coin halo of small floating brass discs around the head, eyes closed in
serene unconcern, mouth slightly open, smoke obscures the lower half of the
body, smoke-grey accent over a dusk-purple base, painterly brushwork,
ethereal volumetric lighting cutting through smoke,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline + `funeral smoke` @ 0.6, `saint portrait halo` @ 0.5.

### W9 — The Brass-Crowned Whelp (Skinward Pact × Iron Penitents — Summoner/Aggro — PAID)

```
{UNIVERSAL_PREFIX}
half-length portrait of a small boy in an oversized brass execution-crown that
tilts forward over his eyes, layered hide-cloak much too large for his frame,
leash in one hand bound to two stitched-pelt hunting hounds out of focus to one
side, tear-streaked face, barefoot, hammer-and-rope embroidery on the cloak
hem, rust-red and bark-brown accents mingled, "child wearing a tyrant's
regalia" composition, PEGI-12 safe — implication of unease only, no harm
depicted, painterly brushwork, volumetric lighting,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline + `druidic shaman` @ 0.4, `iron mask portrait` @ 0.4. **Sensitive subject — PEGI guard verified at runtime by Paul before release.**

### W10 — The Last Confessor (Neutral / faction-flex — Wildcard — PAID)

```
{UNIVERSAL_PREFIX}
half-length portrait of a blind confessor, blindfold of stitched grey linen
across the eyes, threadbare cassock the colour of old bone, ear-trumpet of
tarnished brass held to one ear, walking-stick of bound prayer scrolls leaning
against the shoulder, mouth open slightly as if mid-listen, no faction colour —
greyscale-leaning palette with a single brass-tarnish accent, painterly
brushwork, neutral cell-like background, volumetric lighting from one source,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline only (no faction LoRA — she's neutral).

### W11 — The Saint That Should Not Hang (The Curse Itself — LORE-LOCKED)

```
{UNIVERSAL_PREFIX}
half-length portrait of a young woman in a frayed white shift the colour of
old paper, eyes painted shut with white lead-paint so they cannot judge the
viewer, bare feet that leave no footprint on the floor beneath her, faint
rope-mark always visible at the throat, hands relaxed at her sides, ash-pale
skin, no faction accent — pure greyscale-with-bone-white palette, "she is the
curse" composition, gallows-tree visible through a window behind her out of
focus, painterly brushwork, volumetric lighting falling onto her from above
as if from a gallows beam,
8k, hyper-detailed, masterpiece quality
```
LoRA pack: baseline + `religious icon portrait` @ 0.6. **Critical end-of-arc reveal asset — Paul approves before any other generation; visual sets the tone for the whole game's secret payoff.**

---

## 5. Faction frames — 5 (full motif spec exists; prompts authored here)

Source: `faction_frames_v0.md` §3.1–§3.5. Each "frame" is actually a small bundle:
- 1× top_arch (832 × 220) — themed crown/arch motif
- 1× left_border (56 × 800) — vertical accent strip
- 1× right_border (56 × 800) — mirror of left
- 1× bottom_plate tint overlay (832 × 146) — faction-tinted, holds name labels
- 4× corner accents (80 × 80) — TL/TR/BL/BR
- 1× faction sigil glyph (96 × 96)

**Recommendation:** generate each border/arch element at 1024×1024 SDXL, then crop. Treat each frame as 8 generations bundled. Total: 8 × 5 = **40 sub-generations** to produce the 5 frame packs.

### F1 — Iron Penitents frame pack

**Top arch (832×220 from 1024 crop):**
```
{UNIVERSAL_PREFIX}
ornamental top arch for a fantasy card frame, horizontal banner composition,
tarnished brass execution mask centred at the apex, hammer-and-rope motif
flanking either side, rust-red ribbon woven through, cathedral-ruin gothic
arch architecture, painterly bronze detailing, no central figure, environment
piece only, transparent edges fading to alpha, single accent colour rust-red,
oil-paint texture visible in highlights,
8k, hyper-detailed, masterpiece quality
```

**Left/right border:** rope-twist motif in tarnished brass with rust-red fibre showing through, repeating vertical pattern, isolated on transparent.

**Bottom plate tint:** rust-red translucent gradient with hammer-and-rope embossed faintly.

**Corner accents:** small brass nail-heads with rope wrapped once around each.

**Faction sigil:** brass execution-mask glyph in profile, simplified to 96×96 silhouette readable at thumbnail.

### F2 — Ash-Mourners frame pack

**Top arch:**
```
{UNIVERSAL_PREFIX}
ornamental top arch for a fantasy card frame, horizontal banner composition,
draped court-shroud pleats falling from the apex in dusk-purple silk, raven-quill
sigils stitched in silver across the pleats, gothic vault arch architecture,
painterly fabric detail, no central figure, environment piece only, transparent
edges fading to alpha, single accent colour dusk-purple, oil-paint texture
visible in highlights,
8k, hyper-detailed, masterpiece quality
```

**Left/right border:** ink-stained parchment edge, raven-quill silhouettes spaced vertically.

**Bottom plate tint:** dusk-purple translucent gradient with court-script flourishes faintly.

**Corner accents:** raven feathers, one per corner, painterly.

**Faction sigil:** raven-quill crossed over a shrouded skull, 96×96 silhouette.

### F3 — Coven of the Black Mire frame pack

**Top arch:**
```
{UNIVERSAL_PREFIX}
ornamental top arch for a fantasy card frame, horizontal banner composition,
briar-tangle woven into a witch's hex sign at the apex, demon-coin discs
strung between the briars, bog-green moss creeping across, three small
shadow-shapes flanking the centre, painterly organic detail, no central
figure, environment piece only, transparent edges fading to alpha, single
accent colour bog-green, oil-paint texture visible,
8k, hyper-detailed, masterpiece quality
```

**Left/right border:** thorn-and-briar vertical motif with small demon-coin discs caught in the tangle.

**Bottom plate tint:** bog-green translucent gradient with hex sign embossed faintly.

**Corner accents:** three teeth (per corner) in painterly bone-white.

**Faction sigil:** demon-coin disc inside a hex-sign briar wreath, 96×96.

### F4 — The Last Legion frame pack

**Top arch:**
```
{UNIVERSAL_PREFIX}
ornamental top arch for a fantasy card frame, horizontal banner composition,
foundry-rivet brass plating at the apex, two crossed ironwood batons
beneath, chain-link motif running along the underside, soot-blackened brass
overall, military-industrial gothic detail, no central figure, environment
piece only, transparent edges fading to alpha, single accent colour
smoke-blackened brass, oil-paint texture visible,
8k, hyper-detailed, masterpiece quality
```

**Left/right border:** chain-link vertical motif in tarnished brass.

**Bottom plate tint:** brass-tarnish gradient with foundry-rivet pattern faintly.

**Corner accents:** small brass officer-pip insignia, one per corner.

**Faction sigil:** crossed ironwood batons over a brass gorget, 96×96.

### F5 — Skinward Pact frame pack

**Top arch:**
```
{UNIVERSAL_PREFIX}
ornamental top arch for a fantasy card frame, horizontal banner composition,
antler-arch sprouting fresh green leaves at the apex, bark-brown hide stretched
across the curve, bone-white accents at the tips of antlers, smoke curling up
from the corners, painterly natural detail, no central figure, environment
piece only, transparent edges fading to alpha, single accent colour bark-brown,
oil-paint texture visible,
8k, hyper-detailed, masterpiece quality
```

**Left/right border:** woven hide strapping with small bones tied in, vertical pattern.

**Bottom plate tint:** bark-brown translucent gradient with antler-crown silhouette embossed.

**Corner accents:** small antler tines, one per corner.

**Faction sigil:** antler-crown over a bound seedling, 96×96.

---

## 6. Card heroes — 220 (prompts already exist; queue note only)

All 220 prompts are authored in `art_specs/<faction>/<id>_<name>.md`. No new prompt work required. Generation order recommendation:

1. **B3.0a smoke confirms first** with P1 Nail Choir Flagellant.
2. **Then a per-faction smoke pass** — pick one card per faction, generate, eyeball that the faction LoRA pack is doing the right thing. 5 renders, ~£0.75, ~2 hrs.
3. **Then batch the 5 factions in parallel** — 40 cards per faction, ~40 × £0.15 = ~£6 per faction batch.
4. **Total batch cost estimate:** ~£35–50 GPU spend if no re-rolls. Budget ~£100 with 2× re-roll allowance.
5. **Re-roll triage:** any card that fails the acceptance checklist (§3 above) goes back into a re-roll queue with seed-noted, prompt-tweaked next attempt. Track in `art_iterations/_rerolls.md`.

**Acceptance criteria per card** (same as smoke + per-card):
- Faction visual cues clearly present.
- Card subject from the spec is the focal point.
- Composition leaves the centre rectangle (56, 220, 720, 800) readable — face/key element not in a corner.
- PEGI-12 clean.

**Backlog hooks:** B3.1 (Apple Dev) is parallel-safe with this; B3.2 (frame author) can start in parallel with hero generation since it doesn't block; B3.x is the batch itself.

---

## 7. Animation idle loops — deferred to post-launch

Source: `art_direction.md` §3 — 2–4 frame breathing loops per unit. 440–880 frames total.

**Why deferred:** static cards ship a functional game. Animation is polish. Generate after launch, drop into a free patch.

**When ready:** use controlled-variation pass — re-run the hero prompt with `denoising_strength: 0.15` and seed offset, change pose tag (e.g. "slight head tilt left", "breath in", "breath out", "weight shift") in 2-frame increments. Documented in `art_direction.md` §3.

---

## 8. UI elements / icons — deferred to IMV-2

Source: `collection_ui_v0.md`. Wireframe only — no design language picked yet. Many slots can be solved with text+emoji or simple SVG until the polish pass.

**When ready:** Paul picks Google Fonts (`art_direction.md` §4 has two empty slots: "headline" and "body"), then 30–50 small icons get a single batch generation at 128×128 with `icon` LoRA at high weight.

---

## 9. Heartbeat task hooks

This shotlist is meant to be consumable by the `gaming-app-heartbeat` scheduled task. Suggested heartbeat additions (queue in `backlog.md`):

- **HB-IMG-1**: every 3rd heartbeat, scan `art_iterations/` for completed renders, append a one-line "generated:" entry to `art_iterations/INDEX.md`. Build the index over time.
- **HB-IMG-2**: every 5th heartbeat, check `art_specs/` against `art_iterations/` and report which card_ids still lack a generated image. Output to `art_iterations/_owed.md`. Auto-updates this shotlist's "Status" column.
- **HB-IMG-3**: once any new image lands in `art_iterations/`, run a heuristic check (file size, dimensions, alpha present) and flag obvious pipeline failures (truncated downloads, wrong-resolution outputs) before Paul has to eyeball them.

None of these run image generation themselves — heartbeat doesn't have GPU. They just keep the bookkeeping honest so when Paul does sit down to generate, the queue is correct.

---

## 10. Cost / time estimate (best-case)

| Phase | Images | Est. GPU hours | Est. cost (RunPod ~£0.30/hr) |
|---|---:|---:|---:|
| B3.0a smoke | 1 | 0.4 | £0.15 |
| Warlord portraits (11 at 768) | 11 | 1.5 | £0.50 |
| Faction frame components (40 sub-gens) | 40 | 5 | £1.50 |
| Card heroes batch (220 at 832×1216) | 220 | 30 | £9 |
| Re-rolls (20% allowance) | ~50 | 7 | £2 |
| **Total to MVP-art-complete** | **~322** | **~44** | **~£13** |

Animation pass adds another ~80 GPU hours / ~£25 post-launch.

---

## 11. Open questions for Paul (carry from `warlords_v1.md` §Open questions)

1. RunPod vs local GPU? Local 4GB VRAM is tight but workable for 768-tile.
2. Warlord 9 (Brass-Crowned Whelp) — PEGI-12 borderline. Confirm child-in-tyrant-regalia framing is acceptable before generation.
3. Warlord 11 (Saint That Should Not Hang) — visual sets the tone for the whole game's secret payoff. Paul to approve W11 prompt before any other Warlord generation.
4. Faction sigil glyphs — generate via SDXL with `simple silhouette icon` LoRA, or hand-author in Photopea? AI is cheaper but may look painterly when we want flat-vector.

---

_Cross-link: this doc sits alongside `backlog.md` B3 track. B3.0a–B3.0d slots are already taken (smoke test, LoRA scan, workflow JSON, automation script). No backlog entry needed — gaming-app-heartbeat picks up new top-level docs in the Gaming app folder by directory scan. If a heartbeat later wants explicit cross-reference, add `B3.0e — Shotlist authored 2026-05-13 — see IMAGE-GEN-SHOTLIST.md`._
