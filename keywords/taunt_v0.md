# TAUNT — keyword spec v0

**Status:** design-locked 2026-05-15 by Controller. Engine wiring deferred to B2.7+ next polish pass.

## One-line gameplay text

"Enemies in this unit's lane must attack it before any other friendly target in lane."

## Mechanics (locked)

- **Targeting override.** When an enemy resolves an attack against a friendly target, the targeter resolves in this order: (1) is there a TAUNT-tagged friendly in the same lane within the enemy's attack range? If yes, the enemy MUST target it. (2) Else fall back to the existing "lowest-tile target" rule from B2.7 turn engine.
- **Range scoping.** TAUNT only forces redirection when the taunting unit is in range. A TAUNT unit on tile 5 does NOT pull an enemy on tile 0 unless the enemy has SHORT (2) or LONG (3) attack range. This keeps TAUNT from being a free shield for the back line.
- **Multiple taunters in lane.** If 2+ TAUNT-tagged friendlies are in range, the enemy picks the lowest-tile one (consistent with the default targeting rule, just applied within the taunt-eligible subset).
- **No taunt-on-tokens.** Token units (`is_token = true`) cannot carry TAUNT. Prevents Skinward Cub/Wolf-token swarms from soaking Iron Penitents' burst damage en masse.
- **Stacks with SHIELD.** TAUNT + SHIELD on the same unit is the intended "hold the line" pattern. SHIELD absorbs damage first per existing rules; TAUNT just changes who soaks.
- **Does not affect AoE / lane-wipe.** Lane-wipe traps + Cleave + Pierce ignore TAUNT (they hit everyone in range regardless). TAUNT only redirects single-target enemy attacks.
- **Does not affect spells.** Enemy spells (when added in B3+) follow their own targeting rules; TAUNT does NOT force a spell onto the taunter.

## Why TAUNT, why now

The 3-lane TD format from B2.5 already has a "lowest-tile target" rule but no way for the player to control which friendly takes the hit. Several existing archetypes need a soak mechanism:

- **Iron Penitents — Bleed-Stack / Cleave-Melee** wants the high-HP front-line zealot to take damage so the lower-HP Bleed-applicators behind survive long enough to stack.
- **Last Legion — Rally-Formation / Banner-Buff** is literally about formation discipline — the keyword that says "stand in front and shield the line" is the missing core to make formation reads as formation rather than "incidental adjacency".
- **Coven — Bog-Spawn Swarm** counter-play: opposing TAUNT lets the player choose to soak with a single chunky body rather than lose every Bog-Spawn token to an enemy AoE.

Adds a defensive control dimension to the player's lane-placement decision without adding a new resource. Cheap to learn (TD-genre staple), high in skill ceiling (placement + range awareness).

## Faction allocation

- **Last Legion (primary).** TAUNT is the third pillar alongside RALLY + ECHO. Becomes the keyword that closes the "formation" identity — every Legion deck should run at least one TAUNT body. Per `faction_bible.md` §4 update.
- **Iron Penitents (secondary).** TAUNT fits the "sacrifice yourself for the cause" zealot fantasy. Smaller share: 1–2 cards. Not a faction-defining mechanic, just thematic spice.
- **Other 3 factions: no TAUNT** at v1. Ash-Mourners' Smoke / Dread is their lane-control layer; Coven swarms by overload not by shielding; Skinward's Big-Monster cards self-soak via raw HP. Keeping TAUNT scarce makes it more meaningful when it appears.

## TAUNT candidates — existing cards to retag

**Last Legion** (target: 4 cards, ~10% of the 40-card pool):

| Card | Rarity | Current keywords | Why TAUNT fits | Note |
|---|---|---|---|---|
| L7 Sergeant-Smith Vikar | R | SHIELD-1 + RALLY | Flagship 4-cost rare; the "hold the line" leader. TAUNT confirms his role. | Stat-line untouched. |
| L33 Banner-Captain of the Crowned Anvil | R | SHIELD-1 + RALLY-2 | Banner-Captain payoff. Standing in front of the banner is the fantasy. | Stat-line untouched. |
| L11 Iron Watch Standard-Bearer | U | RALLY | Mid-curve front-line body. | Pre-Phase-2.7 banner pack. |
| L18 Echo-Sergeant | R | ECHO | Inverted from the flagship — Echo+Taunt creates a "replays the soak" loop that's flavour-perfect for the Tempo-Echo archetype. | Echo proc on Taunt absorption is a B3 polish detail. |

**Iron Penitents** (target: 2 cards, ~5% of the 40-card pool):

