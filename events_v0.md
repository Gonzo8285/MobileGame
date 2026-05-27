# Event-card content v0 (Phase 2.12.M8)

_Authored 2026-05-18 by Controller. 10 narrative-choice events for the EVENT NodeKind (B2.9). Each event = title + 2-line setup + 3 choices, each choice with mechanical payoff and faction-flavour binding. Source: `faction_bible.md` (biome/lore alignment) + `archetypes_v0.md` (faction mechanical identity) + `lore_gallowfell.md` (canonical lore). Engine wiring is M8.E1 (separate item)._

## Format

```
ID  · Title
Biome | Suggested floor depth (1-5) | Faction echo

Setup (2 lines, prose, second-person)

Choices:
  A. Choice text
     -> mechanical payoff (gold/heal/curse/relic/card-add/card-remove)
     -> faction flavour binding
  B. Choice text
     -> mechanical payoff
     -> faction flavour binding
  C. Choice text
     -> mechanical payoff
     -> faction flavour binding
```

**Payoff scale (target):** A/B/C choices on each event balance to "two safe-ish + one risky-with-upside" or "one easy + two costly-with-character". Mechanical impact tuned so no single event swings the run; 10 events together should swing perhaps 1-1.5 deck-slots of value across an average chapter.

**Faction echo:** each choice carries the *flavour* of one faction, not a hard buff. Players don't need to play that faction to take the choice — the binding is narrative/audio/art. Allows event cards to deepen world without straitjacketing the deckbuild.

---

## E01 · The Cracked Reliquary
**Cathedral Ruins** | Floor 1-2 | Iron Penitents echo

You step over a fallen pew. A reliquary lies cracked open beside it; the wax-sealed bone inside is still warm. Something inside it shifts as your shadow falls across the opening.

Choices:
  A. **Pocket the bone-relic.** Take the warm fragment with you.
     -> gain relic: *Warm Bone-Splinter* (your next combat, the first time you take damage, deal 3 to a random enemy)
     -> faction flavour: Iron Penitents — quiet satisfaction
  B. **Reseal the reliquary in prayer.** Spend a moment in the gesture.
     -> heal 6 HP, then add a copy of *Crowned Martyr* (P3) to your deck
     -> faction flavour: Iron Penitents — formal respect
  C. **Break the reliquary fully open.** Smash the wax.
     -> gain 35 gold, gain 1 curse: *Reliquary Debt* (-1 max HP for this chapter)
     -> faction flavour: greedy, no faction tie

---

## E02 · The Court Writ
**Ash Quarter** | Floor 1-3 | Ash-Mourners echo

A skeletal courier kneels in the gutter, signet ring still glowing on a phalanx bone. A black-sealed writ rests on the cobblestones beside it, addressed to no one.

Choices:
  A. **Read the writ.** Break the seal.
     -> learn one random enemy's stats in the next two combats (deck-add: *Witness Token* relic, peek-on-encounter)
     -> faction flavour: Ash-Mourners — court procedure
  B. **Sign your name where the addressee should be.** Make the writ yours.
     -> add a copy of *Lord-Justiciar Vey, Witness in Black* to your deck (powerful 4-cost rare)
     -> gain 1 curse: *Court Debt* (each combat you must spend at least 1 mana on a non-attack action)
     -> faction flavour: Ash-Mourners — accepting an obligation
  C. **Burn it unread.** The wax hisses.
     -> remove 1 card from your deck (your choice), but: -2 max HP for the rest of the chapter
     -> faction flavour: Coven of the Black Mire — burning a binding

---

## E03 · The Demon-Coin Pool
**Black Mire** | Floor 2-3 | Coven of the Black Mire echo

A pool of stagnant bog-water sits between two reed-banks. Hundreds of demon-coins float face-up just below the surface, more than you can carry. None of them are the right one.

Choices:
  A. **Take exactly one coin.** Slow, deliberate.
     -> gain relic: *Singular Demon-Coin* (start each combat with 1 free mana for the first turn only)
     -> faction flavour: Coven of the Black Mire — patient bargain
  B. **Wade in and take a fistful.** Greedy.
     -> gain 60 gold, gain 1 curse: *Mire-Bound* (the next two events you encounter become Coven-flavoured regardless of biome)
     -> faction flavour: Coven of the Black Mire — overdrawn
  C. **Drop your own coin into the pool.** A tribute.
     -> spend 25 gold; if you have it, gain a Bog-Spawn (0/1) token-add for your starting hand each combat for the rest of this chapter; if not, no effect
     -> faction flavour: Coven of the Black Mire — accepted tithe

