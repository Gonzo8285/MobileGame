# Audio direction v0 — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory items AUD-1 + AUD-2 + AUD-3. Per-faction leitmotifs + SFX catalogue + Hanging Hour sting. Generation-friendly spec — most assets producible via Suno/Udio (commercial-rights paid tier per HANDOVER §6) + Sonniss CC0 bundles + Freesound CC-BY filter._

**Status:** v0 spec. Pure design doc — no audio assets authored. Sourcing roadmap included.

---

## 1. Audio direction recap

Per HANDOVER §5: *"Orchestral strings + dark choir + industrial percussion. Each faction has a leitmotif."*

Three layers per scene:
1. **Background bed** — sustained ambience (drone / pad / wind)
2. **Faction leitmotif** — recognisable melodic phrase identifying the player's chosen Warlord faction
3. **Combat layer** — percussion + tense strings; intensifies as combat ramps

The Hanging Hour breaks all 3 layers with a 1.5s sting + bell-toll, then resumes.

---

## 2. Per-faction leitmotifs (AUD-1)

### 2.1 Composition spec

| Faction | Key | Tempo | Instrumentation | Theme description |
|---|---|---|---|---|
| **Iron Penitents** | D minor | 90 BPM | low strings + military snare + chain percussion | Marching, self-punishing. 4/4 with intentional drag. Chains audible in offbeats. Builds to a held minor chord. |
| **Ash-Mourners** | F# minor | 60 BPM | choir (low, dark) + dulcimer + raven caws | Funereal, courtly. 6/8 lament. Choir hums tonic. Dulcimer plays inverted-arpeggio motif (suggesting raven flight). |
| **Coven of the Black Mire** | E minor (with bog-flat-7) | 75 BPM | reed pipes + frog/cicada percussion + crone-vocals | Folkloric, ritual. 7/8 odd-meter sway. Reed pipes carry melody (suggesting smoke). Crone-vocals chant nonsense syllables. |
| **The Last Legion** | C minor | 110 BPM | brass + foundry-anvil percussion + iron-rail rhythm | Marching, mechanical. Marcia funebre meets industrial. Brass plays falling fifth motif. Anvils on downbeats. |
| **Skinward Pact** | A minor (modal — Aeolian) | 80 BPM | hand drums + bone-flute + wolf-howl ambience | Pagan, primal. Hand drums in 5/4. Bone-flute plays pentatonic motif. Wolf-howl punctuates phrase ends. |

### 2.2 Per-faction asset list

| Asset | Length | Use |
|---|---|---|
| `leitmotif_full` | 30 sec loop | combat scene background bed |
| `leitmotif_stinger` | 4 bars (~6 sec) | Warlord-select reveal, combat-start, run-victory |
| `leitmotif_softened` | 30 sec | map screen / hub scene (low-intensity variant of full) |

**Total per faction: 3 assets × 5 factions = 15 leitmotif assets**

### 2.3 Generation roadmap (Suno paid tier — commercial rights)

Per-faction Suno prompt template:

```
Style: orchestral [genre-tag from §2.1], grimdark fantasy, [tempo] BPM, [key]
Instrumentation: [list per §2.1]
Mood: [description per §2.1]
Length: 30 seconds, loopable
Output: instrumental only
```

**Example Iron Penitents prompt:**
```
Style: orchestral grimdark fantasy, 90 BPM, D minor, military marching
Instrumentation: low strings, military snare, chain percussion
Mood: marching, self-punishing, intentional drag, 4/4 with builds to held minor chord, chains audible in offbeats
Length: 30 seconds, loopable
Output: instrumental only
```

Generate 3-5 candidates per faction, pick best, manually loop-trim in Audacity. Iterate.

### 2.4 Licensing + cost

- Suno paid tier: ~$10/mo per HANDOVER tooling table; commercial-rights included on paid tier
- Iteration cost: ~$10 for all 15 assets across 1 month subscription
- Backup: hand-composition (Cubase / Reaper) for any leitmotif that doesn't AI-gen well

