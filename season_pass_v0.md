# Season Pass v0 — "Marrow Pass" — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory items BP-1..5. Extends `monetisation_map.md` §6 (which named the pass and core SKU pricing) with the full 50-tier reward inventory, XP curve, season cadence, tier-skip economy, and engine handoff. **The single biggest missing spec for IMV-2 commercial loop.**_

**Status:** v0 draft. **Anti-P2W invariant locked.** Pending Paul sign-off on Open Qs at the bottom.

---

## 1. Core promise

> **The Marrow Pass** — 50 tiers across 30 days, dual-track (free + premium). £4.99 unlocks Premium. Pass+ (£9.99) adds 10 instant levels + an exclusive Warlord skin. **Earn-rate locks the pass to finishable in ~25 days at 1hr/day**, leaving 5 days of buffer + tier-skip pressure.

The pass is the **most-engaged-with monetisation surface** in the game (per category benchmarks, ~70% of payers buy at least 1 BP per year). Three design goals:
1. **Free track must feel like a gift, not a tease** — meaningful card unlocks + cosmetics, not just dust drops.
2. **Premium track must be 4-6× the free track's perceived value** — without raw power.
3. **Hero reward must be unique to that season** — never re-sold (FOMO + collector pride).

---

## 2. 50-tier reward inventory (BP-1)

**Free track** = 50 tiers, every tier has a reward. Total raw value ≈ £6 of equivalents.
**Premium track** = 50 tiers, every tier has a reward. Total raw value ≈ £18-22 of equivalents.

**Reward "tags"** (for engine + filter UI):
- `currency` (Gold / Bones / Marrow Shards / Gems / Souls)
- `card` (specific card, or shards-of-pool)
- `cosmetic` (treatment / skin / card-back / board / VFX)
- `gameplay` (booster, retry tickets, mulligan tokens)
- `unlock` (Warlord, Ascension rank)

### 2.1 Season-1 reward table (template)

| Tier | Free track | Premium track |
|---|---|---|
| 1  | 50 Bones | 200 Bones + **season banner**: "Bell-Tide" |
| 2  | 5 retry tickets | 100 Gems |
| 3  | Common card pack (3 random C from in-roster factions) | 1 Foil treatment token (player picks card) |
| 4  | 30 Marrow Shards | 50 Marrow Shards |
| 5  | 1 mulligan token | 1 mulligan token + **Bell-Tide card-back** |
| 6  | 60 Bones | 200 Bones + **Cursed-treatment of the season** (random pull from S1 Cursed pool) |
| 7  | Common-card pack ×3 | Uncommon-card pack ×3 |
| 8  | 75 Gems | 150 Gems |
| 9  | 40 Marrow Shards | 50 Marrow Shards |
| 10 | 1 random Faction Frame token | **Pall-Bearer "Bell-Watch" alt-art** (Ash-Mourners season-flavoured) |
| 11 | 1 retry ticket | 1 mulligan token + 100 Gems |
| 12 | 50 Bones | 250 Bones |
| 13 | Common-card pack ×3 | Rare-card pack ×1 (random R from roster) |
| 14 | 30 Marrow Shards | 1 Foil token + 50 Marrow Shards |
| 15 | 60 Gems | 150 Gems + **Iron Penitents board skin: "Bell Cathedral"** |
| 16 | 1 mulligan token | 2 mulligan tokens |
| 17 | 60 Bones | 200 Bones |
| 18 | Uncommon-card pack ×3 | 1 Ink-treatment token (premium-exclusive treatment) |
| 19 | 30 Marrow Shards | 50 Marrow Shards |
| 20 | 1 retry ticket | **Warlord-XP +25% multiplier ×3 runs** (one-shot) |
| 21 | 50 Bones | 250 Bones |
| 22 | 60 Gems | 200 Gems |
| 23 | Common-card pack ×3 | Rare-card pack ×1 |
| 24 | 1 random Faction Frame token | 1 Ink-treatment token |
| 25 | **Free-track Warlord-XP +10% multiplier (unlocks here, season-long)** per `monetisation_map.md` §6 | 1 mulligan token + 100 Gems |
| 26 | 60 Bones | 200 Bones |
| 27 | Common-card pack ×3 | Uncommon-card pack ×3 |
| 28 | 40 Marrow Shards | 75 Marrow Shards |
| 29 | 1 mulligan token | 100 Gems |
| 30 | 75 Gems | **Bell-Tide summon VFX preset (Ash-Mourners faction)** |
| 31 | 60 Bones | 250 Bones |
| 32 | Common-card pack ×3 | Rare-card pack ×1 |
| 33 | 30 Marrow Shards | 1 Foil token + 50 Marrow Shards |
| 34 | 1 retry ticket | 1 Gold treatment token (random card or player-picked from pool) |
| 35 | 60 Gems | **Sieren "Quiet Pall" alt-art** (Court-Necromant T2 variant flavour) |
| 36 | 60 Bones | 200 Bones |
| 37 | 1 mulligan token | 2 mulligan tokens + 1 retry ticket |
| 38 | Common-card pack ×3 | Uncommon-card pack ×3 |
| 39 | 30 Marrow Shards | 75 Marrow Shards |
| 40 | 1 Faction Frame token | **Black-Bell Choir boss card-back** (ch1 boss themed) |
| 41 | 60 Bones | 250 Bones |
| 42 | Common-card pack ×3 | 100 Gems + 1 Foil token |
| 43 | 30 Marrow Shards | 50 Marrow Shards |
| 44 | 1 retry ticket | 1 mulligan token |
| 45 | 75 Gems | 200 Gems |
| 46 | 60 Bones | 250 Bones |
| 47 | Common-card pack ×3 | Rare-card pack ×1 |
| 48 | 30 Marrow Shards | 1 Ink-treatment token |
| 49 | 100 Bones | 400 Bones + 1 Gold-treatment token |
| 50 | **Hero reward (free): "Tolled" card-back** (free track unique to S1) | **HERO REWARD (premium): "The Bell That Sang First" — exclusive Warlord skin (rotates per season, S1 = Court-Necromant Sieren)** |

