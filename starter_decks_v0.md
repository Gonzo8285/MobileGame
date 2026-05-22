# Starter decks v0 — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory item DES-12. Per-Warlord 12-card starter deck for IMV-2 onward (IMV-1 uses random 12-card slice per `internal_mvp_scope.md`). Each starter pulls from its Warlord's faction primary pool + 1-2 cross-faction surprises._

**Status:** v0 spec. Pending Paul sign-off.

---

## 1. Design rules for starter decks

Each starter deck has exactly **12 cards**. Composition guideline:

- **8 cards from the Warlord's primary faction** (60-70% faction-coherence)
- **2 cards from the Warlord's secondary faction** (for hybrids) OR **2 strong general-purpose faction cards** (for mono-faction Warlords)
- **2 cards that telegraph the Warlord's signature playstyle** (e.g. Vyrrun starter has 2 bleed-stack cards even if from cross-faction pool)

**Cost curve target:**
- 4 cards at cost 1-2 (early-curve)
- 5 cards at cost 3-4 (mid-curve)
- 3 cards at cost 5+ (late-curve / power)

**Rarity target:** 8 Common, 3 Uncommon, 1 Rare. No Epic, no Legendary in starter (those are unlock-pathways).

**Anti-frustration rule:** every starter must include at least 1 SHIELD card and 1 ranged/removal card to handle round-1 enemies.

---

## 2. Per-Warlord starter decks

### 2.1 W1 — Penance-Captain Vyrrun (Iron Penitents — Aggro)

**Signature:** self-damage triggers + BLEED stacks. Aggressive curve, low HP wall.

| Slot | Card | Faction | Cost | Type | Rarity | Why |
|---|---|---|---|---|---|---|
| 1 | P1 Cathedral Brother | Iron Penitents | 1 | UNIT | C | Aggro 1-cost, MELEE+Cleave (Vyrrun sig unit) |
| 2 | P1 Cathedral Brother | Iron Penitents | 1 | UNIT | C | (×2 for early-game density) |
| 3 | P2 Self-Scourge | Iron Penitents | 2 | SPELL | C | Vyrrun-style: self-damage for ATK buff |
| 4 | P3 Crowned Martyr | Iron Penitents | 2 | UNIT | C | High ATK, low HP, on-death heals adjacent |
| 5 | P4 Bleeding Vigil | Iron Penitents | 3 | UNIT | U | BLEED-on-attack, mid-tier body |
| 6 | P5 Hammer of Naming | Iron Penitents | 3 | SPELL | C | 2 damage + BLEED-1 |
| 7 | P12 Self-Scourge upgraded | Iron Penitents | 3 | SPELL | C | (placeholder until P12 confirmed) Stronger self-damage |
| 8 | P20 Penitent Charger | Iron Penitents | 4 | UNIT | C | Mid-cost MELEE, BLEED on summon |
| 9 | P25 Crown of Nails | Iron Penitents | 4 | RELIC | U | Persistent BLEED-stack support |
| 10 | M11 Pall-Bearer | Ash-Mourners | 3 | UNIT | C | Cross-faction: high-HP body with on-death Smoke (defensive flex) |
| 11 | L5 Iron Sergeant | The Last Legion | 4 | UNIT | C | Cross-faction: SHIELD-providing body |
| 12 | P32 Last Pilgrim | Iron Penitents | 5 | UNIT | R | Late-game payoff — high ATK, scales on BLEED stacks dealt |

**Curve:** 1/1/2/2/3/3/3/4/4/3/4/5 — slightly aggro-tilted. Average cost = ~3.0.

### 2.2 W2 — Court-Necromant Sieren (Ash-Mourners — Control)

**Signature:** PERSIST + Reanimation. Slow grind, attrition wins.

