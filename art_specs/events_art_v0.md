# Event-card art prompts v0 (Phase 2.12.M8)

_Authored 2026-05-18 by Controller. 10 event-card prompts tied to Gallowfell lore beats. Events are map-wide / lane-wide moments (not unit cards) — distinct composition tier from §3.4 portrait/landscape. Follows the same 5-layer prompt assembly as `_template.md`. Source design intent: chapter beats from `faction_bible.md` + `lore_gallowfell.md`; mechanical role notes from `archetypes_v0.md`._

## Generation conventions (apply to all 10)

- **Card type:** EVENT (new role; add to `card_type` enum if not present in `card.gd`).
- **Composition tier:** `event_landscape` — landscape framing, single dominant moment, no central figure required. Camera positioned mid-distance, scene-led not portrait-led. Distinct from `portrait` (§3.4 units) and `environment` (§3.4 spells).
- **Native render size:** 1216×832 SDXL (landscape) → final 1166×832 PNG-24 RGBA. Same hardware budget as hero cards.
- **LoRA stack:** baseline §2.2 (ClassipeintXL @ 0.8 + Dark Fantasy @ 0.8 + Elden Ring Style @ 0.5) plus the chapter-faction LoRA per event below (if event sits in a specific biome). No more than 5 LoRAs stacked.
- **Seed convention:** `300000 + (event_id × 10)`. Range 300010–300100 — clear of all existing ranges.
- **Workflow file:** `pipeline_setup/workflow_gallowfell_card.json` with EmptyLatentImage swapped to 1216×832 and faction LoRA weight set per event.
- **Output path:** `art/events/E<NN>_<lower_snake_name>.png` (1166×832 crop) + `art_iterations/_events/E<NN>_1216x832.png` (full archive).
- **Validation rule:** events are *moments*, not characters. No single dominant figure unless that figure IS the moment (e.g. the gallows-tree). Atmosphere, lighting, composition do the storytelling.

---

## E01 — Hanging Hour Begins (chapter 1 opener)

**event_id:** 1
**seed:** 300010
**biome:** Gallowfell main square — central gallows-tree
**lore beat:** The curse triggers at midnight. The dead in the gallows-tree start to twitch. The town clocks all stop at the same moment.

**Subject description (≤30 words):**
Town square at the stroke of midnight; great gallows-tree silhouetted against bruised-purple sky; multiple hanged figures hang motionless, but the ropes are taut — they are about to move.

**Resolved prompt (5 layers, §3.1 + §3.2 + §3.3 + event_landscape + §3.5):**
```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
midnight cursed town square, dead gallows-tree iconography, multiple silhouetted hanged figures,
ropes pulled taut by unseen current, no living figures present,
bruised-purple twilight sky, candle-yellow lantern accent in foreground,
clock tower visible with hands stopped at twelve,
landscape composition, mid-distance camera, no single subject dominating frame,
atmospheric volumetric haze, deep shadow, single focal moment readable at thumbnail,
no text overlay, no logo, no watermark,
sharp focus, masterpiece quality, 8k cinematic
```
**LoRA additions:** `Ash-Mourner court palette @ 0.4` (sky tone alignment).
**Validation:** (1) tree silhouette is recognisable as gallows-tree (multiple ropes); (2) bruised-purple is the sky, not gore; (3) no living figures; (4) lantern is candle-yellow, not orange/red; (5) no text in image.

---

## E02 — The Bells Toll Backwards (Cathedral Ruins event)

**event_id:** 2
**seed:** 300020
**biome:** Cathedral Ruins
**lore beat:** A Penitent ritual — bells ring in reverse order; the air vibrates with stuck prayer; the bell-tower starts to bleed brass.

**Subject description (≤30 words):**
Cracked cathedral bell-tower at dusk; massive bronze bells visible in the open belfry, ropes hanging down through the floor; brass-coloured tears running down the stone walls; candle wax everywhere.

**Resolved prompt:**
```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
ruined cathedral belfry at dusk, three massive bronze bells visible in stone arches,
heavy bell-ropes hanging straight down through cracked floor,
brass-tinted tears streaming down weathered cathedral stone walls,
spilled candle wax pooled across stone floor, no human figures,
oxblood and candle-yellow accent palette,
landscape framing, mid-distance camera looking up into belfry,
volumetric haze of dust and incense smoke,
sharp focus on the centre bell, masterpiece quality
```
**LoRA additions:** `Iron Penitents grit @ 0.6` (cathedral texture).
**Validation:** (1) three bells visible, not one or two; (2) brass "tears" read as molten brass, not paint; (3) wax spill must be candle-wax, not magical glow; (4) no figures.

---

## E03 — The Court Convenes (Catacomb event)

**event_id:** 3
**seed:** 300030
**biome:** Catacombs
**lore beat:** The Ash-Mourner court holds session at midnight in the buried throne-hall; signets glow; the dead are summoned to give evidence.

**Subject description (≤30 words):**
Underground throne-hall lit only by signet-ring glow; rows of skeletal court-attendants frozen in formal posture along stone walls; a single empty throne at the far end, occupied by a black writ.

