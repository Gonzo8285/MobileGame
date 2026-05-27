# AURA — system spec v0

**Status:** design-locked 2026-05-26 by Controller. Engine wiring DEFERRED to follow-on heartbeat (AURA.E1) — too much surface for a single pass. This doc unblocks W42.E1 (Den-Mother), the L-D3 Banner-Buff archetype payoffs (L27–L40), Iron Penitents PENANCE triggers, Bear-Skin Hierophant (W4) +2 HP grant, and any future "while X is in lane, Y" effects.

## What this is (and isn't)

This is **NOT a new keyword on the GFEnums.Keyword enum.** "Aura" is the engine plumbing that lets one unit grant stat/keyword modifications to another unit, dynamically, for as long as the granter is in lane. It's a system, not a card-facing mechanic — players never see the word "Aura" on a card. Cards say things like "your Wolf-Tokens gain +1/+1 and Lifesteal while she is in lane." The engine layer that makes those words function is what this spec defines.

It IS the missing infra under several already-authored cards. Without it those cards are text-flavour only — the engine can't actually grant the stated buffs.

## Why now

Phase 2.13 N4 (W42 Den-Mother of the Cinderwood) shipped 2026-05-26 with effect_text "Friendly Wolf-Tokens in lane gain +1/+1 and Lifesteal while she is in lane." LIFESTEAL was promoted to a real keyword 2026-05-26 (`lifesteal_v0.md`). With the keyword in place, the only thing standing between W42's effect text and a functional engine behaviour is the aura plumbing. Same blocker affects:

- **W4 Bear-Skin Hierophant** (4c R Identity): "Your highest-cost friendly Wilds unit gains +2 HP and Cleave."
- **L27 / L28 / L29 / L30 / L31 / L32 / L33 / L34 / L35 / L36 / L37 / L38 (Banner-Buff spine)**: most carry "while a friendly banner stands in this row" conditional effects — banner detection + conditional buff application is an aura case.
- **L41 Banner-Bearer of the Crowned Anvil** (Phase 2.13 N2): "While a friendly banner stands in this row, gains +1 ATK and Pierce" — same pattern.
- **C18 Old Mother Slag, C19 Drowned-King's Hag, C5 Briar-Hag** (Coven Poison-stack payoffs): while-alive enemy-debuff auras.
- **P3 Cathedral Brother** with the Phase-2.12 M6 anti-synergy flag — emergent role only legible once aura/TAUNT plumbing lands.

Authoring one system unblocks all of these. Not authoring it locks Phase 2.13 N4 + all Banner-Buff payoffs + every future "while in lane" card behind bespoke handler hooks per card, which scales badly.

## Core model

Two new fields on `UnitInstance` (`game/src/runtime/unit_instance.gd`):

```gdscript
## Runtime-granted keywords from active auras. Read by has_keyword() alongside
## the card's native keywords array. Auras push entries on grant, pop on revoke.
## Keys are the source UnitInstance (so a unit can be affected by multiple
## auras and each revoke only removes its own grants). Values are
## Array[GFEnums.Keyword] of keywords granted by THAT source.
var runtime_keywords: Dictionary = {}     ## { source_unit: Array[int] }

## Runtime stat modifiers from active auras. Same source-keyed structure so
## revokes are clean. Stat modifiers apply on top of card_data + atk_offset.
## Computed at read time by max_hp() / current_attack(); not stored on the
## raw stat fields, so the original stats remain inspectable.
var aura_stats: Dictionary = {}            ## { source_unit: { atk: int, hp: int } }
```

Three new method bands on `UnitInstance`:

