# Bosses v0 — Chapters 2 & 3

_Authored 2026-05-21 by Controller. Closes inventory items DES-3 + DES-4 + BOSS-3 + BOSS-4. Extends `bosses_v0.md` (Chapter 1 = The Black-Bell Choir) with the two remaining chapter bosses needed for IMV-2 + soft-launch. Follows the same template: signature mechanic + wave pattern + reward + defeat + engine sketch._

**Status:** v0 spec. Pending Paul sign-off on Open Qs.

---

## 1. What's at stake per chapter

Per `lore_gallowfell.md` biome map, the curse intensifies as the player presses deeper toward the Gallows Hill scaffold-tree. Chapter bosses escalate on three axes:

| Axis | Ch 1 (Black-Bell Choir) | Ch 2 | Ch 3 |
|---|---|---|---|
| Boss HP scaling | 60 base (Round 8 = ~73) | 80 base (Round 8 = ~98) | 100 base (Round 8 = ~123) |
| Hanging Hour | turn 4 | turn 4 + secondary at turn 8 | turn 3 + secondary at turn 6 + tertiary at turn 9 |
| Signature mechanic complexity | 1 mechanic (Toll the Bell) | 2 interlocked mechanics | 3 interlocked mechanics |
| Reward tier | guaranteed Ch1 relic | guaranteed Ch2 relic + 1 of 2 mid-tier rares | guaranteed Ch3 relic + 1 of 2 rare/legendary + Soul gain |

---

## 2. Chapter 2 boss — The Iron Communion

> _"They forged a new sacrament. They forged it from us."_

**Name:** The Iron Communion
**Biome:** The Foundry (Forgotten Parade extended)
**Faction:** The Last Legion
**Signature mechanic:** **Anvil-Strike** + **Forge-Heat Stacks** (two interlocked mechanics)

### 2.1 Stat block

- **HP:** 80 (baseline pre-scaling — Round 8 ~98)
- **ATK:** 5 (baseline pre-scaling — Round 8 ~8)
- **Range:** MELEE
- **Faction tag:** last_legion
- **Initial position:** front tile of centre lane

### 2.2 Signature ability 1: "Anvil-Strike"

Every 3 turns starting turn 3, the boss raises its hammer and slams the lane. **All friendly units in centre lane take 6 damage** (ignoring SHIELD; bypass per the lore "anvil shatters armor"). Pre-warn: turn 2/5/8 shows a red "ANVIL" overlay on the centre lane.

### 2.3 Signature ability 2: "Forge-Heat Stacks"

The boss accumulates a `forge_heat` counter. **Each enemy that dies in this combat adds +1 to forge_heat.** At each Anvil-Strike, the strike's damage is increased by `forge_heat × 1`. So:
- Turn 3 strike: 6 + 0 = 6 dmg (no kills yet usually)
- Turn 6 strike: 6 + (kills so far) dmg — grows with combat length
- Turn 9 strike: 6 + (all kills) dmg — punishes attrition decks

**Counter-pressure:** the Last Legion-flavour boss rewards killing fast. Decks that turtle accumulate forge_heat against themselves.

### 2.4 Hanging Hour interaction

- **Standard HH at turn 4:** Boss + minions gain +1 ATK (per `lore_gallowfell.md`).
- **Secondary HH at turn 8:** Anvil-Strike at turn 8 fires DOUBLE damage (12 + forge_heat). Forces final-push at this turn.

### 2.5 Wave-spawn pattern

The combat lasts a minimum of 8 turns. Wave schedule:

| Turn | Pre-anvil (1-2) | Anvil-1 (3) | Mid (4-5) | Anvil-2 (6) | Mid (7) | Anvil-2-HH (8) | Post (9+) |
|---|---|---|---|---|---|---|---|
| 1 | Boss spawns front-centre + 2× Iron-Officer flanking | — | — | — | — | — | — |
| 2 | +1 Pall-Bearer rear-centre + ANVIL warning glows | — | — | — | — | — | — |
| 3 | — | **Anvil-Strike** | — | — | — | — | — |
| 4 | — | — | +1 Forge-Cur rear-flank | — | — | — | — |
| 5 | — | — | ANVIL warning glows again | — | — | — | — |
| 6 | — | — | — | **Anvil-Strike (+forge_heat)** | — | — | — |
| 7 | — | — | — | — | +2 Iron-Officer wave-rear, ANVIL warning glows | — | — |
| 8 | — | — | — | — | — | **Anvil-Strike DOUBLE (Hanging Hour)** | — |
| 9+ | — | — | — | — | — | — | Continued attrition |

### 2.6 Faction-flavour bind

- **Iron Penitents:** Self-damage cards still work but BLEED stacks on enemies amplify forge_heat acceleration (more deaths). Bleed-stack deck wants forge_heat fast → meets cap.
- **Coven:** Swarm decks accelerate forge_heat. Bog-Spawn tokens dying to Anvil-Strike contribute. Counter-play: keep Bog-Spawns out of centre.
- **Ash-Mourners:** PERSIST units take Anvil-Strike, die, persist next turn. Two-deaths-per-unit = 2 forge_heat gain. **Worst matchup** by mechanic — playtest carefully.
- **Last Legion:** Mirror-match. Banner-Buff scaling synergises with friendly Iron-Officer if held outside centre lane. RALLY needs row-alignment which the boss disrupts (centre-lane kill pressure).
- **Skinward Pact:** Big-monster transformations soak the Anvil-Strike (one big body = 1 forge_heat instead of 4 spread). Best matchup by attrition profile.

### 2.7 Reward on victory

