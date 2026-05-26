# Shop Economy v2 — The Curse of Gallowfell

_Authored 2026-05-25 by Controller (round 5). Refines `shop_economy_v0.md` (5-currency model + 6-tier gem ladder + Faction Set bundles + spend caps + parental gates — all carried forward) with: rotating shop, gifting, regional pricing, refund flows, loss-leaders, anti-FOMO contract, shop UX, and live-ops levers. v0 remains the foundational catalogue + price layer; v2 layers operational + UX + regulatory + lifecycle on top._

**Status:** v0 → v2 refinement draft. **Anti-P2W invariant carries forward unchanged.** **Loot-box ethics now explicit.** Pending Paul sign-off on Open Qs.

---

## 1. Carry-forward from v0 (unchanged)

The following remain locked from `shop_economy_v0.md`. Not repeated here, only summarised:

| v0 layer | Status |
|---|---|
| 5-currency model (Gold / Bones / Marrow Shards / Gems / Souls) | unchanged |
| 6-tier gem pack ladder (£0.99 / £4.99 / £9.99 / £18.99 / £44.99 / £89.99) | unchanged |
| Starter Bundle £4.99 (Vow-Broken Magus + 700 gems + booster + tickets + card-back) | unchanged |
| 5 Faction Set bundles (£9.99 each) | unchanged |
| In-run shop node (5 slots, 25g reroll, faction-bias) | unchanged |
| Spend caps (£100 warning, self-cap, £25 default for under-18, 30-day cool-off) | unchanged |
| Anti-P2W invariants (no soft-from-hard, Marrow Shards = Warlord-only, Souls = earn-only) | unchanged |
| Subscription Ascendant Pact £4.99/mo (post-IMV-2 patch 1.2) | unchanged + augmented per §10 |
| Live-ops bundle templates (Returner / Whale Mountain / Faction-War / Lapsed-Payer) | unchanged + extended per §3 |

**v2 additions begin §2.**

---

## 2. Anti-FOMO contract (paramount)

Stated as a contract because every other section in this doc must comply.

> **Every "limited-time" item in the Gallowfell shop MUST explicitly state, on the storefront card, when it returns. No permanently-lost cosmetics.**

| Rule | Examples |
|---|---|
| **Item card displays return-date** | "Returns in [Q2 2027]" or "Returns after 90 days" — visible on the SKU card. |
| **No "lost forever" wording** | Banned in copy. Internal flag: `permanent_removal: false` always. |
| **Vault re-acquisition exists** | After 60-90 days, any rotated item lands in Vault at gem-price. Already established in `season_pass_v0.md` §2.3. |
| **Pass+ hero skins** | Single exception — true season-exclusive. But compliance edge handled via Vault re-purchase at 5,000 gems (~£45) per `season_pass_v0.md` §2.3. |
| **No artificial scarcity counters** | "Only 100 left at this price!" banned. Sold-count for social proof allowed only if real. |
| **Limited bundle expiry timer** | Allowed only if accompanied by "Returns in [period]" statement. |

**This is a competitive moat.** Per `competitive_landscape_v0.md` §1.4, Marvel Snap and Wildfrost both got criticised for FOMO. We ship the explicit-return contract from day 1. Press kit messaging hook: "Gallowfell never deletes your wishlist."

---

## 3. Time-limited bundles + rotating shop

### 3.1 Featured Deal (weekly hero slot)

One **Featured Deal** rotates every Monday 04:00 player-local. Always at £4.99 price-point (matches the doubler anchor from `shop_economy_v0.md` §4.1). Composition rotates through templates:

| Template | Rough composition |
|---|---|
| "Themed Pack" | 1 theme pack + 1 board + 1 card-back (~30% off à la carte) |
| "Cosmetic Mountain" | 5 random Foil/Frame tokens + 1 emote |
| "Warlord Skin Heat" | 1 specific Warlord skin (rotates which Warlord) — requires Warlord owned |
| "Currency Doubler" | 1,000 gems + 50 Marrow Shards |
| "Pass Sweetener" | 5 instant tier-skips + 1 mulligan-token bundle |

Cycle: 5 templates × 4 weeks = 20-week unique rotation. Then loops with composition refresh. Each Featured Deal carries the "Returns in [date]" anti-FOMO marker.

### 3.2 Rotating shop — Marvel Snap / Wildfrost pattern