**Resolved prompt:**
```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
underground stone throne-hall, court of skeletal figures in tattered black brocade,
gilt-bone masks, signet rings glowing faintly tarnished-gold,
single empty obsidian throne at vanishing point, black-sealed writ on the throne,
formal symmetrical procession, court-of-the-dead aesthetic,
bruise-purple shadow with tarnished-gold accent only on signet rings,
landscape composition, long perspective camera looking down central aisle,
no living figures, volumetric incense haze, sharp focus on writ,
masterpiece quality
```
**LoRA additions:** `Ash-Mourner court palette @ 0.7`.
**Validation:** (1) signet glow is the ONLY light source; (2) writ is on the throne, not held by anyone; (3) symmetrical composition with vanishing point at throne; (4) no royal figure present.

---

## E04 — Hoofprint in the Mud (Bog of Bargains event)

**event_id:** 4
**seed:** 300040
**biome:** Bog of Bargains
**lore beat:** The patron demon has just walked through; a fresh cloven hoofprint fills with bog-water, and a demon-coin floats face-up beside it.

**Subject description (≤30 words):**
Marshland mud at twilight; one large cloven hoofprint freshly impressed in the wet mud, filling with brown water; a single gold demon-coin floats face-up in the print; no creature visible.

**Resolved prompt:**
```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
fenland marsh at twilight, single fresh cloven hoofprint impressed in wet bog mud,
print partially filled with stagnant water reflecting purple sky,
one gold demon-coin floats face-up in the water of the print,
no creature visible, no figure, just the trace,
reeds and bog grass in foreground, faint mist over water in distance,
bog-green and leech-purple palette with single demon-coin gold accent,
landscape close-mid composition, low camera angle close to mud,
shallow depth of field, coin in sharp focus, hoofprint atmospheric,
masterpiece quality
```
**LoRA additions:** `Coven bog texture @ 0.6`.
**Validation:** (1) ONE coin, not several; (2) hoofprint is cloven (split), not a horse track; (3) no demon or shadow visible — only the trace.

---

## E05 — Forge-Glow Ignites (Foundry event)

**event_id:** 5
**seed:** 300050
**biome:** The Foundry
**lore beat:** A long-dead forge re-ignites itself at the curse's command; the empty workshop is suddenly active, hammers swing, with no one striking them.

**Subject description (≤30 words):**
Industrial forge interior at night; one massive bellows-fed forge fire flares into orange life; anvils show fresh hammer-strikes but no smith is present; sparks hang mid-air.

**Resolved prompt:**
```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
empty industrial forge interior at night, one large bellows-fed forge flares orange,
massive anvils in foreground showing fresh red-hot hammer marks,
hammer suspended in mid-strike with no hand on it,
sparks hanging frozen mid-air, no human figures present,
soot-blackened brick walls, iron rails crossing floor,
soot-black and ember-orange palette,
landscape composition, mid-distance camera looking into forge mouth,
volumetric forge-smoke, sharp focus on suspended hammer,
masterpiece quality
```
**LoRA additions:** `Last Legion industrial @ 0.6`.
**Validation:** (1) hammer hangs in air, no hand; (2) anvil has fresh strike marks; (3) ember-orange is the only warm accent.

---

## E06 — The Cinder-Mother Wakes (Cinderwood event)

**event_id:** 6
**seed:** 300060
**biome:** Cinderwood
**lore beat:** A great half-burnt mother-tree at the centre of the felled-gallows wood opens one charcoal eye in its trunk; the wood remembers.

**Subject description (≤30 words):**
Half-burnt ancient tree in scorched forest clearing; one knot in the trunk is now an open eye made of glowing charcoal; surrounding stumps still smouldering faintly; no animal visible.

**Resolved prompt:**
```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
massive ancient half-burnt mother-tree in scorched forest clearing,
single dark knot in the trunk open as a glowing charcoal eye,
ember-orange pupil watching, no other animation,
surrounding tree-stumps faintly smouldering, white ash drift on forest floor,
no animals, no human figures, just the woken tree,
charcoal-black and ember-orange accent palette on bone-white ash,
landscape composition, mid-distance camera centred on the eye,
volumetric smoke between trees, sharp focus on the open eye,
masterpiece quality
```
**LoRA additions:** `Skinward feral palette @ 0.5`.
**Validation:** (1) eye is the knot, not added on top of bark; (2) ember-orange ONLY in the eye; (3) ash is bone-white not grey.

---

## E07 — The Tree Remembers (Gallows-Tree, neutral)

**event_id:** 7
**seed:** 300070
**biome:** Gallows-Tree (any chapter)
**lore beat:** The gallows-tree carves a name into its own bark; the trapped souls speak through it. The wound on the bark bleeds sap that is not sap.

**Subject description (≤30 words):**
Close on the gnarled black bark of the gallows-tree; a name in old script is freshly carved into the bark; dark resin bleeds from the carving; one rope-fragment visible.

