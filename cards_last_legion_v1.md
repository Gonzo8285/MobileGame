# The Last Legion — Full Card Pool v1.0 (C5)

_Drafted 2026-05-01 in heartbeat. Net-new faction in the cards file (no v0 cards — `cards_v0.md` v1.0 covered Penitents/Mourners/Coven only). All 40 cards authored fresh as IDs L1–L40. Designed against `archetypes_v0.md` v0.1 (D1/D2/D3) and the v0.1 anti-synergy grid. Faction = canonical Track A — **The Last Legion** (`GFEnums.Faction.FERRUM_HOST` in code; engine constant left unchanged this pass per L2 cleanup queue). Pool tuned to the same 60–25–10–5 distribution and 24/12/4 rarity skew as the prior three faction pools._

## Distribution (target: 40 cards / 60–25–10–5; current 41 after Phase 2.13 N2)

| Slot | Target | Authored | Per archetype split |
|---|---|---|---|
| Units | 24 (60%) | 25 | 8 Rally-Formation / 8 Tempo-Echo / 9 Banner-Buff |
| Spells | 10 (25%) | 10 | 4 Rally / 4 Echo / 2 Banner |
| Traps | 4 (10%) | 4 | 1 Rally / 1 Echo / 2 Banner |
| Specials (relics) | 2 (5%) | 2 | 1 Echo-flavoured / 1 Banner-flavoured |
| **Total** | **40** | **41** | _+1 (L41 Banner-Bearer of the Crowned Anvil, 3c U, Phase 2.13 N2)_ |

## Rarity skew

| Rarity | Count | % | Notes |
|---|---|---|---|
| Common (C) | 24 | 58.5% | Cheap fuel, 2-cost spine, draftable mass |
| Uncommon (U) | 13 | 31.7% | Archetype workhorses + both archetype payoff spells (Iron Standard Unfurled, Hammer-Stroke Doctrine) + L41 Banner-Bearer spine (Phase 2.13 N2) + 1 relic |
| Rare (R) | 4 | 9.8% | 3 archetype identities (Vikar / Echo-Sergeant / Banner-Captain) + 1 payoff (Crowned Anvil Standard, 5c R artifact-unit) |

## Format reminder

- **Cost** = mana to play.
- **Units:** HP / ATK / Range (M/S/L) / CD (turns).
- **Rarity:** C / U / R.
- **Hard keywords (in `GFEnums.Keyword`):** Pierce, Shield, Slow, Root, Summon. (No net-new hard keywords.)
- **Soft keyword — Echo:** "replay an effect / attack once." Expressed in card text only this pass — Echo is not in the keyword enum yet, so engine cards leave the keyword array empty for Echo-using cards. Flag for engine-side enum addition is filed under Open questions Q1.
- **Banner-Token:** non-card lane object. Placed by Banner-Buff cards. Has duration in turns, no HP, untargetable. While present, applies the buff text from the placing card.

---

## Rally-Formation archetype (13 cards)

Identity is **L7 Sergeant-Smith Vikar, the Iron Watch (4c R)** — friendly Legion units in this row gain +1 ATK and Shield-1. Payoff: **L9 Iron Standard Unfurled (5c U spell)** — all friendly Legion in lane gain +2 ATK and Echo this turn. Engine: stack 3+ Legion in a row → row-wide ATK + Shield ramp → Pierce/Cleave the front rank. Splashes into Iron Penitents Cleave-Melee (Cleave + adjacency reads natively as Legion). Hard counter: Ash-Mourners Smoke-Fear (Fear scatters ATK targets and breaks formation math).

