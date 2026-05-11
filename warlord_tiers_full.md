# W2 — Warlord tier content (full roster)

_Authored 2026-05-11 heartbeat. Implements `warlord_tiers_v0.md` §3.2–§3.4 for all 11 Warlords from `warlords_v1.md`. Per-Warlord Tier 2 variant passives (×2 each), Tier 3 signature alt-fire, and Tier 4 mastery payoff. Anti-P2W invariant from W1 strictly applied: A/B variants are sidegrades, alt-fires are same-cost shape-rotations, mastery is cosmetic + lore + harder-challenge slot. No raw stat unlocks anywhere._

## Reading guide

Each entry follows the W1 template:
- **Default** lines re-state the Tier-1 passive/spell from `warlords_v1.md` (so this doc is self-contained for designers).
- **T2 Variant A** trends offensive (more damage / more cost). **T2 Variant B** trends defensive or utility. Both are simultaneously unlocked at Tier 2; player picks one per run (or stays on Default).
- **T3 Alt-fire** has the **same mana cost, same cooldown band** as the default sig spell. The effect is rotated on one axis only (damage→heal, single→AoE, immediate→delayed, offence→debuff, etc.).
- **T4 Mastery** is the four-part one-shot payoff: skin / lore line / title / Ascension modifier.

Per W1 Open Q4, the wildcard/lore-locked Warlords (W10, W11) get **campaign-tier Ascension slots** rather than standard A11 slots. Flagged at the bottom of those entries.

---

## Free roster

### W1 — Penance-Captain Vyrrun · Iron Penitents · Aggro
- **Default — _Mortify_:** Lose 2 HP at start of wave; your units gain +1 ATK that wave.
  - **T2 Variant A — _Flagellant Rite_:** Lose 4 HP at start of wave; your units gain +2 ATK AND Bleed-1 that wave. (Higher self-damage, faster wave clear, painful at Hanging Hour.)
  - **T2 Variant B — _Ash-Vow_:** Don't lose HP at start of wave; your units gain +1 armor that wave (no ATK buff). (Pure defensive flip — slower clears, longer runs.)
- **Default sig spell — _Self-Scourge_** (3 mana): Deal 3 dmg to your strongest unit. All your units gain +2 ATK this wave.
  - **T3 Alt-fire — _Bone-Pageant_** (3 mana): Deal 3 dmg to your WEAKEST unit. If it dies, it Persists at the Hanging Hour with +2 ATK regardless of its base Persist eligibility. (Immediate buff → delayed sacrifice payoff. Same cost. M1/M4 hooks live.)
- **T4 Mastery:**
  - _Skin:_ "The Flayed Sermon" — armor stripped, brass mask cracked vertically, ribs visible like tabbed prayer-pages; hammer trails a thin rope of his own blood.
  - _Lore:_ "Vyrrun's brother led the first column. Twelve days from Gallowfell, the brother fell silent. Vyrrun took up the mask he had bled into."
  - _Title:_ "Mastered: Penance-Captain."
  - _Ascension mod:_ **Vyrrun A11 — _The Long Bleed_:** All friendly Bleed effects cost +1 mana to apply. Self-Scourge's wave-buff is unchanged; the rest of the deck pays the tariff.

### W2 — Court-Necromant Sieren · Ash-Mourners · Control
- **Default — _Hanged Memory_:** The first time per battle one of your units dies, raise it on the same tile as a 1/1 Withered Servant.
  - **T2 Variant A — _Sworn in Ink_:** The first TWO unit deaths per battle each raise a 1/1 Withered Servant — but Sieren takes 2 HP per raise. (Doubles the engine. Pays in HP.)
  - **T2 Variant B — _Quiet Pall_:** The first unit death per battle places 2 Smoke tiles adjacent to the death tile instead of raising a Servant. (Trades body-engine for board control. Plays into Saint-of-Gallowsmoke-adjacent decks.)
