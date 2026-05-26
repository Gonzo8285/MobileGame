# Archetype Briefs v0 — Phase 2.6 / C1

_Drafted 2026-05-01 by heartbeat. Five factions × three sub-archetypes = fifteen archetype spines. Faction names use the **canonical Track A** lock (L1, 2026-04-30): Iron Penitents / Ash-Mourners / Coven of the Black Mire / The Last Legion / Skinward Pact. Lore content drawn from `faction_bible.md` v1 (which still uses Track B headers — those map 1:1 to Track A; rename pass tracked under L2). Existing card IDs reference `cards_v0.md` v1.0._

## v0.1 — Paul's resolutions applied (2026-05-01 in-session)

Four open questions resolved by Paul. Locked decisions:

1. **C6 Mother Quag, Twice-Drowned — NO SPLIT.** Stays as a single dual-archetype 5c R card serving both Poison-Stack (C1) and Bog-Spawn Swarm (C2) payoff slots. The card is rare enough as a pull moment that one card carrying both engines is fine; downstream C4 authoring keeps it as one entry.
2. **M5 Last Censer-Bearer — PROMOTED 3c U → 4c R.** Now the canonical Smoke-Fear identity (B1). Statline reshape: 4/4 / Range-S / CD-2 / Dread-1 to all enemies within 2 tiles each turn. Propagates to `cards_v0.md` → `cards_v1.md` and to the Ash-Mourners full pool authored in C3.
3. **Skinward Pact — REBALANCED to even per-faction counter weight.** Anti-synergy grid restructured so each of the 5 factions deals exactly 3 counters and receives exactly 3 counters (each archetype: in-degree 1, out-degree 1). Three edges shifted: P-Penance→C-Poison becomes M-Trap→C-Poison; P-Cleave→S-Big becomes L-Echo→S-Big; L-Rally→C-Swarm becomes S-Beast→C-Swarm. Wilds is now a normal participant in the rivalry web rather than the most-countered faction.
4. **New card names — APPROVED.** No GW/WotC vibe vetoes. C2–C6 may proceed using the names listed in this doc (Hierarch of the Open Wound, Saint of Cinders, Confessor-At-Arms, Headsman of the Long Aisle, Procession Bleeds the Lane, Necrologist of the Catacombs, Funeral Bellringer, Witch of the Bound Coin, Brood-Mother of the Mire, Ferryman of the Drowned Coin, Drowning of the Demon-Coin, plus the placeholder Legion + Wilds card names below).

Old "Open questions for Paul" section at the bottom replaced with "Resolutions applied". Original v0 grid + counter rationales for the 3 changed edges archived inline in this block (no separate diff file).



## Pool-size target (per Paul's Phase 2.6 brief)

- ~35–40 cards per faction → ~175–200 launch cards across 5 factions.
- 3 sub-archetypes per faction → ~10–12 cards per archetype.
- Curve anchor on 2–3–4 cost. Identity card is a **4-cost rare** that names the strategy. Payoff is a 5–6-cost rare that pays off the synergy. Spine = 3–4 workhorses at 2/3/4 cost. Each archetype carries one 1-cost cheap-fuel card and one 0–1-cost spell or trap as glue.
- Rarity distribution per faction (target): ~24 C / ~12 U / ~4 R. Each archetype owns roughly 1 R (identity or payoff), 2–3 U, rest C.
- Cross-archetype splash: every faction needs ≥2 cards that splash cleanly into a rival faction's archetype (deckbuild interest).

## Anti-synergy grid (v0.1 — symmetric, 3 deals + 3 receives per faction)

| Archetype | Hard counter (rival archetype) | Why |
|---|---|---|
| Penitents — Bleed-Stack | Last Legion — Banner-Buff | Shield-1 chains soak the bleed engine before stacks accrue. |
| Penitents — Sacrifice-Penance | Coven — Sacrifice-Combo | Both fight over the death trigger; only one converts corpses to value first. |
| Penitents — Cleave-Melee | Skinward Pact — Big-Monster | Single huge body sidesteps Cleave's multi-target value entirely. |
| Ash-Mourners — Smoke-Fear | Iron Penitents — Cleave-Melee | Cleave clears the screen of cheap units before Smoke layers stack. |
| Ash-Mourners — Resurrect Spam | Skinward Pact — Transformation | Bigger transformed bodies walk past the small-unit recursion economy. |
| Ash-Mourners — Trap-Control | Coven — Bog-Spawn Swarm | Cheap chaff overwhelms single-trigger traps before payoff lands. |
| Coven — Poison-Stack | **Ash-Mourners — Trap-Control** | _v0.1 swap._ Trap-Control's Root + chokepoint pacing stalls the poison tick clock — Poison-Stack pays off in DoT scaling, traps rob the tempo it needs to land enough stacks. |
| Coven — Bog-Spawn Swarm | **Skinward Pact — Beast-Summon** | _v0.1 swap._ Wolves (1/2 stats) out-trade Bog-Spawns (0/1) in token mirror — Beast-Summon overwhelms Swarm's lane density without needing Swarm's sacrifice payoffs. |
| Coven — Sacrifice-Combo | Iron Penitents — Sacrifice-Penance | Mana-steal vs ATK-steal trip over the same trigger order. |
| Last Legion — Rally-Formation | Ash-Mourners — Smoke-Fear | Fear scatters ATK targets and breaks adjacency math. |
| Last Legion — Tempo-Echo | Coven — Poison-Stack | Echo procs don't scale DoT ticks; they stall vs poison turn ticks. |
| Last Legion — Banner-Buff | Iron Penitents — Bleed-Stack | Bleed bypasses Shield-1 by ticking on off-attack turns. |
| Skinward Pact — Big-Monster | **Last Legion — Tempo-Echo** | _v0.1 swap._ Echo's mana spend stacks low-impact replays on a chassis that needs a single big payoff — splashing Echo into Big-Monster wastes Echo's per-attack value and dilutes the Big-Monster mana curve. |
| Skinward Pact — Transformation | Ash-Mourners — Resurrect Spam | Resurrected Wraiths are tokens, not Wilds — invalid Transformation targets. |
| Skinward Pact — Beast-Summon | Last Legion — Rally-Formation | Wolf-tokens are 1/2; formation Pierce/Cleave clears a row before the pack scales. |

**Structural property (v0.1):** every archetype both deals and receives exactly one cross-faction counter. Per faction: 3 dealt, 3 received. No faction is universally over- or under-countered. Two mutual rivalries preserved: P-Bleed ↔ L-Banner (the canonical Bleed/Shield rivalry) and P-Penance ↔ C-Sacrifice-Combo (the canonical sacrifice trigger conflict).