| Slot | Card | Faction | Cost | Type | Rarity | Why |
|---|---|---|---|---|---|---|
| 1 | M1 Mourner-Wraith | Ash-Mourners | 1 | UNIT | C | 1-cost low-HP body with PERSIST baseline |
| 2 | M1 Mourner-Wraith | Ash-Mourners | 1 | UNIT | C | (×2) |
| 3 | M5 Last Censer-Bearer | Ash-Mourners | 2 | UNIT | C | PERSIST + Smoke-on-death |
| 4 | M10 Funeral Writ | Ash-Mourners | 3 | SPELL | C | Lane ROOT-2 + 1 DoT/turn |
| 5 | M11 Pall-Bearer | Ash-Mourners | 3 | UNIT | C | Mid-cost body, on-death Smoke |
| 6 | M15 Raven of Names | Ash-Mourners | 3 | UNIT | U | Draw a card on death |
| 7 | M22 Hollow Mortician | Ash-Mourners | 4 | UNIT | C | PERSIST + bonus ATK from each death this combat |
| 8 | M24 Choir of the Long Dead | Ash-Mourners | 4 | SPELL | U | AoE Smoke + FEAR application |
| 9 | M5 Last Censer-Bearer | Ash-Mourners | 2 | UNIT | C | (×2 for PERSIST density) |
| 10 | P3 Crowned Martyr | Iron Penitents | 2 | UNIT | C | Cross-faction: low-cost body with on-death heal |
| 11 | C8 Bog Reed-Witch | Coven | 4 | UNIT | C | Cross-faction: POISON-on-attack, ranged |
| 12 | M40 Court Witness | Ash-Mourners | 5 | UNIT | R | Late-game payoff — at HH, all friendly PERSIST units return at +1 ATK |

**Curve:** 1/1/2/3/3/3/4/4/2/2/4/5 — control-leaning. Average cost = ~3.0.

### 2.3 W3 — Marsh-Mother Eddra (Coven — Swarm)

**Signature:** swarm tokens + POISON. Wide board, tempo through density.