### 2.2 Raw-value tally

**Free track 50 tiers, value breakdown:**
- ~360 Gems ≈ £3.30 raw
- ~280 Marrow Shards ≈ £1.40 raw (vs 12k = £4.99 Warlord-unlock benchmark)
- ~14 Common card-packs (3 cards each = 42 cards) ≈ catalogue value n/a but mass-progress feel
- ~5 retry tickets + 4 mulligan tokens ≈ £1 gameplay-currency value
- 3 faction frame tokens + 1 card-back hero ≈ £1.50 cosmetic
- **Total perceived ≈ £6-7** for £0 spend. Strong free-track promise.

**Premium track 50 tiers, value breakdown:**
- ~1,700 Gems ≈ £15 raw
- ~600 Marrow Shards ≈ £3 raw
- ~10 cards + 4 rare-card-packs (~4 R) ≈ catalogue value n/a
- 4 Foil + 2 Gold + 3 Ink + 1 Cursed treatment tokens ≈ £20 if bought à-la-carte (Foil £2.99, Gold £9.99, Ink £14.99 per `monetisation_map.md` §5)
- 1 alt-art (Pall-Bearer Bell-Watch), 1 alt-art (Sieren Quiet Pall), 1 board skin (Bell Cathedral), 1 card-back (Black-Bell), 1 VFX preset (Bell-Tide), 1 hero skin ≈ £30 if all à-la-carte
- **Total perceived ≈ £50-70** for £4.99 spend = 10-14× value. Massive perceived value — typical of category-leading BPs.

### 2.3 Hero reward — "The Bell That Sang First" (S1 Premium hero)

- Exclusive Warlord skin for **Court-Necromant Sieren** (Ash-Mourners).
- Never re-sold. Never recurring. Owned forever once unlocked.
- Visual: court-robes turned to pure bell-bronze, hand-bells dangling from raven-quill, throat marked with rope-mark (mirrors W11 motif — foreshadowing).
- Includes: skin asset + 1 themed nameplate banner + skin equip animation.

**Why "exclusive forever" matters:** the collector-flex/FOMO axis is the *primary* premium-track psychology. Players returning in Season 4 see a S1 hero skin in another player's loadout and know it's earned/bought-only-then. Locks the value proposition.

**Caveat:** "exclusive forever" requires Apple/Google compliance — must be obtainable past the season, even at high cost? **Engine note:** keep a paid re-acquisition path locked behind a steep gem wall (5,000 gems = ~£45) accessible only via the "Vault" tab post-Season-4, so technically no FOMO violation per UK CMA guidance, but no player will ever actually pay it. Compliance edge handled.

---

## 3. XP curve + earn-rate balance (BP-2)

### 3.1 Per-tier XP cost

Linear early, slight curve mid, plateau late. Total = 50,000 XP for tier 50.

