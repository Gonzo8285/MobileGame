# Gallowfell test framework

Two headless suites, both runnable from the command line and wired into CI
(`.github/workflows/tests.yml`).

## Quick start

```bash
# from the project root (folder with project.godot)
godot --headless --editor --quit                       # one-time import
godot --headless res://tests/test_main.tscn            # unit/integration — exit 0 = pass
godot --headless res://tests/sim/run_sim.tscn -- --runs 200   # balance sim
```

`test_main` exits non-zero if any assertion fails, so CI (and a pre-push hook)
can gate on it. The sim writes `tests/sim/reports/sim_report.{md,json}`.

## Layout

```
tests/
  framework/
    test_case.gd     GFTest — base class + assert_* library
    test_runner.gd   GFTestRunner — discovers suites, runs test_* methods, exit code
    factory.gd       GFFactory — deterministic in-code cards/enemies/waves for tests
  suites/            one file per area; drop a new GFTest here and it's auto-discovered
    test_card_data.gd     every .tres loads + validates, unique ids, starter pool
    test_deck.gd          draw / shuffle-determinism / mill / reshuffle
    test_game_state.gd    run+combat lifecycle, mana, HP, lethal
    test_card_play.gd     CardPlay validation + unit placement
    test_combat_flow.gd   integration: waves through Combat (spawn/advance/win/lose)
  sim/
    ai_policy.gd       GFAIPolicy — scripted play decisions (swap to A/B strategies)
    combat_resolver.gd GFCombatResolver — see caveat below
    simulator.gd       GFSimulator — plays whole runs, aggregates telemetry
    run_sim.gd/.tscn   headless entry + markdown/JSON report writer
    reports/           generated output
  test_main.gd/.tscn   headless entry for the suites
```

## Writing a test

```gdscript
extends GFTest

func test_two_plus_two() -> void:
    assert_eq(2 + 2, 4, "maths still works")
```

Name methods `test_*`; the runner finds them. Optional `before_each` /
`after_each` / `before_all` / `after_all` hooks. Integration suites that need a
node in the tree can use `host.add_child(node)` (the runner sets `host`).

Note: this project treats GDScript warnings as errors, so keep declarations
strictly typed (no `:=` inference from a `Variant`-returning call).

## ⚠️ Balance resolver caveat

The live engine (B2.6) spawns/advances enemies and routes base damage, but the
unit↔enemy attack exchange (B2.7) is **not built yet**. So the simulator can
produce win/loss + per-card damage today, `sim/combat_resolver.gd` implements a
minimal, documented stand-in. Treat sim numbers as **relative** (card-vs-card,
and regression tracking run-to-run) not absolute. When B2.7 lands, replace the
body of `GFCombatResolver.resolve_turn()` with a call into the real engine —
the simulator and telemetry keys stay the same.