Permanent storefront extended with a **rotating shop** of 6 slots, refreshing every 24h at 04:00 local. Plus **6 always-available** anchor SKUs.

```
+----------------------------------------------+
| FEATURED                                     |
|  [hero deal £4.99]   [seasonal bundle]       |
+----------------------------------------------+
| ROTATING (refreshes in 11h 23m)              |
|  [slot 1] [slot 2] [slot 3]                  |
|  [slot 4] [slot 5] [slot 6]                  |
+----------------------------------------------+
| ALWAYS AVAILABLE                             |
|  Starter Bundle    £4.99 (1-time)            |
|  Faction Set × 5   £9.99                     |
|  Battle Pass tile  → season pass             |
+----------------------------------------------+
| GEM PACKS  (6-tier ladder)                   |
| ...                                          |
+----------------------------------------------+
| GRAB-BAG SKUs (see cosmetic_expansion_v1)    |
| Pick-a-Frame  £2.99   Pick-an-Emote £2.99    |
+----------------------------------------------+
```

**Rotating slot pool:**
- Mix of cosmetics (frames, emotes, card-backs, banners, foils, animated cards, play/death VFX).
- Price band £1.99 to £6.99 — never the high-whale rungs (those live in always-available + Featured).
- Each player's rotation is **per-account deterministic-seeded** — no manipulation, but stops "shop comparing" between players from anchoring expectations.
- "Owned" items skipped automatically.
- Players can "Pin" 1 slot — pinned slot survives one rotation. Free, no IAP.

**Refresh cycle:** 24h at 04:00 local. Telemetry instruments — if rotation slot doesn't sell within 7 days, escalate to data review (price elasticity flag).

### 3.3 Seasonal bundles

Each 30-day season has a **theme-tied seasonal bundle** (per `season_pass_v0.md` §4.2):

| Season | Seasonal bundle |
|---|---|
| S1 "Bell-Tide" | "Bell-Tide Mourning Pack" — Pall-Bearer animated state + Bell-Tide card-back + Ash-Mourners frame + 500 gems — £9.99 |
| S2 "Soot Vigil" | "Soot Vigil Brigade" — Forgotten Parade-themed warband pack — £9.99 |
| S3 "Mire-Bargain" | "Mire-Bargain Coven Pack" — £9.99 |
| S4 "Cinder-Crown" | "Cinder-Crown Pact Pack" — £9.99 |

Each seasonal bundle has explicit "Returns in [next year's same season]" anti-FOMO marker.

### 3.4 Returning rotation

All time-limited items return in the rotation calendar 90 days post-removal at the same price OR Vault at gem-price (player choice when both exist).

---

## 4. Currency exchange rules (locked)

`shop_economy_v0.md` §1 already locked the no-soft-from-hard / no-hard-from-soft rules. v2 extends with explicit **allowed conversions**:

| From → To | Allowed? | Rate | Notes |
|---|---|---|---|
| Gems → Marrow Shards | ✅ (on paid Warlord SKU page only) | dual-price displayed | Anti-P2W: cosmetic on hard currency, not utility |
| Gems → in-run Gold | ❌ | — | Single most-broken F2P rule. Never. |
| Gems → Bones | ❌ | — | Meta-soft is earn-only |
| Bones → Marrow Shards | ❌ | — | Parallel currencies |
| Bones → Gold | ❌ | — | Gold is per-run only |
| Marrow Shards → Gems | ❌ | — | Forbidden direction |
| Marrow Shards → Bones | ❌ | — | Forbidden |
| Souls → anything | ❌ | — | Earn-only, prestige-only |
| Anything → Souls | ❌ | — | Earn-only |
| **NEW v2: Duplicate cosmetic → Marrow Shards** | ✅ | 5 ms per duplicate cosmetic | Gacha pull yields a duplicate? Auto-converts. Per `variants_system_v0.md` §9.1. |
| **NEW v2: Treatment shard → Treatment token** | ✅ | 50 shards = 1 Foil token | New "shard" sub-currency from gacha duplicates / season pass |

**Anti-laundering rule (new v2):** A player cannot gift their way around the cap. A gifted item is **not redeemable into the receiver's currency**. Anti-money-laundering safeguard for the player economy.

---

## 5. Gifting between players (new v2)