### Units (8)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| L1 | Forge-Spark Skirmisher | 1 | 1 | 2 | M | 1 | C | On first attack each turn, +1 ATK. |
| L2 | Foundry-Sworn Pikeman | 2 | 2 | 2 | S | 1 | C | +1 ATK while adjacent to a friendly Legion unit. |
| L3 | Anvil-Drilled Recruit | 2 | 3 | 1 | M | 1 | C | +1 HP while another friendly Legion is in lane. |
| L4 | Iron Bayonet Drill | 3 | 3 | 2 | S | 1 | U | Pierce. While 2+ friendly Legion in row, +1 ATK. |
| L5 | Foundry Engineer | 3 | 3 | 1 | S | 1 | C | On play: a friendly Legion in row gains +1 HP this combat. |
| L6 | Forge-Conscript | 4 | 4 | 2 | S | 1 | U | When 3+ friendly Legion are in this row at start of your turn, draw 1 (once per combat). |
| L7 | **Sergeant-Smith Vikar, the Iron Watch** | 4 | 4 | 3 | S | 1 | **R** | **Identity.** Friendly Legion units in this row gain +1 ATK and Shield-1. |
| L8 | Iron Watchwarden | 5 | 5 | 3 | L | 2 | U | On play: each friendly Legion in row gains Shield-1. |

### Spells (4)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| L9 | **Iron Standard Unfurled** | 5 | **U** | **Payoff.** All friendly Legion in lane gain +2 ATK and Echo this turn. |
| L10 | Lockstep | 1 | C | A friendly Legion gains +1 ATK this turn. If 2+ Legion in row: also Shield-1. |
| L11 | Form Ranks | 2 | C | Shift all friendly Legion in lane one tile toward the front rank; +1 ATK to row this turn. |
| L12 | Drill Order | 3 | C | All friendly Legion in row gain Pierce this turn. |

### Traps (1)

| # | Name | Cost | Rarity | Trigger / Effect |
|---|---|---|---|---|
| L13 | Pikewall Trap | 2 | C | First enemy on tile: take 3 Pierce damage from nearest friendly Legion (counts as a Legion attack) + Slow-1 for 1 turn. |

---

## Tempo-Echo archetype (13 cards)

