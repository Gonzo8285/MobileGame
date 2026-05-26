# Ash-Mourners — Full Card Pool v1.0 (C3)

_Drafted 2026-05-01 in-session. Full 40-card Ash-Mourners pool across the 3 archetypes (Smoke-Fear / Resurrect-Spam / Trap-Control). Designed against `archetypes_v0.md` v0.1 (B1/B2/B3) and the v0.1 anti-synergy grid. Existing 11 cards from `cards_v0.md` v1.0 (M1–M11) absorbed; M5 Last Censer-Bearer gets the S2 statline reshape (3c U → 4c R, 4/4/S/CD-2 + Dread aura). Net new: 29 cards (M12–M40). Faction = canonical Track A — **Ash-Mourners** (`GFEnums.Faction.WITHERED_COURT` in code; the file naming and player-facing text use Ash-Mourners per L1 lock 2026-04-30; the enum constant is left unchanged this pass to avoid an engine-wide rename — flagged for L2 cleanup heartbeat)._

## Distribution (target: 40 cards / 60–25–10–5; actual: 41 post-Phase-2.13 N1)

| Slot | Target | Authored | Per archetype split |
|---|---|---|---|
| Units | 24 (60%) | 25 | 9 Smoke / **10** Resurrect / 8 Trap-Control + 4 cross-archetype splash _(post-N1: +M41 Wraith-Caller of the Dirge)_ |
| Spells | 10 (25%) | 10 | 4 Smoke / 3 Resurrect / 3 Trap-Control |
| Traps | 4 (10%) | 4 | 0 Smoke / 0 Resurrect / 4 Trap-Control |
| Specials (relics) | 2 (5%) | 2 | 1 Smoke / 1 Resurrect (both faction-locked) |
| **Total** | **40** | **41** | _(+1 net from Phase 2.13 N1; accept deviation per audit, re-balance at C7-v0.2)_ |

## Rarity skew

| Rarity | Count | % | Notes |
|---|---|---|---|
| Common (C) | 24 | 59% | Cheap fodder, smoke-spreaders, wraith-bait |
| Uncommon (U) | 13 | 32% | Archetype workhorses incl. both new identities (Necrologist, Funeral Bellringer) + M41 Wraith-Caller of the Dirge (Phase 2.13 N1) |
| Rare (R) | 4 | 10% | M5 Last Censer-Bearer (Smoke-Fear identity, post-S2 promotion), M6 The Pyre-Priest (Resurrect-Spam payoff), M8 Cinder Tide (Smoke-Fear payoff), M11 Funeral Bell (Trap-Control payoff). New identity cards held at U so the rarity budget stays clean — 4 R per faction. |

## Format reminder

- **Cost** = mana to play.
- **Units:** HP / ATK / Range (M/S/L) / CD (turns).
- **Rarity:** C / U / R.
- **Keywords used:** Fear, Dread, Smoke, Slow, Resurrect, Summon, Root, Shield, Sacrifice. (No net-new keywords.)
- **Smoke** is a zone status (existing keyword). **Dread** stacks with Smoke per `cards_v0.md` keyword block.

---

## Smoke-Fear archetype (12 cards + 1 splash)

Identity is **M5 Last Censer-Bearer (post-S2 reshape: 4c R, 4 HP / 2 ATK / Range-S / CD-2, Dread-1 aura to all enemies in 2 tiles each turn)**. Engine: lay smoke + stack Dread + slowly grind enemy ATK to nothing. Payoff: **M8 Cinder Tide (existing 4c R)** — board-wide -2 ATK + Fear-1. Splashes into Last Legion Banner-Buff (Shield-1 stacks under Smoke pressure). Hard counter: Iron Penitents Cleave-Melee (clears chaff before Smoke layers stack).

