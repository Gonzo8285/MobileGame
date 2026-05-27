# Tutorial Flow v0 — The Curse of Gallowfell

_Authored 2026-05-22 by Controller (round 2). Closes inventory item INT-5. First-run experience for new installs. Locks the 3-minute onboarding sequence + skip path + analytics events. Wireframe-level — implementation details land in `interaction_touch_v0.md` §5 (which this doc supersedes for the onboarding scope)._

**Status:** v0 spec. Pending Paul sign-off + ff-151 engine wiring (Phase 3 B2 onwards).

---

## 1. Why this matters

Per `GDD_v1.md` §9 soft-launch KPI table, **tutorial-completion rate ≥ 85%** is a pass-bar for soft-launch. The single biggest D0→D1 retention lever in mobile games is the first 3 minutes: a player who reaches their first run-victory or first reward pick is ~3× more likely to come back tomorrow than a player who quit during tutorial. This doc locks that 3-minute slice.

**Design constraints:**
1. **3 minutes hard cap** from "app cold-launch" to "free play starts".
2. **No more than 4 tap-blocked overlay tips.** Overlay-tip fatigue is a known retention killer. Show fewer, more meaningful tips.
3. **Skippable from any screen** via a "Skip Tutorial" button top-right (small but always visible).
4. **One-Warlord forced path** — first run is locked to Vyrrun (Iron Penitents Aggro) because his fantasy is the most legible for a new player ("hit hard, take risks").
5. **No monetisation surfaces in the first 3 minutes.** Store, BP, IAP buttons all hidden until after first reward pick. Per `monetisation_map.md` Anti-P2W §7 — no IAP banners on first-run experience.
6. **Analytics events fire at every step** so we can find drop-off points in soft-launch telemetry.

---

## 2. Screen-by-screen sequence (3 minutes / 12 screens)

### Screen 1 — Splash + title (0:00 - 0:10)

**Visual:** Black background. App icon enlarges from centre. Title text fades in: **"The Curse of Gallowfell"** (Cinzel font, white). Below: "Tap to begin" (IM Fell English, dim).

**Audio:** `sting-title-screen` plays once (~2 sec). Distant bell-toll under it.

**Interaction:** any tap → Screen 2.

**Time budget:** 10 sec (5 sec mandatory branding hold + up to 5 sec for tap).

**Skippable:** no (this is the brand moment).

**Analytics:** `tutorial_screen_1_seen` fires on render.

---

### Screen 2 — Cold-open cutscene (0:10 - 0:50)

**Visual:** 8 still frames slide in/out (4 sec each, cross-fade between). Frames show:
1. The empire's gallows-tree (silhouette, distant, dusk)
2. A noose with no body
3. Close-up: a Penitent's iron mask, half-broken
4. The cathedral's broken cross
5. The bog at twilight, demon-coin glinting in the mud
6. The Foundry's brass-and-soot banner
7. The Cinderwood's burnt trees with a Skinward figure between them
8. The 8-pip linear map fading in (transition to UI)

Narration text on each frame (1-2 sentences each, IM Fell English at the bottom of frame, ~14pt). Voice-over deferred (per `audio_direction_v0.md` §8 Open Q2) — text-only for soft-launch.

**Sample narration text:**
- Frame 1: _"The empire hung its own here. Centuries of them."_
- Frame 2: _"They stopped trying to count the bodies. The town wouldn't let them leave."_
- Frame 3: _"Some came to make peace with the noose."_
- Frame 4: _"Others came to argue with the empire that put them in it."_
- Frame 5: _"Some came to feed it. Some came to swallow it whole."_
- Frame 6: _"The empire is dead. The orders are not."_
- Frame 7: _"The trees remember every axe-stroke."_
- Frame 8: _"You're one of them now. Pick your reason."_

**Audio:** `leitmotif_softened` of a randomised faction (so the cold-open feels different per re-install). Volume -10 dB. Crossfade out on frame 8.

