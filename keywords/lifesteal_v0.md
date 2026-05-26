# LIFESTEAL — keyword spec v0

**Status:** design-locked 2026-05-26 by Controller. Engine wiring authored same heartbeat (LIFESTEAL.E1 below). Promoted from soft-keyword to enum per the Phase 2.13 W42 add — Open-Q6 trigger crossed (intrinsic Lifesteal on W3 + aura-granted Lifesteal on Wolf-Tokens via W42).

## One-line gameplay text

"When this unit attacks an enemy, heal it equal to the damage dealt (capped at this unit's max HP)."

## Mechanics (locked)

- **Trigger.** Fires when the unit resolves a successful melee or ranged attack against an enemy unit or the enemy player base. The heal value equals **the damage actually dealt** after Shield absorption and Pierce resolution, NOT the unit's raw ATK stat.
- **Cap at max HP.** Heals cannot exceed `max_hp - current_hp`. No "overheal stacking" or temporary HP buffer. Keeps the keyword inside the existing HP model — no new resource.
- **Friendly-fire / attack-self / self-targeting.** Does not trigger. Lifesteal is enemy-damage-only.
- **Cleave + Lifesteal.** Heals for the SUM of damage dealt across all Cleave targets in the same attack resolution. A unit with Cleave + Lifesteal hitting two enemies for 2 each heals for 4 (clamped to max HP).
- **Pierce + Lifesteal.** Pierce bypasses Shield; Lifesteal heals for the full unblocked damage. Synergistic but not redundant.
- **Bleed / Poison + Lifesteal.** DoT damage does NOT trigger Lifesteal. Only the source attack heals (otherwise a single Bleed-Stacker with Lifesteal would heal across many turns from a single application). Keeps Lifesteal as a tempo mechanic, not a long-game scaling one.
- **Shield interaction.** If the target has Shield-N, Lifesteal heals only for damage that gets through. Attack 3 vs Shield-2 → 1 damage dealt → heal 1.
- **TAUNT redirection.** TAUNT changes WHO gets hit, not how much. Lifesteal heals based on damage dealt to the redirected target. No special interaction.
- **PERSIST interaction.** A unit with Lifesteal that dies and PERSISTs back returns at its PERSIST-reduced ATK floor. Lifesteal still works on the returned body — the keyword is on the card, not the instance.
- **Granted Lifesteal (aura case).** When Lifesteal is granted to a unit at runtime by an aura (e.g. W42 Den-Mother's Wolf-Token aura), the engine treats it identically to native-tagged Lifesteal — same damage-dealt heal rule. Aura removal (Den-Mother dies / leaves lane) immediately strips the Lifesteal from affected units. No residual heal from "in-flight" attacks.
- **Tokens with Lifesteal.** Allowed. Wolf-Tokens under W42's aura become 2/3 healing-1-per-hit tokens — strong but not overpowered at the 4-cost aura gate (compare Den-Mother is 4c U / 4 HP / 2 ATK herself + aura body).

## Why LIFESTEAL, why now

Three structural reasons:

1. **The text-only pattern hit its ceiling.** W3 Cinderwood Stalker has carried Lifesteal as bespoke `effect_text = "When this attacks, heal it 1"` since v1.0. W42 Den-Mother (Phase 2.13 N4) now needs to GRANT Lifesteal at runtime to dynamically-summoned Wolf-Tokens, which the text-only convention can't express cleanly — the engine has no "Lifesteal" semantics to grant.
2. **Archetype identity.** `archetypes_v0.md` §"E1 Big-Monster — TIGHT" lists Lifesteal as a defining mechanic of the Skinward Pact Big-Monster archetype ("solo-big-body / Lifesteal value chain"). An archetype-defining mechanic shouldn't be text-only — it should be a real keyword the engine can branch on, so future cards can tag it consistently.
3. **Future-proof for healing-cap balance.** When healing becomes a balance lever (e.g. C7 balance pass adds a "max heal per turn" cap for tournament play), the engine needs to identify Lifesteal-sourced heals distinct from other heal sources. Enum-tagged is the only clean path.

## Faction allocation

- **Skinward Pact (primary).** LIFESTEAL becomes the third pillar of the Beast / Wilds identity alongside SUMMON and aura granting. Per `faction_bible.md` §4 (will be amended in next pass). Target: 2 native-tagged cards (W3 + the aura grant on Wolf-Tokens via W42).
- **Coven (secondary, future).** The Black Mire's blood-rite flavour pairs cleanly with Lifesteal at the C4 Coven 40-card pool design pass. Reserve: 1–2 cards in the Hex-Cycle archetype where "drain life from the cursed" is on-brand.
- **Other 3 factions: no LIFESTEAL** at v1. Iron Penitents heal via Penance triggers (different mechanic), Ash-Mourners drain via Smoke / Dread aura debuffs (not heals), Last Legion heals via Banner / Rally formation buffs (also not heals — those are stat-buffs not HP-restoration). Keeping LIFESTEAL Skinward-locked makes it a faction-recognisable mechanic at draft time.

## Anti-P2W invariant

LIFESTEAL is a free-tier mechanical keyword — no IAP gates the keyword itself. Wolf-Tokens (W27 / W28) are starter-pool 0-cost commons; Den-Mother (W42) is a draftable uncommon; W3 Cinderwood Stalker is a draftable uncommon. No paid card or treatment unlocks Lifesteal. This holds the `anti-P2W invariant` from `monetisation_map.md`.

## LIFESTEAL candidates — existing cards to retag

**Skinward Pact** (target: ZERO native-tagged cards at v1; only the W42 aura grant consumes the new keyword):

| Card | Rarity | Current keywords | Why LIFESTEAL fits | Action |
|---|---|---|---|---|
| W3 Cinderwood Stalker | U | `[]` (text-only) | Long-standing soft-Lifesteal-by-text since v1.0 — "heal it 1" (fixed-1, not damage-dealt). | **LEAVE TEXT-ONLY.** Retagging W3 to the keyword would silently buff its heal from `1` to `damage_dealt` (up to 3 per hit against undefended targets). That's a unilateral balance change. W3 stays as the "soft Lifesteal" variant; the LIFESTEAL keyword is reserved for cards designed around heal-for-damage-dealt scaling. Flag for Paul: agree W3 stays heal-1, OR explicitly approve a buff to keyword-Lifesteal. |
| W42 Den-Mother of the Cinderwood | U | `[]` | **Grants** Lifesteal to Wolf-Tokens via aura, NOT native. Den-Mother herself does NOT have Lifesteal. | Leave `keywords = []`. Effect_text retains the aura grant. Engine handler dispatches the grant at runtime — see LIFESTEAL.E1 below. **This is the first / only consumer of the new keyword at v1.** |

**No native-tag retags this pass.** Future Coven C4 design pass may add 1–2 native-tagged Lifesteal cards (Hex-Cycle archetype).

## Engine wiring sketch (LIFESTEAL.E1)

`game/src/runtime/turn_engine.gd` modifications:

1. **In the attack-resolution function** (the one that calls `enemy.take_damage(dmg)`), after damage is dealt and the post-damage value `damage_dealt` is known (= raw atk minus shield absorption minus any other mitigation):
   ```gdscript
   # LIFESTEAL E1 — apply heal to attacker for damage_dealt amount
   if attacker.has_keyword(GFEnums.Keyword.LIFESTEAL) and damage_dealt > 0:
       var heal_amount = min(damage_dealt, attacker.max_hp - attacker.current_hp)
       if heal_amount > 0:
           attacker.current_hp += heal_amount
           emit_signal("unit_healed", attacker, heal_amount, "lifesteal")
   ```
2. **Cleave + Lifesteal.** Accumulate `total_damage_dealt` across all Cleave hit targets and apply ONE Lifesteal heal at end of the Cleave resolution loop. Avoids the engine triggering Lifesteal multiple times per cleave swing (correct per spec "SUM of damage dealt").
3. **`has_keyword(kw)`** helper checks BOTH the card's native `keywords` array AND any runtime-granted-keyword set (which auras like W42 push onto a unit at lane-enter and pop on lane-exit). New `runtime_keywords: Array[int]` field on the unit instance — defaults to empty, populated only by aura grants.
4. **W42 Den-Mother aura hook.** When W42 enters lane, scan all friendly Wolf-Tokens in lane and push `LIFESTEAL` + `+1/+1` modifier onto each. When W42 leaves lane (or dies), reverse. When a NEW Wolf-Token enters the lane while W42 is alive, apply on-enter. This is a separate aura-handler pattern documented as part of LIFESTEAL.E1.

## Tests (LIFESTEAL.E1 test additions)

Append `_scene_e_lifesteal` to `game/src/runtime/turn_engine_test.gd`:

- **E1.** W3 Cinderwood Stalker (3 ATK / LIFESTEAL) attacks an enemy with Shield-1 (so deals 2 damage). W3 at 1 HP after eating a prior 2-damage hit. Expected: W3 heals to 3 HP after attack resolves.
- **E2.** W3 at full HP (3/3) attacks an enemy with 1 HP (deals 1, target dies). Expected: W3 stays at 3 HP (no overheal).
- **E3.** W28 Wolf-Token in lane with W42 Den-Mother. Wolf-Token attacks enemy for 2 damage (1 native + 1 from Den-Mother aura). Expected: Wolf-Token heals for 2 (capped at max HP including aura's +1).
- **E4.** W42 Den-Mother dies mid-turn. Surviving Wolf-Tokens in lane lose the +1/+1 AND the LIFESTEAL grant immediately. Verify their `runtime_keywords` array is empty post-W42-death.
- **E5.** W3 with Cleave (hypothetical — no Cleave Skinward card exists yet, mock with a test-only fixture) hits 2 enemies for 2 damage each. Expected: W3 heals for 4 total (one Lifesteal trigger, not two).

Sandbox cannot run Godot — Paul confirms `[turn_engine_test] PASS` next time the editor is open. Same heartbeat-deferred-test pattern as TAUNT.E1.

## Open questions for Paul (none blocking)

1. **Lifesteal-from-token-attack triggering Den-Mother's own heal?** No — Lifesteal is on the attacker only. Wolf-Token attacks → Wolf-Token heals. Den-Mother does not get healed from her token's hits. Confirm.
2. **Lifesteal + RESURRECT chain?** If a Lifesteal unit dies and RESURRECTs (per card text), does the RESURRECTed body retain Lifesteal? Yes — keyword is on the card, persists across death/resurrect. Spec is consistent.
3. **C4 Coven design — Lifesteal reservation.** Should we reserve 1–2 Coven slots for Lifesteal now, or wait until the C4 pool design pass and decide then? Recommend wait — keep this spec's faction allocation conservative.

## Cross-doc updates owed this heartbeat

- `game/src/data/enums.gd` — add `LIFESTEAL` after `TAUNT` (= 16). **DONE.**
- `game/data/cards/skinward_pact/W3.tres` — **NO CHANGE** (text-only stays per balance reasoning above; flagged for Paul confirmation).
- `cards_skinward_pact_v1.md` — Open-Q6 marked resolved with cross-reference to this doc; W3 row annotated to note text-only retention pending balance review. **DONE.**
- `gdd_v0.md` line 37 — Lifesteal already listed in the "intended keywords" sentence; no edit needed (was forward-looking).
- `faction_bible.md` §4 — Skinward Pact mechanical pillars updated to include LIFESTEAL alongside SUMMON. OWED — single-line edit at next heartbeat.
- `archetypes_v0.md` E1 Big-Monster archetype — Lifesteal reference upgraded from text-only-flavour to keyword-confirmed. OWED — single-line edit at next heartbeat.

Phase 2.13 Open-Q closed by this spec.