- Guaranteed **Relic of Chapter 2** drop (one of 5 chapter-2-tier relics, faction-matched to warlord)
- Standard reward screen: pick 1 of 3 cards from weighted faction pool — but **rare-pool weight × 2** (per chapter scaling)
- **+15 gems** (vs Ch1's +10)
- **+2 Souls** if at Ascension ≥ 5 (per `upgrade_trees_v0.md` §1 Souls earn rules)

### 2.8 Defeat penalty

- Run ends. No retry without gem spend per balance doc.
- Retry cost = 8 gems (vs Ch1's 5; per chapter scaling)

### 2.9 Tuning fallback levers

If too punishing in playtest:
- Drop Anvil-Strike damage from 6 → 5
- OR drop forge_heat scaling from ×1 → ×0.5
- OR cap forge_heat at 5

---

## 3. Chapter 3 boss — The Saint That Hangs

> _"You came so far. Did you forget her name?"_

**Name:** The Saint That Hangs
**Biome:** Gallows Hill (final boss biome)
**Faction:** None / All / Curse-bound
**Signature mechanic:** **Speak the Name** (passive) + **The Drop** (turn 9 HH) + **Hempen Witness Spawning** (interlocking)

**Lore framing:** This is the curse made flesh. The player faces what W11 *is* — an inverted boss-form of the lore-locked Saint That Should Not Hang. Beating this boss does **not** unlock W11 directly; it makes the final reveal possible.

### 3.1 Stat block

- **HP:** 100 (baseline pre-scaling — Round 8 ~123)
- **ATK:** 6 (baseline pre-scaling — Round 8 ~10)
- **Range:** LONG (3 tiles)
- **Faction tag:** neutral / cursed
- **Initial position:** rear tile, all 3 lanes (the boss is in all 3 lanes; she's the curse, not a body)
- **Special:** the boss has **3 HP bars**, one per lane. Total = 300 HP. Each lane bar drops independently. All 3 must hit 0 to win.

### 3.2 Signature ability 1: "Speak the Name" (passive)

Whenever a friendly UNIT card is played, the boss reads the unit's name aloud (text overlay). At the end of the player's next turn, **the spoken unit dies and Persists immediately** (per `keywords/persist_v0.md` mechanics). Persist returns at base ATK -1, but skips the once-per-combat lock for *this* unit.

**Counter-play:** play many cheap units (each only dies once, so Persists once; absorbs hits). Avoid playing heavy single-target units (one Persist = one death cycle minimum).

### 3.3 Signature ability 2: "The Drop" (Hanging Hour at turn 9 — tertiary HH)

At turn 9, the boss "drops" — the scaffold-rope tightens.

- All friendly units on the field die instantly
- All death-triggered effects fire (Persist, Resurrect, sacrifice payoffs)
- A new wave of "Hempen Witnesses" (1/3 per lane) spawns, taking up to all 9 tiles
- Player's deck reshuffles (mulligan-equivalent)

This is the **single most punishing moment in the game**. Decks that haven't won by turn 9 effectively reset. Forces "win by turn 8" pressure.

### 3.4 Signature ability 3: "Hempen Witness Spawning"

Hempen Witnesses (HW) are 1-HP / 3-ATK units that spawn from the boss every 2 turns starting turn 4. Each HW takes the front tile of a lane (pushing previous enemies forward). HW have **PERSIST** baseline.

### 3.5 Wave-spawn pattern

The combat lasts a minimum of 10 turns. Schedule:

| Turn | Event |
|---|---|
| 1 | Boss "spawns" (passive — visible as overlay across 3 lanes, not unit-shaped) |
| 2 | First Hempen Witness spawns in rear-centre lane |
| 3 | +2 random Pall-Bearer + Cathedral-Brother enemies, one per side lane |
| 4 | **HW spawn** (rear-centre) — typically 2nd one |
| 5 | +1 random Pall-Bearer + Marsh-Mother token from each side lane |
| 6 | **HW spawn** |
| 7 | +2 random enemy waves to all lanes, "Speak the Name" callouts visible all session |
| 8 | **HW spawn** |
| 9 | **THE DROP** — all friendly units die + Persist + HW × 3 spawn + deck reshuffle |
| 10+ | Final attrition — boss focuses fire on highest-HP friendly unit |

### 3.6 Faction-flavour bind

- **Iron Penitents:** Sacrifice + self-damage decks accept the Drop natively. Pre-Drop death-feeds Persist activations.
- **Coven:** Bog-Spawn tokens are PERSIST-immune (tokens excluded per `keywords/persist_v0.md`). Token-spam is the strongest counter to Speak the Name *if* the player can keep replenishing.
- **Ash-Mourners:** Speak the Name + the player's own PERSIST stack — units cycle through 2 deaths each. Tank-and-revive is the canonical approach.
- **Last Legion:** ECHO keyword duplicates spell-casts post-Drop, giving sustain. RALLY is broken by the Drop. Banner needs to come back after Drop.
- **Skinward Pact:** Transformation chains push past the Drop — transformed bigger bodies count as new units, so Speak doesn't accumulate naming-debt on them. Skinward is the **easiest** matchup if played well.

### 3.7 Reward on victory

- Guaranteed **Relic of Chapter 3** drop (one of 5 chapter-3-tier relics, *not* faction-matched — these are the lore-deep neutral relics)
- Reward screen: pick 1 of 3 cards from a **legendary pool** (Epic + Legendary weighted heavily; first time in game where Legendary drops are possible)
- **+25 gems** (vs Ch2's +15)
- **+3 Souls** if at Ascension ≥ 5
- **W11 unlock trigger:** if this is the player's 10th unique-Warlord run-victory, the W11 "Saint That Should Not Hang" unlock fires here (per `warlords_v1.md` §11)
- **Run completion** — the campaign is "won". Map transitions to a victory screen (per inventory GP-6).

### 3.8 Defeat penalty

- Run ends. Retry cost = 12 gems
- **Special "Almost There" path:** if defeated past turn 8 (i.e. survived the Drop and got close), the retry cost drops to 8 gems. Encourages near-victory replay.

### 3.9 Tuning fallback levers

If too punishing in playtest:
- Move The Drop to turn 10 (less compressed)
- OR don't reshuffle deck on Drop (keep hand intact)
- OR HW base ATK 2 instead of 3

---

## 4. Engine handoff

### 4.1 Resource extensions

Per `bosses_v0.md` Engine Wiring §M10.E1 sketch, Boss Resource already has:

```
extends Enemy

@export var is_boss: bool = true
@export var signature_ability_id: StringName
@export var wave_schedule: WaveSpawner
@export var reward_relic_pool: Array[StringName]
@export var defeat_retry_cost: int = 5
```

For chapters 2-3, extend with:

```
@export var hp_pool_count: int = 1  # 1 for ch1/2 (single HP bar), 3 for ch3 ("all 3 lanes" boss)
@export var per_lane_hp: int = -1   # -1 = use base_hp; if hp_pool_count > 1, split

@export var secondary_hh_turn: int = -1  # -1 = no secondary HH; 8 for ch2; -1 for ch1/3
@export var tertiary_hh_turn: int = -1   # -1 = no tertiary; 9 for ch3

@export var passive_ability_id: StringName = &""  # "speak_the_name" for ch3
```

### 4.2 BossAbilities dispatch

Extend `boss_abilities.gd`:

```
static func dispatch(ability_id: StringName, boss: EnemyInstance, combat: Combat) -> void:
    match ability_id:
        &"toll_the_bell":
            _toll_the_bell(boss, combat)
        &"anvil_strike":
            _anvil_strike(boss, combat)
        &"the_drop":
            _the_drop(boss, combat)

static func _anvil_strike(boss: EnemyInstance, combat: Combat) -> void:
    var damage = 6 + boss.get_meta(&"forge_heat", 0)
    var is_hh = (combat.turn_number == 4 or combat.turn_number == 8)
    if combat.turn_number == 8:
        damage *= 2  # secondary HH amplifier
    var lane = combat.centre_lane()
    for unit in lane.friendly_units():
        unit.hp -= damage  # ignores SHIELD per spec
        if unit.hp <= 0:
            combat.cull_friendly(unit)

static func _the_drop(boss: EnemyInstance, combat: Combat) -> void:
    # Kill all friendly units
    for lane in combat.lanes:
        for unit in lane.friendly_units():
            combat.kill_friendly_with_death_triggers(unit)
    # Reshuffle deck
    combat.reshuffle_deck()
    combat.deal_opening_hand(5)
    # Spawn Hempen Witnesses
    for lane in combat.lanes:
        var hw = EnemyInstance.from_template("hempen_witness")
        combat.spawn_enemy(hw, lane.idx, 0)  # front tile
```

### 4.3 Passive ability dispatch

For ch3 `speak_the_name`:
```
# Combat.gd
func on_unit_played(unit: UnitInstance) -> void:
    if active_boss != null and active_boss.passive_ability_id == &"speak_the_name":
        # Queue this unit for forced-Persist at next turn end
        forced_persist_queue.append(unit)

# at turn-end
func _on_turn_ended():
    for unit in forced_persist_queue:
        if unit.is_alive():
            unit.hp = 0
            TurnEngine._pending_persists.append(unit)  # bypasses once-per-combat lock
    forced_persist_queue.clear()
```

### 4.4 Multi-lane HP boss (ch3)

```
# EnemyInstance extension
var per_lane_hp: Array[int] = []  # indexed by lane_idx
func is_dead() -> bool:
    if per_lane_hp.size() == 0:
        return hp <= 0
    return per_lane_hp.all(func(x): return x <= 0)
func take_lane_damage(lane_idx, dmg):
    per_lane_hp[lane_idx] -= dmg
```

---

## 5. Chapter-tier relic pools

Per `upgrade_trees_v0.md` §6.3 relic catalogue:

### 5.1 Chapter 1 pool (already named)
- R-PEN-4 Brass Suffering-Mask
- R-MOU-4 Pall-Bearer's Sash
- R-COV-4 The Hoofprint Locket
- R-SKW-4 God-Tree Seed-Husk
- (placeholder ch1-tier Legion relic — not yet specified; add as part of UPG-5 polish)

### 5.2 Chapter 2 pool (new, ch2-tier relics — 5 total)

| ID | Name | Effect |
|---|---|---|
| R-CH2-1 | The Forge-Maw | At Hanging Hour, your strongest unit gains CLEAVE for the rest of combat |
| R-CH2-2 | The Anvil-Sigil | Anvil-Strike-style boss attacks deal 50% damage to your units only (the boss's own mechanic backfires against itself, narrative justification: "the sigil drinks the strike") |
| R-CH2-3 | Soot-Coated Vow | Your run starts with all enemy first-strike turns SLOW-1 |
| R-CH2-4 | The Cooled Iron | Your max mana cap +1 (=9 instead of 8) — single Mana-cap exception in the game; lore: "the forge stops adding heat" |
| R-CH2-5 | The Wax-Sealed Sigil | Cursed treatments equipped grant the equipped card +1 to its primary stat in combat (paywall guard: see Open Q 1) |

**Anti-P2W note on R-CH2-5:** **flagged.** This is the ONLY relic that gives gameplay benefit from cosmetic state. Recommend redesign — see Open Q 1.

### 5.3 Chapter 3 pool (new, ch3-tier relics — 5 total, neutral/lore-deep)

| ID | Name | Effect |
|---|---|---|
| R-CH3-1 | The Spoken Name | Once per run, prevent a death via "the curse forgets your name briefly" — chosen friendly unit returns to 1 HP |
| R-CH3-2 | The Rope-Mark Pendant | Persist returns at base ATK +0 (no -1 debuff) for the remainder of this run |
| R-CH3-3 | The Hung Crown | At run-victory, gain +3 extra Souls |
| R-CH3-4 | The Last Confession | After each combat, if a unit died, draw a card |
| R-CH3-5 | The Tree-Carved Name | Reanimation curse % triples in your favour (player-controlled raised enemies) |

---

## 6. MVP coverage

| Boss | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| Black-Bell Choir (Ch1) | spec only | engine wired (M10.E1) | ✅ | ✅ | ✅ |
| Iron Communion (Ch2) | — | spec only | engine wired | ✅ | ✅ |
| Saint That Hangs (Ch3) | — | — | spec only | engine wired | ✅ |
| Ch2 relic pool | — | spec only | 3 of 5 | full 5 | full |
| Ch3 relic pool | — | — | spec only | 3 of 5 | full 5 |

---

## 7. Open questions for Paul

1. **R-CH2-5 Wax-Sealed Sigil** breaks the anti-P2W invariant by tying gameplay to cosmetic state. Redesign options: (a) drop the relic entirely; (b) re-flavour as Cursed-CARD-type (not Cursed-treatment) — the player must own the *card* with the relic; (c) remove the cosmetic linkage and make it a generic "+1 stat for cards with Persist". Recommend option (c). Confirm.
2. **Chapter 3 boss difficulty.** The Drop at turn 9 is very punishing. Alternative: turn 10. Confirm 9 vs 10.
3. **Saint That Hangs as multi-lane boss (3 HP bars)** vs single-HP-bar. Multi-lane reads "the curse fills the field"; single-HP is more concrete but less narrative. Recommend multi-lane. Confirm.
4. **W11 unlock condition.** Per `warlords_v1.md` open Q2, current rule = "beat campaign with all 10 others". Add: triggered specifically at Ch3 boss victory. Confirm.
5. **Ch2 Iron Communion faction.** Last Legion fits The Foundry biome best. Alternative: Iron Penitents (cathedral-anvil overlap). Recommend Last Legion. Confirm.

---

## 8. Cross-references

- `bosses_v0.md` — Chapter 1 boss spec.
- `keywords/hanging_hour_persist_v0.md` — HH trigger contract.
- `keywords/persist_v0.md` — Persist mechanics.
- `lore_gallowfell.md` — biome map + faction lore.
- `warlords_v1.md` §11 — W11 unlock criterion.
- `upgrade_trees_v0.md` §6 — chapter-tier relic pools.
- `gameplay_keywords_resolution_v0.md` §10 — anti-soft-lock curse-tick (applies to bosses too).
- `2026-05-18_gallowfell_balance.md` — chapter scaling formula.

— Controller, 2026-05-21
