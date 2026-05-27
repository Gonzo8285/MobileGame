# UI shotlist v0 — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory item GFX-4 + GFX-6/7/8/13 (icons / splash / app icon / boards / store screenshots). Extends `IMAGE-GEN-SHOTLIST.md` (which covers card art / faction frames / sigils / warlords / enemies) with UI-layer art asks: icons, splash, app icon, board backgrounds, status overlays, store-listing screenshots._

**Status:** v0 spec. Pure design doc.

---

## 1. Icon pack — gameplay UI iconography (GFX-4)

### 1.1 Required icon set (30 icons)

| ID | Icon | Use | Variants |
|---|---|---|---|
| ico-cost | mana orb | card mana cost | base + faction-tinted (5) |
| ico-hp | drop-of-blood | unit HP / player HP | base + low-HP red variant |
| ico-atk | crossed-blades | unit attack | base |
| ico-range-melee | fist-overlap | range MELEE | base |
| ico-range-short | bow-aimed | range SHORT | base |
| ico-range-long | spire-arrow | range LONG | base |
| ico-faction-penitents | brass execution-mask (small) | faction tag | inherited from S1 sigil |
| ico-faction-mourners | raven-quill | faction tag | inherited from S2 sigil |
| ico-faction-coven | demon-coin-in-hex | faction tag | inherited from S3 sigil |
| ico-faction-legion | crossed-batons-over-gorget | faction tag | inherited from S4 sigil |
| ico-faction-pact | antler-crown-over-seedling | faction tag | inherited from S5 sigil |
| ico-keyword-bleed | crimson droplet trail | BLEED status | base + animated tick |
| ico-keyword-poison | green skull | POISON status | base + animated tick |
| ico-keyword-fear | trembling skull | FEAR status | base |
| ico-keyword-root | thorn-twined ankle | ROOT status | base |
| ico-keyword-slow | hourglass-half | SLOW status | base |
| ico-keyword-smoke | smoke-curl | SMOKE tile | base + animated |
| ico-keyword-dread | inverted-pentagram | DREAD status | base |
| ico-keyword-shield | tower shield-iconic | SHIELD charges | base + per-charge count overlay |
| ico-keyword-persist | spectral hand-rising | PERSIST queue | base + glow |
| ico-keyword-resurrect | phoenix-spiral | RESURRECT remaining | base |
| ico-keyword-cleave | arc-of-strikes | CLEAVE on attack | base |
| ico-keyword-pierce | thrust-arrow | PIERCE on attack | base |
| ico-keyword-taunt | shout-mouth | TAUNT | base |
| ico-curr-gold | gold-coin (in-run) | Gold currency | base |
| ico-curr-bones | white-bone-shard | Bones currency | base |
| ico-curr-marrow | red-marrow-vial | Marrow Shards currency | base |
| ico-curr-gems | violet-gem | Gems currency | base |
| ico-curr-souls | pale-flame | Souls currency | base |
| ico-hanging-hour | gallows-clock | HH timer marker | base + active animated |

### 1.2 Style guide

- **Format:** SVG masters (vector), exported to PNG at 64×64 (1×) and 128×128 (2×).
- **Stroke:** 2px @ 1× (4px @ 2×), monochrome.
- **Palette:** white-on-dark default. Faction-tint variants override fill color per faction.
- **Compositional consistency:** all icons fit within a 56×56 inner bounding box (8px padding for touch-target).
- **Reference style:** Phosphor Icons / Game-Icons.net for silhouette readability.

### 1.3 Asset path layout

```
res://game/art/icons/
├── 1x/
│   ├── ico-cost.png
│   ├── ico-cost-iron-penitents.png
│   ├── ico-hp.png
│   └── ...
├── 2x/
│   └── ...
└── source/
    └── *.svg
```

### 1.4 Effort + sourcing

