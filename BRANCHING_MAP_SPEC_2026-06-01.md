# Gallowfell — Branching map + encounter variance: build-ready spec (2026-06-01)

_Authored by Controller for the Claude Code session. **Supersedes the IMV-1 linear-gauntlet design call**
(Paul rethink 2026-06-01: linear felt bland / un-immersive). Grounds on live code: `map_node.gd`,
`map_graph.gd` (branching already supported: children/depth/reachability), `map_generator.gd` (only the
linear generator is wired), `wave_generator.gd` (`for_round(round, kind, seed)`), `enemy.gd`,
`map_view.gd` (already styles all 8 node-kind symbols), `run_controller.gd`._

Three things Paul asked for: **(1) multiple possible journeys** (branching routes), **(2) variance in
enemies AND tactics**, **(3) those variances shown by different symbols**. The engine already does the
graph + the node-kind symbols; the new idea below is **Encounter Archetypes** — the enemy/tactic variety,
each with its own glyph.

---

## 1. The map shape — branching, Slay-the-Spire style

Replace the linear 8-pip strip with a **layered DAG**, deterministic per `(chapter, seed)`:

- **Depth 0:** single START node.
- **Depths 1..N-1:** a *row* of 2–4 nodes; each node links forward to 1–2 nodes on the next depth
  (edges may cross/converge; no orphans — every node reachable from START and able to reach BOSS, which
  `map_graph.validate()` already checks).
- **Final depth:** single BOSS node (all paths converge).
- **Default chapter size:** `DEPTHS = 12`, `WIDTH = 2..4` (tunable consts). A run = ~9–11 nodes traversed
  out of ~28 placed, so two playthroughs of the same chapter feel different → the "multiple journeys".

**Node-kind distribution per chapter** (rules, not fixed slots — rolled from seed):
- Depth 1 always COMBAT (gentle on-ramp).
- ~55% COMBAT, ~12% ELITE, ~10% EVENT, ~8% SHOP, ~8% REST, ~7% SHRINE across the middle depths.
- At least one REST and one SHOP reachable on *every* path before the boss (path-aware placement).
- A guaranteed ELITE "gate" around depth 7–8. BOSS terminal.
- `EVENT/SHOP/SHRINE/REST` already have symbols in `map_view`; at v0 they **auto-resolve** (existing
  run_controller stub) so the route variety lands now and the real interactions are a follow-on (§7).

Keep `_generate_linear_8_round` as `generate_linear()` for engine tests/back-compat; make
`generate()` call the new `generate_branching()`.

## 2. Encounter Archetypes — the enemy + tactic variance (the new core)

Each COMBAT / ELITE / HORDE node carries an `encounter_id` (new field on `MapNode`). An archetype defines
**who you fight and how they behave**, and **a symbol** so the player reads it on the map and tunes their
deck. New `src/data/encounter_archetype.gd` (Resource) + a catalog (static table or `.tres` set):

```gdscript
extends Resource
class_name EncounterArchetype
@export var id: StringName = &""
@export var display_name: String = ""        ## telegraph label, e.g. "Plague Swarm"
@export var symbol: String = ""              ## map glyph (unicode v0; icon art in B3)
@export var blurb: String = ""               ## one line shown on tap: how it plays
@export var density: int = 0                 ## enemy count bias (-1 few / 0 normal / +1 many)
@export var hp_bias: float = 1.0             ## stat multipliers layered on round scaling
@export var atk_bias: float = 1.0
@export var move_bias: int = 0               ## faster/slower advance
@export var emphasise_keywords: Array[GFEnums.Keyword] = []   ## tactic = enemy keyword bias
@export var prefer_faction: GFEnums.Faction = GFEnums.Faction.NEUTRAL  ## enemy flavour when roster allows
```

**v0 catalog (7 archetypes — distinct enemies + tactics + symbol):**

| id | Name | Symbol | Enemies / tactic | Counter-play it rewards |
|----|------|:------:|------------------|--------------------------|
| `swarm` | Brood Swarm | `∴` | many weak, fast, low HP (density +1, hp ↓, move +1) | AoE / Cleave, lane control |
| `bruisers` | Iron Vanguard | `▰` | few, high HP + armor, slow (density −1, hp ↑↑, armor) | Pierce, focus-fire, big hits |
| `plague` | Plague Tide | `☣` | POISON/BLEED DoT carriers, medium (emphasise POISON, BLEED) | burst before stacks, healing |
| `volley` | Ranged Volley | `»` | back-line ranged attackers (range bias, atk ↑) | rush the line, Taunt/Shield |
| `ambush` | Flanking Ambush | `↯` | fast flankers, burst, spread lanes (move +1, density 0) | board presence, anti-rush |
| `summoners` | Wretch-Callers | `⊛` | SUMMON adds each turn (emphasise SUMMON) | kill the source, tempo |
| `dread` | Dread Procession | `◓` | FEAR/SMOKE/SLOW debuffers (emphasise FEAR, SMOKE, SLOW) | resilient units, go wide |