**Interaction:** "Skip cutscene" button top-right always available. Auto-advance 4 sec per frame; tap-to-advance early.

**Time budget:** 40 sec (8 frames × 5 sec including transitions, but tap-skips allowed).

**Skippable:** yes (full cutscene skip → jumps to screen 3). Skipping fires `tutorial_cutscene_skipped`.

**Analytics:** `tutorial_screen_2_seen`, `tutorial_cutscene_complete` on frame 8, `tutorial_cutscene_skipped` if skipped.

---

### Screen 3 — Tutorial fight intro (0:50 - 1:00)

**Visual:** Cathedral Ruins biome backdrop. Vyrrun (Penance-Captain) portrait centre, half-tinted. Text overlay: _"You are Penance-Captain Vyrrun. Three sinners stand in your way. Place your warband, swing your hammer."_ Below: large button **"Begin"**.

**Audio:** Iron Penitents leitmotif full plays (the bell-toll loop fades out as combat fades in).

**Interaction:** Tap "Begin" → Screen 4.

**Time budget:** 10 sec.

**Skippable:** "Skip Tutorial" top-right available (drops to Screen 11).

**Analytics:** `tutorial_screen_3_seen`.

---

### Screen 4 — Tutorial combat: first card play (1:00 - 1:25)

**Visual:** Single-lane combat scaffolded. Three enemies (Cathedral-Brother + 2 weak token-tier units) march from right. Vyrrun's tutorial hand of 3 cards visible: **Cathedral Brother** (1-cost, MELEE), **Self-Scourge** (1-cost, spell), **Iron Shield** (2-cost, SHIELD-2 to friendly unit).

Tile grid shows 3 lanes × 4 tiles. Mana = 3. Turn 1.

**Overlay tip 1 (tap-blocked):** highlight Cathedral Brother card in hand. Text: _"Drag the Cathedral Brother to a lane tile."_ Arrow points from card to first tile in centre lane.

Player must drag the Cathedral Brother to a centre-lane tile. No other card responds. Tile glows green on valid drop target.

On drop: Cathedral Brother appears on tile. Mana ticks to 2. Tip dismisses. Enemy turn fires — first enemy walks 1 tile.

**Overlay tip 2 (tap-blocked):** highlight Self-Scourge card. Text: _"Self-Scourge: spend 1 mana. Your unit takes 3 damage, all your units gain +2 ATK. Tap it, then tap your Cathedral Brother."_

Player taps Self-Scourge → it highlights blue → taps Cathedral Brother → spell resolves. Brother is at 5 HP (took 3 damage from 8 HP), ATK now 3.

Enemy turn: enemies advance. First enemy hits Cathedral Brother for 2 damage. Brother now at 3 HP.

Player turn 2 (mana = 4): tap end-turn or play Iron Shield. Engine forces them to play Iron Shield via Tip 3 OR by limiting actions.

**Overlay tip 3 (tap-blocked):** highlight Iron Shield card. Text: _"Iron Shield: protect your unit before the next strike."_ Arrow points from card → Brother.

Player drags Iron Shield to Brother → SHIELD-2 applied.

End-turn fires. Brother attacks first enemy for 3 damage (kills it). Second enemy attacks Brother, hits shield (SHIELD absorbs 2). Third enemy advances.

Turns 3-4: Brother kills the rest. **Tutorial combat resolves with a win.**

**Audio:** combat SFX (sfx-card-summon-unit, sfx-card-cast-spell, sfx-unit-attack-melee, sfx-unit-death-enemy, sfx-shield-consume). Music: Iron Penitents leitmotif full.

**Time budget:** 25 sec.

**Skippable:** "Skip Tutorial" available — drops to Screen 11.

**Analytics:** `tutorial_screen_4_seen`, `tutorial_first_card_played`, `tutorial_first_spell_cast`, `tutorial_first_combat_won`. Drop-off telemetry on each subgate.

---

### Screen 5 — First reward pick (1:25 - 1:35)

