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
- **Payoff (5–6c R):** **C6 Mother Quag, Twice-Drowned** (dual-archetype payoff — same card as C1 Poison-Stack; here serves the recycle half: every 3rd enemy killed returns as a friendly Bog-Spawn).
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