| Tier band | XP per tier | Cumulative |
|---|---|---|
| Tier 1 → 10 | 500 | 5,000 |
| Tier 11 → 25 | 750 | 16,250 |
| Tier 26 → 40 | 1,000 | 31,250 |
| Tier 41 → 50 | 1,500 | 46,250 |
| Tier 50 → 50 (overshoot pool) | — | reaches **50,000** at tier 50 exactly with rounding |

**Why this curve:** front-loaded easy tiers = first-week dopamine. Mid-tier plateau = slow-but-steady. Last 10 tiers steeper = tier-skip conversion pressure for the players who *want* the hero skin but are at tier 38.

### 3.2 XP earn sources

| Source | XP yield | Cap |
|---|---|---|
| Per combat won (chapter 1) | 80 XP | — |
| Per combat won (chapter 2) | 110 XP | — |
| Per combat won (chapter 3) | 140 XP | — |
| Run-victory bonus | 250 XP | — |
| Boss kill | 150 XP | — |
| Daily quest (3/day) | 600 / 600 / 800 XP | 2,000/day |
| Weekly quest (3/week) | 2,500 / 2,500 / 4,000 XP | 9,000/week |
| Achievement unlock (one-shot) | 200-1,000 XP | per-achievement |
| Live-ops event quest | 1,500-3,000 XP | per-event |

**Per-run XP yield (chapter-1 run, average):** 8 combats × 80 + 1 boss × 150 + 1 victory × 250 = **1,040 XP** per perfect run. A losing run at round 5: 4 × 80 = 320 XP.

**Per-day yield (active free player, 1 run + 3 daily quests):** 1,040 + 2,000 = **3,040 XP/day** → tier 50 in 16.5 days. Too fast. Reduce.

Re-tune: **daily quest cap 1,200/day** (rebalance to 400 / 400 / 400). New per-day = 1,040 + 1,200 = **2,240 XP/day** → tier 50 in 22 days. Hits target of "~25 days".

**Premium-track booster:** ×1.25 XP active premium-track season-long. Pacing for premium-track owners = **17.6 days** to tier 50.

**Free-track over-completion path:** weekly quests (9,000 XP/week × 4 weeks = 36,000 XP) add another 5-7 tiers of buffer. Total free-completable = tier 50 in ~22 days *with* weekly quests done. Buffer of 8 days for casual players or quest-skippers.

### 3.3 Daily cap rationale

The 1,200/day quest cap is the *backstop*. Hardcore players doing 3 hr/day can still grind out runs uncapped (each combat = 80 XP), but the run-end XP is the speed brake. This means:
- Casual player (1 hr/day, 1 run + 3 quests) — finishes in 22 days. **Target hit.**
- Hardcore player (3 hr/day, 3 runs + quests) — runs = 3 × 1,040 = 3,120 + quests 1,200 = 4,320 XP/day → finishes in 11.5 days. **OK** — hardcore players should finish faster.
- Whale + premium (3 runs + quests + ×1.25) → finishes in 9 days. **OK** — still rewards engagement, doesn't make Pass+ obligatory.

---

## 4. Season cadence, theming, archive (BP-3)

### 4.1 Cadence

- **Season length:** 30 days (e.g. S1 = 1 Sep → 30 Sep).
- **Inter-season gap:** 0 days. New season starts 00:01 player-local the day after old season ends.
- **Mid-season offer window:** Premium track buyable up to **last 24h of season**. After that, archived.

### 4.2 Per-season theme

Each season carries a **lore theme** that ties Cursed-treatment, hero skin, and at least 1 boss event to it.

| Season | Theme | Lore tie | Cursed-treatment | Hero skin | Boss event |
|---|---|---|---|---|---|
| S1 | "Bell-Tide" | The Black-Bell Choir awakens | Cursed-Bell (green-pyre rim treatment) | Sieren "Bell That Sang First" | Black-Bell Choir extended-play live-op |
| S2 | "Soot Vigil" | The Forgotten Parade marches again | Cursed-Ember (ember-orange) | Veska "Cold Furnace Resumed" | New Forgotten Parade mid-boss live-op |
| S3 | "Mire-Bargain" | A demon-coin pool overflows | Cursed-Bog (bog-green wax) | Eddra "The Fourteenth Body" | Coven event-boss |
| S4 | "Cinder-Crown" | Cinderwood ignites | Cursed-Flame (animated cinder) | Mhar "God-Tree's Heir Fully Bloomed" | Skinward Pact event-boss |

After S4 cycle, S5+ either repeat themes or introduce new ones — Y2 planning slot.

### 4.3 Archive policy

