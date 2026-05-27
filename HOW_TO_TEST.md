# How to test The Curse of Gallowfell — IMV-1 playable build

**Authored 2026-05-18 by Controller.** Drops the missing UI scenes so the engine can be run as a clickable game. Engine work (B2.5-B2.10) was already complete — this PR fills in the screens that wire them into a playable loop.

## Quick start (5 min)

1. **Install Godot 4.6 Mobile** if not already — https://godotengine.org/download
2. Open Godot → **Import** → point at `Gaming app/game/project.godot`.
3. Press **F5** (run main scene). The new `run_controller.tscn` is the entry point.
4. You should see a **Title screen** with 3 Warlord buttons (Vyrrun / Vey / Quag).
5. Pick one → **Map screen** with 5 nodes (Chapter 1 prototype layout).
6. Click a reachable node:
   - **COMBAT / ELITE / BOSS** → Combat scene loads with 5 cards in hand.
   - **EVENT / SHOP / SHRINE** → auto-resolves in IMV-1 (logged to console) → reward.
7. In Combat: drag a card to a lane to play it. Mana cost / hand→discard works.
   **Placeholder end-of-combat:** press **C** to declare victory, **X** to declare defeat (until real wave-end detection lands).
8. On victory → **Reward screen** with 3 cards. Pick one or **Skip**.
9. Returns to Map → pick next node → repeat → reach Boss or die.
10. **Game-over screen** shows result + Run again button.

## What this build delivers (IMV-1 gate)

Paul's 2 May validation gate: "all 5 must be true" — draft choice matters, sub-archetypes distinct, counter-play, deaths informative, one-more-run pull.

This build now lets you actually walk the loop end-to-end with placeholder visuals. Whether the 5 criteria are met is what the playtest evaluates.

## New files (this PR)

```
src/ui/map_view.gd            173 lines — chapter map rendering + node clicks
src/ui/reward_view.gd         205 lines — 3-card pick screen
src/ui/title.gd               123 lines — Warlord-pick start screen
src/ui/game_over.gd            45 lines — win/lose screen with restart
src/runtime/run_controller.gd 183 lines — top-level scene orchestrator

scenes/map_view.tscn
scenes/reward_view.tscn
scenes/title.tscn
scenes/game_over.tscn
scenes/run_controller.tscn

data/warlords/vyrrun.tres     Penance-Captain Vyrrun (Iron Penitents)
data/warlords/vey.tres        Lord-Justiciar Vey (Ash-Mourners)
data/warlords/quag.tres       Mother Quag (Coven)
```

**project.godot** updated: `main_scene` now points to `run_controller.tscn` (was `main.tscn`).

## Still using the test suite

The old test-runner entry still works — just open `scenes/main.tscn` in the editor and press **F6** (run from scene). All 9 dev tests + e2e smoke fire to the console. Useful for regression checks.

## Known IMV-1 limitations

- **Combat end is keyboard-stubbed.** No real wave-clear detection yet. Press C (win) or X (lose) to advance. When the wave-spawner / combat-end signal lands, the controller already has the wire-up — just remove the keyboard fallback.
- **EVENT / SHOP / SHRINE / REST nodes auto-skip to reward.** Engine has these phases reserved (GFEnums.RunPhase), but no UI yet. M8 narrative-event content exists in `events_v0.md` — wiring is M8.E1.
- **Chapter 2+ clones chapter 1.** Per the map_generator comment — placeholder until real layouts land.
- **No art.** Coloured shapes + text labels. AI art pipeline (B3) deferred to IMV-2.
- **No SFX.** Silent until B2.11 audio pass.
- **Starter deck is random 12-card slice.** Warlord-locked starter decks land in IMV-2 alongside the Warlord tier system (Phase 2.7 W1-W5).

## How to debug if something breaks

1. Open Godot's **Output** panel (Window menu) — most things log there with a `[run_controller]` / `[title]` / `[map_view]` prefix.
2. Common gotcha: **uid collisions**. The new .tscn files use `uid://gallowfell_*` names. If Godot complains, delete the matching `<uuid>.uid` files from `.godot/imported/` and reopen.
3. **GameState autoload errors**: ensure `project.godot` has the `[autoload]` block intact — GameState must be `"*res://src/runtime/game_state.gd"` (star = singleton).
4. **Map renders but nothing's clickable**: check console for `[run_controller] illegal node jump` — means a wiring bug between map → controller. Re-paste the scene to refresh.

## What to feed back

Paul, as you play:

1. Does picking a card actually feel like a choice (not always obvious)?
2. Do the 3 factions feel mechanically distinct in the first 3-4 fights?
3. When you lose, can you articulate why in one sentence?
4. Did you immediately want to try again with a different Warlord/path?
5. Anything that broke / crashed / felt unresponsive — note the console output.

Drop notes into `Controller project./gallowfell_playtest_<date>.md` or just message Controller via chat. Controller will route to the .151 / Claude Code instance that owns engine work next, or queue it directly.

## File-tree after this PR

```
Gaming app/
├─ game/
│  ├─ project.godot                     ← main_scene = run_controller.tscn
│  ├─ scenes/
│  │  ├─ run_controller.tscn            NEW (entry point)
│  │  ├─ title.tscn                     NEW
│  │  ├─ map_view.tscn                  NEW
│  │  ├─ reward_view.tscn               NEW
│  │  ├─ game_over.tscn                 NEW
│  │  ├─ main.tscn                      (still works for dev tests)
│  │  ├─ combat.tscn                    (existing)
│  │  ├─ hand_view.tscn                 (existing)
│  │  ├─ card_view.tscn                 (existing)
│  │  └─ sandbox.tscn                   (existing)
│  ├─ src/
│  │  ├─ main.gd                        (test runner)
│  │  ├─ runtime/
│  │  │  ├─ run_controller.gd           NEW
│  │  │  └─ ...existing engine files
│  │  └─ ui/
│  │     ├─ map_view.gd                 NEW
│  │     ├─ reward_view.gd              NEW
│  │     ├─ title.gd                    NEW
│  │     ├─ game_over.gd                NEW
│  │     └─ ...existing hand_view/card_view
│  └─ data/
│     ├─ warlords/                      NEW folder
│     │  ├─ vyrrun.tres
│     │  ├─ vey.tres
│     │  └─ quag.tres
│     └─ cards/, enemies/, waves/, treatments/  (existing)
└─ HOW_TO_TEST.md                       NEW (this file)
```

— Controller, 2026-05-18T18:50Z