---

## E04 · The Frozen Hammer-Strike
**Forgotten Parade** | Floor 2-4 | The Last Legion echo

The parade route is empty, but you can hear hammering. In the foundry off the parade, a hammer hangs in mid-strike above an anvil with no smith. The iron under it is white-hot.

Choices:
  A. **Place your weapon on the anvil.** Let the strike finish.
     -> remove 1 attack card from your deck (your choice); add upgraded copy back: +1 ATK, +1 cost
     -> faction flavour: The Last Legion — disciplined upgrade
  B. **Take the suspended hammer.** Pry it from the air.
     -> gain relic: *Forge-Stilled Hammer* (your first attack each combat hits twice for that turn)
     -> faction flavour: The Last Legion — claiming an heirloom
  C. **Let it finish striking down at empty iron.** Walk away.
     -> heal 12 HP (the resonance is calming, somehow)
     -> faction flavour: The Last Legion — observed routine

---

## E05 · The Cinder-Mother Watches
**Cinderwood** | Floor 3-4 | Skinward Pact echo

A burnt mother-tree splits open one knot like an eye. Charcoal-orange pupil tracks you across the clearing. Around her base, three offerings have been left by previous travellers — a coin, a feather, a tooth.

Choices:
  A. **Leave your own offering.** Drop a card.
     -> remove any 1 card from your deck permanently (your choice)
     -> faction flavour: Skinward Pact — a price paid in self
  B. **Take all three existing offerings.** No one will know.
     -> gain 40 gold AND add *Mother Quag, Thirteen-Times-Drowned* OR *Hierarch of the Open Wound* (your choice) to your deck
     -> gain 1 curse: *Watched* (the Cinder-Mother's eye appears in 2 future events; outcomes are randomised within range, not optimised)
     -> faction flavour: Skinward Pact — broken pact
  C. **Stare back.** Don't blink.
     -> nothing happens. The eye closes. (Skip the event with no effect.)
     -> faction flavour: Skinward Pact — feral parity

---

## E06 · The Hanging Sentry
**Gallows Hill (boss biome)** | Floor 4-5 | Iron Penitents echo

A lone Penitent kneels at a side-gallows, hood pulled forward, hands clasped. Three other Penitents are hanged from the same beam, motionless. The kneeling one doesn't look up. Their lips are moving.

Choices:
  A. **Kneel beside them.** Pray with them.
     -> at the start of the next combat, the first enemy to die also kills the enemy adjacent to it (one-time effect for this chapter)
     -> faction flavour: Iron Penitents — communion
  B. **Cut down the three hanged.** End the prayer.
     -> heal to full HP
     -> gain 2 curses: *Disrupted Rite* and *Penitent Mark* (every combat, you start with -1 mana for the first turn)
     -> faction flavour: Iron Penitents — sacrilege
  C. **Walk past.** Don't engage.
     -> gain 20 gold (a Penitent purse-bead slips from their hand as you pass)
     -> faction flavour: opportunistic, no faction tie

---

## E07 · The Choir of Catacombs
**Ash Quarter** | Floor 3-4 | Ash-Mourners echo

A wet, perfectly-harmonised hymn rises from a sealed catacomb door. Twelve voices, no breath between them. The door has a courtroom-style writ-slot at face height.

Choices:
  A. **Slide gold through the slot.** The court price.
     -> spend 30 gold; if you have it, gain relic: *Choir Beads* (every combat, your first card played costs -1 mana). If you don't have 30 gold, the door doesn't respond.
     -> faction flavour: Ash-Mourners — paid passage
  B. **Press your ear to the door.** Listen.
     -> learn the boss's first move ahead of time (text revealed in the boss's opening turn for this chapter)
     -> faction flavour: Ash-Mourners — courtroom intelligence
  C. **Sing back.** Match the harmony.
     -> add *Witness Choir* token to your starting hand every combat for the rest of this chapter (1-cost, deals 1 damage and applies *Heard*: -1 ATK to target next turn)
     -> faction flavour: Ash-Mourners — invited into the rite

---

## E08 · The Bog-Wife's Bargain
**Black Mire** | Floor 3-5 | Coven of the Black Mire echo

A figure waist-deep in the bog turns slowly to face you. Her hair is full of toads. She offers a cupped hand of green water and says, in a perfectly courteous voice: "You will give me three things, and I will give you one."