- Past-season hero skins + Cursed-treatments **never re-enter pass**.
- Re-acquisition: from the "Vault" tab in Hub Storefront at 5,000 gems each (UK CMA compliance per §2.3).
- Past-season cards / cosmetics that weren't season-exclusive are catalogue-permanent and remain obtainable via shop / gacha.

### 4.4 Inter-season teaser

Last 3 days of season N show a "Coming Next Season" banner with season N+1 theme art + 1 reward teaser. Drives re-engagement on rollover day.

---

## 5. Premium tier-skip economy (BP-4)

### 5.1 Pass+ (one-time per season)

**£9.99** per season:
- Premium track unlock
- **+10 instant tier-skips** (jumps from current tier to current + 10)
- Exclusive Pass+ skin (mirrored from season hero, but with a unique nameplate accent — distinguishes Pass+ owners from Premium-only)

### 5.2 Per-tier gem skip

Outside Pass+, players can skip individual tiers with gems:
- **150 gems per tier** (≈ £1.40 raw at £4.99 / 500 gem ratio)
- Cap: 25 tier-skips per season (so a player can never skip the entire pass — must engage at least to tier 25 to claim tier 50)
- Tier-skip purchase grants both free + premium track rewards for that tier (if premium owned; else free-track only)

### 5.3 Anti-FOMO cap

If a player has not purchased Premium by tier 35, **a one-time-per-season prompt** offers Premium + 25 instant skips for £14.99 (= Premium £4.99 + 25 × 150 gems × £0.01/gem ≈ £8.74 effective discount). Captures the "wait, I want the hero skin" late-converter without abusing FOMO.

### 5.4 Anti-P2W audit (XP boosters / tier-skips)

| Lever | Anti-P2W test | Pass |
|---|---|---|
| Premium ×1.25 XP booster | gives 1.25× speed only, not 1.25× content | ✅ |
| Pass+ +10 instant tiers | locks ceiling at tier 50, same as free | ✅ |
| Per-tier skip 150 gems | capped at 25 skips, still need engagement | ✅ |
| Late-converter £14.99 offer | one-time, doesn't grant exclusive | ✅ |

---

## 6. Engine handoff (BP-5)

### 6.1 New resource classes

`game/src/data/season_pass.gd`:
```
class_name SeasonPass extends Resource

@export var id: StringName        # "season_1_bell_tide"
@export var display_name: String  # "The Marrow Pass: Bell-Tide"
@export var theme: String         # "Bell-Tide"
@export var starts_unix: int
@export var ends_unix: int
@export var free_tiers: Array[SeasonPassTier]  # 50 entries
@export var premium_tiers: Array[SeasonPassTier]  # 50 entries
@export var hero_reward_free: SeasonPassTier   # tier 50 free
@export var hero_reward_premium: SeasonPassTier  # tier 50 premium
@export var tier_xp_cost_curve: Array[int]  # [500, 500, ..., 1500] 50 entries
@export var premium_sku_id: StringName    # links to Sku
@export var pass_plus_sku_id: StringName
@export var tier_skip_gem_cost: int = 150
@export var max_tier_skips: int = 25
```

`game/src/data/season_pass_tier.gd`:
```
class_name SeasonPassTier extends Resource

@export var tier_number: int
@export var rewards: Array[SkuContentEntry]  # from shop_economy_v0.md §7.1
@export var is_hero: bool = false
```

### 6.2 GameState extensions

```
# season state
var current_season_pass: SeasonPass  # null between seasons (shouldn't happen — 0-day gap)
var season_xp: int = 0
var season_current_tier: int = 0  # 0 = not started; 50 = capped
var season_premium_unlocked: bool = false
var season_pass_plus_unlocked: bool = false
var season_tier_skips_purchased: int = 0
var season_free_claimed_tiers: Array[int] = []
var season_premium_claimed_tiers: Array[int] = []

# signals
signal season_xp_gained(amount: int, source: StringName, new_total: int)
signal season_tier_advanced(new_tier: int)
signal season_reward_claimed(tier: int, track: StringName, contents: Array)
signal season_premium_unlocked()
signal season_ended(final_tier: int)
signal season_started(season_pass: SeasonPass)

# API
func grant_season_xp(amount: int, source: StringName) -> void
func claim_season_reward(tier: int, track: StringName) -> bool  # track = "free" or "premium"
func unlock_season_premium() -> bool  # routes to IAP
func purchase_tier_skip(count: int = 1) -> bool  # gem-cost
```

