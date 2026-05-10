# Faction frames — authoring spec v0 (T3)

_Authored 2026-05-10 by Cowork heartbeat. Backlog: Phase 2.10 T3._
_Sister docs: `art_direction.md` §2 + faction-frame visual language table; `shader_stack_design.md` §3.6 (FrameDecal at layer 15); `game/data/treatments/treatment_definitions.tres` (the 5 faction-frame entries that point at these PNGs)._

This doc locks the **PSD-template approach** for the 5 free faction frames so B3.2 (frame author pass) can produce them without re-deriving dimensions / slot anchors / export specs from scratch. Frame authoring is a 2D-asset task — the PSD template lives outside the engine, the engine consumes the exported PNGs at `res://game/art/frames/<faction>.png`.

## 1. Why a master template + 5 swappable packs

Each faction frame shares 90% of the structure (UI chrome anchors, transparent art window, name-plate pleat, cost-circle cutout, stats-circle cutout). The 10% that differs is **border decoration, top-arch motif, accent metal, corner accent, name-bar treatment**. Authoring 5 from-scratch PSDs would diverge on the shared anchors and break engine alignment. A master template + 5 border-asset packs is the cheap, consistent path.

**Master template** = one `frame_master.psd` with all anchors / cutouts / chrome regions locked + smart-object slots that swap in the per-faction art.

**Border-asset packs** = 5 small folders (one per faction) holding only the smart-object PNGs that drop into the master. Pack contents fixed by the spec below; if a faction needs an extra layer it goes in the master with a `visible=false` default.

## 2. Master frame template — canonical dimensions + anchors

### 2.1 Canvas
- **Size:** 832 × 1166 px. (2:3 aspect locked by SDXL output 832×1216, cropped 50px from top + bottom — see Open Q1.)
- **Resolution:** 72 DPI (mobile asset, no print path).
- **Bit depth:** 8-bit RGBA. Alpha required.
- **Colour profile:** sRGB.

### 2.2 Slot map (anchors are absolute px, top-left origin)

| Slot | Region (x, y, w, h) | Purpose | Frame-asset role |
|---|---|---|---|
| ART_WINDOW | (0, 0, 832, 1166) | Full-bleed art behind the frame | Frame must NOT cover the centre — leaves the art readable. Decoration only along edges + top arch + bottom name plate. |
| TOP_ARCH | (0, 0, 832, 220) | Faction-themed crown / arch motif | Per-faction art lives here. Brass mask (Penitents), shroud-pleat (Mourners), briar-tangle (Coven), foundry-rivet (Legion), antler-arch (Pact). |
| LEFT_BORDER | (0, 220, 56, 800) | Vertical accent strip | Per-faction texture (rope-twist, ink-stain, briar, chain-link, bark-grain). |
| RIGHT_BORDER | (776, 220, 56, 800) | Vertical accent strip | Mirror of LEFT_BORDER. |
| BOTTOM_PLATE | (0, 1020, 832, 146) | Translucent name + 1-line description bar | Faction-tinted overlay (rust-red, dusk-purple, etc. per `art_direction.md` §0 palette). Holds NameLabel + DescLabel. |
| COST_BADGE_HOLE | (32, 32, 128, 128) | Transparent cutout — cost circle drops through | Always transparent. Engine's CostBadge ChromeUI sits above this hole. Frame must NOT decorate inside this circle (would clash with the cost numeral). |
| STATS_BADGE_HOLE | (672, 880, 128, 128) | Transparent cutout — stats circle drops through | Always transparent. UNIT cards only — SPELL/TRAP cards have engine hide this region. Frame must NOT decorate inside. |
| FACTION_SIGIL_NICHE | (32, 1020, 96, 96) | Small corner niche in BOTTOM_PLATE for the faction sigil glyph | Per-faction sigil PNG. ≤96px square. Treated as part of the BOTTOM_PLATE composition. |
| CORNER_ACCENT_TL / TR / BL / BR | (0,0,80,80), (752,0,80,80), (0,1086,80,80), (752,1086,80,80) | 4 small corner motifs | Per-faction (hammer-and-rope, ink-bleed, three-shadow, chain-link, ivy-leaf). |