- Total: 30 icons × 2 densities + 5 faction tints on `ico-cost` + animated variants on 4 status icons = ~80 assets
- Sourcing options: hand-author (Krita / Inkscape) OR pre-made library (Game-Icons.net is CC-BY, suitable)
- Recommended: pre-made library for v1, hand-replace for v1.1 once art direction is more locked
- Effort: **M** — 1-2 days for full set + faction tints

---

## 2. Status-effect overlay VFX (GFX-5)

### 2.1 Overlay set (8 status types)

| Status | Visual treatment | Animation |
|---|---|---|
| BLEED | crimson drip aura around unit sprite | continuous drip every 1.5s |
| POISON | green miasma cloud overlay | slow swirl, opacity-pulse |
| FEAR | desaturated tint + shaking sprite | sprite shakes 2px every 0.5s |
| ROOT | brown vine-overlay at unit's base | static, fade in/out on apply |
| SLOW | translucent slowmotion-blur trail | trails position lag by ~2 frames |
| SMOKE | grey-green smoke tile (lane-level, not unit-level) | continuous lazy drift |
| SHIELD | golden translucent half-sphere around unit | shimmer once per 2s, breaks-on-consume animation |
| PERSIST | spectral after-image floating above death-tile, awaiting return | gentle bob + fade-in on death, anchor for HH return |

### 2.2 Per-status particle + shader spec

```
class_name StatusOverlay extends Node2D

@export var status_id: GFEnums.Status
@export var particle_count: int  # 5-15 depending on status
@export var shader_path: String
@export var anchor_offset: Vector2  # offset from sprite origin
@export var z_order_offset: int     # above or below sprite
@export var fade_in_ms: int = 200
@export var fade_out_ms: int = 200
@export var loop: bool = true
```

### 2.3 Mobile perf budget

- **Max 30 status overlays simultaneously** (across all units in combat)
- **Per-overlay ALU budget:** < 4 ms render @ 60fps target
- **Auto-LOD:** in Quality=Low setting (per `interaction_touch_v0.md` §4.1), overlays drop to static icons (no particles)

### 2.4 Effort + sourcing

- 8 overlays × particle preset + shader = 16 files
- Per-overlay author time: ~2 hours (Godot ParticleProcessMaterial + GLSL shader)
- Total: **M effort** — 2 days

---

## 3. Splash / loading screen (GFX-6)

### 3.1 Splash

- **Asset:** single 1080×1920 portrait image
- **Subject:** the gallows-tree silhouette against an ash-grey dawn sky, single rope hanging
- **Title overlay:** "The Curse of Gallowfell" in Cinzel font, candle-gold color, drop-shadow
- **Treatment:** painterly oil per `art_direction.md`
- **AI-gen prompt template:** existing universal prefix per `pipeline_spec.md` §3.1 + subject "gallows-tree silhouette, single rope, dawn-grey backlight, the empire's executions tree, painterly oil, no figures, no text"
- **Path:** `res://game/art/splash/splash_v1.png`

### 3.2 Loading flavour text

20 lines, rotated randomly during loads. Each ≤ 80 chars:

```
1. "The dead refuse to leave Gallowfell."
2. "Every confession is heard. None are answered."
3. "The Hanging Hour comes again."
4. "Iron rusts in the Cathedral Ruins."
5. "Court has been postponed for forty years and counting."
6. "The bog remembers your name."
7. "A regiment sent. No orders to leave."
8. "The Cinderwood does not burn out."
9. "The bell tolls for the one wrongly hanged."
10. "Coin face up in the mud — take it if you dare."
11. "The flagellants keep walking. The road keeps adding miles."
12. "An empty throne is the worst kind."
13. "The smoke does not lift. The smoke knows."
14. "Wolves with hands. Hands with antlers. Antlers with eyes."
15. "Pray, or defile. The shrine doesn't care which."
16. "A reliquary cracked open. The bone was still warm."
17. "Eleven names hang from the gallows-tree. One name shouldn't."
18. "The curse keeps the dead from staying dead."
19. "The Marrow Pass begins again."
20. "Lower the bell, raise the choir."
```