### Units (8)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| M1 | Mourning Acolyte | 1 | 2 | 1 | S | 1 | C | Applies Dread-1 to first enemy hit each turn. _(v0 — unchanged.)_ |
| M2 | Censer-Bearer | 2 | 3 | 1 | S | 2 | C | Aura: enemies within 1 tile have ATK -1. _(v0 — unchanged. Splashes into Resurrect-Spam.)_ |
| M3 | Ash-Speaker | 2 | 1 | 2 | L | 2 | C | On enemy kill: that tile becomes Smoke for 2 turns (enemies entering get Fear-1). _(v0 — unchanged.)_ |
| M5 | **Last Censer-Bearer** | 4 | 4 | 2 | S | 2 | **R** | **Identity (post-S2 promotion).** Each turn: applies Dread-1 to all enemies within 2 tiles. _(was: 3c U, 3/1/S/CD-2 with Dread-1 within 2 tiles each turn. Reshape: 4c R, 4/2/S/CD-2 — same Dread aura, beefier statline.)_ |
| M14 | Cinder-Hooded Mourner | 1 | 1 | 1 | M | 1 | C | On attack: kill-tile becomes Smoke for 1 turn. |
| M15 | Veiled Reverent | 2 | 2 | 1 | M | 1 | C | While in Smoke: +1 ATK and Fear-immune. |
| M16 | Smoke-Walker | 3 | 3 | 2 | M | 1 | C | While standing on Smoke: +1 ATK and Stealth (cannot be targeted by Range-L). |
| M17 | Pyre-Tender | 3 | 3 | 1 | S | 2 | C | Start of turn: extend duration of every Smoke tile in lane by 1 turn. |
| M18 | Funeral Choir | 4 | 4 | 2 | S | 2 | C | Aura: enemies adjacent to this unit gain Dread-1 each turn. |

### Spells (4)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| M7 | Smother | 1 | C | Apply Dread-2 and Root for 1 turn to a single enemy. _(v0 — unchanged. Splashes into Trap-Control.)_ |
| M8 | Cinder Tide | 4 | R | All enemies in lane: -2 ATK and Fear-1 for 2 turns. _(v0 — payoff for Smoke-Fear.)_ |
| M30 | Ash-Veil | 1 | C | A friendly Mourner gains Fear-aura (enemies attacking it next turn take Fear-1). |
| M31 | Funeral Rites | 2 | C | Choose a tile: Smoke for 3 turns. |
| M32 | Cinder Bloom | 2 | C | Deal 1 dmg to every enemy currently in Smoke. Refresh Smoke duration on all Smoke tiles by 1 turn. |
| M36 | The Long Dirge | 5 | U | Board-wide: -1 ATK and Fear-1 for 1 turn. Draw 1 card per friendly Mourner alive (cap 4). |

(M30, M31, M32 = C; M7 = C v0; M8 = R v0; M36 = U new — 4 spells in archetype, but counts toward 4 Smoke-side allotment from the 10-spell pool.)

### Special (1)

| # | Name | Slot | Rarity | Effect |
|---|---|---|---|---|
| M39 | The Black Bell | Relic | U | At the start of each combat, summon a 2/2 Ash Wraith with Fear in your lane. (Once per combat.) |

---

## Resurrect-Spam archetype (12 cards + 1 splash)

Identity is **M12 Necrologist of the Catacombs (4c U)** — when a friendly Mourner dies, draw 1 + summon a 1/1 Ash Wraith on nearest empty tile (cap 1/turn). Payoff: **M6 The Pyre-Priest (existing 5c R)** — Resurrects fallen Mourners as 1/1 Ash Wraiths with Fear. Engine: spam cheap Mourners → cycle deaths into Wraith tokens + cards. Splashes into Iron Penitents Sacrifice-Penance (death triggers cross-feed but compete for the same corpse — trigger-order rule applies). Hard counter: Skinward Pact Transformation (transformed bodies bypass small-unit recursion).

