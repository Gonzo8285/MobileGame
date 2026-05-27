# Curses v0 — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory item DES-5. Canonical 20-entry curse catalogue, removal cost rules, expiry rules, anti-perma-stack guard. Consolidates 8 curses scattered across `events_v0.md` + 12 new ones authored here._

**Status:** v0. Pure design doc.

---

## 1. What a curse is

A **curse** is a persistent run-level debuff applied to the player. Curses are *not* status effects on units — they're meta-level penalties on the run's economy / mechanics / deck.

Curses are acquired through:
- **EVENT choice** (chosen risky outcomes, per `events_v0.md`)
- **SHRINE "Defile" outcome** (per `shrines_v0.md`)
- **Ascension modifiers** (per `upgrade_trees_v0.md` §5.2)
- **Boss reward gambles** (post-victory choose-a-curse for higher reward, planned in IMV-2)

Curses can be removed by:
- **SHOP service slot "Holy water"** (60 Gold, per `shop_economy_v0.md` §3)
- **REST node trade** (some future rest variants will offer curse removal — planned)
- **End of chapter** (some curses expire automatically)
- **Specific event choices** (rare)

---

## 2. Curse catalogue (20 entries)

### 2.1 Already-named in `events_v0.md` (8 entries)

| ID | Name | Effect | Source event | Expiry |
|---|---|---|---|---|
| CRS-1 | Reliquary Debt | -1 max HP for this chapter | E01 choice C | end of chapter |
| CRS-2 | Court Debt | Each combat you must spend ≥ 1 mana on a non-attack action | E02 choice B | end of chapter |
| CRS-3 | Mire-Bound | Next 2 events become Coven-flavoured regardless of biome | E03 choice B | self-clears after 2 events |
| CRS-4 | Forge-Bound | Each combat starts with -1 starting mana for the first turn | E04 choice B (recommended) | persist for chapter |
| CRS-5 | Bargained Heart | -3 max HP, +50% gold gain (the trade is a feature) | E05 / E08 mire-event | end of chapter |
| CRS-6 | Drill-Sergeant's Voice | Each combat, your first card play costs +1 mana | E09 choice B | persist for chapter |
| CRS-7 | Cinder-Mark | Every 4 turns in combat, you take 2 damage | E05 choice C (cinderwood) | persist run |
| CRS-8 | Tree-Named | At Hanging Hour, take 3 extra damage | E10 choice B | persist run |

### 2.2 New curses authored this pass (12 entries)

| ID | Name | Effect | Source | Expiry |
|---|---|---|---|---|
| CRS-9 | Hangman's Doubt | Once per combat, your strongest unit takes 3 damage at random | Defile S1 outcome | end of chapter |
| CRS-10 | Bog-Sickness | POISON ticks on enemies expire 1 turn earlier (your DoT shortened) | Defile S2 outcome | persist for chapter |
| CRS-11 | Ash-Cough | -10% Bones gained at run-end | Ascension A6 modifier | persist run |
| CRS-12 | Iron-Cold | Each rest heals 10 fewer HP (R1 = 20 instead of 30, R2 = 40 instead of 50) | Defile S4 outcome | persist for chapter |
| CRS-13 | Spectral Watcher | One random enemy gains FEAR-1 *granted to it* (your units that attack it deal -1 ATK) | Cursed boss-reward gamble | per combat (resets each combat) |
| CRS-14 | Coin-Debt | First shop slot purchase costs +50% Gold | Defile S3 outcome | persist for chapter |
| CRS-15 | Hollow Vow | Persist no longer fires for player units this run | Special Penitent shrine outcome | persist run |
| CRS-16 | Mourners' Glance | Reanimation curse % doubled against you (more enemies rise) | Ash-Mourners shrine defile | persist for chapter |
| CRS-17 | Banner-Cold | RALLY effect range -1 row (only applies to same-tile units) | Defile S4 (Legion-flavoured) | persist for chapter |
| CRS-18 | Pelt-Bound Hunger | Each summon costs +1 Gold | Wyrm-Shifter event | persist for chapter |
| CRS-19 | The Black Writ | One random card in your deck becomes UNPLAYABLE for this run | Cursed boss-reward gamble | persist run |
| CRS-20 | The Tree's Listening | Boss combats deal +20% damage to you | Cursed boss-reward gamble | persist run |

**Total: 20 curses.** Each has flavour, a measurable mechanical penalty, a source path, and a clear expiry rule.

---

## 3. Removal rules

### 3.1 Holy Water (per `shop_economy_v0.md` §3 service slot)

- 60 Gold
- Removes **1 active curse**, player picks
- Cannot be used on the same combat the curse was applied
- Each Holy Water purchase guaranteed; service-slot doesn't reroll holy water away

### 3.2 REST trade (planned R3 variant)

A future Rest variant "The Forgotten Confessional" (queued for IMV-2 v0.2 rests) offers a trade:
- Pay 3 HP → remove 1 curse OR
- Heal 30 HP (normal R1 outcome)

### 3.3 Self-expiry by source

- "End of chapter" curses (CRS-1, CRS-2, CRS-4, CRS-6, CRS-9, CRS-10, CRS-12, CRS-14, CRS-16, CRS-17, CRS-18) clear at chapter transition (between chapter 1 → 2 etc.)
- "Persist run" curses (CRS-7, CRS-8, CRS-11, CRS-15, CRS-19, CRS-20) only clear at run end (death or victory)
- "Self-clears" curses (CRS-3) clear automatically per source rule
- "Per combat" curses (CRS-13) reset each combat start

### 3.4 Ascension-applied curses

