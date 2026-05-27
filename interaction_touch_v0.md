# Interaction & touch input v0 — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory items INT-1..INT-8. Mobile-first interaction spec — gesture taxonomy, conflict resolution, touch-target sizes, haptic contract, accessibility settings, pause/resume._

**Status:** v0 spec. Pure design doc — no engine work. Target platform iOS/Android (per HANDOVER §5).

---

## 1. Gesture set (INT-1)

| Gesture | Trigger | Timing | Intent |
|---|---|---|---|
| **Tap** | finger down → up within 200ms, < 8px movement | 0-200ms | "Select" — opens / equips / confirms |
| **Long-press** | finger down ≥ 350ms, < 8px movement | 350ms+ | "Inspect" — opens info modal |
| **Drag** | finger down → move > 8px → up at new pos | continuous | "Move" — drag card from hand to lane, drag-to-reorder |
| **Pinch (2-finger)** | 2 fingers separate or close | continuous | "Zoom" — map / collection only, NOT combat |
| **Swipe** | finger down → move ≥ 40px in <300ms | <300ms | "Navigate" — swap between detail panels |
| **Two-finger tap** | 2 fingers tap simultaneously | <200ms | "Reveal stats" — temporary HUD reveal |

### 1.1 Conflict resolution rules

Conflicts arise when one gesture starts and could become another (drag is initially a long-press, etc.). Locked rules:

1. **Tap vs Long-press:** finger-down starts a 350ms timer. If finger lifts before 350ms → Tap. If finger held ≥ 350ms with no movement → Long-press. If finger moves > 8px before 350ms → Drag.
2. **Tap vs Drag:** if finger moves > 8px at any point, intent commits to Drag — even if released within 200ms.
3. **Long-press during drag:** ignored. Drag commits.
4. **Swipe vs Tap:** if movement ≥ 40px AND release within 300ms, intent commits to Swipe (no Tap fires).
5. **Pinch vs Drag:** if 2nd finger touches during a drag, drag cancels, pinch takes over.
6. **Two-finger tap:** detected as "both fingers down within 50ms, both released within 200ms, neither moved > 8px". Reveals HUD stats overlay for 2 seconds.

### 1.2 Touch-target sizes (Apple HIG / Material Design compliance)

| Element | Minimum touch target (px @ 1× density) | Rationale |
|---|---|---|
| Card in hand | 64 × 96 | StS-equivalent; comfortable thumb reach |
| Lane drop zone | 320 × 240 (1/3 of screen width × 1/4 height) | Large drop targets reduce missed plays |
| Hub menu button | 48 × 48 | Apple HIG minimum |
| HUD icon (gem / HP / mana) | 44 × 44 | Apple HIG minimum |
| End-turn button | 80 × 56 | Frequent action; oversized |
| Settings cog | 48 × 48 | Apple HIG minimum |
| Modal close (X) | 48 × 48 | Apple HIG minimum |

All targets satisfy WCAG 2.5.5 (Target Size — 44 × 44 minimum).

---

## 2. Card-inspect modal (INT-2)

Long-press on any card-shaped UI element opens an Inspect modal.

### 2.1 Behaviour

- **Trigger:** long-press (≥ 350ms, < 8px movement) on a card in hand / collection / shop / reward
- **Animation:** card grows from origin to centred 80% screen size, 200ms ease-out
- **Treatment-aware:** modal renders the card with currently equipped treatment + alt-art + frame + sigil (per `variants_system_v0.md` §10.2 collection extensions)
- **Content:** large art + full rules text + keyword tooltips + flavour text (if any) + per-card mastery progress bar (per `upgrade_trees_v0.md` §3)
- **Dismiss:** tap-outside / swipe-down / back-button

### 2.2 Edge cases

- **Long-press during card-drag:** ignored. Drag commits per §1.1.4.
- **Long-press on opponent reveal card** (async boss-event): same modal but no edit-equip controls.
- **Long-press in combat:** opens modal, **does not pause combat** (turn-timer not implemented v1 anyway; this is for symmetry with future turn-timer mode).

---

## 3. Hand fan layout (INT-3)

Current implementation = HBoxContainer flat list (`hand_view.gd`). Replace with fanned arc layout for "this is a card game" identity.

### 3.1 Layout spec

