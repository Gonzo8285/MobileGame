# Shader stack design — Card cosmetic treatments (T2)

_Authored 2026-05-09 by Cowork heartbeat. Backlog: Phase 2.10 T2._
_Sister docs: `art_direction.md` §2 (treatment economy), `game/src/data/card_treatment.gd` (data model), `game/data/treatments/treatment_definitions.tres` (catalog)._

This doc specifies the shader pipeline that applies cosmetic treatments to a base CardView render. Treatment data (T1) is already on disk; this is the rendering side. Shader bodies are NOT authored here — they need real card-art textures to tune sparkle density / metallic mask threshold / shimmer speed against, which is a B3-art-pass dependency. T2's job is to lock the architecture, layer order, parameter API, and combo resolution algorithm so when shader authoring lands it slots in cleanly.

## 1. Architecture — where shaders live in the CardView scene tree

CardView (B2.6 placeholder) is currently `Control + ColorRect BG + 4 Labels`. The treated CardView v1 scene tree (B3 art pass replaces the BG ColorRect with real art):

```
CardView (Control)
├── ArtFrame (Control, owns the art region only — full-bleed minus UI chrome)
│   ├── Art (TextureRect)                      ← layer 0  base art OR alt_art (Ink)
│   │   └── material: art_modifier shader      ← layer 10 Gold HSV-shift binds here
│   ├── FrameDecal (TextureRect)               ← layer 15 faction frame (Iron Penitents brass arch, etc.)
│   ├── OverlayStatic (TextureRect)            ← layer 20 Foil sparkle (static)
│   ├── OverlayAnimatedA (TextureRect)         ← layer 30 Prism / Cursed (one slot — they are mutually exclusive)
│   └── OverlayHighlight (TextureRect)         ← layer 40 Ultimate's extra sheen
└── ChromeUI (Control)                         ← layer 100 cost circle, name plate, stats, faction sigil
    ├── NameLabel
    ├── CostBadge
    ├── StatsBadge
    └── FactionSigil
```

**Why this shape:**
- Each treatment renders into ONE pre-allocated TextureRect slot, not a dynamically-created node. Spawning/freeing nodes per CardView is expensive when the player browses a 200-card collection. We allocate the slots once; treatments toggle `visible` and rebind shader uniforms.
- ArtFrame contains all treatment-affected layers. ChromeUI sits above EVERYTHING and is never shaded by treatments (cost circle stays cost circle whether the card is Foil, Gold, or Ultimate). This keeps stat readability constant — a critical UX rule, never let a cosmetic obscure a stat number.
- The scene tree IS the layer order: Godot's CanvasItem render order = tree order top-to-bottom. The layer numbers in `card_treatment.gd::stack_layer` are advisory metadata for the engine to assert the slot a treatment goes into.

## 2. Canonical layer order

This is the locked layer scheme. T1 stack_layer values get rebalanced to match (open Q1 below).

