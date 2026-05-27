# Audio Production Brief v1 — The Curse of Gallowfell

_Authored 2026-05-22 by Controller (round 2). Composer-quotable production brief. Builds on `audio_direction_v0.md` (2026-05-21 v0 spec) which is the design intent doc. This is the version you hand to a freelancer, a small studio, or use as a Suno/Udio prompt seed. Each leitmotif and SFX entry is specified to the point where a composer can give you a quote without follow-up._

**Status:** v1 production-ready brief. Pending: composer outreach (Paul-action), generation runs (Suno/Udio paid tier), iteration. Targeted total cost: £400-1,200 hand-composed OR £15-30 Suno-only.

---

## 1. Scope of work

| Asset class | Asset count | Total runtime | Format | Delivery |
|---|---|---|---|---|
| Faction leitmotifs (×5 factions × 3 variants) | 15 | ~9.5 min | stereo OGG 192 kbps + WAV master | per-asset stems if hand-composed |
| Hanging Hour sting | 1 | 2 sec | stereo OGG 192 kbps | WAV master |
| Hanging Hour ambient loop | 1 | 8 sec loop | mono OGG 96 kbps | WAV master |
| Boss themes (×8 chapters × 1 each) | 8 | ~8 min | stereo OGG 192 kbps | WAV master |
| SFX (40 events) | 40 | ~80 sec total | mono OGG 96 kbps, mostly | WAV masters |
| Ambient beds (×6 biomes × 1 each) | 6 | ~6 min loop | stereo OGG 128 kbps | WAV master |
| UI music stings (×4 surfaces) | 4 | ~8 sec total | stereo OGG 192 kbps | WAV master |
| **TOTAL** | **75 assets** | **~25 min** | — | — |

**Mobile budget:** total file size of music + SFX must be ≤25 MB after compression. SFX library ≤5 MB. Currently sized at ~18 MB by spec. Budget OK.

---

## 2. Tone direction (read before quoting)

Per `GDD_v1.md` §2 and `lore_gallowfell.md`:

- **Setting:** A cursed gallows-town. The dead refuse to leave. Reality frays at the edges. Centuries of executions accumulated into a weight that broke the empire's geography.
- **Player register:** Grim with gallows humour. Never camp. Never grand. The closest emotional reference is **"a Catholic procession heard from three streets away on a winter evening — half-remembered, slightly wrong, and you can't tell if it's coming closer or going away."**
- **What we're NOT going for:** Disney epic, JRPG bombast, dubstep drops, modern blockbuster horror jump-scares, Skyrim sky-wide orchestra. The music must feel **handled** — like every instrument was carried, by hand, into the room.
- **Three pillar references for the entire OST:**
  1. **Mick Gordon's _Killer Instinct: Season 3_ soundtrack** — for the industrial edge under the orchestral layer
  2. **Jeremy Soule's _Morrowind Theme_** — for the restrained orchestral grandeur
  3. **Hozier's _Cherry Wine_ + _Wasteland Baby!_** — for the folk-doom + Gaelic-funeral tone

**Single-line brief if you can only read one line:** "Imagine if Doom: Eternal's composer scored a 12th-century funeral mass in a country church."

---

## 3. Faction leitmotifs (×5 factions × 3 variants each)

### 3.1 General rules (apply to all 5 factions)