- **Default sig spell — _Funeral Writ_** (3 mana): Root all enemies in target lane for 2 turns; deal 1 dmg/turn rooted.
  - **T3 Alt-fire — _Glean_** (3 mana): Exhaust 2 cards from discard + consume target friendly unit's discard entry → summon a copy of any UNIT in discard to a friendly tile at -1 ATK (floor 0). Tokens and already-Persisted bodies excluded. (Lane-control DoT → resource conversion. Spec'd in detail in `sieren_t3_glean_v0.md` per M3.)
- **T4 Mastery:**
  - _Skin:_ "Court of One" — robes resolve fully into grave-shrouds, raven-quill becomes an actual raven's beak fused to her hand, ink trails drip from her fingers and form letters mid-air before falling.
  - _Lore:_ "The warrants she signed in blood became aware. They demand updates. She still writes them every dawn, in her old court hand."
  - _Title:_ "Mastered: Court-Necromant."
  - _Ascension mod:_ **Sieren A11 — _Ink Runs Pale_:** All Reanimated units (Hanged Memory included) arrive at 1 HP regardless of source. The engine still runs; everything raised is fragile.

### W3 — Marsh-Mother Eddra · Coven of the Black Mire · Swarm
- **Default — _Brood_:** At the start of each wave, summon a free 1/1 Familiar (Poison-1) on your back tile.
  - **T2 Variant A — _Twelvebirth_:** Start of each wave, summon TWO 1/1 Familiars (Poison-1) — but your deck cannot draw on turn 1 of that wave.
  - **T2 Variant B — _Old Bargain_:** Start of each wave, summon one 2/2 Familiar (no Poison) — but it gains Resurrect-once. (Trades swarm-and-poison for a single sturdier body.)
- **Default sig spell — _Hex of Many_** (3 mana): Replace one enemy with three weak Bog-Born tokens.
  - **T3 Alt-fire — _Hex of One_** (3 mana): Mark one enemy. They become a 1/1 token but keep their original ATK. Lasts until killed. (Replacement-swarm → singleton-debuff. The boss is still scary, just easy to drop.)
- **T4 Mastery:**
  - _Skin:_ "The Thirteenth Body" — wreath of demon-coins burnt black, three shadows resolve into twelve at the edges of vision, eyes show all thirteen deaths at once.
  - _Lore:_ "Each of her former bodies still walks the bog. They do not know she lives in a new one. They are looking for her."
  - _Title:_ "Mastered: Marsh-Mother."
  - _Ascension mod:_ **Eddra A11 — _The Bog Forgets_:** Friendly tokens cannot block. They push past blockers freely, but die on any lane-end damage instead of soaking it. Swarm gets faster; defensive turtling collapses.

### W4 — Forge-Marshal Veska · The Last Legion · Tempo
- **Default — _Forge-Heat_:** When you play a Host unit, draw a card if you control 3+ Host units.
  - **T2 Variant A — _Crucible Vow_:** Threshold drops to 2+ Host units — but Veska's run starts with -1 max hand size. (Faster draw engine, tighter hand pressure.)
  - **T2 Variant B — _Anvil Stance_:** When you play a Host unit, the NEXT Host unit you play costs 1 less (refreshes on use). Replaces the draw entirely with a cost-curve compressor.
- **Default sig spell — _Iron Cohort_** (3 mana): All your Host units shift one tile forward, gain +1 ATK this wave.
  - **T3 Alt-fire — _Iron Retreat_** (3 mana): All your Host units shift one tile BACK, gain +1 armor this wave; the vacated tiles count as Trap-tiles for 1 turn (any enemy entering takes 1 dmg). (Forward-tempo → defensive reposition + lane-trap. Same cost. Same cooldown band.)
