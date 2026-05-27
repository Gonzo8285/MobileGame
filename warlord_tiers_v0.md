# W1 — Warlord tier system v0

_Authored 2026-05-02 14:17 UTC by heartbeat. Phase 2.7 design doc. Designs how Warlords gain XP, how tiers unlock sideways power, and what content slots into each tier band. Anti-P2W constraint: tiers NEVER unlock raw stat increases. Per-Warlord tier content (Tier 2 variants, Tier 3 alt-fires, Tier 4 mastery) is W2's job. Engine wiring is W5's job. XP-booster economy reflection in `monetisation_map.md` is W3's job._

## 1. Design intent

Tiers exist so that **mastery feels visible** without selling power. A new player and a Tier-4 player have the same numerical kit. The Tier-4 player has more **shapes** to choose from — different passives, different ult patterns, deeper customisation per run. Mastery is recognised through cosmetics, lore reveals, and access to harder self-imposed challenges, not through bigger numbers.

Reference points: Hades (Heat + cosmetic mastery), Slay the Spire (Ascension adds modifiers, never raw power), Vampire Survivors (achievement unlocks are sidegrades), Marvel Snap (card variants are pure cosmetic), Hearthstone (hero portrait variants). Explicitly NOT the Clash Royale / Diablo Immortal model where time + spend = stronger account.

## 2. XP economy

### 2.1 How XP is earned
- **Wins-with-this-Warlord only.** Losses give 0 by default (see Open Q1). Encourages stickiness without grindy farming.
- Base XP per run-victory = **100 XP**.
- Run-quality scaling (multipliers stack additively):
  - Final boss killed: ×1.5
  - Ascension N modifier: +10% per A-level, capped ×2.0 at A10
- One standard A0 win ≈ **150 XP**. One A5 win ≈ **225 XP**. One A10 win ≈ **300 XP**.

### 2.2 Tier thresholds

| Tier | Cumulative XP | Wins-from-zero (A0) | Wins (A5) | Hits target band? |
|---|---|---|---|---|
| 1 → 2 | 1,800 | ~12 | ~8 | ✅ 10–15 |
| 2 → 3 | 4,800 | ~32 | ~22 | ✅ ~30 |
| 3 → 4 | 10,800 | ~72 | ~48 | ✅ 60–80 |

Increment-per-tier: 1,800 → 3,000 → 6,000. Gentle gradient that rewards repeat play without making T4 feel impossible.

### 2.3 XP boosters (anti-P2W speed lever)
Boosters **multiply** earned XP. They never grant flat XP and never instant-tier.
- Battle Pass premium track: +25% XP for-life-of-season. Free track unlocks +10% past level 25.
- Daily quest "Win with Warlord X": one-shot ×1.5 multiplier on next win.
- Starter bundle: 7-day +50% XP booster.
- Live-ops weekend events: ×2.0 XP, all Warlords, hard-capped at 5 boosted wins per event.
- Cosmetic-skin equipped on Warlord: flat +5% XP for that Warlord (small mastery flex, not P2W).

Boosters stack **multiplicatively** but the total multiplier hard-caps at **×3.0**. A whale who buys every booster and grinds an event weekend hits Tier 4 in ~25 wins instead of ~72. Still a meaningful play time. Never a checkout.

## 3. Tier unlock content

### 3.1 Tier 1 (default, no XP needed)
- Base passive (per `warlords_v1.md`)
- Base signature unit (deck-included)
- Base signature spell (deck-included)
- Default cosmetic / portrait

### 3.2 Tier 2 — Variant Passive (choose 1 per run; default stays available)
At Tier 2 the player **unlocks BOTH** variant passives. Per-run loadout is `Default OR Variant A OR Variant B`. Swappable from the Warlord-select screen at zero cost; never mid-run.

Design rule (the litmus test):
> A Tier-1 player borrowing a Tier-2 account must not feel like they have *less* of a kit. Just *fewer choices*.

**Per-Warlord template (fill in W2):**
- _Variant A_ — twists the passive toward an aggressive playstyle (typically: more damage, more cost — extra self-damage, hand-size loss, mana premium).
- _Variant B_ — twists toward defensive / utility (armor, draw, status cleanse, keyword conversion).

Worked example — **Vyrrun, Iron Penitents:**
- _Default — Mortify:_ Lose 2 HP at start of wave; your units +1 ATK that wave.
- _Variant A — Flagellant Rite:_ Lose 4 HP at start of wave; your units +2 ATK and **Bleed-1** that wave.
- _Variant B — Ash-Vow:_ Don't lose HP; your units gain +1 armor that wave (no ATK buff).

A and B are spreadsheet-balanced in expected value across a 20-wave run. They play differently. Neither is strictly stronger.

### 3.3 Tier 3 — Signature Alt-Fire (choose 1 per run)
Each Warlord's signature spell gets an alt-fire at Tier 3. **Same mana cost. Same cooldown band. Opposite-axis effect.**

**Per-Warlord template (fill in W2):**
- _Default sig spell_ — as authored in `warlords_v1.md`.
- _Alt-fire_ — same cost; effect rotated on one axis: damage → heal, single-target → AoE, immediate → delayed-trap, offence → debuff.

