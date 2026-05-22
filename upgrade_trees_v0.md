# Upgrade trees v0 — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory items UPG-1..5. Unifies the three upgrade systems referenced across the project — meta-progression (Ancestor Tree), in-run upgrades (REST nodes — already in `rests_v0.md`), Warlord Ascension (post-T4 difficulty ladder). Adds the missing relic catalogue (UPG-5) since relics are the primary in-run upgrade vector._

**Status:** v0 draft. **Anti-P2W invariant locked.** Pending Paul sign-off on Open Qs.

---

## 1. Three upgrade systems, three layers

The game has three distinct upgrade axes. They never share state but they share UI conventions and anti-P2W rules.

| Layer | Lifetime | Currency | Affects | Reset on |
|---|---|---|---|---|
| **In-run upgrade** (REST + SHOP service slot) | run-only | Gold (in-run) | per-`CardInstance` stat delta | run end |
| **Card mastery** (per-card play counter) | persistent | — (auto-earned) | cosmetic only — unlocks Foil + alt-art slot | never (persistent) |
| **Ancestor Tree** (meta-progression) | persistent | Bones | starting deck options, starting gold buff, mulligan size, Ascension unlock | never (persistent) |
| **Warlord Ascension** (post-mastery difficulty ladder) | persistent | (earned by winning at lower Ascension) | run modifiers (+enemy HP / +HH severity / -starting HP etc.) + cosmetic | never (persistent) |

**Why four total when this doc is "Upgrade Trees":** the REST upgrade is a *system* not a *tree*. Card mastery is a passive auto-earned curve. Ancestor Tree + Ascension are the actual *tree* shapes. All four are in one doc so a developer has one place to look.

---

## 2. Ancestor Tree (UPG-1) — meta-progression

### 2.1 Premise

> The dead of Gallowfell remember you. As you return between runs, each death gives you back a fragment of what they knew. The Ancestor Tree is the bone-grove at the foot of the gallows. Each unlock is a name added to the marker.

The Ancestor Tree is a node-graph progression UI (think Hades' Mirror of Night, plus Slay the Spire's persistent unlocks, minus power-creep). 36 nodes. Spent in **Bones**.

### 2.2 Tree shape — 4 branches × 9 nodes each = 36 total nodes

```
                          [ROOT NODE — free]
                                |
        +-----------+-----------+-----------+
        |           |           |           |
    [BLOOD]      [BONE]      [BREATH]    [BIND]
    (offence)    (defence)    (utility)   (meta)
        |           |           |           |
       ...         ...         ...         ...
      (9 each)
```

Each branch = 9 unlock nodes. Each node = cost in Bones + prerequisite. Some nodes have a 2-of-3 fork further down. Total 36 unlocks.

### 2.3 Branch contents

#### BLOOD (offence) — 9 nodes

| Node | Cost (Bones) | Effect | Prereq |
|---|---|---|---|
| B1 | 50 | Starting hand contains +1 random Common card | ROOT |
| B2 | 100 | Run-start: +5 starting Gold | B1 |
| B3 | 200 | Damage dealt to enemies during turn 1 +1 | B2 |
| B4 | 350 | Reward screen offers 1 extra card (1 of 4 not 1 of 3) | B3 |
| B5 | 500 | Run-start: gain 1 random Common-relic | B4 |
| B6 | 750 | (FORK A) Cards costing 3+ enter with Bleed-1 next combat |
| B6 | 750 | (FORK B) BLEED stacks last +1 turn before decay |
| B7 | 1,000 | Win bonus: +10 Bones per chapter-1 boss kill | B5 |
| B8 | 1,500 | (FORK A) Sacrifice-trigger cards refund 1 Gold |
| B8 | 1,500 | (FORK B) Penance keyword cards heal you for 1 on cast |
| B9 | 2,500 | **Ancestor T1 — _Open the Bone-Grove_:** Unlock Ascension 1 for any Warlord at T4 |

**Total BLOOD cost:** ~6,950 Bones (≈ 8-10 runs at perfect-run Bones yield).

#### BONE (defence) — 9 nodes

