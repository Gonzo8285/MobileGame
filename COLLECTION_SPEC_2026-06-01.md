# Gallowfell — Card Collection / Codex screen: build-ready spec (2026-06-01)

_Authored by Controller for the Claude Code session. Reuses the `CardDatabase` autoload (Phase 2.16 DB-1)
and `scenes/card_view.tscn`. Pure read-only browse/gallery — no deck mutation, no monetisation hooks
(anti-P2W invariant). Showcases the ~219 rendered card images._

---

## 1. What this is + where it slots in

A **codex / gallery** where the player browses every card in the game, reads full details, and admires
the art — separate from the deck-builder (which is run-scoped). Reached from the Title / main menu
("Collection"); **Back** → Title. No combat dependency, so it can build in parallel with everything else
(only hard dep is `CardDatabase` from DB-1).

## 2. Data source — extend `CardDatabase`

Add read accessors (the deck-builder already added `draftable_for`/`get_by_id`/`resolve_deck`):

```gdscript
func all_cards() -> Array[Card]:
    var out: Array[Card] = []
    for arr in _by_faction.values(): out.append_array(arr)
    out.sort_custom(func(a, b):
        return a.faction < b.faction if a.faction != b.faction else
               (a.cost < b.cost if a.cost != b.cost else a.display_name < b.display_name))
    return out

func by_faction(faction: int) -> Array[Card]:
    return (_by_faction.get(faction, []) as Array).duplicate()

func counts_by_faction() -> Dictionary:                  ## faction(int) -> int
    var d := {}
    for fac in _by_faction: d[fac] = _by_faction[fac].size()
    return d
```

Codex shows **all** cards including tokens/relics (it's a reference, unlike the deck-builder which hides
`is_draftable=false`). Render tokens/relics with a small "Token"/"Relic" badge.

## 3. Layout (mobile portrait, 540×960 override)

```
┌───────────────────────────────────────────────┐
│ ◀ Back   COLLECTION            142 / 177 ▣      │  header + collected count
├───────────────────────────────────────────────┤
│ [Iron][Ash][Coven][Legion][Skin][Neut][All]    │  faction tabs
│ cost ▾  type ▾  rarity ▾      🔍 search…        │  filters + search
├───────────────────────────────────────────────┤
│  ┌──┐┌──┐┌──┐┌──┐                               │
│  │c1││c2││c3││c4│   scrollable grid              │  card_view thumbnails
│  └──┘└──┘└──┘└──┘   (locked = greyed/silhouette) │  cost badge + faction tint
│  ┌──┐┌──┐┌──┐┌──┐                               │
│  │..││..││..││..│                               │
│  └──┘└──┘└──┘└──┘                               │
└───────────────────────────────────────────────┘
        ↑ tap a card → full detail overlay (§4)
```

- Faction tabs filter the grid; "All" shows everything (default).
- Per-faction "collected" count in the header updates with the active tab (`counts_by_faction`).
- Locked cards (`unlock_tag != &""` and not owned) render greyed with a lock glyph; name still shown,
  detail still readable (it's a codex). At MVP all `unlock_tag == &""` cards count as collected.

## 4. Card detail overlay (shared with deck-builder's card-zoom)

Tap a tile → full-screen overlay:
- Big card art (`card.art_path`, placeholder fallback — the 4 owed cards land shortly).
- Header: name · faction tag · rarity · cost.
- Unit stats (if `card_type == UNIT`): HP / ATK / range / cooldown.
- **Keyword chips**: one per `card.keywords` entry, label from `GFEnums.Keyword.keys()`, tap a chip →
  short rules tooltip (e.g. LIFESTEAL → "On a successful attack, heal the attacker for damage dealt").
  Keep a `KEYWORD_BLURBS: Dictionary` in the overlay (single source for tooltip text).
- `effect_text` and `flavour_text` blocks.
- Close (X / Back / swipe).

Build this overlay as a small reusable scene `scenes/card_detail.tscn` so the deck-builder's long-press
zoom (DB-7) and the Collection both use it — avoids two divergent detail views.

## 5. Wiring
- Add a **"Collection"** entry point on the Title / main shell → loads `scenes/collection.tscn`.
- `collection.gd` builds UI programmatically (matches `title.gd`/`map_view.gd` convention).
- Read-only: the screen never writes game state.

## 6. Acceptance criteria (desktop Godot run)
1. Open Collection → grid shows all cards; "All" tab default; header count == total `.tres` count.
2. Faction tabs filter correctly; per-tab count matches `CardDatabase.counts_by_faction()`.
3. Filters (cost/type/rarity) and search narrow results; clearing restores.
4. Tap a card → detail overlay with art, stats (units only), keyword chips + tooltips, effect + flavour.
5. Tokens/relics show with the right badge; locked cards render greyed but still openable.
6. Back returns to Title; no game state mutated.

Add `game/src/runtime/collection_test.gd` (headless): `all_cards().size()` == sum of per-faction `.tres`,
`counts_by_faction()` sums to the same, detail overlay populates from a sample card without error.

## 7. Build chunks (one heartbeat each) — see backlog Phase 2.18
CO-1 CardDatabase accessors · CO-2 collection.gd grid + faction tabs + count · CO-3 shared
`card_detail.tscn` overlay · CO-4 filters/search + locked rendering · CO-5 Title wiring + Back ·
CO-6 headless test.

## 8. Note for Paul (not building without your call)
The map is intentionally a **linear 8-round gauntlet** (your IMV-1 design). The engine already supports
**branching maps** and four unused node types are fully defined + styled in the UI (EVENT / SHOP / SHRINE /
REST). Turning those on — a Slay-the-Spire-style branching route with shops/rests/events between fights —
is a sizeable IMV-2 gameplay upgrade. Flagging it as a decision; not touching the linear structure unless
you want it.

— Controller