Identity is **L18 Echo-Sergeant (4c R)** — when you play a 2-cost-or-less Legion unit, replay its on-play effect once. Payoff: **L25 Hammer-Stroke Doctrine (5c U spell)** — all Legion attacks this turn trigger Echo. Engine: chain cheap Legion plays + spells → Echo doubles their on-play / on-attack triggers → tempo wave. Splashes into Ash-Mourners Trap-Control (Echo replays trap-triggered effects — natural hybrid). Hard counter: Coven Poison-Stack (Echo doesn't scale DoT ticks; replays stall vs poison turn-clocks).

### Units (8)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| L14 | Forge-Light Runner | 1 | 1 | 1 | M | 1 | C | On attack, gain +1 ATK this turn (stacks if the attack is repeated). |
| L15 | Echo-Cadet | 2 | 2 | 1 | S | 1 | C | When you cast a Legion spell, this gains +1 ATK this turn. |
| L16 | Bayonet Echoist | 2 | 2 | 2 | S | 1 | U | On attack: 33% chance to repeat the attack (Echo). |
| L17 | Hammer-Pulse Specialist | 3 | 2 | 2 | M | 1 | C | On play: deal 1 dmg to a chosen enemy. If you played a Legion card last turn, repeat once. |
| L18 | **Echo-Sergeant** | 4 | 4 | 2 | S | 1 | **R** | **Identity.** When you play a 2-cost-or-less Legion unit, replay its on-play effect once. |
| L19 | Repeating Bayonet | 4 | 3 | 3 | S | 1 | U | While 3+ friendly Legion in row, this unit's attacks Echo once. |
| L20 | Drum-Sergeant of the Foundry | 5 | 4 | 3 | S | 1 | U | On play: replay the on-play of one friendly Legion in lane (once per combat). |
| L21 | Forge-Volley Crew | 3 | 2 | 2 | L | 2 | C | On attack: if a Legion has already attacked this turn, repeat. |

### Spells (4)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| L22 | Forge-Cry | 1 | C | A friendly Legion gains Echo for one attack. |
| L23 | Tempo Strike | 2 | C | Deal 2 dmg to a single enemy. If a Legion has attacked this turn, repeat. |
| L24 | Hammer-Cycle | 3 | U | Choose a friendly Legion unit; its next attack Echoes twice. |
| L25 | **Hammer-Stroke Doctrine** | 5 | **U** | **Payoff.** All Legion attacks this turn trigger Echo. |

### Traps (1)

| # | Name | Cost | Rarity | Trigger / Effect |
|---|---|---|---|---|
| L26 | Echoing Snare | 2 | C | First enemy on tile: take 1 dmg twice (Echo) + Slow-1 for 1 turn. |

---

## Banner-Buff archetype (14 cards)

Identity is **L33 Banner-Captain of the Crowned Anvil (4c R)** — on play, places a Banner-Token (3 turns) in this lane: while it stands, all Legion in row gain +1 ATK and Shield-1. Payoff: **L34 Crowned Anvil Standard (5c R artifact-unit)** — 8 HP, 0 ATK, no attack; aura: persistent +1 ATK to friendly Legion in lane until destroyed. Engine: place banner / artifact → row-wide buff sustained → Crown-Anvil Veteran etc. scale off it. Splashes into Ash-Mourners Smoke-Fear (Shield-1 aura + Smoke is a brutal turtle). Hard counter: Iron Penitents Bleed-Stack (Bleed bypasses Shield-1 by ticking on off-attack turns).

### Units (8)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| L27 | Standard-Boy | 1 | 1 | 1 | M | 1 | C | On death: a friendly Legion in lane gains Shield-1. |
| L28 | Banner-Bearer Acolyte | 2 | 2 | 1 | S | 1 | C | While alive: friendly Legion in row gain +1 ATK on first attack each turn. |
| L29 | Iron Wardrum | 2 | 2 | 0 | — | 0 | C | Aura: friendly Legion in row gain Shield-1, refreshed at start of your turn. Cannot attack. |
| L30 | Crown-Anvil Veteran | 3 | 3 | 2 | S | 1 | C | While a friendly banner is in your lane, +1 ATK. |
| L31 | Iron Choir-Standard | 3 | 3 | 1 | S | 1 | C | Aura: friendly Legion in row are immune to Fear. |
| L32 | Banner-Sergeant of Vanrik | 4 | 4 | 2 | S | 1 | U | On play: place a Banner-Token (3 turns) in this lane: row gains Shield-1 while it stands. |
| L33 | **Banner-Captain of the Crowned Anvil** | 4 | 4 | 3 | S | 1 | **R** | **Identity.** On play: Banner-Token (3 turns); while it stands, all Legion in row gain +1 ATK and Shield-1. |
| L34 | **Crowned Anvil Standard** | 5 | 8 | 0 | — | 0 | **R** | **Payoff (artifact-unit).** Cannot attack. Aura: persistent +1 ATK to friendly Legion in lane until destroyed. |
| L41 | Banner-Bearer of the Crowned Anvil | 3 | 3 | 2 | S | 1 | U | While a friendly banner stands in this row, gains +1 ATK and Pierce. _(Phase 2.13 N2 spine, 2026-05-26 — anchors the 1c→3c→4c R→5c R Banner rarity ramp.)_ |

### Spells (2)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| L35 | Standard-Bearer's Cry | 1 | C | +1 ATK to all friendly Legion in row this turn. |
| L36 | Raise the Anvil | 3 | C | Place a Banner-Token (2 turns) in chosen lane: row gains Shield-1 and is immune to Slow while it stands. |

### Traps (2)

| # | Name | Cost | Rarity | Trigger / Effect |
|---|---|---|---|---|
| L37 | Banner-Defence Trap | 1 | C | First enemy on tile: take 2 dmg. If a friendly banner is in this lane, take 4 dmg + Slow-1 instead. |
| L38 | Crowned Stake | 3 | U | First enemy on tile: Root 1 turn. While rooted, friendly Legion attacking it gain +1 ATK. |

### Specials (2 relics — off-deck unlocks)

| # | Name | Slot | Rarity | Effect |
|---|---|---|---|---|
| L39 | Hammer-Echo Sigil | Relic | U | When you cast a Legion spell, draw 1. Cap 2 per combat. |
| L40 | Banner of the Last Hour | Relic | C | At the start of each combat: place a 3-turn Banner-Token in your starting lane (row gains Shield-1 while it stands). |

---

## Pool totals (sanity check)

| Slice | Target | Actual |
|---|---|---|
| Total cards | ~40 | **41** _(+1 from Phase 2.13 N2)_ |
| Common (C) | ~24 | **24** (L1, L2, L3, L5, L10, L11, L12, L13, L14, L15, L17, L21, L22, L23, L26, L27, L28, L29, L30, L31, L35, L36, L37, L40) ✓ |
| Uncommon (U) | ~12 | **13** (L4, L6, L8, L9, L16, L19, L20, L24, L25, L32, L38, L39, **L41**) _(+1 N2)_ |
| Rare (R) | ~4 | **4** (L7, L18, L33, L34) ✓ |
| Units | ~24 (60%) | **25** (L1–L8, L14–L21, L27–L34, **L41**) _(+1 N2)_ |
| Spells | ~10 (25%) | **10** (L9, L10, L11, L12, L22, L23, L24, L25, L35, L36) ✓ |
| Traps | ~4 (10%) | **4** (L13, L26, L37, L38) ✓ |
| Specials | ~2 (5%) | **2** (L39, L40) ✓ |

## Per-archetype card density (target ~10–13 each)

- **D1 Rally-Formation:** L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11, L12, L13 = **13 primary**.
- **D2 Tempo-Echo:** L14, L15, L16, L17, L18, L19, L20, L21, L22, L23, L24, L25, L26, L39 (relic) = **14 primary**.
- **D3 Banner-Buff:** L27, L28, L29, L30, L31, L32, L33, L34, L35, L36, L37, L38, L40 (relic), **L41 (Phase 2.13 N2 spine)** = **14 primary**.

Cross-archetype splash (every Legion Pierce / Shield card splashes into the other two Legion archetypes natively — formation pieces feed Echo replays and Banner auras alike).

## Cost curve (full pool)

| Cost | Count | Cards |
|---|---|---|
| 0 | 0 | — |
| 1 | 7 | L1, L10, L14, L22, L27, L35, L37 |
| 2 | 10 | L2, L3, L11, L13, L15, L16, L23, L26, L28, L29 |
| 3 | 11 | L4, L5, L12, L17, L21, L24, L30, L31, L36, L38, **L41** _(+1 N2)_ |
| 4 | 6 | L6, L7, L18, L19, L32, L33 |
| 5 | 5 | L8, L9, L20, L25, L34 |
| relic | 2 | L39, L40 (cost 0, off-deck) |

Curve is bottom-heavy 2/3-cost (formation wants bodies in lane every turn). 4-cost is the identity-card cluster (3 of 4 Rares sit at 4c). Single 5-cost Rare payoff (L34 Crowned Anvil Standard).

## Anti-synergy + splash recap (D1/D2/D3 hard counters per `archetypes_v0.md` v0.1)

- **D1 ↔ Ash-Mourners Smoke-Fear:** Fear scatters ATK targets, breaks adjacency math. Punish: L8 Iron Watchwarden (Long range bypasses front-rank Fear), L31 Iron Choir-Standard (immune-to-Fear aura).
- **D2 ↔ Coven Poison-Stack:** Echo doesn't scale DoT ticks. Punish: L25 Hammer-Stroke Doctrine empties the lane in one turn — out-paces poison's slow scaling.
- **D3 ↔ Iron Penitents Bleed-Stack:** Bleed bypasses Shield-1 by ticking off-attack. Punish: L34 Crowned Anvil Standard's persistent +1 ATK survives Bleed (it's an artifact-unit, no on-attack tick). Soak with raw ATK race.