| Node | Cost | Effect | Prereq |
|---|---|---|---|
| C1 | 50 | Run-start: +5 max HP | ROOT |
| C2 | 100 | Run-start: +1 mulligan token | C1 |
| C3 | 200 | After a defeat, retain 50% of run Gold as Bones at conversion | C2 |
| C4 | 350 | First combat each run: heal +5 HP at end | C3 |
| C5 | 500 | Block effects reduce damage by +1 | C4 |
| C6 | 750 | (FORK A) SHIELD keyword grants +1 shield charge |
| C6 | 750 | (FORK B) PERSIST units return at base ATK -1 (instead of -2 if other -X stacks) |
| C7 | 1,000 | Run-start: +10 max HP (stacks with C1) | C5 |
| C8 | 1,500 | (FORK A) ROOT and SLOW durations +1 turn |
| C8 | 1,500 | (FORK B) FEAR keyword no longer affects friendly units |
| C9 | 2,500 | **Ancestor T2 — _Close the Catacomb-Gate_:** Unlock Ascension 5 (requires T1 unlocked) |

#### BREATH (utility) — 9 nodes

| Node | Cost | Effect | Prereq |
|---|---|---|---|
| D1 | 50 | Run-start: +1 starting hand size | ROOT |
| D2 | 100 | Map nodes show their kind 1 step further ahead | D1 |
| D3 | 200 | Shop reroll cost -10 Gold | D2 |
| D4 | 350 | Event-card outcome preview reveals 1 hidden payoff | D3 |
| D5 | 500 | Daily-quest XP +10% | D4 |
| D6 | 750 | (FORK A) REST node heal +10 HP |
| D6 | 750 | (FORK B) REST node upgrade picks +1 (R1: 2 picks, R2: 3 picks) |
| D7 | 1,000 | Run-end: +5% Bones conversion rate | D5 |
| D8 | 1,500 | (FORK A) Shop service slot offers 2 services not 1 |
| D8 | 1,500 | (FORK B) Per-chapter, the first SHRINE rolls "Pray" outcome free |
| D9 | 2,500 | **Ancestor T3 — _Hear the Bells_:** Unlock Ascension 11 (requires T2 unlocked) |

#### BIND (meta) — 9 nodes

| Node | Cost | Effect | Prereq |
|---|---|---|---|
| E1 | 50 | Bones cap +1000 | ROOT |
| E2 | 100 | Bones cap +5000 | E1 |
| E3 | 200 | Run-end: per-Warlord XP +10% (multiplier registered) | E2 |
| E4 | 350 | Per-Warlord T3 alt-fire unlock requirement reduced by 5 wins | E3 |
| E5 | 500 | Per-Warlord T4 mastery unlock requirement reduced by 5 wins | E4 |
| E6 | 750 | (FORK A) Per-card mastery counter +10% per play |
| E6 | 750 | (FORK B) Card-mastery-Foil unlock at 30 plays not 50 |
| E7 | 1,000 | Run-end: +1 daily-quest re-roll | E5 |
| E8 | 1,500 | (FORK A) Soul earn rate +1 per chapter cleared above Ascension 5 |
| E8 | 1,500 | (FORK B) Vault re-purchase past-season hero -25% gem cost |
| E9 | 2,500 | **Ancestor T4 — _Speak the Name_:** Unlock Ascension 16 (requires T3 unlocked) |

### 2.4 Total Ancestor Tree cost

All 36 nodes = ~28,000 Bones. At ~80-150 Bones per run (varies by victory/loss and Warlord), that's ~250 runs to full completion.

**Pacing target:** dedicated player should reach Ancestor T1 (Ascension 1 unlock) at ~10 runs in, T2 at ~30 runs, T3 at ~70 runs, T4 at ~150 runs. T4 unlock = the prestige milestone.

### 2.5 Anti-P2W audit

| Concern | Test | Pass |
|---|---|---|
| Buy-the-tree shortcut | No gem→Bones conversion exists (per `shop_economy_v0.md` §1 currency rules) | ✅ |
| Power-creep at T4 | T4 unlocks A16 *difficulty*, doesn't grant power | ✅ |
| Mandatory unlocks for content | All 5 free Warlords playable without any unlock; tree only adds buffs | ✅ |
| Cumulative power | All 4 branches' full power ≈ ~+25% effective at full unlock — significant but not paid; capped by tree structure | ✅ |