---

## 3. SFX catalogue (AUD-2)

40-event sound spec. Each entry: event trigger, perceptual category, source preference.

### 3.1 Card / hand SFX (8)

| ID | Event | Category | Source |
|---|---|---|---|
| sfx-card-draw | Card drawn from deck to hand | UI tick | Sonniss CC0 (card-shuffle bundles) |
| sfx-card-hover | Card hovered/selected in hand | UI hover | Sonniss CC0 |
| sfx-card-drop-valid | Card dropped on valid lane | UI confirm | Freesound CC0 |
| sfx-card-drop-invalid | Card dropped on invalid spot | UI error | Freesound CC0 |
| sfx-card-cast-spell | Spell card resolves | Spell ambient | Suno/manual whoosh |
| sfx-card-summon-unit | Unit card spawns on lane | Summon thud + brass | Suno/manual |
| sfx-card-place-trap | Trap card placed | Trap click | Freesound CC0 |
| sfx-deck-reshuffle | Empty deck triggers reshuffle | Shuffle riff | Sonniss CC0 |

### 3.2 Combat SFX (12)

| ID | Event | Category | Source |
|---|---|---|---|
| sfx-unit-attack-melee | MELEE unit hits target | Strike/clash | Sonniss CC0 (combat bundles) |
| sfx-unit-attack-short | SHORT-range attack | Bow/strike | Sonniss CC0 |
| sfx-unit-attack-long | LONG-range attack | Projectile whoosh | Sonniss CC0 |
| sfx-unit-take-damage | Unit takes damage | Grunt + impact | Freesound CC0 |
| sfx-unit-death-friendly | Friendly unit dies | Soft fall + sad string | Suno stinger |
| sfx-unit-death-enemy | Enemy dies | Crunch + groan | Sonniss CC0 |
| sfx-bleed-tick | BLEED applies / ticks | Drip drop | Freesound CC0 |
| sfx-poison-tick | POISON applies / ticks | Bubble / hiss | Freesound CC0 |
| sfx-shield-consume | SHIELD charge consumed | Metallic clank | Sonniss CC0 |
| sfx-shield-break | SHIELD all charges gone | Metallic shatter | Sonniss CC0 |
| sfx-persist-rise | Unit persists at end-of-turn | Spectral whoosh | Suno custom |
| sfx-cleave | CLEAVE attack fan-out | Whoosh × 3 | Sonniss CC0 |

### 3.3 Map / event SFX (6)

| ID | Event | Category | Source |
|---|---|---|---|
| sfx-map-node-enter | Player enters new node | UI confirm | Sonniss CC0 |
| sfx-map-node-hover | Hover map node | UI hover | Sonniss CC0 |
| sfx-event-reveal | Event card reveals | Mystery sting | Suno custom |
| sfx-shrine-pray | Player picks "Pray" on shrine | Choir whisper | Suno custom |
| sfx-shrine-defile | Player picks "Defile" on shrine | Wood-snap + warning sting | Suno custom |
| sfx-rest-heal | REST node heal action | Soft heal chime | Freesound CC0 |

### 3.4 Reward / progression SFX (8)

| ID | Event | Category | Source |
|---|---|---|---|
| sfx-reward-card-reveal | Reward screen card reveals | Fanfare 1 | Suno custom |
| sfx-reward-card-pick | Player picks reward card | Confirm + brass | Sonniss CC0 |
| sfx-gem-gain | Gain gems | Crystal chime ascending | Freesound CC0 |
| sfx-bone-gain | Gain Bones | Hollow rattle | Freesound CC0 |
| sfx-relic-acquire | New relic in possession | Ancient hum + brass | Suno custom |
| sfx-warlord-tier-up | Warlord tier ladder advance | Fanfare 2 | Suno custom |
| sfx-mastery-unlock | Card mastery tier 3+ | Soft chime + held note | Suno custom |
| sfx-treatment-unlock | Cosmetic treatment unlock | Shimmer sting | Suno custom |

