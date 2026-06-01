# Gallowfell — Deck-Builder screen: build-ready spec + scaffold (2026-06-01)

_Authored by Controller for the Claude Code session to implement in `Gonzo8285/MobileGame`.
Grounded in the live code: `src/data/card.gd`, `src/runtime/deck.gd`, `src/runtime/game_state.gd`,
`src/ui/title.gd`. Controller is not editing the Godot tree (avoids colliding with your commits) — drop
these files in and commit, or adapt as you see fit._

---

## 1. What this is + where it slots in

A pre-run screen where the player **chooses which cards go into their deck**, then starts the run.

Current flow (`title.gd._start_run_with`): pick Warlord → auto-builds a random starter deck →
`GameState.start_run(starter, warlord_id, 0)` → `enter_chapter(1)`.

New flow: pick Warlord → **Deck Builder (faction-scoped)** → player assembles deck → **Start** →
`GameState.start_run(chosen_deck, warlord_id, 0)` → `enter_chapter(1)`. A **Back** returns to Warlord
select. The random auto-deck stays as a **"Quick Deck / Auto-fill"** button so testing isn't slowed.

## 2. Deck rules (v0 — matches the sim in `c8_deck_construction_v0.md`)

- **Deck size:** exactly **20 cards** (`DECK_SIZE = 20`). Start disabled until met.
- **Copies:** **singleton at v0** (`MAX_COPIES = 1`). Parameterised so v1 can raise to 2–3.
- **Faction lock:** only the active Warlord's faction **+ NEUTRAL**. (Warlord→faction already mapped in
  `run_controller._get_active_warlord_faction`; promote that into the Warlord resource / `CardDatabase`.)
- **Excluded:** non-draftable cards (`is_draftable == false` → tokens + relics), per the same exclusion
  the sim builder uses. Relic-slot system stays out until Paul ratifies it (separate decision).
- **Unlock gating:** a card shows as ownable only if `unlock_tag == &""` OR the profile owns that tag.
  At MVP, treat all `unlock_tag == &""` cards as available (collection/unlock economy is IMV-2).

## 3. New: `CardDatabase` autoload (no catalog exists yet)

`run_controller` and `title` currently load card dirs ad-hoc. Add one indexed source of truth that the
deck-builder, reward generator and run-start all share.

`game/src/runtime/card_database.gd` (register as autoload `CardDatabase` in `project.godot`, after
`GameState`):

```gdscript
extends Node
## Scans res://data/cards/** once at boot, indexes Card resources by id and faction.
## Single source of truth for "what cards exist" — used by the deck-builder, reward
## generator, and run-start id->Card resolution.

const CARDS_ROOT := "res://data/cards/"

var _by_id: Dictionary = {}              ## StringName -> Card
var _by_faction: Dictionary = {}         ## GFEnums.Faction (int) -> Array[Card]

func _ready() -> void:
    _scan()

func _scan() -> void:
    _by_id.clear()
    _by_faction.clear()
    var root := DirAccess.open(CARDS_ROOT)
    if root == null:
        push_error("[CardDatabase] cannot open %s" % CARDS_ROOT)
        return
    for sub in root.get_directories():                       # iron_penitents/, ash_mourners/, ...
        var dir := DirAccess.open(CARDS_ROOT + sub)
        if dir == null:
            continue
        for f in dir.get_files():
            # Exported builds import .tres as .remap — accept both.
            if not (f.ends_with(".tres") or f.ends_with(".tres.remap")):
                continue
            var path := CARDS_ROOT + sub + "/" + f.trim_suffix(".remap")
            var card := load(path) as Card
            if card == null:
                continue
            _by_id[card.id] = card
            _by_faction.get_or_add(card.faction, [] as Array[Card]).append(card)

func get_by_id(id: StringName) -> Card:
    return _by_id.get(id)

## Draftable cards for a faction set (e.g. [active_faction, NEUTRAL]), tokens/relics excluded.
func draftable_for(factions: Array) -> Array[Card]:
    var out: Array[Card] = []
    for fac in factions:
        for c in _by_faction.get(fac, []):
            if c.is_draftable:
                out.append(c)
    out.sort_custom(func(a, b): return a.cost < b.cost if a.cost != b.cost else a.display_name < b.display_name)
    return out

## Resolve an ordered list of ids into deep-copied Card resources for a run.
func resolve_deck(ids: Array) -> Array[Card]:
    var out: Array[Card] = []
    for id in ids:
        var c: Card = _by_id.get(id)
        if c != null:
            out.append(c.duplicate_card())
    return out
```

