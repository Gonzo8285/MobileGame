# Bosses v0 — Chapters 4 through 8

_Authored 2026-05-22 by Controller (round 2). Extends `bosses_v0.md` (Ch1 Black-Bell Choir) and `bosses_chapters_2_3_v0.md` (Ch2 Iron Communion / Ch3 Saint That Hangs). Per the 8-round linear lock in `GDD_v1.md` §4, each chapter is its own 8-round run with its own boss. Chapters 4-8 are the post-IMV-2 metagame content. Difficulty climbs progressively._

**Status:** v0 spec — pending Paul sign-off on Open Qs.

---

## 1. Chapter-to-boss map (full)

| Ch | Boss name | Faction tag | Biome | Tier | Spec |
|---|---|---|---|---|---|
| 1 | The Black-Bell Choir | Ash-Mourners | Gallows Hill (entry) | T1 (intro) | `bosses_v0.md` |
| 2 | The Iron Communion | Last Legion | The Foundry (extended) | T2 | `bosses_chapters_2_3_v0.md` §2 |
| 3 | The Saint That Hangs | Curse-bound | Gallows Hill (summit) | T3 (act 1 finale) | `bosses_chapters_2_3_v0.md` §3 |
| 4 | The Bog-Mother's Ledger | Coven of the Black Mire | Bog of Bargains (deep) | T4 (act 2 opener) | THIS DOC §2 |
| 5 | The Cinderwood Warden | Skinward Pact | Cinderwood (felled tree) | T5 | THIS DOC §3 |
| 6 | The Penitents' Hammer | Iron Penitents | Cathedral Ruins (crypt) | T6 | THIS DOC §4 |
| 7 | The Twelve-Eyed Court | Ash-Mourners (corrupted) | Court of the Withering Hand | T7 | THIS DOC §5 |
| 8 | The Curse Itself | All / none | The Tree at the End | T8 (campaign finale) | THIS DOC §6 |

**Difficulty escalation axes** (extends `bosses_chapters_2_3_v0.md` §1 table):

| Axis | Ch4 | Ch5 | Ch6 | Ch7 | Ch8 |
|---|---|---|---|---|---|
| Boss base HP | 130 (R8 ~160) | 150 (R8 ~185) | 175 (R8 ~215) | 220 (R8 ~270) | 320 (R8 ~390) |
| Hanging Hour beats | 3, 6, 9 | 3, 6, 9 + secondary trigger | 2, 5, 8 + curse-tick | 2, 4, 6, 9 | continuous — every 3 turns |
| Signature mechanics | 3 interlocked | 3 + faction inversion | 4 interlocked | 4 + lane-corruption | 5 interlocked, all 5 prior boss signatures merge |
| Reward tier | guaranteed Ch4 relic + 1 of 3 Epic | guaranteed Ch5 relic + 1 of 3 Epic/Legendary | guaranteed Ch6 + 1 of 3 Legendary + Souls | guaranteed Ch7 relic-pool draft (pick 2 of 5) + Souls × 2 | full campaign reward — title, cosmetic, all chapter relics if not yet owned, Souls × 5, W11 unlock check |
| Retry cost | 15 gems | 18 gems | 22 gems | 30 gems | 50 gems (capped) |

---

## 2. Chapter 4 boss — The Bog-Mother's Ledger

> _"Every name on this page is a name that owed me. Every name on this page is mine now."_

**Name:** The Bog-Mother's Ledger
**Biome:** Bog of Bargains (deep — the inner mire, demon-coin-paved)
**Faction:** Coven of the Black Mire
**Signature mechanics:** **Debt Accrual** + **The Mother's Three Shadows** + **Demon-Coin Tithe**

**Lore framing:** Marsh-Mother Eddra (W3) is the player's playable Coven Warlord. The Bog-Mother's Ledger is what Eddra *should have* become if she'd stopped trading lives. The Ledger is a book — physically a book, suspended in bog-mud at the back of the lane, with three shadows surrounding it. Each shadow is a half-Eddra.

### 2.1 Stat block

