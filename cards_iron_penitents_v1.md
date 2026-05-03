# Iron Penitents — Full Card Pool v1.0 (C2)

_Drafted 2026-05-01 in-session. Full 40-card Iron Penitents pool across the 3 archetypes (Bleed-Stack / Sacrifice-Penance / Cleave-Melee). Designed against `archetypes_v0.md` v0.1 (C1) and the v0.1 anti-synergy grid. Existing 9 cards from `cards_v0.md` v1.0 (P1–P9) absorbed unchanged in this pass; net-new is 31 cards (P10–P40). Card IDs are stable — never reused across rebalance passes, per `card.gd` header convention. Flavour text left punchy and grimdark in the gallows-humour register; no GW/WotC echoes._

## Distribution (target: 40 cards / 60–25–10–5)

| Slot | Target | Authored | Per archetype split |
|---|---|---|---|
| Units | 24 (60%) | 24 | 8 Bleed / 8 Penance / 8 Cleave |
| Spells | 10 (25%) | 10 | 4 Bleed / 4 Penance / 2 Cleave |
| Traps | 4 (10%) | 4 | 1 Bleed / 1 Penance / 2 Cleave |
| Specials (relics) | 2 (5%) | 2 | 1 Bleed-flavoured / 1 Cleave-flavoured (both faction-locked) |
| **Total** | **40** | **40** | |

## Rarity skew

| Rarity | Count | % | Notes |
|---|---|---|---|
| Common (C) | 24 | 60% | The deckbuilding spine; cheap, plentiful, draftable as commons |
| Uncommon (U) | 12 | 30% | Archetype workhorses; 2-cost+ spine cards |
| Rare (R) | 4 | 10% | 3 archetype identities (Hierarch / Saint of Cinders / Confessor-At-Arms) + 1 payoff (Headsman of the Long Aisle). Procession Bleeds the Lane held at U so Bleed decks see it consistently. |

## Format reminder

- **Cost** = mana to play.
- **Units:** HP / ATK / Range (M/S/L) / CD (turns).
- **Rarity:** C / U / R. (No Epic in launch pool — reserved for season-1 expansion.)
- **Keywords used** (no net new in this pool): Cleave, Bleed, Penance, Shield, Sacrifice, Slow.

---

## Bleed-Stack archetype (13 cards)

Identity is **P15 Hierarch of the Open Wound**. Engine: friendly-damage-on-self triggers Bleed-on-random-enemy. Payoff: **P19 Procession Bleeds the Lane** turns Bleed stacks into burst row-clear damage. Splashes into Coven Poison-Stack (DoT scaling). Hard counter: Last Legion Banner-Buff (Shield-1 chains soak the bleed engine).

### Units (8)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| P3 | Crowned Martyr | 2 | 4 | 1 | M | 1 | C | Bleed-1 to any unit that attacks it. _(v0 — unchanged.)_ |
| P10 | Open-Veined Pilgrim | 1 | 1 | 2 | M | 1 | C | On death: apply Bleed-1 to all enemies within 1 tile. |
| P11 | Wound-Tender | 2 | 3 | 1 | M | 1 | C | On attack: apply Bleed-1 to target. |
| P12 | Bone-Lash Whipster | 3 | 3 | 2 | M | 1 | U | On attack: Bleed-1 to target AND adjacent friendly Penitent (triggers Penance). |
| P13 | Pilgrim of the Open Vein | 3 | 4 | 2 | M | 1 | C | Whenever a friendly Penitent in lane takes damage this turn, this unit gains +1 ATK (resets at end of turn). |
| P14 | Stigmata-Bearer | 4 | 3 | 2 | S | 2 | U | Aura: at end of turn, all enemies in lane gain Bleed-1 (caps at Bleed-3 per enemy). |
| P15 | **Hierarch of the Open Wound** | 4 | 4 | 3 | M | 1 | **R** | **Identity.** When a friendly Penitent takes damage, apply Bleed-1 to a random enemy in lane. Once per turn. |
| P16 | Hemorrhage-Saint | 5 | 5 | 3 | M | 1 | U | On play: apply Bleed-1 to all enemies in lane. Whenever a Bleed expires on an enemy, draw 1 card. |

### Spells (4)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| P8 | Hammer of Penance | 2 | C | Deal 4 dmg to a single enemy. Apply Bleed-2. _(v0 — unchanged. Splashes into Cleave-Melee.)_ |
| P17 | Sanguine Vow | 2 | C | Apply Bleed-3 to a single enemy. |
| P18 | Crown of Thorns | 1 | C | Friendly Penitent gains "on attack: Bleed-1 to target" until end of turn. |
| P19 | **Procession Bleeds the Lane** | 6 | **U** | **Payoff.** Deal 1 damage to every enemy on the row per Bleed stack on it. Bleed stacks expire on resolve. _(Held at U not R — Bleed decks need to see it reliably.)_ |