### 3.5 Hub / menu SFX (4)

| ID | Event | Category | Source |
|---|---|---|---|
| sfx-menu-tap | Menu button tap | UI tap | Sonniss CC0 |
| sfx-menu-modal-open | Modal opens | UI rise | Sonniss CC0 |
| sfx-menu-modal-close | Modal closes | UI fall | Sonniss CC0 |
| sfx-purchase-success | IAP purchase completes | Bell + brass crescendo | Suno custom |

### 3.6 Boss + Hanging Hour SFX (2)

| ID | Event | Category | Source |
|---|---|---|---|
| sfx-boss-spawn | Boss appears | Heavy drum + brass roar | Suno custom |
| sfx-boss-killed | Boss defeated | Long fall + held minor chord | Suno custom |

**Total: 40 SFX events.**

### 3.7 Sourcing summary

| Source | Count | Cost |
|---|---|---|
| Sonniss GDC bundles (CC0) | ~18 events | free |
| Freesound CC0/CC-BY | ~8 events | free |
| Suno custom-generated | ~14 events | $10/mo subscription |
| Total | 40 events | ~$10 single-month + free assets |

### 3.8 Implementation budget

- Per-SFX file size target: < 100 KB (mobile-friendly download size)
- Format: OGG Vorbis (Godot-native) at 96 kbps
- Total catalogue size: ~4 MB

---

## 4. Hanging Hour sting + ambient (AUD-3)

### 4.1 Sting (1 asset)

- **Length:** 2 seconds
- **Composition:** single dramatic bell-toll struck on beat 1, sustained 1 second, decay 1 second; layered with low string swell underneath
- **Purpose:** plays at the exact moment Hanging Hour triggers (turn 5 standard / 4 boss / per `keywords/hanging_hour_persist_v0.md`)
- **Format:** stereo OGG, 192 kbps (premium quality — single-event drama)
- **Triggers:** `combat.hanging_hour_struck` signal

### 4.2 Ambient bell-toll loop (1 asset)

- **Length:** 8 seconds loop
- **Composition:** distant bell ringing every 4 seconds (single toll on bar 1, single toll on bar 3), under quiet wind ambience
- **Purpose:** plays as a "the bell remembers" ambient layer underneath the leitmotif during turns 3-4 (pre-HH) and turns 5-6 (post-HH); fades in over 2 sec, out over 2 sec
- **Format:** mono OGG, 96 kbps (background quality)

### 4.3 Generation prompts

Sting:
```
Style: orchestral grimdark, dramatic single-event sting
Length: 2 seconds
Composition: heavy church bell strike on beat 1, sustained, decays under low string swell
Mood: ominous, time-stop, the curse arrives
```

Ambient:
```
Style: orchestral ambient, distant church bell
Length: 8 seconds loop
Composition: bell tolls on beats 1 and 5, soft wind ambience underneath
Mood: foreboding, the bell remembers, quiet
```

---

## 5. Audio mixing + dynamics

### 5.1 Bus layout (Godot AudioServer)

```
Master
├── Music bus
│   ├── Leitmotif bus (per-faction)
│   ├── HH ambient bus
│   └── Sting bus
├── SFX bus
│   ├── Combat SFX bus
│   ├── Card SFX bus
│   ├── UI SFX bus
│   └── Notification SFX bus
└── Voice bus (reserved for v1.1 voiced lines)
```

### 5.2 Default volume mix

- Master: -6 dB
- Music: -8 dB (subordinated to gameplay)
- SFX: -3 dB (player feedback priority)
- Voice: -5 dB
- HH sting: -2 dB (above all other music briefly)

### 5.3 Adaptive mixing (combat intensity)

- Turn 1: Music bus -10 dB
- Turn 3+: Music bus -8 dB (slight intensify)
- Turn 5 (HH): Music bus duck to -15 dB during sting (1.5s), recover to -6 dB after (full intensity post-HH)
- Boss combat (e.g. Black-Bell Choir): always -6 dB Music bus, +2 dB on boss SFX

