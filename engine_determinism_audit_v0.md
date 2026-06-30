# Engine determinism audit — v0

**Status:** v0 audit landed 2026-05-28 by Cowork Claude per Phase 2.17 AC7 (backlog) + `pvp_design_v0.md` §3.1.
**Scope:** every `randi`/`randf`/`randomize`/`RandomNumberGenerator`/`.shuffle()` call in `game/src/`. Production code classified into one of three buckets; tests excluded from the determinism contract (they don't run in shipped builds).
**Verdict:** **GREEN — the engine is PvP-determinism-ready by design.** Zero ambient-global call sites in production. Two `needs-seeding-for-PvP` sites, both at the natural entry points where a PvP match server would inject its own seed. No remediation work blocked behind this — the PvP-1 build can proceed against the existing surface.

---

## Bucket 1 — SAFE (seeded RNG threaded through state)

These call sites take a `RandomNumberGenerator` as parameter or operate on a member RNG that was seeded explicitly. Output is deterministic given the seed; nothing further to do for PvP.

| File:line | Call | Notes |
|---|---|---|
| `deck.gd:18` | `var rng: RandomNumberGenerator = RandomNumberGenerator.new()` | Per-Deck member RNG. |
| `deck.gd:28` | `rng.seed = seed_value` | Seeded path — caller passes seed. |
| `deck.gd:52` | `var j := rng.randi_range(0, i)` | Fisher–Yates shuffle using the seeded member RNG. |
| `e2e_smoke_test.gd:148–149` | `reward_rng = RandomNumberGenerator.new(); reward_rng.seed = GameState.run_seed ^ 0xC0FFEE` | Smoke-test path; seeded off `run_seed` with constant XOR salt. Deterministic. |
| `map_generator.gd:36–37` | `var rng := RandomNumberGenerator.new(); rng.seed = seed_value ^ (chapter * _MULT_KNUTH)` | Map gen RNG, seeded from passed `seed_value` with Knuth multiplicative hash for chapter offset. |
| `map_node.gd:35–39` | `func make_rng(run_seed: int) -> RandomNumberGenerator: ... rng.seed = run_seed ^ (seed_offset * 2654435761)` | Per-node RNG factory. Each MapNode derives a deterministic seed from `run_seed` + `seed_offset` via Knuth hash. **Excellent pattern** — copy this for PvP per-turn RNG. |
| `reward_generator.gd:67, 115, 196` | `func ... (rng: RandomNumberGenerator, ...)` | All reward-gen entry points take RNG as a parameter — fully threaded. |
| `reward_generator.gd:203` | `var roll: float = rng.randf() * total` | Weighted pick uses passed RNG. |

---

## Bucket 2 — NEEDS-SEEDING-FOR-PvP

These sites use ambient/global `randi()` or `randomize()` as a fallback. In PvE they're harmless / desired (variety per run). In PvP they MUST be replaced with a deterministic seed injection — usually from the PvP match server. **Both are entry-point shaped**, meaning the injection is one-line and natural.

| File:line | Call | PvE semantics | PvP remediation |
|---|---|---|---|
| `game_state.gd:195` | `run_seed = seed_value if seed_value != 0 else randi()` | If no seed passed at run start, generate one from global RNG. Fine for PvE — each fresh run gets a different RNG. | In PvP, `GameState.start_run()` is called with a seed **received from the match server / committed by both players**. Pass non-zero `seed_value` — the `else randi()` branch never fires. **One-line change in the PvP run controller; engine code unchanged.** |
| `deck.gd:30` | `rng.randomize()` | If `set_seed(0)` called or seed not set, randomize the deck's RNG from the global entropy source. | In PvP, the deck is constructed via the deckbuilder + initialised with `set_seed(run_seed XOR <player-index>)` or equivalent. The `randomize()` fallback should not be hit. **Optional hardening:** add an `assert(seed_set)` in deck initialisation under a PvP-mode flag to catch silent fallthrough. |

---

## Bucket 3 — AMBIENT-GLOBAL MUST-REMEDIATE

**NONE.** No production code calls `randi()` / `randf()` / `randomize()` mid-frame on the global RNG.

---

## Tests — excluded from contract (informational)

These are dev-test files that call shuffle/RNG directly. They don't run in production builds, so don't gate PvP determinism. Listed for completeness:

- `card_zones_test.gd:40, 117, 118` — `deck.shuffle()` calls on test decks (each test seeds its own deck via `set_seed`).
- `map_test.gd:143, 150` — `rng.randi()` on test RNGs (each seeded explicitly with `12345`).
- `reward_test.gd:57–123+` — multiple `rng.seed = N` test fixtures.

---

## Float-arithmetic determinism

`pvp_design_v0.md` §3.1 flagged float ops as a secondary concern. Current engine usage:

- `reward_generator.gd:203` `var roll: float = rng.randf() * total` — single float multiplication on a per-call basis; result is deterministic given identical input (GDScript / C++ floats are IEEE 754).
- `_attack_range_to_tiles` and target-picking are pure `int` math (verified by inspection of `turn_engine.gd`).
- No `tan`/`sin`/`cos`/`pow` in hot paths.

**Verdict:** float determinism is not a current risk surface. Re-audit if any future card effect uses transcendentals.

---

## Recommendations for PvP-1 build

1. **Reuse `map_node.gd::make_rng()`'s pattern** for per-turn RNG in PvP. Each turn N derives `rng.seed = match_seed XOR (turn_num * 2654435761)`. Both clients land on identical RNG state without server round-trips per turn.
2. **Add `GameState.start_run(seed_value)` enforcement under a PvP-mode flag** — `assert(seed_value != 0)` to catch the `randi()` fallthrough at compile-time of intent rather than runtime drift.
3. **`Deck.set_seed()` similar enforcement.** Optional; the entry-point seed in `start_run` already covers the cascade.
4. **No engine refactor needed.** The architecture decision to keep `turn_engine` static + thread RNG through `Lane` / `RewardGenerator` paid off here — PvP-1 can build against the existing surface without touching the hot engine code Controller is currently editing.

---

## What this audit does NOT do

- Doesn't remediate Bucket 2 (those are PvP-1 build steps, not separately scheduled).
- Doesn't cover ENEMY AI / wave-spawn RNG — those are in PvE-only paths and irrelevant to PvP.
- Doesn't cover network-layer determinism (match-state hashing, anti-cheat) — that's `pvp_design_v0.md` §3.2 authority model, not this audit.

---

_Audit complete. Engine is greener than expected for PvP determinism — credit to whoever architected the static-functions-over-Lane pattern (turn_engine.gd authors / Controller cycles). Phase 2.17 AC7 closed._