> Export note: if `DirAccess` can't enumerate packed `.tres` in an exported build, generate a
> `card_manifest.json` (id→path list) at build time and have `_scan()` read that as the fallback.
> Fine for editor/dev runs as-is; flag the manifest step in the export checklist.

## 4. `GameState` additions — persist the chosen deck

The profile already persists run/economy state. Add the player's last deck so it survives sessions:

```gdscript
# game_state.gd — profile-persisted
var last_deck_ids: Array[StringName] = []     ## ids the player assembled in the deck-builder

func set_last_deck(ids: Array[StringName]) -> void:
    last_deck_ids = ids.duplicate()
    _save_profile()                            ## reuse the existing profile-save path

func start_run_from_ids(ids: Array[StringName], warlord_id: StringName, seed_value: int = 0) -> void:
    start_run(CardDatabase.resolve_deck(ids), warlord_id, seed_value)
```

(Keep the existing `start_run(Array[Card], ...)` untouched — `start_run_from_ids` is a thin wrapper so
the builder works in ids and combat keeps getting `Array[Card]`.)

## 5. `deck_builder.gd` — the screen (programmatic UI, matching `title.gd` convention)

`game/scenes/deck_builder.tscn` = a root `Control` with `deck_builder.gd` attached.
`game/src/ui/deck_builder.gd`:

```gdscript
extends Control
## Pre-run deck assembly. Faction-scoped to the active Warlord. Produces a 20-card
## singleton deck (v0 rules) and hands it to GameState to start the run.

const DECK_SIZE := 20
const MAX_COPIES := 1                          ## v0 singleton; bump for v1 multi-copy

var _faction: int = GFEnums.Faction.NEUTRAL
var _warlord_id: StringName = &""
var _available: Array[Card] = []               ## draftable pool for this faction (+neutral)
var _deck: Dictionary = {}                     ## StringName id -> int count
var _filter_type: int = -1                     ## -1 = all; else GFEnums.CardType
var _search := ""

@onready var _count_label: Label = %CountLabel
@onready var _collection: GridContainer = %CollectionGrid
@onready var _deck_list: VBoxContainer = %DeckList
@onready var _start_btn: Button = %StartButton

func setup(warlord_id: StringName, faction: int) -> void:
    _warlord_id = warlord_id
    _faction = faction

func _ready() -> void:
    _available = CardDatabase.draftable_for([_faction, GFEnums.Faction.NEUTRAL])
    _rebuild_collection()
    _refresh_deck_panel()
    %BackButton.pressed.connect(_on_back)
    %AutoFillButton.pressed.connect(_on_autofill)
    %ClearButton.pressed.connect(func(): _deck.clear(); _refresh_all())
    _start_btn.pressed.connect(_on_start)

func _deck_count() -> int:
    var n := 0
    for c in _deck.values(): n += c
    return n

func _can_add(card: Card) -> bool:
    return _deck_count() < DECK_SIZE and _deck.get(card.id, 0) < MAX_COPIES

func _add(card: Card) -> void:
    if _can_add(card):
        _deck[card.id] = _deck.get(card.id, 0) + 1
        _refresh_all()

func _remove(id: StringName) -> void:
    if _deck.has(id):
        _deck[id] -= 1
        if _deck[id] <= 0: _deck.erase(id)
        _refresh_all()

func _passes_filter(c: Card) -> bool:
    if _filter_type != -1 and c.card_type != _filter_type: return false
    if _search != "" and not c.display_name.to_lower().contains(_search.to_lower()): return false
    return true

func _rebuild_collection() -> void:
    for child in _collection.get_children(): child.queue_free()
    for c in _available:
        if not _passes_filter(c): continue
        var tile := _make_card_tile(c)              # reuse card_view.tscn thumbnail; see §6
        _collection.add_child(tile)

func _refresh_deck_panel() -> void:
    for child in _deck_list.get_children(): child.queue_free()
    var ids := _deck.keys()
    ids.sort_custom(func(a, b):
        var ca: Card = CardDatabase.get_by_id(a); var cb: Card = CardDatabase.get_by_id(b)
        return ca.cost < cb.cost if ca.cost != cb.cost else ca.display_name < cb.display_name)
    for id in ids:
        var c: Card = CardDatabase.get_by_id(id)
        var row := _make_deck_row(c, _deck[id])      # "[2] Nail-Choir Flagellant  x1   (–)"
        _deck_list.add_child(row)
    _count_label.text = "%d / %d" % [_deck_count(), DECK_SIZE]
    _start_btn.disabled = _deck_count() != DECK_SIZE

func _refresh_all() -> void:
    _rebuild_collection(); _refresh_deck_panel()

func _on_autofill() -> void:
    _deck.clear()
    for c in _available:
        if _deck_count() >= DECK_SIZE: break
        if c.card_type == GFEnums.CardType.UNIT: _deck[c.id] = 1   # bias to a playable curve
    var i := 0
    while _deck_count() < DECK_SIZE and i < _available.size():
        _deck[_available[i].id] = 1; i += 1
    _refresh_all()

func _on_clear_search_changed(text: String) -> void:
    _search = text; _rebuild_collection()

func _on_start() -> void:
    if _deck_count() != DECK_SIZE: return
    var ids: Array[StringName] = []
    for id in _deck.keys():
        for _i in range(_deck[id]): ids.append(id)
    GameState.set_last_deck(ids)
    GameState.start_run_from_ids(ids, _warlord_id, 0)
    GameState.enter_chapter(1)

func _on_back() -> void:
    get_tree().change_scene_to_file("res://scenes/title.tscn")
```

