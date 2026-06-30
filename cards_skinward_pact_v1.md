# Skinward Pact — Full Card Pool v1.0 (C6)

_Drafted 2026-05-02 in heartbeat. Net-new faction in the cards file (no v0 cards — `cards_v0.md` v1.0 covered Penitents/Mourners/Coven only; C5 added the Last Legion). All 40 cards authored fresh as IDs W1–W40. Designed against `archetypes_v0.md` v0.1 (E1/E2/E3) and the v0.1 anti-synergy grid. Faction = canonical Track A — **Skinward Pact** (`GFEnums.Faction.SABLE_WILDS` in code; engine constant left unchanged this pass per L2 cleanup queue). Pool tuned to the same 60–25–10–5 distribution and 24/12/4 rarity skew as the prior four faction pools._

## Distribution (target: 40 cards / 60–25–10–5)

| Slot | Target | Authored | Per archetype split |
|---|---|---|---|
| Units | 24 (60%) | 24 | 8 Big-Monster / 8 Transformation / 8 Beast-Summon |
| Spells | 10 (25%) | 10 | 4 Big-Monster / 4 Transformation / 2 Beast-Summon |
| Traps | 4 (10%) | 4 | 1 Big-Monster / 1 Transformation / 2 Beast-Summon |
| Specials (relics) | 2 (5%) | 2 | 1 Transformation-flavoured / 1 Beast-Summon-flavoured |
| **Total** | **40** | **40** | |

## Rarity skew

| Rarity | Count | % | Notes |
|---|---|---|---|
| Common (C) | 24 | 60% | Cheap fuel, 2-cost spine, draftable mass + the two summoned token-shape cards (W27 Cub-Token, W28 Wolf-Token are 0c C is_draftable=true, mirroring C1 Bog-Spawn) |
| Uncommon (U) | 12 | 30% | Archetype workhorses + payoff spells (Crown of Bone, The Antler-King Awakened, Pack-Call of the Cinderwood) + 2 relics |
| Rare (R) | 4 | 10% | 3 archetype identities (Bear-Skin Hierophant / Wyrd-Shifter of the Cinderwood / Pelt-Bound Shaman, all 4c R) + 1 payoff (Thrask, the Bear-Who-Was-King — 6c R) |

## Format reminder