### 2.6 Respec

**Cost:** 2,500 Bones (≈ T4 single-node cost). Available from Hub > Ancestor menu. Refunds 80% of spent Bones (rounding down) — 20% lost to "the dead don't give it back cleanly". Caps respecs at 3 per season to prevent meta-thrash.

---

## 3. Card mastery (UPG-2)

### 3.1 Premise

Each card tracks a per-account play counter. As the counter climbs, the card unlocks cosmetic tiers. No gameplay buff — pure recognition.

### 3.2 Mastery tiers

| Tier | Tier-name | Plays required | Reward |
|---|---|---|---|
| 1 | Used | 1 | (nothing — initial state on first play) |
| 2 | Known | 10 | Card-mastery sigil visible in collection UI |
| 3 | Mastered | 50 | **1 free Foil treatment token** for this card |
| 4 | Cherished | 200 | **1 free alt-art slot unlocked** (player picks from the 3 alt-art variants if available, else placeholder) |
| 5 | Eternal | 1,000 | **Animated name-plate on this card** (gold-script across the card title) — the connoisseur flex |

### 3.3 Per-card counter

```
CardMasteryProgress: Dictionary[card_id: StringName, play_count: int]
```

Play counter increments by 1 each time the card is played in combat (counts in both run-victory and run-loss scenarios). Tokens (Bog-Spawn, etc.) don't increment — they're auto-summoned, not played.

### 3.4 Anti-P2W audit

| Concern | Test | Pass |
|---|---|---|
| Card-mastery affects gameplay | Counter is read only by Collection UI shader-stack, never by combat logic | ✅ |
| Buying mastery | No "instant Mastered" SKU; only ways to count are play and the E6 Ancestor Tree node (+10% per play, max 1.10× speed) | ✅ |
| Mastery wall blocking content | No content gates behind mastery; only cosmetic | ✅ |

### 3.5 MVP coverage

- IMV-1: counter tracked, no UI surface, no cosmetic unlock (no cosmetics in IMV-1 anyway).
- IMV-2: counter shown in collection grid.
- First commercial pass: rewards (Tier 3+) unlock.

---

## 4. In-run upgrade (UPG-3 — cross-ref `rests_v0.md`)

Already spec'd in `rests_v0.md`. This section is the **dispatch reference** that REST/SHOP/EVENT all read.

### 4.1 Primary-stat upgrade dispatch

Per `rests_v0.md` §"Upgrade rules", the +1 dispatch is keyed off the card's primary stat. Locking the table:

| Card type | Primary stat | +1 means |
|---|---|---|
| UNIT (attack > 0) | `attack` | +1 ATK |
| UNIT (attack == 0, e.g. token-emitting) | `hp` | +1 HP |
| SPELL (damage) | damage value | +1 damage |
| SPELL (heal) | heal value | +1 heal |
| SPELL (status applier — Bleed/Poison/Slow/Root/Fear/Smoke) | stack/turn count | +1 stack or +1 turn |
| SPELL (control — banish/freeze/silence) | duration | +1 turn |
| TRAP (damage) | damage | +1 damage |
| TRAP (charge-counted) | charge count | +1 charge |
| TRAP (lane-effect, e.g. C42 Black Mire Pact) | charge count | +1 charge |
| RELIC (tick) | tick value | +1 tick |
| RELIC (one-shot) | magnitude | +1 magnitude |
| WARLORD | (cannot be upgraded — Warlord cards are not in-deck cards) | — |

**Edge cases (locked):**

- **Multi-stat cards** (e.g. SPELL "deal 2 damage and heal 1"): upgrade picks the **higher-magnitude** stat. Tied? Picks damage first.
- **Tokens upgraded via summon-source** (e.g. upgraded Bog-Spawn-summoner doesn't transitively upgrade Bog-Spawns; they're separate `Card`s, not `CardInstance`s): cross-ref `cards_v0.md` C1 — Bog-Spawn stays at 0/1 even if summoner upgraded. Open Q for Paul whether to add an "upgrade transfers to summons" Ancestor node later.
- **Persist + upgrade interaction** (per `rests_v0.md` Open Q1): Persist debuff applies from base, not from upgraded. So upgraded M5 (ATK 4 → 5) Persists at ATK 4 (5 - 1, with PERSIST -1 against base = 4). Net: +1 stays.