| Slot | Card | Faction | Cost | Type | Rarity | Why |
|---|---|---|---|---|---|---|
| 1 | C1 Bog-Spawn (drafted version) | Coven | 0 | UNIT | C | Eddra-style: 0-cost token-style unit (note: as token TKN-1 it's not draftable; this is the C1 draftable variant) |
| 2 | C1 Bog-Spawn | Coven | 0 | UNIT | C | (×2) |
| 3 | C2 Bog-Witch | Coven | 1 | UNIT | C | Cheap caster, POISON-on-attack |
| 4 | C5 Hex of Many | Coven | 3 | SPELL | C | Replace enemy with 3 Bog-Spawn tokens |
| 5 | C8 Bog Reed-Witch | Coven | 4 | UNIT | C | POISON-on-attack ranged body |
| 6 | C10 Three-Shadows Cast | Coven | 2 | SPELL | C | Apply POISON-2 to enemy lane |
| 7 | C15 Mire-Bound Pact | Coven | 3 | TRAP | U | Enemies entering tile take POISON-2 |
| 8 | C20 Witch of the Hoofprint | Coven | 4 | UNIT | U | Summons Familiar on cast; if 3+ Coven units, +1 ATK |
| 9 | C25 Toad-Stitched | Coven | 4 | UNIT | C | Mid-cost body, on-death summon 2 Bog-Spawn |
| 10 | M11 Pall-Bearer | Ash-Mourners | 3 | UNIT | C | Cross-faction: tanky body for hold |
| 11 | P5 Hammer of Naming | Iron Penitents | 3 | SPELL | C | Cross-faction: 2 damage + BLEED — removal flex |
| 12 | C40 Mother of Many Tongues | Coven | 5 | UNIT | R | Late-game swarm payoff: every friendly token death = +1 ATK to all Coven units |

**Curve:** 0/0/1/3/4/2/3/4/4/3/3/5 — swarm-tilted, early flooding. Average cost = ~2.7.

### 2.4 W4 — Forge-Marshal Veska (The Last Legion — Tempo)

**Signature:** RALLY adjacency + ECHO + draw engine. Linear pressure.

| Slot | Card | Faction | Cost | Type | Rarity | Why |
|---|---|---|---|---|---|---|
| 1 | L1 Forge-Cur | The Last Legion | 1 | UNIT | C | Cheap MELEE body |
| 2 | L1 Forge-Cur | The Last Legion | 1 | UNIT | C | (×2) |
| 3 | L3 Iron Recruit | The Last Legion | 2 | UNIT | C | 2-cost RALLY user |
| 4 | L5 Iron Sergeant | The Last Legion | 2 | UNIT | C | SHIELD-1 + RALLY |
| 5 | L7 Sergeant-Smith Vikar | The Last Legion | 4 | UNIT | R | Sig unit per `warlords_v1.md`: row +1 ATK + SHIELD-1 |
| 6 | L10 Forge-Heat Echo | The Last Legion | 2 | SPELL | C | Pop-up ECHO buff |
| 7 | L13 Iron Cohort | The Last Legion | 3 | SPELL | C | All Legion shift +1 tile forward + ATK buff |
| 8 | L18 Echo-Sergeant | The Last Legion | 3 | UNIT | U | ECHO-keyword body |
| 9 | L22 Drill-Sergeant | The Last Legion | 4 | UNIT | C | On-summon draw if 2+ Legion |
| 10 | L28 Banner-Lieutenant | The Last Legion | 4 | UNIT | U | Banner-Token spawner |
| 11 | P3 Crowned Martyr | Iron Penitents | 2 | UNIT | C | Cross-faction: cheap removal flex |
| 12 | L33 Banner-Captain | The Last Legion | 5 | UNIT | R | Late-game payoff: every Banner-Token = +1 ATK Legion units |

**Curve:** 1/1/2/2/4/2/3/3/4/4/2/5 — tempo-leaning. Average cost = ~3.0.

### 2.5 W5 — Tree-Walker Mhar (Skinward Pact — Summoner)

**Signature:** summons + transformation chains.

| Slot | Card | Faction | Cost | Type | Rarity | Why |
|---|---|---|---|---|---|---|
| 1 | W1 Cinder-Pup | Skinward Pact | 1 | UNIT | C | Cheap summon |
| 2 | W1 Cinder-Pup | Skinward Pact | 1 | UNIT | C | (×2) |
| 3 | W5 Wild-Caller | Skinward Pact | 2 | UNIT | C | Summon body |
| 4 | W10 Cinder-Wolf | Skinward Pact | 4 | UNIT | C | Mhar sig unit per `warlords_v1.md`: big body, RESURRECT once |
| 5 | W12 Don the Pelt | Skinward Pact | 3 | SPELL | C | Mhar sig spell: sacrifice→bigger copy |
| 6 | W14 Antler-Crown | Skinward Pact | 2 | SPELL | C | +1/+1 to all your summons |
| 7 | W19 Wyrd-Shifter | Skinward Pact | 3 | UNIT | R | Transformation flex |
| 8 | W22 Bone-Flute Druid | Skinward Pact | 3 | UNIT | U | On-summon: draw 1 if any summon died this turn |
| 9 | W28 Wolf-Token spawner | Skinward Pact | 4 | UNIT | C | Summons Wolf-Tokens (per existing W28) |
| 10 | M11 Pall-Bearer | Ash-Mourners | 3 | UNIT | C | Cross-faction: tanky body with on-death Smoke |
| 11 | C8 Bog Reed-Witch | Coven | 4 | UNIT | C | Cross-faction: ranged POISON applier |
| 12 | W33 God-Tree Heir | Skinward Pact | 5 | UNIT | R | Late-game payoff: per-summon-death cost reduction stacks |

**Curve:** 1/1/2/4/3/2/3/3/4/3/4/5 — summoner with mid-curve density. Average cost = ~3.1.

### 2.6 W6-W10 (paid Warlords)

Same 12-card structure. Following template, NOT full per-Warlord detail (each is ~5 min to populate from `warlord_tiers_full.md` once final card pool is locked):

| Warlord | Primary faction | Cross faction | Sig style | 12-card structure |
|---|---|---|---|---|
| W6 Vow-Broken Magus | Iron Penitents × Ash-Mourners | both 50/50 | Hybrid Aggro/Control | 6 IP + 6 AM, BLEED+PERSIST chain |
| W7 Warden Caspar Voll | The Last Legion | none | Tempo (boss-control) | 9 LL + 3 generic, SLOW/FREEZE pieces |
| W8 Saint of Gallowsmoke | Coven × Ash-Mourners | both 50/50 | Smoke swarm-control | 5 COV + 5 AM + 2 token, SMOKE density |
| W9 Brass-Crowned Whelp | Skinward Pact × Iron Penitents | 7 SP / 3 IP / 2 token | Summoner/Aggro | Lots of summon + Brass Hound tokens |
| W10 Last Confessor | Neutral / faction-flex | 4-6 from random rival faction (per passive) | Wildcard | 6 neutral + 6 random (re-rolls per run per passive _Hearsay_) |

**W11 Saint That Should Not Hang:** per `warlords_v1.md` §11, her deck is curated 12 from the entire pool, not faction-locked. **Special composition for IMV-2 polish:** mix of 2 cards from each of the 5 factions + 2 neutral relic-utility cards = 12. Author when W11 is unlock-ready.

---

## 3. Engine handoff

### 3.1 Resource class

`game/src/data/starter_deck.gd`:
```
class_name StarterDeck extends Resource

@export var warlord_id: StringName
@export var card_ids: Array[StringName]  # 12 entries
@export var notes: String  # design notes for tuning
```

### 3.2 Per-Warlord `.tres` files to author

`game/data/starter_decks/`:
```
- vyrrun.tres
- sieren.tres
- eddra.tres
- veska.tres
- mhar.tres
- vow_broken_magus.tres
- caspar_voll.tres
- saint_of_gallowsmoke.tres
- brass_crowned_whelp.tres
- last_confessor.tres
- saint_that_should_not_hang.tres
```

11 starter deck files total.

### 3.3 Run-start integration

```
# game_state.gd
func start_run(warlord_id: StringName) -> void:
    var warlord = WarlordRegistry.find(warlord_id)
    var starter = load("res://game/data/starter_decks/" + str(warlord_id).to_lower() + ".tres")
    deck.clear()
    for card_id in starter.card_ids:
        var card = CardRegistry.find(card_id)
        deck.add_to_bottom(card)
    deck.shuffle()
    # ... rest of run-init
```

### 3.4 IMV-1 fallback

Per `internal_mvp_scope.md`: IMV-1 uses random 12-card draw from 3-faction pool (no warlord-locked starter). Engine path:

```
if Settings.imv1_random_starter:
    deck = RandomStarterGenerator.build(in_scope_factions)
else:
    deck = StarterDeck.load_for_warlord(warlord_id)
```

---

## 4. Tuning notes

### 4.1 Vyrrun starter — known weak vs HORDE rounds 5/7

Per balance doc, rounds 5 and 7 are HORDE-stat. Vyrrun's aggro starter has limited AoE. Recommend:
- If HORDE win-rate is below 50%, add P12 Self-Scourge (AoE if upgraded) earlier OR swap M11 → C5 Hex of Many.

### 4.2 Mhar starter — slow first 3 turns

Summoner ramp is naturally slow. Recommend:
- If turn-1 board feels empty, swap W5 Wild-Caller → C1 Bog-Spawn (0-cost flex).

### 4.3 Veska starter — RALLY rules need 2 Host units adjacent

Adjacency requires careful placement. Recommend:
- If players struggle, swap to L3 + L5 (both with cheap RALLY-readiness).

### 4.4 Sieren starter — PERSIST density

PERSIST is the core mechanic. Recommend at minimum 4 PERSIST-tagged cards in the starter (currently 4: 2× M1, 2× M5). Confirmed correct density.

### 4.5 Eddra starter — token swarm vs HORDE clash

Eddra and HORDE rounds both flood the board. Mana race becomes the dynamic. Watch the round 5 win-rate carefully.

---

## 5. MVP coverage

| Surface | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| Random 12-card starter | ✅ | ✅ (toggle) | ✅ (toggle) | — | — |
| Warlord-locked starters (W1-W5 free) | — | ✅ | ✅ | ✅ | ✅ |
| W6-W10 paid Warlord starters | — | — | ✅ (when paid unlocks land) | ✅ | ✅ |
| W11 secret-Warlord starter | — | — | — | ✅ (with unlock) | ✅ |

---

## 6. Open questions for Paul

1. **Card pool gaps.** Several cards referenced above (P12 upgraded variant, P20 Penitent Charger, P25 Crown of Nails, P32 Last Pilgrim, M22 Hollow Mortician, M40 Court Witness, L13 Iron Cohort, L18 Echo-Sergeant, L22 Drill-Sergeant, L28 Banner-Lieutenant, L33 Banner-Captain, W14 Antler-Crown, W19 Wyrd-Shifter, W22 Bone-Flute Druid, W28 Wolf-Token spawner) need verification against actual `cards_*_v1.md` content. May need substitution if names don't match the canonical list. Confirm I have authoring permission to substitute on-the-fly.
2. **W6-W10 starter authoring depth.** Recommend full per-Warlord author pass at IMV-2 polish — IMV-2 ships W1-W5 starters only and W6-W10 use a generic "your faction primary + cross flex" auto-generator until polish.
3. **Starter card-instance state.** Are starter cards CardInstance-level (each with their own upgrade counter, mastery counter) or shared per-deck-per-run? Recommend per-deck-per-run instances (each run gets fresh CardInstances).

---

## 7. Cross-references

- `warlords_v1.md` — Warlord-by-Warlord signature design.
- `cards_*_v1.md` — full card pool source (must verify card IDs match).
- `internal_mvp_scope.md` — IMV-1 random-starter rule.
- `2026-05-18_gallowfell_balance.md` — round-by-round difficulty curve drives starter tuning.
- `tokens_v0.md` — explains C1-as-token-but-draftable-variant distinction.

— Controller, 2026-05-21