## Splash cards (≥2 cards splash into rival faction archetypes — Phase 2.6 brief)

- **L4 Iron Bayonet Drill** → splashes into Iron Penitents Cleave-Melee (Pierce + adjacency formation reads as Cleave-prep).
- **L9 Iron Standard Unfurled** → splashes into Skinward Pact Big-Monster (a single 6/6 Wilds with +2 ATK and Echo is a brutal one-shot — design hook for hybrid Warlords).
- **L24 Hammer-Cycle** → splashes into Ash-Mourners Trap-Control (Echo on a trap trigger is a v1.1 design hook).
- **L31 Iron Choir-Standard** → splashes into Ash-Mourners Smoke-Fear (Fear-immune body sits in Smoke and keeps swinging).
- **L34 Crowned Anvil Standard** → splashes into Iron Penitents Sacrifice-Penance (8 HP off-attack body absorbs Penance self-damage without dying).

Five splash hooks → meets C7's "≥2 splash hooks per faction" target.

## Naming + flavour notes

- All names hew to the foundry / iron / hammer / anvil / banner / drill register. The Last Legion is the last imperial holdout — they speak in drill-orders and forge-cant.
- "Foundry-Sworn", "Forge-Spark", "Anvil-Drilled", "Crown-Anvil" — the naming cluster builds the locale (the Foundry biome) into the card-text, same trick the Coven uses with the bog-coin cluster.
- Flagship characters: Sergeant-Smith Vikar (the line officer), Banner-Captain of the Crowned Anvil (the standard-bearer), Echo-Sergeant (the drill-master). Lord-Marshal placeholder _not_ used this pass — reserved for a future Warlord-tier signature card.
- Echo as soft keyword: card text spells out "Echo (replay)" so players parse the rule without enum support. Engine `.tres` keywords array is empty for Echo-only cards.