### 3.3 Effort

- Splash: AI-gen + manual title overlay, ~1 hour
- Flavour text: written above
- Total: **S effort**

---

## 4. App icon (GFX-7)

### 4.1 Master asset

- **Source:** 1024×1024 PNG, painterly oil treatment
- **Subject:** single brass execution-mask centered, dripping wax, against ash-grey background
- **Title text:** none (icon must read at 60×60 — text would not survive)

### 4.2 Adaptive icon (Android)

- Foreground layer: 432×432 PNG of just the mask (no background)
- Background layer: 432×432 PNG of ash-grey + candle-gold radial gradient

### 4.3 iOS sizes

| Size | Use |
|---|---|
| 1024×1024 | App Store master |
| 180×180 | iPhone 6 Plus and later |
| 167×167 | iPad Pro |
| 152×152 | iPad |
| 120×120 | iPhone 6 and later |
| 87×87 | iPhone 5 / 6 spotlight |
| 80×80 | iPad spotlight |

### 4.4 Effort

- 1 master + 6 iOS exports + 2 Android adaptive = ~9 files
- Generate via 1 AI render + automated resize script
- Total: **S effort**

---

## 5. Lane / board background art per biome (GFX-8)

Cross-reference `variants_system_v0.md` §6 for the full board catalogue. Authoring spec here.

### 5.1 Per-biome boards (5 launch)

| Board | Subject | Color palette | LoRA stack |
|---|---|---|---|
| Cathedral Ruins | fallen pews + cracked basilica, candle-yellow shafts | oxblood / dull iron / candle-yellow | Iron Penitents stack |
| Catacombs | corridor of standing dead + signet seals + raven feathers | bruise-purple / tarnished gold / grave-grey | Ash-Mourners stack |
| Black Mire | bog water + demon-coins + reed banks | bog-green / coin-gold / leech-purple | Coven stack |
| Foundry | iron rails + soot smoke + forge embers | soot-black / brass / ember-orange | Last Legion stack |
| Cinderwood | half-burnt forest + antler-bark trees + cinder embers | bark-brown / cinder-orange / ash-grey | Skinward Pact stack |

### 5.2 Per-board asset spec

- **Resolution:** 1080×1920 portrait (matches mobile screen)
- **Parallax layers:** 3 layers (sky / mid / foreground) — separate PNG exports
- **Atmospheric depth:** background = blurred painterly; foreground = sharp painterly
- **No characters:** boards must read as backgrounds, not action art
- **Composition:** central 60% of board left visually "open" so lanes overlay readably

### 5.3 Bell Cathedral (S1 hero board)

Per `season_pass_v0.md` S1 premium tier 15 reward. Same biome as Cathedral Ruins but with the Black-Bell Choir's bell-tower visible in the background. Bell glows faintly green. Same spec as launch boards.

### 5.4 Effort

- 5 launch boards × 4 assets (1 base PNG + 3 parallax layers) = 20 PNGs
- Per-board author: AI-gen base + manual parallax slice = ~2 hours
- Total: **M effort**

---

## 6. In-app store screenshot pack (GFX-13)

Required for App Store + Google Play listing. Per `phase1_brief.md` R11 ASO research.

### 6.1 Required count (per Apple + Google guidance)

- iOS: minimum 3, maximum 10 screenshots per device size (5.5" iPhone, 6.5" iPhone, 6.7" iPhone, 12.9" iPad if iPad-supported)
- Google Play: minimum 2, maximum 8 phone screenshots + 1-8 tablet screenshots

### 6.2 Screenshot list (5 launch)