```gdscript
## Grant. Called by the aura emitter when this unit becomes eligible
## (e.g. lane entry, on-summon, on the source taking the lane).
func apply_aura_grant(source: UnitInstance, atk_buff: int, hp_buff: int,
        keywords: Array[int]) -> void:
    # Atomic write — if the source already has an entry, replace it (don't
    # stack — that's intentional, see "Multi-source rules" below).
    aura_stats[source] = { "atk": atk_buff, "hp": hp_buff }
    runtime_keywords[source] = keywords.duplicate()
    # HP buff increases both max and current by the same amount (player
    # never "loses" HP they didn't see). Revoke shrinks both, clamping
    # current at the new max.
    current_hp += hp_buff

## Revoke. Called when the source leaves lane / dies / aura conditions
## fail. Pops the source's contribution out of both dicts and shrinks HP
## if hp_buff was positive.
func revoke_aura_grant(source: UnitInstance) -> void:
    var stats = aura_stats.get(source, null)
    if stats == null:
        return
    var hp_was: int = int(stats.get("hp", 0))
    aura_stats.erase(source)
    runtime_keywords.erase(source)
    if hp_was > 0:
        # Clamp current_hp at the new max — never go below 1 even if the
        # aura was the only thing keeping the unit alive (avoids killing
        # units by aura revoke; death from buff loss is too unfair).
        var new_max := max_hp()
        current_hp = min(current_hp, new_max)
        if current_hp < 1:
            current_hp = 1

## Read-side adjusted stats. card_data + atk_offset (Persist etc) + sum of
## aura_stats contributions. Used by combat code.
func max_hp() -> int:
    var base: int = card_data.hp if card_data != null else 0
    var aura_sum: int = 0
    for s in aura_stats.values():
        aura_sum += int(s.get("hp", 0))
    return base + aura_sum
```

`current_attack()` is amended the same way — sum aura `atk` contributions.

`has_keyword()` (currently on `Card`) is mirrored as a UnitInstance method that ORs the card's native list with the union of all `runtime_keywords` values.

## Multi-source rules

- **Multiple auras stack additively** for stats. Two Den-Mothers in the same lane → each Wolf-Token gets +2/+2 (not +1/+1). This makes the swarm + double-aura curve-topper a real win-con (and a balance lever — flag for C7 if it proves too strong).
- **Keyword grants don't stack** — they're set membership. Two sources granting LIFESTEAL = unit has LIFESTEAL (once). Revoking one source still leaves it from the other.
- **Sources are tracked individually** so partial revokes work cleanly. When one of two Den-Mothers dies, only her contribution is stripped — the surviving Den-Mother's grant remains intact.
- **HP buff handling on revoke** never kills the unit (clamps current_hp at 1). The alternative (allowing aura loss to kill) makes board state too brittle and creates "aura assassination" combos that don't feel earned.

## Aura emitter pattern

Each aura-source card needs:
1. An **`aura_targets(lane: Lane) -> Array[UnitInstance]`** function — defines what the aura looks for. E.g. W42's `aura_targets` returns "all friendly Wolf-Tokens in this lane."
2. An **`aura_grant_spec()`** returning the `{atk, hp, keywords}` payload.
3. The engine drives the rest: when the source enters lane, it walks `aura_targets()` and calls `apply_aura_grant()` on each. When the source leaves (dies, removed by Sacrifice, lane wipe), it walks the same set + any new arrivals since (tracked by reverse lookup on `aura_stats.keys()`) and calls `revoke_aura_grant()`.

For now (v0) these two functions are implemented as static dispatch on card ID in a single `AuraDispatch` module (`game/src/runtime/aura_dispatch.gd`). v1 polish: promote to a Card-resource property (`aura_spec: AuraSpec`) so card authors can declare auras in the .tres file rather than in code. Out of scope this pass.

## On-enter / on-leave hooks

Two new helper calls in `lane.gd`:

```gdscript
## Called from place_unit() after the unit is appended to friendly_units.
## Walks all aura sources currently in lane and lets them grant onto the
## new unit if it matches their target spec. Then, if the new unit is
## itself an aura source, grants onto all existing targets.
func _on_unit_entered_lane(new_unit: UnitInstance) -> void:
    for source in friendly_units:
        if source == new_unit:
            continue
        AuraDispatch.maybe_grant(source, new_unit, self)
    AuraDispatch.maybe_grant(new_unit, null, self)  ## null = grant onto all

## Called from _cull_dead() before the unit is removed. Walks all
## currently-affected units and revokes this source's contribution.
func _on_unit_leaving_lane(leaving_unit: UnitInstance) -> void:
    AuraDispatch.revoke_all_from(leaving_unit, self)
```

## Test scenarios (AURA.E1 — deferred)