**v0 → v0.1 grid changes (3 edges):**
- Coven Poison-Stack: hard counter swapped from `Penitents Sacrifice-Penance` → `Ash-Mourners Trap-Control`. Frees Penitents to deal exactly 3 (was 5).
- Coven Bog-Spawn Swarm: hard counter swapped from `Last Legion Rally-Formation` → `Skinward Pact Beast-Summon`. Gives Skinward 3 deals (was 2).
- Skinward Big-Monster: hard counter swapped from `Penitents Cleave-Melee` → `Last Legion Tempo-Echo`. Gives Legion's Echo a counter to deal (was 0).

Mourners Trap-Control (was 0 deals), L-Echo (was 0 deals), and S-Beast (was 0 deals) now each deal 1.

---

## 1. Iron Penitents — Cathedral Ruins (aggro / sacrifice)

### A1. Bleed-Stack
- **Identity (4-cost R):** **Hierarch of the Open Wound** — when a friendly Penitent takes damage, apply Bleed-1 to a random enemy in lane. Once per turn.
- **Payoff (5–6c R):** **Procession Bleeds the Lane** — 6c spell: deal 1 dmg per Bleed stack on the row; Bleed stacks expire on resolve.
- **2-3-4 spine:** P3 Crowned Martyr (2c, Bleed-1 on attacker), P4 Hammer-Confessor (3c U, Cleave applies Bleed-1), P5 Iron Choir-Master (4c U, +1 ATK aura), P8 Hammer of Penance (2c, 4 dmg + Bleed-2).
- **Cheap fuel:** P2 Whip-Brother (1c, on-death dmg friend triggers Hierarch).
- **Hard counter:** Last Legion — Banner-Buff (Shield-1 soaks Bleed before stacks accrue).
- **Splashes into:** Coven Sacrifice-Combo (Bleed enables corpse triggers).

### A2. Sacrifice-Penance
- **Identity (4-cost R):** **Saint of Cinders** — friendly Penitent deaths grant +1 ATK to all friendly Penitents this run. Caps at +3 per combat.
- **Payoff (5–6c R):** P6 The Crucified Saint (5c R, on-play dmg all friendly Penitents — feeds Penance loop).
- **2-3-4 spine:** P9 Procession of Nails (3c U, +2 ATK, sac lowest-HP at end of turn), P5 Iron Choir-Master (4c U), P3 Crowned Martyr (2c), P7 Self-Mortification (0c, dmg friends, draw on damaged).
- **Cheap fuel:** P1 Nail-Choir Flagellant (1c, gains +1 ATK per Penitent death — the canonical Penance unit).
- **Hard counter:** Coven Sacrifice-Combo (mana-steal robs the engine of room).
- **Splashes into:** Skinward Pact Beast-Summon (Penance triggers can fire on token wolf deaths if a wolf is reflagged Penitent — design hook for a future hybrid Warlord).

### A3. Cleave-Melee
- **Identity (4-cost R):** **Confessor-At-Arms** — friendly melee Penitents gain Cleave when attacking 2+ adjacent enemies.
- **Payoff (5–6c R):** **Headsman of the Long Aisle** — 5c R unit, 5/4 melee, Cleave-3 (hits the entire row tier).
- **2-3-4 spine:** P4 Hammer-Confessor (3c U, Cleave anchor), P5 Iron Choir-Master (4c U), P8 Hammer of Penance (2c, big single-target swing for non-Cleave turns), P3 Crowned Martyr (2c, baits enemies into adjacency).
- **Cheap fuel:** P2 Whip-Brother (1c, sets up adjacency-of-three for Cleave activation).
- **Hard counter:** Skinward Pact Big-Monster (one body sidesteps the value curve).
- **Splashes into:** Last Legion Rally-Formation (Cleave + adjacency ATK reads native).

---

## 2. Ash-Mourners — Catacombs (control / debuff)

### B1. Smoke-Fear Control
- **Identity (4-cost R):** **M5 Last Censer-Bearer** — confirmed promoted 3c U → 4c R as the Smoke-Fear identity (Paul-locked 2026-05-01). Statline reshape: 4/4 / Range-S / CD-2 / Dread-1 to all enemies within 2 tiles each turn. Propagates to `cards_v0.md` → `cards_v1.md` and to the C3 Ash-Mourners full pool.
- **Payoff (5–6c R):** M8 Cinder Tide (existing 4c R; keep at 4c, treat as **archetype payoff** rather than identity — board-wide -2 ATK + Fear-1 for 2 turns).
- **2-3-4 spine:** M3 Ash-Speaker (2c, kill-tile becomes Smoke), M2 Censer-Bearer (2c, ATK-1 aura), M4 Funeral Drummer (3c U, Shield-1 aura), M1 Mourning Acolyte (1c, Dread-1 first hit each turn).
- **Cheap fuel:** M7 Smother (1c spell, Dread-2 + Root for 1 turn).
- **Hard counter:** Iron Penitents Cleave-Melee (Cleave clears the screen before Smoke layers).
- **Splashes into:** Last Legion Banner-Buff (Shield-1 aura overlap is genuine — Mourner+Legion control hybrid is a real archetype).

### B2. Resurrect Spam
- **Identity (4-cost R):** **Necrologist of the Catacombs** — when a friendly Mourner dies, draw 1, and a 1/1 Ash Wraith spawns on the nearest empty tile. Once per turn.
- **Payoff (5–6c R):** M6 The Pyre-Priest (existing 5c R, Resurrects Mourners as 1/1 Ash Wraiths with Fear).
- **2-3-4 spine:** M2 Censer-Bearer (2c, ATK-1 aura — fodder + value), M1 Mourning Acolyte (1c, cheap death trigger), M4 Funeral Drummer (3c U), M3 Ash-Speaker (2c, on-kill Smoke).
- **Cheap fuel:** M9 Smoke Veil (1c trap, set up Mourner kills).
- **Hard counter:** Skinward Pact Transformation (transformed bigger bodies bypass small-unit recursion economy).
- **Splashes into:** Iron Penitents Sacrifice-Penance (death triggers cross-feed, but compete for the same corpse — mind the trigger order rule).

### B3. Trap-Control
- **Identity (4-cost R):** **Funeral Bellringer** — when a trap triggers in your lane, summon a 1/1 Ash Wraith on the nearest empty tile. Caps at 3 Wraiths per combat.
- **Payoff (5–6c R):** M11 Funeral Bell (existing 3c R trap; reposition as the **payoff trap** of the archetype — Root 2 turns + +1 ATK adjacent Mourners).
- **2-3-4 spine:** M9 Smoke Veil (1c trap, Fear-1), M10 Ash-Shroud (2c U trap, row-wide Dread-2), M2 Censer-Bearer (2c), M4 Funeral Drummer (3c U).
- **Cheap fuel:** M7 Smother (1c spell, Dread-2 + Root) — substitutes for traps when the lane is already trap-saturated.
- **Hard counter:** Coven Bog-Spawn Swarm (cheap chaff burns through traps before payoff fires).
- **Splashes into:** Last Legion Tempo-Echo (Echo replays trap-triggered effects — design hook for v1.1).