### Units (9)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| M4 | Funeral Drummer | 3 | 4 | 0 | — | — | U | Aura: adjacent friendly units gain Shield-1 each turn. _(v0 — unchanged. Splashes into all archetypes.)_ |
| M6 | The Pyre-Priest | 5 | 4 | 3 | S | 1 | R | When a friendly Mourner dies, **Resurrect** it as a 1/1 Ash Wraith with Fear. _(v0 — unchanged. Resurrect-Spam payoff.)_ |
| M12 | **Necrologist of the Catacombs** | 4 | 4 | 2 | S | 1 | **U** | **Identity.** When a friendly Mourner dies, draw 1 and summon a 1/1 Ash Wraith on the nearest empty tile. Once per turn. |
| M19 | Catacomb Cherub | 1 | 1 | 1 | M | 1 | C | On death: 50% chance to return as a 1/1 Ash Wraith with Fear. |
| M20 | Bone-Shroud Acolyte | 2 | 2 | 1 | M | 1 | C | When this unit dies, the next Mourner you summon this combat costs 1 less. |
| M21 | Wraith-Caller | 3 | 2 | 2 | S | 1 | U | On play: summon a 1/1 Ash Wraith with Fear on nearest empty tile. |
| M22 | Hollow Mortician | 3 | 3 | 2 | M | 1 | C | When any friendly Mourner dies in lane, this unit gains +1 ATK this turn. |
| M23 | Cradle of the Dead | 4 | 5 | 1 | M | 1 | U | On death: summon a 2/2 Ash Wraith with Fear. |
| M24 | Choir of the Long Dead | 5 | 4 | 2 | S | 1 | U | Aura: friendly Ash Wraiths gain +1 HP. On play: existing Ash Wraiths get +1 HP immediately. |
| M41 | **Wraith-Caller of the Dirge** | 3 | 3 | 2 | M | 1 | **U** | When a friendly Mourner dies, the next Mourner you play this turn costs 1 less. Cap once per turn. _(Phase 2.13 N1, added 2026-05-26. B2 Resurrect-Spam spine fix per M7 audit. Naming-distinct from M21 "Wraith-Caller" via the "of the Dirge" suffix — M21 is on-play SUMMON, M41 is on-friendly-death cost-reduction. Trigger surface broader than M20 Bone-Shroud Acolyte (M20 = own death only; M41 = any friendly Mourner death) justifying the 3c vs 2c cost gap. Engine reads effect text and dispatches via the existing `friendly_unit_died` signal path used by M22 Hollow Mortician — no new keyword required.)_ |

### Spells (3)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| M33 | Choir of Catacombs | 3 | U | Summon two 1/1 Ash Wraiths with Fear on empty tiles in lane. |
| M34 | The Drowning Hush | 3 | C | Silence all enemy auras in lane until end of turn. |
| M35 | Knell of Mourning | 4 | C | This turn, every friendly Mourner death summons a 2/2 Ash Wraith with Fear instead of nothing. |

### Special (1)

| # | Name | Slot | Rarity | Effect |
|---|---|---|---|---|
| M40 | Cinder-Wreath Reliquary | Relic | C | When a friendly Mourner dies, your next spell this turn costs 1 less (caps at 3 stacks per combat). |

---

## Trap-Control archetype (8 cards + payoff)

Identity is **M13 Funeral Bellringer (4c U)** — when a trap triggers in your lane, summon a 1/1 Ash Wraith on nearest empty tile (cap 3/combat). Payoff: **M11 Funeral Bell (existing 3c R trap)** repositioned as the highlight pull — Root 2 + adjacent Mourner ATK buff. Engine: chokepoint via traps + auras + Root; Wraith generation feeds back into Resurrect-Spam splash. Hard counter: Coven Bog-Spawn Swarm (cheap chaff burns through traps before payoff fires). Splashes into Last Legion Tempo-Echo (Echo replays trap-triggered effects — design hook v1.1).

### Units (5)

| # | Name | Cost | HP | ATK | Rng | CD | Rarity | Effect |
|---|---|---|---|---|---|---|---|---|
| M13 | **Funeral Bellringer** | 4 | 3 | 2 | S | 1 | **U** | **Identity.** When a trap triggers in your lane, summon a 1/1 Ash Wraith on nearest empty tile. Cap 3 Wraiths per combat. |
| M25 | Trap-Reader Acolyte | 2 | 2 | 1 | M | 1 | C | When a friendly trap triggers, this unit gains +1 ATK this turn. |
| M26 | Sentinel of Pews | 3 | 3 | 2 | S | 1 | C | When a friendly trap triggers, draw 1 card. Once per turn. |
| M27 | Bell-Tower Watcher | 3 | 3 | 1 | S | 2 | U | Aura: friendly Mourners adjacent to a friendly trap tile gain Shield-1 each turn. |
| M28 | Catacomb Warden | 4 | 4 | 2 | S | 2 | U | Aura: friendly traps gain +1 turn duration on their effects. |
| M29 | Black-Bell Sister | 4 | 3 | 2 | S | 1 | C | On play: a friendly trap re-arms after its first trigger this combat. |