- **Per faction:** 3 variants — `_full` (30 sec loop, combat scene background bed), `_stinger` (4 bars / ~6 sec, used on Warlord-select reveal + combat-start + run-victory), `_softened` (30 sec, hub / map screen ambient version of full).
- **Loopable:** loop point at start of bar 1, return-to-loop at end of bar 16 (for 30-sec loops at the spec BPMs).
- **Tonality:** stay in named key. Modulation OK within faction-internal phrasing. Avoid bridging into other faction keys (cross-faction harmonic clashes would break the player's recognition).
- **Mix:** -8 dB target peak (room for SFX), -14 LUFS integrated.
- **Instrumentation library:** real-recorded preferred, EastWest Hollywood Strings / Spitfire BBC Symphony / Heavyocity Vocalise acceptable for orchestral elements. Industrial percussion = sampler / pads OK.
- **Length tolerance:** ±2 sec on loops, exact on stingers.

### 3.2 Iron Penitents — "Penitents' March"

| Attribute | Spec |
|---|---|
| Key | D minor |
| Tempo | 90 BPM (4/4) |
| Length | full 30 sec / stinger 4 bars (~10 sec) / softened 30 sec |
| Mode | natural minor |
| Instrumentation | low strings (cellos + double bass, divisi), military snare (rim-shots, no resonant snare), CHAIN PERCUSSION (recorded chain dragged on stone or close substitute — sampler OK), distant church bell (one tone, doesn't have to be in key), low men's choir hum (no lyrics, mid-low register, dorian-tinted) |
| Theme description | Marching with intentional drag — like the snare lags 8-12 ms behind the beat consistently. Chain percussion drops on offbeats (and-2, and-4) audibly. Phrase ends with a long-held minor chord (Dm with added 7 if you want melancholy) lasting 2 bars. Then snare comes back. NO TIMPANI. NO BRASS FANFARE. |
| Mix notes | Snare panned slightly right (+10°). Strings centred. Chain in left channel (+15°). Choir at -16 dB under everything. |
| Style ref 1 | **Hildur Guðnadóttir's _Joker (2019)_ — track "Defeated Clown"** — for the dragged-snare feel and the low strings carrying everything. |
| Style ref 2 | **Olafur Arnalds' _Island Songs_ — track "Particles"** — for the restraint, the held minor chord, the sense the music is *not catching up.* |
| Stinger spec | 4 bars. Bar 1 = solo cello entrance on D. Bar 2 = snare + chain joins. Bar 3 = choir hums in. Bar 4 = held Dm chord into silence. 10 sec total at 90 BPM. |
| Softened spec | Same instrumentation, snare and chains REMOVED. Strings + choir + distant bell only. Pad-like. -3 dB quieter than full. |

### 3.3 Ash-Mourners — "The Court That Won't Die"

| Attribute | Spec |
|---|---|
| Key | F# minor |
| Tempo | 60 BPM (6/8) |
| Length | full 30 sec / stinger 4 bars (~16 sec at 60 BPM 6/8) / softened 30 sec |
| Mode | natural minor with occasional Phrygian moments (♭2 = G natural in F# minor) on the 4th and 8th bars |
| Instrumentation | full female choir (low, dark — mezzo + alto, no soprano), hammered dulcimer (NOT regular harp — dulcimer specifically, for the strike+decay shape), raven caws (sampled — Sonniss bundle has these), single funeral bell (toll on bar 1 each phrase), ground-toned organ pedal (one note, F#, sustained underneath) |
| Theme description | Funereal, courtly. 6/8 lament. Choir hums tonic (F#) the entire 30 sec — a drone. Dulcimer plays an inverted-arpeggio motif: descending F#-C#-A-F#, then ascending C#-F#-A-F#, suggesting raven flight (down to up). Raven caws scatter through, NOT on beat. Funeral bell tolls once per 8 bars. |
| Mix notes | Choir centre. Dulcimer slightly left. Organ pedal under everything (-20 dB). Ravens random pan, very wet reverb. -10 LUFS — quieter than the others. |
| Style ref 1 | **Jocelyn Pook's _Eyes Wide Shut_ soundtrack — track "Masked Ball"** — for the Latin-Catholic-procession choral texture and the slow burn. |
| Style ref 2 | **Anna von Hausswolff's _All Thoughts Fly_ (2020 album)** — for the church-organ drone discipline and the willingness to leave space. |
| Stinger spec | 4 bars at 60 BPM 6/8 = 16 sec. Bar 1 = choir enters on F# drone. Bar 2 = dulcimer descending phrase. Bar 3 = single raven caw + funeral bell toll. Bar 4 = sustain into silence. |
| Softened spec | Choir + organ pedal only. Dulcimer removed (too foreground). Ravens removed. -5 dB. |

### 3.4 Coven of the Black Mire — "The Bog Remembers"

| Attribute | Spec |
|---|---|
| Key | E minor (Aeolian) with bog-flat-7 (D natural emphasised) |
| Tempo | 75 BPM (7/8 — odd meter on purpose) |
| Length | full 30 sec / stinger 4 bars (~13 sec at 75 BPM 7/8) / softened 30 sec |
| Mode | Aeolian with deliberate use of the flattened 7th |
| Instrumentation | reed pipes (NOT bagpipes — single reed, mournful tone, e.g. tin whistle / pennywhistle in low register), frog/cicada percussion (Sonniss CC0 ambient bundles), crone vocals (single female voice, low register, NOT trained — chanting nonsense syllables in folkloric tone), hand-drum (low frame drum, played palm-flat), water drips (Sonniss ambient) |
| Theme description | Folkloric, ritual. 7/8 odd-meter sway (groups of 4+3 within the bar). Reed pipes carry the melody — suggest a wisp of smoke moving across water. Crone vocals weave in around bar 4 with non-language syllables (suggest old country curse, not modern words). Frog/cicada sounds layered as texture, NOT rhythmic. |
| Mix notes | Reed pipes centred (carrying melody). Crone vocals panned left (mid-distance). Hand drum mostly centred, slight L. Frog/cicada wide-panned, very low (-22 dB). Water drips occasional, very low (-25 dB). |
| Style ref 1 | **Heilung's _Krigsgaldr_** — for the folk-pagan ritual feeling, the deep drone, the way the voice is *part* of the texture rather than *over* it. |
| Style ref 2 | **Lisa Gerrard's _Gladiator_ vocal lines (e.g. "Now We Are Free")** — for the non-language nonsense-syllable crone-vocal approach, used at low-medium volume. |
| Stinger spec | 4 bars 7/8 at 75 BPM = ~13 sec. Bar 1 = hand drum + water drip. Bar 2 = reed pipe melody enters. Bar 3 = crone vocal joins for one phrase. Bar 4 = held single reed note dying out. |
| Softened spec | Reed pipe + crone vocal + frog/cicada texture. Hand drum removed. -3 dB. |

### 3.5 The Last Legion — "Forge Discipline"

| Attribute | Spec |
|---|---|
| Key | C minor |
| Tempo | 110 BPM (4/4) |
| Length | full 30 sec / stinger 4 bars (~8.7 sec) / softened 30 sec |
| Mode | natural minor with Aeolian cadences |
| Instrumentation | brass section (3 trumpets + 2 trombones + 1 tuba; mid-low register — NO fanfare brass blare), foundry-anvil percussion (literal anvils, struck — sampled OK), iron-rail rhythm (low industrial sample — rail-yard recordings ideal, factory sample bundle OK), low military drum (no snare flam — clean hits), distant factory whistle (occasional, very wet reverb) |
| Theme description | Marching, mechanical. Marcia funebre meets industrial. Brass plays a falling fifth motif (C → G → C → A♭) on bars 1, 3, 5, 7. Anvils on downbeats (every beat 1 + 3). Iron-rail rhythm underneath as bed. Brass should sound like it's being played by tired men, NOT triumphant. |
| Mix notes | Brass centred. Anvils centred, very compressed (transient-strong). Iron-rail rhythm wide. Military drum left-of-centre. Factory whistle very wet reverb, distant. |
| Style ref 1 | **Mick Gordon's _Doom: The Dark Ages_ track "Crucible Forged"** — for the industrial-percussion-meets-orchestral discipline. |
| Style ref 2 | **Hans Zimmer's _Dunkirk_ — track "The Mole"** — for the patient, mechanical marching pulse and the brass that doesn't ever quite swell into triumph. |
| Stinger spec | 4 bars 4/4 at 110 BPM = 8.7 sec. Bar 1 = anvil hit. Bar 2 = brass enters with falling-fifth motif. Bar 3 = iron-rail rhythm joins. Bar 4 = anvil + military drum simultaneous, hold to silence. |
| Softened spec | Brass + iron-rail rhythm only. Anvils + military drum removed. -4 dB. |

### 3.6 Skinward Pact — "Cinderwood Howl"

| Attribute | Spec |
|---|---|
| Key | A minor (Aeolian, modal — never flatten the 7th into harmonic minor) |
| Tempo | 80 BPM (5/4 — pentametric, off-balance) |
| Length | full 30 sec / stinger 4 bars (~12 sec at 80 BPM 5/4) / softened 30 sec |
| Mode | Aeolian. Lock in modal. NO leading-tone resolutions. |
| Instrumentation | hand drums (multiple — frame, djembe-style, bodhrán), bone-flute (NOT regular flute — bone-flute samples or recorder-imitation of bone-flute timbre; pentatonic phrases), wolf-howl ambience (Sonniss bundle, treated to fit in mix — NOT raw recordings), low contrabass bowed long notes, crow caws (occasional, like raven but lower-pitched) |
| Theme description | Pagan, primal. Hand drums in 5/4 — groups of 3+2 within the bar. Bone-flute plays pentatonic motif: A-C-E-G-E-C-A descending phrase, repeated across phrases at different starts (A, E, then C). Wolf-howl punctuates phrase ends (every 8 bars), single howl held for 4 sec, faded in. Crow caws scatter. Contrabass plays slow bowed long-notes on A (root) underneath. |
| Mix notes | Hand drums centred. Bone-flute slightly right. Wolf-howl WIDE — very stereo, slightly left then slightly right (suggesting forest depth). Contrabass low and centre. Crow random pan. |
| Style ref 1 | **Wardruna's _Heimta thurs_** — for the Norse-folk-pagan ritual hand-drum discipline and the way the natural-element sounds (wind, howls) feel integrated rather than ornamental. |
| Style ref 2 | **Bear McCreary's _The Walking Dead_ early-season tracks — track "All This Time"** — for the restraint, the patient pentatonic phrases, and how the percussion always feels like one player rather than an orchestra. |
| Stinger spec | 4 bars 5/4 at 80 BPM = 12 sec. Bar 1 = hand drum enters. Bar 2 = bone-flute first phrase. Bar 3 = wolf-howl fades in. Bar 4 = contrabass long-note + bone-flute resolution to A, hold. |
| Softened spec | Bone-flute + contrabass + crow caws only. Hand drums + wolf-howl removed. -3 dB. |

---

## 4. Boss themes (×8)

Each chapter boss gets a unique theme. Lengths: 90 sec loop, transitions to faction-leitmotif on victory (cross-fade 4 sec).

| Boss | Theme name | Key / Tempo | Instrumentation overlay (on top of faction leitmotif) | Style ref |
|---|---|---|---|---|
| Ch1 Black-Bell Choir | "Bells Hold the Hours" | F# minor 60 BPM (Mourners ext.) | Add 3-bell tolling pattern (high/mid/low) + male choir on top of Mourners leitmotif | Hildur Guðnadóttir's _Chernobyl_ track "Vichnaya Pamyat" |
| Ch2 Iron Communion | "Anvil Hour" | C minor 110 BPM (Legion ext.) | Add hammer-on-anvil rhythm overlay every 8 bars + brass swell | Mick Gordon's _Doom Eternal_ "The Only Thing They Fear is You" — MORE RESTRAINED |
| Ch3 Saint That Hangs | "Speak the Name" | F# minor 60 BPM (Mourners ext. corrupted) | Replace dulcimer with detuned dulcimer (-15 cents) + add backwards-played choir layer | Penderecki's _Threnody for the Victims of Hiroshima_ — sparingly applied |
| Ch4 Bog-Mother's Ledger | "Ledger and Coin" | E minor 75 BPM (Coven ext.) | Add coin-drop rhythm (random sparse) + low cello drone on E flat (semitone clash) | Anna Meredith _Nautilus_ — the rhythmic anxiety |
| Ch5 Cinderwood Warden | "Three Times the Pelt" | A minor 80 BPM (Skinward ext.) | Add inverse-pitched wolf-howl (slowed 50%) + bone-flute in fifth | Wardruna _Tjelvar_ slowed +6 BPM |
| Ch6 Penitents' Hammer | "Hammer and Hour" | D minor 90 BPM (Penitents ext.) | Add hammer-on-stone rhythm (sampled) on downbeat of bars 1, 5, 9, 13 (4-bar phrase markers) | Hildur Guðnadóttir _Joker_ "Subway" |
| Ch7 Twelve-Eyed Court | "Twelve Witnesses" | F# minor 60 BPM (Mourners ext. + 12-tone row inserted) | 12-tone-row motif played on dulcimer underneath choir (Schoenberg-tier serialism, sparingly) — every 12 bars | Schoenberg _Pierrot Lunaire_ excerpt approach |
| Ch8 The Curse Itself | "The Tree Stops Listening" | A minor 80 BPM transitioning to chaotic 7/8 in phase 3 | Phase 1 = Mourners leitmotif. Phase 2 = Saint's theme. Phase 3 = all 5 faction leitmotifs simultaneously, slightly detuned — chaos | Mica Levi _Under the Skin_ track "Lonely Void" — the harmonic disintegration |

**Phased boss themes (Ch5 + Ch8) need crossfade points marked** so engine can switch on phase transition.

---

## 5. SFX list — 40 events with concrete durations

Restated from `audio_direction_v0.md` §3 with concrete durations + tone descriptors. Source preference noted.

### 5.1 Card / hand SFX (8 events)

| ID | Event | Duration | Tone descriptor | Source |
|---|---|---|---|---|
| sfx-card-draw | Card from deck to hand | 0.25 sec | Crisp paper-on-cloth slip | Sonniss CC0 |
| sfx-card-hover | Card hover/select | 0.10 sec | Soft tactile tap | Sonniss CC0 |
| sfx-card-drop-valid | Drop on valid lane | 0.35 sec | Hollow wood thunk + faint bell-ting | Sonniss CC0 |
| sfx-card-drop-invalid | Drop on invalid spot | 0.30 sec | Dull stone thud + low buzz | Freesound CC0 |
| sfx-card-cast-spell | Spell resolves | 0.80 sec | Whoosh + faint choir voice | Suno custom or manual whoosh |
| sfx-card-summon-unit | Unit spawns | 0.60 sec | Heavy thud + brass swell-and-fall | Suno custom |
| sfx-card-place-trap | Trap placed | 0.40 sec | Metallic click + chain shudder | Freesound CC0 |
| sfx-deck-reshuffle | Empty deck → reshuffle | 1.20 sec | Riffle-shuffle + soft bell-sweep | Sonniss CC0 |

### 5.2 Combat SFX (12 events)

| ID | Event | Duration | Tone descriptor | Source |
|---|---|---|---|---|
| sfx-unit-attack-melee | MELEE hit | 0.45 sec | Iron-on-bone strike | Sonniss CC0 (combat bundles) |
| sfx-unit-attack-short | SHORT range | 0.40 sec | Bow-twang + arrow-impact-stub | Sonniss CC0 |
| sfx-unit-attack-long | LONG range | 0.55 sec | Whoosh-trail + arrow-impact-stub | Sonniss CC0 |
| sfx-unit-take-damage | Unit hurt | 0.30 sec | Short grunt + impact-thud | Freesound CC0 |
| sfx-unit-death-friendly | Friendly dies | 0.90 sec | Soft fall + sad string fall (down-glissando) | Suno stinger custom |
| sfx-unit-death-enemy | Enemy dies | 0.55 sec | Crunch + final groan | Sonniss CC0 |
| sfx-bleed-tick | BLEED applies/ticks | 0.20 sec | Single drip-drop on stone | Freesound CC0 |
| sfx-poison-tick | POISON applies/ticks | 0.20 sec | Bubble + low hiss | Freesound CC0 |
| sfx-shield-consume | SHIELD charge used | 0.30 sec | Metallic clank, single | Sonniss CC0 |
| sfx-shield-break | SHIELD all consumed | 0.60 sec | Metallic shatter | Sonniss CC0 |
| sfx-persist-rise | Persist end-of-turn | 0.85 sec | Spectral whoosh + faint choir whisper | Suno custom |
| sfx-cleave | CLEAVE attack | 0.60 sec | Three whooshes in close succession | Sonniss CC0 |

### 5.3 Map / event SFX (6 events)

| ID | Event | Duration | Tone descriptor | Source |
|---|---|---|---|---|
| sfx-map-node-enter | Enter new node | 0.50 sec | Confirm-chime + paper unfurling | Sonniss CC0 |
| sfx-map-node-hover | Hover map node | 0.10 sec | Soft tap | Sonniss CC0 |
| sfx-event-reveal | Event card reveals | 1.10 sec | Mystery sting — bell+string sustain | Suno custom |
| sfx-shrine-pray | Pray on shrine | 0.95 sec | Choir whisper + soft chime | Suno custom |
| sfx-shrine-defile | Defile shrine | 1.05 sec | Wood-snap + warning sting | Suno custom |
| sfx-rest-heal | REST heal | 0.85 sec | Soft heal chime + breath sigh | Freesound CC0 |

### 5.4 Reward / progression SFX (8 events)

| ID | Event | Duration | Tone descriptor | Source |
|---|---|---|---|---|
| sfx-reward-card-reveal | Reward reveals | 1.20 sec | Fanfare 1 — three-note brass + bell | Suno custom |
| sfx-reward-card-pick | Pick reward | 0.55 sec | Confirm + brass click | Sonniss CC0 |
| sfx-gem-gain | Gain gems | 0.70 sec | Crystal chime ascending | Freesound CC0 |
| sfx-bone-gain | Gain Bones | 0.55 sec | Hollow bone-rattle | Freesound CC0 |
| sfx-relic-acquire | New relic | 1.45 sec | Ancient hum + brass swell | Suno custom |
| sfx-warlord-tier-up | Warlord tier ladder | 1.50 sec | Fanfare 2 — full brass | Suno custom |
| sfx-mastery-unlock | Card mastery 3+ | 1.20 sec | Soft chime + held choir | Suno custom |
| sfx-treatment-unlock | Cosmetic unlock | 0.95 sec | Shimmer sting | Suno custom |

### 5.5 Hub / menu SFX (4 events)

| ID | Event | Duration | Tone descriptor | Source |
|---|---|---|---|---|
| sfx-menu-tap | Menu button | 0.15 sec | Tactile tap | Sonniss CC0 |
| sfx-menu-modal-open | Modal open | 0.40 sec | Soft rise + chime | Sonniss CC0 |
| sfx-menu-modal-close | Modal close | 0.35 sec | Soft fall | Sonniss CC0 |
| sfx-purchase-success | IAP completes | 1.65 sec | Bell + brass crescendo + coin-clink | Suno custom |

### 5.6 Boss + Hanging Hour SFX (2 events)

| ID | Event | Duration | Tone descriptor | Source |
|---|---|---|---|---|
| sfx-boss-spawn | Boss appears | 1.85 sec | Heavy drum + brass roar | Suno custom |
| sfx-boss-killed | Boss defeated | 2.50 sec | Long fall + held minor chord + bell-toll-fade | Suno custom |

**Total: 40 SFX. Aggregate duration: ~80 sec. Compressed file size estimate: ~3.5 MB.**

---

## 6. Hanging Hour ambient (signature moment)

### 6.1 HH sting (1 asset)

| Attribute | Spec |
|---|---|
| Length | exactly 2.0 sec |
| Composition | beat 1: heavy church bell single strike (low-mid pitch, ~80 Hz fundamental, harmonic to 800 Hz). Sustained 1.0 sec. Decays under simultaneous low string swell (cellos + double-bass on E, slow forte-piano dynamic). All-in, then fade. |
| Mood | Ominous, time-stop, the curse arrives, time itself is being marked |
| Format | stereo OGG 192 kbps |
| Triggers | `combat.hanging_hour_struck` signal |
| Style ref 1 | The bell from **Skyrim's main menu** — but slower and lower |
| Style ref 2 | The opening 2 seconds of **Mark Lanegan's _Whiskey for the Holy Ghost_** (album mood, not specific track) |

### 6.2 HH ambient bell-toll loop (1 asset)

| Attribute | Spec |
|---|---|
| Length | 8.0 sec loop, loop point seamless |
| Composition | distant bell ringing on beats 1 and 5 (of an 8-beat loop at 60 BPM), softer than the sting bell — same bell, captured at distance with high reverb. Underneath: quiet wind ambience (slow swirl, no high frequencies above 4 kHz). |
| Mood | Foreboding, "the bell remembers", quiet |
| Format | mono OGG 96 kbps |
| Triggers | Faded in over 2 sec during turns 3-4 (pre-HH) and 5-6 (post-HH). Faded out over 2 sec after. |
| Style ref | **Brian Eno's _Ambient 4: On Land_ — track "Lantern Marsh"** — for the genuinely distant feel, not just reverb-treated near-recording |

### 6.3 Generation prompts (if going Suno/Udio route)

**Sting:**
```
Style: orchestral grimdark, dramatic single-event sting
Length: 2 seconds
Composition: heavy church bell strike on beat 1, sustained 1 second, decays under low string swell on E minor
Mood: ominous, time-stop, the curse arrives
Output: instrumental, stereo, no fade-in, hard fade-out at 2.0 sec
```

**Ambient:**
```
Style: orchestral ambient, distant church bell at twilight
Length: 8 seconds loop
Composition: church bell tolls on beats 1 and 5 of an 8-beat 60 BPM loop, distant and reverberant; underneath quiet wind ambience, no high frequencies
Mood: foreboding, the bell remembers, quiet
Output: instrumental, mono, seamless loop
```

---

## 7. Ambient beds — 6 biomes

Background loops for each chapter biome (not just boss biomes — every biome). 30-sec loops, played underneath leitmotif at -22 dB. Cross-fade between biomes is 4 sec on biome transition.

| Biome | Faction | Tone | Source |
|---|---|---|---|
| Cathedral Ruins | Iron Penitents | Distant prayer-murmurs + bell-creaks + stone-drips | Freesound CC0 + church recordings |
| Ash Quarter / Catacombs | Ash-Mourners | Wind through stone halls + raven caws + occasional whispered Latin | Sonniss CC0 + crafted whisper layers |
| Bog of Bargains | Coven | Frog/cicada layer + water bubbling + distant crone humming | Sonniss CC0 + crafted vocal layer |
| The Foundry | Last Legion | Distant forge-hammering + ember crackle + iron-rail ringing | Freesound CC0 + factory-yard recordings |
| Cinderwood | Skinward Pact | Wind through burnt trees + distant wolf-howls + crow caws | Sonniss CC0 wildlife bundles |
| Gallows Hill / Tree at the End | Boss biome | Single-rope-creak loop + absolute silence + faint heartbeat | crafted from scratch — Suno custom or manual recording |

**Total ambient runtime:** ~3 min of original material × 6 = ~18 min budget if all 6 are unique. Most can be sourced from Sonniss CC0 bundles + processed (high reverb, low-pass filter, layered).

---

## 8. UI music stings (×4)

Short stings for UI moments. ~2 sec each.

| ID | Surface | Composition |
|---|---|---|
| sting-title-screen | App launch / title | 4-bar D minor cello + faint bell (variant of Penitents leitmotif stinger) |
| sting-warlord-select | Warlord-pick reveal | Whichever faction's leitmotif stinger (auto-route) |
| sting-run-victory | Boss defeated, run complete | Held minor → minor 6 resolution; choir + bell |
| sting-game-over | Run defeat | Falling string phrase, no resolution — leaves player in dissonance |

---

## 9. Mix discipline

| Bus | Target dB | LUFS-I | Notes |
|---|---|---|---|
| Master | 0 dB | -14 LUFS integrated | Standard mobile loudness |
| Music | -8 dB | -16 LUFS | Subordinate to gameplay |
| SFX | -3 dB | -10 LUFS | Player feedback priority |
| Voice | -5 dB | -12 LUFS | Reserved for v1.1 |
| HH sting | -2 dB transient | (within music bus) | Brief peak |

Cross-fades: 4 sec on biome transitions, 2 sec on leitmotif full ↔ softened, 1 sec on UI sting starts/stops.

Adaptive mixing (per `audio_direction_v0.md` §5.3): music bus duck to -15 dB during HH sting (1.5 sec), recover to -8 dB.

---

## 10. Budget + delivery options

### 10.1 Option A: Pure Suno/Udio gen (cheapest)

- Subscribe to Suno paid tier (£8/mo equivalent, commercial-rights included)
- 1 month of generation work covers all 75 assets if scoped tightly
- Iterations: generate 3-5 candidates per asset, pick best, Audacity-trim
- **Total cost: ~£15-30 (single-month subscription + spare for an iteration month)**
- **Risk:** Suno can't always nail odd-meter or specific instrumentation. Falls back to hand-comp for ~15% of assets.

### 10.2 Option B: Suno + small studio polish (recommended)

- Suno-gen the 5 leitmotifs + 6 ambient beds (~11 assets) for ~£10
- Hand-commission the 8 boss themes + Hanging Hour sting + 4 UI stings (~13 assets) from a freelance composer
- Freelance composer rate: ~£40-80 per finished minute on Fiverr / Soundbetter for mid-tier
- 13 assets × ~30 sec avg = ~6.5 min × £60 = ~£390
- **Total cost: ~£400-450**
- **Quality:** signature moments are hand-composed; backing tracks are gen'd. Best ROI.

### 10.3 Option C: Full hand-commission (premium)

- Full studio package: 75 assets, ~25 min of finished material
- Industry rate ~£40-100 per finished minute for indie game scope
- ~£1,000-2,500 typical range
- Delivery 4-8 weeks with iteration rounds
- **Total cost: ~£1,000-2,500**
- **Quality:** highest — consistent vision, stems delivered, can re-mix later

**Paul's call.** Recommend **Option B** for soft-launch (composer-touch on signature moments, gen for the rest). Re-cost to **Option C** at v1.0 launch if soft-launch validates audience.

---

## 11. Composer outreach copy

Paste-ready brief to send to a freelance composer:

> Hi — I'm working on a mobile game called **The Curse of Gallowfell**. It's a grimdark roguelite TD deckbuilder for iOS/Android, soft-launching in ~Q3-Q4 2026. We need 8 boss themes + 1 Hanging Hour bell-sting + 4 UI stings (~13 assets, ~6.5 min of finished material).
>
> The tone is "what if Doom: Eternal's composer scored a 12th-century funeral mass in a country church." Specific references: Hildur Guðnadóttir's _Joker_ score, Olafur Arnalds' _Island Songs_, Wardruna, Mick Gordon. NOT bombastic, NOT Disney epic. Restrained, hand-handled, present.
>
> I have a 12-page production brief with per-asset spec including key/tempo/instrumentation/length/style references. Format: OGG + WAV master per asset, mobile-loudness mix.
>
> Budget: £400-450. Timeline: 4 weeks. Iteration rounds: 2.
>
> Reply if interested — happy to send the full brief.

---

## 12. Open questions for Paul

1. **Option A vs B vs C.** Recommend B (£400-450). Confirm budget.
2. **Suno or Udio.** Both viable. Suno is slightly more recognisable for orchestral. Confirm.
3. **Boss theme replacement vs overlay.** §4 specifies overlays on top of faction leitmotifs. Alternative: standalone tracks per boss. Recommend overlays (cheaper, ties faction identity in). Confirm.
4. **Ch8 chaotic finale.** §4 calls for all 5 leitmotifs simultaneously detuned. This is technically ambitious for Suno. May need hand-comp. Confirm Paul wants this or simplify to "Ash-Mourners leitmotif inverted".
5. **Voice lines.** Per `audio_direction_v0.md` §8 Open Q2: spoken Warlord intros. Recommend defer to v1.1 (after voice-actor budget). Confirm.

---

## 13. Cross-references

- `audio_direction_v0.md` — design-intent spec (this is the production version).
- `GDD_v1.md` §2 — tone direction reference.
- `lore_gallowfell.md` — biome / faction lore drives leitmotif mood.
- `faction_bible.md` v1 — faction descriptions.
- `bosses_v0.md` + `bosses_chapters_2_3_v0.md` + `bosses_chapters_4_to_8_v0.md` — boss theme triggers.
- `keywords/hanging_hour_persist_v0.md` — HH trigger contract.
- `interaction_touch_v0.md` §4 + §8 — Settings audio sliders + haptics pairing.
- HANDOVER.md §6 — Suno + Sonniss + Freesound sourcing chain.

— Controller, 2026-05-22