Worked example — **Sieren, Ash-Mourners:**
- _Default — Funeral Writ:_ Root all enemies in target lane for 2 turns; 1 dmg/turn rooted.
- _Alt-fire — Pall Writ:_ Place Smoke in all 3 lanes for 1 turn; enemies inside gain Fear-1.

The player picks before the run starts. Alt-fire is **never simply better** — it covers a different matchup.

### 3.4 Tier 4 — Mastery Reward (one-shot per Warlord)
Triggered once on hitting T4. Four-part payoff:

1. **Mastery skin** — new portrait + summon VFX recolour. Free with tier. Never a stat change.
2. **Lore reveal** — one written line of in-fiction backstory, surfaced on the Warlord-select screen. Optional voice-line recording slot for post-launch.
3. **Mastery title** — display-only profile/leaderboard badge ("Mastered: Penance-Captain").
4. **Ascension modifier slot** — unlocks **one additional Ascension challenge slot** specific to that Warlord (e.g. "Vyrrun A11 — All friendly Bleed costs +1 mana"). The challenge is harder; the reward is a *cosmetic* prestige icon. Inside the anti-P2W bound.

**Per-Warlord template (fill in W2):**
- Mastery skin name + 1-line visual cue
- Lore reveal one-liner (≤30 words)
- Mastery title string
- Ascension modifier (1 line of mechanical text)

## 4. UX / display rules

- Warlord-select screen shows tier ladder (1 → 4) with XP bar to next tier. _Spec'd in W4._
- Tier-up triggers a modal, not a forced cutscene. Skippable. But the new unlocks (A/B passive choice at T2; alt-fire pick at T3; mastery payoff at T4) are surfaced immediately so the player understands what they got.
- Tier badges visible on social / share screens. Cosmetic flex, not power flex.
- The Last Confessor (W10) and The Saint That Should Not Hang (W11) follow the same four-tier template; their alt-fires lean into wildcard / curse-bound fantasies. W2 specifies.

## 5. Engine handoff (for W5)

Data shape on `Warlord` Resource:
```gdscript
@export var tier_unlocks: Array[Resource]  # 4 entries indexed 1..4
# Per entry (TierContent Resource):
#   tier: int
#   variant_passives: Array[Passive]   # len 0 (T1), 2 (T2), unchanged after
#   alt_fire_spell: Card                # null for T1/T2; populated at T3
#   mastery_skin_id: StringName
#   mastery_lore_string: String
#   mastery_title: StringName
#   ascension_mod_id: StringName
```

`GameState` autoload additions:
- `warlord_xp: Dictionary[StringName, int]` — keyed by warlord_id
- `active_xp_multiplier: float` — current stacked-and-capped booster value
- `signal warlord_tier_changed(warlord_id, new_tier)`
- `signal warlord_xp_gained(warlord_id, amount, multiplier_applied)`

`run_won` callback writes XP into the dictionary, applies the active multiplier (clamped to 3.0), checks thresholds, emits the signal.

## 6. Anti-pay-to-win audit

- ✅ No tier ever grants flat ATK / HP / mana / draw count.
- ✅ Both Tier-2 variants are **sidegrades** — spreadsheet-balanced expected value.
- ✅ Tier-3 alt-fire is _shape_, not _power_ — same cost, same cooldown, different effect axis.
- ✅ Tier-4 mastery is cosmetic + lore + a *harder* challenge slot. The Ascension mod makes the game harder for a *cosmetic* reward.
- ✅ XP boosters **multiply** earned XP only. They cannot be bought as flat-XP grants. Cap ×3.0 enforced server-side.
- ✅ Wins-only XP — no XP from microtransactions, no XP from defeats. Mastery is earned in play.
- ✅ Whale ceiling: ~25 wins per Warlord to T4. Free floor: ~72. Same destination, different speed.

## 7. Open questions for Paul

1. **XP-on-loss?** Currently 0. Some games (Slay the Spire) give partial. Worth a small grant (5 XP per Act cleared even on a loss) to soften the new-player grind, or keep wins-only for clarity?
2. **Booster cap at ×3.0** — feels right anti-P2W but could throttle event weekends. Allow ×4.0 ceiling _for live-ops events only_?
3. **Tier-2 default passive availability** — currently the default stays selectable forever. Should Tier 2 *replace* the default, forcing A-or-B? Cleaner UX vs more freedom — slight lean to keep default available.
4. **W10 / W11 Tier-4 Ascension slots** — these Warlords are wildcard / lore-locked. Their A-slots should probably be *campaign-tier* difficulty, not standard A11. Confirm before W2.
5. **XP multiplier display** — show as `+150% XP` boost or as `×2.5 XP`? Industry split; pick one for consistency before W4 UI work.
6. **MVP-slice tiers?** Internal MVP ships 3 Warlords (Vyrrun, Sieren, Mhar). Do those three need full T1–T4 content for the internal build, or is T1+T2 enough to validate the system before W2 authors all 11?