Choices:
  A. **Give her your name.** (Only your name, said aloud.)
     -> rename your run (cosmetic); gain relic: *Bog-Witnessed* (one-time, when you would die, you survive at 1 HP instead — this chapter only)
     -> faction flavour: Coven of the Black Mire — name as bond
  B. **Give her three gold coins.** Easy.
     -> spend 30 gold; gain a guaranteed common Coven card (random pick of: Bog-Spawn, Leech-Belt Initiate, Mire-Marsh Hag); guaranteed-good outcome
     -> faction flavour: Coven of the Black Mire — small mercantile bargain
  C. **Refuse.** Walk on.
     -> she throws a stone at your back as you leave. Lose 5 HP.
     -> faction flavour: insolent, no faction tie

---

## E09 · The Drill-Sergeant's Ghost
**Forgotten Parade** | Floor 1-3 | The Last Legion echo

Bayoneted bones still stand at attention in a long-empty barracks. One bone-shape stands slightly apart from the rest, sword raised, frozen mid-bellow. He's waiting for something to be done correctly.

Choices:
  A. **Show him your deck.** Lay it out for inspection.
     -> the bone-shape moves twice — once to the worst card in your deck, once to the best. Lose the worst (remove); duplicate the best (add copy).
     -> faction flavour: The Last Legion — drill discipline
  B. **Drill yourself for an hour.** Stand in formation.
     -> heal 20 HP, but lose your next combat's first-turn (you start at -1 mana that turn)
     -> faction flavour: The Last Legion — exertion
  C. **Bayonet his shoulder-plate, pull it off, walk away.** Take a trophy.
     -> gain relic: *Crowned-Anvil Pauldron* (the first time you take damage in each combat, the attacker takes the same damage back)
     -> gain 1 curse: *Court-Martialled* (Last Legion units in your deck cost +1 mana for the rest of this chapter)
     -> faction flavour: The Last Legion — desertion, punished

---

## E10 · The Tree Carves Your Name
**Gallows Hill (boss biome)** | Floor 5 (just before boss) | Neutral — gallows-tree itself

The gallows-tree's bark is fresh-cut. The name being carved into it is yours; the wood is bleeding amber as you watch. The carving slows when you look at it directly.

Choices:
  A. **Touch the wet sap with one finger.** A small intimacy.
     -> the boss begins the upcoming combat with one fewer "phase" (lose its first wind-up turn). One-time only.
     -> faction flavour: neutral — directly contracting with the curse
  B. **Carve a different name underneath yours.** Pick someone.
     -> the carved name becomes a one-shot relic: *Names On The Tree* — call it in any future combat this chapter to instantly kill the lowest-HP enemy (one use, ever, this chapter).
     -> faction flavour: neutral — naming someone else
  C. **Carve over your own name.** Erase it.
     -> the boss's first attack of the upcoming combat targets a random enemy instead of you (one-time only). Gain 1 curse: *Anonymous* (every event for the rest of this chapter offers only options A/B/C re-randomised — you can't reload).
     -> faction flavour: neutral — denial

---

## Implementation notes (Phase 2.12.M8 close-out)

- Engine wiring (M8.E1, separate item) needs:
  - `EVENT` NodeKind picker reads from this file or its compiled JSON
  - Per-choice payoff dispatch (relic-add, deck-add, deck-remove, gold delta, HP delta, curse-add)
  - Faction-flavour binding for art/audio overlay (not mechanical)
- Curses, relics, and one-shot effects referenced here may need stub definitions in `card.gd` or `relic.gd` — list of new identifiers:
  - Relics: `Warm Bone-Splinter`, `Singular Demon-Coin`, `Forge-Stilled Hammer`, `Choir Beads`, `Bog-Witnessed`, `Crowned-Anvil Pauldron`, `Names On The Tree`
  - Curses: `Reliquary Debt`, `Court Debt`, `Mire-Bound`, `Watched`, `Disrupted Rite`, `Penitent Mark`, `Court-Martialled`, `Anonymous`
- Floor depth suggestions assume 5-floor chapter; rescale if chapters get longer/shorter.
- Balance pass post-playtest: target a +/- 1 deck-slot value swing across all 10 events combined.
- Art prompts for each event are in `art_specs/events_art_v0.md` (Phase 2.12.M9 candidate).
- **Phase 2.12.M8 acceptance criterion (this file):** 10 narrative-choice events authored with title + setup + 3 choices + payoff + faction binding, across 5 biomes + 1 boss biome. ✓

— Controller, 2026-05-18