### Traps (1)

| # | Name | Cost | Rarity | Trigger / Effect |
|---|---|---|---|---|
| P20 | Crimson Banner | 3 | U | First enemy entering: Bleed-2 + Slow-1 for 2 turns. |

---

## Sacrifice-Penance archetype (13 cards)

Identity is **P23 Saint of Cinders**. Engine: friendly Penitent deaths grant +1 ATK rest-of-combat to all Penitents (caps at +3). Payoff: **P6 The Crucified Saint** — on-play self-damage feeds Penance. Splashes into Coven Sacrifice-Combo (death triggers cross-feed) but mutually counter via P-Penance ↔ C-Sacrifice-Combo trigger conflict.

### Units (8)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| P1 | Nail-Choir Flagellant | 1 | 2 | 1 | M | 1 | C | **Penance:** +1 ATK each time a friendly Penitent dies this run. _(v0 — unchanged.)_ |
| P2 | Whip-Brother | 1 | 1 | 2 | M | 1 | C | On death: deal 1 dmg to an adjacent friendly Penitent. _(v0 — unchanged.)_ |
| P5 | Iron Choir-Master | 4 | 4 | 2 | S | 1 | U | Aura: friendly Penitents in lane gain +1 ATK while it lives. _(v0 — unchanged. Splashes into Cleave-Melee.)_ |
| P6 | The Crucified Saint | 5 | 6 | 4 | M | 1 | R | On play: deal 2 dmg to all friendly Penitents in lane (triggers Penance). _(v0 — unchanged.)_ |
| P21 | Penitent Acolyte | 1 | 2 | 1 | M | 1 | C | When a friendly Penitent dies in this lane, gain +1 HP (cap +3). |
| P22 | Sin-Eater Novice | 2 | 2 | 2 | M | 1 | C | On play: sacrifice a friendly 1-cost Penitent — gain +2 ATK and Shield-1. |
| P23 | **Saint of Cinders** | 4 | 4 | 2 | M | 1 | **R** | **Identity.** Friendly Penitent deaths grant +1 ATK to all friendly Penitents this combat (caps at +3). |
| P24 | Lash-Master Galor | 3 | 3 | 2 | M | 1 | U | On a friendly Penitent's death anywhere on the board, this unit attacks the nearest enemy for 1 free dmg. |

### Spells (4)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| P7 | Self-Mortification | 0 | C | Deal 1 dmg to all friendly Penitents. Draw 1 card per Penitent damaged (cap 3). _(v0 — unchanged.)_ |
| P9 | Procession of Nails | 3 | U | Friendly Penitents gain +2 ATK this turn. End of turn: sacrifice your lowest-HP Penitent. _(v0 — unchanged.)_ |
| P25 | Vow of Ash | 2 | C | Sacrifice a friendly Penitent. Draw 2 cards. |
| P26 | The Long Confession | 4 | U | Sacrifice up to 3 friendly Penitents. Each one grants you +1 mana and draws 1 card this turn. |

### Trap (1)

| # | Name | Cost | Rarity | Trigger / Effect |
|---|---|---|---|---|
| P27 | Veil of Hair-Shirts | 2 | C | Triggers when a friendly Penitent dies in lane. Apply Penance to all friendly Penitents in lane (+1 ATK rest of combat). |

---

## Cleave-Melee archetype (13 cards)

Identity is **P30 Confessor-At-Arms**. Engine: melee Penitents gain Cleave when attacking 2+ adjacent enemies. Payoff: **P33 Headsman of the Long Aisle** — 5c R Cleave-3 row-clearer. Splashes into Last Legion Rally-Formation (Cleave + adjacency reads native). Hard counter: Skinward Pact Big-Monster (single body sidesteps Cleave).

### Units (8)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| P4 | Hammer-Confessor | 3 | 3 | 3 | M | 1 | U | **Cleave** (hits 2 adjacent enemies). _(v0 — unchanged. Splashes into Bleed-Stack via P8.)_ |
| P28 | Bell-Striker Initiate | 1 | 2 | 2 | M | 1 | C | First attack each turn: Cleave-1. |
| P29 | Long-Aisle Pilgrim | 2 | 3 | 2 | M | 1 | C | While 2+ enemies are adjacent to this unit, gain Cleave. |
| P30 | **Confessor-At-Arms** | 4 | 4 | 3 | M | 1 | **R** | **Identity.** Friendly melee Penitents gain Cleave when attacking 2+ enemies in adjacent tiles. |
| P31 | Brother Bullhammer | 3 | 4 | 3 | M | 2 | U | Cleave-2. CD-2 reflects the swing wind-up. |
| P32 | Hooded Headsman | 4 | 3 | 4 | M | 1 | U | On kill: gain +1 ATK rest of combat (caps +3). |
| P33 | **Headsman of the Long Aisle** | 5 | 5 | 4 | M | 1 | **R** | **Payoff.** Cleave-3 (hits the entire row tier). On play: enemies in lane take 1 damage. |
| P34 | Iron Vespers | 4 | 5 | 2 | M | 1 | U | Cleave-1. On attack: adjacent friendly Penitents gain +1 ATK this turn. |