- **Fan arc:** 60° total spread (30° each side of center), radius 800px (≈ 80% of screen height in portrait)
- **Per-card rotation:** linearly interpolated across the arc (max ±15° at edges)
- **Per-card vertical offset:** parabolic — center card sits ~20px higher than edges
- **Z-order:** center card on top, fanning outward (left edges behind, right edges behind)
- **Overlap:** each card covers ~40% of neighbour at 7-card max; less at smaller hand sizes

### 3.2 Per-hand-size adjustments

| Hand size | Arc spread | Per-card overlap |
|---|---|---|
| 1 | 0° | none (center) |
| 2-3 | 20° | 20% |
| 4-5 | 40° | 30% |
| 6-7 | 60° | 40% |
| 8+ (rare) | 60° clamped | up to 55%, hand "scrunches" |

### 3.3 Hover-extract animation

When tapped/long-pressed/picked-up-for-drag:
- Selected card scales 1.1×, rotates to 0° (upright), translates up 30px
- 150ms ease-out
- Neighbours fan out slightly (5° additional spread each direction) to make room
- On release/drag-end, card returns to fan position in 150ms

### 3.4 Drag-from-fan flow

1. Finger-down on card → 150ms hover animation begins
2. Finger moves > 8px → drag commits, card detaches from fan
3. Card visually "lifts" — drops shadow gains, card scales to 1.2×
4. Lane drop-zones highlight (green border)
5. Finger-up on lane → CardPlay.play_card per B2.6
6. Finger-up outside lane → card returns to fan with 200ms ease-back

### 3.5 Anti-misplay

- Lane drop-zone shows highlight color: green = playable, amber = un-affordable, red = invalid (e.g. unit on full lane).
- 50ms delay before commit on drop-zone leave (catches accidental release-during-drag).

---

## 4. Settings / options screen (INT-4)

Wireframe (ASCII):

```
+--------------------------------------+
| < BACK         SETTINGS          [X] |
+--------------------------------------+
| AUDIO                                 |
|   Music                  [====|----]  |
|   SFX                    [======|--]  |
|   Voice                  [===|-----]  |
|   Music on background      [ ON  ]    |
+--------------------------------------+
| HAPTICS                               |
|   Haptic feedback          [ ON  ]    |
|   Strength               [===|-----]  |
+--------------------------------------+
| GRAPHICS                              |
|   Quality            [Low/Med/High]   |
|   Animated treatments      [ ON  ]    |
|   Reduce motion (a11y)     [ OFF ]    |
|   Battery saver mode       [ AUTO ]   |
+--------------------------------------+
| GAMEPLAY                              |
|   Confirm-before-play      [ OFF ]    |
|   Auto-end turn             [ OFF ]   |
|   Hold-to-inspect timer  [350ms ▼]   |
+--------------------------------------+
| LANGUAGE                              |
|   English (UK) ▼                      |
+--------------------------------------+
| ACCESSIBILITY                         |
|   Large text               [ OFF ]    |
|   High contrast            [ OFF ]    |
|   Colorblind mode    [None/D/P/T▼]   |
|   Screen reader hints      [ AUTO ]   |
+--------------------------------------+
| ACCOUNT                               |
|   Sign in / Restore purchases         |
|   Monthly spend cap   [Unlimited▼]    |
|   Clear local cache                   |
|   Sign out                            |
+--------------------------------------+
| LEGAL                                 |
|   Privacy / Terms / Licenses          |
+--------------------------------------+
| VERSION                               |
|   v0.4.0 (build 412)                  |
+--------------------------------------+
```

### 4.1 Default values

| Setting | Default |
|---|---|
| Music | 60% |
| SFX | 80% |
| Voice | 50% |
| Music on background | OFF |
| Haptic feedback | ON |
| Haptic strength | 70% |
| Quality | AUTO-detect (Low for <2GB RAM, Med for 2-4GB, High for 4GB+) |
| Animated treatments | ON |
| Reduce motion | OFF (auto-ON if OS-level reduce-motion flag set) |
| Battery saver | AUTO (kicks in at <20% battery) |
| Confirm-before-play | OFF |
| Auto-end turn | OFF |
| Hold-to-inspect timer | 350ms |
| Language | OS-locale auto-detect |
| Monthly spend cap | per `shop_economy_v0.md` §6 (region default) |