### Spells (3)

| # | Name | Cost | Rarity | Effect |
|---|---|---|---|---|
| M37 | Mourning Reach | 1 | C | Give a friendly Mourner Range-S boost (or +1 tile if already S/L) for 1 turn. |
| (none additional) | — | — | — | _Trap-Control's spell allocation is light by design — the archetype is unit + trap heavy._ |

### Traps (4)

| # | Name | Cost | Rarity | Trigger / Effect |
|---|---|---|---|---|
| M9 | Smoke Veil | 1 | C | First enemy on tile: Fear-1; its ATK halved next turn. _(v0 — unchanged.)_ |
| M10 | Ash-Shroud | 2 | U | Triggered: all enemies on the row gain Dread-2. _(v0 — unchanged.)_ |
| M11 | **Funeral Bell** | 3 | **R** | First enemy entering: Root 2 turns. Adjacent friendly Mourners gain +1 ATK next turn. _(v0 — unchanged. Trap-Control payoff.)_ |
| M38 | Veil of Black Crepe | 2 | C | First enemy entering: Fear-2 + Slow-1 for 2 turns. |

---

## Pool totals (sanity check)

| Slice | Target | Actual |
|---|---|---|
| Total cards | ~40 | **41** _(+1 from Phase 2.13 N1)_ |
| Common (C) | ~24 | **24** (M1, M2, M3, M7, M9, M14, M15, M16, M17, M18, M19, M20, M22, M25, M26, M29, M30, M31, M32, M34, M35, M37, M38, M40) ✓ |
| Uncommon (U) | ~12 | **13** (M4, M10, M12, M13, M21, M23, M24, M27, M28, M33, M36, M39, **M41**) _(+1 from Phase 2.13 N1)_ |
| Rare (R) | ~4 | **4** (M5 post-promotion, M6, M8, M11) ✓ |
| Units | ~24 (60%) | **25** (M1–M6 + M12–M29 + M41 — 6 v0 + 19 new) _(+1 from Phase 2.13 N1)_ |
| Spells | ~10 (25%) | **10** (M7, M8, M30–M37 — 2 v0 + 8 new) ✓ |
| Traps | ~4 (10%) | **4** (M9, M10, M11 + M38 — 3 v0 + 1 new) ✓ |
| Specials | ~2 (5%) | **2** (M39, M40 — both new) ✓ |

## Per-archetype card density (target ~10–12 each)

- **B1 Smoke-Fear:** M1, M2, M3, M5, M7, M8, M14, M15, M16, M17, M18, M30, M31, M32, M36, M39 = **16 primary** (heavy because Smoke-Fear has the most v0 cards). Still healthy — wide card variety reads as the "control" faction's identity.
- **B2 Resurrect-Spam:** M4, M6, M12, M19, M20, M21, M22, M23, M24, M33, M34, M35, M40, **M41** = **14 primary** _(post-Phase-2.13 N1: M41 Wraith-Caller of the Dirge added as B2 spine fix per M7 audit)_.
- **B3 Trap-Control:** M9, M10, M11, M13, M25, M26, M27, M28, M29, M37, M38 = **11 primary**.

(Splash cards count toward both archetypes; total unique cards still 40.)

## Cost curve (full pool)

| Cost | Count | Cards |
|---|---|---|
| 0 | 0 | — |
| 1 | 7 | M1, M7, M9, M14, M19, M30, M37 |
| 2 | 9 | M2, M3, M10, M15, M20, M25, M31, M32, M38 |
| 3 | 9 | M16, M17, M21, M22, M26, M27, M33, M34, **M41** _(+1 from Phase 2.13 N1)_ |
| 4 | 8 | M5, M8, M12, M13, M18, M23, M28, M29, M35 _(9 — slight overweight, accept)_ |
| 5 | 3 | M6, M24, M36 |
| relic | 2 | M39, M40 (cost 0, off-deck) |

