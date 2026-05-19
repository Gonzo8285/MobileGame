# Bosses v0 — Chapter 1

_Authored 2026-05-19 by Controller. Phase 2.12 M10 deliverable. Implements the BOSS NodeKind added in B2.9 — pure design content, engine wiring is M10.E1. Chapters 2-3 deferred to IMV-2 per `internal_mvp_scope.md`._

## What a BOSS encounter is

A BOSS encounter is the terminal node of a chapter. It differs from standard combat in five ways:

1. **Hanging Hour fires at turn 4** (not turn 5) — see `keywords/hanging_hour_persist_v0.md`
2. **Wave-spawn is tri-phase** — pre-Hanging-Hour, at-Hanging-Hour, post-Hanging-Hour
3. **Boss has a signature mechanic** that defines the combat's primary tension
4. **Victory reward is a guaranteed relic + faction-matched card choice (1 of 3)**
5. **Defeat ends the run** — no retry without spending gems per `2026-05-18_gallowfell_balance.md`

## Chapter 1 boss — The Black-Bell Choir

> _He hung first. He sang the others down. He still sings, every dusk._

**Name:** The Black-Bell Choir
**Biome:** Gallows Hill (boss biome)
**Faction:** Ash-Mourners (canonical "Hanging Hour" faction)
**Signature mechanic:** Resurrection echo — every enemy that dies under the bell tolls a count. On turn 4 (Hanging Hour), all enemies that died this combat are resurrected at full stats AND inherit one keyword (Persist) from the boss.

### Stat block

- **HP:** 60 (baseline pre-scaling — Round 8 scaling per balance doc multiplies to ~73)
- **ATK:** 4 (baseline pre-scaling — Round 8 = ~7)
- **Range:** LONG (3 tiles)
- **Faction tag:** ash_mourners
- **Initial position:** rear tile of centre lane

### Signature ability: "Toll the Bell"

Activates passively. Every enemy that dies during this combat gets added to a `corpse_queue` ordered by death turn. At the Hanging Hour trigger (turn 4):
- All corpses in the queue resurrect at full HP, full ATK
- Each resurrected enemy gains the PERSIST keyword (once-per-combat, returns at ATK-1 on second death)
- The queue does NOT clear after Hanging Hour — Toll resolves once at HH, and Persist drains normally as bodies die

**Engine note:** This is the canonical use case for the `corpse_queue` data structure introduced in `keywords/hanging_hour_persist_v0.md`. The boss's "Toll the Bell" is implemented by registering a handler on the `hanging_hour_struck` signal that walks the queue and re-spawns each entry as a fresh `EnemyInstance` with PERSIST added to its keyword array.

### Wave-spawn pattern

The combat lasts a minimum of 6 turns. Wave generator schedules:

| Turn | Pre-HH (1-3) | HH (4) | Post-HH (5+) |
|---|---|---|---|
| 1 | Boss spawns rear-centre; 2× Pall-Bearer enemies front-flank | — | — |
| 2 | +1 Catacomb Cherub centre | — | — |
| 3 | +1 Carrion Hound | — | — |
| 4 | — | **Toll the Bell fires.** All dead enemies resurrect with Persist | +1 Reaper-Bell rear-centre |
| 5+ | — | — | Continued attrition. Boss focuses on lowest-HP friendly unit. |

Player wins by killing the boss. Defeating wave-enemies doesn't end combat — only boss death does. This is a notable departure from standard combat (which ends when all enemies cleared).

### Faction-flavour bind

- **Iron Penitents:** Bleed stacks survive Hanging Hour resurrection. Penance combos still work — the resurrected target is the same `EnemyInstance` with Bleed intact.
- **Coven:** Black Mire Pact (C42) procs heavily during Toll. Every resurrected enemy that dies again summons a Bog-Spawn on tile.
- **Ash-Mourners:** Mirror-match. Player's Persist units interact symmetrically with the boss's Toll. Hanging Hour fires both Toll AND the player's full-stats-Persist-restoration.
- **Last Legion:** Banner-Buff scales linearly with enemy count — Toll creates a horde, Banner's ATK-bonus shines.
- **Skinward Pact:** Transform unit can re-target post-Toll, picking the highest-HP resurrected enemy and softlocking it.

### Reward on victory

- Guaranteed **Relic of Chapter 1** drop (one of 5 chapter-1-tier relics, faction-matched to warlord)
- Standard reward screen: pick 1 of 3 cards from weighted faction pool (per B2.8)
- **+10 gems** per `2026-05-18_gallowfell_balance.md` (boss reward)