### 4.2 Persistence

All settings persist in local save (per `shop_economy_v0.md` §7.4 save format). Account-sync optional (Apple iCloud / Google Play Games).

---

## 5. Tutorial / onboarding (INT-5)

### 5.1 First-run flow

| Screen | Content | Length |
|---|---|---|
| Title splash | "The Curse of Gallowfell" logo, single tap-to-continue | tap |
| Lore prologue | 4-line narrated curse intro with parallax painterly background | ~12s, skippable on second tap |
| Warlord-pick (forced Vyrrun) | "Choose your Warlord — the curse remembers them all" + Vyrrun card auto-selected | tap |
| Tutorial combat 1 | 3-wave easy combat; overlay tips fire at: turn 1 (drag card), turn 2 (lane choice), end-of-turn (button highlight), reward screen | ~3 min |
| Tutorial combat 2 | Slightly harder; overlay tips fire at: BLEED keyword (status decay), boss-style encounter (Hanging Hour preview), HP at 50% (mana ramp) | ~4 min |
| Map intro (post combat 2) | "8 rounds. The curse waits at the gallows." brief map highlight | ~5s |
| First real run | Hands off — player drives | indefinite |

### 5.2 Tutorial overlay tip mechanics

- Overlay = semi-transparent dim background + spotlight on target UI element + 1-line tip in bottom card
- Tap-anywhere dismisses
- Tips: stored in `tutorial_state.gd` — `tips_dismissed: Array[StringName]`
- Re-trigger: Settings > Gameplay > "Replay tutorial tips" toggle

### 5.3 Skip path

- "Skip tutorial" button visible top-right on every tutorial screen
- Single confirmation modal: "Skip? You can replay any time in Settings."
- Skips both combats but seeds the run with the same starting deck/Warlord

### 5.4 D0 → D1 retention design

Per HANDOVER §5 and `monetisation_map.md` § Day-2 starter bundle: D0 onboarding length budget = max 15 minutes for a complete-from-launch-to-first-real-run. Tutorial split-test recommended (2-combat vs 1-combat) post-launch.

---

## 6. Pause / interrupt / resume (INT-6)

### 6.1 Trigger states

| Trigger | Engine response |
|---|---|
| OS-level app suspend (NOTIFICATION_APPLICATION_PAUSED) | Serialise combat state to `mid_combat_save.json`, pause music |
| Incoming phone call (iOS / Android) | Same as suspend |
| User taps in-game Pause button (HUD top-left) | Open Pause modal — Resume / Settings / Abandon Run |
| Network state change | (info-only; no engine pause — game is offline) |

### 6.2 Mid-combat save format

```
mid_combat_save.json:
{
  "active": true,
  "run_id": "run_20260521_xxx",
  "combat_state": {
    "turn": 3,
    "mana_current": 4,
    "mana_max": 5,
    "lanes": [...],  # serialised UnitInstance arrays
    "enemies": [...],
    "smoke_tiles": [...],
    "hand": [...],
    "deck": [...],
    "discard": [...],
    "pending_persists": [...]
  },
  "warlord_id": "vyrrun",
  "node_id": "ch1_node_3",
  "saved_unix": 1735776000
}
```

### 6.3 Resume flow

On app foreground:
1. Detect `mid_combat_save.active == true`
2. Show modal: "Combat in progress — Resume / Restart combat / Abandon run"
3. **Resume:** load save, restore Combat scene, position UI to mid-state, do NOT auto-advance turn
4. **Restart combat:** reset Combat to turn 1, opening hand 5 (deck loses 5-card lead but stays content-equivalent)
5. **Abandon run:** end_run(false), routes to GameOver / Map per existing logic

### 6.4 Auto-cleanup

- `mid_combat_save.json` cleared on natural combat resolution (win/lose) and on run end.
- Save older than 7 days = auto-cleared on app launch (stale-save protection).

---

## 7. HUD persistent — gem tap-target (INT-7)

### 7.1 HUD layout (per `2026-05-18_gallowfell_balance.md` §"Visual feedback")

```
[💎 17][HP 28/45][Mana 4/5][Next 5][Turn 3][Vyrrun]
```

### 7.2 Tap behaviours

