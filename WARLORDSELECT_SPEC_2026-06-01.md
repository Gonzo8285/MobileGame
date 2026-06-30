# Gallowfell — Warlord-Select screen: build-ready spec (2026-06-01)

_Authored by Controller for the Claude Code session. Grounds on live code (`src/data/warlord.gd`,
`src/ui/title.gd`, `src/runtime/run_controller.gd`) + existing design `warlord_select_ui_v0.md` §2
(Screen A roster grid) + roster data in `warlords_v1.md` §Free roster. Pairs with the Deck-Builder
(Phase 2.16): Warlord-Select sets the faction the deck-builder scopes to._

---

## 1. What this is + where it slots in

The screen the player lands on for a new run: a **roster grid** to pick a Warlord. On select →
**Deck Builder** (`deck_builder.setup(warlord_id, faction)`), which then starts the run.

New flow: Title → **Warlord Select** → Deck Builder → `start_run` → Chapter 1.
Today `title.gd` hardcodes a 5-entry warlord dictionary with **stale names** (Vey/Quag/Vikar/Thrask) and
auto-starts. This replaces that with data-driven select + the deck-builder hop.

## 2. MVP scope (and what's deferred)

**In scope (v0):** Screen A roster grid (5 free shown; 5 paid shown locked/greyed; W11 hidden until
unlocked), each tile = art slot + name + faction tag + archetype tag; a light **detail panel** (bigger
art, passive name+text, signature unit + signature spell names); **Select** → deck builder; **Back** → Title.

**Deferred to IMV-2** (per `warlord_select_ui_v0.md` §0 + the tier/monetisation lane): Tier 2/3/4 unlock
modals, the XP-booster strip, paid-Warlord purchase flow. Show paid Warlords **locked** with their cost
label, but tapping them just shows "Unlock in IMV-2" — no purchase yet.

## 3. Canonical free-5 (supersedes the stale `title.gd` dict)

From `warlords_v1.md` §Free roster. **Reconcile names** — the older `vey`/`quag`/`vikar`/`thrask`
stubs are wrong; canonical ids/names below:

| id | Name | Faction | Archetype | Passive | Sig. unit | Sig. spell |
|----|------|---------|-----------|---------|-----------|-----------|
| `vyrrun` | Penance-Captain Vyrrun | IRON_PENITENTS | Aggro | Mortify | Cathedral Brother | Self-Scourge |
| `sieren` | Court-Necromant Sieren | ASH_MOURNERS | Control | Hanged Memory | Pall-Bearer | Funeral Writ |
| `eddra`  | Marsh-Mother Eddra | COVEN | Swarm | Brood | Bog-Born | Hex of Many |
| `veska`  | Forge-Marshal Veska | LAST_LEGION | Tempo | Forge-Heat | Iron-Officer | Iron Cohort |
| `mhar`   | Tree-Walker Mhar | SKINWARD_PACT | Summoner | Wear the Dead | Cinder-Wolf | Don the Pelt |

(Existing stubs `data/warlords/vyrrun.tres` is keepable; `vey.tres`/`quag.tres` are replaced by
`sieren`/`eddra`. Art already rendered: `_showcase/warlords/w1..w5` map to these five.)

## 4. New: `WarlordDatabase` autoload (mirror of CardDatabase)

`game/src/runtime/warlord_database.gd`, registered after `GameState` + `CardDatabase`:

```gdscript
extends Node
## Scans res://data/warlords/*.tres once at boot, indexes by id. Source of truth
## for the roster grid + run-start warlord→faction resolution (replaces the
## hardcoded map in run_controller).
const WARLORDS_DIR := "res://data/warlords/"
var _by_id: Dictionary = {}                      ## StringName -> Warlord

func _ready() -> void: _scan()

func _scan() -> void:
    _by_id.clear()
    var dir := DirAccess.open(WARLORDS_DIR)
    if dir == null: push_error("[WarlordDatabase] cannot open %s" % WARLORDS_DIR); return
    for f in dir.get_files():
        if not (f.ends_with(".tres") or f.ends_with(".tres.remap")): continue
        if f.ends_with("_tiers.tres"): continue                  # tier sidecars, not roster entries
        var w := load(WARLORDS_DIR + f.trim_suffix(".remap")) as Warlord
        if w != null: _by_id[w.id] = w

func get_by_id(id: StringName) -> Warlord: return _by_id.get(id)
func faction_of(id: StringName) -> int:
    var w: Warlord = _by_id.get(id)
    return w.faction if w != null else GFEnums.Faction.NEUTRAL
func free_warlords() -> Array:
    var out := []
    for w in _by_id.values(): if w.is_free: out.append(w)
    out.sort_custom(func(a, b): return a.faction < b.faction)
    return out
func paid_warlords() -> Array:
    var out := []
    for w in _by_id.values(): if not w.is_free and w.unlock_tag == &"": out.append(w)
    return out
```