**Rule:** the centre rectangle (56, 220, 720, 800) — i.e. the painterly art region minus a 56-px border on each side — MUST be untouched by the frame asset. Treatment shaders (Foil sparkle, Gold HSV, Prism shimmer) operate on the art layer below and rely on the centre being clean.

### 2.3 PSD layer structure (master)

```
frame_master.psd
├── 00_GUIDES (visible=false at export)        ← layout grid + safe zones
├── 10_BACKGROUND_VOID (visible=false at export) ← solid black for preview only
├── 20_ART_PLACEHOLDER (visible=false at export) ← grey checker, helps preview alignment
├── 30_TOP_ARCH                                ← smart-object slot (per-faction PNG)
├── 31_LEFT_BORDER                             ← smart-object slot
├── 32_RIGHT_BORDER                            ← smart-object slot
├── 33_BOTTOM_PLATE                            ← smart-object slot (faction-tinted, translucent)
├── 34_CORNER_TL  / 35_CORNER_TR / 36_CORNER_BL / 37_CORNER_BR ← smart-object slots
├── 38_FACTION_SIGIL                           ← smart-object slot (96×96, sits inside BOTTOM_PLATE)
├── 50_COST_HOLE_MASK                          ← group with vector mask cutting alpha
├── 51_STATS_HOLE_MASK                         ← group with vector mask cutting alpha
└── 99_EXPORT_RULES (text layer, hidden)       ← reminders for the exporter
```

Smart objects mean swapping a faction = 7 PNG drops + a re-tint of BOTTOM_PLATE. Total swap time per faction ≤ 5 min once the pack is drawn.

### 2.4 Export spec
- **Format:** PNG-24 with alpha. NO PNG-8, NO compression below 6 (the soft brass / rusted edges have ≥256 colours each — palette compression destroys them).
- **Filename:** `<faction_id>.png`, snake_case, lower. The 5 valid IDs per `enums.gd`:
  - `iron_penitents.png`
  - `ash_mourners.png` _(maps to `WITHERED_COURT` enum constant per L2 reconciliation)_
  - `coven.png` _(`HOLLOW_PACT` constant)_
  - `last_legion.png` _(`FERRUM_HOST` constant)_
  - `skinward_pact.png` _(`SABLE_WILDS` constant)_
- **Destination:** `res://game/art/frames/<faction_id>.png`.
- **Engine binding:** `treatment_definitions.tres` already references these via `frame_path` on each FACTION_FRAME entry per T1.

## 3. Per-faction border-asset packs

Each pack is 7 PNGs + a faction-tint hex value. Drawn against the dimensions in §2.2 — same canvas, same anchors, only the artwork differs.

### 3.1 Iron Penitents (rust-red accent `#8C2E2E`)
- **TOP_ARCH:** brass execution-mask top-arch. Tarnished brass tone, hammered-metal texture, rivets along the bottom edge of the arch where it meets the art. Faceless mask silhouette centred (stylised — no realistic gore, PEGI 12).
- **LEFT_BORDER + RIGHT_BORDER:** rope-twist column (frayed, knotted at the top + bottom). Rusted iron studs at 1/3 and 2/3 marks.
- **BOTTOM_PLATE:** translucent rust-red wash (alpha 0.78), faint ink-on-vellum execution-warrant texture overlay at 0.15 alpha. Ragged top edge (looks torn, not cut).
- **CORNER_TL / TR:** hammer head + spike motif (two crossed elements, brass).
- **CORNER_BL / BR:** rope-coil end with a hanging weight (small).
- **FACTION_SIGIL:** flayed-back-with-hammer glyph at 96×96, brass on a darker brass disc.

### 3.2 Ash-Mourners (dusk-purple accent `#4A3A5C`)
- **TOP_ARCH:** shroud-pleat top with a raven-quill flourish off-centre-left. Corroded silver wire embroidery along the pleat seam. The pleat hangs in the centre — not symmetrical, captures the "no shadow" wrong-feeling.
- **LEFT_BORDER + RIGHT_BORDER:** corroded silver chain alternating with ink-stain drips. Ink bleeds INTO the art slightly along the inner edge (stay within first 8 px).
- **BOTTOM_PLATE:** translucent dusk-purple (alpha 0.78), ink-stain bleed motif rising from the bottom edge into the plate (heaviest at the LEFT, fades RIGHT). Top edge is a torn-paper deckle.
- **CORNER_TL / TR:** raven-quill nib (single, angled inward).
- **CORNER_BL / BR:** ink-blot splash (asymmetric — never symmetrical between corners; Mourners reject symmetry).
- **FACTION_SIGIL:** quill-and-shroud glyph, corroded silver on darker purple disc.