### Spells (2)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| P35 | Hammer Service | 1 | C | A friendly Penitent gains Cleave for its next attack. |
| P36 | The Long Office | 3 | C | Deal 2 dmg to all enemies in a 3-tile line. |

### Traps (2)

| # | Name | Cost | Rarity | Trigger / Effect |
|---|---|---|---|---|
| P37 | Iron Pews | 1 | C | First enemy on tile: 1 dmg + adjacent enemies take 1 dmg. |
| P38 | Confession Booth | 3 | U | Triggers on 2+ enemies entering: Root 1 turn + Bleed-1 to each. _(Cleave-Bleed splash trap.)_ |

---

## Specials — equippable relics (2)

Specials are run-persistent equippables claimed at reward nodes. They occupy a relic slot (3 slots per run), are NOT shuffled into the deck, and are faction-locked.

| # | Name | Slot | Rarity | Effect |
|---|---|---|---|---|
| P39 | Reliquary of Wounds | Relic | U | At end of each turn, deal 1 damage per Bleed stack on enemies in your lane to those enemies (caps at 5 dmg/turn). |
| P40 | Crown of the Hanged Confessor | Relic | R | While you have ≥3 friendly Penitents in any lane, all Penitents gain Cleave-1. |

---

## Cross-archetype splash cards (in-faction overlap)

| # | Name | Splashes | Why |
|---|---|---|---|
| P4 | Hammer-Confessor | Cleave + Bleed | Cleave attack pairs with Hammer of Penance Bleed-2 spell |
| P5 | Iron Choir-Master | Penance + Cleave | +1 ATK aura helps both archetypes |
| P8 | Hammer of Penance | Bleed + Cleave | 4 dmg + Bleed-2 hits both damage curves |
| P12 | Bone-Lash Whipster | Bleed + Penance | Bleed AND friendly damage (Penance feed) |
| P38 | Confession Booth | Cleave + Bleed | Trap that applies Bleed |

## Cross-faction splash cards (Penitents → other factions)

| # | Card | Splashes into | How |
|---|---|---|---|
| P12 | Bone-Lash Whipster | Coven Sacrifice-Combo | Bleed + friend-damage feeds the corpse engine |
| P25 | Vow of Ash | Coven Sacrifice-Combo | Sacrifice → draw is faction-agnostic value |
| P22 | Sin-Eater Novice | Last Legion Rally-Formation | +2 ATK / Shield-1 reads as a tempo unit anywhere |
| P19 | Procession Bleeds the Lane | Coven Poison-Stack | DoT scaling rewards both Bleed and Poison decks |
| P34 | Iron Vespers | Last Legion Rally-Formation | Cleave-1 + adjacency +1 ATK is a row-buff hybrid |

Five splash hooks → meets the C7 cross-faction balance target ("≥2 cards splash cleanly into a rival faction's archetype").

---

## Open questions / flags for Paul

1. **Specials slot model** — relics are run-persistent equippables (3 slots per run, claimed at reward nodes, NOT in deck). Match your mental model? If you want specials to be in-deck cards instead, P39/P40 reshape into 3–4 cost spells.
2. **The Crucified Saint (P6) vs Hierarch of the Open Wound (P15)** — both are 5-cost-tier-or-lower Bleed payoffs. P6 5c R unchanged; P15 4c R new identity. Comfortable having both? Or re-tier P6 for clearer hierarchy?
3. **Trap density** — 4 traps total (1 Bleed / 1 Penance / 2 Cleave) hits the brief's 10% target exactly. Cleave-Melee got the extra trap because it lacks a Resurrect engine and benefits most from chokepoint setups. Want different distribution?
4. **Existing P1–P9 stat changes** — currently all unchanged. If you want a balance pass on v0 cards (e.g., Hammer-Confessor 3/3/3 → 3/4/3 to anchor Cleave harder, or P6 reshape), flag now and I fold into v1.

## Change log

- **v1.0 (2026-05-01)** — initial 40-card pool authored from C1 archetype briefs + `cards_v0.md` v1.0. Existing P1–P9 absorbed unchanged. 31 net-new cards (P10–P40). 60/25/10/5 distribution hit exactly. 4 Rares (3 identities + 1 payoff). 2 specials introduced (relics).

_Next step: heartbeat authors `.tres` files for P10–P40 in `game/data/cards/iron_penitents/`. Existing P1–P9 may be migrated into the same subfolder for tidiness — flag for B2.x bookkeeping when the Iron Penitents pool is locked._