| # | Caption overlay | Subject (in-app capture) |
|---|---|---|
| 1 | "Build a deck. Push the curse back." | Combat scene with 3 cards in fan, Vyrrun warlord visible, mana 5/5, enemies in lane |
| 2 | "Five factions. Five fantasies." | Faction-select screen with all 5 Warlord portraits (or fallout if Warlord-select shown) |
| 3 | "The Hanging Hour returns the dead." | Hanging Hour mid-screen flash with Persist-queue visible, dramatic moment |
| 4 | "Eleven Warlords. One curse." | Roster grid showing all 11 Warlords at various tiers |
| 5 | "Earn cosmetics. Never pay for power." | Collection grid showing Foil/Gold/Prism-treated cards |

### 6.3 Per-screenshot spec

- **Resolution:** 1242×2688 px (iPhone 6.5") + 1290×2796 px (iPhone 6.7") + 1080×1920 px (Android phone tier-1) + 2048×2732 (iPad 12.9")
- **Captions:** rendered in Cinzel font, candle-gold, white drop-shadow, top 20% of screen
- **In-app captures:** taken from real builds (not mocked) — IMV-2 milestone gates real captures
- **Device-frame option:** wrap in device chrome OR leave raw — Apple allows either

### 6.4 Effort

- 5 screenshots × 4 device sizes = 20 captures
- Per-capture: ~30 min including caption + crop + resize
- Total: **M effort** — 1 day once captures available

---

## 7. Hanging Hour full-screen VFX (GFX-9)

Cross-references `gameplay_keywords_resolution_v0.md` §1 and inventory item GP-8.

### 7.1 Visual sequence

```
0.0s: Combat scene as normal
0.0s: Screen tint shifts ash-grey, vignette darkens edges
0.2s: Bell-toll SFX peak
0.3s: Full-screen flash — pale green at 30% opacity, fades over 800ms
0.5s: Diegetic clock graphic overlay (gallows-clock from icon pack) at top-center, briefly shows "23:59 → 00:00"
1.5s: Tint and flash clear; HUD pulses heavy haptic (per `interaction_touch_v0.md` §8.1)
1.5s: Persist-queue resolution begins
```

### 7.2 Asset list

- 1 full-screen ash-grey overlay shader (alpha animated)
- 1 pale-green flash shader (alpha + opacity ramp)
- 1 vignette texture (1080×1920 dark edges)
- 1 gallows-clock graphic (768×768)
- 1 bell-toll SFX (cross-ref AUD-3 in `audio_direction_v0.md`)

### 7.3 Reduce-motion variant

Per `interaction_touch_v0.md` §10: if `reduce_motion` setting ON, replace full-screen flash with a static text banner: "THE HANGING HOUR" displayed for 1.5s + bell-toll SFX still plays. No tint, no shake.

### 7.4 Effort

- VFX + assets: ~4 hours
- Total: **S effort**

---

## 8. Card art consistency audit (GFX-10)

Heartbeat-driven post-Stage-B per inventory GFX-1/2.

### 8.1 Audit rubric

Per-card pass/fail score against 5 criteria (cross-ref `pipeline_spec.md` §5):

1. **Faction-readable** — silhouette + palette make faction obvious at thumbnail size
2. **Subject-clear** — what the card *does* visible in the art (e.g. Cleave card shows weapon-arc)
3. **Style-consistent** — painterly oil, no AI-tell hands, no Stable Diffusion bias artifacts
4. **Frame-fit** — composition leaves room for cost/HP/ATK overlays
5. **Treatment-compatible** — base art works with Foil/Gold/Prism/Ink overlays (no busy-detail-conflict)

### 8.2 Output

Per-card score sheet → `art_iterations/_audit_v0.md`:
```
| Card | Faction | Subject | Style | Frame | Treatment | Total /5 | Reroll? |
|---|---|---|---|---|---|---|---|
| P1 Cathedral Brother | ✅ | ✅ | ✅ | ✅ | ✅ | 5/5 | no |
| P12 Self-Scourge | ✅ | ✅ | ⚠️ AI hand artifact | ✅ | ⚠️ | 3/5 | yes |
| ... | | | | | | | |
```

### 8.3 Effort

- 216 cards × ~3 min per card = ~10 hours total
- Recommend split across 5 heartbeats post-Stage-B
- Total: **M effort**

---

## 9. Boss card art (GFX-11)

Per `bosses_v0.md` Open Q4 — boss art TBD until D-VALIDATE-1 Stage A clears.

### 9.1 Black-Bell Choir (Chapter 1)

- Composition: full-figure "boss" treatment, larger frame than standard
- Subject: a Person-shaped silhouette wearing a cloak of stitched bell-pulls, an iron bell where the face would be, green pyre flickering from the bell's mouth, hand raised in toll
- Reference: combines Ash-Mourners court-wear motif + reanimated-corpse motif + iconic religious figure pose
- Resolution: 1024×1536 (higher than standard 832×1166 — boss-tier)
- LoRA stack: Ash-Mourners stack per `pipeline_spec.md` §2.2

### 9.2 Future bosses

Chapter 2 + 3 bosses queued — spec to be added as bosses authored.

### 9.3 Effort

- Per-boss: 1 art spec + 1 AI-gen pass + review = **S effort**

---

## 10. Sigil glyph render (GFX-12)

Cross-ref `art_specs/_sigils.md` (S1-S5 specs are complete per backlog B3.0f).

### 10.1 Rendering

- All 5 sigils have full SDXL prompts authored
- Renders gated on B3.0a smoke test
- Output: 5 PNG @ 96×96 to `res://game/art/sigils/`

### 10.2 Effort

- 5 renders × ~3 min RunPod execute = **S effort** (mostly GPU cost ~£0.15)

---

## 11. Engine handoff

### 11.1 Asset folder structure

```
res://game/art/
├── splash/
│   └── splash_v1.png
├── app_icon/
│   ├── master_1024.png
│   ├── ios/  (6 sizes)
│   └── android/  (foreground + background)
├── icons/  (per §1.3)
├── boards/
│   ├── cathedral_ruins/  (base + 3 parallax)
│   ├── catacombs/
│   ├── black_mire/
│   ├── foundry/
│   ├── cinderwood/
│   └── bell_cathedral/  (S1 hero)
├── overlays/  (per §2 — 8 status overlays)
├── sigils/  (per §10)
├── bosses/
│   └── chapter_1_black_bell_choir.png
├── warlords/  (per existing pipeline)
└── cards/  (per existing pipeline)
```

### 11.2 UI scene additions

- `loading_screen.tscn` — splash + flavour-text rotator
- `status_overlay_pool.gd` — object pool for runtime status overlays
- `hanging_hour_vfx.tscn` — full-screen HH sequence

---

## 12. MVP coverage

| Asset | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| Icon pack (30 icons) | — | placeholder Game-Icons | full pack | full | full |
| Status overlays | — | static icons | particle versions | full | full |
| Splash | placeholder | painterly v1 | v1 | v1 | v1 |
| Loading flavour text | — | ✅ | ✅ | ✅ | ✅ |
| App icon | placeholder | painterly v1 | v1 | v1 | v1 |
| Boards (5) | placeholder | 1 board | 5 launch | + Bell Cathedral S1 hero | + seasonal |
| HH VFX | — | ✅ | ✅ | ✅ | ✅ |
| Boss art (B1) | — | placeholder | painterly v1 | v1 | v1 |
| Store screenshots | — | placeholder | 5 captures | 5 captures + localised | full localised |

---

## 13. Cross-references

- `IMAGE-GEN-SHOTLIST.md` — covers card / faction frame / sigil / warlord / enemy art (this doc extends with UI-tier).
- `art_direction.md` — palette + style lock.
- `pipeline_spec.md` — SDXL prompt template, LoRA stacks, sampler lock.
- `variants_system_v0.md` §6 — board skin catalogue this doc authors against.
- `interaction_touch_v0.md` — UI touch-targets size + accessibility hooks.
- `gameplay_keywords_resolution_v0.md` — status visualisation contract for §2 overlays.

— Controller, 2026-05-21