### 5.1 Gift mechanics

A player can gift specific SKUs to a friend (social-ID-linked) in their friends list:

- **Theme packs**: giftable (£3.99 / £5.99 / £7.99 tiers).
- **Card-backs**: giftable (£1.99-£3.99).
- **Frames**: giftable.
- **Emotes**: giftable.
- **Currency packs (gems)**: NOT giftable. (Anti-money-laundering: currency must be self-purchased to track regional pricing + spend caps.)
- **Warlords**: NOT giftable. (Roster access tied to player; no second-hand market.)
- **Battle Pass / Pass+**: NOT giftable. (Personal progression; per-account.)

### 5.2 Pricing

Gift = full price, no discount. Receiver gets the asset; gifter gets a **one-time "Generous Stranger" banner-frame** as thank-you (the first time only — not stackable spam).

### 5.3 Gift cap

- **3 gifts per friend per month** (anti-laundering).
- **10 gifts per gifter per month total** (cap to prevent shop-laundering schemes).
- Gift recipient must be in friends list for ≥ 7 days (anti-throwaway-account abuse).

### 5.4 Refunds on gifts

- Receiver can refund within 24h (no questions) — refund goes back as gems to the gifter (not the receiver).
- After 24h: case-by-case via support.

### 5.5 Engine handoff

```
class_name GiftTransaction extends Resource

@export var gifter_id: StringName
@export var receiver_id: StringName
@export var sku_id: StringName
@export var sent_unix: int
@export var accepted_unix: int = 0  # 0 = pending
@export var refunded_unix: int = 0
@export var receiver_friendship_age_days: int  # for cap check
```

Friend-list integration: extends `GameState.social.friends_list` (added v1.0).

---

## 6. Refund policy (new v2)

PWA / iOS / Android refund handling, transparent and disclosed.

### 6.1 Day-1 no-questions refund

- Any IAP within 24h is refundable from the in-app receipt page.
- One tap "Refund this purchase". Gems / items returned (consumed gems re-added; non-consumed items un-grant).
- Available once per SKU lifetime per player.

### 6.2 Later refunds — case-by-case

- 2-30 days post-purchase: support ticket via in-app form. SLA = 48h response.
- 30+ days: not eligible by default. Exceptional cases (mistaken-child-purchase, regional-billing dispute) escalated.

### 6.3 Subscription cancellation

- Ascendant Pact cancellable at any time from Settings → Subscription.
- Cancellation effective end of current billing cycle (player retains benefits for that month).
- One-tap cancel; no retention dark-patterns (no "are you sure?" repeated, no offers-to-stay).

### 6.4 Platform-specific routes