---

## 5. Warlord Ascension (UPG-4)

### 5.1 Premise

After completing the Warlord's Tier-4 mastery path (per `warlord_tiers_full.md`), the Warlord can be played at increasing Ascension ranks. Each rank adds a *difficulty* modifier — never raw player power. Slay-the-Spire pattern.

### 5.2 The 20-rung ladder

Recommendation: **A1..A20**, with per-Warlord modifiers at A5/A11/A16/A20 (the four milestone rungs).

| Rung | Generic modifier (applies to every Warlord) |
|---|---|
| A1 | Boss difficulty +20% |
| A2 | Enemy HP +5% global |
| A3 | Starting Gold halved |
| A4 | Elite difficulty +20% (HORDE rounds 5/7 only) |
| A5 | **Milestone — Warlord-specific A5 modifier** (see §5.3 per-Warlord table) |
| A6 | Hanging Hour triggers at turn 4 (standard) / 3 (boss) |
| A7 | Starting hand -1 card |
| A8 | Enemy ATK +10% global |
| A9 | Shop service slot -1 (only cards/relics, no service) |
| A10 | Reroll cost in shop ×2 |
| A11 | **Milestone — Warlord-specific A11 modifier** (per `warlord_tiers_full.md` — Vyrrun "Long Bleed", Sieren "Ink Runs Pale", etc.) |
| A12 | Starting Gold = 0 |
| A13 | Curse-chance on event "risky" choices +25% |
| A14 | Reanimation curse % chance +5% per chapter (ch1: 10%, ch2: 13%, ch3: 17%) |
| A15 | Boss minions ×1.5 HP |
| A16 | **Milestone — Warlord-specific A16 modifier** (per-Warlord; design-debt slot) |
| A17 | Run-victory rewards halved (forces engagement at peak difficulty) |
| A18 | Starting deck -1 random card |
| A19 | Max HP -10 |
| A20 | **Milestone — Warlord-specific A20 modifier "The Curse Itself"** — see §5.4 |

### 5.3 Per-Warlord A5 modifier table

A5 is the "Warlord starts to fight you back" rung — modifier should bend the Warlord's own identity painfully.

