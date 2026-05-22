# Trailer Script v0 — The Curse of Gallowfell

_Authored 2026-05-22 by Controller (round 3). Shot-by-shot 60-second launch trailer + 30-second cut-down. Music cues reference leitmotifs locked in `audio_production_brief_v1.md`. Visuals reference faction biomes locked in `faction_bible.md` v1 and the chapter-1 boss spec'd in `bosses_v0.md`. Author of record for video editor hand-off._

**Status:** v0 spec. No editor commissioned. Lives as a paste-pack a freelance editor can shoot to.

---

## 1. Top-line creative brief

**Run-time:** 60 sec primary cut · 30 sec cut-down for paid social.  
**Aspect ratios needed:** 16:9 (1920×1080) for YouTube + Steam · 9:16 (1080×1920) for TikTok / Reels / Shorts · 1:1 (1080×1080) for IG feed + paid social.  
**Sound:** stereo 192 kbps OGG master delivered as WAV; closed-caption sidecar required (.srt + burned-in alt cut).  
**Tone:** grim with restraint. Never camp. Three pillar references from the audio brief carry through to the cut:

1. **Mick Gordon energy** — only at the boss-climax act, never sustained
2. **Wardruna folk-doom** — the world-tour act
3. **Hozier _Cherry Wine_ patience** — the hook and the CTA breath

**One-line brief if the editor can only read one sentence:** "Imagine if Doom: Eternal's composer scored a 12th-century funeral mass in a country church — then we cut a 60-second mobile-game trailer to it."

---

## 2. Structure (5 acts)

| Act | Beat | Duration |
|---|---|---|
| 1 | HOOK — the gallows-bell | 8 sec |
| 2 | WORLD — five biomes, five factions | 14 sec |
| 3 | SYSTEM SHOWCASE — deck + lanes + Hanging Hour | 18 sec |
| 4 | BOSS CLIMAX — Black-Bell Choir + bell-toll | 14 sec |
| 5 | CTA + LOGO | 6 sec |
| | **Total** | **60 sec** |

---

## 3. Shot-by-shot — 60-second cut

### Act 1 — HOOK (0:00 – 0:08)