## v1.1 change log

**2026-05-26 — Phase 2.13 N2 (Controller).** Added **L41 Banner-Bearer of the Crowned Anvil** (3c U Banner-Buff spine). Hardens D3 (flagged LOOSE in M7 audit) by giving the 1c→3c→4c R→5c R Banner rarity ramp its 3c U keystone. Pool 40 → 41; Units 24 → 25; Uncommons 12 → 13; D3 Banner-Buff archetype density 13 → 14. Distribution + Rarity-skew + Pool-totals + Per-archetype-density + Cost-curve tables updated. PIERCE is conditional (only while banner stands in row) so `.tres` `keywords` array is empty — Pierce is granted via effect text, mirroring the M41 / Wraith-Caller convention for cost-triggered conditional effects. `attack_range = 2` (SHORT) for consistency with the 3c Banner-Buff slot (L30, L31) and the polearm-bearer chassis.

Open questions for Paul (none block N3 / N4):

1. **What counts as a "friendly banner"?** Banner-Tokens placed by L13 / L32 / L33 / L36 / L37 / L40 are the obvious answer. Does **L34 Crowned Anvil Standard** (the 5c R artifact-unit) ALSO count as a banner for L41's trigger? Lean YES (it's a banner in flavour and the persistent +1 ATK aura makes it the late-game lane anchor L41 should pair with), but worth confirming so the engine reads either `LaneEffect.kind == BANNER_TOKEN` OR `card.id == &"L34"`, not just the former.
2. **Pierce scope.** "gains +1 ATK and Pierce" reads as: while banner stands → ATK = 3 with PIERCE applied to all attacks (not just the bonus). Confirm — alternative reading would be "+1 ATK that bypasses Shield" which is a niche corner case.
3. **Multi-banner stacking.** If L32 (Banner-Sergeant) + L33 (Banner-Captain) both place tokens in the same row, does L41 stack the +1 ATK / Pierce buff (becomes +2 ATK + 2× Pierce-redundant) or cap at ≥1 banner = single buff? Lean SINGLE (binary trigger), matches the "1c→3c→4c→5c ramp" framing.

## Open questions / flags for Paul

1. **Echo as keyword.** Echo is currently soft-rule (text-only, not in `GFEnums.Keyword`). All 8+ Echo-using cards in this pool reference it in `effect_text` only. Adding `ECHO = 14` to `enums.gd` lets gameplay code branch on it cleanly. Recommend adding before B2.5 wave-spawner work — affects on-attack resolution.
2. **Banner-Token as lane object.** Not modelled in current `GameState` — needs a lightweight lane-object system (HP-less, duration-based, untargetable). Smaller scope than full Trap/Unit class but does need a class. Flag for B2.6/B2.7 design.
3. **Crowned Anvil Standard at R.** Sits as 5c R artifact-unit (8/0/—/0). If Paul wants the 4 Rares to all be "named characters", demote L34 to U and promote L9 Iron Standard Unfurled U → R for the 4th Rare slot. Net rarity unchanged.
4. **Specials slot model.** Same open question as Iron Penitents (Q1), Ash-Mourners, and Coven. L39/L40 authored as `is_draftable=false` + `unlock_tag=&"relic_last_legion"` pending your call.
5. **Echo-Sergeant 2c-or-less gate.** Identity caps Echo at "play a 2c-or-less Legion unit". Lots of 1c and 2c Legion units in this pool (L1, L2, L3, L14, L15, L16, L27, L28, L29 = 9 cards). Validate that 9 valid Echo-targets isn't degenerate when combined with L25 Hammer-Stroke Doctrine. May want to gate to 1c-or-less if too snowbally in playtest.