- **T4 Mastery:**
  - _Skin:_ "The Cold Furnace" — soot-armor turned to ash-grey lacquer, brass gorget darkened to lead, the ironwood baton's tip glows once on first attack each wave and then never again.
  - _Lore:_ "Six years in Gallowfell. She has not slept once. She no longer remembers what the Emperor looks like, only the smell of his orders."
  - _Title:_ "Mastered: Forge-Marshal."
  - _Ascension mod:_ **Veska A11 — _Pure Iron_:** Echo keyword triggers on Host-faction units only. Cross-faction Echo combos go cold. Forces purist Legion decks; rewards them.

### W5 — Tree-Walker Mhar · Skinward Pact · Summoner
- **Default — _Wear the Dead_:** When one of your summons dies, your next summoned unit costs 1 less.
  - **T2 Variant A — _Wear the Many_:** When a summon dies, your next TWO summoned units cost 1 less (the discount stacks once but doesn't compound) — Mhar's starting hand is -1 card.
  - **T2 Variant B — _Wear the Wound_:** When a summon dies, draw a card instead of the cost discount. (Replaces ramp with card-flow. Plays differently into mid-cost curves.)
- **Default sig spell — _Don the Pelt_** (3 mana): Sacrifice a unit; summon a stronger version of it (same name, +50% stats) on the same tile.
  - **T3 Alt-fire — _Shed the Pelt_** (3 mana): Sacrifice a unit; summon TWO weaker copies (same name, 50% stats each) on adjacent friendly tiles. The copies cannot Persist (anti-loop guard). (Single-stronger body → swarm-split.)
- **T4 Mastery:**
  - _Skin:_ "The God-Tree's Heir" — antler-crown blossoms with living cinder-leaves, the second heart visibly beats through the ribcage, smoke from his fingers takes the shape of small running animals.
  - _Lore:_ "The seed in his ribcage has started speaking back. He no longer remembers if he taught it Gallowfell's tongue or it taught him."
  - _Title:_ "Mastered: Tree-Walker."
  - _Ascension mod:_ **Mhar A11 — _The Bark Bleeds_:** All summoned units enter with Bleed-1. Swarms come bigger and die faster. Faction-flavoured trade.

---

## Paid roster

### W6 — The Vow-Broken Magus · Iron Penitents × Ash-Mourners · Hybrid Aggro/Control
- **Default — _Twinned Vow_:** Every 3rd card you play, add a free random Penitent OR Court spell to hand.
  - **T2 Variant A — _Triple Vow_:** Every 4th card you play, add a free random Penitent AND Court spell to hand (one of each). (Slower trigger, double yield.)
  - **T2 Variant B — _Broken Vow_:** Every 3rd card you play, add a free random non-Penitent non-Court spell to hand (from any of the other 3 factions). (Genuinely chaotic mid-deck.)
- **Default sig spell — _Brand of Penance_** (3 mana): Mark an enemy. Whenever the marked enemy takes damage, the next attacker (yours) gains +2 ATK.
  - **T3 Alt-fire — _Brand of Pall_** (3 mana): Mark an enemy. Whenever the marked enemy takes damage, place 1 Smoke tile adjacent to them for 1 turn. (Offence-buff cascade → control-zone application. Different fantasy, same scaffold.)
- **T4 Mastery:**
  - _Skin:_ "The Two Vows Kept" — mask split open down the middle in two cleanly polished halves: brass to the left, black silk shroud to the right; body bare and ash-streaked between.
  - _Lore:_ "He keeps a count, in two columns. The first column is debts paid in his blood. The second is debts paid in his sister's."
  - _Title:_ "Mastered: Vow-Broken Magus."
  - _Ascension mod:_ **Magus A11 — _The Vow Settles_:** Twinned Vow rolls only ONCE per battle; the resulting spell-faction pool is fixed at battle start. No more cross-faction chains mid-fight. Forces commitment.

### W7 — Warden Caspar Voll, the Empty Throne · The Last Legion · Tempo (boss-control)
- **Default — _Gaoler's Word_:** Once per battle, freeze (Slow-3) an enemy boss for 2 turns.
  - **T2 Variant A — _Gaoler's Vigil_:** Once per battle, freeze ANY non-boss enemy for 3 turns instead of bosses. (Wider scope, shorter targets — anti-elite, not anti-boss.)
  - **T2 Variant B — _Gaoler's Reach_:** Twice per battle, Slow-1 on any enemy (bosses included). (Smaller per-cast but reusable; pure tempo.)
- **Default sig spell — _Throne Gone Cold_** (3 mana): Banish a non-boss enemy to the back of the wave queue; they return later, weakened.
  - **T3 Alt-fire — _Throne Gone Hot_** (3 mana): Banish a non-boss enemy; on their return they arrive Bleeding-3 and the player gets a 2-turn telegraph before they re-enter the lane. (Delayed-weakening → telegraphed Bleed payoff. Trades the surprise for the burn.)
- **T4 Mastery:**
  - _Skin:_ "The Throne Returned" — broken sceptre re-forged from gallows-iron with a fresh execution-knot welded to the head, keyring now made of officer's teeth not human, the missing ear visible as a scarred hollow.
  - _Lore:_ "He has the emperor's signet in a sealed jar of saltwater. He looks at it once a year. He has not opened the jar."
  - _Title:_ "Mastered: Empty Throne."
  - _Ascension mod:_ **Voll A11 — _The Crown He Earned_:** Gaoler's Word triggers automatically on the first boss appearance — but Voll loses 5 max HP for the run. Trades agency for guarantee.

### W8 — The Saint of Gallowsmoke · Coven × Ash-Mourners · Smoke synergy / swarm-control
- **Default — _Drift_:** Your Smoke tiles persist 1 extra turn and deal 1 dmg/turn to enemies inside.
  - **T2 Variant A — _Long Drift_:** Your Smoke tiles persist 2 extra turns; no damage tick. (Trades damage for area-denial duration.)
  - **T2 Variant B — _Black Drift_:** Your Smoke tiles do not persist longer, but apply Fear-1 to enemies on first entry. (Trades duration for psychological control.)
- **Default sig spell — _Veil of Gallowsmoke_** (3 mana): Fill the entire lane with Smoke for 1 turn; enemies inside gain Fear-1.
  - **T3 Alt-fire — _Pall Writ_** (3 mana): Place Smoke in all 3 lanes for 1 turn; enemies inside gain Fear-1. (Single-lane wide-AoE → cross-lane shallow-AoE. **Reassigned from Sieren** per M3 — better thematic fit, kept at same cost.)
- **T4 Mastery:**
  - _Skin:_ "The Canonised Lie" — halo darkened to full grey, censer chains lengthened to drag the floor and leave smoke-trails, the figure under the halo has no face at all beneath the smoke.
  - _Lore:_ "Her smoke knows the Court's secrets. It also knows their lies. She has not decided which to leak first."
  - _Title:_ "Mastered: Saint of Gallowsmoke."
  - _Ascension mod:_ **Saint A11 — _The Smoke Sees Both Sides_:** Smoke tiles damage friendly units as well as enemies. The saint cannot tell sides apart. Mid-board Smoke discipline becomes a real constraint.

### W9 — The Brass-Crowned Whelp · Skinward Pact × Iron Penitents · Summoner/Aggro
- **Default — _Crowned in Want_:** The first summon each wave costs 1 less and enters with Bleed.
  - **T2 Variant A — _Crowned in Anger_:** First summon each wave costs 1 less, enters with Bleed-2 (was Bleed-1), and Whelp loses 1 HP. (Doubles the Bleed; pays HP for it.)
  - **T2 Variant B — _Crowned in Sorrow_:** First summon each wave costs 2 less (deeper discount), enters without Bleed. (Pure cost-ramp, drops the self-harm clock.)
- **Default sig spell — _Wail_** (3 mana): Summon 3 Brass Hounds in a single tile; they rush forward, ignoring blockers for 1 turn.
  - **T3 Alt-fire — _Whimper_** (3 mana): Summon 1 Brass Hound in each lane; they don't rush, but each deals 2 dmg when they die from any source (delayed-explode payoff). (Concentrated-rush → distributed-suicide-bombers.)
- **T4 Mastery:**
  - _Skin:_ "The Bell-Worn King" — the brass crown swallows the head fully, only the mouth and chin visible beneath; the hounds wear matching small crowns; bare feet bound in brass wire.
  - _Lore:_ "He still cries when he summons them. The hounds were once boys he played with. The bell knew their names first."
  - _Title:_ "Mastered: Brass-Crowned Whelp."
  - _Ascension mod:_ **Whelp A11 — _Every Hound Bleeds_:** All Brass Hounds (Whelp's and any others' on-board) enter with Bleed-2. Faster swarm clears, faster losses, sharper read.

### W10 — The Last Confessor · Neutral / faction-flex · Wildcard
- **Default — _Hearsay_:** Your starting deck includes 2 cards from a random rival faction each run.
  - **T2 Variant A — _Loud Hearsay_:** Starting deck includes 4 cards from a random rival faction — but ONE of your starting Confessor cards is removed.
  - **T2 Variant B — _Quiet Hearsay_:** Starting deck includes 1 card from EACH of the other 4 factions (4 fixed-mix cards, replacing the single random lump).
- **Default sig spell — _Last Words_** (3 mana): Copy and re-cast the last spell used by any Warlord this run — including enemy bosses.
  - **T3 Alt-fire — _First Words_** (3 mana): Cast the FIRST spell played this run, regardless of who played it. Effects scale by current turn number — longer runs make the replay louder. (Last-played → first-played; immediate → growing-multiplier.)
- **T4 Mastery:**
  - _Skin:_ "The All-Heard" — the ear trumpet is now a halo of small mouths, the walking-stick of bound prayer scrolls whispers legibly when she moves, the blindfold is removed to reveal eyes painted shut beneath.
  - _Lore:_ "She remembers every Warlord's true name. None has guessed hers. None has tried."
  - _Title:_ "Mastered: Last Confessor."
  - _Ascension mod (campaign-tier per W1 Open Q4):_ **Confessor A-Campaign — _The Hearsay Runs Wild_:** Hearsay rolls a NEW random rival faction every wave (not run-locked). Added cards cannot be discarded by your own effects (they stick until played). Wildcard fantasy maxed out.

### W11 — The Saint That Should Not Hang · The Curse Itself · All-curse synergy (lore-locked)
- **Default — _The First Wrongful Death_:** Whenever Reanimation raises an enemy, they rise fighting FOR YOU instead.
  - **T2 Variant A — _The Silent Death_:** Reanimated enemies still flip to your side, but they arrive at 1 HP (instead of full). (Fragile salvage; you still get the body.)
  - **T2 Variant B — _The Loud Death_:** Reanimated enemies stay enemies, but on raising they trigger an immediate 2 dmg to the nearest enemy in that lane (you don't claim them; the curse just lashes out).
- **Default sig spell — _Speak the Name_** (5 mana): At the Hanging Hour, all units on the field stop for one turn. You play a free card.
  - **T3 Alt-fire — _Forget the Name_** (5 mana): At the Hanging Hour, NO unit stops, but all your units gain +1 ATK and Bleed-1 for that turn; the free card becomes a free *attack* instead. (Suspend-time → time-still-flows-but-you-strike.)
- **T4 Mastery:**
  - _Skin:_ "The Painted-Eyes Wake" — the eyes painted shut now have a second pair of eye-shapes painted on top of the eyelids in gold, the rope-mark at her throat is gold-painted stigmata, her bare feet trail a faint dragging line wherever she moves.
  - _Lore:_ "Speak her name three times in Gallowfell and the gallows-tree blossoms. Nobody has spoken it twice."
  - _Title:_ "Mastered: The Saint That Should Not Hang."
  - _Ascension mod (campaign-tier per W1 Open Q4):_ **Saint A-Campaign — _The Curse Re-Reads_:** Speak the Name's free turn applies only to enemies — your units act normally during it — but Wrongful-Death recoveries arrive at +2 ATK. The curse gets sharper; the trade is asymmetry.

---

## Anti-P2W audit (this doc vs W1 §6)

- ✅ Every T2 A/B pair is a sidegrade — each pays a real cost (HP / hand-size / draw / Smoke-duration / damage-tick / scope) for its gain. No variant is strictly better than Default.
- ✅ Every T3 alt-fire matches the default spell's mana cost. None increases damage outright; each rotates one design axis.
- ✅ Every T4 mastery is cosmetic + lore + a *harder* challenge slot. The Ascension mod adds difficulty; the reward for completing it is a prestige icon, never raw power.
- ✅ Glean (Sieren T3) and Pall Writ (Saint of Gallowsmoke T3) are existing-canon spells reassigned per M3 — no new content cost, no new balance unknowns.
- ✅ W10 + W11 use campaign-tier Ascension slots (per W1 Open Q4 lean) rather than standard A11. They remain harder-and-cosmetic, not stronger-and-paid.

## MVP-slice trim (per W1 Open Q6)

Internal MVP ships 3 free Warlords (Vyrrun / Sieren / Mhar per `internal_mvp_scope.md`). For IMV-1, recommended trim:
- **All three need full T1+T2** (Variant A + B authored — that's the system validation, since Tier 2 is where the "sidegrade-not-power" claim is tested).
- **T3 alt-fires authored but locked at IMV-1** (data lives in `.tres`; XP curve disabled past Tier 2 for IMV-1).
- **T4 mastery deferred** to IMV-2 — needs cosmetic-skin asset pipeline (B3.x) live first.

That's ~9 pieces of content to engine-wire (3 Warlords × 3 passive options) for IMV-1, instead of ~66 across all 11. Tight.

## Open questions for Paul

1. **Sieren T2 Variant A — _Sworn in Ink_ HP cost timing.** "Sieren takes 2 HP per raise" — does this stack if both raises happen in the same wave (2 + 2 = 4 HP)? Recommend yes; the cost should bite at scale. Confirm.
2. **Whelp T2 Variant A — Bleed-2 stack risk.** Crossed with Iron Penitent Bleed-stack archetype this could snowball past the C7 "Bleed-5 per-enemy cap" recommendation. Flag for C7-redux pass when balance work resumes; non-blocking for design lock.
3. **W10 + W11 campaign-tier slots.** Per W1 Open Q4 my lean was W10/W11 only get campaign-tier — but W6–W9 are paid hybrids with cross-faction fantasies, arguably also wildcard-shaped. Should hybrids ALSO get campaign-tier slots instead of A11? Recommend no (keep them on A11 — the hybrids are flashy-not-wild) but flag for your call.
4. **Vyrrun T3 _Bone-Pageant_ Persist override.** The alt-fire forces a Persist trigger regardless of base eligibility, which sidesteps the M1 once-per-combat lock. Two reads:
   - (a) Bone-Pageant grants Persist for the dying unit, then the unit Persists once normally (subject to has_persisted lock thereafter).
   - (b) Bone-Pageant is a parallel pathway — the unit returns regardless of has_persisted, and a *normal* future Persist trigger can still fire (one extra round-trip).
   Lean (a) for design hygiene. M4 Hanging Hour × Persist interaction already adds one bypass; layering another via Vyrrun risks loop. Confirm.
5. **Naming pass.** All variant-passive names ("Flagellant Rite," "Twelvebirth," "Old Bargain," etc.) are first-pass and grimdark-flavoured but unprotected. Flag any that don't earn their slot before W4 UI mock pulls them in.
6. **Tier-3 unlock UX hook.** When a Warlord hits T3 and the alt-fire unlocks, the player picks _per-run_ (default or alt-fire) at the Warlord-select screen. Should this be a togglable button on the same Warlord card, or a separate "spell variant" sub-screen? Cleaner UX vs. screen real-estate. Spec'd more fully in W4.