| Shot | T-in | Dur | Visual | On-screen text | Audio | Pacing |
|---|---|---|---|---|---|---|
| H1 | 0:00 | 3.0 s | Black frame fading to a single, very slow pan up a knotted rope against a slate-grey dawn sky. The rope ends just out of frame. | _(none)_ | Ambient bed: wind + distant single bell-toll on 0:02 (Mourners' funeral bell, F# minor). | Hold longer than feels safe. Let it breathe. |
| H2 | 0:03 | 3.0 s | The pan reveals the gallows-tree at the top of Gallows Hill, silhouetted, the wider town in mist below. Tilt continues, very slow. | _(centred, fade-in at 0:04, fade-out at 0:06)_ **"They hanged a saint here."** | Bell-toll repeats on 0:05. Choir hum (Mourners _softened_ variant) starts at -16 dB. | Title-card register. No flashy kerning. |
| H3 | 0:06 | 2.0 s | Single cut to a still painting frame — the Saint That Should Not Hang, eyes painted shut. 1.5 sec hold, then hard cut to black. | _(none)_ | Choir hum cuts on the hard-cut to black. Two-frame silence. | Single hard cut. No transition. |

### Act 2 — WORLD (0:08 – 0:22)

Five biome flashes, ~2.8 sec each. Each flash is a slow push-in on a wide environmental shot with one faction sigil revealing at the end of the shot. Music: cross-fade through softened leitmotif stingers in faction order.

| Shot | T-in | Dur | Visual | On-screen text | Audio | Pacing |
|---|---|---|---|---|---|---|
| W1 | 0:08 | 2.8 s | Cathedral Ruins — split pews, dust shafts, candle-yellow rim-light. Push-in. End-frame: **Iron Penitents** sigil bottom-left, dimmed. | **"Five factions."** (lower-third, fade-in mid-shot) | Penitents stinger (D minor, 90 BPM, dragged snare + chain percussion). 4 bars. | Each biome is one breath. |
| W2 | 0:10.8 | 2.8 s | Catacombs — corridor of standing dead, gilt-bone masks catching one candle. Push-in. End-frame: **Ash-Mourners** sigil. | _(none)_ | Crossfade to Mourners stinger (F# minor, 60 BPM 6/8, choir + dulcimer + raven caws). 4 bars. | — |
| W3 | 0:13.6 | 2.8 s | Bog of Bargains — coins floating face-up in dark water, demon-hoofprint half-submerged. Push-in. End-frame: **Coven** sigil. | _(none)_ | Crossfade to Coven stinger (7/8 reed pipe + crone vocal). 4 bars. | — |
| W4 | 0:16.4 | 2.8 s | The Foundry — black-coal forges, iron rails, soot. Push-in. End-frame: **Last Legion** sigil. | _(none)_ | Crossfade to Legion stinger (C minor 110 BPM brass + anvil). 4 bars. | — |
| W5 | 0:19.2 | 2.8 s | Cinderwood — half-burnt forest, the gallows-tree stump at frame-centre, smoke trailing left. Push-in. End-frame: **Skinward Pact** sigil. | **"One cursed town."** (lower-third, fade-in at 0:20) | Crossfade to Skinward stinger (5/4 hand drum + bone-flute, wolf-howl fade-in). 4 bars. | — |

### Act 3 — SYSTEM SHOWCASE (0:22 – 0:40)

Gameplay capture, portrait-orientation phone frame in centre with landscape gameplay zoomed in around it. Per `interaction_touch_v0.md` — drag-to-lane.

| Shot | T-in | Dur | Visual | On-screen text | Audio | Pacing |
|---|---|---|---|---|---|---|
| S1 | 0:22 | 3.5 s | Hand of 5 cards. Player thumb drags a Pall-Bearer card from hand to lane. Card glows on valid drop. Unit summons on tile. | **"Build a deck. Hold the lane."** | Layered ambient + low ticking percussion. Card-place SFX (`sfx-card-drop-valid`). Unit-summon SFX (`sfx-card-summon-unit`). | Show the gesture clearly. |
| S2 | 0:25.5 | 3.5 s | Three lanes visible. Combat resolves — friendly Cathedral Brother cleaves two enemies, BLEED ticks fire. UI-icons read clearly. | _(small captions)_ "CLEAVE" · "BLEED" | Combat ambient. `sfx-cleave` + `sfx-bleed-tick` × 2. | Show the keywords without explaining them. |
| S3 | 0:29 | 3.5 s | Ascending overhead pull-back. Lanes condense to a tactical line. Warlord portrait flashes (Sieren). Reward-pick screen: 1 of 3 cards. Thumb taps a card. | **"Eight combats. One run."** | Layer in soft Mourners ambient. Reward-pick SFX (`sfx-reward-rare`). | The choice is the thing. |
| S4 | 0:32.5 | 4.0 s | The Hanging Hour fires. Screen ash-tints. Bell-toll. Diegetic clock reads 23:59 → 00:00. All friendly units flash +1 ATK. One fallen enemy rises. | **"And one hour the dead remember."** | Hard cut to silence on 0:32.5 (1-frame). Bell-toll on 0:33 — full _Hanging Hour sting_ (2 sec, F# minor). Ambient drops out for 1.5 sec. Bell sting decays into pillar reference 1 build-in. | The signature moment. Treat it like a scene change in a horror film — silence then strike. |
| S5 | 0:36.5 | 3.5 s | Quick montage: 3 Warlords playing distinct decks — Vyrrun's flagellant rush · Eddra's bog-token swarm · Mhar's beast summons. 1.0 sec per Warlord, hard cuts. | _(none)_ | Industrial percussion ramps. Pillar 1 (Mick-Gordon-energy) — restrained, building. | Tease variety. |

### Act 4 — BOSS CLIMAX (0:40 – 0:54)

The Black-Bell Choir reveal, per `bosses_v0.md` chapter-1 spec.

| Shot | T-in | Dur | Visual | On-screen text | Audio | Pacing |
|---|---|---|---|---|---|---|
| B1 | 0:40 | 2.5 s | Boss reveal frame. Black-Bell Choir centre, three bells tolling, robed figures behind. Camera holds. | **"Chapter 1."** _(top-left)_ | _Bells Hold the Hours_ boss theme (Ch1) — full Mick-Gordon-energy mode. Three-bell tolling pattern. Loud, mid-low brass under choir. | Bring the bass back. |
| B2 | 0:42.5 | 3.5 s | Gameplay — boss signature ability fires (every-bell-toll AOE). Friendly units take damage, player drops a Crucified Saint and counters. Cards fly. | _(small caption)_ "BOSS · HANGING HOUR" | Layer in male choir on top of Mourners ext. Industrial-percussion-meets-orchestral. Combat SFX layered. | This is the loudest moment. |
| B3 | 0:46 | 4.0 s | Slow-motion: player unit lands killing blow on the Black-Bell. Bells crack. Choir vocal climaxes. | **"You will die. The town will not."** | Choir climax. Bells crack on 0:48 (one-shot SFX, very wet reverb). | Slow-mo here = earned. |
| B4 | 0:50 | 4.0 s | Cut to player avatar's noose-mark scar (the death-debt). Camera pulls out — Gallows Hill in background, eleven Warlord silhouettes assembling. | **"Eleven Warlords. One curse."** | Music drops to held minor chord. Soft Mourners _softened_ outro. | The breath before the CTA. |

### Act 5 — CTA + LOGO (0:54 – 1:00)

| Shot | T-in | Dur | Visual | On-screen text | Audio | Pacing |
|---|---|---|---|---|---|---|
| C1 | 0:54 | 3.0 s | Game logo (The Curse of Gallowfell — wordmark) on dark stone, slow fade-in. Single candle-flame guttering bottom-right. | **THE CURSE OF GALLOWFELL** _(centred wordmark)_ | Single soft funeral bell-toll. Otherwise near-silence. Pillar 3 (Hozier patience) reference for the breath. | Don't rush this. |
| C2 | 0:57 | 3.0 s | Storefront badges below the logo — App Store + Google Play. URL: `gallowfell.ml2consulting.com`. PEGI 12 / Teen 13+ stamp bottom-left. | **"Coming to iOS + Android."** · _(small)_ "Soft-launch 2026 · ml2consulting.com" | Bell-toll fade-out. Last 0.5 sec silent. | Hold the silence into the cut-to-black. |

---

## 4. 30-second cut-down

Same beats, compressed. Drop Act 2 to two biomes (Cinderwood + Catacombs only — the two strongest visual reads) and Act 3 to two shots. Keep the Hanging Hour sting; it's the trailer's signature moment. Keep the CTA at 4 seconds.

| Slot | T-in | Dur | Source | Notes |
|---|---|---|---|---|
| 1 | 0:00 | 4.0 s | H1 + H2 compressed | Rope + gallows + **"They hanged a saint here."** Single bell-toll. |
| 2 | 0:04 | 2.5 s | W2 (Catacombs) | + sigil reveal. Mourners stinger. |
| 3 | 0:06.5 | 2.5 s | W5 (Cinderwood) | + sigil reveal. Skinward stinger. **"Five factions. One cursed town."** lower-third. |
| 4 | 0:09 | 3.5 s | S1 + S2 compressed | Drag-to-lane + cleave + bleed. **"Build a deck. Hold the lane."** |
| 5 | 0:12.5 | 3.5 s | S4 (full) | Hanging Hour sting. **"And one hour the dead remember."** This is the spine. |
| 6 | 0:16 | 4.5 s | B1 + B2 compressed | Black-Bell reveal + signature ability + counter-play. Boss theme full. |
| 7 | 0:20.5 | 3.0 s | B3 compressed | Slow-mo killing blow. **"You will die. The town will not."** |
| 8 | 0:23.5 | 2.5 s | B4 compressed | Pull-out to eleven Warlords. **"Eleven Warlords. One curse."** |
| 9 | 0:26 | 4.0 s | C1 + C2 compressed | Logo + storefront badges + **"Coming to iOS + Android."** |
| | **Total** | **30 sec** | | |

---

## 5. Tone notes for the editor

- **Restraint first.** Per the audio brief, three pillar references all share patience. _Never camp._ No record-scratch transitions. No "ANOTHER ONE"-style cuts. No dubstep drops. No fake-out fake-outs.
- **The Hanging Hour is the trailer's spine.** That single shot — bell-toll, ash-tint, +1 ATK flash, dead enemy rising — is what the viewer should remember. Everything before it builds to it; everything after it cashes the chip.
- **The 1-frame silence before the bell-toll is load-bearing.** Don't replace it with a "dramatic" sound. The silence _is_ the dramatic sound.
- **Wardruna energy for Act 2.** Folk-pagan, drone-heavy, hand-drums-only-when-on-screen. The world-tour is a procession, not a fashion show.
- **Mick Gordon energy for Act 4 only.** Build into it from Act 3's industrial-percussion ramp. Earn the loud. _Don't sustain it past 0:50._
- **Hozier-_Cherry Wine_ patience for Act 5.** The CTA breath. Single guttering candle. Don't punctuate the bell-toll fade-out — let it die.
- **No-go list:**
  - No reviewer pull-quotes (we have none yet; don't fake them)
  - No "Game of the Year" badges (we have none)
  - No fake gameplay (capture from build only)
  - No third-party music we can't licence
  - No Hozier or Wardruna _actual tracks_ — those are pillar references, the score is bespoke
  - No frames of the Saint That Should Not Hang's full face (it's painted-shut for canon reasons)
- **CC-safe pillar references for the music brief:** all music is bespoke composition matching the leitmotifs locked in `audio_production_brief_v1.md`. The editor never licences pillar-reference tracks — the editor scores against the bespoke OST.

---

## 6. Deliverables checklist (editor-side)

- [ ] Master 60s cut, 16:9, 1920×1080, ProRes 422 + H.264 1080p
- [ ] 60s cut, 9:16, 1080×1920 (TikTok / Reels / Shorts)
- [ ] 60s cut, 1:1, 1080×1080 (IG feed + paid social)
- [ ] 30s cut-down, all three aspect ratios
- [ ] 6s silent cut-down for App Store Connect preview
- [ ] Burned-in subtitles cut (16:9 + 9:16)
- [ ] .srt subtitle sidecar (en-GB)
- [ ] Audio stems: dialogue / music / SFX, split
- [ ] Frame-grabs at 0:33 (Hanging Hour sting), 0:46 (boss kill), 0:54 (logo) for press use

---

## 7. Version history

- v0 — 2026-05-22 — Controller round 3. First filing-ready trailer script. Pre-editor commission.

— Controller, 2026-05-22