- **HP:** 130 (R8 ~160)
- **ATK:** 0 (the Ledger itself doesn't attack — shadows do)
- **Range:** N/A
- **Faction tag:** coven
- **Initial position:** rear tile of centre lane, untargetable for first 3 turns ("the book is closed")
- **Shadows:** 3 distinct enemy entities, one per lane, spawn turn 1

### 2.2 Signature ability 1: "Debt Accrual" (passive)

Every time the player **plays a Coven card** OR **kills a token enemy** (any token — Bog-Spawn, Wolf-Token, Withered Servant per `tokens_v0.md`), the Ledger gains +1 `debt_count`. At each Hanging Hour beat (turns 3, 6, 9):

- All shadows gain +`debt_count` ATK that turn only
- Debt is consumed (resets to 0) at the end of the HH turn

**Counter-play:** burst-token Coven decks tank their own boss fight. The boss is faction-themed inversion of the player's worst habit. Slow, careful Coven (or non-Coven) decks have an easier time.

### 2.3 Signature ability 2: "The Mother's Three Shadows"

Three shadow enemies spawn turn 1, one per lane:

| Shadow | HP | ATK | Range | Keyword |
|---|---|---|---|---|
| Shadow of the First Bargain | 30 | 4 | MELEE | PERSIST + POISON-on-hit |
| Shadow of the Seventh Body | 35 | 3 | SHORT | RESURRECT (once, full HP) |
| Shadow of the Thirteenth Name | 25 | 5 | LONG | CLEAVE + FEAR-aura (-1 ATK to adjacent friendlies) |

The Ledger is **untargetable while at least 1 shadow lives.** Player must kill all 3 shadows first. Shadows reanimate at half-HP at turn 9 (Hanging Hour tertiary) UNLESS the Ledger's debt_count = 0 at that turn (rewards burning debt off).

### 2.4 Signature ability 3: "Demon-Coin Tithe"

At turn 5, the Ledger drops a "demon coin" token (3-cost spell) into the player's hand, **replacing one random card.** The coin's text: _"Cast: deal 5 damage to the Ledger. After cast, lose 1 mana cap for the rest of combat."_

Player choice: take the damage hit, or skip the coin. Skipping leaves it in hand permanently (clog). Casting it deals damage but cripples the mana ramp.

### 2.5 Wave-spawn pattern

| Turn | Event |
|---|---|
| 1 | Shadows spawn × 3 (one per lane). Ledger appears as untargetable rear-centre |
| 2 | +1 Bog-Born token rear-flank lanes |
| 3 | **Hanging Hour 1** — shadows gain +debt_count ATK; debt resets |
| 4 | +2 Bog-Spawn tokens, one rear-flank each |
| 5 | **Demon-Coin Tithe** — 3-cost card replaces one in hand |
| 6 | **Hanging Hour 2** — shadows gain +debt_count ATK |
| 7 | If any shadow dead, it stays dead unless debt_count > 5 (auto-reanim trigger) |
| 8 | +3 Marsh-Mother tokens flood lanes (similar to Eddra's signature spell) |
| 9 | **Hanging Hour 3** — shadows reanimate at half-HP UNLESS debt_count = 0 |
| 10+ | Ledger is now targetable if all shadows dead. Direct damage phase. |

### 2.6 Faction-flavour bind (one line each)

- **Iron Penitents:** Self-damage decks accelerate debt_count (each Penance proc fires shadows up). Worst matchup if not paced.
- **Coven:** Mirror-match. Eddra's own Bog-Spawn token-pump is what feeds the boss. **Hardest matchup by faction theme.**
- **Ash-Mourners:** PERSIST cycles add 1 token-equivalent death each. Debt accumulates fast. Tight control plays survive; combo-engine decks fold.
- **Last Legion:** No tokens by default. Debt accrues only on Coven cards (which Legion decks don't run). **Easiest matchup by faction theme.**
- **Skinward Pact:** Transform chains kill tokens to make bigger tokens. Each death adds debt. Mixed.

### 2.7 Reward on victory

- Guaranteed **Relic of Chapter 4** drop (one of 5 — see §7.1)
- Reward screen: 1 of 3 cards, **Epic weight ×3** in pool
- **+15 gems**
- **+1 Soul** if at Ascension ≥ 5
- Retry cost: 15 gems

---

## 3. Chapter 5 boss — The Cinderwood Warden

> _"He stopped being a man somewhere between the third tree and the fourth. The tree finished what he started."_

**Name:** The Cinderwood Warden
**Biome:** Cinderwood (felled tree — the corpse of the god-tree)
**Faction:** Skinward Pact (corrupted Tree-Walker, mirror to Mhar)
**Signature mechanics:** **Transformation Cascade** + **Pelt-Theft** + **Faction Inversion (HH-bound)**

**Lore framing:** The Warden is what the Skinward Pact's transformation magic produces when used on the wrong tree. He was once a Tree-Walker like Mhar. He wore one too many pelts. Now the pelts wear him.

### 3.1 Stat block

- **HP:** 150 (R8 ~185)
- **ATK:** 6
- **Range:** MELEE (the Warden is hand-to-hand)
- **Faction tag:** skinward_pact
- **Initial position:** centre lane, front tile — IN THE PLAYER'S FACE
- **Special:** transforms on each Hanging Hour into a stronger form. 3 forms total.

### 3.2 Signature ability 1: "Transformation Cascade"

At each Hanging Hour beat (turns 3, 6), the Warden sheds his current form and grows a new one. Each transform is irreversible.

| Phase | Triggered | HP carry-over | ATK | Range | New keyword |
|---|---|---|---|---|---|
| Phase 1 (turn 1-3) | start | 150 | 6 | MELEE | none |
| Phase 2 (turn 4-6) | HH-1 (turn 3) | 65% of remaining HP* | 8 | SHORT | CLEAVE |
| Phase 3 (turn 7+) | HH-2 (turn 6) | 50% of remaining HP* | 10 | LONG | CLEAVE + PIERCE |

*HP carry-over rounds up. So a player who deals 80 damage in phase 1 leaves the Warden at 70 HP, and phase 2 starts at 65% = 46 HP. Aggressive play between transforms is rewarded.

**Phase tells:** the lane background distorts (forest → ash → bone) when transforms approach.

### 3.3 Signature ability 2: "Pelt-Theft"

When a friendly unit dies in melee range of the Warden, the Warden gains its primary keyword for the rest of the combat. (Stacks — can hold multiple stolen keywords.)

- Player kills off their own units near the Warden? Watch the Warden grow.
- The Warden ends Hanging Hour beats often holding 2-3 stolen keywords.

**Counter-play:** keep dying units away from the Warden's tile. Force ranged trades.

### 3.4 Signature ability 3: "Faction Inversion (HH-bound)"

At Hanging Hour beats (turns 3, 6, 9), the Warden gains the **inverse keyword** of the player's primary faction this run:

- vs Iron Penitents (BLEED/PENANCE) → Warden gains SHIELD-2 (cleanses BLEED ticks)
- vs Ash-Mourners (PERSIST/SMOKE) → Warden gains FEAR-aura
- vs Coven (POISON/TOKENS) → Warden gains POISON-immunity + anti-token CLEAVE
- vs Last Legion (RALLY/ECHO) → Warden gains SLOW-immunity + ECHO of his own ATK (double-strike)
- vs Skinward Pact (RESURRECT) → Warden gains RESURRECT once at 25% HP — yes, even in mirror-match

### 3.5 Wave-spawn pattern

| Turn | Event |
|---|---|
| 1 | Warden phase-1 spawns centre-front, no minions |
| 2 | +2 Cinder-Wolf minions one per flank lane |
| 3 | **HH-1** — Warden → phase 2. Inversion applied. |
| 4 | +1 Stitched-Hide rear-centre (token, PERSIST) |
| 5 | +1 Wolf-Token flank lanes |
| 6 | **HH-2** — Warden → phase 3. Second inversion applied. |
| 7 | +2 Cinder-Wolf wave, focused on player's strongest lane |
| 8 | +1 Bone-Crowned Wolf (mini-elite) flank |
| 9 | **HH-3** — Warden gains +5 ATK this turn only. No further phase change. |
| 10+ | Attrition. Warden focuses lowest-HP friendly. |

### 3.6 Faction-flavour bind

- **Iron Penitents:** Aggro fast-clear before HH-1 is the strategy. Phase-1 Warden is killable. If you don't push, phase-2 onwards wrecks you.
- **Coven:** Tokens get CLEAVED. Hard matchup. Pivot to non-token Coven.
- **Ash-Mourners:** PERSIST gets stolen via Pelt-Theft. PERSIST-into-Warden = he gains it. Awful.
- **Last Legion:** ECHO inversion makes the Warden double-strike. Brutal. TAUNT to soak it.
- **Skinward Pact:** Mirror-match. Player's transformations vs Warden's transformations. RESURRECT inversion creates 2-life Warden. **Hardest matchup by mechanic.**

### 3.7 Reward on victory

- Guaranteed **Relic of Chapter 5** drop (one of 5 — see §7.2)
- Reward screen: 1 of 3 cards, **Epic weight ×3 + Legendary weight ×2**
- **+18 gems**
- **+2 Souls** if at Ascension ≥ 5
- Retry cost: 18 gems

---

## 4. Chapter 6 boss — The Penitents' Hammer

> _"They ran out of sinners. They started swinging at each other. He's the last one swinging."_

**Name:** The Penitents' Hammer (Vilrek the Last Striker)
**Biome:** Cathedral Ruins (crypt — the basilica's foundation, where Penitents pile their dead)
**Faction:** Iron Penitents
**Signature mechanics:** **Hammer-Swing Phases** + **Crypt-Wave Reinforcement** + **Penance Tithe** + **Curse-Tick (PASS-BREAKING)**

**Lore framing:** Vilrek is what happens when the Iron Penitents run out of external sinners to flagellate. He's been swinging the cathedral's foundational hammer for thirty years, longer than most Penitents live. He stopped feeling the swing in year seven.

### 4.1 Stat block

- **HP:** 175 (R8 ~215)
- **ATK:** 7
- **Range:** SHORT (2 tiles — the hammer arc)
- **Faction tag:** iron_penitents
- **Initial position:** front tile of centre lane
- **Special:** **8 mana cap is not enough.** Vilrek's mana ramp is +1/+1 per turn, capping at 11, NOT 8. Player's cap is unchanged. Asymmetric.

### 4.2 Signature ability 1: "Hammer-Swing Phases"

Vilrek's hammer needs 2 turns to swing. Phase tells visible at all times.

| Turn pattern | Phase | What happens |
|---|---|---|
| Turn 1, 3, 5, 7, 9 (odd) | RAISE | Vilrek raises hammer. ATK = 7, no special. |
| Turn 2, 4, 6, 8, 10 (even) | STRIKE | Vilrek hammers down. ATK = 14 (double), CLEAVE this turn only, hits **3 tiles** in centre lane |

Player learns to time defences for even turns.

### 4.3 Signature ability 2: "Crypt-Wave Reinforcement"

Whenever Vilrek kills a friendly unit, **2 Pall-Bearer minions spawn from the crypt-tile (rear-centre)** to march forward. Each Pall-Bearer is a 12-HP / 3-ATK with PERSIST.

Asymmetric: every kill snowballs into 2 enemies. Sustainable trades only.

### 4.4 Signature ability 3: "Penance Tithe"

At each Hanging Hour beat (turns 2, 5, 8), Vilrek deals **2 damage to himself** AND gives himself **+2 ATK permanent.** Self-flagellation. By turn 9, Vilrek is at 7 + 6 = 13 ATK baseline (× hammer-swing double = 26 dmg on STRIKE turns).

**Counter-play:** the +ATK is permanent but Vilrek's HP is bleeding. Reactive Smoke / Slow plays at HH let him chip himself.

### 4.5 Signature ability 4: "Curse-Tick (PASS-BREAKING)"

Per `gameplay_keywords_resolution_v0.md` §10 anti-soft-lock curse-tick, **after turn 12 the player base-HP takes +1 damage per turn from "the curse closing in."** Vilrek amplifies this: from turn 8 onwards (not 12), the curse-tick fires. Forces fast-win. No turtle deck survives.

### 4.6 Wave-spawn pattern

| Turn | Event |
|---|---|
| 1 | Vilrek spawns front-centre, hammer raised |
| 2 | **HH-1.** Vilrek tithes (-2 HP, +2 ATK). Hammer strikes (ATK 14 cleave). |
| 3 | +2 Cathedral-Brother flank lanes |
| 4 | Hammer raised — STRIKE next turn |
| 5 | **HH-2.** Tithe + strike. ATK 16. |
| 6 | +2 Cathedral-Brother + 1 Nail-Choir-Flagellant (token, BLEED-on-hit) |
| 7 | Hammer raised |
| 8 | **HH-3 + Curse-Tick starts.** Tithe + strike. ATK 18 cleave + player loses 1 base-HP/turn forward. |
| 9 | Hammer raised |
| 10 | Hammer strikes. ATK 20+ cleave. |
| 11+ | Attrition. Curse-tick keeps grinding. Defeat by curse-tick is canonical here. |

### 4.7 Faction-flavour bind

- **Iron Penitents:** Mirror-match. Player's BLEED stacks crit Vilrek's tithe-damage cycle. **Easiest matchup if played hyper-aggro.**
- **Ash-Mourners:** PERSIST + crypt-wave reinforcement = both sides flood the lane. Tactical trades critical. Hard.
- **Coven:** Tokens get CLEAVED by hammer strikes. Coven needs to feed bigger bodies into centre lane. Mediocre.
- **Last Legion:** TAUNT pulls hammer-strikes onto throwaway bodies. Strong play.
- **Skinward Pact:** Transform off the front tile when STRIKE turn approaches. Mobile dance. Mid-tier.

### 4.8 Reward on victory

- Guaranteed **Relic of Chapter 6** drop (one of 5 — see §7.3)
- Reward screen: 1 of 3 cards, **Legendary weight ×2**
- **+22 gems**
- **+2 Souls** if at Ascension ≥ 5
- Retry cost: 22 gems

---

## 5. Chapter 7 boss — The Twelve-Eyed Court

> _"There were nine of us once. We've grown additional eyes."_

**Name:** The Twelve-Eyed Court
**Biome:** Court of the Withering Hand (the Ash-Mourners' last sealed crypt-court, never on the public map)
**Faction:** Ash-Mourners (corrupted — the court has become the curse it served)
**Signature mechanics:** **Twelve Court Members** + **Witness Tax** + **Sealed Writ** + **Lane Corruption**

**Lore framing:** The Court was nine Ash-Mourner court mages who tried to bind the curse by signing it into law. The curse signed back. The court now has twelve members, three of which never existed before the binding. The court doesn't speak — it watches.

### 5.1 Stat block

- **HP:** 220 spread across 12 court members (varies — see §5.2)
- **ATK:** N/A (the court doesn't directly attack — it taxes)
- **Range:** N/A
- **Faction tag:** ash_mourners
- **Initial position:** all 12 in a 3×4 grid behind all 3 lanes (back row). 4 per lane.

### 5.2 Signature ability 1: "Twelve Court Members"

| Slot | Member | HP | Ability |
|---|---|---|---|
| 1-3 | Black Justiciars | 25 each | Each turn, mark 1 friendly unit. Marked unit takes +1 damage from all sources. |
| 4-6 | Pale Witnesses | 20 each | Each kill from any lane adds +1 to `witness_tax` (see §5.3) |
| 7-9 | Ink Ravens | 15 each | RESURRECT once at full HP if killed before turn 7 |
| 10 | The Twelfth Eye | 30 | Untargetable until all other 11 are dead |
| 11 | The Hand That Doesn't Sign | 40 | At turn 5, plays a free Cursed-treatment card from the player's deck back at the player (turns it against them) |
| 12 | The Witness That Has No Name | 5 | Each turn, costs 1 gem from the player's wallet (passive drain) |

Player kills 11 → court collapses → Twelfth Eye becomes targetable. **Twelfth Eye is the actual boss HP bar.** Killing it = victory.

### 5.3 Signature ability 2: "Witness Tax"

`witness_tax` accumulates +1 per kill (any side). At Hanging Hour beats (turns 2, 4, 6, 9):

- Every alive court member gains +1 ATK per `witness_tax` for that turn only
- Tax does **not** reset between HHs — it grows the whole combat

By turn 9 with 30+ kills, the court members are flinging double-digit damage at HH.

### 5.4 Signature ability 3: "Sealed Writ"

At turn 5, the Hand That Doesn't Sign (slot 11) takes one **Cursed-treatment** card from the player's deck and casts it on the player. If the player has no Cursed-treatment cards, the Hand plays a generic "Curse of the Court" (a 3-cost spell that adds a curse to the player's deck — see `curses_v0.md` §"Court Curses").

**Implication:** running Cursed-treatments through chapter 7 has a real cost.

### 5.5 Signature ability 4: "Lane Corruption"

At Hanging Hour beats, one random lane is **corrupted** for the next 2 turns:

- Friendly units in that lane lose 1 ATK
- Enemy units in that lane gain 1 ATK
- New units summoned into that lane spawn at 50% HP

Corruption cycles through lanes. Forces lane-shuffle plays.

### 5.6 Wave-spawn pattern

| Turn | Event |
|---|---|
| 1 | Court spawns × 12. No minions. |
| 2 | **HH-1.** Witness tax = current kill count. Lane 1 corrupts. |
| 3 | +2 Catacomb-Cherub units fly in (range LONG) |
| 4 | **HH-2.** Lane 2 corrupts. |
| 5 | **Sealed Writ fires.** Player's Cursed-treatment card returns as enemy spell. |
| 6 | **HH-3.** Lane 3 corrupts. |
| 7 | Ink Ravens that haven't died yet can't RESURRECT after this turn |
| 8 | +3 Pall-Bearer wave |
| 9 | **HH-4.** Massive tax burst. Last HH. |
| 10+ | Attrition + Twelfth Eye targetable if 11 down. |

### 5.7 Faction-flavour bind

- **Iron Penitents:** Self-damage decks pay the +1-per-marked-source tax twice. Hard.
- **Ash-Mourners:** Mirror-match. PERSIST cycles each count as kills, accelerating witness tax. **Hardest matchup.**
- **Coven:** Token spam = many kills = massive witness tax. Painful. Pivot to no-token Coven.
- **Last Legion:** TAUNT soaks marked-debuffs. RALLY post-Sealed-Writ if player has spare mana.
- **Skinward Pact:** Few units, big bodies, few kills. **Easiest matchup by tax model.**

### 5.8 Reward on victory

- **Guaranteed pick 2 of 5 from Ch7 relic pool** (best loot drop in game so far — pre-finale)
- Reward screen: 1 of 3 cards, **Legendary weight ×3**
- **+30 gems**
- **+4 Souls** if at Ascension ≥ 5
- Retry cost: 30 gems

---

## 6. Chapter 8 boss — The Curse Itself

> _"There was never a curse. There was only the town remembering what was done to it."_

**Name:** The Curse Itself (presented in-game with no name visible — just a black silhouette of the gallows-tree)
**Biome:** The Tree at the End (the original gallows-tree, the first nail, the first rope)
**Faction:** All / none (per the lore-locked W11)
**Signature mechanics:** **Phase Cascade (3 phases, each with a prior boss signature)** + **Reverse Mana Ramp** + **Continuous Hanging Hour** + **No Retries**

**Lore framing:** This is the final boss of the campaign. The curse isn't a creature — it's the tree, the rope, and the memory of every person who died here. The player faces the curse in three forms, each remembering a prior boss. Beat all three to free Gallowfell. Beat the third to unlock W11 (per `bosses_chapters_2_3_v0.md` §3.7 W11 unlock criteria — adjusted: actually triggers here, not Ch3).

### 6.1 Stat block (total)

- **HP:** 320 across 3 phases (~107 per phase) (R8 ~390 total)
- **ATK:** varies per phase
- **Range:** varies per phase
- **Faction tag:** neutral / cursed
- **Initial position:** rear-centre, full-screen vertical silhouette

### 6.2 Phase 1 — "The Bell Remembers"

The first form is the Black-Bell Choir from Ch1 — now upscaled.

- **HP:** 107
- **ATK:** 8 (LONG range)
- **Signature:** **Toll the Bell++**: all enemies that died this combat AND every dead unit from the player's history this RUN resurrect at HH. (Run-wide death memory.)
- **HH:** turn 3

### 6.3 Phase 2 — "The Saint Speaks"

Phase 2 starts when phase 1 dies. The board does NOT clear.

- **HP:** 107
- **ATK:** 9 (3 HP bars, 1 per lane, per `bosses_chapters_2_3_v0.md` §3.1)
- **Signature:** **Speak the Name+++**: every friendly unit played from this point is queued for forced-PERSIST at end of next turn. Plus **The Drop** at turn 6 of phase 2 (game-time, not boss-time) — full board wipe with deck reshuffle.
- **HH:** turn 6

### 6.4 Phase 3 — "The Tree Stops Listening"

Phase 3 starts when phase 2 dies. The board clears (mercy beat).

- **HP:** 106
- **ATK:** 11 (LONG range, all 3 lanes simultaneously)
- **Signature:** **Continuous Hanging Hour** — every 3 turns from phase 3 start, HH fires. Plus **Reverse Mana Ramp** — the player's mana cap drops 1 per turn (8 → 7 → 6 → ...). When mana cap hits 0, the player can play nothing. Forces a hard kill window of ~6 turns.
- Additional: at phase 3 turn 3, the boss casts **The Spoken Name** (player's deck's most expensive card) back at the player as enemy damage equal to its cost × 3.

### 6.5 Wave-spawn pattern

| Turn (game-wide) | Event |
|---|---|
| 1 | Phase 1 begins. Silence. No minions yet. |
| 2 | +2 Pall-Bearer minions (Ch1 style) |
| 3 | **HH** for phase 1. Toll the Bell++ fires using run-history kill list. |
| 4 | +1 Reaper-Bell rear-centre |
| 5-8 | Phase 1 attrition. Player kills it. |
| 9 (~) | **Phase 2 begins.** Board does NOT clear. Boss-shaped overlay morphs. |
| 9+ | Speak-the-Name fires on every unit played. Forced-PERSIST. |
| ~12 | **The Drop** — full friendly wipe + deck reshuffle |
| 12-15 | Phase 2 attrition. Player kills 3 HP bars (one per lane). |
| ~15 | **Phase 3 begins.** Board clears. Continuous-HH starts. Mana cap drop starts. |
| ~17 | The Spoken Name fires |
| ~18 | HH fires again (continuous-HH) |
| ~21 | HH again. Mana cap = 5. Hard pressure. |
| ~25 | Player wins or dies — mana cap = 0 around this point. |

### 6.6 No retries

Per `internal_mvp_scope.md` precedent + `2026-05-18_gallowfell_balance.md` retry economy: **chapter 8 boss is non-retryable.** If you die, you restart the entire chapter 8 run. Final-boss gravity. Players know what they signed up for.

(Optional Open Q for Paul — see §8.)

### 6.7 Faction-flavour bind

- **Iron Penitents:** BLEED stacks survive phase transitions. Self-damage gets you killed by phase-3 continuous HH. Mixed.
- **Ash-Mourners:** PERSIST gets weaponised by Phase 2. **Hardest matchup.**
- **Coven:** Tokens are PERSIST-immune (per `keywords/persist_v0.md`) — Phase 2 is survivable. Phase 1 + 3 are punishing.
- **Last Legion:** TAUNT soaks the Spoken-Name re-cast. RALLY needs to survive The Drop (it won't).
- **Skinward Pact:** Transform-chain past The Drop. Easiest survivability.
- **Lore-locked W11:** if the player is playing W11 (which they shouldn't be the first time, since W11 unlocks ON this boss — but on Ascension replays they might) — the Reanimation curse works for them, turning the Toll-the-Bell+ into free units. **Easiest matchup by lore design.**

### 6.8 Reward on victory

- **Full campaign-clear reward:** title "Gallowfell Survivor" + all-chapter relic pool catch-up (any unowned Ch1-8 relic = granted) + cosmetic Warlord-cape variant + **+5 Souls** + **+50 gems**
- **W11 unlock trigger** (if all 10 other Warlords have a campaign-clear logged)
- Achievement "The Tree Stops Listening" — global leaderboard entry
- Cinematic outro: the gallows-tree falls. Cuts to credits.

### 6.9 Defeat penalty

- Run ends. Restart entire chapter 8 from round 1.
- Player keeps Ascension progress + Soul gains earned in rounds 1-7.

---

## 7. Chapter-tier relic pools (Ch4-Ch8)

### 7.1 Chapter 4 pool — 5 relics

| ID | Name | Effect |
|---|---|---|
| R-CH4-1 | The Bog Ledger | At end of run, +1 Bone per friendly token-card death this run (Bones meta-currency boost) |
| R-CH4-2 | Demon-Coin Wreath | Once per run: cast a free 3-cost spell from your deck without paying mana |
| R-CH4-3 | The Thirteenth Shadow | Your tokens gain +1 HP for the rest of the run |
| R-CH4-4 | The Black-Mire Pact | When you Sacrifice a friendly unit, the next unit you summon enters with +1 ATK |
| R-CH4-5 | Eddra's Forfeit | Lose 5 max HP for the run. Gain +25% Bones earn rate |

### 7.2 Chapter 5 pool — 5 relics

| ID | Name | Effect |
|---|---|---|
| R-CH5-1 | The God-Tree Bark | Once per combat: prevent the death of a friendly unit (revive at 1 HP) |
| R-CH5-2 | Pelt-Stitched Cloak | All friendly RESURRECT units return with +1 ATK |
| R-CH5-3 | The Antler-Crown | First summon each combat costs 1 less mana |
| R-CH5-4 | Cinder-Wolf Tooth | When a friendly summon dies, deal 2 damage to a random enemy |
| R-CH5-5 | The Final Pelt | At Hanging Hour, your weakest friendly transforms into a copy of your strongest friendly |

### 7.3 Chapter 6 pool — 5 relics

| ID | Name | Effect |
|---|---|---|
| R-CH6-1 | The Cathedral Hammer | Your CLEAVE attacks deal +1 damage |
| R-CH6-2 | Crypt-Bound Vow | When 3+ friendly units die in a single turn, draw 2 cards |
| R-CH6-3 | The Penitents' Chain | All friendly Iron Penitent cards cost 1 less if your HP ≤ 50% |
| R-CH6-4 | Iron Nail of Vilrek | Once per run, deal 25 damage to a single enemy (boss-shred) |
| R-CH6-5 | The Hammer's Backswing | At every Hanging Hour, all friendly units gain SHIELD-1 |

### 7.4 Chapter 7 pool — 5 relics (player picks 2 of 5)

| ID | Name | Effect |
|---|---|---|
| R-CH7-1 | The Twelfth Eye | See your next 3 reward picks before each combat |
| R-CH7-2 | Sealed Court Writ | First curse drawn each combat is removed from deck for that combat |
| R-CH7-3 | Black Justiciar's Mark | Marked enemies (by any source) take +2 damage |
| R-CH7-4 | Pale Witness Ring | At each Hanging Hour, gain 1 gem |
| R-CH7-5 | The Unsigned Hand | Cursed-treatment cards in your deck gain +1 to their primary stat for the run (only takes effect if you OWN the card — anti-P2W: doesn't gift power based on cosmetic state) |

**Note on R-CH7-5:** explicit anti-P2W rewording vs the rejected R-CH2-5 ("Wax-Sealed Sigil"). This version requires owning the Cursed-treatment card itself, not just having Cursed equipped. Cosmetic state is not the gate. Card ownership is.

### 7.5 Chapter 8 pool — 5 relics (auto-granted on victory, all 5 if missing)

| ID | Name | Effect |
|---|---|---|
| R-CH8-1 | The First Nail | Run starts: gain 3 gems |
| R-CH8-2 | The First Rope | All friendly units gain +1 max HP for the rest of the run |
| R-CH8-3 | The Bell That Doesn't Toll | Hanging Hour fires 1 turn later (turn 6 standard, turn 5 boss) |
| R-CH8-4 | The Saint's Last Breath | Once per run: at run-start, draw an extra card on turn 1 of every combat for 3 combats |
| R-CH8-5 | The Tree at the End | At chapter-clear, +2 Souls (stacks with Ascension bonus) |

---

## 8. Open questions for Paul

1. **Chapter 4 boss faction-mirror.** Coven mirror against player Coven is hardest matchup. Is that the intended fantasy? Recommend yes — "your own bog comes for you" reads as on-tone.
2. **Chapter 5 inversion table.** Each faction gets a different Warden form. Confirm matchup difficulty is acceptable (Skinward mirror as "hardest by mechanic" intended?).
3. **Chapter 6 asymmetric mana cap (Vilrek at 11 vs player at 8).** This is the first time the player's economy is asymmetrically capped. Confirm OK.
4. **Chapter 7 lane corruption.** Cycling-corruption is a new lane state. Engine work needed: `lane.corruption: enum {NONE, P_DEBUFF, E_BUFF, BOTH}` + duration counter. Confirm worth implementing or simplify to single-lane locked corruption.
5. **Chapter 8 phase cascade.** 3 phases on a single boss is novel for the engine. Confirm the design is worth the engine cost OR simplify to single-phase with 320 HP.
6. **Chapter 8 retry policy.** Recommend NO retries on final boss (forces respect for the moment). Alternative: 1 retry at 100 gems. Confirm.
7. **W11 unlock trigger.** _RESOLVED 2026-05-22 (CANON_PATCHES_APPLIED): Ch8 boss clear is canonical_, with a "10 of 10 Warlord campaign clears" achievement visible all the way through. Ch3 reference in `bosses_chapters_2_3_v0.md` §3.7 patched to "progress milestone only".
8. **Curse-tick start turn.** Per `gameplay_keywords_resolution_v0.md` §10, default = turn 12. Ch6 Vilrek pulls it to turn 8 for spec reasons. Confirm OK or move back to 12.

---

## 9. Engine handoff

Extends `bosses_v0.md` §"Engine wiring sketch — M10.E1" and `bosses_chapters_2_3_v0.md` §4. Additional fields needed:

```
@export var multi_phase: bool = false               # Ch5, Ch8
@export var phase_definitions: Array[PhaseDef]      # array of phase resources for multi-phase bosses
@export var asymmetric_mana_cap: int = -1            # Ch6 — -1 = use player's cap
@export var continuous_hh_period: int = -1           # Ch8 phase 3 — -1 = no continuous HH
@export var reverse_mana_ramp: bool = false          # Ch8 phase 3
@export var no_retry: bool = false                   # Ch8
@export var run_wide_death_memory: bool = false      # Ch8 phase 1
@export var faction_inversion_table: Dictionary = {} # Ch5 — { player_faction: keyword_to_grant_boss }
@export var lane_corruption_cycle: bool = false      # Ch7
@export var multi_member_court: Array[CourtMember] = []  # Ch7 — 12 sub-bosses with their own HP
```

PhaseDef resource:
```
@export var hp_carry_over_pct: float = 1.0  # 0.0..1.0
@export var atk_override: int = -1
@export var range_override: int = -1
@export var keywords_added: Array[StringName] = []
@export var signature_ability_id: StringName
@export var passive_ability_id: StringName = &""
```

Total new engine work: ~3-4 days of GDScript heartbeat work (per Phase 3 build cadence). Most can be IMV-2 work + early FCP work.

---

## 10. MVP coverage

| Boss | IMV-1 | IMV-2 | FCP | Soft launch | v1.0 |
|---|---|---|---|---|---|
| Ch1 Black-Bell Choir | spec only | engine wired | ✅ | ✅ | ✅ |
| Ch2 Iron Communion | — | spec only | engine wired | ✅ | ✅ |
| Ch3 Saint That Hangs | — | — | spec only | engine wired | ✅ |
| Ch4 Bog-Mother's Ledger | — | — | spec only | engine wired | ✅ |
| Ch5 Cinderwood Warden | — | — | — | spec only | engine wired |
| Ch6 Penitents' Hammer | — | — | — | spec only | engine wired |
| Ch7 Twelve-Eyed Court | — | — | — | — | spec only |
| Ch8 The Curse Itself | — | — | — | — | engine wired |
| Ch4-8 relic pools | — | — | Ch4 only | Ch4-5 | full |

Soft launch ships Ch1-4 playable. Ch5-8 are v1.0 patch content.

---

## 11. Cross-references

- `bosses_v0.md` — Ch1 boss.
- `bosses_chapters_2_3_v0.md` — Ch2 + Ch3 bosses.
- `GDD_v1.md` §4 — locked 8-round structure.
- `gameplay_keywords_resolution_v0.md` §10 — curse-tick anti-soft-lock.
- `faction_bible.md` v1 — faction lore + keywords.
- `warlords_v1.md` §11 — W11 unlock criterion.
- `upgrade_trees_v0.md` §6 — chapter-tier relic catalogue.
- `tokens_v0.md` — token rules used in Ch4 debt-accrual mechanic.
- `curses_v0.md` — Court Curses referenced in Ch7 Sealed Writ.
- `2026-05-18_gallowfell_balance.md` — chapter scaling formula.

— Controller, 2026-05-22