Works with the current 5 base enemies (E1–E5) by biasing composition + overlaying `emphasise_keywords`
and stat biases; as the enemy roster grows (the `bosses_chapters_*` docs already design more), `prefer_faction`
and richer pools slot in with no API change. ELITE nodes use an archetype + the existing elite stat gate;
BOSS keeps its own builder.

## 3. Symbols on the map (what Paul asked to see)

`map_view` already maps node KINDS → glyphs (⚔ ⚔⚔ ✦✦✦ ☠ ? $ △ z). Extend so a COMBAT/ELITE/HORDE node
shows its **encounter symbol** (from §2) instead of the generic ⚔ — e.g. a node reads `☣` (Plague Tide)
or `▰` (Iron Vanguard). Tapping a reachable node shows its `display_name` + `blurb` ("Poison-heavy, many
weak — bring burst or healing") **before** the player commits, so route choice is informed. Add a small
**legend** toggle listing every symbol. (Unicode glyphs at v0; swap for icon art in the B3 pass.)

## 4. Data + generator wiring
- **`MapNode`:** add `encounter_id: StringName = &""` (+ include in `describe()`).
- **`MapGenerator.generate_branching(chapter, seed)`:** build the layered DAG (§1), assign kinds by the
  distribution rules, then assign an `encounter_id` to each combat-type node — *vary along each path* so a
  single route hits several different archetypes (track recent picks per path, avoid repeats).
- **`WaveGenerator.for_node(node, run_seed)`:** new entry point. Reads `node.kind` + `node.encounter_id`,
  looks up the archetype, applies density/stat/keyword/move biases on top of the existing round scaling,
  then builds spawns. Keep `for_round` as a thin shim (`for_node` is the real path).
- **`run_controller`:** on entering a combat node call `WaveGenerator.for_node(cur_node, seed)`; traversal
  picks among `map_graph.get_children(current)` (the reachable set) per the player's tap.

## 5. Determinism
Reuse `MapNode.make_rng(run_seed)` per node so the same `(chapter, seed)` always yields the same map
*and* the same encounter composition — replay/save-load safe, matches the existing seed discipline.

## 6. Acceptance criteria (desktop Godot run)
1. New run → a **branching** map renders: multiple depths, 2–4 nodes wide, edges drawn, BOSS at the end;
   `map_graph.validate()` passes (all nodes reachable, all can reach BOSS).
2. Player can only advance to a **reachable child**; the chosen path is highlighted; visited nodes lock.
3. Combat nodes show **encounter symbols**, not a generic sword; tapping shows name + blurb; a legend lists all.
4. Two different routes through the same seed produce **noticeably different enemy mixes/tactics** (e.g. a
   `swarm` node spawns many fast weak enemies; a `bruisers` node spawns few armored slow ones).
5. `for_node` produces a legal `Wave` for every archetype (no nulls, sane counts/stats).
6. Every path reaches a REST and a SHOP before the boss; ELITE gate present ~depth 7–8.
7. Determinism: same seed → identical map + identical encounters on reload.

Tests (headless): extend `map_test.gd` (branching reachability, boss-terminal, per-path REST/SHOP
guarantee, no archetype repeats back-to-back on a path) + new `encounter_test.gd` (each archetype → legal
wave; symbol+blurb present for every catalog entry).

## 7. Scope honesty / follow-on
- v0 lands **branching routes + enemy/tactic variance + symbols** (Paul's three asks).
- `EVENT / SHOP / SHRINE / REST` nodes are **placed and symbol'd** as route variety but **auto-resolve**
  for now (existing stub). Their real interactions (a shop screen, event choices, rest heal/upgrade) are a
  follow-on phase — flagged, not in this spec.

## 8. Decisions for Paul (sensible defaults chosen)
1. **Chapter size:** 12 depths, 2–4 wide (≈9–11 nodes/run). Bigger/smaller?
2. **Archetype count:** 7 (§2). Add/cut any? Names/symbols to your taste — easy to tweak.
3. **Enable real Event/Shop/Rest now**, or keep them auto-resolving until the branching map is in and
   playtested? (Default: defer — get the routes + combat variety feeling right first.)

— Controller
