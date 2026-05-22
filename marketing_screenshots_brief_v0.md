# Store Screenshots Brief v0 — The Curse of Gallowfell

_Authored 2026-05-22 by Controller (round 3). Eight launch screenshots, speced for App Store + Google Play. Closes inventory item GFX-13. Pixel sizes match Apple HIG (6.7" iPhone Pro Max master) and Google Play 16:9 phone master, both upscaled/downscaled per platform requirements. Accessibility floor: no text smaller than 16pt on the canvas surface._

**Status:** v0 spec. Pre-capture. Gated on D-VALIDATE-1 Stage A (anchor renders) + the engine reaching presentable-GUI state.

---

## 1. Top-line rules (all 8 screenshots)

- **Aspect ratio (portrait):** 9:19.5 master canvas (6.7" iPhone Pro Max) — **1290 × 2796 px** for iOS, **1080 × 2400 px** for Play. We author at iOS master and downscale to Play.
- **Aspect ratio (landscape tablet, optional Y1):** 4:3 — **2048 × 2732 px** (iPad master). Spec'd at end of doc.
- **Colour profile:** Display P3 (Apple) + sRGB (Play). Author in Display P3, export sRGB for Play.
- **Safe zones:** keep critical content within the centre 80% of canvas. Apple crops top + bottom variably on listing previews.
- **Overlaid text floor:** no text smaller than **16pt on the canvas surface** (~80px on the 1290-wide master). Headers ≥ 56pt. Lower-thirds ≥ 28pt.
- **Font:** wordmark + headers use the game's display face; body / lower-third uses Inter Tight (or near substitute) at 600 weight on dark backgrounds.
- **Palette anchor:** ash-grey (#1A1A1F), candle-gold (#D9B673), blood-red (#7A1A1A), Mourners' purple (#3A1E3A). One accent per screenshot — never two.
- **Accessibility:** all overlaid text must hold ≥4.5:1 contrast against the underlying frame in the bounding box. Colour-blind-safe palette by default. No red/green-only signalling.
- **Localisation flag:** all overlaid text in English at v1.0; brief left enough margin to swap in German / French / Spanish / Portuguese-BR strings at 20% longer without reflow.
- **Source of capture:** in-engine, build-tagged. NO mockups in final. The brief authors against mockups; the captures replace them 1:1.

---

## 2. Slot map

| # | Slot intent | Why this slot | Palette anchor |
|---|---|---|---|
| 1 | HOOK — Title + Hanging Hour bell-toll | First-frame conversion; what the game _is_ in one image | candle-gold + ash-grey |
| 2 | SYSTEM — Lane-defence with cards in hand | Show the loop in one frame | blood-red |
| 3 | WARLORD ROSTER — Five free Warlords | "There's variety" in one frame | Mourners' purple |
| 4 | DECKBUILD — Reward-pick + faction-weighted pool | "You build decks" without saying it | candle-gold |
| 5 | BOSS — The Black-Bell Choir at Hanging Hour | Spectacle frame | blood-red |
| 6 | META — Ancestor Tree + Ascension | "There's depth past one run" | ash-grey |
| 7 | FACTIONS — Five-biome strip | World-tour frame | rotating per faction |
| 8 | MARROW PASS + COSMETICS — Treatment ladder | "Cosmetic-only" promise made visible | Mourners' purple + gold |

Order is **store-display order** (slots 1–3 are the editorial-most-visible on both stores).

---

## 3. Per-slot briefs

### Slot 1 — HOOK · Title + Hanging Hour bell-toll

- **Slot rationale.** The first screenshot is the only one a player will guaranteed look at. It must answer "what is this?" in <1 sec. Choice: lead with the **signature moment** (the Hanging Hour bell-toll) rather than a generic combat shot.
- **iOS pixel size.** 1290 × 2796 px (6.7" master). Apple downscales for 6.5" + 5.5" listings automatically.
- **Play pixel size.** 1080 × 2400 px. Re-exported from master.
- **In frame.** Game in progress, mid-Hanging-Hour. Screen ash-tinted (per `gameplay_keywords_resolution_v0.md` §"Hanging Hour UX lock"). Diegetic clock visible reading **23:59 → 00:00**. Three lanes visible. One friendly unit just buffed +1 ATK (visible particle). The gallows-bell icon top-right glows. Wordmark **THE CURSE OF GALLOWFELL** is _not_ on this screenshot — that's slot 8's tail. This frame is gameplay.
- **Overlaid text + position.** Top-of-frame, header band at **y=240–440 px** (within top safe area).  
  Header: **"The Hanging Hour."** _(56pt, candle-gold, centered)_  
  Sub: **"Every fight has a moment the dead remember."** _(28pt, ash-white, centered, below header at y=520)_  
  No CTA on this slot. Let the spectacle carry.
- **Background / palette.** Ash-tinted desaturated frame. Candle-gold rim-light on the bell icon. Blood-red BLEED tick particle on one enemy. No other colour.
- **A11y notes.** Header 56pt (well above 16pt floor). Sub 28pt. Contrast against ash-grey backdrop ≥ 7:1. No red/green-only cue. Diegetic clock readable at 320×640 thumbnail size.
- **Acceptance check.** Show the screenshot at thumbnail size (174×376 in App Store listing). The Hanging-Hour bell-toll moment must read as the subject in <1 sec without zooming. If a tester can't say "something dramatic is happening" without zooming, reshoot.

### Slot 2 — SYSTEM · Lane defence with cards in hand

- **Slot rationale.** Slot 2 explains the game mechanically. The "deck plus lanes" combination is genre-novel; show it.
- **iOS pixel size.** 1290 × 2796 px.
- **Play pixel size.** 1080 × 2400 px.
- **In frame.** Three lanes from a slight elevated angle. 7–8 friendly units placed, 5–6 enemies advancing. **Hand-fan of 5 cards visible bottom 35% of frame.** Mana counter shows 5/8. One card mid-drag toward the centre lane — thumb visible (in-frame thumb illustration, NOT a real photographed thumb). UI icons clear: cost / ATK / HP / range / faction tag.
- **Overlaid text + position.** Top band y=240–520 px.  
  Header: **"Build a deck. Hold the lane."** _(56pt, ash-white, centered)_  
  Sub: **"60-second combats. Eight per run."** _(28pt, candle-gold, centered)_  
  Lower-third at y=2400–2600: **"DECKBUILD · LANE DEFENCE · ROGUELITE"** _(20pt, all-caps, ash-grey on candle-gold band)_
- **Background / palette.** The Foundry biome — soot-black + brass + ember-orange. Mostly desaturated except the dragged card glow (brass-orange).
- **A11y notes.** All overlaid text ≥ 20pt. UI icons in the captured frame at ≥ 32px square. Contrast ≥ 4.5:1 on lower-third caption.
- **Acceptance check.** A new player should be able to point at this screenshot and say "you put down cards to defend lanes." If they say "is it a CCG?" we missed.

### Slot 3 — WARLORD ROSTER · Five free Warlords

- **Slot rationale.** Slot 3 promises variety. The free roster is the headline (paid roster spoils that there's paid).
- **iOS pixel size.** 1290 × 2796 px.
- **Play pixel size.** 1080 × 2400 px.
- **In frame.** Warlord-select grid from `warlord_select_ui_v0.md`. **Five free Warlords in a quincunx (4 corners + 1 centre)** with Sieren (Court-Necromant, the trailer's hero) centre. Each Warlord shows portrait + faction sigil + playstyle tag. Background is the Catacombs biome behind the grid.
- **Overlaid text + position.** Top band y=240–520.  
  Header: **"Eleven Warlords. Five factions."** _(56pt, ash-white)_  
  Sub: **"Five free forever. One you can never buy."** _(28pt, candle-gold)_  
  Each Warlord portrait already has its name + faction + playstyle tag baked into the UI; no extra overlay needed.
- **Background / palette.** Mourners' purple wash through the Catacombs. Candle-gold rim on Sieren (centre).
- **A11y notes.** Warlord-portrait label text in the captured UI must be ≥ 18pt at 1290-wide. Playstyle tags (AGGRO / CONTROL / SWARM / TEMPO / SUMMONER) at ≥ 16pt all-caps.
- **Acceptance check.** A reader at thumbnail size should see **five distinct silhouettes** without zooming. If two silhouettes blur together at 174-wide, re-pose them.

### Slot 4 — DECKBUILD · Reward-pick

- **Slot rationale.** Roguelite-deckbuilder buyers look for the reward-pick screen. Showing the 1-of-3 is shorthand for "Slay-the-Spire-style".
- **iOS pixel size.** 1290 × 2796 px.
- **Play pixel size.** 1080 × 2400 px.
- **In frame.** Reward-pick screen — three cards displayed face-up with full art + cost + stats + keyword text. Behind: blurred run-map showing 4 completed nodes + 4 ahead. Bottom: "SKIP" button (dimmed) + "TAKE" button (active on whichever card is centred). Centre card is **Hammer-Confessor** (3c Penitents, Cleave applies Bleed-1) — readable text.
- **Overlaid text + position.** Top band y=240–520.  
  Header: **"Pick one. Skip one. Build the run."** _(48pt, ash-white)_  
  Sub: **"Faction-weighted reward pools."** _(24pt, candle-gold)_
- **Background / palette.** Cathedral Ruins biome behind. Candle-gold on the centre card only.
- **A11y notes.** Card text within captured UI ≥ 18pt. Keyword chips (CLEAVE, BLEED) at ≥ 16pt all-caps. Contrast on header ≥ 7:1.
- **Acceptance check.** A roguelite-deckbuilder buyer should recognise the genre signal in <1 sec. The card art must be readable at thumbnail without being able to read every word.

### Slot 5 — BOSS · The Black-Bell Choir at Hanging Hour

- **Slot rationale.** Slot 5 sells _spectacle_. The chapter-1 boss is the strongest visual moment we have spec'd.
- **iOS pixel size.** 1290 × 2796 px.
- **Play pixel size.** 1080 × 2400 px.
- **In frame.** Mid-fight against The Black-Bell Choir. Boss centre-frame, three bells tolling, robed figures behind. Player has Crucified Saint deployed. Three lanes visible but lane-furniture compressed for the boss focal point. Hanging Hour active (ash-tint). One enemy mid-Reanimation rise. Player HP 18/30.
- **Overlaid text + position.** Top band y=240–520.  
  Header: **"Chapter 1."** _(40pt, candle-gold, all-caps)_  
  Sub: **"The town has eight bosses. The first one is the gentle one."** _(28pt, ash-white)_
- **Background / palette.** Mourners' purple wash. Blood-red on the boss's robe + Bleed particles. Candle-gold on the bells.
- **A11y notes.** Boss name + chapter label ≥ 24pt within captured UI. Damage numbers readable at ≥ 28pt where shown.
- **Acceptance check.** Reader should feel _scale_. If the boss looks the same size as a normal enemy at thumbnail, reframe. Boss should occupy ≥ 25% of the centred frame.

### Slot 6 — META · Ancestor Tree + Ascension

- **Slot rationale.** Slot 6 sells _depth past one run_. The two persistent systems shown together answer "is there a game after the run?"
- **iOS pixel size.** 1290 × 2796 px.
- **Play pixel size.** 1080 × 2400 px.
- **In frame.** Split-screen of two UI surfaces: top half (60%) = Ancestor Tree (30-node passive web, ~12 unlocked, candle-gold on unlocked, ash-grey on locked). Bottom half (40%) = Ascension ladder for one Warlord (Vyrrun), showing A1–A20 vertically with A1–A7 cleared. The bottom half's foreground modifier-tooltip reads: _"A8 · Hanging Hour fires turn 4 (was turn 5). Retry cost doubled."_
- **Overlaid text + position.** Centre band y=1300–1500 (between the two halves).  
  Header: **"Beyond the run."** _(48pt, ash-white)_  
  Sub: **"Spend Bones in the Ancestor Tree. Climb A1–A20 per Warlord."** _(24pt, candle-gold)_
- **Background / palette.** Ash-grey base. One candle-gold accent on the centred-band header. Tree-tile glow is brass-orange.
- **A11y notes.** Tree-node labels in captured UI ≥ 16pt. Ascension-ladder rung numbers ≥ 20pt. Modifier tooltip body ≥ 18pt.
- **Acceptance check.** A reader should leave this screenshot believing the game has _two distinct persistent systems_. If they read it as "one big upgrade screen", reshoot.

### Slot 7 — FACTIONS · Five-biome strip

- **Slot rationale.** Slot 7 sells _the world_. Five-biome strip is one frame that does what a trailer second-act does in 14 seconds.
- **iOS pixel size.** 1290 × 2796 px.
- **Play pixel size.** 1080 × 2400 px.
- **In frame.** Vertical 5-panel strip — Cathedral Ruins / Catacombs / Bog of Bargains / The Foundry / Cinderwood, top-to-bottom. Each panel ~520px tall, with the faction sigil in the bottom-left and the faction name in the bottom-right of each panel. Mid-frame divider lines in candle-gold, 2px.
- **Overlaid text + position.** Top header band y=80–240 (above the strip).  
  Header: **"Five factions. One cursed town."** _(40pt, ash-white)_  
  No sub-header. Let the strip carry.  
  Bottom band y=2580–2740 (below the strip): one-line tagline _"Pilgrims, mourners, witches, soldiers, the wild."_ _(24pt, candle-gold, centered)_
- **Background / palette.** Rotates per panel. Penitents = oxblood. Mourners = bruise-purple. Coven = bog-green. Legion = soot-black + brass. Skinward = ember-red + green.
- **A11y notes.** Faction name labels in captured strip ≥ 20pt. Sigils ≥ 96×96px. Contrast on each faction-name label vs its panel background ≥ 4.5:1.
- **Acceptance check.** Reader should be able to name two of the five factions from the visual alone, without overlay. If all five biomes blur together visually, re-stage.

### Slot 8 — MARROW PASS + COSMETICS · Treatment ladder

- **Slot rationale.** Slot 8 makes the **cosmetic-only promise visible**. Where slots 1–7 sold the game, slot 8 pre-emptively answers _"how does it monetise?"_ before the player even taps Install.
- **iOS pixel size.** 1290 × 2796 px.
- **Play pixel size.** 1080 × 2400 px.
- **In frame.** Top 50% = Marrow Pass screen showing free + premium tracks at tier 25/50, with one Cursed-treatment card (Vyrrun's Self-Scourge) glowing as the premium tier-50 hero reward. Bottom 50% = the treatment ladder for one card (Pall-Bearer) — seven thumbnails: Default → Foil → Gold → Ink → Prism → Cursed → Ultimate. **Wordmark THE CURSE OF GALLOWFELL** centred at the bottom y=2680, white wordmark on ash-grey.
- **Overlaid text + position.** Centre band y=1300–1480 (between the two halves).  
  Header: **"Cosmetic only."** _(56pt, candle-gold, all-caps)_  
  Sub: **"Every gameplay-affecting card is free. Forever."** _(28pt, ash-white)_
- **Background / palette.** Mourners' purple wash, candle-gold accents.
- **A11y notes.** "Cosmetic only" header ≥ 7:1 contrast against backdrop. Treatment-thumb labels ≥ 16pt. Wordmark legible at thumbnail.
- **Acceptance check.** A reader concerned about pay-to-win should see this screenshot and lower their guard. If they don't, the message isn't reading.

---

## 4. Landscape tablet brief (optional, Y1 stretch)

If we ship iPad-optimised at v1.0 (Apple HIG highly rewards it), author landscape variants of slots 1, 2, 4, 5 (the four most gameplay-heavy) at **2048 × 2732 px** master, re-export to Play 10" tablet 1920 × 1200 px. Same overlay text, repositioned to top-centre with the gameplay framing reorganised for 4:3.

Defer to post-soft-launch unless capacity surfaces.

---

## 5. Capture-day production checklist

- [ ] Engine build tagged `v0.9-screenshot-capture` (no debug overlays, no FPS counter, no test cards)
- [ ] Run seed pre-loaded — deterministic state so each capture can be re-shot identical
- [ ] HUD-skin set to "default ash" (not faction-themed, which would bias the read)
- [ ] System UI hidden (status bar overlay, notch-cutout) — pure 1290×2796 frame
- [ ] All currency counters set to mid-game values (not 0, not maxed)
- [ ] Capture each slot at iOS master + 6.5" + 5.5" downsamples + Play 1080×2400 (4 outputs per slot × 8 slots = 32 files)
- [ ] Burn-in metadata: file name = `slot-NN_{intent}_{platform}_{size}.png`
- [ ] No re-touching beyond text overlay + colour-grade (no painted-in particles, no compositied gameplay)
- [ ] Spot-check pass against acceptance check (above) per slot
- [ ] Localisation-ready PSDs with text on a named layer for each slot — handed to translator pack

---

## 6. Version history

- v0 — 2026-05-22 — Controller round 3. First filing-ready screenshots brief. Pre-capture.

— Controller, 2026-05-22