Append `_scene_f_aura_dispatch` to `turn_engine_test.gd`:

- **F1.** W42 Den-Mother enters lane with two Wolf-Tokens already present. Both Wolf-Tokens become 2/3 with LIFESTEAL (was 1/2). Verify via `has_keyword(LIFESTEAL)` on each token + `max_hp() == 3` + `current_attack() == 2`.
- **F2.** A third Wolf-Token enters the lane after Den-Mother is already in. The new token gets the same grant on-enter.
- **F3.** Den-Mother dies (HP set to 0 + `_cull_dead()` runs). All Wolf-Tokens revert to 1/2 without LIFESTEAL. `runtime_keywords` and `aura_stats` are empty on each.
- **F4.** Two Den-Mothers in lane. Wolf-Tokens become 3/4 (additive stat stack) with LIFESTEAL once. One Den-Mother dies; Wolf-Tokens revert to 2/3 (single grant remaining) still with LIFESTEAL.
- **F5.** Wolf-Token at full HP under double Den-Mother aura (HP 4/4). One Den-Mother dies; HP clamps to 3 (new max) — not killed.
- **F6.** Wolf-Token at 1 HP under double Den-Mother aura (HP 1/4 — took 3 damage). Both Den-Mothers die; HP clamps at 1 (the "never kill via revoke" floor), not 0.

## Anti-P2W invariant

Aura plumbing is engine-level. All aura-source cards (W42, W4, banner spine, Mother Slag, etc.) are draftable commons / uncommons / rares — no IAP unlocks the aura system itself, no paid card carries an aura that free-tier cards can't. `monetisation_map.md` invariant holds.

## Open questions for Paul (none blocking)

1. **Aura affecting the source itself?** Some "aura" cards (Bear-Skin Hierophant's +2 HP grant) target a specific other unit (highest-cost Wilds). Does the source ever buff itself? My read: no — auras are outbound only. The "highest-cost Wilds" might BE the Hierophant in degenerate cases (single-unit lane), and the spec text reads to me like the Hierophant explicitly excludes itself ("YOUR highest-cost friendly Wilds unit" implies another). Worth confirming.
2. **Aura over-application — race vs combat resolution?** If an aura grant changes max_hp during the friendly-attack phase (e.g. a buff-on-attack effect), the unit's `current_hp` could change mid-iteration of `lane.friendly_units`. Recommend: aura grants/revokes are atomic per phase boundary (turn_start, post-friendly-attack, post-enemy-attack, etc), not inline mid-attack. Same model as TAUNT's "next phase" hook.
3. **Save/load.** `runtime_keywords` and `aura_stats` are derived state — on save, store nothing aura-related; on load, walk the lane and re-resolve all auras from scratch. Avoids drift between source-of-truth (card position in lane) and derived (granted buffs). Same approach Hearthstone uses.
4. **UI overlay.** Should aura'd units show a visual indicator (border glow, icon)? Out of scope this spec, but flag for collection_ui_v0.md follow-on.

## Cross-doc updates owed

- `game/src/runtime/unit_instance.gd` — add `runtime_keywords` + `aura_stats` fields + `apply_aura_grant` / `revoke_aura_grant` / `max_hp()` / amended `current_attack()` / `has_keyword()` mirror. OWED at AURA.E1.
- `game/src/runtime/aura_dispatch.gd` — NEW module, static dispatch on card ID for W42, W4, L41, banner spine, etc. OWED at AURA.E1.
- `game/src/runtime/lane.gd` — `_on_unit_entered_lane` / `_on_unit_leaving_lane` hooks called from `place_unit()` and `_cull_dead()`. OWED at AURA.E1.
- `game/src/runtime/turn_engine_test.gd` — `_scene_f_aura_dispatch` with F1–F6 above. OWED at AURA.E1.
- `keywords/lifesteal_v0.md` — cross-link to this doc under the "Granted Lifesteal (aura case)" bullet. DONE this heartbeat.
- `cards_skinward_pact_v1.md` — W42 row updated with cross-ref to this doc once AURA.E1 lands. OWED.
- `backlog.md` — file AURA.E1 + W42.E1 + L41.E1 + W4.E1 as queued engine-wiring items.
