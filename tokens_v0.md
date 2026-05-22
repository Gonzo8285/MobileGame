# Tokens v0 — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory item CARD-6. Canonical token registry. Locks anti-draft, anti-Persist, anti-upgrade rules. Identifies token-card sources and engine fields._

**Status:** v0 spec.

---

## 1. What a token is

A **token** is a card-shape entity that:
- Exists only as a summon (never drafted, never in starter deck)
- Has `is_token = true` on the `Card` Resource
- Cannot Persist (per `keywords/persist_v0.md` §"Token exclusion")
- Cannot be upgraded at REST nodes (per `rests_v0.md` and `upgrade_trees_v0.md` §4)
- Cannot have on-attack keywords (per inventory open Q from §13.4 in `gameplay_keywords_resolution_v0.md` — confirmed: tokens don't have DREAD-able first-attack triggers)
- Per-card mastery counter does NOT increment on token plays (per `upgrade_trees_v0.md` §3.3)

Tokens are summoned from:
- Spell card effects (e.g. Hex of Many → 3 Bog-Spawn)
- Unit triggered abilities (e.g. Mother Quag's "every 3rd enemy killed → Bog-Spawn")
- Trap effects (e.g. C42 Black Mire Pact → spawns on sacrifice)
- Warlord passives (e.g. Marsh-Mother Eddra's _Brood_ → Familiar)

---

## 2. Canonical token registry

### 2.1 Existing tokens (named in `cards_*_v1.md` and `warlord*` docs)

| ID | Name | Stats | Faction | Source(s) | Notes |
|---|---|---|---|---|---|
| TKN-1 | Bog-Spawn | 0/1 | Coven | C1 (card itself flagged is_draftable), Hex of Many (Eddra spell), C42 Black Mire Pact | Existing C1 already flagged is_token in `.tres` |
| TKN-2 | Familiar | 1/1 (Poison-1) | Coven | Eddra Brood passive | Starts on player's back tile |
| TKN-3 | Withered Servant | 1/1 | Ash-Mourners | Sieren Hanged Memory passive, Lord-Justiciar Vey (M5) trigger | Spawned on death-tile |
| TKN-4 | Cub-Token | 0/1 | Skinward Pact | W27 in `cards_skinward_pact_v1.md` | Existing, flagged is_token |
| TKN-5 | Wolf-Token | 1/2 | Skinward Pact | W28 in `cards_skinward_pact_v1.md` | Existing, flagged is_token |
| TKN-6 | Banner-Token | 0/3 | The Last Legion | L34 Crowned Anvil Standard (existing 5c artifact-unit) | Existing, flagged is_token; new lane-object class flagged in cards_last_legion Q2 |
| TKN-7 | Brass Hound | 1/1 (Bleed-on-hit) | Iron Penitents × Skinward Pact (hybrid) | Brass-Crowned Whelp W9 sig spell _Wail_ | New token (was named in `warlords_v1.md`, no `.tres` yet) |
| TKN-8 | Confessor-Familiar | 0/1 (gains last-played-card keywords) | Neutral | Last Confessor W10 sig unit (passive Hearsay) | New token (Hearsay's mechanic implies a token form) |
| TKN-9 | Hempen Witness | 1/3 (PERSIST-tagged but per-instance excluded from re-PERSIST per §3 below) | Neutral / curse | Saint That Hangs ch3 boss (per `bosses_chapters_2_3_v0.md` §3.4) | Spawned by The Drop |
| TKN-10 | Demon-Familiar | 3/3 | Coven | R-COV-4 The Hoofprint Locket relic (per `upgrade_trees_v0.md` §6.3) | Spawned on player death (relic-trigger) |
| TKN-11 | Beast | 4/4 (Skinward-flavoured) | Skinward Pact | R-SKW-4 God-Tree Seed-Husk relic | Spawned at HH |

**Total: 11 canonical tokens.**

### 2.2 Special case — Hempen Witness PERSIST exception

Hempen Witness (TKN-9) is a token but is *spec-listed* with PERSIST. This conflicts with the general "tokens cannot Persist" rule.

**Resolution:** Hempen Witness is **enemy-only** (boss-spawned) and the "tokens cannot Persist" rule applies to *player-side* tokens to prevent infinite-Persist combos. Enemy-side tokens with PERSIST are allowed *if* the boss spawns them and they meet the per-combat once limit applied to that specific instance. Engine flag: `Card.token_can_persist: bool = false` default; set true on TKN-9.

---

## 3. Engine rules (locked)

### 3.1 Anti-draft rule

```
# reward_generator.gd already excludes via Card.is_draftable filter
# Card.is_draftable = false on every token

filter: card.is_draftable == true
```

### 3.2 Anti-Persist rule

```
# turn_engine.gd PERSIST resolver
func should_persist(unit: UnitInstance) -> bool:
    if unit.card_data.is_token:
        return unit.card_data.token_can_persist  # default false
    return GFEnums.Keyword.PERSIST in unit.card_data.keywords and not unit.has_persisted
```

### 3.3 Anti-upgrade rule

```
# rests_v0.md REST upgrade picker UI
func is_upgradable(card_instance: CardInstance) -> bool:
    return not card_instance.card_data.is_token
```

### 3.4 Anti-mastery rule

```
# upgrade_trees_v0.md §3 card mastery
# in combat.gd on_unit_played callback
func on_unit_played(unit: UnitInstance):
    if not unit.card_data.is_token:
        GameState.record_card_play(unit.card_data.id)
```

### 3.5 Anti-DREAD rule

Per `gameplay_keywords_resolution_v0.md` Open Q 4 (DREAD on tokens): excluded.
```
# keyword_resolver.gd
func resolve_attack_with_dread_check(attacker: UnitInstance):
    if attacker.card_data.is_token:
        return AttackTarget.NORMAL  # tokens skip DREAD
    # normal check ...
```

### 3.6 Tokens cannot be targeted by certain effects

Some cards/relics only target "drafted units" — i.e. non-tokens. Per-effect basis:
- **Sacrifice outlets** (P41 Last Vows, M2 spec): can sacrifice tokens? **Yes** — sacrifice + token is intentional combo (e.g. Coven sac-Bog-Spawn-for-payoff). Tokens are valid sacrifice fodder.
- **REST upgrade**: no per §3.3.
- **Treatment apply**: tokens cannot have card-treatments applied (they're not in collection). Treatment-related effects ignore tokens.

---

## 4. Token .tres file convention

```
# example: TKN-1 Bog-Spawn (game/data/cards/coven/C1.tres — already exists)

[gd_resource type="Card" load_steps=2 format=3]

[ext_resource type="Script" path="res://src/data/card.gd" id="1"]

[resource]
script = ExtResource("1")
id = &"TKN-1"
display_name = "Bog-Spawn"
faction = 6  # COVEN
card_type = 0  # UNIT
rarity = 0  # COMMON
cost = 0
attack = 0
hp = 1
range = 0  # MELEE
keywords = []
is_draftable = false
is_token = true
token_can_persist = false  # new field, default false
flavour_text = "Bargained from the mud. Cheap."
```

### 4.1 New `Card.token_can_persist` field

Add to `card.gd`:
```
@export var token_can_persist: bool = false  # default false; true only for Hempen Witness (TKN-9)
```

---

## 5. Token-card files to be authored (post-IMV-1)

Of the 11 canonical tokens, these don't have `.tres` files yet:

| ID | Required file path |
|---|---|
| TKN-2 Familiar | `game/data/cards/coven/TKN-2_familiar.tres` |
| TKN-3 Withered Servant | `game/data/cards/ash_mourners/TKN-3_withered_servant.tres` |
| TKN-7 Brass Hound | `game/data/cards/hybrid/TKN-7_brass_hound.tres` (or appropriate folder) |
| TKN-8 Confessor-Familiar | `game/data/cards/neutral/TKN-8_confessor_familiar.tres` |
| TKN-9 Hempen Witness | `game/data/cards/neutral/TKN-9_hempen_witness.tres` |
| TKN-10 Demon-Familiar | `game/data/cards/coven/TKN-10_demon_familiar.tres` |
| TKN-11 Beast | `game/data/cards/skinward_pact/TKN-11_beast.tres` |

7 token .tres files to author. Recommend folder organisation: each token lives in its primary faction folder, or in a new `neutral/` folder for cross-faction tokens.

**Effort:** ~30 min total — they're small files.

---

## 6. Engine handoff

### 6.1 `Card.is_token` registry helper

```
class_name TokenRegistry extends Object

static var _all_tokens: Array[Card] = []

static func load_all() -> void:
    _all_tokens.clear()
    for path in ["res://game/data/cards/coven/", "res://game/data/cards/ash_mourners/", ...]:
        var dir = DirAccess.open(path)
        for f in dir.get_files():
            if f.ends_with(".tres"):
                var card = load(path + f)
                if card.is_token:
                    _all_tokens.append(card)

static func find_token_by_id(id: StringName) -> Card:
    for t in _all_tokens:
        if t.id == id:
            return t
    return null

static func is_token_id(id: StringName) -> bool:
    return find_token_by_id(id) != null
```

### 6.2 Token spawn API

```
# In Combat.gd

func spawn_token(token_id: StringName, lane_idx: int, tile_idx: int) -> UnitInstance:
    var token_card = TokenRegistry.find_token_by_id(token_id)
    if token_card == null:
        push_error("Unknown token: " + str(token_id))
        return null
    var instance = UnitInstance.new()
    instance.card_data = token_card
    instance.hp = token_card.hp
    instance.is_token = true
    lanes[lane_idx].place_unit(instance, tile_idx)
    return instance
```

---

## 7. MVP coverage

| Token | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| C1 Bog-Spawn | ✅ (existing) | ✅ | ✅ | ✅ | ✅ |
| TKN-2 Familiar | — | ✅ | ✅ | ✅ | ✅ |
| TKN-3 Withered Servant | — | ✅ | ✅ | ✅ | ✅ |
| TKN-4/5 Cub/Wolf | ✅ (existing) | ✅ | ✅ | ✅ | ✅ |
| TKN-6 Banner-Token | ✅ (existing) | ✅ | ✅ | ✅ | ✅ |
| TKN-7 Brass Hound | — | — | ✅ (Whelp W9 unlocked) | ✅ | ✅ |
| TKN-8 Confessor-Familiar | — | — | ✅ (Confessor W10 unlocked) | ✅ | ✅ |
| TKN-9 Hempen Witness | — | — | ✅ (boss ch3 in spec) | ✅ | ✅ |
| TKN-10 Demon-Familiar | — | — | (relic R-COV-4 lands) | ✅ | ✅ |
| TKN-11 Beast | — | — | (relic R-SKW-4 lands) | ✅ | ✅ |

---

## 8. Open questions for Paul

1. **TKN-9 Hempen Witness PERSIST exception** — confirm enemy-side tokens may carry PERSIST when boss-spawned. Alternative: drop PERSIST from boss-spawned Witnesses (they just spawn fresh each Drop). Recommend keep PERSIST for terror factor.
2. **TKN-8 Confessor-Familiar mechanic** — does it gain last-played-card keywords just for the next combat or for run? Recommend per-combat (refreshes).
3. **Token alt-art slots** — should tokens have alt-art variants per `variants_system_v0.md` VAR-1? Tokens aren't in collection, so no acquisition path... recommend NO alt-arts for tokens (frees ~10 alt-art slots from authoring scope).
4. **TKN-7 Brass Hound** is a hybrid-faction token (Iron Penitents × Skinward Pact). Where does its `.tres` file live? Recommend `game/data/cards/neutral/` with `faction = NEUTRAL`.

---

## 9. Cross-references

- `keywords/persist_v0.md` — token exclusion rule.
- `rests_v0.md` — upgrade exclusion.
- `upgrade_trees_v0.md` §3.3 — mastery exclusion.
- `gameplay_keywords_resolution_v0.md` §13 — DREAD on tokens question (now resolved).
- `cards_coven_v1.md` C1 / `cards_skinward_pact_v1.md` W27, W28 / `cards_last_legion_v1.md` L34 — existing token-flagged cards.
- `warlords_v1.md` W3 Brood + W9 Wail + W10 Hearsay — token-spawning sources.
- `bosses_chapters_2_3_v0.md` §3 — Hempen Witness boss-spawn.

— Controller, 2026-05-21