| Layer | Slot | Treatment(s) that bind here | Notes |
|---|---|---|---|
| 0 | Art TextureRect (texture binding) | Ink (alt_art_id) | Substitutes the base art texture. NOT a shader; just a texture swap. |
| 10 | Art TextureRect (material) | Gold | HSV-shift shader runs on the art itself. Affects ONLY the art region. |
| 15 | FrameDecal | Faction frames (×5) | Faction-themed border PNG. Pre-rendered (PSD-template per `art_direction.md` §2). |
| 20 | OverlayStatic | Foil | Static sparkle PNG with screen-blend shader. Cheap. |
| 30 | OverlayAnimatedA | Prism, Cursed | One slot — mutually exclusive (can't own both Prism AND Cursed on the same card simultaneously per economy spec). Animated shader. |
| 40 | OverlayHighlight | Ultimate's extra sheen | Only the Ultimate combo binds here. Animated diagonal sheen sweep. |
| 100 | ChromeUI | (none) | Always above all treatments. Cost / name / stats stay readable. |

**Why Ink at layer 0:** Ink is an alt-art swap (different illustration, monochrome ink-line treatment). It's not a shader pass — it just replaces the texture loaded into the Art TextureRect. Layered "below" everything because it changes the substrate, not an overlay.

**Why Gold below the frame:** Gold HSV-shifts the art only. The faction frame is its own decal asset and is pre-coloured (brass / silver / bog-iron / etc.); it should NOT shift to gold when Gold treatment is applied. This keeps faction identity readable on a Gold-treated card.

**Why one OverlayAnimatedA slot:** Battery cost. Two animated shaders running per card × 7 cards in hand × 60fps = noticeable thermal load on mid-tier Android. Limiting to one animated overlay per card caps the cost. Ultimate's Layer 40 sheen is animated but is a deliberate exception (a single SKU at $49.99 — whales pay for the cost).

## 3. Per-treatment shader spec

Each shader is a Godot `canvas_item` shader. Shader files live at `res://game/shaders/treatments/<id>.gdshader`. Material instances are pre-created and bound at runtime via `set_shader_parameter()`.

### 3.1 `gold.gdshader` — HSV-shift + metallic mask
- **Layer:** 10 (binds to Art.material)
- **Uniforms:**
  - `hue_shift_target: float = 50.0` (degrees, gold-yellow centre)
  - `saturation_boost: float = 0.4`
  - `value_floor: float = 0.15` (lift shadows so gold reads "metallic" not "muddy")
  - `metallic_mask_strength: float = 0.7` (0 = flat HSV-shift, 1 = strong specular highlight on bright pixels)
- **Technique:** sample art texture → RGB→HSV → shift H toward target weighted by current_value (preserves art readability — only mid-and-high values shift) → boost S → floor V → HSV→RGB. Multiply a metallic-mask texture (one shared asset) into the highlight channel.
- **Cost:** ~6 ALU + 2 texture taps per pixel. Cheap.
- **Animated:** no.

### 3.2 `foil.gdshader` — Static sparkle overlay
- **Layer:** 20 (binds to OverlayStatic.material)
- **Uniforms:**
  - `sparkle_density: float = 0.6`
  - `sparkle_tint: vec4 = vec4(1.0, 0.95, 0.8, 1.0)` (warm white)
  - `art_alpha_mask: sampler2D` (so sparkles only land on the art, not the transparent corners)
- **Technique:** voronoi/noise-based sparkle pattern × art_alpha_mask × sparkle_tint. Screen-blend onto the art layer.
- **Cost:** ~8 ALU + 1 texture tap. Cheap.
- **Animated:** no (static highlight — Foil is the entry-tier).

### 3.3 `prism.gdshader` — Animated rainbow shimmer
- **Layer:** 30 (binds to OverlayAnimatedA.material)
- **Uniforms:**
  - `time: float` (driven by `_process`)
  - `shimmer_speed: float = 0.5` (Hz)
  - `wavelength: float = 0.3` (UV space — controls band width)
  - `art_alpha_mask: sampler2D`
- **Technique:** animated angular gradient using `hsv2rgb(vec3(fract(uv.x * wavelength + time * shimmer_speed), 0.7, 1.0))` × art_alpha_mask. Add-blend at ~30% opacity onto the art.
- **Cost:** ~10 ALU + 1 texture tap, runs every frame. Mid.
- **Animated:** yes.
- **Low-power downgrade:** `shimmer_speed → 0` (becomes a static rainbow gradient at the current frame's offset). See §5.

### 3.4 `cursed.gdshader` — Animated green-pyre flame
- **Layer:** 30 (binds to OverlayAnimatedA.material — mutually exclusive with Prism)
- **Uniforms:**
  - `time: float`
  - `flame_speed: float = 1.2` (Hz, faster than Prism — flames flicker)
  - `flame_tint: vec4 = vec4(0.3, 1.0, 0.5, 1.0)` (witchfire green, pulled from Coven palette accent)
  - `art_alpha_mask: sampler2D`
- **Technique:** scrolling perlin noise warped upward (flame UV = uv + vec2(0, time * flame_speed)) → threshold to flame shape → tint by flame_tint with alpha falloff at the top edges. Add-blend at ~40% opacity.
- **Cost:** ~12 ALU + 2 texture taps (perlin lookup + alpha mask). Mid.
- **Animated:** yes.
- **Low-power downgrade:** `flame_speed → 0` (frozen flame frame). See §5.

### 3.5 Ultimate's extra sheen — `ultimate_sheen.gdshader`
- **Layer:** 40 (binds to OverlayHighlight.material)
- **Uniforms:**
  - `time: float`
  - `sweep_speed: float = 0.3` (Hz — slow, ceremonial)
  - `sweep_width: float = 0.15` (UV)
  - `sheen_tint: vec4 = vec4(1.0, 0.95, 0.7, 1.0)`
- **Technique:** diagonal band that sweeps across the card every ~3.3s. Mask by art_alpha. Screen-blend at peak ~60% opacity, alpha-falls-off either side of the band.
- **Cost:** ~6 ALU + 1 texture tap. Cheap-mid.
- **Animated:** yes.
- **Low-power downgrade:** `sweep_speed → 0.05` (still moves but barely — Ultimate is the whale SKU; we don't fully kill the animation, just slow it).

### 3.6 Faction frame decals — NOT shaders, just textures
- **Layer:** 15 (FrameDecal TextureRect — `texture` swap, no material)
- 5 PNG assets authored in T3 from PSD-template per `art_direction.md` §2.
- The base CardView ALREADY draws the always-on UI chrome (cost circle, name plate); FrameDecal adds the faction-specific overlay (brass arch, briar tangle, antler corners, etc.).

### 3.7 Default treatment — no shaders, no decal
- All slots `visible = false`. Cleanest possible render. Acts as the "off" state; every other treatment toggles slots ON.

## 4. Combo resolution algorithm

`CardTreatment.combines: Array[StringName]` is the list of treatment IDs that compose this treatment. Currently only Ultimate uses it (`combines = [&"gold", &"prism"]`).

**Engine algorithm** (pseudocode for the future `CardView::apply_treatment(treatment_id, catalog)` method):

```
func apply_treatment(tid: StringName, cat: TreatmentCatalog):
    var t = cat.get_by_id(tid)
    if t == null: return
    # Reset all slots to off.
    _reset_slots()
    # Build the resolved list: if t.combines is non-empty, expand it; else just [t].
    var to_apply: Array[CardTreatment] = []
    if t.combines.is_empty():
        to_apply.append(t)
    else:
        for sub_id in t.combines:
            var sub = cat.get_by_id(sub_id)
            if sub: to_apply.append(sub)
        to_apply.append(t)  # the combo treatment itself for its own layer (Ultimate's sheen)
    # Sort ascending by stack_layer.
    to_apply.sort_custom(func(a, b): return a.stack_layer < b.stack_layer)
    # Bind each into its slot.
    for sub in to_apply:
        _bind_to_slot(sub)
    # Faction frame (separate code path — set by player choice independently of treatment).
    _apply_faction_frame(player_collection.get_frame_for(card_id))
```

**Key invariants:**
- Combo treatments include a self-entry (Ultimate's own layer-40 sheen) AND the components (Gold + Prism). All three render simultaneously.
- Slot conflicts (e.g. two treatments wanting OverlayAnimatedA) are caught by `_bind_to_slot` — log a warning and let last-write-wins. Should not occur in the locked catalog (Prism and Cursed are mutually exclusive per §2).
- Faction frame is independent of treatment. A card can be (Default + Iron Penitents Frame) OR (Ultimate + Iron Penitents Frame). Both cosmetic axes compose.

## 5. Low-power mode downgrade rules

Detect via `OS.is_in_low_processor_usage_mode()` OR a player-toggleable Settings option ("Reduce battery usage"). When enabled:

1. All animated shaders set their speed uniform to 0 (or near-0 for Ultimate). Shader still binds, just doesn't animate.
2. OverlayAnimatedA and OverlayHighlight stay visible — players who paid for Prism/Cursed/Ultimate still see the visual difference, just frozen.
3. Foil and Gold are unaffected (already static / cheap).

This preserves the perceived value of paid treatments while halving the per-card pixel-shader cost. Acceptable trade because the player opted in to battery saving.

## 6. Performance budget

- Target: 7 CardViews visible in hand simultaneously, each with full treatment stack, at stable 60fps on a Pixel 6a equivalent (Adreno 642L) and an iPhone 11 (A13).
- Worst case = 7 × Ultimate = 7 × (Gold + Prism + Ultimate-sheen) = 7 × 3 animated shader passes + 7 × 1 art-modifier pass + 7 × frame decal + 7 × ChromeUI = ~28 shader passes per frame.
- Estimated cost at 200×280 px each = ~7 × 56,000 px × 28 ALU = ~11M ALU ops/frame. Comfortably under mobile GPU budget (most mobile GPUs handle 1–5 GFLOPS).
- **Stress-test ticket:** spawn 10× Ultimate cards in a debug scene, measure frame time, gate B4 on ≤16ms.

## 7. Implementation roadmap (follow-up tickets)

These are the tickets that should appear in the backlog after T2 lands. NOT to be authored as part of this T2 heartbeat — they need real card art and the B3 pipeline running.

- **T2.1** Author `gold.gdshader` body + tune against 3 sample cards from each faction.
- **T2.2** Author `foil.gdshader` body + tune sparkle density.
- **T2.3** Author `prism.gdshader` body + tune wavelength + speed.
- **T2.4** Author `cursed.gdshader` body + tune flame shape + speed against Coven palette.
- **T2.5** Author `ultimate_sheen.gdshader` body + tune sweep timing.
- **T2.6** Refactor `CardView` scene to the §1 tree shape; pre-allocate slots; wire `apply_treatment()`.
- **T2.7** Update `treatment_definitions.tres` with shader_path values + the rebalanced stack_layer values per §2.
- **T2.8** Stress-test 10× Ultimate-treated cards on Pixel 6a — frame time ≤ 16ms target.
- **T2.9** Settings toggle for "Reduce battery usage" + wire into shader uniform broadcast.

## 8. Open questions for Paul

1. **Stack-layer rebalance** — current T1 catalog has Ink=5, Frame=10, Gold=15, Foil=20, Prism/Cursed=30, Ultimate=40. §2 of this doc keeps the same numbers EXCEPT swaps Frame and Gold (Frame moves to 15, Gold moves to 10 — so Gold's HSV-shift only touches the art and the faction frame stays its native colour). Confirm acceptable. _(Cowork's recommendation: yes; alternative breaks faction identity readability on Gold cards.)_
2. **Faction frames + Cursed event-exclusive** — does Cursed treatment override the faction frame, or stack with it? Recommendation: stack with it (frame layer 15, Cursed overlay layer 30 — they don't fight for a slot). Confirm.
3. **Prism vs Cursed mutual exclusivity** — economy spec doesn't formally say a player CAN'T own both for the same card. Engine assumes one OverlayAnimatedA slot. If both are owned, last-applied wins (player picks which to display in the collection screen, T4). Acceptable?
4. **Ink + Gold combo** — Ink is an alt-art (monochrome). Gold is HSV-shift. If a player owns both for a card, the Gold shift would tint the monochrome ink art gold. This might look great or terrible — need a visual test once any shader exists. No engine-side block; just flagging.