**Visual:** Reward screen UI. 3 cards displayed (face-up, big). Cards: **Cathedral Hammer** (Penitent 2-cost), **Nail-Choir Flagellant** (Penitent 1-cost), **Self-Scourge** (the spell again — duplicate accepted).

**Overlay tip 4 (final tap-blocked):** _"Pick one card to add to your deck. Your deck grows as you survive."_

Player taps any card → card flies into a deck-pile animation. SFX: sfx-reward-card-pick. +2 gems gained (matches round-1 reward per balance doc).

**Audio:** sfx-reward-card-reveal at screen-load, sfx-reward-card-pick on selection.

**Interaction:** Tap any card → Screen 6.

**Time budget:** 10 sec.

**Skippable:** "Skip Tutorial" available — drops to Screen 11.

**Analytics:** `tutorial_screen_5_seen`, `tutorial_first_reward_picked` (with `card_id` payload).

---

### Screen 6 — Warlord pick screen (1:35 - 1:55)

**Visual:** 5 Warlord portraits across the screen (the free roster). Vyrrun glows highlighted as "selected" (the tutorial Warlord). Other 4 visible but slightly dimmed.

Text overlay (NOT tap-blocked, dismissible): _"You picked Vyrrun for the tutorial. You can pick a different Warlord for your full run, or keep Vyrrun. Each Warlord changes how the game feels."_

5 Warlord portraits show: Vyrrun (highlighted), Sieren, Eddra, Veska, Mhar. Tap any Warlord → swap selection. Selected Warlord's faction palette tints the background slightly.

Bottom of screen: **"Begin Your Run"** button.

**Audio:** Selected Warlord's leitmotif stinger plays on tap-to-select. Background: hub-tone ambient.

**Interaction:** Tap any portrait to select. Tap "Begin Your Run" → Screen 7.

**Time budget:** 20 sec (most players will just tap "Begin" without changing).

**Skippable:** N/A (no longer "tutorial" — this is the regular Warlord-pick screen).

**Analytics:** `tutorial_screen_6_seen`, `tutorial_warlord_swapped` (if changed from Vyrrun), `tutorial_warlord_finalised` (with `warlord_id`).

---

### Screen 7 — Deck builder explainer (1:55 - 2:10)

