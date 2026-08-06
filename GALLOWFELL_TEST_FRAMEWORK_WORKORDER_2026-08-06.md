# Gallowfell — Test Framework handoff + testing work order
**Date:** 2026-08-06 · **From:** Controller · **To:** ff-151 (repurposed to Gallowfell testing while FastForward awaits JSM sign-off)

## What's already built (validated green on Godot 4.3 headless)
A full headless test framework now lives in the project at
`the-curse-of-gallowfell-(4.3)/tests/` + CI at `.github/workflows/tests.yml`.

Run it:
```
godot --headless --editor --quit                       # one-time import
godot --headless res://tests/test_main.tscn            # suites — exit 0 = pass
godot --headless res://tests/sim/run_sim.tscn -- --runs 200   # balance sim
```

Current status (Controller-validated):
- **Unit/integration suites: 5 suites, 22 tests, 169 assertions, all PASS, exit 0.**
  Covers card/enemy .tres validation, Deck (draw/shuffle-determinism/mill/reshuffle),
  GameState lifecycle+mana+HP, CardPlay validation+placement, and a Combat
  integration suite (spawn/advance/base-damage/victory/defeat through the real
  Combat node).
- **Balance simulator: 200-run baseline = 21% win-rate**, per-card damage/kills/
  play-rate telemetry, markdown+JSON report in `tests/sim/reports/`.
- Runner auto-discovers any `GFTest` suite dropped in `tests/suites/`.

## ⚠️ Read these two things first
1. **Warnings are errors** in this project — all test code is strictly typed
   (no `:=` inference from a `Variant`-returning call). Keep new tests the same.
2. **The sim's combat resolver is a B2.7 stand-in.** The live engine doesn't yet
   resolve unit↔enemy attacks (that's B2.7). `tests/sim/combat_resolver.gd`
   models a minimal exchange so the sim produces outcomes today. Sim numbers are
   RELATIVE (card-vs-card / regression), not absolute.

## Your backlog (work top-down; each is independent)
1. **Confirm on the VM's engine.** Project targets 4.x/Mobile; I validated on
   4.3-stable. Run the two commands above on your Godot build; if it's 4.6, bump
   `GODOT_VERSION` in `.github/workflows/tests.yml` and confirm still-green.
2. **Commit to git.** Add `tests/` + `.github/` to the Gallowfell repo on a
   branch → PR. (Controller needs the repo remote/PAT confirmed — flagged to Paul.)
3. **Widen coverage** — these units have no direct suite yet: `lane.gd`,
   `hand.gd` (mulligan + overflow/burn), `discard.gd` (find/remove/reshuffle),
   `wave_spawner.gd` (schedule + is_complete), `enemy_instance.gd` /
   `unit_instance.gd` (damage/armor/cooldown). One `GFTest` file each.
4. **Golden content test.** Assert every card ID in `cards_v0.md` spec has a
   matching `.tres` (catches missing/renamed cards).
5. **When B2.7 lands:** replace the body of `GFCombatResolver.resolve_turn()`
   with a call into the real attack engine — telemetry keys stay identical.
6. **Grow the sim:** load real `data/waves/*.tres`, add 2–3 alternative
   `GFAIPolicy` strategies for A/B win-rate comparison, break telemetry out
   per-faction, and add a mana-curve sweep.

## Optional (additive, low-risk)
`combat.gd` is the only runtime script without a `class_name` — tests reference
it via `preload`. Adding `class_name Combat` would let tests type it directly.
Your call.

## Rules of engagement (unchanged)
- All software → Git; all data/backups → G drive.
- No hard stops without a rollback target.
- Report against real run output (exit codes / report file), never "should pass".