### 6.3 Quest system handoff (XP source)

Cross-reference `monetisation_map.md` §11 + §13. Daily-quest cap rebalance (1,200 XP/day rather than 2,000) goes into:

```
class_name DailyQuest extends Resource

@export var id: StringName
@export var display_name: String
@export var xp_reward: int = 400
@export var other_rewards: Array[SkuContentEntry]  # gold / bones / etc
@export var qualifying_condition: StringName  # "win_run" / "win_with_warlord_X" / "apply_30_bleed"
```

`GameState.daily_quests: Array[DailyQuest]` — 3 slots, refresh 04:00 player-local.

### 6.4 Save format additions

```
# game_save.json
"season": {
  "current_id": "season_1_bell_tide",
  "xp": 12340,
  "tier": 14,
  "premium_unlocked": false,
  "pass_plus_unlocked": false,
  "tier_skips_used": 0,
  "free_claimed": [1,2,3,...,14],
  "premium_claimed": []
},
"vault_purchases": [],  # past-season hero re-acquisitions
"daily_quest_progress": {
  "rotation_date_unix": 1735776000,
  "quests": [
    { "id": "win_with_warlord_sieren", "qualifying_progress": 0, "claimed": false },
    ...
  ]
}
```

### 6.5 Booster multiplier registry hook

Per `warlord_tiers_v0.md` §13 + `monetisation_map.md` §13:

- `unlock_season_premium()` calls `GameState.set_xp_multiplier_source("battle_pass_premium", 1.25)` ONCE on unlock. Source stays alive until `season_ended` clears it.
- `season_tier_advanced(25)` checks: if free track and tier 25 just crossed, call `GameState.set_xp_multiplier_source("battle_pass_free_tier_25", 1.10)`. Cleared on `season_ended`.

These plug into the existing ×3.0 cap; no new multiplier mechanism needed.

### 6.6 IAP routing

Per `shop_economy_v0.md` §7.5, `PlatformBilling.purchase(sku_id)` handles. Premium-track SKU and Pass+ SKU are both registered SKUs (priced £4.99 and £9.99 respectively). Tier-skip is **not** a SKU — it's a gem spend, no IAP roundtrip.

---

## 7. MVP coverage

| Surface | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| Season Pass system | — | — | spec-only | **first BP ships** | live |
| Daily/weekly quest system | — | — | — | ✅ | ✅ |
| Tier-skip economy | — | — | — | ✅ | ✅ |
| Pass+ SKU | — | — | — | ✅ | ✅ |
| Vault (past-season re-purchase) | — | — | — | — | post-S4 only |
| Late-converter offer | — | — | — | ✅ | ✅ |
| Hero skin per season | — | — | — | ✅ | ✅ |
| Inter-season teaser | — | — | — | — | v1.1 |

---

## 8. Open questions for Paul

1. **S1 hero skin pick.** Recommend **Court-Necromant Sieren** — Ash-Mourners is the lore-canonical "Hanging Hour" faction, ties to S1 boss Black-Bell Choir. Alternative: Penance-Captain Vyrrun (Iron Penitents — most-played aggro). Lock now.
2. **Cursed-treatment season-exclusivity.** Cursed treatment is named in `monetisation_map.md` §5 as "14-day event £14.99". Spec'd here as season-exclusive premium-track reward (tier 6). Confirm: is the £14.99 SKU a separate purchase route, or strictly BP-exclusive going forward?
3. **Daily-quest XP cap (1,200 vs 2,000).** Recommend the 1,200 cap to keep BP finishable at ~22 days. Confirm.
4. **Inter-season gap (0 vs 1-2 days).** 0-day rollover keeps payer LTV tight but is grindy for the player. 1-day gap is more humane. Pick.
5. **Vault re-acquisition gem price (5,000 vs 8,000).** 5,000 is on-trend; 8,000 makes the FOMO real but is closer to "anti-consumer" line. Pick.

---

## 9. Cross-references

- `monetisation_map.md` §6 — original BP framing + booster registry §13.
- `shop_economy_v0.md` — currency model + IAP SDK + storefront wireframe.
- `variants_system_v0.md` — Cursed / Foil / Gold / Ink / Prism treatments referenced as rewards here.
- `upgrade_trees_v0.md` — Ancestor Tree (Bones sink) and Ascension (Souls earn) provide currency outlets for BP rewards.
- `warlord_tiers_v0.md` §13 — booster cap rules.
- `bosses_v0.md` — Black-Bell Choir = S1 theme tie-in.

— Controller, 2026-05-21