| Warlord | A5 modifier |
|---|---|
| W1 Vyrrun | Mortify costs 4 HP (was 2) — self-damage scales hard at HH |
| W2 Sieren | Hanged Memory triggers only on UNIT death, not on TOKEN death |
| W3 Eddra | Brood Familiars enter at 0/1 (was 1/1) |
| W4 Veska | Forge-Heat draw requires 4+ Host units (was 3+) |
| W5 Mhar | Wear-the-Dead cost reduction floors at 1 (won't reduce below) |
| W6 Vow-Broken Magus | Twinned Vow only adds Penitent OR Court spell, not random |
| W7 Caspar Voll | Gaoler's Word freeze duration -1 (Slow-3, 1 turn) |
| W8 Saint of Gallowsmoke | Smoke persistence reduced -1 turn |
| W9 Brass-Crowned Whelp | First summon discount lost (no cost reduction) |
| W10 Last Confessor | Random faction added to starter deck must be from a *rival* faction (per anti-synergy grid) |
| W11 Saint That Should Not Hang | Reanimated enemies don't fight for you; they reanimate as normal enemies |

### 5.4 A20 modifier — "The Curse Itself" — per Warlord

A20 is the prestige rung. Per-Warlord A20 modifier must feel narratively earned, not just numerically punishing. Drafting these as template; per-Warlord polish in IMV-2.

**Template structure:** "Your Warlord's identity inverts. The thing that defined you now hurts you. Beat this and you've truly mastered."

| Warlord | A20 modifier (template) |
|---|---|
| W1 Vyrrun | Mortify HEALS you instead of damaging, but your units gain -1 ATK that wave (inverted purpose) |
| W2 Sieren | Reanimations rise as ENEMY units, fighting against you (inverted purpose) |
| W3 Eddra | Familiars belong to the enemy at wave-start (your Brood is patron-claimed) |
| W4 Veska | Forge-Heat triggers on ENEMY play, drawing them an extra card |
| W5 Mhar | Wear-the-Dead inverted: each summon DEATH costs +1 mana on next summon |
| W6 Vow-Broken Magus | Twinned Vow rolls hostile-spell: the free spell triggers AGAINST you |
| W7 Caspar Voll | Gaoler's Word freezes a *friendly* unit, not a boss |
| W8 Saint of Gallowsmoke | Smoke now damages friendly units inside, not enemies |
| W9 Brass-Crowned Whelp | Bleed applies to friendly summon, not enemy |
| W10 Last Confessor | Last Words triggers MULTIPLE enemy-spell echoes per cast |
| W11 Saint That Should Not Hang | Speak the Name silences YOUR side instead of the field — only the curse acts |

### 5.5 Ascension rewards

- A1 unlock requires Ancestor T1 (B9 node), per §2.3.
- A5 / A11 / A16 / A20 unlock requires Ancestor T2 / T3 / T4 respectively (gated).
- Each milestone completion grants:
  - **A5:** 25 Bones + warlord-specific Ascension banner accent
  - **A11:** 50 Bones + 10 Souls + Ascension nameplate
  - **A16:** 100 Bones + 25 Souls + animated Ascension nameplate
  - **A20:** **The Curse Itself title** (visible to other players in leaderboards) + 50 Souls + warlord-specific A20 mastery banner

### 5.6 Anti-P2W audit (Ascension)

| Concern | Test | Pass |
|---|---|---|
| Pay-to-unlock Ascension | Locked behind Ancestor Tree which uses Bones (earned only) | ✅ |
| Souls grant gameplay power | Souls only spent on Ancestor T4/T5 *cosmetic-only* prestige nodes + are an earn-only currency | ✅ |
| Difficulty-pay-bypass | No SKU lets you skip Ascension difficulty; can only "skip" by playing better | ✅ |

---

## 6. Relic catalogue (UPG-5)

30 relics across 5 factions + 5 neutral. Loosely follows the existing P39/P40, M39/M40, C39/C40, L39/L40, W39/W40 RELIC card_type files (2 per faction = 10). This catalogue adds the missing 20 relics needed for IMV-2 minimum variety.

### 6.1 Acquisition paths

- **In-run combat reward (40% of relics):** can drop from any non-boss combat (~5% chance per combat).
- **Boss kill (15%):** guaranteed chapter-tier relic drop per `bosses_v0.md`.
- **SHOP relic slot (20%):** purchasable for 120-200 Gold (per `shop_economy_v0.md` §3).
- **EVENT reward (15%):** specific events grant specific relics per `events_v0.md` (7 named relics).
- **Ancestor B5 unlock (10%):** run-start gain 1 random Common relic.

### 6.2 Relic rarity & ownership rules

- **Common (12 relics):** can stack multiples; passive effect doubles.
- **Uncommon (10):** unique per run; if offered when owned, replaced with refund 50% of cost.
- **Rare (6):** unique per account per run (can't appear back-to-back in adjacent runs).
- **Legendary (2):** unique per account; only Ancestor-Tree-tied unlocks.

### 6.3 Relic catalogue table

| ID | Name | Rarity | Source | Effect | Faction (or NEUTRAL) |
|---|---|---|---|---|---|
| R-PEN-1 | Warm Bone-Splinter | Common | Event E01 | Next combat, on first damage taken, deal 3 to a random enemy | Iron Penitents |
| R-PEN-2 | Crowned Nail | Common | Combat drop | Self-damage cards heal you for 1 | Iron Penitents |
| R-PEN-3 | Flayed Prayer-Scroll | Uncommon | Shop | BLEED stacks deal +1 damage on first tick | Iron Penitents |
| R-PEN-4 | Brass Suffering-Mask | Rare | Boss B1 | At Hanging Hour, your strongest unit gains +2 ATK and BLEED-2 self | Iron Penitents |
| R-PEN-5 (existing P39) | (per `cards_iron_penitents_v1.md`) | (per existing) | (per existing) | (per existing) | Iron Penitents |
| R-PEN-6 (existing P40) | (per `cards_iron_penitents_v1.md`) | (per existing) | (per existing) | (per existing) | Iron Penitents |
| R-MOU-1 | Raven-Quill Stub | Common | Combat drop | On unit death, peek at next card in deck | Ash-Mourners |
| R-MOU-2 | Inkwell of Last Hours | Common | Combat drop | Spells cost 1 less every 3rd cast | Ash-Mourners |
| R-MOU-3 | Court-Signet Wax-Bead | Uncommon | Event E02 (Witness Token) | Reveals enemy stats in next 2 combats | Ash-Mourners |
| R-MOU-4 | Pall-Bearer's Sash | Rare | Boss B1 | First PERSIST per combat returns at full ATK (no -1) | Ash-Mourners |
| R-MOU-5 (M39) | (existing) | — | — | (existing) | Ash-Mourners |
| R-MOU-6 (M40) | (existing) | — | — | (existing) | Ash-Mourners |
| R-COV-1 | Singular Demon-Coin | Common | Event E03 | Start each combat with +1 free mana for turn 1 only | Coven |
| R-COV-2 | Bog-Wife's Promise | Common | Combat drop | When a friendly token dies, gain 1 Gold | Coven |
| R-COV-3 | Briar-Tangled Doll | Uncommon | Shop | POISON stacks last +1 turn | Coven |
| R-COV-4 | The Hoofprint Locket | Rare | Event E08 | Once per run, on death, summon a 3/3 Demon-Familiar on your back tile | Coven |
| R-COV-5 (C39) | (existing) | — | — | (existing) | Coven |
| R-COV-6 (C40) | (existing) | — | — | (existing) | Coven |
| R-LEG-1 | Crowned-Anvil Standard Fragment | Common | Combat drop | RALLY adjacency bonus +1 ATK (was: only if same row) | The Last Legion |
| R-LEG-2 | Soot-Stained Officer Sash | Common | Combat drop | ECHO triggers grant +1 Gold | The Last Legion |
| R-LEG-3 | Frozen Hammer-Strike | Uncommon | Event E04 | Once per combat, freeze (SLOW-3) one enemy for 1 turn | The Last Legion |
| R-LEG-4 | Drill-Sergeant's Whistle | Rare | Event E09 | Host units get +1 ATK if 3+ in same row | The Last Legion |
| R-LEG-5 (L39) | (existing) | — | — | (existing) | The Last Legion |
| R-LEG-6 (L40) | (existing) | — | — | (existing) | The Last Legion |
| R-SKW-1 | Antler-Crown Splinter | Common | Combat drop | Summons enter with +1 HP | Skinward Pact |
| R-SKW-2 | Pelt-Bound Charm | Common | Combat drop | TRANSFORMATION cards cost -1 every 4th cast | Skinward Pact |
| R-SKW-3 | Cinder-Bark Talisman | Uncommon | Shop | After a unit dies, draw a card (max once per turn) | Skinward Pact |
| R-SKW-4 | God-Tree Seed-Husk | Rare | Boss B1 | At Hanging Hour, summon a 4/4 Beast on a random friendly tile | Skinward Pact |
| R-SKW-5 (W39) | (existing) | — | — | (existing) | Skinward Pact |
| R-SKW-6 (W40) | (existing) | — | — | (existing) | Skinward Pact |
| R-NEU-1 | Reliquary Debt | Common (CURSE) | Event E01 choice C | -1 max HP for chapter | Neutral / curse |
| R-NEU-2 | Court Debt | Common (CURSE) | Event E02 choice B | Each combat, must spend at least 1 mana on non-attack action | Neutral / curse |
| R-NEU-3 | Mire-Bound | Common (CURSE) | Event E03 choice B | Next 2 events become Coven-flavoured | Neutral / curse |
| R-NEU-4 | The Tree's Mark | Rare | Event E10 choice B | At end of run, +1 Soul if W11 is unlocked | Neutral |
| R-NEU-5 | Ash-Vow Bell | Legendary | Ancestor B5 + E5 path | At start of each combat, gain 1 Gold per friendly unit on board | Neutral |
| R-NEU-6 | The Black Writ | Legendary | Complete A11 with all 5 free Warlords | Spells cost -1 (floor 1) for the first turn each combat | Neutral |

**Total: 30 relics** (12 Common, 10 Uncommon, 6 Rare, 2 Legendary).

### 6.4 Anti-stack rules

- **Common relics stack**: drawing the same Common relic twice doubles its effect (additive, not multiplicative). E.g. 2× Crowned Nail = self-damage heals 2.
- **Uncommon and rarer DON'T stack**: drawing dupes triggers an auto-refund (Gold equal to 50% of shop price, or +20 Bones if from non-shop source).
- **Cursed relics (R-NEU-1..3) can be stacked** but trigger a "you have 3 curses — accept another?" guard prompt on the 4th curse.

### 6.5 Anti-P2W audit (relics)

| Concern | Test | Pass |
|---|---|---|
| Pay for relics | No relic is gem-purchasable; only Gold in shop + earned via play | ✅ |
| Power-creep relics | Effects are sideways or +X (capped); no relic instant-wins a run | ✅ |
| Legendary relic gating | Both Legendaries require Ancestor Tree depth or A11 completion (earned-only) | ✅ |

---

## 7. Engine handoff

### 7.1 Resource classes

`game/src/data/relic.gd`:
```
class_name Relic extends Resource

@export var id: StringName
@export var display_name: String
@export var flavour_text: String
@export var rarity: GFEnums.Rarity
@export var faction: GFEnums.Faction  # or NEUTRAL
@export var trigger: StringName  # "on_combat_start" / "on_damage_taken" / "on_persist" / "on_hanging_hour" / "passive" / etc.
@export var stack_rule: StringName  # "stack" / "unique" / "stack_with_guard"
@export var effect_payload: Dictionary  # data-driven effect (parsed by RelicResolver)
@export var acquisition_source: StringName  # "combat" / "boss" / "shop" / "event" / "ancestor"
```

`game/src/data/ancestor_tree_node.gd`:
```
class_name AncestorTreeNode extends Resource

@export var id: StringName
@export var branch: StringName  # "BLOOD" / "BONE" / "BREATH" / "BIND" / "ROOT"
@export var depth: int          # 0 = ROOT, 1..9 = branch depth
@export var fork_branch: StringName = &""  # for FORK A / FORK B nodes
@export var cost_bones: int
@export var prereq_ids: Array[StringName]
@export var effect_id: StringName  # dispatched by AncestorEffectResolver
@export var display_name: String
@export var description: String
```

`game/src/data/warlord_ascension.gd`:
```
class_name WarlordAscension extends Resource

@export var warlord_id: StringName
@export var rung: int  # 1..20
@export var generic_modifier_id: StringName  # references AscensionModifierResolver lookup
@export var per_warlord_modifier_id: StringName = &""  # set on A5/A11/A16/A20 only
@export var unlock_prereq_rung: int  # rung - 1
@export var unlock_prereq_ancestor_tier: int  # 0/1/2/3/4
@export var completion_rewards: Array[SkuContentEntry]
```

`game/src/data/card_mastery.gd`:
```
class_name CardMastery extends Resource

# Tier configuration (data-driven)
const TIER_THRESHOLDS = [0, 1, 10, 50, 200, 1000]
const TIER_NAMES = ["", "Used", "Known", "Mastered", "Cherished", "Eternal"]

static func tier_for_count(play_count: int) -> int:
    for i in range(TIER_THRESHOLDS.size() - 1, -1, -1):
        if play_count >= TIER_THRESHOLDS[i]:
            return i
    return 0
```

### 7.2 GameState extensions

```
# meta-progression
var ancestor_unlocked_nodes: Array[StringName] = []  # persistent
var ancestor_respec_count_this_season: int = 0
var warlord_ascension_unlocks: Dictionary  # { "vyrrun": 5, "sieren": 11, ... }
var card_mastery_progress: Dictionary  # { card_id: play_count }
var owned_relics_this_run: Array[Relic] = []

# signals
signal ancestor_node_unlocked(node_id: StringName)
signal warlord_ascension_unlocked(warlord_id: StringName, rung: int)
signal warlord_ascension_completed(warlord_id: StringName, rung: int)
signal card_mastery_tier_advanced(card_id: StringName, new_tier: int)
signal relic_acquired(relic: Relic, source: StringName)
signal relic_triggered(relic: Relic, payload: Dictionary)

# API
func unlock_ancestor_node(node_id: StringName) -> bool  # cost-checked
func respec_ancestor_tree() -> int  # returns refunded Bones
func unlock_warlord_ascension(warlord_id: StringName, rung: int) -> bool
func record_card_play(card_id: StringName) -> void  # called by combat
func add_relic_to_run(relic: Relic, source: StringName) -> bool
```

### 7.3 Save format additions

```
# game_save.json
"ancestor_tree": {
  "unlocked_nodes": ["B1", "B2", "C1", "D1"],
  "respec_count_this_season": 0
},
"warlord_ascension": {
  "vyrrun": 5, "sieren": 11, "eddra": 1
},
"card_mastery": {
  "P3_crowned_martyr": 47,
  "M5_last_censer_bearer": 122,
  ...
}
```

### 7.4 Run-state additions

`RunState` (new RefCounted held by GameState while a run is active):
```
class_name RunState extends RefCounted

var warlord_id: StringName
var ascension_rung: int = 0  # 0 = no ascension, A1-A20
var ascension_modifiers_active: Array[StringName]  # populated from rung table
var owned_relics: Array[Relic]
var card_instances_in_deck: Array[CardInstance]  # tracks per-instance upgrade_count
```

---

## 8. MVP coverage

| Surface | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| In-run upgrade (REST node) | — (no REST in linear ch1) | ✅ | ✅ | ✅ | ✅ |
| Card mastery counter | tracked, no UI | ✅ counter visible | reward unlocks | ✅ | ✅ |
| Ancestor Tree | — | tree exists, 12 nodes only (BLOOD + BONE branches) | full 36 nodes | full | full |
| Warlord Ascension | — | A1-A5 only | A1-A11 | A1-A16 | A1-A20 |
| Relic catalogue (30 relics) | 5 (one per faction stub) | 12 (Commons) | 20 | 30 | 30 |

---

## 9. Open questions for Paul

1. **Ascension ladder length.** Recommend A1..A20 (StS pattern, well-understood). Alternative: shorter A1..A11 (Hades-ish, less prestige headroom). Lock now.
2. **Per-Warlord A20 modifier polish.** Templates are drafted in §5.4; each Warlord needs final-pass polish. Lock per-Warlord author pass timeline (recommend IMV-2 polish, not gating).
3. **Respec cost (2,500 vs 5,000 Bones).** Recommend 2,500 to make respec feel possible. Higher = more commitment, less player flex.
4. **Card mastery Tier 5 "Eternal" at 1,000 plays.** That's ~50 runs of using one card heavily. Too high for most cards (players don't play one card 1,000 times). Recommend lowering to 500 to make it achievable for staple cards. Confirm.
5. **A20 "Curse Itself" title visibility.** Recommend leaderboard-visible only (Ascension veterans flexing). Alternative: visible in matchmaking (PvE only, no MM needed, so leaderboard).

---

## 10. Cross-references

- `rests_v0.md` — in-run upgrade primary spec; this doc extends with §4 dispatch.
- `shop_economy_v0.md` — Bones currency role, shop service slot, relic shop slot pricing.
- `warlord_tiers_full.md` — per-Warlord T4 mastery + A11 modifier source.
- `bosses_v0.md` — chapter-1 relic drop pool (R-PEN-4, R-MOU-4, R-COV-4, R-SKW-4 referenced).
- `events_v0.md` — 7 event-named relics (R-PEN-1, R-MOU-3, R-COV-1, R-COV-4, R-LEG-3, R-LEG-4, R-NEU-4) live here.
- `cards_*_v1.md` — existing P39/P40/M39/M40/C39/C40/L39/L40/W39/W40 RELIC card_type entries.
- `monetisation_map.md` §"Anti-pay-to-win guardrails" — invariant root.

— Controller, 2026-05-21