## Change log

- **v1.0 (2026-05-01)** — initial 40-card pool authored from D1/D2/D3 archetype briefs. Net-new faction in cards file. 40 cards (L1–L40). 60/25/10/5 distribution hit exactly. 4 Rares (L7, L18, L33, L34). 2 specials introduced (relics flagged for system-wide call). Echo flagged as soft keyword for engine-side enum addition.
- **Same heartbeat:** `.tres` files for L1–L40 generated under `game/data/cards/last_legion/`.

_Next backlog hop: C6 — Skinward Pact full pool (~40 cards). Net-new faction in the cards file. Identity/payoff cards from `archetypes_v0.md` (Bear-Skin Hierophant, Wyrd-Shifter, Pelt-Bound Shaman, Thrask the Bear-Who-Was-King, etc.) used as the spine._


---

## TAUNT candidates (design-flagged 2026-05-15 by Controller — Phase 2.12.M5)

Per `keywords/taunt_v0.md`, 4 Last Legion cards are flagged for TAUNT tagging at the next engine-wiring heartbeat (Phase 2.12.E1). Markdown-level design flag only this run; `.tres` `keywords` array edits happen at E1 after Paul's keyword approval, same pattern as M1 → M2 for PERSIST.

| Card | Rarity | Current keywords | TAUNT rationale | Risk note |
|---|---|---|---|---|
| **L7 Sergeant-Smith Vikar** | R | SHIELD-1 + RALLY | Flagship 4-cost; the "hold the line" leader. TAUNT confirms his role as the formation soak. | None — stat-line untouched. |
| **L11 Iron Watch Standard-Bearer** | U | RALLY | Mid-curve front-line body. Currently flex; TAUNT gives him a clear soak role. | None. |
| **L18 Echo-Sergeant** | R | ECHO | Echo+Taunt creates a "replays the soak" pattern that's flavour-perfect for the Tempo-Echo archetype. | Echo-proc-on-Taunt-absorption is a B3-polish detail (visual feedback only); does not change combat math. |
| **L33 Banner-Captain of the Crowned Anvil** | R | SHIELD-1 + RALLY-2 | Banner-Captain payoff. Standing in front of the banner IS the fantasy. | None — stat-line untouched. |

**Density:** 4 / 40 = 10% of pool. Spread across rarities (3R + 1U) — Common-tier TAUNT deliberately omitted to keep formation-style decks rewarding rare-pulls rather than handing it to the C-curve. Reconsider density at first balance review if Legion mirror-matches feel oppressive.


---

## M7 cohesion-audit addition (2026-05-26 by Controller)

Per `archetypes_v0.md` §"Sub-archetype cohesion audit" — D3 Banner-Buff was rated LOOSE because the spine borrowed from D1 (Pikeman) and D2 (Echo-Sergeant), leaving D3 with no unique 3-cost anchor. One new uncommon added:

| Card | Rarity | Cost | Stats | Role |
|---|---|---|---|---|
| **L41 Banner-Bearer of the Crowned Anvil** | U | 3 | 3 HP / 2 ATK / Range-M / CD-1 | Front-line spine for Banner-Buff. While a friendly banner stands in this row, gains +1 ATK and Pierce. Banner-as-object becomes the spine's primary value lever; rarity ramp now reads Standard-Bearer's Cry (1c spell) → L41 Banner-Bearer (3c U) → L33 Banner-Captain (4c R identity) → Crowned Anvil Standard (5c R payoff). |

`.tres` authored at `game/data/cards/last_legion/L41.tres`. Faction-id 3 / card-type UNIT / rarity UNCOMMON / `keywords=[1]` (PIERCE — engine applies Pierce only when banner present per the effect_text condition; tag declares the kit). Net new card; brings pool from 40 → 41.