**Visual:** Starter deck display. 12 cards in a 4×3 grid, taps-to-zoom on each. Per `starter_decks_v0.md`, the displayed deck depends on chosen Warlord (Vyrrun's starter is in §2.1).

Text overlay (dismissible, NOT tap-blocked): _"This is your starter deck. 12 cards. Survive 8 combats to win the run. You'll add cards as you go."_

Bottom button: **"Set Out"**.

**Audio:** Selected Warlord's leitmotif (continued from Screen 6).

**Interaction:** Tap cards to zoom-inspect (`sfx-card-hover`). Tap "Set Out" → Screen 8.

**Time budget:** 15 sec (most players tap through; curious players inspect cards).

**Analytics:** `tutorial_screen_7_seen`, `tutorial_deck_card_inspected` (per inspection — capped at 12 events).

---

### Screen 8 — Map screen reveal (2:10 - 2:20)

**Visual:** Linear 8-pip map appears, sliding in from the right. Pips show: ⚔ ⚔ ⚔ ⚔⚔ ✦✦✦ ⚔ ✦✦✦ ☠ (matching `2026-05-18_gallowfell_balance.md` round 1-8). Pip 1 highlighted, others greyed. HUD shows: HP (50/50), Mana (3), Gems (5 = starter 3 + 2 from tutorial win), Warlord name.

Text overlay (dismissible): _"Eight combats. One boss. Reach the end."_

Bottom button: **"Enter"** (sits on the pip 1).

**Audio:** sfx-map-node-enter on screen-load. Soft Penitents leitmotif (softened variant) underneath.

**Interaction:** Tap "Enter" → Screen 9.

**Time budget:** 10 sec.

**Analytics:** `tutorial_screen_8_seen`, `tutorial_first_map_node_entered`.

---

### Screen 9 — First "real" combat (round 1) (2:20 - 3:00 estimated)

**Visual:** Combat scene. Round 1 enemies: 3 weak units. The player now plays through round 1 of their actual run. No more overlay tips. No more tutorial scaffolding. Full game.

**Audio:** Faction leitmotif full.

**Interaction:** Standard combat. Player plays normally.

**Time budget:** 40 sec target (typical round-1 combat length per balance doc).

**Analytics:** `tutorial_first_real_combat_started`, `tutorial_first_real_combat_won` (on combat-end) or `tutorial_first_real_combat_lost`.

---

### Screen 10 — First event-style touch (Round 1 reward pick) (3:00 - 3:10)

After round 1 ends, reward screen displays 3 cards. **Tutorial is now considered complete.** Tutorial-completion event fires.

**Visual:** Reward screen (same as Screen 5 but with new cards from the faction-weighted pool).

**Interaction:** Tap any card → card added to deck. Player proceeds to round 2.

**Analytics:** **`tutorial_complete` FIRES HERE** (with `total_seconds_in_tutorial` payload, `skipped_segments` payload, `warlord_finalised` payload).

---

### Screen 11 — Tutorial skipped path (alternative exit)

Triggered if player taps "Skip Tutorial" at any point.

**Visual:** Confirmation modal: _"Skip the tutorial? You can replay it from Settings later."_  
Buttons: **"Skip"** / **"Continue tutorial"**.

If "Skip" tapped:

**Visual:** Brief loading screen, then drops directly to Screen 6 (Warlord pick, with no Vyrrun-forced highlight — player picks freely).

**Analytics:** `tutorial_skipped` (with `skipped_from_screen` payload).

---

### Screen 12 — In Settings: Replay tutorial

In Settings (Settings → Onboarding → Replay tutorial), tapping the option drops user back to Screen 1 (forced full re-run). Used for QA + accessibility.

**Analytics:** `tutorial_replayed_from_settings`.

---

## 3. Skip toggle — locations

| Where | Behaviour |
|---|---|
| In-tutorial: top-right "Skip Tutorial" button | Visible on screens 3-5. Triggers Screen 11 confirmation modal. |
| Settings → Onboarding → Replay tutorial | Re-runs full tutorial from Screen 1. |
| Settings → Onboarding → Show overlay tips in-game | Toggle for the 4 tap-blocked overlay tips. Default ON. Off = no overlay tips even in first-time scenarios. |
| Settings → Onboarding → "Mark tutorial complete" (QA-only) | Debug build only. Force-flags `tutorial_complete`. |

---

## 4. Analytics events — full event taxonomy

All events fire to Firebase Analytics + GameAnalytics per HANDOVER §6 tooling stack.

| Event ID | Fires on | Properties |
|---|---|---|
| `tutorial_screen_<n>_seen` | Each tutorial screen load (n=1-10) | `screen_id`, `seconds_since_install` |
| `tutorial_cutscene_complete` | Screen 2 reaches frame 8 | `frames_skipped` (0-8) |
| `tutorial_cutscene_skipped` | Skip-cutscene button tapped | `frame_at_skip` |
| `tutorial_first_card_played` | Screen 4, on first valid card-drop | `card_id` |
| `tutorial_first_spell_cast` | Screen 4, on Self-Scourge resolve | — |
| `tutorial_first_combat_won` | Screen 4 combat end | `turns_taken`, `damage_dealt`, `damage_taken` |
| `tutorial_first_reward_picked` | Screen 5 | `card_id`, `position` (1/2/3) |
| `tutorial_warlord_swapped` | Screen 6, if player changed from Vyrrun | `from_warlord`, `to_warlord` |
| `tutorial_warlord_finalised` | Screen 6 "Begin Your Run" tap | `warlord_id`, `swap_count` |
| `tutorial_deck_card_inspected` | Screen 7, card tap-to-zoom | `card_id` (capped 12 events) |
| `tutorial_first_map_node_entered` | Screen 8 | `node_kind` (always COMBAT for round 1) |
| `tutorial_first_real_combat_started` | Screen 9 begin | — |
| `tutorial_first_real_combat_won` | Screen 9 victory | `turns_taken` |
| `tutorial_first_real_combat_lost` | Screen 9 defeat | `turns_taken`, `cause_of_death` |
| `tutorial_complete` | Screen 10 reward pick (the canonical "tutorial done" event) | `total_seconds_in_tutorial`, `skipped_segments`, `warlord_finalised`, `Vyrrun_kept` (bool) |
| `tutorial_skipped` | Screen 11 confirm-skip | `skipped_from_screen` (1-10) |
| `tutorial_replayed_from_settings` | Settings → Replay tutorial | `previous_complete` (bool) |

**Soft-launch funnel KPIs (built from these events):**
1. % installs that fire `tutorial_screen_1_seen` (should be ~100% — anything less = install corruption)
2. % installs that fire `tutorial_complete` (the headline "tutorial-completion rate ≥ 85%" KPI)
3. Drop-off curve: each `tutorial_screen_<n>_seen` count plotted; biggest drop reveals the broken step
4. `tutorial_first_combat_won` vs `tutorial_first_combat_started` ratio (should be ~99% — engine forces win; <99% = engine bug)
5. `tutorial_skipped` rate (should be <10% for new players, >40% for re-installs — anything outside that range = signal)

---

## 5. Forced-Vyrrun rationale

**Why Vyrrun and not another Warlord?**

| Warlord | Why considered | Why rejected |
|---|---|---|
| **Vyrrun (Iron Penitents Aggro)** | **Chosen.** Aggro fantasy ("hit hard, take risks") is most legible. Self-Scourge is a clean tutorial spell example. BLEED keyword is intuitive. | — |
| Sieren (Mourners Control) | Control fantasy is too cerebral for first-time | PERSIST is harder to explain in 25 sec |
| Eddra (Coven Swarm) | Token swarm is satisfying | Token economy is too noisy for tutorial |
| Veska (Last Legion Tempo) | Tempo is satisfying | RALLY needs 2 Host units adjacent — engine constraint |
| Mhar (Skinward Summoner) | Big units, slow ramp | First 3 turns are too slow; player loses interest |

Vyrrun's starter deck (`starter_decks_v0.md` §2.1) is also the most forgiving for round 1.

---

## 6. Edge cases + accessibility

### 6.1 Player force-closes the app mid-tutorial

Tutorial state is persisted at each `tutorial_screen_<n>_seen` event. On re-launch, player resumes from the last seen screen.

### 6.2 Player has poor connectivity (slow asset load)

Tutorial screens 1-3 use baked-in assets (no network calls). Screen 4 onwards needs combat scene loaded — show loading spinner if asset load >2 sec. Loading state fires `tutorial_loading_delayed` analytics event.

### 6.3 Player rotates device mid-tutorial

Game is portrait-locked per `interaction_touch_v0.md` §1. No rotation handling needed.

### 6.4 Player taps spam (accessibility — reduced touch sensitivity)

Each tap-blocked overlay tip waits for a clean tap (no rapid-fire). Tutorial advance buttons have 350ms debounce.

### 6.5 Accessibility — colour-blind, dyslexic, low-vision

- All 4 overlay tips use both colour highlight AND arrow indicator (not colour-only).
- Tutorial text uses IM Fell English (a serif but dyslexic-tested legible). Minimum 14pt at 1× density.
- Audio cues parallel every visual cue (sfx-card-drop-valid, sfx-card-summon-unit, etc).
- "Reduce motion" Settings toggle (per `interaction_touch_v0.md` §4) reduces cross-fade animations and disables the Hanging Hour full-screen tint pulse.

---

## 7. Engine handoff

### 7.1 Scene hierarchy

```
res://game/scenes/tutorial/tutorial_root.tscn
├── splash_screen.tscn (Screen 1)
├── cutscene_player.tscn (Screen 2)
├── tutorial_combat.tscn (Screens 3-4)
├── reward_pick.tscn (Screens 5, 10)
├── warlord_pick.tscn (Screen 6)
├── deck_view.tscn (Screen 7)
├── map_view.tscn (Screen 8 — same as runtime map view)
└── combat.tscn (Screen 9 — same as runtime combat)
```

### 7.2 State machine

`game/src/runtime/tutorial_state.gd`:
```gdscript
class_name TutorialState extends Resource

enum Step {
    SPLASH, CUTSCENE, TUTORIAL_FIGHT_INTRO, TUTORIAL_COMBAT,
    FIRST_REWARD, WARLORD_PICK, DECK_VIEW, MAP_ENTRY,
    FIRST_REAL_COMBAT, FIRST_REAL_REWARD, COMPLETE
}

@export var current_step: Step = Step.SPLASH
@export var first_seen_at: int = 0  # unix timestamp
@export var completed_at: int = -1
@export var skipped: bool = false
@export var skipped_from_step: Step = Step.SPLASH
@export var vyrrun_kept: bool = true
@export var screens_seen: Array[Step] = []
```

### 7.3 Save / persistence

Tutorial state persisted to `user://tutorial_state.cfg` after each step transition. Cleared on uninstall (no cloud sync needed — local only).

### 7.4 Analytics SDK hook

```gdscript
func _on_tutorial_step_changed(new_step: TutorialState.Step):
    Analytics.event("tutorial_screen_%d_seen" % new_step, {
        "seconds_since_install": Time.get_unix_time_from_system() - install_time
    })
```

### 7.5 Force-Vyrrun mechanism

`game/src/runtime/run_controller.gd` checks `TutorialState.current_step < Step.WARLORD_PICK`. If true, `force_warlord = "vyrrun"`. After WARLORD_PICK reached, that lock is released.

---

## 8. MVP coverage

| Milestone | Tutorial state |
|---|---|
| IMV-1 | Screens 1, 8, 9, 10 only (combat + map + reward — no cutscene, no overlay tips). Pure "can the player play". |
| IMV-2 | All 12 screens scaffolded. Overlay tips present. Analytics events fire. Skip available. |
| FCP | Iteration on tutorial copy + visuals based on IMV-2 internal playtest. |
| Soft launch | Full tutorial polish + cold-open cutscene with finalised art. |
| v1.0 | Adds voice-over narration on cutscene (if v1.1 voice-line budget approved). |

---

## 9. Open questions for Paul

1. **Forced-Vyrrun first run.** Recommend yes. Alternative: let player pick from all 5 free Warlords on first run (less linearity but harder to write tutorial copy). Confirm.
2. **Cutscene length.** 8 frames × 5 sec = 40 sec. Some studios go shorter (20-25 sec). Recommend keep 40 sec for tone-setting; iterate based on tutorial-completion telemetry. Confirm.
3. **Cutscene narration text.** §2 has placeholder text. Want it written tighter, more grimdark, or more accessible? Lock register before art is commissioned.
4. **Skip rate concern.** If skip rate >40% in soft-launch, redesign cutscene to be shorter OR move cutscene to "Story" tab instead of first-run. Reactive, not pre-emptive.
5. **Tutorial replay surface.** Settings → Replay tutorial is one entry point. Add a "Story" tab in Hub that shows the cutscene as content? Could be a v1.1 add.

---

## 10. Cross-references

- `GDD_v1.md` §8 — tutorial outline summary.
- `interaction_touch_v0.md` §5 — onboarding spec (superseded by this doc for first-run scope).
- `starter_decks_v0.md` §2.1 — Vyrrun starter deck used in tutorial combat.
- `monetisation_map.md` — no IAP on first-run rule.
- `2026-05-18_gallowfell_balance.md` — round 1 reward of +2 gems matches.
- `audio_direction_v0.md` + `audio_production_brief_v1.md` §8 — UI stings used in tutorial.
- HANDOVER.md §6 — Firebase Analytics + GameAnalytics tooling.

— Controller, 2026-05-22