`_make_card_tile` / `_make_deck_row` are small helpers (see §6). Tap a collection tile → `_add`; tap a
deck row's "–" → `_remove`; long-press / right-click a tile → zoom via `card_view`.

## 6. UI layout (mobile portrait, 540×960 override per `project.godot`)

```
┌───────────────────────────────────────────────┐
│ ◀ Back   [faction crest]  Vyrrun   12 / 20   ▶ │  top bar (CountLabel = %CountLabel)
├───────────────────────────────────────────────┤
│ [All][Units][Spells][Traps]   🔍 search…       │  filter chips + search
├──────────────────────────────┬────────────────┤
│  COLLECTION (scroll, grid)    │  YOUR DECK      │
│  ┌──┐┌──┐┌──┐                 │  [1] Bog-Spawn –│
│  │c1││c2││c3│  cost badge,     │  [2] Flagellant–│
│  └──┘└──┘└──┘  faction tint    │  …              │
│   tap = add                   │  mana curve ▁▃▅▂│
├──────────────────────────────┴────────────────┤
│  [Auto-fill]   [Clear]            [ Start Run ] │  Start disabled until 20/20
└───────────────────────────────────────────────┘
```

- Reuse `scenes/card_view.tscn` + `src/ui/card_view.gd` for tiles (cost, name, faction tint, art via
  `card.art_path` with the existing placeholder fallback — the 4 owed cards land in art shortly).
- Validation text near Start: "Need N more", "Max copies reached", "20/20 — ready".
- Mana-curve mini-histogram from the deck's cost buckets (nice-to-have; ship the list first).

## 7. Wiring change in `title.gd`

Replace the body of `_start_run_with(warlord_id)` so it routes to the builder instead of auto-starting:

```gdscript
func _start_run_with(warlord_id: StringName) -> void:
    var faction := _faction_for_warlord(warlord_id)        # reuse run_controller's mapping
    var scene := load("res://scenes/deck_builder.tscn").instantiate()
    scene.setup(warlord_id, faction)
    get_tree().root.add_child(scene)
    get_tree().current_scene.queue_free()
    get_tree().current_scene = scene
```

Keep the old auto-deck logic available behind the deck-builder's **Auto-fill** button so dev/testing is
still one tap.

## 8. Acceptance criteria (verify on a desktop Godot run)

1. Pick a Warlord → Deck Builder opens, collection shows only that faction + Neutral, **draftable only**
   (no tokens/relics).
2. Adding cards updates the count; **Start is disabled until exactly 20**; a 21st add is refused.
3. Singleton enforced: a second copy of the same card is refused at v0.
4. **Auto-fill** produces a legal 20-card deck in one tap; **Clear** empties it.
5. **Start** launches the run with exactly the assembled deck (assert `GameState.deck.size()` reflects
   20 minus opening draw), and **Back** returns to Title.
6. Filters (Units/Spells/Traps) and search narrow the collection correctly.
7. Chosen deck persists: relaunch → `GameState.last_deck_ids` restored (offer "Use last deck").

Add `game/src/runtime/deck_builder_test.gd` (headless): build CardDatabase, assert `draftable_for`
excludes non-draftables, assert deck-size + singleton rules, assert `resolve_deck` round-trips ids→Cards.

## 9. Open decisions for Paul (sensible defaults chosen; flag to change)
1. **Deck size 20** (matches the balance sim). Keep, or a different player-facing number?
2. **Singleton (1 copy) at v0.** Keep for launch, or allow 2–3 copies for the player now?
3. **Full collection available at MVP** (unlock economy deferred to IMV-2). OK, or gate some cards now?
4. Neutral pool is currently **empty** (0 `.tres`) — decks are pure-faction until Neutral cards exist;
   harmless, just noting.

— Controller