| Card | Rarity | Current keywords | Why TAUNT fits | Note |
|---|---|---|---|---|
| P3 Cathedral Brother | C | SACRIFICE-soft | Cheap 2-cost zealot body. Becomes the "early-game soak" play pattern that hands off into Bleed-Stack scaling. | Brother is currently a flex flavour-card; TAUNT gives him a clear role. |
| P34 Hammer-Curate | U | PENANCE | Aura captain who buffs Penance triggers. Taunt-soaking is consistent with curate-as-shepherd flavour. | Stat-line untouched. |

**Tagging mechanic:** markdown-level flag this run, the same M1 pattern. Actual `.tres` `keywords` array edits happen at the next focused Engine-Wiring heartbeat (Phase 2.12.E1 in the new backlog block), after Paul's keyword approval. Keeps this heartbeat purely design.

## Interactions

- **TAUNT × PIERCE.** PIERCE ignores SHIELD but not TAUNT. TAUNT forces the target, then PIERCE bypasses the SHIELD layer on that target. Consistent with existing rules.
- **TAUNT × FEAR / SMOKE.** A FEAR'd or SMOKE'd enemy still respects TAUNT; only its ATK number is reduced, not its target choice. Mourners can stack debuffs on top of a Legion taunt-line without breaking either keyword.
- **TAUNT × PERSIST.** A TAUNT-tagged unit that dies and Persists back retains its TAUNT keyword on return. The -1 ATK from Persist applies; TAUNT does not modify ATK. Once-per-combat Persist lock continues to apply.
- **TAUNT × ROOT.** ROOT prevents movement but not attack-receiving. A rooted TAUNT body is still a valid target — it just can't reposition. Fine.
- **TAUNT × Hanging Hour.** Hanging Hour Persist override (M4) returns dead units at full stats. A TAUNT body returning at full stats is intentional — Hanging Hour escalation makes the lane re-shield brutally hard.
- **TAUNT × enemy AoE / Cleave (Reaper-Bell etc.).** Cleave hits 2 adjacent enemies regardless of TAUNT. TAUNT does not protect adjacency siblings from collateral. Correct — collateral is what makes Cleave a counter to Formation.

## Engine wiring sketch (for Phase 2.12.E1)

- `GFEnums.Keyword.TAUNT` added as 16th keyword (single-token enum append, same risk profile as M1's PERSIST add). Already drafted below.
- `TurnEngine.choose_enemy_target(enemy, lane) -> UnitInstance` extended: before falling through to the existing lowest-tile rule, filter `lane.friendlies` for units with `card.has_keyword(GFEnums.Keyword.TAUNT) AND not card.is_token AND tile_distance(enemy, unit) <= enemy.card.attack_range_tiles`. If the filtered list is non-empty, target the lowest-tile member.
- No `UnitInstance` state changes — TAUNT is a static keyword check on the underlying Card resource. No `has_taunted` or per-combat lock; TAUNT is always-on.
- Test coverage: extend `turn_engine_test.gd` with 3 new assertions — (a) MELEE enemy targets TAUNT body over closer non-taunt body in range; (b) MELEE enemy out of range of TAUNT body falls back to lowest-tile; (c) Cleave hits both TAUNT body + adjacent non-taunt.
- Sandbox can't run Godot syntax — Paul confirms `[turn_engine_test] PASS` after the wiring run.

## Anti-P2W invariant

TAUNT is gameplay-only, never cosmetic. Cursed-treatment / Gold-treatment / etc. MUST NOT modify which unit pulls aggro — treatment_id is read by the visual layer only. Restated explicitly here because TAUNT is high-impact and the IAP-temptation to sell "premium taunt" cosmetics is real but would break PvP fairness if multiplayer is ever added.

## Open questions for Paul (none block Phase 2.12.E1)

1. **TAUNT visual cue.** Halo? Banner-shimmer? Border-glow on the unit's tile? Defer to B3.2 art pass.
2. **Player-initiated TAUNT activation.** Should TAUNT be always-on, or a play-time toggle (cost: 1 mana to "taunt this turn")? Default = always-on per the spec above. Toggle-version adds a strategic decision but a new UI element. Recommend defer.
3. **TAUNT chains across lanes.** TAUNT only works within a unit's own lane. Should there be a high-rarity LEGION_LEADER unit at LEGENDARY tier that taunts cross-lane (forces enemies in lanes 0 and 2 to attack into lane 1)? Defer to a future "boss-counter rare" pass after IMV-1.
4. **TAUNT-pull priority vs Penance-trigger priority.** When an Iron Penitent dies under TAUNT, does Penance trigger fire BEFORE or AFTER the TAUNT body soaks the killing blow? Recommend: TAUNT body soaks → if it dies, Penance fires on its death → if it survives, no Penance trigger. Lock at engine-wire time.