**Resolved prompt:**
```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
extreme close-up of gnarled blackened bark of the gallows-tree,
fresh carved name in old script visible in centre of frame,
dark amber sap bleeding from the cuts of each letter,
single frayed rope-fragment hangs from upper edge of frame, partially visible,
no figure, just bark and carving,
oxblood-amber accent on near-black bark,
landscape composition, macro camera, shallow depth of field, carving in sharp focus,
volumetric mist around bark texture, masterpiece quality
```
**LoRA additions:** none (neutral biome).
**Validation:** (1) script is unreadable but feels old-language; (2) sap is amber, not red; (3) rope-fragment is partial — only hint.

---

## E08 — Reanimation Tide (curse-wide event)

**event_id:** 8
**seed:** 300080
**biome:** any — global event
**lore beat:** The curse-wide reanimation pulse passes through the town; hands push up from graves across multiple visible biomes in the distance.

**Subject description (≤30 words):**
Wide aerial view of Gallowfell at twilight; multiple biomes visible — cathedral spires, catacomb cracks, bog, foundry smoke, burnt wood; pale hands emerge from earth at scale, just barely visible.

**Resolved prompt:**
```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
wide high-angle establishing shot of cursed gallows-town at twilight,
distant cathedral spires, exposed catacomb crack, marsh, foundry chimneys, burnt wood,
across all districts: pale withered hands push up from earth, distant, scale subtle,
bruised-purple sky with single greenish moonlight accent,
no large central figure, atmosphere does the storytelling,
landscape composition, wide cinematic camera, deep haze,
sharp focus on mid-distance graves, atmospheric falloff at horizon,
masterpiece quality, 8k cinematic
```
**LoRA additions:** none (multi-biome — would mix LoRA palettes badly).
**Validation:** (1) all five biomes faintly identifiable; (2) hands are pale, not bloody; (3) moonlight is faint green not white; (4) no large central figure.

---

## E09 — Penance for the Failed (mechanic event)

**event_id:** 9
**seed:** 300090
**biome:** any cathedral-adjacent
**lore beat:** A player-side defeat triggers the Penance mechanic — a flagellant priest whips a kneeling silhouette in the foreground; sin transferred, advantage gained next turn.

**Subject description (≤30 words):**
Kneeling silhouetted figure receives ritual lash from off-frame; bare back shows scar-pattern; wax candles on stone floor; no full body of either figure shown; gesture only.

**Resolved prompt:**
```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
ritual penance scene, kneeling silhouetted figure from behind, bare scarred back showing scar-pattern,
ritual lash mid-strike entering frame from upper right, no figure of the striker shown,
spilled candle wax on cathedral stone floor in foreground,
rust-red and candle-yellow palette, deep shadow background,
landscape composition, mid-shot from low rear angle,
volumetric incense haze, sharp focus on the scar-pattern,
absolutely no explicit blood spray, no severed flesh, no gore,
masterpiece quality
```
**LoRA additions:** `Iron Penitents grit @ 0.5`.
**Validation:** (1) hard PEGI gate — no visible blood spray on screen; (2) scar-pattern reads as ritual not injury; (3) lash itself is in motion but not landed.

---

## E10 — The Sky Splits Black (boss-trigger event)

**event_id:** 10
**seed:** 300100
**biome:** any — over Gallowfell
**lore beat:** The Hanging Hour boss-phase begins. The sky above the gallows-tree fractures and a vertical column of darkness descends — the curse acknowledges the player.

**Subject description (≤30 words):**
Sky directly above the gallows-tree cracks open in a vertical jagged seam; deep black column descends to within feet of the gallows-tree's highest rope; lightning halts mid-strike around it.

**Resolved prompt:**
```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga,
night sky above the great gallows-tree cracks open in vertical jagged seam,
deep-black column of pure darkness descends from the rift,
column halts just above the highest rope of the gallows-tree,
forked lightning frozen mid-strike around the column, no rain,
bruised-purple stormcloud frame, single ember-orange accent at base of column,
landscape composition, low wide-angle camera looking up the column,
volumetric storm haze, sharp focus on the rift seam,
masterpiece quality, 8k cinematic
```
**LoRA additions:** none (event is sky-led; biome LoRAs would conflict).
**Validation:** (1) seam is JAGGED not curved; (2) lightning is FROZEN, single flash; (3) column reaches almost-but-not-quite the gallows-tree; (4) no figures present.

---

## Implementation notes (for Phase 2.12.M8 close-out)

- Each event's resolved prompt is final v0 — paste directly into ComfyUI's positive prompt node.
- Negative prompt (universal, all 10): use §3.6 baseline from `pipeline_spec.md` unchanged. Each event's validation list is in addition to standard PEGI/quality checks.
- Seed range 300010–300100 is reserved; do not collide.
- Run order recommendation: E01 first (chapter-1 opener; highest visibility), then E08 (multi-biome — riskiest, learn early), then the rest in any order.
- B3.0a smoke test must clear before any of these run, per `IMAGE-GEN-SHOTLIST.md` TL;DR.
- **Phase 2.12.M8 acceptance criterion (this file):** 10 events authored with subject + resolved prompt + LoRA stack + validation checklist + seed. ✓

— Controller, 2026-05-18