### Defeat penalty

- Run ends. No retry without gem spend per existing economy.
- Player can spend **5 gems** to retry the boss combat from scratch (mana, hand, base HP restored). Wave generator re-fires from turn 1.

## Anti-P2W invariant

Boss reads only run-level state. Toll the Bell never branches on `account.tier` or `warlord.tier`. The "Relic of Chapter 1" drop pool is run-seeded, not account-seeded. Engine MUST NOT make the boss easier for tier-4 warlords (mastery cosmetic is the only T4 reward).

## Engine wiring sketch — M10.E1

`game/data/bosses/chapter_1_black_bell_choir.tres` — new boss resource:

```
extends Enemy

# inherited fields: id, display_name, faction, base_hp, base_atk, range, keywords
# new boss-specific fields:
@export var is_boss: bool = true
@export var signature_ability_id: StringName  # "toll_the_bell"
@export var wave_schedule: WaveSpawner          # the tri-phase spawn
@export var reward_relic_pool: Array[StringName]  # the 5 chapter-1 relics
@export var defeat_retry_cost: int = 5
```

`signature_ability_id` is a soft-keyword that maps to a function in `boss_abilities.gd`. The dispatch is:

```gdscript
extends Object
class_name BossAbilities

static func dispatch(ability_id: StringName, boss: EnemyInstance, combat: Combat) -> void:
    match ability_id:
        &"toll_the_bell":
            _toll_the_bell(boss, combat)
        # future bosses register handlers here

static func _toll_the_bell(boss: EnemyInstance, combat: Combat) -> void:
    var corpses = combat.corpse_queue
    for corpse in corpses:
        var resurrected = corpse.duplicate_for_resurrection()
        if not GFEnums.Keyword.PERSIST in resurrected.keywords:
            resurrected.keywords.append(GFEnums.Keyword.PERSIST)
        combat.spawn_enemy(resurrected, corpse.tile_index)
    # queue persists post-Toll for normal Persist drain
```

`Combat.on_hanging_hour_struck` (existing from `keywords/hanging_hour_persist_v0.md`) is the signal that fires Toll's dispatch. Boss handler runs BEFORE player Persist queue per ordering rule in the HH spec.

Wave schedule lives in a normal `WaveSpawner` resource — the tri-phase nature is just rows in the spawn table. No new wave type needed.

## Tuning targets for first playtest

1. **Average boss combat length:** 7-10 turns
2. **Boss kill rate at IMV-1 deck strength:** 30-40% first-attempt, climbing to 60% after 1-2 retries
3. **Toll the Bell felt impact:** must feel like a meaningful shift, not a chore. Watch for "I lost 3 minutes of work" frustration vs "the curse really is bringing them back" satisfaction.
4. **Reward perceived value:** chapter-1 relic + card pick + 10 gems = enough to feel earned for the difficulty step

If Toll-the-Bell feels punishing, drop:
- Resurrected enemy HP to 80% of base (not full)
- OR delay Hanging Hour to turn 5 for the boss specifically (revert the boss-faster-HH from `hanging_hour_persist_v0.md`)

## Open questions for Paul

1. **Boss XP reward.** Should defeating the boss grant warlord XP toward tier progression per `warlord_tiers_v0.md`? Recommend yes, ×3 the standard combat XP — boss is the meaningful run achievement.
2. **Toll the Bell visual cue.** When HH fires, do we need a special boss-only animation (bell-toll overlay, sky darkens, etc.)? Recommend yes for IMV-2 polish, placeholder full-screen tint pulse for IMV-1.
3. **Chapter 1 relic pool composition.** I haven't specified which 5 relics drop. Recommend pulling from existing relic pool — 1 per faction (P39/P40, M39/M40, C39/C40, L39/L40, W39/W40) — but the player's warlord faction relic is removed from the drop pool to avoid dupes. So drop pool = 4 relics. Cleaner.
4. **Boss alt-art.** Boss enemies should have premium art. Spec for the Black-Bell Choir doesn't exist yet — covered separately in `art_specs/_anchors/` once D-VALIDATE-1 Stage A clears. Queued, not blocked.

## What this spec ships

- Chapter 1 boss: The Black-Bell Choir
- Signature mechanic + wave-spawn pattern
- Per-faction interaction notes
- Reward + defeat rules
- Engine handoff sketch for M10.E1
- Anti-P2W invariant restated
- Tuning targets + fallback levers

— Controller, 2026-05-19