---

## 3. Coven of the Black Mire — Bog of Bargains (swarm / poison)

### C1. Poison-Stack
- **Identity (4-cost R):** **Witch of the Bound Coin** — at end of turn, every Poisoned enemy in lane takes +1 dmg per Poison stack on it.
- **Payoff (5–6c R):** **C6 Mother Quag, Twice-Drowned** (existing 5c R) — **dual-archetype payoff**: serves both Poison-Stack and Bog-Spawn Swarm. Confirmed no split, Paul-locked 2026-05-01 — one card carries both engines in C4.
- **2-3-4 spine:** C3 Leech-Tender (2c, Poison-1 on attack), C5 Briar-Hag (4c U, Sacrifice → +2 ATK + Poison-2), C4 Toad-Caller (2c U, summons Bog-Spawn each turn — fuel + body), C8 Antler Crown (3c spell, Poison-2 to all enemies in row).
- **Cheap fuel:** C2 Bog-Witch Initiate (1c, summons a Bog-Spawn — cheap Poison vector).
- **Hard counter (v0.1):** Ash-Mourners Trap-Control (Root + chokepoint pacing stalls the poison tick clock; Poison wants tempo, traps rob it).
- **Splashes into:** Ash-Mourners Smoke-Fear (Poison + Fear is a brutal stall combo).

### C2. Bog-Spawn Swarm
- **Identity (4-cost R):** **Brood-Mother of the Mire** — on play, summon 3 Bog-Spawns on empty tiles in lane. (Promotes from existing C7 Mire-Witch concept.)
- **Payoff (5–6c R):** **C6 Mother Quag, Twice-Drowned** (dual-archetype payoff — same card as C1 Poison-Stack; here serves the recycle half: every 3rd enemy killed **this turn** returns as a friendly Bog-Spawn). _Canon: per-turn counter reset, per `faction_bible.md` v1. Patched 2026-05-22 (CANON_PATCHES_APPLIED)._
- **2-3-4 spine:** C2 Bog-Witch Initiate (1c, summons Bog-Spawn on play), C4 Toad-Caller (2c U, recurring summon engine), C5 Briar-Hag (4c U, sac fodder for tempo).
- **Cheap fuel:** C1 Bog-Spawn (0c, draftable — the chaff itself).
- **Hard counter (v0.1):** Skinward Pact Beast-Summon (Wolves out-trade Bog-Spawns 1/2 vs 0/1; Beast lane density crushes Swarm without needing sacrifice payoffs).
- **Splashes into:** Skinward Pact Beast-Summon (token-summoner archetypes overlap; both can drop wolf+bog-spawn screens).

### C3. Sacrifice-Combo
- **Identity (4-cost R):** **Ferryman of the Drowned Coin** — when you Sacrifice a Bog-Spawn, gain +1 mana this turn (cap +2 / turn).
- **Payoff (5–6c R):** **Drowning of the Demon-Coin** — 6c spell: Sacrifice up to 3 Bog-Spawns, deal 2 dmg each + Poison-3 to all enemies in a 3-tile zone.
- **2-3-4 spine:** C5 Briar-Hag (4c U, Sacrifice payoff), C3 Leech-Tender (2c, Poison feed), C4 Toad-Caller (2c U, sac-feeder engine).
- **Cheap fuel:** C2 Bog-Witch Initiate (1c, sac-fodder generator).
- **Hard counter:** Iron Penitents Sacrifice-Penance (mana-steal vs ATK-steal — Penance fires first by current trigger order).
- **Splashes into:** Skinward Pact Transformation (sacrifice-then-transform is a 2-card combo — design hook).

---

## 4. The Last Legion — The Foundry (tempo / formation)

_Faction not in MVP cards file (`cards_v0.md` v1.0 covers Penitents/Mourners/Coven only). Archetype card names below are placeholders to be authored in C5._

### D1. Rally-Formation
- **Identity (4-cost R):** **Sergeant-Smith Vikar, the Iron Watch** (existing flagship) — friendly Legion units in this row gain +1 ATK and Shield-1.
- **Payoff (5–6c R):** **Iron Standard Unfurled** — 5c spell: all Legion units in lane gain +2 ATK and Echo this turn.
- **2-3-4 spine:** **Foundry-Sworn Pikeman** (2c, +1 ATK if adjacent friendly Legion), **Iron Bayonet Drill** (3c, Pierce in formation), **Forge-Conscript** (4c, draws 1 card on row-fill of 3 Legion units).
- **Cheap fuel:** **Forge-Spark Skirmisher** (1c, +1 ATK on first attack each turn).
- **Hard counter:** Ash-Mourners Smoke-Fear (Fear scatters ATK targets, breaks formation math).
- **Splashes into:** Iron Penitents Cleave-Melee (Cleave + adjacency reads natively as Legion).