Per `upgrade_trees_v0.md` §5.2, A6 modifier = Hanging Hour triggers earlier. CRS-11 (Ash-Cough) was authored above to be the A-side curse for A6. Per-rung Ascension curses don't appear as random curse-stack; they're rung-defined.

---

## 4. Anti-perma-stack rule

**Stack guard:** when a player would acquire their 4th *active, non-expired* curse, a guard prompt fires:

> "You already carry 3 of the curse's gifts. Accept this one too? [Yes] [No]"

This prevents accidental death-spiral from chained event-choice picks. The guard does not appear for Ascension modifiers (those are rung-defined, not optional).

### 4.1 Stack-cap design rationale

- 3 curses = challenging but recoverable
- 4+ curses = effectively unwinnable in most decks
- Guard surfaces the cap to the player; they can still accept (intentional ironman)
- Telemetry should track 4+ curse opt-in rate (catches cheesers / unwinnable runs)

---

## 5. Curse rarity & weighting

When randomly selected for an Ascension modifier or boss-reward-gamble or shrine-defile, curses roll on the table below:

| Severity | Examples | Roll weight |
|---|---|---|
| Light (cosmetic-tier penalty) | CRS-1, CRS-3, CRS-9, CRS-14 | 50% |
| Medium (combat-tier penalty) | CRS-2, CRS-4, CRS-6, CRS-10, CRS-12, CRS-16, CRS-17, CRS-18 | 35% |
| Heavy (run-altering) | CRS-5, CRS-7, CRS-8, CRS-11, CRS-13, CRS-15, CRS-20 | 12% |
| Catastrophic | CRS-19 (unplayable card) | 3% |

Heavy + catastrophic curses give correspondingly bigger rewards on the prompts that grant them.

---

## 6. Engine handoff

### 6.1 Resource class

`game/src/data/curse.gd`:

```
class_name Curse extends Resource

@export var id: StringName
@export var display_name: String
@export var flavour_text: String
@export var severity: GFEnums.CurseSeverity  # LIGHT / MEDIUM / HEAVY / CATASTROPHIC
@export var effect_id: StringName             # dispatched by CurseEffectResolver
@export var effect_payload: Dictionary
@export var expiry_rule: StringName           # "end_of_chapter" / "end_of_run" / "after_n_events" / "per_combat_reset"
@export var expiry_payload: int = 0           # e.g. 2 for "after_2_events" (CRS-3)
@export var removable_by_holy_water: bool = true
@export var source: StringName                # "event_E01_choice_C" / "shrine_defile" / "ascension_A6" / "boss_gamble"
```

### 6.2 GameState extensions

```
var active_curses: Array[Curse] = []  # cleared per expiry rules
var curse_chapter_marker: int = 0  # for "end_of_chapter" expiry detection

# signals
signal curse_applied(curse: Curse)
signal curse_removed(curse: Curse, reason: StringName)  # "holy_water" / "expiry" / "rest_trade"

# API
func apply_curse(curse: Curse) -> bool  # returns false if 4-cap guard prompt rejected
func remove_curse(curse_id: StringName, reason: StringName) -> bool
func get_active_curses() -> Array[Curse]
func on_chapter_advance(new_chapter: int) -> void  # iterates curses, clears chapter-bound
func on_event_resolved() -> void  # iterates "after_n_events" curses, decrements
func on_combat_start() -> void  # iterates "per_combat_reset" curses, re-applies
```

### 6.3 Effect dispatcher

`CurseEffectResolver.gd` — pure-static, mirrors `keyword_resolver.gd` pattern:

```
class_name CurseEffectResolver extends Object

static func apply_passive(curse: Curse, game_state: GameState) -> void:
    match curse.effect_id:
        &"max_hp_minus":
            game_state.max_hp -= curse.effect_payload.get("amount", 1)
        &"first_card_costs_more":
            game_state.first_card_cost_penalty = curse.effect_payload.get("amount", 1)
        # ... etc per curse
```

---

## 7. MVP coverage

| Surface | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| Curse system (data model) | — | resource + 8 event-source curses | + 12 more | full 20 | full + new per-season |
| Holy water (shop service) | — | ✅ | ✅ | ✅ | ✅ |
| REST curse-trade (R3 variant) | — | — | spec only | ✅ | ✅ |
| 4-cap guard prompt | — | ✅ | ✅ | ✅ | ✅ |
| Telemetry on curse opt-in | — | — | basic | ✅ | full dashboard |

---

## 8. Open questions for Paul

1. **4-curse cap** — confirm 4 as the soft cap (player can still accept). Alternative: hard cap (can't stack 4+ curses). Recommend soft cap, telemetry-monitor.
2. **CRS-19 The Black Writ** marks a random deck card unplayable for the run — punishing but lore-rich. Confirm willingness to include catastrophic-tier curses, or all run-altering curses cap at "heavy"?
3. **Holy water flat price (60 Gold)** vs per-severity pricing (60 / 100 / 150 Gold by curse severity). Recommend flat 60 — predictable for player. Confirm.
4. **CRS-13 (Spectral Watcher) per-combat reset** — does it pick a new enemy at each combat? Yes per spec. Confirm.

---

## 9. Cross-references

- `events_v0.md` — 8 source curses originated here (CRS-1..8 — most named in event-choice payoffs).
- `shrines_v0.md` — Defile outcomes apply CRS-9..12, CRS-16.
- `shop_economy_v0.md` §3 — Holy Water service slot, 60 Gold.
- `upgrade_trees_v0.md` §5.2 — Ascension modifiers reference CRS-11 (Ash-Cough).
- `bosses_chapters_2_3_v0.md` — bosses + curse-gambles (CRS-13, CRS-19, CRS-20).
- `keywords/hanging_hour_persist_v0.md` — CRS-8 (Tree-Named) HH interaction.

— Controller, 2026-05-21
