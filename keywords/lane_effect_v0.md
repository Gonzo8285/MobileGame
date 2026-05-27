# LaneEffect — system spec v0

**Status:** design-locked 2026-05-27 by Controller (hourly backlog cycle #20). Engine wiring DEFERRED to follow-on heartbeats (LE.E1 + LE.E2 + LE.E3 + LE.E4) — multiple subclasses + dispatch surface, won't fit one pass. This doc unblocks LD3.E1 (L27–L40 Banner-Buff spine batch), C42 Black Mire Pact (first lane-wide passive trap from M2 sacrifice-loop hardening), and gives `SmokeTile` a real base class to extend (the pseudocode in `gameplay_keywords_resolution_v0.md` §6.2 declares `class_name SmokeTile extends LaneEffect` but the base class doesn't exist).

Companion to `aura_v0.md`. AURA is **unit-to-unit grants** (one UnitInstance buffing another). LaneEffect is **lane- or tile-scoped persistent state** that is NOT attached to a UnitInstance. The two systems compose: a BANNER_TOKEN LaneEffect satisfies a predicate that the AURA dispatch table reads to decide whether to grant L41's self-aura.

## 1. What this is (and isn't)

LaneEffect is a **lightweight RefCounted holder** for combat-scoped, lane-anchored state. It is NOT:

- A UnitInstance (no HP, no ATK, can't be targeted by combat attacks, doesn't occupy the unit collision tile from the attacker's POV).
- An aura source (auras read `lane.lane_effects` but the LaneEffect itself doesn't call `apply_aura_grant`; the AURA dispatch hook does).
- A persistent run-level resource (LaneEffects are wiped at `Combat.cleanup()` — they do not survive to the next combat).
- A new GFEnums.Keyword (same logic as AURA — players never see "LaneEffect" on a card; cards just say things like "Banner-Token", "Smoke-tile", "While this trap is in lane …").

It IS the missing piece of engine plumbing under three named mechanics:

1. **BANNER_TOKEN** — placed by Last Legion spells / traps / dedicated spawners (L13 Banner-Standard / L32 Crown-Mark Standard / L33 Banner-Captain / L36 / L37 / L40 — see `cards_last_legion_v1.md` Open Q2). LD3.E1 (12-card Banner-Buff spine dispatch entries) is gated on this.
2. **SACRIFICE_PAYOFF** (C42 Black Mire Pact) — Coven 2c TRAP, lane-wide: "Each time a friendly unit dies in this lane this combat, summon a 0/1 Bog-Spawn on that tile. (3 charges, then expires.)" First lane-wide passive trap. Flagged for engine work in M2 sacrifice-loop hardening (cards_coven_v1.md line 219).
3. **SMOKE_TILE** — `gameplay_keywords_resolution_v0.md` §6.2 already declares `class_name SmokeTile extends LaneEffect`. The base class doesn't exist; SmokeTile's pseudocode is currently dangling.

Authoring one base class + a dispatch hub unblocks all three. Bespoke per-card handlers would scale badly (the Banner-Buff spine alone is 12 cards plus L41 plus L34 Crowned Anvil Standard, all reading the same banner-presence predicate).

## 2. Why now

Three independent design lanes converged on a shared blocker this week:

- **2026-05-26** (Phase 2.13 N2 ship): L41 Banner-Bearer authored with "while a friendly banner stands in this row" conditional. The aura system was authored same heartbeat (`aura_v0.md`) but its dispatch table for L41 explicitly notes (per `aura_dispatch.gd` lines 46–50 + 312) that BANNER_TOKEN LaneEffect detection is owed.
- **2026-05-10** (M2 sacrifice-loop hardening ship): C42 Black Mire Pact authored. `cards_coven_v1.md` line 219 flags "C42 is the first lane-wide passive trap — needs a `LaneEffect` Resource separate from per-tile `Trap` instances."
- **2026-04-30** (gameplay_keywords_resolution_v0.md §6 SMOKE): `SmokeTile extends LaneEffect` declared in pseudocode without a base class.

Without LaneEffect:
- LD3.E1 stays blocked (12+ Banner-Buff dispatch entries that can't fire).
- C42 stays as text-only flavour — Coven Sacrifice combo archetype loses its archetype-payoff lane-wide trap.
- SmokeTile pseudocode stays dangling — M5 TAUNT keyword spec resolved engine wiring for TAUNT but SMOKE engine wiring still depends on this spec.

Authoring this spec also forward-loads:
- **PASSIVE_AURA_LANE** (future generic) — for any future "while this trap/spell/relic is in lane, …" card.
- **POISON_FOG / ROOT_VINE / DREAD_AURA** (future) — Coven and Penitent late-game design space is heavy in lane-wide debuff zones.

## 3. Core model

### 3.1 Base class — `game/src/runtime/lane_effect.gd`

```gdscript
class_name LaneEffect extends RefCounted

## What kind of effect this is. Per-kind handler logic lives in
## lane_effect_dispatch.gd. See GFEnums.LaneEffectKind.
var kind: int = -1

## Back-reference to the lane that owns this effect. Set by Lane.add_lane_effect.
## Cleared on remove. Used by handler functions to query other lane state.
var lane: Lane = null

## Side that owns this effect. PLAYER or ENEMY. Banner-Tokens are PLAYER-only;
## Smoke-Tiles can belong to either; Sacrifice-Payoff is PLAYER-only at v0.
var owner_side: int = -1                    ## GFEnums.Side

## Source card id for traceability (e.g. &"L13" for a Banner-Token placed by
## L13, &"C42" for Black Mire Pact). Empty StringName for engine-spawned
## effects (none at v0 — every LaneEffect ships from a card).
var source_card_id: StringName = &""

## Tile index for tile-bound effects; -1 for lane-wide effects. SMOKE_TILE
## uses 0..tile_count-1; BANNER_TOKEN uses tile_idx of the placing spell's
## target tile (or -1 for lane-wide banners — open Q2); SACRIFICE_PAYOFF is
## always lane-wide (tile_idx = -1).
var tile_idx: int = -1

## Lifetime gates. -1 = unlimited / combat-duration.
var duration_turns: int = -1                ## Decrements on turn_ended; expires at 0.
var charges: int = -1                       ## Decrements on charge_consumed; expires at 0.

## Kind-specific payload. Keep handler-local; do not read in generic code.
## SMOKE_TILE: { "miss_chance": 0.5 }
## BANNER_TOKEN: { "banner_class": "crowned_anvil" }  (open Q4)
## SACRIFICE_PAYOFF: { "spawn_card_id": &"C1", "spawn_atk": 0, "spawn_hp": 1 }
var payload: Dictionary = {}

## --- Lifecycle signals (subscribed by handlers + Combat for telemetry) ---

signal applied(self_ref: LaneEffect)
signal expired(self_ref: LaneEffect, reason: StringName)  ## &"duration" | &"charges" | &"combat_end" | &"explicit"
signal charge_consumed(self_ref: LaneEffect, remaining: int)
signal tick(self_ref: LaneEffect)             ## per turn_end, before duration decrement
```

**Why RefCounted, not Resource:** LaneEffect is combat-scoped runtime state. Resources have `.tres` persistence semantics, which is wrong here — we never want a save file to contain Banner-Tokens. The card that spawns the LaneEffect IS a Resource; the LaneEffect itself is just a runtime side-effect of that card resolving.

### 3.2 New enum — `GFEnums.LaneEffectKind`

```gdscript
enum LaneEffectKind {
    BANNER_TOKEN = 0,       ## L-faction Banner-Buff payoff: passive marker, no own behaviour.
    SMOKE_TILE = 1,         ## Per gameplay_keywords_resolution_v0.md §6: 50% miss-chance, duration.
    SACRIFICE_PAYOFF = 2,   ## C42: on friendly death in lane, spawn token; charge-gated.
    PASSIVE_AURA_LANE = 3,  ## Generic v1 slot — reserved for future "while in lane" cards.
}
```

`PASSIVE_AURA_LANE` is **reserved** at v0 — no card uses it yet. Reserved so a future generic case lands as a kind-3 dispatch entry rather than requiring an enum migration.

### 3.3 New `GFEnums.Side` (if not already present)

```gdscript
enum Side {
    PLAYER = 0,
    ENEMY = 1,
    NEUTRAL = 2,  ## Reserved for environmental effects (Hanging Hour ambient, future map-node curses).
}
```

Currently the engine uses `friendly_units` / `enemy_units` array partitioning on Lane, which encodes side implicitly. A formal Side enum lets LaneEffect declare ownership unambiguously without inferring from array membership. If a `Side` enum already exists under another name (search `game/src/data/enums.gd` before adding), reuse the existing — don't duplicate.

### 3.4 Lane changes — `game/src/runtime/lane.gd`

```gdscript
## New field on Lane.
var lane_effects: Array[LaneEffect] = []

## --- Public API ---

func add_lane_effect(le: LaneEffect) -> void:
    if le == null:
        return
    if le in lane_effects:
        return  # idempotent — same instance can't be added twice
    le.lane = self
    lane_effects.append(le)
    LaneEffectDispatch.on_applied(le)
    le.applied.emit(le)

func remove_lane_effect(le: LaneEffect, reason: StringName = &"explicit") -> void:
    if le == null:
        return
    if not (le in lane_effects):
        return
    lane_effects.erase(le)
    LaneEffectDispatch.on_expired(le, reason)
    le.expired.emit(le, reason)
    le.lane = null

func get_lane_effects_by_kind(kind: int) -> Array[LaneEffect]:
    var out: Array[LaneEffect] = []
    for le in lane_effects:
        if le.kind == kind:
            out.append(le)
    return out

func has_friendly_banner() -> bool:
    ## Helper consumed by aura_dispatch._is_friendly_banner_in_lane.
    ## TRUE if ANY BANNER_TOKEN LaneEffect with owner_side == PLAYER is in the lane.
    ## Does NOT include L34 Crowned Anvil Standard — that's a UnitInstance check,
    ## handled by aura_dispatch separately (see Open Q4).
    for le in lane_effects:
        if le.kind == GFEnums.LaneEffectKind.BANNER_TOKEN and \
           le.owner_side == GFEnums.Side.PLAYER:
            return true
    return false

func clear_lane_effects() -> void:
    ## Called from Combat.cleanup() — flushes everything with reason="combat_end".
    var to_clear := lane_effects.duplicate()
    for le in to_clear:
        remove_lane_effect(le, &"combat_end")
```

### 3.5 Dispatch hub — `game/src/runtime/lane_effect_dispatch.gd`

Static module, mirrors `aura_dispatch.gd` + `boss_abilities.gd` pattern.

```gdscript
class_name LaneEffectDispatch extends RefCounted

## Called by Lane.add_lane_effect after the effect is registered.
## Hands off to the per-kind on_applied handler.
static func on_applied(le: LaneEffect) -> void:
    match le.kind:
        GFEnums.LaneEffectKind.BANNER_TOKEN:
            _banner_on_applied(le)
        GFEnums.LaneEffectKind.SMOKE_TILE:
            _smoke_on_applied(le)
        GFEnums.LaneEffectKind.SACRIFICE_PAYOFF:
            _sacrifice_on_applied(le)
        GFEnums.LaneEffectKind.PASSIVE_AURA_LANE:
            pass  # v1 reserved; no v0 dispatch
        _:
            push_warning("LaneEffectDispatch.on_applied: unknown kind %d" % le.kind)

## Called by Lane.remove_lane_effect before the effect is dereffed.
static func on_expired(le: LaneEffect, reason: StringName) -> void:
    match le.kind:
        GFEnums.LaneEffectKind.BANNER_TOKEN:
            _banner_on_expired(le, reason)
        GFEnums.LaneEffectKind.SMOKE_TILE:
            _smoke_on_expired(le, reason)
        GFEnums.LaneEffectKind.SACRIFICE_PAYOFF:
            _sacrifice_on_expired(le, reason)
        _:
            pass

## Called by Combat._on_unit_killed (PLAYER deaths only, after cull) so
## SACRIFICE_PAYOFF handlers see a clean lane state.
static func on_friendly_unit_died(lane: Lane, victim: UnitInstance) -> void:
    for le in lane.lane_effects:
        if le.kind == GFEnums.LaneEffectKind.SACRIFICE_PAYOFF and \
           le.owner_side == GFEnums.Side.PLAYER:
            _sacrifice_on_friendly_death(le, victim)

## Called by TurnEngine end-of-turn phase (after DoT tick, before friendly
## attacks). Lets effects tick duration / fire on_turn_end behaviour.
static func on_turn_ended(lane: Lane) -> void:
    var to_expire: Array[LaneEffect] = []
    for le in lane.lane_effects:
        le.tick.emit(le)
        match le.kind:
            GFEnums.LaneEffectKind.SMOKE_TILE:
                _smoke_on_turn_ended(le)
        if le.duration_turns > 0:
            le.duration_turns -= 1
            if le.duration_turns == 0:
                to_expire.append(le)
    for le in to_expire:
        lane.remove_lane_effect(le, &"duration")

## --- Banner-Token handler ---

static func _banner_on_applied(le: LaneEffect) -> void:
    # Trigger aura re-eval — any L41-type self-aura that reads banner-presence
    # needs a chance to grant retroactively.
    if le.lane != null:
        AuraDispatch.re_evaluate_self_auras(le.lane, null)

static func _banner_on_expired(le: LaneEffect, _reason: StringName) -> void:
    # Trigger aura re-eval — L41 / Banner-Buff spine self-auras revoke
    # if banner-presence flips false.
    if le.lane != null:
        AuraDispatch.re_evaluate_self_auras(le.lane, null)

## --- Smoke-Tile handler ---

static func _smoke_on_applied(_le: LaneEffect) -> void:
    pass  # Smoke takes effect on attack-resolve; no eager work.

static func _smoke_on_expired(le: LaneEffect, _reason: StringName) -> void:
    le.tick.emit(le)  # final smoke_cleared mirror; UI listener can detatch

static func _smoke_on_turn_ended(_le: LaneEffect) -> void:
    pass  # duration decrement handled by the generic on_turn_ended driver

## --- Sacrifice-Payoff handler (C42 Black Mire Pact) ---

static func _sacrifice_on_applied(_le: LaneEffect) -> void:
    pass  # No eager work; trap awaits friendly death.

static func _sacrifice_on_expired(_le: LaneEffect, _reason: StringName) -> void:
    pass  # No cleanup needed; RefCounted dereffed by Lane.

static func _sacrifice_on_friendly_death(le: LaneEffect, victim: UnitInstance) -> void:
    if le.charges <= 0:
        return  # exhausted; expire-on-tick will collect
    # Spawn a 0/1 Bog-Spawn (or whatever payload says) on victim's tile.
    var spawn_id: StringName = le.payload.get("spawn_card_id", &"C1")
    var spawn_card: Card = CardLoader.load_card_by_id(spawn_id)  # cached in v1
    if spawn_card == null:
        push_warning("SACRIFICE_PAYOFF: spawn card %s not found" % spawn_id)
        return
    var spawn_unit: UnitInstance = UnitInstance.new(spawn_card)
    spawn_unit.is_token = true
    if le.lane != null:
        # Use victim's last tile_idx — Combat sets victim.tile_idx pre-erase.
        le.lane.place_unit(spawn_unit, victim.tile_idx)
    le.charges -= 1
    le.charge_consumed.emit(le, le.charges)
    if le.charges <= 0:
        # Expire on the same tick via Combat's expire-collector;
        # don't remove mid-dispatch (Lane.remove during a friendly-death
        # cascade is iteration-unsafe).
        le.duration_turns = 0
```

### 3.6 Combat hook integration

```gdscript
## In combat.gd::_on_unit_killed (existing function), after the cull pass:
func _on_unit_killed(lane: Lane, victim: UnitInstance) -> void:
    # existing PERSIST queue capture stays:
    if not victim.is_token and \
       victim.card_data.has_keyword(GFEnums.Keyword.PERSIST) and \
       not victim.has_persisted:
        _pending_persists.append(victim)
    # NEW: SACRIFICE_PAYOFF dispatch (friendly-only at v0).
    if victim in lane.friendly_units_alive_before_cull:  # see implementation note
        LaneEffectDispatch.on_friendly_unit_died(lane, victim)
    # existing M41.E1 Mourner discount trigger stays unchanged.

## In turn_engine.gd::end_turn (existing function), after DoT tick:
LaneEffectDispatch.on_turn_ended(lane)
## ...before friendly attacks.

## In combat.gd::cleanup() (existing function), at the top:
for lane in lanes:
    lane.clear_lane_effects()
```

**Implementation note on "friendly_units_alive_before_cull":** Combat's existing cull pass erases the dying unit from `friendly_units` BEFORE `_on_unit_killed` fires. To know whether the victim was friendly, either (a) capture a snapshot before cull, (b) pass a `was_friendly: bool` flag through the kill signal, or (c) check `victim.faction in PLAYER_FACTIONS`. Pick whichever fits the existing kill-signal shape — (c) is the cheapest if the faction enum already partitions cleanly.

### 3.7 Card-side wiring (LE.E2 + LE.E3)

For BANNER_TOKEN, the placing card's resolver (Spell / Trap / on-summon UNIT) constructs a LaneEffect with:

```gdscript
var banner := LaneEffect.new()
banner.kind = GFEnums.LaneEffectKind.BANNER_TOKEN
banner.owner_side = GFEnums.Side.PLAYER
banner.source_card_id = &"L13"  # or whichever placer
banner.tile_idx = -1             # banners are row-scoped (open Q2)
banner.duration_turns = -1       # combat-duration
banner.charges = -1
banner.payload = {"banner_class": "crowned_anvil"}  # open Q4
target_lane.add_lane_effect(banner)
```

For C42 Black Mire Pact, the TRAP resolver constructs:

```gdscript
var trap_le := LaneEffect.new()
trap_le.kind = GFEnums.LaneEffectKind.SACRIFICE_PAYOFF
trap_le.owner_side = GFEnums.Side.PLAYER
trap_le.source_card_id = &"C42"
trap_le.tile_idx = -1
trap_le.duration_turns = -1
trap_le.charges = 3                   # 3 friendly deaths, then expire
trap_le.payload = {
    "spawn_card_id": &"C1",            # Bog-Spawn token
    "spawn_atk": 0,
    "spawn_hp": 1,
}
target_lane.add_lane_effect(trap_le)
```

For SmokeTile (refactoring the §6.2 pseudocode):

```gdscript
var smoke := LaneEffect.new()
smoke.kind = GFEnums.LaneEffectKind.SMOKE_TILE
smoke.owner_side = caster_side
smoke.source_card_id = &"M-smoke-source-id"
smoke.tile_idx = target_tile_idx
smoke.duration_turns = caster_duration
smoke.payload = {"miss_chance": 0.5}
target_lane.add_lane_effect(smoke)
```

## 4. Aura-system integration

`aura_dispatch.gd::_is_friendly_banner_in_lane` (current state per `aura_v0.md` + `aura_dispatch.gd` lines 46–50 + 312) reads only friendly L34 Crowned Anvil Standard alive in lane. After LE.E2, the predicate extends to:

```gdscript
static func _is_friendly_banner_in_lane(lane: Lane, excluding: UnitInstance) -> bool:
    # Path A: dedicated BANNER_TOKEN LaneEffects (new).
    if lane.has_friendly_banner():
        return true
    # Path B: friendly L34 Crowned Anvil Standard alive in lane (existing).
    for u in lane.friendly_units:
        if u == excluding:
            continue
        if not u.is_alive():
            continue
        if u.card_data == null:
            continue
        if u.card_data.id == &"L34":
            return true
    return false
```

Both paths satisfy L41's self-aura predicate. Banner placers (L13 / L32 / L33 / L36 / L37 / L40) post a BANNER_TOKEN LaneEffect; L34 alive-in-lane stays as the unit-side fallback. Either route flips the predicate true.

## 5. Lifecycle, persistence, anti-P2W

### 5.1 Lifecycle summary

| Event | What happens |
|-------|--------------|
| Card resolves (Spell / Trap / on-summon) | `LaneEffect.new()` → fields set → `lane.add_lane_effect(le)` |
| Add | `lane_effects.append`, `LaneEffectDispatch.on_applied`, `applied` signal emit |
| Turn ended | `LaneEffectDispatch.on_turn_ended` (per lane): tick signal + duration decrement |
| Friendly unit died | `LaneEffectDispatch.on_friendly_unit_died` (from Combat._on_unit_killed): each SACRIFICE_PAYOFF handler called |
| Charges exhausted | Handler sets `duration_turns = 0` so the next turn-end driver removes it |
| Duration reaches 0 | Lane.remove_lane_effect with reason="duration" |
| Combat ends | `Combat.cleanup` → `lane.clear_lane_effects()` for every lane with reason="combat_end" |

### 5.2 Persistence

**LaneEffects do NOT persist beyond combat.** No save-file representation. No run-state representation. They are pure runtime side-effects of in-combat card resolves.

A future "Relic that grants permanent lane-effect X for the rest of the run" would NOT be modelled as a persistent LaneEffect — it would be modelled as a Relic that posts a fresh LaneEffect at the start of every combat. Keeps LaneEffect single-purpose.

### 5.3 Anti-P2W invariant (restated)

LaneEffect handlers MUST NOT read:
- `CardInstance.treatment_id` (cosmetic Foil / Gold / Prism / Ink / Cursed / Ultimate state — `T1` Phase 2.10 spec)
- `CardInstance.alt_art_id` (cosmetic skin choice)
- `CardInstance.acquired_via` (gacha / IAP / event / starter — provenance)
- `GameState.warlord_xp` or `GameState.xp_multiplier_sources` (Phase 2.7 Warlord-tier system)
- Any monetisation entitlement (battle-pass tier, store-bundle ownership, etc.)

This invariant is restated wholesale from `aura_v0.md` §"Anti-P2W invariant" + `m41.E1` engine wiring. The cosmetic state lives on CardInstance only; the gameplay layer (Card resource + LaneEffect + UnitInstance combat state) never branches on it.

## 6. Multi-effect rules

### 6.1 Same-kind stacking

| Kind | Stacking rule |
|------|---------------|
| BANNER_TOKEN | Independent. Multiple Banner-Tokens in the same lane each occupy a slot in `lane_effects`. `has_friendly_banner()` returns true if **≥1** banner; the L41 / Banner-Buff spine self-aura grants are NOT additive on multiple banners (single-banner-grants-once semantics — see `cards_last_legion_v1.md` Open Q3 on multi-banner stacking). |
| SMOKE_TILE | Per `gameplay_keywords_resolution_v0.md` §6.3: durations sum, capped at 6 turns. Miss-chance does NOT compound (max stays 50%). Implementation: same-tile, same-kind dispatch sums into the existing instance's `duration_turns` instead of appending a new instance — open Q3 confirms. |
| SACRIFICE_PAYOFF | Independent. Two C42s in the same lane = 6 charges total (3 each), with the lower-tile-idx C42 consuming first (deterministic tie-break by `lane_effects` insertion order). |
| PASSIVE_AURA_LANE | Reserved; rule TBD when first PASSIVE_AURA_LANE card lands. |

### 6.2 Cross-kind interactions

- **BANNER_TOKEN + SMOKE_TILE same tile:** independent. Banner gives row-wide aura permission; smoke gives tile-local miss-chance. They don't conflict.
- **BANNER_TOKEN + SACRIFICE_PAYOFF same lane:** independent. A friendly unit dying triggers C42's sacrifice payoff; the banner predicate continues to satisfy regardless of who died (the banner-token itself is not a unit and doesn't die).
- **SACRIFICE_PAYOFF + PERSIST (open Q5):** does C42 trigger on the initial death OR on every Persist-back-and-die? **Lean: initial death only.** A Persist-back unit's eventual death is the unit's "second death" — already-tagged. Implementation: capture `victim.has_persisted` BEFORE applying Persist; if true, don't fire SACRIFICE_PAYOFF on the second death. Confirm with Paul before LE.E3 ships.
- **SACRIFICE_PAYOFF + LIFESTEAL:** orthogonal. Heal happens on attacker side; sacrifice payoff happens on lane-effect side. No interaction.

## 7. Engine-wiring follow-on items (queued for Phase 2.16)

- **LE.E1** — Implement base LaneEffect class + GFEnums.LaneEffectKind + Lane.lane_effects registry + Lane.add/remove/get/has_friendly_banner/clear API + LaneEffectDispatch hub. Combat hook integration (kill signal + turn-end driver + cleanup flush). No card-side wiring at this step — just plumbing. Test: scene I in `turn_engine_test.gd` exercising add → tick → expire-by-duration + add → charge_consumed → expire-by-charges + add → cleanup → expire-by-combat-end with the appropriate signal-emit asserts.
- **LE.E2** — BANNER_TOKEN dispatch + aura_dispatch._is_friendly_banner_in_lane extension to read `lane.lane_effects`. Card-side wiring for the first Banner placer (L13 chosen as canonical test path). Test: scene J asserting L41 self-aura grants when L13 places a BANNER_TOKEN, revokes when banner is cleared by combat-end.
- **LE.E3** — SACRIFICE_PAYOFF dispatch + C42 Black Mire Pact card resolver. Test: scene K asserting 3-friendly-death cascade spawns 3 C1 Bog-Spawn tokens then expires at charge 0; Persist-back unit's second death doesn't trigger (per Q5 lean).
- **LE.E4** — Refactor SmokeTile pseudocode (`gameplay_keywords_resolution_v0.md` §6.2) into a real LaneEffect subclass. Mirror the existing §6.3 stacking rule into the dispatch handler. Test: scene L asserting smoke-tile miss-chance behaviour + duration sum capped at 6.
- **LD3.E1** — Reopened post-LE.E2. The 12-card Banner-Buff spine batch (L27–L40 dispatch entries) becomes a single-batch heartbeat now that `_is_friendly_banner_in_lane` resolves through LaneEffects.

## 8. Open questions (none block LE.E1 plumbing)

1. **BANNER_TOKEN visual representation** — render as small tile icon, tinted lane background, or no visual at v0 (banner predicate is invisible until L41 lights up its PIERCE bonus)? Decision belongs to a UI heartbeat; backing data model is unaffected.
2. **BANNER_TOKEN tile vs lane-wide** — current spec uses `tile_idx = -1` (lane-wide / row-scoped). Alternative: `tile_idx = placer's tile` (Banner-Token "occupies" a specific tile and clears if that tile is contested). Lean lane-wide (matches "in this row" card text), but worth confirming. Affects L41 self-aura tile-locality but NOT predicate truth.
3. **SMOKE_TILE same-tile-same-kind stacking** — sum-into-existing vs append-new-instance. `gameplay_keywords_resolution_v0.md` §6.3 says "durations sum, capped at 6" — implementation can be either. Lean sum-into-existing (fewer Array entries, simpler cleanup).
4. **BANNER_TOKEN "banner class" sub-typing** — `payload.banner_class` field reserved. v0 doesn't distinguish (all banners satisfy the predicate identically). v1 might (e.g. Crowned-Anvil banner triggers L34 lore-bonus separately from a Watch-banner). Reserve the field; don't enforce at v0.
5. **SACRIFICE_PAYOFF + PERSIST interaction** — initial-death-only vs every-death-counts. Lean initial-death-only per §6.2. Confirm with Paul before LE.E3 ships.
6. **Cross-faction sacrifice payoffs** — does C42 trigger on Iron Penitent self-sacrifice when both are in the same lane? "Friendly unit" is faction-agnostic; lean YES (the lane is shared player real-estate; cross-faction synergy is a feature). No engine work to enable — it's just the literal reading of `owner_side == PLAYER`.
7. **NEUTRAL side** — reserved in §3.3. Any v0 LaneEffect that should be NEUTRAL? Not at v0; reserved for Hanging Hour environmental effects + map-node curses.

## 9. Deliberately out of scope (v0)

- **Save / load** — LaneEffects are combat-scoped, never persisted.
- **Enemy-side LaneEffects** — handlers note `owner_side == PLAYER` everywhere. Enemy bosses might post LaneEffects later (e.g. Chapter-2 boss "Iron Maw" places a ROOT_VINE lane-wide that slows player units). Reserved for the boss design heartbeat that introduces it.
- **Multi-lane LaneEffects** — e.g. "all three lanes get smoke for 1 turn". v0 says no — duplicate the LaneEffect across lanes by the placer if the card requires it. Avoids a Lane-ownership ambiguity.
- **LaneEffect targeting via spell removal** — e.g. a future Penitent spell "Purify: remove all hostile LaneEffects from one lane". Possible but no card needs it yet.
- **LaneEffect serialization for replay** — reserved for the post-IMV-2 telemetry / replay pass.

## 10. Verification gates for LE.E1

When LE.E1 ships, the implementer (Controller or .151) must:

1. **Parse-clean:** `lane_effect.gd` + amended `lane.gd` + `lane_effect_dispatch.gd` parse without GDScript errors in Paul's editor (sandbox can't run Godot syntax).
2. **Existing tests still PASS:** `turn_engine_test.gd` scenes A–H, `reward_test.gd`, `map_test.gd`, `e2e_smoke_test.gd`, `warlord_test.gd`, `card_zones_test.gd`, `game_state_test.gd`, `combat_test.gd` — all green. LaneEffect plumbing must not break the existing eight test suites.
3. **New scene I PASS:** add → tick → expire-by-duration (3 turns) + add → charge_consumed → expire-by-charges (3 deaths) + add → cleanup → expire-by-combat-end. Signal-emit asserts on `applied` / `charge_consumed` / `expired` / `tick`.
4. **Python mirror:** author `outputs/lane_effect_mirror.py` mirroring the GDScript semantics for at least scene I; 0 failures.
5. **Anti-P2W audit re-applied:** grep `lane_effect_dispatch.gd` for `treatment_id` / `acquired_via` / `xp_multiplier` — must return zero hits.

— Controller, 2026-05-27 (hourly backlog cycle #20)