### D2. Tempo-Echo
- **Identity (4-cost R):** **Echo-Sergeant** — when you play a 2-cost or less Legion unit, replay its on-resolve effect once.
- **Payoff (5–6c R):** **Hammer-Stroke Doctrine** — 5c spell: all Legion attacks this turn trigger Echo (replays on-attack effects once).
- **2-3-4 spine:** Forge-Spark Skirmisher (1c, on-attack: deal 1 again under Echo), Iron Bayonet Drill (3c, Pierce + Echo on kill), Foundry-Sworn Pikeman (2c, formation buff).
- **Cheap fuel:** **Forge-Cry** (1c spell, give a Legion unit Echo for one attack).
- **Hard counter:** Coven Poison-Stack (Echo doesn't scale DoT ticks — stalls vs poison clocks).
- **Splashes into:** Ash-Mourners Trap-Control (Echo replays trap-triggered effects — natural hybrid).

### D3. Banner-Buff
- **Identity (4-cost R):** **Banner-Captain of the Crowned Anvil** — banner stays 3 turns; all Legion units in row gain +1 ATK and Shield-1 while it stands.
- **Payoff (5–6c R):** **Crowned Anvil Standard** — 5c artifact, persistent +1 ATK aura to friendly Legion in lane until destroyed (8 HP / no ATK).
- **2-3-4 spine:** Foundry-Sworn Pikeman (2c), Echo-Sergeant (3c, formation tempo), Forge-Conscript (4c, on-rally draw).
- **Cheap fuel:** **Standard-Bearer's Cry** (1c spell, +1 ATK to row this turn — cheap banner-substitute when removed).
- **Hard counter:** Iron Penitents Bleed-Stack (Bleed bypasses Shield-1 by ticking on off-attack turns).
- **Splashes into:** Ash-Mourners Smoke-Fear (Shield-1 aura + Smoke is a brutal turtle).

---

## 5. Skinward Pact — Cinderwood (summoner / monstrous)

_Faction not in MVP cards file. Archetype card names below are placeholders to be authored in C6._

### E1. Big-Monster
- **Identity (4-cost R):** **Bear-Skin Hierophant** — your highest-cost friendly Wilds unit gains +2 HP and Cleave.
- **Payoff (6c R):** **Thrask, the Bear-Who-Was-King** (existing flagship) — 6c 8/8 melee, on summon exile a Wilds card from hand to gain its keywords.
- **2-3-4 spine:** **Antler-Grown Ranger** (3c, +1 ATK if no other friendly Wilds in lane — solo tempo), **Cinderwood Stalker** (4c U, Lifesteal anchor), **Pelt-Gathered Hunter** (2c, +1 ATK if a friendly Wilds is at full HP).
- **Cheap fuel:** **Cub of the Sundered Tree** (1c, gains +1/+1 each time a friendly Wilds dies — bridge from token decks).
- **Hard counter (v0.1):** Last Legion Tempo-Echo (Echo replays small attacks on a single big chassis — wastes Echo's per-hit value AND eats Big-Monster's mana curve).
- **Splashes into:** Last Legion Banner-Buff (one big body + Shield-1 aura is the canonical "stall" tower).

### E2. Transformation
- **Identity (4-cost R):** **Wyrd-Shifter of the Cinderwood** — once per turn: pay 3 mana, transform a friendly Wilds unit into a beast costing 2 more (gains its statline + keywords).
- **Payoff (6c R):** **The Antler-King Awakened** — 6c spell: transform any friendly Wilds unit on the board into a 7/7 with Cleave + Fear (overrides cost-of-target rule).
- **2-3-4 spine:** Cub of the Sundered Tree (1c, growth target), Antler-Grown Ranger (3c, transform target), Cinderwood Stalker (4c U, transform fuel).
- **Cheap fuel:** **Wyrd-Bind** (1c spell, your next Transformation costs 1 less).
- **Hard counter:** Ash-Mourners Resurrect-Spam (Wraiths are tokens, not Wilds — invalid Transformation targets).
- **Splashes into:** Coven Sacrifice-Combo (sacrifice → transform is a 2-card combo line).

### E3. Beast-Summon
- **Identity (4-cost R):** **Pelt-Bound Shaman** — at start of each turn, summon a 1/2 Wolf-Token in your lane (cap 3 Wolves).
- **Payoff (5–6c R):** **Pack-Call of the Cinderwood** — 5c spell: summon 1/2 Wolf-Tokens equal to friendly Wilds units in lane (cap 4).
- **2-3-4 spine:** Cub of the Sundered Tree (1c), Antler-Grown Ranger (3c), Cinderwood Stalker (4c U, Lifesteal).
- **Cheap fuel:** **Cub-Cry** (1c spell, summon a 1/1 Cub-Token — cheaper than Wolf, but Wilds-tagged for Transformation feed).
- **Hard counter:** Last Legion Rally-Formation (Wolves are 1/2; formation Pierce/Cleave row-clears before the pack scales).
- **Splashes into:** Coven Bog-Spawn Swarm (token-summoner overlap; combined wolf+bog-spawn screen is a viable midrange shape).

---

## Notes for downstream backlog items

- **C2 (Iron Penitents full pool):** Use A1/A2/A3 spines above. Identity + payoff cards from this doc are net-new (Hierarch of the Open Wound, Saint of Cinders, Confessor-At-Arms, Procession Bleeds the Lane, Headsman of the Long Aisle). Existing P1–P9 fold in. Target ~40 cards.
- **C3 (Ash-Mourners full pool):** B1 reshapes M5 into a 4c R identity (statline change). Resurrect Spam needs **Necrologist of the Catacombs** authored. Trap-Control needs **Funeral Bellringer** authored. M11 repositions as payoff. Target ~40.
- **C4 (Coven full pool):** C6 Mother Quag stays as a **single dual-archetype card** (no split — Paul-locked 2026-05-01); printed once, slotted into both Poison-Stack and Bog-Spawn Swarm decks. New cards: Witch of the Bound Coin, Brood-Mother of the Mire, Ferryman of the Drowned Coin, Drowning of the Demon-Coin. Target ~40.
- **C5 (Last Legion full pool):** Net-new faction in the cards file. All ~40 cards to author. Identity/payoff cards above are placeholders pending C5 authoring.
- **C6 (Skinward Pact full pool):** Net-new faction. ~40 cards. Identity/payoff cards above are placeholders pending C6 authoring.
- **C7 (cross-faction balance pass):** Validate the anti-synergy grid with playtest sim — flag any archetype that has zero counter (none should). Validate rarity skew (~24 C / ~12 U / ~4 R per faction).
- **C8 (internal-MVP scope):** First playable build = Penitents + Mourners + Coven × ~100 cards (3 archetypes each, ~33 cards/faction lite-pool). Validate deckbuilder feel before adding Legion + Wilds.

## Resolutions applied (2026-05-01)

All four open questions resolved by Paul in-session. Decisions locked into the doc above (see v0.1 update block at top).

| # | Question | Paul's call | Where applied |
|---|---|---|---|
| 1 | C6 Mother Quag — split into two Rares or single dual-archetype card? | **Keep in both** (single card) | C1 + C2 archetype entries; C4 downstream note |
| 2 | M5 Last Censer-Bearer — promote 3c U → 4c R or author a fresh identity? | **Promote** | B1 archetype entry; flagged for `cards_v1.md` + C3 |
| 3 | Skinward Pact — stay wildcard / most-countered, or rebalance? | **Rebalance** | Anti-synergy grid restructured to symmetric 3-deal / 3-receive per faction |
| 4 | New card names — any GW/WotC vibe vetoes? | **Approved, go ahead** | Names locked for use in C2–C6 |

---

_v0.1 done. Next eligible heartbeat item: C2 (Iron Penitents full pool, ~40 cards + `.tres` files)._

---

## Sub-archetype cohesion audit (M7, 2026-05-26)

_M7 from `backlog.md`. For each of the 15 sub-archetypes (5 factions × 3), audit whether the identity card (4-cost rare) + payoff card (5-6c R) + the 2/3/4-cost spine + cheap fuel share at least 2 connecting keyword/mechanic references. Tight = the spine delivers a recognisable strategy by turn 4; loose = engine reads only on identity + payoff; re-spec = spine too generic._

**Definition of a "connecting reference":** a shared keyword (Bleed, Cleave, Smoke, Fear, Resurrect, Sacrifice, Penance, Poison, Echo, Banner, Shield, Transformation, Token-summon) OR a shared mechanic loop (e.g. on-friendly-death trigger, trap-triggered spawn, adjacency-formation, token-economy).

### Per-archetype ratings

| # | Archetype | Faction | Rating | Connecting refs |
|---|---|---|---|---|
| A1 | Bleed-Stack | Iron Penitents | **TIGHT** | Bleed (Identity, Payoff, P3, P4, P8); friendly-takes-damage loop (Hierarch, P2) |
| A2 | Sacrifice-Penance | Iron Penitents | **TIGHT** | Friendly-Penitent-death (Identity, Payoff, P9, P1); self-damage (P6, P7); ATK-buff-on-death (Identity, P1) |
| A3 | Cleave-Melee | Iron Penitents | **TIGHT** | Cleave (Identity, Payoff, P4); adjacency (Identity, P3, P2) |
| B1 | Smoke-Fear Control | Ash-Mourners | **TIGHT** | Dread/Fear (Identity, Payoff, M1, M7); Smoke (M3, archetype name); ATK-debuff (Payoff, M2) |
| B2 | Resurrect Spam | Ash-Mourners | **LOOSE** | Mourner-death-trigger/Wraith-spawn lives only on Identity + Payoff + M1; M2/M4/M3 are general Mourner support, not direct accelerants of the resurrect engine |
| B3 | Trap-Control | Ash-Mourners | **TIGHT** | Trap (Identity, Payoff, M9, M10); Wraith-spawn (Identity, Payoff); Root (Payoff, M7) |
| C1 | Poison-Stack | Coven | **TIGHT** | Poison (Identity, C3, C5, C8); Bog-Spawn economy (C4, C5, C2) |
| C2 | Bog-Spawn Swarm | Coven | **TIGHT** | Bog-Spawn summon (every card); Sacrifice (C5, Payoff-via-kill-return) |
| C3 | Sacrifice-Combo | Coven | **TIGHT** | Sacrifice (Identity, Payoff, C5); Bog-Spawn (Identity, Payoff, C2, C4); Poison (Payoff, C3) |
| D1 | Rally-Formation | Last Legion | **TIGHT** | Formation/adjacency (Identity, Pikeman, Bayonet Drill, Forge-Conscript); ATK-buff aura (Identity, Payoff, Pikeman) |
| D2 | Tempo-Echo | Last Legion | **TIGHT** | Echo (Identity, Payoff, Skirmisher, Bayonet Drill, Forge-Cry) — only Pikeman is formation-borrow rather than Echo-native |
| D3 | Banner-Buff | Last Legion | **LOOSE** | Banner-as-object reads only on Identity + Payoff + Standard-Bearer's Cry; Pikeman is shared with D1; Echo-Sergeant is borrowed from D2 — D3 has no unique 3c spine card |
| E1 | Big-Monster | Skinward Pact | **TIGHT** | Wilds (universal); solo-big-body / Lifesteal value chain (Identity, Ranger, Stalker) |
| E2 | Transformation | Skinward Pact | **TIGHT** | Transformation (Identity, Payoff, Wyrd-Bind; Cub/Ranger/Stalker as targets); Wilds (universal) |
| E3 | Beast-Summon | Skinward Pact | **LOOSE** | Token-summon lives only on Identity + Payoff + Cub-Cry; Ranger/Stalker/Cub-card are shared with E1, not summon-specific. Spine duplicates E1 — needs a Beast-Summon-unique 3c or 4c card |

### Tally

- **TIGHT: 12** — engine reads cleanly across identity + payoff + spine; new player can recognise the strategy by turn 4.
- **LOOSE: 3** — engine reads on identity + payoff but spine doesn't accelerate the loop. Listed below with re-design recommendations.
- **RE-SPEC NEEDED: 0** — no archetype is fundamentally incoherent; all 3 LOOSE archetypes are fixable by promoting or authoring a single spine card.

### Recommendations for the 3 LOOSE archetypes

**B2 Resurrect Spam (Ash-Mourners):** the spine's death-trigger acceleration is too thin. Two options:
- Option B2-a: re-tag M3 Ash-Speaker — currently "kill-tile becomes Smoke"; promote to "kill-tile spawns a 1/1 Ash Wraith instead of Smoke when the kill is by a Mourner" so the spine has a second on-death payoff that doesn't compete with the identity's once-per-turn cap.
- Option B2-b: author a fresh 3c U named **Wraith-Caller of the Dirge** — "when a friendly Mourner dies, the next friendly Mourner you play costs 1 less." Cuts mana cost of the resurrection chain, doesn't compete with the Necrologist's wraith spawn.

Pick one and propagate to `cards_ash_mourners_v1.md`. B2-b is the cleaner add — doesn't conflict with B1 Smoke-Fear's M3 dependency.

**D3 Banner-Buff (Last Legion):** the spine borrows from D1 (Pikeman) and D2 (Echo-Sergeant), leaving D3 with no unique 3c. Recommend:
- Author a 3c U named **Banner-Bearer of the Crowned Anvil** — "while a friendly banner stands in this row, gains +1 ATK and Pierce." Gives D3 its own 3c-cost anchor, makes the banner-as-object the spine's primary value lever, and reads as the natural progression from the 1c Standard-Bearer's Cry → 3c Banner-Bearer → 4c R Banner-Captain (identity) → 5c R Crowned Anvil Standard (payoff). Clean rarity ramp.

Propagate to `cards_last_legion_v1.md`. Existing Echo-Sergeant can stay as a tempo splash but is no longer load-bearing for D3.

**E3 Beast-Summon (Skinward Pact):** the spine duplicates E1's roster (Cub, Ranger, Stalker), so a Beast-Summon deck and a Big-Monster deck currently look identical at the 1-4 mana range. Recommend:
- Author a 3c U named **Pack-Caller Initiate** — "when you summon a Wolf-Token in your lane, draw 1 card (cap once per turn)." Gives E3 a unique mid-game card-draw engine tied directly to its token economy.
- Plus a 4c U named **Den-Mother of the Cinderwood** — "your Wolf-Tokens gain +1/+1 and Lifesteal while she is in lane." Anchors the spine at the curve-topping common slot.

Both propagate to `cards_skinward_pact_v1.md`. With these adds, the E1 / E3 split becomes legible at draft time: E1 = solo big body, E3 = token swarm with card-draw + Lifesteal scaling.

### Implications for downstream backlog

- These 3 fixes are NEW card adds (4 total: Wraith-Caller, Banner-Bearer, Pack-Caller Initiate, Den-Mother), not redesigns of existing cards. They slot into the 40-card faction pools as net-new entries — they DO NOT replace cards already authored in `cards_ash_mourners_v1.md`, `cards_last_legion_v1.md`, `cards_skinward_pact_v1.md`.
- Total card count rises by 4 (203 → 207 card heroes per `art_pipeline_readiness_v0.md` §1.1). Negligible art-pipeline impact (these are commons, ride the Stage-B common-tile validation, not new anchors).
- M6 (cross-faction synergy refinement v0.2, post-TAUNT) should consider whether TAUNT in Legion's Banner row interacts with these 3 new spine cards — flag for next pass.

— Controller, 2026-05-26

---

## v0.2 (post-TAUNT) — cross-faction synergy refinement (M6, 2026-05-26)

_M6 from `backlog.md` Phase 2.12. Re-audit of the v0.1 anti-synergy grid after TAUNT (spec: `keywords/taunt_v0.md`, design-locked 2026-05-15) introduces a single-target-redirect keyword to Last Legion (primary, 4 cards: L7, L11, L18, L33) and Iron Penitents (secondary, 2 cards: P3, P34). The Legion concentration is the structural force — TAUNT bodies in Legion lanes change which archetypes Legion can soft-counter and which can soft-counter Legion._

### Headline impact (the three shifts Paul flagged)

**1. Bleed-Stack (P A1) ↔ Banner-Buff (L D3) — HARDENS, no edge change.** Counter direction (L D3 → P A1) unchanged from v0.1. Strength deepens: L33 Banner-Captain now carries TAUNT in addition to SHIELD-1 + RALLY-2. Enemy attacks (in the Penitents-side analysis, "enemy" = the Bleed-Stack player's own bodies trying to land hits to trigger DoT) hit the high-HP TAUNT body first, where SHIELD-1 absorbs the initial chip. Bleed application still bypasses SHIELD per existing rules, BUT the bleed-applicator units (Hammer-Confessor P4, Hammer of Penance P8) take a full extra round of enemy fire before they can land their second/third stacks because the Banner-Captain holds the line. The math: v0.1 had Banner-Buff trading at ~55% win-rate vs Bleed-Stack in design-space estimation; v0.2 estimate is ~62%. Still beatable (Bleed wins late-game on DoT scaling), but the early window where Bleed needed to land 4 stacks by turn 5 just got tighter.

**2. Bog-Spawn Swarm (C C2) hard counter shifts: E E3 Beast-Summon → L D1 Rally-Formation.** Bog-Spawns (0/1 stats) used to lose to Wolf-tokens (1/2 stats) in straight token mirror. That logic still works mathematically — but the new dominant counter to Bog-Spawn Swarm is Legion's TAUNT line. Every Bog-Spawn attack in a Legion lane is now forced onto the TAUNT body (L7 Sergeant-Smith Vikar or L33 Banner-Captain), and a single soak body absorbs N bog-spawn attacks per turn without dying — the SHIELD-1 + RALLY +1 ATK means each Bog-Spawn dies to one return swing while the TAUNT body burns through them lane-by-lane. Swarm strategy fundamentally relies on attacking many different friendly targets to overwhelm; TAUNT collapses that into a single soak vector. Beast-Summon (E E3) is now demoted to a secondary counter — still effective in a Skinward mirror or against a non-TAUNT Coven line, but no longer the cleanest answer when Legion is on the table.

**3. Big-Monster (E E1) hard counter shifts: L D2 Tempo-Echo → L D1 Rally-Formation.** Big-Monster's chassis is a single 6-8 cost body with high HP and one big swing per turn. v0.1's counter was Tempo-Echo, whose Echo procs supposedly diluted the per-attack value when forced to replay small attacks on a single big chassis. The shift: Echo's per-attack-dilution argument was always thin (Echo only replays effects, not the attack damage itself in most card configurations), whereas TAUNT directly addresses the Big-Monster fantasy. L D1's TAUNT body soaks the Big-Monster's once-per-turn swing; SHIELD-1 absorbs the first hit's chip damage; RALLY +1 ATK and adjacent Pikeman/Forge-Conscript chip the Big-Monster down at 1-2 HP per turn while the TAUNT body holds. Big-Monster's payoff turn (Thrask the Bear-Who-Was-King resolving on turn 5-6) now needs to break through a TAUNT body before reaching the back line, fundamentally changing the tempo math. Tempo-Echo (L D2) is no longer the headline counter — it remains an annoyance but the TAUNT line is the new wall.

### v0.2 anti-synergy grid (with deltas marked)

| # | Archetype | Hard counter (v0.2) | Δ from v0.1 |
|---|---|---|---|
| A1 | Penitents — Bleed-Stack | Last Legion — Banner-Buff | unchanged (HARDENED) |
| A2 | Penitents — Sacrifice-Penance | Coven — Sacrifice-Combo | unchanged |
| A3 | Penitents — Cleave-Melee | Skinward Pact — Big-Monster | unchanged |
| B1 | Ash-Mourners — Smoke-Fear | Iron Penitents — Cleave-Melee | unchanged |
| B2 | Ash-Mourners — Resurrect Spam | Skinward Pact — Transformation | unchanged |
| B3 | Ash-Mourners — Trap-Control | Coven — Bog-Spawn Swarm | unchanged |
| C1 | Coven — Poison-Stack | Ash-Mourners — Trap-Control | unchanged |
| C2 | Coven — Bog-Spawn Swarm | **Last Legion — Rally-Formation** | **swap** (was Skinward Beast-Summon) |
| C3 | Coven — Sacrifice-Combo | Iron Penitents — Sacrifice-Penance | unchanged |
| D1 | Last Legion — Rally-Formation | Ash-Mourners — Smoke-Fear | unchanged |
| D2 | Last Legion — Tempo-Echo | Coven — Poison-Stack | unchanged |
| D3 | Last Legion — Banner-Buff | Iron Penitents — Bleed-Stack | unchanged |
| E1 | Skinward Pact — Big-Monster | **Last Legion — Rally-Formation** | **swap** (was Last Legion Tempo-Echo) |
| E2 | Skinward Pact — Transformation | Ash-Mourners — Resurrect Spam | unchanged |
| E3 | Skinward Pact — Beast-Summon | Last Legion — Rally-Formation | unchanged |

### v0.1 → v0.2 edge changes (2)

1. **C2 Bog-Spawn Swarm:** counter swapped from `E E3 Beast-Summon` → `L D1 Rally-Formation`. Logic per Shift 2 above.
2. **E1 Big-Monster:** counter swapped from `L D2 Tempo-Echo` → `L D1 Rally-Formation`. Logic per Shift 3 above.

### Structural deviation from v0.1's 3-deal / 3-receive symmetry

v0.1 locked symmetric per-faction balance: each faction dealt exactly 3 counters and received exactly 3. v0.2 BREAKS that symmetry in the direction TAUNT pushes:

| Faction | v0.1 deals | v0.2 deals | v0.1 receives | v0.2 receives | Δ |
|---|---|---|---|---|---|
| Iron Penitents | 3 | 3 | 3 | 3 | 0 |
| Ash-Mourners | 3 | 3 | 3 | 3 | 0 |
| Coven of the Black Mire | 3 | 3 | 3 | 3 | 0 |
| Last Legion | 3 | **5** | 3 | 3 | **+2 deals** |
| Skinward Pact | 3 | **1** | 3 | 3 | **−2 deals** |

Per-archetype: L D1 Rally-Formation now deals 3 counters (E E3 retained, plus C C2 and E E1 added). L D2 Tempo-Echo and E E3 Beast-Summon both fall to zero deals.

This is **intentional design pressure**: TAUNT is meant to make Legion the soak-faction of choice in the meta. Concentrating counter-power in L D1 reflects that. The trade-off is that v0.2 is no longer a clean symmetric web — Skinward (specifically Beast-Summon) loses its v0.1 over-trade lane, and Legion's Tempo-Echo loses its v0.1 anti-Big-Monster lane.

### Knock-on archetype-strength implications

- **L D1 Rally-Formation** becomes the strongest open-meta archetype in the v0.2 cross-faction matrix (3 deals, 1 receive). Likely needs gentle nerfs at C7-v0.2 balance pass — recommend Forge-Conscript card-draw trigger raised from "row-fill of 3 Legion units" to "row-fill of 4" to slow the Rally engine slightly.
- **L D2 Tempo-Echo** loses its headline counter use (anti-Big-Monster). Compensation: M9 cohesion fix in the same M7 audit doesn't touch D2; D2 remains TIGHT structurally. Echo-Sergeant (L18, R) already carries TAUNT per `taunt_v0.md` — so D2 isn't TAUNT-naked, it just isn't the primary TAUNT distributor. Leave as-is at v0.2; revisit if playtest shows D2 win-rate drops below 45%.
- **E E3 Beast-Summon** loses its only v0.1 counter (Bog-Spawn Swarm). With the M7 fixes (Pack-Caller Initiate + Den-Mother of the Cinderwood adding card-draw + Lifesteal scaling), E3 gains internal cohesion but still has zero cross-faction counter targets in v0.2. This is structurally OK (E3 just becomes a "neutral" archetype in the matrix — doesn't hard-counter anyone but isn't hard-countered either way, since C C2 ← E E3 in v0.1 was bidirectional pressure not hard counter). Flag for C7-v0.2 to confirm E3 doesn't fall into "no role in the meta" territory.
- **C C2 Bog-Spawn Swarm** now faces a much harsher hard counter (TAUNT line vs Wolves). Compensates via more open splash-room into Sacrifice-Combo (C C3) and Poison-Stack (C C1) — both of which can wear down a TAUNT body through DoT instead of attack-damage. Recommend `cards_coven_v1.md` adds a 1-line note to C2 archetype guidance: "Splash Poison cards (C3 Leech-Tender, C8 Antler Crown) when facing Legion TAUNT lines — DoT bypasses the TAUNT redirect."

### Symmetry-restoration options for v0.3 (deferred — not in M6 scope)

Three ways to restore the 3-deal / 3-receive per-faction balance if Paul wants strict symmetry:

- **Option v0.3-α (distribute TAUNT counter-power):** put C C2's counter at L D1 but E E1's counter at L D3 (instead of both at L D1). L D1 deals 2, L D3 deals 2, balance per-faction Legion = 4 deals. Still over by 1; would need a second offset.
- **Option v0.3-β (give E3 a new deal):** restore symmetry by having E E3 Beast-Summon counter L D2 Tempo-Echo (wolves dilute Echo's per-attack value across many targets, mirroring v0.1's Echo-vs-Big-Monster logic in reverse). Adds E3 → L D2 edge, removes one of L D1's new deals. Cleanest path back to symmetry.
- **Option v0.3-γ (accept asymmetry, document it as canon):** keep v0.2 as-is, treat Legion's TAUNT dominance as a meta-defining feature rather than a balance break. Paul's call on whether the meta should have a soak-faction at the top of the heap.

Recommend Option β as the C7-v0.2 balance-pass default unless Paul explicitly endorses γ. Deferring decision — does not block M8 (event-card content), M9 (shrine/rest), or M10 (Hanging Hour boss).

### Anti-P2W invariant restated

TAUNT redirects targeting; treatment_id (Cursed / Gold / Foil / etc.) does not. The combat layer reads `card.has_keyword(TAUNT)` not `card.treatment.has_keyword(TAUNT)` — cosmetic state never enters the targeting filter. Per `taunt_v0.md` Anti-P2W section. Restated here because the v0.2 grid concentrates TAUNT counter-power in L D1, which makes TAUNT-as-cosmetic the single highest IAP-temptation surface in the game; the engine MUST NOT honour cosmetic TAUNT.

### Open questions for Paul (none block M8/M9/M10)

1. **Symmetry stance.** Do you want C7-v0.2 to restore the per-faction 3/3 symmetry (Options α/β) or endorse Legion-as-soak-meta (Option γ)? Recommend β if undecided.
2. **L D1 Rally-Formation nerf — Forge-Conscript trigger.** Raise row-fill threshold from 3 → 4 Legion units to slow the engine? Or leave at 3 and watch playtest data?
3. **E E3 Beast-Summon role.** With zero v0.2 deals, is E3 still a "viable archetype" or does it slide into "fun-only / not competitive"? May need a small buff at C7-v0.2 — e.g., promote Pack-Caller Initiate's draw cap from once-per-turn to twice-per-turn.

### Implications for downstream backlog

- **No card adds.** v0.2 is pure matrix-shift commentary; M7's 4 card adds (Wraith-Caller, Banner-Bearer, Pack-Caller Initiate, Den-Mother) remain the only net-new cards from the Phase 2.12 audit cycle.
- **No `.tres` edits required from M6.** Engine wiring of TAUNT itself is E1's job; the v0.2 grid is design-doc-only.
- **No art-pipeline impact.** Same 207-card hero count post-M7. v0.2 matrix-shift adds nothing to the shotlist.
- **M8/M9/M10 unblocked.** Event/shrine/boss design proceeds against the v0.2 matrix without further dependency.

— Controller, 2026-05-26

---

## v0.2 (post-TAUNT — cross-faction synergy refinement)

_M6 from `backlog.md`. Re-audit the v0.1 anti-synergy grid after TAUNT lands in Legion (4 cards: L7, L11, L18, L33) and Penitents (2 cards: P3, P34) per `keywords/taunt_v0.md`. TAUNT is single-target attack redirect onto a tagged friendly in range; does NOT affect Cleave / Pierce / AoE / spells / tokens; stacks with SHIELD._

### v0.2 grid (deltas only — unchanged edges inherit from v0.1)

| Archetype edge | v0.1 verdict | v0.2 delta | Magnitude |
|---|---|---|---|
| **L-Banner-Buff vs P-Bleed-Stack** (mutual rivalry, both directions) | Shield-1 chains soak Bleed; Bleed bypasses Shield on off-attack turns | **TAUNT+SHIELD double-soak intensifies Banner's anti-Bleed line.** Bleed application requires friendly Penitents taking damage; TAUNT pulls enemy attacks onto a SHIELD-buffed Banner body that doesn't carry Bleed-trigger tags. The "tick on off-attack turns" loophole still favours Bleed slightly, but the bulk-stacking phase is starved. | Hardened ↑↑ |
| **L-Rally-Formation vs S-Beast-Summon** | Wolf-tokens (1/2) are out-stat-ed by formation Pierce/Cleave row-clears | **L11 Iron Watch Standard-Bearer's TAUNT pulls Wolf attacks onto a SHIELD-1 body before formation clears the row.** Beast-Summon's tempo path narrows further: Wolves no longer trade evenly into the front line before Pierce arrives. | Hardened ↑ |
| **L-Rally-Formation ← M-Smoke-Fear** | Fear scatters ATK targets; formation math breaks | **TAUNT preserves the soak layer; Fear's ATK debuff still cripples the offensive amp.** Net: Rally no longer collapses fully under Smoke-Fear — partial counter instead of hard counter. The formation can still hold a defensive line; it just can't push damage. | Softened ↓ |
| **L-Tempo-Echo vs S-Big-Monster** (v0.1 had Echo countering Big-Monster) | Echo wastes per-hit value on a single big chassis | **L18 Echo-Sergeant's new TAUNT+ECHO combo means the taunter replays its on-resolve effect after soaking damage.** Now reads as a self-replaying soak loop — flavour-perfect for Tempo-Echo but creates a Big-Monster matchup wrinkle: Big-Monster's single huge hit lands on the TAUNT'd Echo-Sgt, Echo replays on damage absorbed, partial counter softens. | Softened ↓ |
| **P-Cleave-Melee ↔ M-Smoke-Fear** | Cleave clears Mourner cheap units before Smoke layers | **P3 Cathedral Brother now has TAUNT** — gives Penitent player a cheap-soak option that didn't exist. Doesn't directly affect the Cleave vs Smoke-Fear counter, but enables a *hybrid* Penitent build (TAUNT-front-line + Cleave-back) that's more resilient to early-game Dread procs. | Marginal — Penitent flex increases |

### v0.2 grid summary — Legion's resilience increases asymmetrically

The TAUNT additions concentrate in Last Legion (4 cards across all 3 sub-archetypes) and Penitents (2 cards). Concretely:

- **Legion gains:** 2 hardened counter deals (vs Bleed via Banner; vs Beast-Summon via Rally), 2 softened counter receives (Smoke-Fear no longer fully crips Rally; Big-Monster softens Tempo-Echo less). Net Legion balance: more durable in defensive matchups; the "formation soak" identity now reads cleanly.
- **Penitents gain:** marginal flex — P3's TAUNT enables a hybrid build pattern that hadn't existed. No structural counter shifts.
- **Mourners / Coven / Skinward:** structurally unaffected by TAUNT (none allocated). Their existing 3-deal / 3-receive balance holds.

The v0.1 structural property (every archetype deals 1 + receives 1) is preserved at the GRID level — no edges flipped sides. But the *strength* of two edges intensified (Banner→Bleed, Rally→Beast) and two softened (Smoke-Fear→Rally, Big-Monster→Echo). The grid is no longer symmetric in counter-magnitude even though it's symmetric in counter-count.

### Emergent design considerations to flag

**1. L18 Echo-Sergeant — TAUNT + SHIELD + ECHO triple-stack.** Per TAUNT spec, Echo replays on-resolve effects; combined with TAUNT (attract hits) and SHIELD (absorb hits) on the same body, L18 becomes a self-replaying soak chassis. Flavour-perfect for Tempo-Echo's "the line replays its own discipline" identity, but **needs explicit balance review**: how many replay cycles per turn before it dominates a lane? Recommend cap at 1 ECHO proc per TAUNT-absorption per turn in the engine wiring (E1 backlog item).

**2. P3 Cathedral Brother — Penitents now have a cheap defensive option.** Previously the faction had no soak unit < 4 cost (P34 Hammer-Curate is 4c U). P3 at 2c with TAUNT enables Bleed-Stack lists to soak early-game enemy spike while the Hierarch + Whip-Brother chain spins up. This was a known weakness in v0.1 — P-Bleed lost too many board-clear games before Bleed stacks hit 3. TAUNT on P3 is a genuine power buff to Bleed-Stack — flag for the playtest sim in C7.

**3. Banner-Buff's anti-Bleed counter is now load-bearing.** The intensified L-Banner→P-Bleed edge means Bleed-Stack pilots will draft AROUND Banner-Buff matchups. Confirm via playtest sim (C7) that this doesn't create a "P-Bleed is always 3rd-pick if L-Banner is on the board" meta — if so, soften the SHIELD-1 stack from Banner-Captain to compensate.

**4. Smoke-Fear is weaker vs Legion overall.** With TAUNT preserving Rally's soak, Smoke-Fear's "Fear scatters formation" hard counter softens to partial. Mourners need a new edge into Legion — or they need a non-Legion counter they currently lack. Worth re-evaluating M-Resurrect-Spam's S-Transformation edge in light of this (does Mourner have enough total counter pressure?). **Out of M6 scope; queue for C7 playtest pass.**

### What this changes downstream

- `cards_iron_penitents_v1.md` — annotate P3 with the TAUNT keyword flag (M5-style markdown flag, .tres edit at E1).
- `cards_last_legion_v1.md` — annotate L7/L11/L18/L33 with TAUNT flags.
- `archetypes_v0.md` — this v0.2 section (now appended).
- `keywords/taunt_v0.md` — add cross-reference to this v0.2 audit + the §"Emergent design considerations" balance flags.
- `playtest_sim_brief.md` (C7, future) — must include the 4 v0.2 deltas as targeted scenarios.

— Controller, 2026-05-26 (M6 complete)