## 5. `warlord_select.gd` — the screen (programmatic UI, `title.gd` convention)

`game/scenes/warlord_select.tscn` = root `Control` + `warlord_select.gd`. Behaviour:

- `_ready()`: build the grid from `WarlordDatabase.free_warlords()` (always selectable) +
  `paid_warlords()` (rendered locked/greyed with cost label).
- Each tile: art (`res://art/warlords/<id>_*.png` with placeholder fallback — w1..w5 exist now), name,
  faction tag, archetype tag (from a small `{faction→archetype}` map or a future `Warlord.archetype` field).
- Tap a free tile → open the detail panel for that Warlord (art + passive name/text + signature
  unit/spell names). Detail panel has **Select** and **Back**.
- **Select** →
  ```gdscript
  func _on_select(w: Warlord) -> void:
      GameState.active_warlord_id = w.id
      var scene := load("res://scenes/deck_builder.tscn").instantiate()
      scene.setup(w.id, w.faction)
      get_tree().root.add_child(scene)
      get_tree().current_scene.queue_free()
      get_tree().current_scene = scene
  ```
- **Back** (screen-level) → `res://scenes/title.tscn`.

Layout = `warlord_select_ui_v0.md` §2 Screen A: a "FREE" row of 5 tiles, then a "LOCKED" row of paid
tiles greyed with cost. Tier dots / XP strip from that doc are **omitted at v0** (IMV-2).

## 6. Wiring changes to existing files

- **`title.gd`:** delete the hardcoded `warlords` dictionary + `_start_run_with` auto-deck logic; the
  Title's "Play / New Run" button now just loads `warlord_select.tscn`. (Keep Title minimal — logo +
  Play + Continue-with-last-deck shortcut if `GameState.last_deck_ids` is set.)
- **`run_controller._get_active_warlord_faction()`:** replace the hardcoded `match` with
  `return WarlordDatabase.faction_of(GameState.active_warlord_id)`. Removes the stale vyrrun/vey/quag map.

## 7. Acceptance criteria (desktop Godot run)
1. Launch → Title → Play → Warlord Select shows **5 free** tiles (Vyrrun/Sieren/Eddra/Veska/Mhar) with
   correct faction + archetype tags and rendered art.
2. Paid Warlords render **locked** with a cost label and are not selectable into a run (tap → "IMV-2").
3. Tapping a free Warlord opens the detail panel with its passive + signature unit/spell names.
4. **Select** → Deck Builder opens scoped to that Warlord's faction (verify the collection matches).
5. `GameState.active_warlord_id` is set; `run_controller` resolves the **same** faction via
   `WarlordDatabase` (no hardcoded map hit).
6. **Back** at each level returns correctly (detail→grid, grid→Title).

Add `game/src/runtime/warlord_select_test.gd` (headless): `WarlordDatabase` loads ≥5 free, `faction_of`
returns the table-3 value for each id, `free_warlords()` count == 5.

## 8. Open items / decisions
1. **Signature unit/spell linkage:** §3 names them; the `.tres` `signature_unit`/`signature_spell`
   `Card` refs are currently null. WL-1 should point them at the matching card `.tres` **if those cards
   exist** (Cathedral Brother / Pall-Bearer / etc. — resolve by name→id), else leave null + flag. Whether
   signatures auto-inject into the run deck is a separate `start_run` concern — flag, don't solve here.
2. **Archetype tag source:** add a `Warlord.archetype: StringName` field, or keep a faction→archetype
   map in the UI for v0? (Default: small UI map now; promote to the resource later.)
3. Paid-Warlord **purchase flow** stays stubbed ("IMV-2") until Paul opens the monetisation lane.

— Controller