| HUD element | Tap action | Long-press action |
|---|---|---|
| 💎 gem | Open storefront §"Gem Packs" (per `shop_economy_v0.md` §2) | Tooltip: "Earned in runs + retries cost gems. Tap for store." |
| HP | (no action) | Tooltip: "Your soul. The curse takes you at 0." |
| Mana | (no action) | Tooltip: "Spent on cards. +1 per turn, max 8." |
| Next | (no action) | Tooltip: "Mana at start of next turn." |
| Turn | (no action) | Tooltip: "Current combat turn. Hanging Hour at turn 5." |
| Vyrrun | Open Warlord-detail modal (per `warlord_select_ui_v0.md` Screen B) | (none) |

### 7.3 Pause / Settings buttons

```
[⏸] Pause   (top-left)
[⚙] Settings (top-right)
```

- Both 48×48 px, 16px from edges, 8px padding.

---

## 8. Haptic feedback contract (INT-8)

Per-event haptic strength definitions. Implementation = `Input.vibrate_handheld(duration_ms)` (Android) and Core Haptics (iOS via GDExtension wrapper).

### 8.1 Event table

| Event | Haptic pattern | Strength |
|---|---|---|
| Card-play (drop on lane) | single tick | light (20ms) |
| Unit summoned (visual confirmation) | single tap | light (15ms) |
| Spell cast | single tap | light (20ms) |
| Trap triggered | double tap | medium (15ms × 2, 30ms gap) |
| Enemy damage dealt (player attacks enemy) | single tap | light (10ms) |
| Player damage taken | single bump | medium (30ms) |
| Unit death (friendly) | double bump | medium (25ms × 2, 50ms gap) |
| Unit death (enemy) | single tap | light (15ms) |
| BLEED/POISON tick (enemy) | single soft tap | light (5ms) |
| BLEED/POISON tick (player base HP) | medium bump | medium (20ms) |
| Hanging Hour trigger | heavy double-pulse | heavy (100ms × 2, 100ms gap) |
| Boss kill | success pattern | heavy (50ms) + medium (50ms after 100ms) + light (30ms after 50ms) |
| Run defeat | failure pattern | heavy (200ms) sustained |
| Run victory | celebration pattern | heavy + medium + light × 4 ascending |
| Card draw | (no haptic — would be too constant) | — |
| End-turn button press | UI confirm tap | light (15ms) |
| Modal open/dismiss | UI confirm tap | light (15ms) |
| Treatment unlock / collection event | medium triple-tap | medium ×3 |
| IAP purchase complete | celebration medium | medium (40ms) ×3 ascending |

### 8.2 Settings strength scaling

Settings haptic strength slider scales ALL events by % multiplier (0% = haptics off, 100% = spec values, 70% = 0.7× duration).

### 8.3 Power-budget

- Haptics on mobile = ~5% battery per hour active use. Confirm in QA.
- Battery-saver mode (per §4.1 "Battery saver") = haptics auto-disabled when battery < 20% or charging-disconnected sustained.

---

## 9. Accessibility (a11y) summary

Per Settings §4:

- **Large text:** 1.25× UI font scale. Affects HUD, modal text, card text, menu labels.
- **High contrast:** removes faction-tinted backgrounds, uses solid black + white + warning yellow for status text.
- **Colorblind mode** (D=Deuteranopia, P=Protanopia, T=Tritanopia): swaps status-overlay colors to colorblind-safe palette.
- **Screen reader hints:** AUTO detects if iOS VoiceOver / Android TalkBack is active and emits semantic labels for every UI element.
- **Reduce motion:** disables animated treatments (Prism / Cursed / Ultimate go static), disables card-fan animation, disables Hanging Hour full-screen flash (replaces with text banner only).

---

## 10. Cross-references

- `2026-05-18_gallowfell_balance.md` — HUD layout and current UI elements.
- `collection_ui_v0.md` — Collection UI long-press behaviour reference.
- `warlord_select_ui_v0.md` — Warlord-select UI tap targets.
- `gameplay_keywords_resolution_v0.md` — keyword effects that drive haptic events (BLEED tick, Hanging Hour).
- `variants_system_v0.md` — treatment-aware Inspect modal rendering.

— Controller, 2026-05-21