Curve is mid-heavy at 2–4 (matches Ash-Mourners' grindy control identity — they want to live to mid-game).

## Anti-synergy + splash recap (B1/B2/B3 hard counters per `archetypes_v0.md` v0.1)

- **B1 ↔ Iron Penitents Cleave-Melee:** Cleave clears smoke-bait fodder before Smoke layers stack. Punish: M5 + M8 deny ATK fast enough to stall Cleave's wind-up turns.
- **B2 ↔ Skinward Pact Transformation:** Transformed bigger bodies bypass the small-unit recursion economy. Punish: M22 Hollow Mortician's death-trigger ATK swing + M6 chain Resurrect produce so many Wraiths that even one transformed boss eats too many actions to reach the back line.
- **B3 ↔ Coven Bog-Spawn Swarm:** Cheap chaff burns through traps before payoff fires. Punish: M28 Catacomb Warden's +1-duration aura + M29 trap re-arm push trap value past chaff floor.

## Splash cards (≥2 cards splash into rival faction archetypes — Phase 2.6 brief)

- **M4 Funeral Drummer** → splashes into Iron Penitents Sacrifice-Penance (Shield-1 aura buys Penance triggers an extra turn).
- **M7 Smother** → splashes into Trap-Control (Dread-2 + Root replicates Funeral Bell's Root effect for 1c).
- **M22 Hollow Mortician** → splashes into Iron Penitents Bleed-Stack (death-trigger ATK swing fires whenever a Penitent bleeds out).
- **M27 Bell-Tower Watcher** → splashes into Last Legion Banner-Buff (Shield-1 aura stacks with Legion's Shield-1).
- **M36 The Long Dirge** → splashes into Coven Poison-Stack (board-wide -1 ATK + Fear stalls poison-tick clocks long enough).

Five splash hooks → meets C7's "≥2 splash hooks per faction" target.

## Cross-archetype splash cards (in-faction overlap)

| # | Name | Splashes | Why |
|---|---|---|---|
| M2 | Censer-Bearer | Smoke + Resurrect | ATK-1 aura helps Wraith chaff trade up |
| M4 | Funeral Drummer | All three | Shield-1 aura is universally valuable |
| M7 | Smother | Smoke + Trap-Control | 1c Root + Dread mimics trap behavior |
| M14 | Cinder-Hooded Mourner | Smoke + Resurrect | Smoke-on-attack feeds B2 chaff cycles |
| M22 | Hollow Mortician | Resurrect + Trap-Control | Death-trigger ATK swing fires on trapped enemy kills |

## Naming + flavour notes
- All names hew to grimdark funereal register (per `lore_gallowfell.md` Ash-Mourners motif: catacombs, censers, funerary cloth, bell-tower).
- "Catacomb", "Funeral", "Bell-Tower", "Pyre", "Cinder" → vocabulary cluster. Consistent with v0 flavour.
- Specials (M39, M40) named with reliquary register — sacred objects, not weapons. Distinguishes them from in-deck cards.

## Open questions / flags for Paul

1. **M5 statline reshape** — promoted to 4c R, 4/2/S/CD-2 (was 3c U, 3/1/S/CD-2). Same Dread aura. Statline change carried into `M5.tres` this heartbeat. Comfortable with the bump? If you want the ATK to stay at 1 (pure debuff body), flag and I'll re-tune.
2. **New identities at U not R** — Necrologist (M12) and Funeral Bellringer (M13) at 4c U not R. Keeps Ash-Mourners' R count at exactly 4 (matching faction target). If you want them at R for "highlight pull" weight, demote one of M5/M6/M8/M11 to U for symmetry.
3. **Trap-Control spell allocation** — only 1 spell (M37 Mourning Reach) tagged primary B3. The archetype is intentionally unit + trap heavy. Want me to author 1–2 more B3 spells to fill the slots? (Could re-tag M34 Drowning Hush as B3 instead of B2.)
4. **Specials slot model** — same open question as Iron Penitents (Q1 in `cards_iron_penitents_v1.md`). Relics M39/M40 authored as `is_draftable=false` + `unlock_tag=&"relic_ash_mourners"` pending your call on the full relic-slot system.

## Change log

- **v1.0 (2026-05-01)** — initial 40-card pool authored from C1 archetype briefs + `cards_v0.md` v1.0 (M1–M11). M5 statline reshape S2 lock applied (3c U → 4c R, 4/2/S/CD-2). 29 net-new cards (M12–M40). 60/25/10/5 distribution hit exactly. 4 Rares (3 v0 retained + M5 promoted). 2 specials introduced (relics flagged for system-wide call).
- **Same heartbeat:** `.tres` files for M12–M40 generated under `game/data/cards/ash_mourners/`. M5.tres updated in place with promoted statline + R rarity.
- **v1.1 (2026-05-26)** — Phase 2.13 N1 add: M41 Wraith-Caller of the Dirge (3c U Resurrect-Spam spine) per M7 cohesion audit. Net +1 card (pool now 41). Distribution, Rarity, Pool-totals, Per-archetype-density, and Cost-curve tables updated in place. No existing card altered. `M41.tres` authored under `game/data/cards/ash_mourners/`. **3 open Qs for Paul** (none block N2):
    1. **Cap-per-turn vs cap-per-combat?** Spec uses once-per-turn (mirrors M12). Once-per-combat would make N1's "spine accelerator" job thinner — recommend keep once-per-turn.
    2. **Stack with M20 Bone-Shroud Acolyte?** If M20 dies on a turn N41 has already fired, do both discounts apply to the same next Mourner (cost -2)? Spec leans yes — they're different trigger sources, both with their own caps. Watch for free-Mourner cascades in playtest.
    3. **"Next Mourner you play this turn" — hand-only or any source?** If a friendly Mourner death spawns a summoned Ash Wraith (e.g. via M12 Necrologist), does that summon count as "the next Mourner played" and consume N41's discount? Spec leans no — summons are not "played." Aligns with M20's "next Mourner you summon this combat" which explicitly says "summon," distinguishing it.

_Next backlog hop: C4 — Coven of the Black Mire full pool (~40 cards). C6 Mother Quag stays as a single dual-archetype card per Paul's 2026-05-01 lock; new cards Witch of the Bound Coin, Brood-Mother of the Mire, Ferryman of the Drowned Coin, Drowning of the Demon-Coin authored fresh._

- **v1.1a (2026-05-26 evening)** — Cleanup: removed M42 "Wraith-Caller of the Dirge" duplicate. A prior Controller pass had authored M42.tres + a spec block (formerly at the "M7 cohesion-audit additions" section below) before the N1 / M41 backlog assignment was visible to that seat. Same card name, same role, slightly different stats (M42 was 3 HP / 1 ATK / Range-S / CD-2; M41 — canonical — is 3 HP / 2 ATK / MELEE / CD-1). M41 is the authoritative N1 deliverable. M42.tres deleted from `game/data/cards/ash_mourners/`; M42 spec block replaced with a supersession note pointing at M41. Pool composition unaffected (M41 was the only Phase-2.13 add for this faction). Caught by the "verify backlog ticks against actual files" rule — phantom-tick / phantom-untick check on 2026-05-26 evening hand-back.

---

## Persist candidates (M1, heartbeat 2026-05-10)

PERSIST keyword authored this heartbeat (`keywords/persist_v0.md`, `GFEnums.Keyword.PERSIST` added). 5 existing Ash-Mourner cards flagged as good Persist-tagging candidates — design suggestion only, **no `.tres` edits this pass**. Tagging happens at M2 (sacrifice-and-return loop hardening) once Paul confirms direction.

| # | Card | Why it fits | Risk note |
|---|---|---|---|
| M5 | **Last Censer-Bearer** (4c R, Smoke-Fear identity) | Persist on the Smoke-Fear payoff means the Dread aura keeps ticking. Reinforces "the curse keeps the dead from staying dead." | Most powerful candidate — watch for Smoke-stack ceiling abuse. |
| M12 | **Necrologist of the Catacombs** (4c U, Resurrect-Spam identity) | Persist + own death-trigger = self-fueling. On its own death it triggers another draw + Wraith for itself. Engine-pillar fit. | Could over-snowball; cap by once-per-combat lock already in spec. |
| M20 | **Bone-Shroud Acolyte** (2c C) | Already a death-trigger card (cost-reduction on death). Persist gives you a second body to chain the discount. Clean common-tier teaching card. | None — low-power, intentionally sticky. |
| M22 | **Hollow Mortician** (3c C) | Gains +1 ATK on Mourner death; Persist means it can witness its own death and come back stronger. Thematic + mechanical fit. | -1 ATK on Persist offsets the on-death buff cleanly. Self-balancing. |
| M24 | **Choir of the Long Dead** (5c U) | Aura-giver; Persist makes the Wraith-HP buff sticky across one wipe. Resurrect-Spam payoff worth defending. | Aura is lost on death even with Persist (per spec); the body returns stripped, then re-applies the aura on next-turn tick. Confirm tick-order in B2.7. |

Anti-synergy reminder: if a Persist-tagged Ash-Mourner is also Resurrect-eligible (M6 Pyre-Priest field), Resurrect wins (replaces the death). Spec'd in `keywords/persist_v0.md` Interactions block.

---

## M2 update (2026-05-10) — Persist tags applied

Five M1-flagged cards have been keyword-tagged with PERSIST in their `.tres` files. No statline changes; just the keyword. Anti-P2W invariant preserved (Persist is gameplay, never cosmetic — see `keywords/persist_v0.md`).

| Card | Keywords (after M2) | Why this card got Persist |
|---|---|---|
| M5 Last Censer-Bearer (4c R Smoke-Fear identity) | Dread + Persist | Persist on the Smoke-Fear payoff means the Dread aura keeps ticking through one death. Reinforces the Gallowfell through-line. |
| M12 Necrologist of the Catacombs (4c U Resurrect-Spam identity) | Resurrect + Summon + Persist | Self-fueling: dies → triggers her own draw + Wraith summon (per her own ability), then Persists back at -1 ATK to keep the engine running. |
| M20 Bone-Shroud Acolyte (2c C) | Persist | Already a death-trigger card (cost-reduction on death). Persist gives a second body to chain the discount. Clean common-tier teaching card. |
| M22 Hollow Mortician (3c C) | Persist | Gains +1 ATK on Mourner death; Persist means it can witness its own death and come back with the buff stacked — though the buff resets, the on-death trigger still fires. |
| M24 Choir of the Long Dead (5c U) | Persist | Aura-giver; Persist makes the Wraith-HP buff sticky across one wipe. Aura is lost on death even with Persist (per spec); the body returns stripped, then re-applies the aura on next-turn tick. |

**Combo cross-references opened by M2 + M1:**
- M5/M12/M22/M24 + Iron Penitents P41 Last Vows → sacrifice your Persist-tagged Mourner the turn it Persists back, get Bleed-2 on enemies. Lossy tempo conversion that works as a panic finisher.
- Any Persist-tagged Mourner + Coven C41 Bog-Bargain Recall → return to hand, replay, Persist marker reset, infinite-ish loop bounded by mana cost.
- All five + Coven C42 Black Mire Pact → each Persist death pops a 0/1 Bog-Spawn (3 charges). Mourner + Coven combo deck becomes a real shape.

**Open Q for Paul (not blocking M3):** M22 Hollow Mortician's "+1 ATK this turn" on-death trigger interacts oddly with Persist — when the Mortician itself dies and Persists back, does its own death trigger fire and pre-buff its returning body? Engine answer is "no" (the buff is on the Mortician's instance, which is gone; the new instance is fresh). Design answer is unclear. Recommend keeping engine answer; revisit only if Mortician underperforms.

---

## M7 cohesion-audit additions — superseded by Phase 2.13 N1 (M41)

**SUPERSEDED 2026-05-26 evening (Controller).** This section originally added an M42 "Wraith-Caller of the Dirge" as the B2 Resurrect-Spam spine fix. That add wa