| Platform | Primary refund route |
|---|---|
| iOS | Apple's "Report a Problem" link surfaced in-app + manual support |
| Android (Play Store) | Google Play's 48h refund window + manual support |
| PWA (Stripe-billed) | Direct in-app refund button (we're the merchant of record) |

### 6.5 Disclosure

Refund policy visible:
- In Settings → Account → Refund Policy (full text).
- On every IAP purchase screen (collapsed "About refunds" link).
- Linked from store-page descriptions per Apple/Play guidance.

---

## 7. Regional pricing (new v2)

Aligned to Steam regional pricing tier list as published. Below = the £4.99 anchor in each tier; other rungs scale proportionally.

| Region tier | Markets | £4.99 SKU price | % of UK |
|---|---|---|---|
| **Tier 1 — premium markets** | Norway / Switzerland / Iceland | £5.49 | 110% |
| **Tier 2 — baseline** | UK / IE / DE / FR / NL / AU / NZ / CA / JP / KR | £4.99 | 100% |
| **Tier 3 — moderate discount** | Spain / Italy / Portugal / Greece / Eastern EU | £3.99 | 80% |
| **Tier 4 — emerging markets** | Mexico / Argentina / Chile / South Africa / Thailand / Vietnam | £2.99 | 60% |
| **Tier 5 — deep discount** | India / Brazil / Turkey / Indonesia / Philippines / Egypt | £1.99 | 40% |

**Why this pattern:** matches Steam regional pricing convention, which players in those markets expect. Refusing to regionalise creates the "Western game costs 3x my wage" problem and pushes piracy + churn.

**Currency floor:** sub-region prices may be even lower for the £0.99 SKU rung (capped at the platform-minimum, which is region-set by Apple/Google).

### 7.1 Anti-arbitrage

- Account region locked to IP/store country at first login. Single switch allowed within 90 days, then frozen.
- VPN-fraud detection: if account region differs from IP region for >5 sessions, hard-flagged for support review.
- Marrow Shards + Souls are region-agnostic (earned). Gems are region-priced — but the player can't VPN to cheap-tier, stockpile gems, then VPN back.

### 7.2 Localised currency display

`PlatformBilling.query_localised_price(sku_id)` (per `shop_economy_v0.md` §7.5) returns:
- iOS: StoreKit-localised string (£4.99 / ₹399 / R$24.90 / etc).
- Android: Play Billing localised price.
- PWA: Stripe regional pricing API.

---

## 8. Loss-leaders + conversion lift (new v2)

### 8.1 First-purchase 100% bonus (the universal payer-converter)

Already in `shop_economy_v0.md` §4.1 as +50 gems on the £4.99 pack. v2 escalates:

> **First-purchase 100% bonus on the £4.99 SKU specifically — payer's first lifetime purchase doubles the gems (500 → 1,000).**

This is THE single most-impactful payer-conversion lever in F2P. Industry data: 1.5-2.5× conversion lift on first-purchase doublers. Cost = ~5% of one paying customer's LTV. ROI enormous.

**Rule:** lifetime-once per account. Surfaced ONLY on the £4.99 SKU. Removed for that account once redeemed.

### 8.2 Day-3 "stuck" offer

Player has played 3 sessions but no IAP, and is showing struggle metrics (≥3 retries on a single run, or 2+ failed runs in a row):

> **One-time £2.99 "Mire-Wife's Comfort" pack — 200 gems + 3 retry tickets + 1 mulligan token.**

Expires after 7 days. Returns in 90 days if not purchased. **Anti-FOMO rule applies** — explicitly states "Returns in 90 days".

### 8.3 Day-14 "comeback" offer

Player has been engaged 14 days but no IAP:

> **One-time £4.99 "Persistence of the Curse" pack — Starter Bundle minus Vow-Broken Magus (cheaper because no Warlord — pure currencies + tickets + card-back).**

Slot-fills the Starter Bundle gap if the original was rejected.

### 8.4 "Friend referred you" loss-leader

Friend invited via referral code → first-purchase bonus is 150% (vs the standard 100%). Plus referrer gets 100 gems thanks. Two-sided incentive.

### 8.5 Anti-burnout

These loss-leaders are **non-overlapping** — a single player encounters at most 4 across their lifetime (first-purchase doubler + day-3 + day-14 + friend-referral). No bombardment.

---

## 9. Shop UX (new v2)

### 9.1 Wireframe (mobile portrait, expanded over v0)

```
┌──────────────────────────────────────────────┐
│  STORE                            💎 1,420   │  <- balance, tap = gem pack
├──────────────────────────────────────────────┤
│  [FEATURED ▾]  [BUNDLES]  [COSMETICS]  [GEMS]│  <- top-level tabs
├──────────────────────────────────────────────┤
│  🔍 Search...                              ⓘ │  <- search + help
│  Filter:  [Owned] [Affordable] [On sale]    │  <- filter chips
├──────────────────────────────────────────────┤
│  HERO DEAL OF THE WEEK                       │
│  ┌─────────────────────────────────┐         │
│  │ Bell-Tide Mourning Pack         │         │
│  │ ┌──┐ Pall-Bearer animated       │         │
│  │ │  │ + Bell-Tide card-back      │         │
│  │ │  │ + 500 gems                 │         │
│  │ └──┘                            │         │
│  │ £9.99    Returns: Q2 2027       │         │
│  │ [Buy]  [Gift]  [Wishlist ❤]    │         │
│  └─────────────────────────────────┘         │
├──────────────────────────────────────────────┤
│  ROTATING (refreshes 11h 23m)                │
│  ┌────┐ ┌────┐ ┌────┐                       │
│  │ ▢  │ │ ▢  │ │ ▢  │  ← 6 grid slots       │
│  └────┘ └────┘ └────┘                       │
│  ┌────┐ ┌────┐ ┌────┐                       │
│  │ ▢  │ │ ▢  │ │ ▢📌│  ← 📌 = pinned        │
│  └────┘ └────┘ └────┘                       │
├──────────────────────────────────────────────┤
│  ALWAYS AVAILABLE                            │
│  [Starter Bundle]  [Faction Set x5]         │
│  [Battle Pass]                               │
└──────────────────────────────────────────────┘
```

### 9.2 Core UX rules

| Rule | Specification |
|---|---|
| **Featured carousel** | Top of store. 1 deal at a time, swipe between 3 if multiple active. |
| **Search** | Full-text search across name + description + category. |
| **"Owned" filter** | Filter chip to hide already-owned items. Default: off (lets players see "what would I buy if I had more gems"). |
| **Gift button** | Every giftable SKU shows Gift icon next to Buy. Tap = friend picker. |
| **Wishlist** | Players can wishlist any SKU. Wishlist surfaces in: notification when item enters rotation, friend can see (for gift-giving), birthday-banner pinning. |
| **Price visibility** | Always show currency price (£) and gem price where dual-priced. Localised per region. |
| **Return-date marker** | All limited items show "Returns in [date]" on the SKU card. **Required UI element.** |
| **"Try before you buy"** | Cosmetic SKUs (themes, frames, foils) have a "Preview" button that shows the item applied to the player's current deck before purchase. Free, no commit. |
| **Confirmation modal** | All IAP > £4.99 require a confirmation tap. Sub-£4.99 = single tap. (Anti-misclick for whales who hit Buy on £89.99 by accident.) |
| **Receipt history** | Settings → Purchase History — every IAP receipt browsable with refund button (per §6). |

### 9.3 Discoverability

- Tab top-level: Featured / Bundles / Cosmetics / Gems.
- Cosmetics tab subdivided into: Themes / Card-Backs / Skins / Frames / Foils / Boards / Banners / Emotes.
- Filter chips: "Owned", "Affordable" (gems-only), "On sale" (≥20% off), "New this week".

### 9.4 No dark patterns

| Banned UX pattern | Why |
|---|---|
| Pre-checked auto-renewals | EU consumer law. |
| "Last chance!" without real expiry | Anti-FOMO contract §2. |
| Trick-purchase flow (Buy → Confirm → Confirm) | Anti-misclick yes, but no manipulative drag-out. |
| Hidden subscription terms | All terms surfaced on purchase screen. |
| "Almost gone!" without real inventory | Banned. |
| Currency bundle that doesn't divide cleanly | All gem packs end in 0 or 00. No "1,237 gems for £4.99" trick. |

---

## 10. Subscription — Ascendant Pact v2 (extending v0 §4.6)

`shop_economy_v0.md` §4.6 already locked the core £4.99/mo offer. v2 extensions:

### 10.1 Tiers

| Tier | Price | Inclusions |
|---|---|---|
| **Ascendant Pact** (basic) | £4.99/mo | 30 gems/day + double-rewards toggle + sub-banner + 1 Cursed-treatment/mo |
| **Ascendant Pact Pro** (new v2) | £9.99/mo | All above + 1 free theme pack/quarter + Pass+ included each season + 50 gems/day + 1 paid Warlord/quarter |

Pro tier adds the "all-included" upsell for committed players. Pricing reflects raw value (Pass+ alone is £9.99/season, theme pack £3.99-£7.99, paid Warlord £4.99 — so £9.99/mo for the year = £120 spend → ~£200 raw value).

### 10.2 Anti-churn

- Pause subscription (up to 90 days) — keeps benefits earned, freezes billing.
- Win-back offer: lapsed subscriber returns within 30 days → 1 free month.
- No win-back > 30 days (avoids manipulating churn).

### 10.3 Sub-only cosmetics

Per `variants_system_v0.md` §8 patterns:
- "Pact-Sworn" banner-frame (sub-only).
- "Ascended" title (sub-tenure ≥ 6 months).
- "Hangman's Patron" title (sub-tenure ≥ 12 months).
- These remain **earned during subscription** — cancelling doesn't strip them.

---

## 11. Five economic levers for post-launch tuning

These are the **operational knobs** Live-Ops can adjust without engine changes. Each has a telemetry signal we monitor.

### 11.1 Price elasticity

- **Lever:** can adjust SKU price ±20% per region per quarter.
- **Signal:** purchase volume per £ revenue per quarter; segment by region tier.
- **Bound:** never increase prices on existing SKUs that players bought once (perceived bait-and-switch).
- **Bound:** never decrease below the published platform floor (~£0.99).

### 11.2 Discount cadence

- **Lever:** % of weeks per quarter with a discounted Featured Deal. Range: 25-50%.
- **Signal:** payer-conversion rate, weekly active payers.
- **Bound:** never run 4 consecutive weeks of >25% discounts (trains payers to wait).

### 11.3 Bundle composition

- **Lever:** what's bundled at the £4.99 / £9.99 / £19.99 hero slots. 5 templates (per §3.1); rotation can adjust to demand.
- **Signal:** sell-through rate per template; if one template never sells, replace.
- **Bound:** bundle value must always exceed sum-of-parts à la carte (perceived deal). Minimum 20% discount equivalent.

### 11.4 Rotation frequency

- **Lever:** how often Featured / Rotating refresh. Default: 7 / 1 days. Range: 5-10 / 1-2 days.
- **Signal:** revenue per shop-visit; visits per day per player.
- **Bound:** never refresh faster than 24h (causes anxiety + dark-pattern signal).

### 11.5 Gift quotas

- **Lever:** monthly gift cap per gifter (default 10). Range: 5-20.
- **Signal:** gift-abuse-flagged accounts per month; spend cap evasion patterns.
- **Bound:** never < 3/month (kills the gifting feature).

Telemetry instrumentation: each lever has a dashboard panel + 30-day rolling window. Tuning reviewed quarterly.

---

## 12. MVP coverage (v2 updates)

| Surface | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| (v0 carry-forward — unchanged) | | | | | |
| **NEW — Anti-FOMO contract** | — | — | ✅ spec | ✅ all SKUs | ✅ |
| **NEW — Featured Deal weekly** | — | — | — | ✅ | ✅ |
| **NEW — Rotating shop 6-slot** | — | — | — | ✅ | ✅ |
| **NEW — Gifting** | — | — | — | beta (1 SKU type) | ✅ all types |
| **NEW — Regional pricing** | — | — | ✅ Tiers 2-5 | ✅ all 5 tiers | ✅ |
| **NEW — Refund flow** | — | — | ✅ basic | ✅ full | ✅ |
| **NEW — Loss-leaders (first-buy doubler)** | — | — | ✅ | ✅ + day-3 + day-14 | ✅ + friend-referral |
| **NEW — Shop UX (search/filter/wishlist)** | — | — | ✅ | ✅ | ✅ + preview |
| **NEW — Ascendant Pact Pro tier** | — | — | — | — | ✅ (v1.2) |
| **NEW — Grab-Bag SKUs** | — | — | — | ✅ 4 SKUs | ✅ + rotation |

---

## 13. Open questions for Paul

1. **Featured Deal price point.** Locked at £4.99 anchor. Confirm — or test £6.99 in some weeks for higher-margin templates?
2. **Gift cap (3 per friend / 10 per month).** Recommend keeping conservative for launch; widen post-soft-launch if abuse signals stay low.
3. **Ascendant Pact Pro launch timing.** Recommend patch 1.2 (~3 months post-launch). Earlier = cannibalises basic subscription. Later = misses the engaged-payer window. Lock.
4. **Day-3 + Day-14 loss-leaders.** Recommend both. Some publishers do day-7 instead (between the two). Pick.
5. **Refund window for non-consumable cosmetics.** 24h "no questions" is generous — some publishers do 1h. Confirm 24h.

---

## 14. Cross-references

- `shop_economy_v0.md` — foundational catalogue + price + spend caps (carries forward).
- `season_pass_v0.md` + `season_pass_v2.md` — Battle Pass + Pass+ + Vault catch-up + returning track.
- `variants_system_v0.md` — cosmetic stack consumed by shop.
- `theme_packs_system_v0.md` — theme packs as the new £3.99/£5.99/£7.99 SKU tier.
- `cosmetic_expansion_v1.md` — new vectors (foils / frames / animated cards / VFX) consumed by shop rotation.
- `monetisation_map.md` §1-§9 — booster registry + per-SKU mapping.
- `competitive_landscape_v0.md` §1.4 — anti-FOMO + anti-Spotlight-Cache lessons.
- `extended_game_modes_v0.md` — PvP modes drop only cosmetics (no card grinds), all consumed via this shop.

— Controller, 2026-05-25