---

## 6. Engine handoff

### 6.1 Audio manager pattern

`game/src/audio/audio_manager.gd` — autoload:

```
class_name AudioManager extends Node

# Loaded music streams per faction
var leitmotif_streams: Dictionary  # { faction_id: { "full": AudioStream, "stinger": AudioStream, "softened": AudioStream } }
var hh_sting: AudioStream
var hh_ambient: AudioStream

# Currently playing
var current_leitmotif_player: AudioStreamPlayer
var current_ambient_player: AudioStreamPlayer

func play_leitmotif(faction_id: StringName, variant: StringName = &"full") -> void
func play_hh_sting() -> void
func play_hh_ambient_fade_in() -> void
func play_hh_ambient_fade_out() -> void
func play_sfx(sfx_id: StringName) -> void  # routes to bus by id-prefix
func duck_music(target_db: float, duration_ms: int) -> void
func set_combat_intensity(level: int) -> void  # 1-5 maps to music-bus dB
```

### 6.2 Signal wiring (combat → audio)

```
# combat.gd connections
GameState.combat_started.connect(_on_combat_started)
GameState.combat_ended.connect(_on_combat_ended)
GameState.hanging_hour_struck.connect(_on_hh_struck)
GameState.turn_resolved.connect(_on_turn_resolved)

func _on_hh_struck():
    AudioManager.duck_music(-15.0, 1500)
    AudioManager.play_hh_sting()
    await get_tree().create_timer(1.5).timeout
    AudioManager.duck_music(-6.0, 500)
```

### 6.3 Settings integration

Per `interaction_touch_v0.md` §4: Settings has Music/SFX/Voice volume sliders. AudioManager listens for setting changes and updates bus volumes:

```
Settings.audio_changed.connect(_on_audio_settings_changed)
func _on_audio_settings_changed():
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(Settings.music_volume))
    # etc.
```

---

## 7. MVP coverage

| Asset | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| Per-faction leitmotifs | silence | 3 of 5 (Penitents/Mourners/Coven) | all 5 | all 5 + softened variants | full |
| SFX catalogue | 3 stubs (card-play / hit / defeat per `internal_mvp_scope.md`) | 20 of 40 | full 40 | full + multi-language UI | full |
| HH sting + ambient | — | both authored | both wired | both wired | both wired |
| Adaptive mixing | — | basic | full | full | full |

---

## 8. Open questions for Paul

1. **Suno subscription** — confirm willingness to pay $10/mo for ~1-2 months of audio gen, or prefer Udio / Stable Audio alternative?
2. **Voice lines** — per `monetisation_map.md` warlord-select-screen reference, are there spoken Warlord intros? Currently spec'd as voice-bus reserved but no v1 lines. Confirm defer to v1.1.
3. **Leitmotif key choices** — D / F# / E / C / A minor cover most ground, but C minor + A minor are close. Consider F major for Skinward (modal-major) to avoid all-minor-monotony. Recommend swap A minor → A modal-Aeolian (still minor-ish but distinct).
4. **Bell-toll SFX licensing** — for the HH bell, generic CC0 vs Suno-generated? Recommend Suno custom for signature-moment uniqueness.

---

## 9. Cross-references

- `interaction_touch_v0.md` §4 (Settings) and §8 (haptics — paired with SFX events).
- `gameplay_keywords_resolution_v0.md` — keyword events drive SFX list §3.2.
- `bosses_v0.md` + `bosses_chapters_2_3_v0.md` — boss spawn / death SFX hooks.
- `keywords/hanging_hour_persist_v0.md` — HH trigger contract.
- `lore_gallowfell.md` — faction lore drives leitmotif mood.
- HANDOVER §6 — Suno + Sonniss + Freesound sourcing chain.

— Controller, 2026-05-21