### 3.3 Coven of the Black Mire (bog-green accent `#2D5A3F`)
- **TOP_ARCH:** briar-tangle arch — gnarled thorny vines woven into a rough crown shape. Three small hung-coin amulets dangling from the tangle (one centre, two off-centre — the "demon-coin wreath" + "three" motif).
- **LEFT_BORDER + RIGHT_BORDER:** briar-and-bog-iron column. Visible patches of green-rust (oxidised bog-iron). Briar thorns project ~6 px into the art region — this is the only faction allowed to violate the inner-56px clean zone, and only with thorns ≤6 px deep.
- **BOTTOM_PLATE:** translucent bog-green (alpha 0.78). Three faint shadow-shapes cast UNDER the name (the "three shadows" motif). Top edge is bog-water rippled.
- **CORNER_TL / TR:** demon-coin trio (three small overlapping discs).
- **CORNER_BL / BR:** thorned root tendril curling inward.
- **FACTION_SIGIL:** three-shadows-cast glyph with a single coin centred, bog-iron on darker green disc.

### 3.4 The Last Legion (smoked-brass accent `#6B5530`)
- **TOP_ARCH:** foundry-rivet top — heavy plate-armour slab with a row of brass rivets at the bottom edge and soot-smear staining the upper half. Officer's gorget motif centred (chevron-shaped notch). No face — just plate and rivet.
- **LEFT_BORDER + RIGHT_BORDER:** chain-link border running vertical, smoke-tarnished brass. Each link has a faint engraved sigil (legion-mark — tiny, only readable at full-screen zoom).
- **BOTTOM_PLATE:** translucent smoked-brass (alpha 0.78), faint scorch-mark texture across the plate. Top edge is a hard machined cut (this is the only faction with a hard edge — they're industrial).
- **CORNER_TL / TR:** crossed batons (ironwood + brass cap).
- **CORNER_BL / BR:** chain-link with a broken final link (the "Last" of the Last Legion).
- **FACTION_SIGIL:** foundry-anvil-and-chevron glyph, smoked brass on darker brass disc.

### 3.5 Skinward Pact (bark-brown accent `#4B3621`, secondary bone-white `#E8DCC0`)
- **TOP_ARCH:** antler-arch — paired antlers sweeping inward with bone shards woven between them. Bark-grain texture on the antler bases where they emerge from the frame edge (suggests the antlers are growing out of the wooden frame itself).
- **LEFT_BORDER + RIGHT_BORDER:** bark-grain columns with bone slivers at irregular intervals. Ivy tendrils trail down from the top — uneven length per side.
- **BOTTOM_PLATE:** translucent bark-brown (alpha 0.78), faint smoke-trail wisps rising from the bottom edge (the "smoke-trailing fingers" motif). Top edge is uneven bark-shred.
- **CORNER_TL / TR:** ivy-leaf cluster (3 leaves, asymmetric).
- **CORNER_BL / BR:** bone shard with a leather binding.
- **FACTION_SIGIL:** antler-and-ivy glyph, bone-white on bark-brown disc.

## 4. Production process

1. **Author `frame_master.psd` first** — empty smart-object slots, all chrome holes cut, anchors locked to §2.2. One-time work.
2. **Author each faction's 7 PNGs in a faction sub-folder** (`assets/source/frames/<faction_id>/{top_arch,left_border,right_border,bottom_plate,corner_tl,corner_tr,corner_bl,corner_br,faction_sigil}.png`). Drawn against the master's anchor grid.
3. **Drop the PNGs into the master's smart-object slots, set the BOTTOM_PLATE tint, export `<faction_id>.png` to `res://game/art/frames/`.** Five exports = five faction frames.
4. **In-engine smoke check:** open the Godot editor, set a CardInstance's `treatment_id` to `faction_frame_iron_penitents` (etc.), confirm the FrameDecal TextureRect renders the PNG, the cost / stats / name labels are unobscured, the centre art region is unobstructed.
5. **Iterate per-faction independently** — no cross-faction dependency once §2's master is locked.

**Tooling note:** Paul's hardware doesn't have Photoshop. Free alternatives: Krita (FOSS, supports PSD smart objects via "embedded references" — close enough), Photopea (browser-based PSD editor, no install). GIMP works for the per-faction PNG drawing pass; PSD smart-object workflow is weakest there. Recommendation: **Photopea for the master template, Krita for the per-faction art, then re-import to Photopea for export.** All free, all cross-platform.

**Budget:** master template ≈ 2 hrs author. Per-faction pack ≈ 3-4 hrs author (the 7 PNGs + tuning). Total = ~20 hrs of art time across all 5 factions. This is the slowest item in T-track and a likely candidate for "Cowork generates faction-frame textures via the AI pipeline + Paul touches up in Krita" once B3.0a smoke test confirms the SDXL pipeline works.

## 5. Integration with the shader stack (recap from `shader_stack_design.md` §3.6)

- FrameDecal binds to `res://game/art/frames/<faction_id>.png` at layer 15.
- It is a **texture swap**, not a shader — no material attached. CPU and GPU cost ≈ free.
- Faction frame is mutually exclusive with Default frame at the data-model layer (T1: `treatment_id` enum forces one or the other, never both).
- Treatments above (Foil at 20, Prism at 30, Ultimate at 40) render OVER the faction frame. Frame artists should ASSUME the centre 720×800 region will get sparkled / shimmered / sheen-swept and design accordingly — keep the frame's own visual interest in the borders + top arch + bottom plate, never in the centre.

## 6. Open questions for Paul

1. **Aspect ratio tension.** SDXL outputs 832×1216 (2:3 = 0.684). Current CardView is 200×280 (5:7 = 0.714). Frame canvas spec above is 832×1166 (≈5:7 to match CardView). This means generated card art gets a **50px crop top + bottom** before rendering. Acceptable for B3 first pass, OR rebase CardView to 200×292 (matches SDXL native, no crop). Recommend the rebase — saves an art-pipeline step and lets us run art generation 1:1 to render. Paul: confirm rebase OK?
2. **PSD vs Krita-native.** The smart-object workflow is genuinely better in Photopea/Photoshop than Krita (Krita's "embedded references" needs manual relink on PNG update). If Paul wants to skip PSD entirely, the alternative is to flatten each faction frame to a single PNG up-front and skip the master-template indirection. Loses ~30% of the iteration speed but is simpler. Recommend: **stick with PSD master via Photopea (free, browser-based)**.
3. **AI-assisted frame generation.** The 5 frames are fundamentally repeatable border patterns with motif variations. SDXL with a "ornate fantasy card border" LoRA could draft the per-faction packs in <10 mins of GPU vs ~20 hrs of hand-painting. Worth queueing a B3.2-frame-pipeline task once D-VALIDATE-1's 9-tile reference sheet confirms the SDXL pipeline produces faction-readable output? Recommend: **yes, defer the hand-paint path, try the AI route first.** Even if 70% of the AI output is unusable the 30% that lands cuts art time by ~14 hrs.
4. **Localised name plates.** Long card names (e.g. "Sergeant-Smith Vikar of the Crowned Anvil") may overflow BOTTOM_PLATE. T3 doesn't solve this; flagging for B2.6 UI hardening — name auto-shrink at >24 chars, or a 2-line layout. Doesn't block frame authoring.

## 7. Definition of done for T3

- [x] Master template dimensions + slot anchors locked (§2.2 above).
- [x] PSD layer structure spec'd (§2.3).
- [x] Export spec locked (§2.4) — engine binding path + filenames defined.
- [x] All 5 faction packs spec'd to motif-and-corner level (§3.1–§3.5).
- [x] Production process documented (§4).
- [x] Shader-stack integration confirmed against existing T2 spec (§5).
- [x] Open questions surfaced for Paul (§6).

Authoring of the actual `frame_master.psd` + 5 PNG packs is **B3.2 (frame author pass)** — a separate art-production task, not part of T3's spec deliverable. T3's contract is "the spec exists and B3.2 can execute against it without re-deriving anything." That's met.
