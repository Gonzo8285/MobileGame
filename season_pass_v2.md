# Season Pass v2 — "Marrow Pass" — The Curse of Gallowfell

_Authored 2026-05-25 by Controller (round 5). Refines `season_pass_v0.md` (50 tiers, dual-track, £4.99 premium + £9.99 Pass+, 4-season runway, Vault re-acquisition, anti-P2W audit — all carried forward) with: Pass+ scope confirmation + instant-tier-skip purchase, Vault catch-up, season narrative arcs tied to theme packs, returning-player track, new-player track, cross-season XP carryover, free-track generosity, catch-up missions. v0 remains the tier-by-tier reward catalogue + XP curve; v2 layers lifecycle, segmentation, and theme integration._

**Status:** v0 → v2 refinement draft. **Anti-P2W invariant carries forward unchanged.** **Free-track-as-gift contract restated.** Pending Paul sign-off on Open Qs.

---

## 1. Carry-forward from v0 (unchanged)

The following remain locked from `season_pass_v0.md`. Summarised:

| v0 layer | Status |
|---|---|
| 50-tier reward inventory (free + premium tracks) — S1 template | unchanged + theme-pack hook added §4 |
| XP curve (50,000 total XP, front-loaded easy, late steep) | unchanged |
| Daily quest cap (1,200/day) + weekly quests (9,000/week) | unchanged |
| Season cadence (30 days, 0-day inter-season gap default) | unchanged + revisited Q in §11 |
| Hero reward exclusive-forever with Vault compliance edge | unchanged |
| Pass+ tier (£9.99 = Premium + 10 instant tiers + exclusive skin variant) | unchanged + scope confirmed §3 |
| Per-tier gem skip (150g/tier, cap 25 skips/season) | unchanged |
| Late-converter offer (£14.99 = Premium + 25 tier-skips by tier 35) | unchanged |
| Anti-P2W invariants (no power, no exclusive cards, cap ×1.25 XP) | unchanged |

**v2 additions begin §2.**

---

## 2. Free-track-as-gift contract (paramount, restated for v2)

> **The free pass track must feel like a gift, not a tease.** Per `competitive_landscape_v0.md` Wildfrost-grade generosity benchmark.

This restates and locks in the v0 §1 design goal as a contract. Operating rules:

| Rule | Specification |
|---|---|
| **Free track ≥ £6 perceived value** | At GBP-equivalent rates per `shop_economy_v0.md` (already met in v0 §2.2). |
| **Free track has its own unique hero reward** | Per v0 §2.1 tier 50 free = "Tolled" card-back (S1) — owned forever, even by F2P-only players. |
| **Every "premium" cosmetic surface has at least one free-track precursor** | Free track has its own card-backs, frames, banners. Just fewer / less prestigious. |
| **Free track is finishable in casual time** | 22 days at 1hr/day per v0 §3.2. Buffer of 8 days. |
| **Premium upgrade is the gear, not the destination** | A non-paying player who finishes the free track must feel "I got something good for £0". A paying player must feel "I got 4-6× more for £4.99". |
| **NEW v2: Free track gets one art-stubbed theme-pack name preview** | Per `theme_packs_system_v0.md` — free track tier 35 grants the **themed-name overlay** for one theme pack of the season (cosmetic-tease that doesn't gate the full theme but lets free players experience the theme-name layer). |

Press kit hook: "The free pass is a gift. Pay if you want more."

---

## 3. Pass+ scope confirmation + extensions (BP-4 v2)

### 3.1 Locked scope (carries from v0)

- £9.99 / season
- Includes Premium track unlock (so £9.99 is +£5 over £4.99 Premium — buyers don't pay twice)
- +10 instant tier-skips
- Exclusive hero-skin variant (mirror of season hero, distinct nameplate accent)

### 3.2 New v2 — instant-tier-skip purchase for late buyers

**Scenario:** A player buys Pass+ at tier 35 of a 50-tier pass. They need the +15 remaining tiers fast. v0 §5.2 covers per-tier gem skip (150g/tier, cap 25/season).

**v2 addition: bulk tier-skip SKU available specifically to late-buyers:**

| SKU | Trigger | Price | Skip count |
|---|---|---|---|
| Pass+ Tier Surge Small | Bought Pass+ at tier 30+ | £4.99 | +15 tiers |
| Pass+ Tier Surge Big | Bought Pass+ at tier 40+ | £9.99 | +25 tiers (caps to tier 50) |

Cost is calibrated below the equivalent gem-by-gem skip cost (150g × 25 = 3,750 gems ≈ £33 raw) for tier 40+ scenario, **rewarding late conversion**. Limited to one purchase per season per type.

**Anti-P2W test:** still capped at tier 50. No additional content unlock beyond what every Pass+ owner already gets at tier 50. ✅ pass.

### 3.3 New v2 — Pass+ retention beyond tier 50

`season_pass_v0.md` §3.1 has an "overshoot pool" hand-wave at tier 50. v2 fleshes this out:

| Tier 51+ band | Reward |
|---|---|
| Tier 51-55 (Pass+ only) | 1 Gold-treatment token per tier (5 picks total) |
| Tier 56-60 | 1 Cursed-treatment token + 200 gems per tier |
| Tier 61-65 | 1 Ink-treatment token + 250 gems per tier |
| Tier 66-70 | 1 Prismatic foil + 1 random animated-card state per tier |
| Tier 71+ | Pure currency: 300 gems per tier; soft-cap pacing |

XP requirement per overshoot tier: 1,500 XP (locked at the tier 50 cost).

**Why this exists:** the top 5% Pass+ payers grind through tier 50 with weeks left. Without overshoot rewards, they disengage. The overshoot is exclusively for Pass+ owners (Premium-only stops at tier 50). Adds 40-60h of retention for whales.

### 3.4 Cross-season XP carryover (new v2)

End-of-season overshoot XP banks into the next season:

| Source | Carry-over |
|---|---|
| XP earned past tier 50 (Pass+) | 50% banks toward next season's tier 1-5 (head-start) |
| XP earned past tier 50 (Premium-only) | 25% banks |
| XP earned past tier 50 (Free only) | 10% banks (small but visible reward for free-grinders) |
| Daily quest XP at season transition | rolls over (within 24h grace window) |

Cap on banked XP = 3 tiers worth (4,500 XP) into the next season. Prevents whale-snowball.

---

## 4. Season narrative arcs tied to theme packs (new v2)

Per `theme_packs_system_v0.md` §6.2 — each season carries a theme-pack tie-in.

| Season | Lore arc | Pass+ free theme pack | Hero skin (existing v0) |
|---|---|---|---|
| S1 "Bell-Tide" | Black-Bell Choir awakens | **The Grimm Reaping** (PD — Brothers Grimm) — Pied Piper as Pall-Bearer riff | Sieren "Bell That Sang First" |
| S2 "Soot Vigil" | Forgotten Parade marches | **The Forge-King's Engine** (Original — steampunk) — Forgotten Parade as automaton regiment riff | Veska "Cold Furnace Resumed" |
| S3 "Mire-Bargain" | Demon-coin pool overflows | **The Cosmic Drowning** (PD — Lovecraft) — pool as portal to the deep church | Eddra "The Fourteenth Body" |
| S4 "Cinder-Crown" | Cinderwood ignites | **The Ash Pantheon** (PD — Norse Ragnarok) — Cinderwood as Yggdrasil burning | Mhar "God-Tree's Heir Bloomed" |

**Mechanic:** Pass+ owners auto-receive the theme pack at season start as a free unlock. Theme pack is otherwise £5.99 standalone (per `theme_packs_system_v0.md` §6.1).

**Theme-pack tier integration:** the season's theme pack provides the *visual frame* for 5 specific season-pass reward tiers (tier 5 card-back, tier 15 board, tier 30 VFX, tier 35 themed-name overlay for free track, tier 40 boss card-back). Pass+ owners see these in the season theme; Premium owners see them in canonical Gallowfell theme; Free track gets the themed-name overlay only.

**Narrative thread:** each season's events, boss content, and theme pack pull from the same lore beat. Players who play the season feel immersed; players who only play premium track get the *cosmetic emersion*; players who play Pass+ get the *fully-themed game-world* during that season.

---

## 5. Returning-player track (new v2)

Per `competitive_landscape_v0.md` §1.3 Wildfrost re-engagement lesson — returning players are the cheapest re-conversion.

**Trigger:** player absent ≥ 30 days, returns. Triggered ONCE per absence-streak (resets if absent again ≥ 30 days).

### 5.1 Returning Seeker Pass

A **30-day mini-pass** tailored for re-engagement:

| Feature | Spec |
|---|---|
| Duration | 14 days from return-login |
| Tiers | 20 (vs the 50-tier full season) |
| Free track rewards | 200 gems + 100 Bones + 3 retry tickets + 1 Cursed-treatment + 1 Themed-name overlay |
| Premium track unlock | £2.99 (cheaper than standard £4.99) |
| Premium rewards | 800 gems + 1 Foil token + 1 alt-art + 1 frame + 1 board state preset |
| Catch-up XP boost | ×2.0 XP for first 7 days back (stacks with anything; capped at ×3.0 still per `monetisation_map.md` §13) |

### 5.2 Catch-up missions (Returning Seeker quests)

3 daily quests rotating for 14 days:
- "Run a chapter 1 again" — 800 XP + 100 gems
- "Win with the Warlord you played most before" — 1,200 XP + 1 retry ticket
- "Try a Warlord you've never played" — 1,500 XP + 50 Marrow Shards

### 5.3 Anti-burnout

Returning Seeker mini-pass cannot be combined with the current full season pass purchase in the same window — player picks one or the other. (Avoids stacking £2.99 + £4.99 + £9.99 promotional confusion.) Player can buy the full Pass+ at any time during/after the 14-day Returning Seeker window.

---

## 6. New-player track (new v2)

Per `competitive_landscape_v0.md` §2.3 tutorial-validation gap — first 14 days set retention for the next 14 months.

**Trigger:** player creates first account. First season they encounter gets the new-player track variant instead of the standard season pass.

### 6.1 First-Pass-Ever

| Feature | Spec |
|---|---|
| Duration | full 30-day season |
| Tiers | 50 (same as standard) |
| **Tier pacing** | front-loaded harder — tiers 1-15 require only 50 XP each (half the standard 500). Easy onboarding. |
| **Premium unlock** | £2.99 (cheaper than £4.99 — first-pass-ever discount). |
| **Pass+ unlock** | £6.99 (cheaper than £9.99). |
| **Premium first-tier hero reward** | Sieren skin variant OR Marrow Shards × 50 + retry ticket (player picks at unlock). |
| **Tutorial integration** | Quests are tutorial-wrapped — "Win your first run" = 5,000 XP (+5 tiers in one beat). |

### 6.2 Onboarding rewards (not in standard pass)

| Day | Reward |
|---|---|
| Day 1 (account create) | 200 Bones + 100 gems gift |
| Day 3 | "Welcome to Gallowfell" banner-frame |
| Day 7 | 1 free random Common-treatment token |
| Day 14 | Choice of 1 starter Warlord skin variant |
| Day 21 | 500 gems |
| Day 28 | 1 free random Uncommon-treatment token + invite to Day-29 "What's Next" tutorial of meta-progression systems |

### 6.3 Standard pass eligibility

Once the player completes their first-pass-ever season (or finishes 30 days, whichever comes first), they enter the standard pass progression. The first-pass-ever cannot be re-rolled — single-use per account.

---

## 7. Vault catch-up — late-season buyer (new v2)

Per `competitive_landscape_v0.md` §1.4 Marvel Snap Spotlight criticism — players who buy late feel punished. v2 fixes.

### 7.1 Mechanism

Player buys Premium (£4.99) or Pass+ (£9.99) on day 14+ of a 30-day season:
- All free-track rewards up to current tier **immediately claimed** (auto-paid as a one-tap collection).
- All premium-track rewards up to current tier **immediately claimed**.
- For tier 1-25 (compressed catch-up): rewards delivered in one bundle.
- For tier 26+ (more valuable rewards): rewards delivered tier-by-tier as XP earns.

### 7.2 Compressed weeks 1-2 progression

If a player buys Premium on day 21+ and they're stuck at tier 18:
- A one-time "Catch-up XP grant" of 8,000 XP (~5 tiers) added at purchase. Bridges tier 18 → 23.
- This is a Vault-Catch-up mechanism — bound to **Premium purchase after day 14** only.
- Stacks with Pass+ +10 tier-skip — so a day-21 Pass+ buyer can leap from tier 18 to tier 18+5+10 = tier 33.

### 7.3 Anti-FOMO

This means a player who hesitates and buys late doesn't feel "I wasted £4.99". They feel they got the same value, just delayed. Critical for late-converter trust.

### 7.4 Anti-P2W

Catch-up XP is just XP — doesn't grant exclusive content beyond what an early buyer gets at tier 50. Tier 50 still requires earned XP. ✅ pass.

---

## 8. New v2 — Hero reward design rule

Restated for v2: **the season hero reward is unique to that season; never re-sold, never recurring.** v0 §2.3 covered S1 Sieren "Bell That Sang First".

### 8.1 Hero reward locked progression

| Season | Hero Warlord | Hero skin name |
|---|---|---|
| S1 | Sieren (Court-Necromant) | "The Bell That Sang First" |
| S2 | Veska (Iron Penitents) | "Cold Furnace Resumed" |
| S3 | Eddra (Coven) | "The Fourteenth Body" |
| S4 | Mhar (Skinward Pact) | "God-Tree's Heir Fully Bloomed" |

S5+ rotates back through; **with a 2-year gap minimum** before any Warlord gets a second hero skin. Prevents same-Warlord re-buy fatigue.

### 8.2 Compliance edge (carries from v0 §2.3)

Vault re-acquisition at 5,000 gems (~£45) per CMA-compliance edge. No player ever actually pays it but the path exists.

### 8.3 Hero skin visibility

Hero skins are visible to other players (Warlord-select grid, in-combat HUD, PvP loadout per `extended_game_modes_v0.md`). The flex / collector identity is the entire psychological value driver. Visible = real.

---

## 9. Multi-pass holding (new v2)

**Q:** Can a player hold multiple passes simultaneously? E.g. has the Returning Seeker pass + the full season pass + a banked overshoot.

**A:** Yes, but only:
- 1 main season pass active.
- 1 Returning Seeker / First-Pass-Ever pass active (mutually exclusive with each other; switches on account state).
- Overshoot tier (tier 51+) is part of the main season pass, not separate.

XP earned counts toward both active passes simultaneously (no penalty for holding both — the pass-aware quest system rewards toward all eligible passes).

### 9.1 Engine handoff

```
# game/src/data/season_pass.gd extended:
@export var pass_kind: StringName  # "standard" / "returning_seeker" / "first_pass_ever"
@export var compatible_with_main_pass: bool  # true for returning_seeker, false for first_pass_ever during its window

# GameState:
var active_passes: Array[SeasonPass]  # 1-2 active at any time
func get_xp_eligible_passes() -> Array[SeasonPass]:
    return active_passes.filter(func(p): return p.is_active())
```

---

## 10. Engine handoff summary (v2 additions)

### 10.1 New SKUs

| SKU id | Price | Trigger |
|---|---|---|
| `pass_plus_tier_surge_small` | £4.99 | Pass+ bought at tier 30+ |
| `pass_plus_tier_surge_big` | £9.99 | Pass+ bought at tier 40+ |
| `returning_seeker_premium` | £2.99 | Player absent ≥30 days, returned |
| `first_pass_ever_premium` | £2.99 | New account, first season encountered |
| `first_pass_ever_plus` | £6.99 | New account, first season Pass+ |

All routed via `PlatformBilling.purchase(sku_id)` per `shop_economy_v0.md` §7.5.

### 10.2 GameState additions (delta from v0 §6.2)

```
# v2 additions
var first_pass_ever_used: bool = false
var returning_seeker_active_until_unix: int = 0  # 0 = not active
var banked_xp_next_season: int = 0  # cross-season carryover
var vault_catchup_xp_grants_used: Array[StringName] = []  # log per season

signal returning_seeker_activated()
signal first_pass_ever_activated()
signal vault_catchup_xp_granted(amount: int, season_id: StringName)
signal cross_season_xp_banked(amount: int)
```

### 10.3 Save format additions (delta from v0 §6.4)

```
"season_meta": {
  "first_pass_ever_used": false,
  "returning_seeker_active_until_unix": 0,
  "banked_xp_next_season": 0,
  "season_history": [
    { "season_id": "season_1_bell_tide", "final_tier": 38, "track": "premium" }
  ]
}
```

### 10.4 Theme pack integration (new for v2 per §4)

```
# extends SeasonPass:
@export var pass_plus_free_theme_pack_id: StringName  # e.g. "grimm_reaping"
@export var themed_tier_reward_overrides: Dictionary  # { tier_5: themed_card_back, tier_15: themed_board, ... }
```

When Pass+ unlocks, `ThemePackController.grant(season_pass.pass_plus_free_theme_pack_id)` is called. Player's owned-themes list updated. Per `theme_packs_system_v0.md` §2.3.

---

## 11. MVP coverage (v2 updates)

| Surface | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| (v0 carry-forward — unchanged) | | | | | |
| **NEW — Pass+ tier-surge SKU** | — | — | — | ✅ both rungs | ✅ |
| **NEW — Pass+ overshoot rewards (51-71)** | — | — | — | ✅ to tier 70 | ✅ to tier 71+ |
| **NEW — Cross-season XP carryover** | — | — | — | ✅ at S1→S2 rollover | ✅ |
| **NEW — Returning Seeker mini-pass** | — | — | — | live from week 1 | ✅ |
| **NEW — First-Pass-Ever pacing** | — | — | spec only | engine live S1 | ✅ |
| **NEW — Vault catch-up XP grant** | — | — | — | ✅ from day 14 | ✅ |
| **NEW — Theme pack tied to season** | — | — | — | ✅ S1 Grimm | ✅ all 4 seasons |
| **NEW — Multi-pass holding** | — | — | — | ✅ | ✅ |

---

## 12. Open questions for Paul

1. **Pass+ Tier Surge pricing.** Recommend £4.99 / £9.99 dual-rung. Confirm — or compress to a single £6.99 ladder?
2. **Returning Seeker mini-pass duration.** Recommend 14 days from return. Some publishers run 30-day catch-up. Pick.
3. **First-Pass-Ever Premium price.** Recommend £2.99 (less than standard £4.99). Confirm — or just discount the standard? Worry: discounting the standard pass starts a precedent.
4. **Vault catch-up XP grant size.** Recommend ~5 tiers (8,000 XP) for day-21 Premium buyers. Tune up if soft-launch shows late-buyer dropoff.
5. **Cross-season XP cap (3 tiers banked).** Confirm — or zero-cap (no rollover, simpler), or unlimited (whale-friendly but snowball risk)?

---

## 13. Cross-references

- `season_pass_v0.md` — foundational reward catalogue + XP curve (carries forward).
- `theme_packs_system_v0.md` — Pass+ free-theme-of-season hook + themed-name free-tier overlay.
- `shop_economy_v0.md` + `shop_economy_v2.md` — IAP routing, refund flow, regional pricing for pass SKUs.
- `variants_system_v0.md` — cosmetic rewards in tier inventory.
- `cosmetic_expansion_v1.md` — new cosmetic vectors as v2 pass-tier rewards.
- `extended_game_modes_v0.md` — PvP / Daily Brawl reward integration with pass XP.
- `monetisation_map.md` §6 — original BP framing + booster registry.
- `competitive_landscape_v0.md` §1.3 (Wildfrost retention), §1.4 (Snap FOMO), §2.3 (tutorial onboarding).

— Controller, 2026-05-25