- **Cost** = mana to play.
- **Units:** HP / ATK / Range (M/S/L) / CD (turns).
- **Rarity:** C / U / R.
- **Hard keywords (in `GFEnums.Keyword`):** Cleave, Pierce, Shield, Fear, Summon, Sacrifice. (No net-new hard keywords — Transformation expressed in card text only this pass; flagged Q1 below for engine-side enum addition.)
- **Wilds tag:** all faction-4 (SABLE_WILDS) cards count as Wilds for archetype lookups (transformation eligibility, beast-token tag, big-monster scaling). Tokens (Cub, Wolf) are tagged Wilds.
- **Wolf-Token / Cub-Token:** Wilds-tagged unit tokens. Wolf = 1/2 M CD1. Cub = 1/1 M CD1. Both authored as 0c C draftable cards (W27, W28) so the deckbuilder can include them, AND generated as runtime tokens by other cards (Pelt-Bound Shaman, Pack-Call of the Cinderwood, Cub-Cry, Den-Mother, Whelping Burrow, Hunter's Snare, Whelp-Caller). Mirrors C1 Bog-Spawn pattern from Coven.
- **Soft keyword — Transformation:** "transform a friendly Wilds into a beast costing N more — gains its statline + keywords." Expressed in card text only this pass; not in keyword enum yet (Q1).

---

## Big-Monster archetype (13 cards)

Identity is **W4 Bear-Skin Hierophant (4c R)** — your highest-cost friendly Wilds unit gains +2 HP and Cleave. Payoff: **W8 Thrask, the Bear-Who-Was-King (6c R)** — 8/8 melee, on summon exile a Wilds card from hand to gain its keywords. Engine: drop one big chassis per lane → buff/scale it up via Hierophant + Crown of Bone + auras → win the lane with one fat body. Splashes into Last Legion Banner-Buff (one big body + Shield-1 aura is the canonical "stall tower"). Hard counter: Last Legion Tempo-Echo (Echo's per-attack value wastes on a single big chassis, AND eats Big-Monster's mana curve — locked v0.1 grid).

### Units (8)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| W1 | Pelt-Gathered Hunter | 2 | 2 | 2 | M | 1 | C | +1 ATK while a friendly Wilds is at full HP. |
| W2 | Antler-Grown Ranger | 3 | 3 | 3 | S | 1 | C | +1 ATK while no other friendly Wilds is in lane. |
| W3 | Cinderwood Stalker | 4 | 3 | 3 | M | 1 | U | When this attacks, heal it 1. (Soft-Lifesteal — text-only intentionally. The real `LIFESTEAL = 16` keyword now exists per `keywords/lifesteal_v0.md` 2026-05-26 but heals for damage-dealt, not fixed 1. W3 stays soft pending balance review — flag for Paul.) |
| W4 | **Bear-Skin Hierophant** | 4 | 4 | 3 | S | 1 | **R** | **Identity.** Your highest-cost friendly Wilds unit gains +2 HP and Cleave. |
| W5 | Old-Wyrm Whelp | 2 | 3 | 1 | M | 1 | C | When a friendly Wilds in lane reaches 5+ HP, this gains +1 ATK (cap +2). |
| W6 | Boneward Behemoth | 5 | 6 | 4 | M | 2 | U | Shield-2. |
| W7 | Cinder-Maned Lion | 5 | 5 | 4 | M | 2 | C | When you summon a Wilds in this lane, this gains +1 ATK this turn. |
| W8 | **Thrask, the Bear-Who-Was-King** | 6 | 8 | 8 | M | 2 | **R** | **Payoff.** On summon: exile a Wilds card from hand; this gains its keywords for the rest of the combat. |

### Spells (4)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| W9 | Cinder Roar | 1 | C | Your highest-cost friendly Wilds gains +1 HP this turn. |
| W10 | **Crown of Bone** | 4 | **U** | A friendly Wilds gains +2 HP and Pierce this turn. |
| W11 | Wild Howl | 2 | C | A friendly Wilds gains Cleave this turn. |
| W12 | Lone-Hunt | 3 | C | If you control exactly 1 friendly Wilds, it gains +3 ATK this turn. |

### Traps (1)

| # | Name | Cost | Rarity | Trigger / Effect |
|---|---|---|---|---|
| W13 | Den-Pit | 2 | C | First enemy on tile: take 3 damage. The nearest friendly Wilds gains +1 ATK this combat. |

---

## Transformation archetype (13 cards)

Identity is **W19 Wyrd-Shifter of the Cinderwood (4c R)** — once per turn, pay 3 mana, transform a friendly Wilds unit into a beast costing 2 more (gains its statline + keywords). Payoff: **W24 The Antler-King Awakened (6c U spell)** — transform any friendly Wilds unit into a 7/7 with Cleave + Fear (overrides cost-of-target rule). Engine: drop cheap Wilds chaff → spend 3 mana per turn growing the curve up the cost ladder → finish with Antler-King at 6 mana for a 7/7 swing. Splashes into Coven Sacrifice-Combo (sacrifice → transform is a 2-card combo line). Hard counter: Ash-Mourners Resurrect-Spam (Wraiths are tokens — engine-flagged as non-Wilds for transform targeting; invalid transform targets).

### Units (8)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| W14 | Cub of the Sundered Tree | 1 | 1 | 1 | M | 1 | C | When a friendly Wilds dies, this gains +1/+1 (cap +3/+3). |
| W15 | Wyrd-Touched Initiate | 2 | 2 | 2 | M | 1 | C | When transformed, this also gains +1 ATK on top of the new statline. |
| W16 | Skin-Walker Apprentice | 2 | 2 | 2 | S | 1 | C | Wilds-tagged transform target. Pay 1 mana: target Wilds gains +1 ATK this turn. |
| W17 | Half-Wolf Initiate | 3 | 3 | 2 | M | 1 | C | Pierce. Wilds-tagged transform target. |
| W18 | Hide-Sworn Bonebinder | 3 | 2 | 3 | S | 1 | U | When a friendly Wilds transforms, draw 1 (cap 2/combat). |
| W19 | **Wyrd-Shifter of the Cinderwood** | 4 | 4 | 4 | S | 1 | **R** | **Identity.** Once per turn, pay 3 mana: transform a friendly Wilds into a beast costing 2 more (gains its statline + keywords). |
| W20 | Stag-Crowned Witness | 4 | 3 | 4 | S | 1 | U | When a friendly Wilds transforms in lane, this gains +1 ATK (cap +3). |
| W21 | Skin-Lord Augur | 5 | 4 | 4 | M | 2 | U | On play: transform the cheapest Wilds in lane into a beast costing 2 more (free, no per-turn cap). |

### Spells (4)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| W22 | Wyrd-Bind | 1 | C | Your next Transformation this combat costs 1 less. |
| W23 | Beast-Skin Rite | 3 | C | Transform a friendly Wilds into a beast costing 2 more. (Ignores per-turn cap.) |
| W24 | **The Antler-King Awakened** | 6 | **U** | **Payoff.** Transform any friendly Wilds unit on the board into a 7/7 with Cleave + Fear (overrides cost-of-target rule). |
| W25 | Mantle of the Bear | 2 | C | A friendly Wilds gains +2 HP this turn; if it has been transformed this combat, +2 ATK as well. |

### Traps (1)

| # | Name | Cost | Rarity | Trigger / Effect |
|---|---|---|---|---|
| W26 | Skin-Snare Trap | 2 | C | First enemy on tile: take 2 damage. The nearest friendly Wilds gains +1/+1 this combat. |

---

## Beast-Summon archetype (12 cards)

Identity is **W31 Pelt-Bound Shaman (4c R)** — at start of each turn, summon a 1/2 Wolf-Token in your lane (cap 3 Wolves). Payoff: **W36 Pack-Call of the Cinderwood (5c U spell)** — summon 1/2 Wolf-Tokens equal to friendly Wilds units in lane (cap 4). Engine: stack token generators → flood lane with Wolves and Cubs → buff with Pack-Sworn Houndmaster + Wolf-Pelt Sigil → out-trade smaller swarms. Splashes into Coven Bog-Spawn Swarm (token-summoner overlap; combined wolf+bog-spawn screen is a viable midrange shape). Hard counter: Last Legion Rally-Formation (Wolves are 1/2; formation Pierce/Cleave row-clears before the pack scales).

### Units (8)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| W27 | Cub-Token | 0 | 1 | 1 | M | 1 | C | Wilds-tagged token. Draftable 0-cost. Also generated by Skinward Pact summon cards. |
| W28 | Wolf-Token | 0 | 2 | 1 | M | 1 | C | Wilds-tagged token. Draftable 0-cost. Also generated by Skinward Pact summon cards. |
| W29 | Whelp-Caller | 2 | 2 | 2 | S | 1 | C | On play: summon a 1/1 Cub-Token in your lane. |
| W30 | Pack-Runner | 2 | 3 | 2 | M | 1 | C | +1 ATK while a friendly Wolf-Token is in lane. |
| W31 | **Pelt-Bound Shaman** | 4 | 4 | 3 | S | 1 | **R** | **Identity.** At start of each turn, summon a 1/2 Wolf-Token in your lane (cap 3 Wolves). |
| W32 | Bone-Whistler | 3 | 3 | 3 | S | 1 | C | When you summon a Wolf or Cub token, that token gains +1 HP this combat. |
| W33 | Pack-Sworn Houndmaster | 5 | 4 | 4 | M | 1 | U | Friendly Wolf-Tokens and Cub-Tokens in lane gain +1 ATK. |
| W34 | Den-Mother | 5 | 4 | 5 | S | 2 | C | At end of your turn, summon a 1/2 Wolf-Token in your lane (cap 3 Wolves). |

### Spells (2)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| W35 | Cub-Cry | 1 | C | Summon a 1/1 Cub-Token in your lane. |
| W36 | **Pack-Call of the Cinderwood** | 5 | **U** | **Payoff.** Summon 1/2 Wolf-Tokens equal to the number of friendly Wilds units in lane (cap 4). |

### Traps (2)

| # | Name | Cost | Rarity | Trigger / Effect |
|---|---|---|---|---|
| W37 | Hunter's Snare | 2 | C | First enemy on tile: take 2 damage; summon a 1/1 Cub-Token in your lane. |
| W38 | Whelping Burrow | 3 | U | First enemy on tile: take 2 damage; summon a 1/2 Wolf-Token on the empty tile behind. |

---

## Specials / Relics (2)

| # | Name | Cost | Rarity | Type | Effect |
|---|---|---|---|---|---|
| W39 | Antler-Crown Sigil | 0 | U | Spell-shaped relic | RELIC. The first Transformation each combat costs 0 mana. `is_draftable=false`, `unlock_tag=&"relic_skinward_pact"`. |
| W40 | Wolf-Pelt Sigil | 0 | U | Spell-shaped relic | RELIC. Wolf-Tokens you control gain +1 HP. `is_draftable=false`, `unlock_tag=&"relic_skinward_pact"`. |

---

## Cost curve (40 cards)

| Cost | Count | IDs |
|---|---|---|
| 0 | 4 | W27 Cub-Token, W28 Wolf-Token, W39 Antler-Crown Sigil, W40 Wolf-Pelt Sigil |
| 1 | 4 | W9 Cinder Roar, W14 Cub of the Sundered Tree, W22 Wyrd-Bind, W35 Cub-Cry |
| 2 | 11 | W1, W5, W11, W13, W15, W16, W25, W26, W29, W30, W37 |
| 3 | 7 | W2, W12, W17, W18, W23, W32, W38 |
| 4 | 6 | W3, W4, W10, W19, W20, W31 |
| 5 | 6 | W6, W7, W21, W33, W34, W36 |
| 6 | 2 | W8 Thrask, W24 The Antler-King Awakened |

_Curve audit: 4 + 4 + 11 + 7 + 6 + 6 + 2 = 40 ✓. Curve is 2c-heavy (bottom-mid heavy) — Beast-Summon archetype needs cheap chaff every turn for Pelt-Bound Shaman / Pack-Call to scale. Spike at 4c is the identity-card cluster (3 of 4 Rares at 4c). Single 6c R unit (Thrask) + 6c U spell (Antler-King) sit at top. The two 0c relics + two 0c token-draftables together form the "free" floor; the 4 token+relic 0-costs are NOT mana-curve filler in practice (relics are out-of-deck, tokens are mostly summoned not played from hand)._

---

## Splashes into rival archetypes (≥2 hooks per faction target)

- **W17 Half-Wolf Initiate (3c C, Pierce, Wilds-tagged)** → Last Legion Rally-Formation: Pierce + adjacency-friendly statline reads native as Legion melee anchor.
- **W6 Boneward Behemoth (5c U, Shield-2)** → Last Legion Banner-Buff: Shield-2 stacks with Banner-Captain's Shield-1 row aura — turtle hybrid.
- **W14 Cub of the Sundered Tree (1c C, growth on Wilds death)** → Coven Sacrifice-Combo: Cub triggers off Bog-Spawn sacrifices when re-tagged Wilds (engine work flagged).
- **W34 Den-Mother (5c C, Wolf-Token at end of turn)** → Coven Bog-Spawn Swarm: token-summoner overlap; combined wolf+bog-spawn screen is the canonical token-shape midrange.
- **W26 Skin-Snare Trap (2c C, +1/+1 on first hit)** → Ash-Mourners Trap-Control: trap-payoff payload reads native to Trap-Control buff cycle.

Five splashes — meets brief.

---

## Anti-synergy hard counters wired (v0.1 grid)

- E1 Big-Monster (W4 Bear-Skin Hierophant + W8 Thrask) hard-countered by Last Legion Tempo-Echo (D2 — L18 Echo-Sergeant + L25 Hammer-Stroke Doctrine). Echo's per-attack value wastes on a single big chassis AND eats Big-Monster's mana curve.
- E2 Transformation (W19 Wyrd-Shifter + W24 The Antler-King Awakened) hard-countered by Ash-Mourners Resurrect-Spam (B2 — M6 Pyre-Priest summons Wraiths, which are tokens — invalid transformation targets).
- E3 Beast-Summon (W31 Pelt-Bound Shaman + W36 Pack-Call) hard-countered by Last Legion Rally-Formation (D1 — L7 Vikar + L9 Iron Standard Unfurled). Wolves are 1/2; formation Pierce/Cleave row-clears before pack scales.

---

## Open questions for Paul

1. **Transformation-as-keyword.** Same shape as Echo (C5). Used in card text on 9 cards (W14, W15, W18, W19, W20, W21, W22, W23, W24, W25). Recommend adding `TRANSFORM = 15` to `enums.gd` alongside `ECHO = 14` (C5 Q1) before B2.5 wave-spawner work — affects on-play resolution. Engine arrays empty for Transformation-only cards this pass.
2. **Wilds tag — engine field or faction lookup?** Currently the spec says "all faction-4 cards count as Wilds for archetype lookups." But Wraiths (tokens summoned by faction-1 / Ash-Mourners cards) explicitly DON'T count. So the engine needs either a `is_wilds` bool field on Card OR a hard-coded faction-4 lookup. Smaller-scope option: use faction-4 lookup; flag a future `tags: Array[StringName]` field on Card for cross-faction tags (Wilds, Beast, Token, etc.).
3. **Token cards as draftable C vs token-only.** W27 Cub-Token and W28 Wolf-Token are authored as draftable 0c cards (mirroring C1 Bog-Spawn). Alternative: leave them token-only (`is_draftable=false`) and remove from the deckbuilder pool — then the 24 C count drops to 22, need to re-promote 2 Us → Cs to balance. Paul's call.
4. **Thrask exile-a-Wilds-from-hand mechanic.** W8 Thrask exiles a Wilds card from hand on summon to gain its keywords. Engine needs an Exile zone + a "card-as-keyword-source" lookup. Could be simplified to "Cleave + Pierce + Shield" baked-in keywords on Thrask (lose flavour, gain implementation simplicity). Paul's call.
5. **Relic-system unification (Q4 from C5).** W39 Antler-Crown Sigil and W40 Wolf-Pelt Sigil match the C5/C4/C3/C2 relic pattern (`card_type=SPELL`, `is_draftable=false`, `unlock_tag=&"relic_<faction>"`). Still pending unified relic-slot system per Paul's open question. Carried.
6. **Lifesteal soft-keyword on W3 Cinderwood Stalker.** ~~Heals 1 on attack — expressed as text only this pass. Tiny scope, single card. Could fold into a future `LIFESTEAL = 16` enum addition or stay text-only. Low priority.~~ **RESOLVED 2026-05-26 by Controller.** `LIFESTEAL = 16` keyword promoted to enum in `keywords/lifesteal_v0.md` + `enums.gd`. Promotion driven by Phase 2.13 N4 (W42 Den-Mother's aura grant of Lifesteal to Wolf-Tokens needs a real keyword to grant). W3 NOT retagged — keyword heals for `damage_dealt`, W3's text was fixed-1 heal; retagging would silently buff W3 from heal-1 to heal-up-to-3-per-hit. W3 stays soft-Lifesteal pending Paul balance call. Open flag: agree W3 stays soft OR explicitly approve the heal-1-to-keyword buff at next balance pass. **RESOLVED 2026-05-28 by Cowork Claude (per Paul's "ungate anything I have gated, no cost implication" directive).** W3 retagged to `LIFESTEAL`. Rationale: (1) **keyword consistency** — engine path validated by `LIFESTEAL.E1` cycle; every other Lifesteal-flavoured card now uses the keyword (W42 aura grant target); maintaining bespoke effect_text for W3 alone is dead weight. (2) **Buff is bounded** — Lifesteal heals `damage_dealt` capped at `max_hp`; W3 max_hp is 3, so the worst-case heal is +3/turn vs the old +1/turn. The strict upper-bound matters: no "scales with stack buffs to infinity" failure mode. (3) **Stat line is balanced** — 4-cost / 3-atk / 3-hp UNCOMMON with Lifesteal is reasonable for Skinward Pact's "big-monster persistence" archetype; not a meta-warper at that line. (4) **No engine work** — single-line `.tres` edit; engine already handles LIFESTEAL via the validated keyword path. Edits applied: `W3.tres` keywords `[]` → `[16]`; effect_text "When this attacks, heal it 1." → "Lifesteal." If post-playtest data shows W3 over-performing, the fix is a stat-line nerf (e.g. attack 3→2), NOT a keyword revert — keep keyword consistency.

---

_v1.0 done. 40 cards authored. Next eligible heartbeat item: C7 (cross-faction balance pass — validate the v0.1 anti-synergy grid + rarity skew across all 5 factions × ~40 cards = 200 cards)._

---

## M7 cohesion-audit additions (2026-05-26 by Controller)

Per `archetypes_v0.md` §"Sub-archetype cohesion audit" — E3 Beast-Summon was rated LOOSE because its spine duplicated E1 Big-Monster's roster (Cub / Antler-Grown Ranger / Cinderwood Stalker) across the 1-4 mana range, leaving E3 indistinguishable from E1 at draft time. Two new commons added to make the E1 / E3 split legible:

| Card | Rarity | Cost | Stats | Role |
|---|---|---|---|---|
| **W41 Pack-Caller Initiate** | U | 3 | 2 HP / 2 ATK / Range-S / CD-1 | Card-draw engine tied directly to token economy. When a friendly Wolf-Token is summoned in lane, draw 1 (cap once/turn). Differentiates E3 by giving it mid-game velocity E1 doesn't have. |
| **W42 Den-Mother of the Cinderwood** | U | 4 | 4 HP / 2 ATK / Range-M / CD-1 | Curve-topping spine for E3. Friendly Wolf-Tokens in lane gain +1/+1 and Lifesteal while she is in lane. Anchors the swarm at 4-cost; pairs with W31 Pelt-Bound Shaman (4c R identity) without redundancy. |

`.tres` authored at `game/data/cards/skinward_pact/W41.tres` and `W42.tres`. Both faction-id 4 / card-type UNIT / rarity UNCOMMON / `keywords=[]` (bespoke effects; Lifesteal on W42 is the same soft-keyword pattern as W3 Cinderwood Stalker per open Q6). Pool grows from 40 → 42.

**Open question carried**: same as Q6 in this doc — Lifesteal is text-only on 2 cards now (W3 + W42). At 3 cards we should consider promoting to a real `LIFESTEAL = 16` enum entry. Defer to next balance pass.
