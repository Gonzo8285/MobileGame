# Shop economy v0 — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory items SHOP-1..6. Extends, does not replace, `monetisation_map.md` (which remains the player-journey diagram). This doc is the catalogue + price + economy contract; monetisation_map.md is the where-it-lives-in-the-loop view._

**Status:** v0 draft — pending Paul sign-off on Open Q items at the bottom. **Anti-P2W invariant locked.**

---

## 1. Currency model (SHOP-1)

5 currencies. Each has exactly one role; never overlap. Locked here for the rest of the design space.

| Currency | Symbol | Tier | Earned by | Spent on | Caps | Persists? |
|---|---|---|---|---|---|---|
| **Gold** | `g` | in-run soft | won in combat, looted, event rewards | in-run Shop, in-run upgrades at REST nodes, event-choice gates | wallet capped at 999/run; resets to 0 on run-start | per-run only |
| **Bones** | `bo` | meta soft | run-end conversion (1 Bone per node cleared + 10 per run-victory), daily-login chest, returner bundles | Ancestor Tree (UPG-1) unlocks, card-mastery shard exchange, Warlord-XP scrolls | wallet capped at 99,999 | persistent |
| **Marrow Shards** | `ms` | meta hard-soft | win quota of any Warlord (~30 ms / run win, ~15 ms / run loss past round 4), boss kills (+50 ms), achievements | **Paid Warlord unlocks only** (per `warlords_v1.md` §"Paid roster"). Nothing else. | wallet uncapped | persistent |
| **Gems** | `gm` | premium | **purchased only** (gem packs), daily quest (small drip ≤5/day), seasonal events (≤30/season), starter bundle | retries (per balance doc), gacha pulls (treatments + alt-arts), Season-Pass Pass+ + tier-skip, paid Warlord skip (alt path to Marrow Shards), in-Hub storefront SKUs | wallet uncapped | persistent |
| **Souls** | `so` | premium **earned-only** | run-victory at Ascension ≥ 5 (+1 / +2 / +3 by chapter), beating each Warlord's Ascension 11 (+10), W11 unlock (+25) | Ancestor Tree T4/T5 prestige nodes, Warlord skins flagged "Soul-bound" (cannot be IAP-bought), the no-IAP cosmetic surface | wallet uncapped | persistent |

**Why 5:** Gold and Bones are the play-to-earn loop. Marrow Shards are the *grind* path that mirrors the *gem* path for paid Warlords (so anti-P2W: any paid Warlord buyable via play). Gems are the IAP-only currency for impatience. Souls are the prestige cosmetic currency that no spend can shortcut — protects elite-player identity.

**Conversion rules (locked, anti-P2W):**
- **No buying soft from hard** — Gems cannot buy Gold or Bones (this is the single most-broken rule in F2P; we don't break it).
- **No buying hard from soft** — Bones cannot buy Marrow Shards or Souls.
- **Marrow Shards → Gems = forbidden** in both directions; they're parallel currencies on purpose.
- **Souls are earned-only** — never any IAP path; never any pity unlock.
- **One exception**: Gem → Marrow Shards is allowed *one direction*, **only on the paid Warlord SKU page** (UI presents both prices side-by-side; player picks). Never as a "buy 100 Marrow Shards for £4.99" SKU.

**Anti-stockpile rule:** Gold cap (999) prevents the carry-over abuse where you intentionally avoid spending in shops. Bones cap (99,999) is generous but exists so we can detect inflation outliers in telemetry.

**MVP coverage:** Gold + Gems live for IMV-1 (gems per balance doc). Bones + Marrow Shards + Souls land at IMV-2 alongside the persistent save layer (per `2026-05-18_gallowfell_balance.md` §"IAP / store integration — deferred to IMV-2").

---

## 2. Permanent storefront — Hub > Store tab (SHOP-2)

Wireframe (ASCII):

```
+----------------------------------------------+
| < BACK              STORE              [💎0] |  <- gem balance, tap = §3 gem packs
+----------------------------------------------+
| FEATURED                                     |
|  +---------------+   +---------------+        |
|  |  STARTER      |   |  THIS WEEK    |        |
|  |  BUNDLE       |   |  Brass Hounds |        |
|  |  £4.99        |   |  bundle £4.99 |        |
|  |  1-time       |   |  ends in 3d   |        |
|  +---------------+   +---------------+        |
+----------------------------------------------+
| GEM PACKS                                    |
|  💎 Handful     100   £0.99                  |
|  💎 Pouch       500   £4.99   (+50 first)    |
|  💎 Sack       1,200  £9.99                  |
|  💎 Casket     2,800  £19.99                 |
|  💎 Hoard      7,500  £49.99                 |
|  💎 Tribute   18,000  £99.99                 |
+----------------------------------------------+
| BUNDLES                                       |
|  - Returner Bundle (segment-gated)            |
|  - Faction Set: Iron Penitents (£9.99)        |
|  - Faction Set: Ash-Mourners  (£9.99)         |
|  - Faction Set: Coven         (£9.99)         |
|  - Faction Set: Last Legion   (£9.99)         |
|  - Faction Set: Skinward Pact (£9.99)         |
+----------------------------------------------+
| COSMETICS                                     |
|  > Card Treatments (link → Collection chooser)|
|  > Warlord Skins (3 featured + browse)        |
|  > Card-backs (1 free unlocked / 9 paid)      |
|  > Board Skins                                |
+----------------------------------------------+
| BATTLE PASS  →  Marrow Pass: Season 1         |
|  [Unlock Premium £4.99]  [Pass+ £9.99]        |
+----------------------------------------------+
```

**Sections (5):**

1. **Featured** — 2 hero slots. Always: starter bundle (one-time SKU) + week's rotating bundle. Updates Monday 04:00 player-local.
2. **Gem Packs** — 6-tier ladder per `monetisation_map.md` §1. First-purchase doubler ON the £4.99 SKU only.
3. **Bundles** — rotating + always-on. Faction Sets are always-on; live-ops bundles rotate.
4. **Cosmetics** — 4 sub-views. Card Treatments routes into Collection chooser. Warlord Skins / Card-backs / Board Skins each open their own grid.
5. **Battle Pass tile** — single tile that opens season pass view (see `season_pass_v0.md`).

**Display rules:**
- Owned/unlocked items show "Owned" badge, never a buy button.
- Limited bundles always show countdown timer + sold-count if >50 sales globally (social proof).
- Price strings localised via store; UK player sees £, US sees $, EU sees €, etc.
- Per Apple/Play guidance: no third-party-payment routing in app.

**Refresh cadence:**
- Featured: weekly (Mon 04:00 local).
- Bundles: weekly (Mon) + ad-hoc live-ops.
- Cosmetics: daily reshuffle on the "featured cosmetic" row only; full catalogue always browseable.

---

## 3. In-run shop node — catalogue, pricing, weights (SHOP-3)

**Node trigger:** any time a player enters a SHOP node on the map (per `enums.gd` NodeKind.SHOP). Frequency per chapter is up to the map generator; for chapter-1 (linear 8-round per balance doc) there's no SHOP node, so this lands at IMV-2 with the branching map.

**Slot count:** 5 slots per shop visit. Layout: 1 cards row × 3 slots + 1 relic slot + 1 service slot.

| Slot | Stock pool | Price | Refresh on reroll? |
|---|---|---|---|
| Slot 1 (card) | random Common/Uncommon from any in-scope faction | 50g / 75g | yes |
| Slot 2 (card) | random Uncommon/Rare from any in-scope faction | 90g / 150g | yes |
| Slot 3 (card) | random Rare/Epic from player's Warlord faction (faction-bias) | 175g / 240g | yes |
| Slot 4 (relic) | random Common/Uncommon relic | 120g / 200g | yes |
| Slot 5 (service) | 1 of 3 services — see below | flat | no |

**Service slot options (one rolled per visit):**
| Service | Cost | Effect |
|---|---|---|
| **Remove a card** | 75g | Permanently remove 1 card from the run-deck (player picks). |
| **Upgrade a card** | 100g | Pick 1 card; +1 to its primary stat (per UPG-3 / `rests_v0.md`). |
| **Holy water** (faction-shrine flavoured) | 60g | Remove 1 active curse from the player. |

**Reroll:** entire shop rerolls (slots 1-4) for 25g, cap 1 reroll per visit. Service slot does not reroll.

**Faction bias:** all card slots roll on the standard reward weights (`reward_generator.gd`: BIAS=4.0 / OTHER=1.0 / NEUTRAL=2.0; COMMON=10 / UNCOMMON=5 / RARE=2; EPIC and LEGENDARY excluded). Relic slot weights TBD (UPG-5 deliverable).

**Pricing scale per chapter:** prices above are chapter-1 baseline. Multiply by `1.0 + 0.10 × (chapter - 1)`:
- Chapter 1: ×1.00
- Chapter 2: ×1.10
- Chapter 3: ×1.20

(Matches the enemy-stat scaling shape in `2026-05-18_gallowfell_balance.md`. Keeps shop in-line with currency yield as the run goes deeper.)

**Anti-stockpile loop:** if the player visits 3 shops without spending (telemetry counter), the next shop offers a "Mire-Wife's Tip" event — 5g unlocks one slot at 50% price for that visit only. Surfaces unused gold without forcing a spend.

**Sold-out state:** once bought, slot is permanently empty for that visit. Tap empty slot → "The wares are gone. Nothing more to be had here." flavour line.

---

## 4. IAP price ladder + bundle compositions (SHOP-4)

### 4.1 Gem packs (6-tier ladder)

Confirmed per `monetisation_map.md` §1. Concrete contents:

| SKU | USD anchor (UK £ equivalent) | Gems | First-purchase bonus | Why this rung exists |
|---|---|---|---|---|
| Handful | $0.99 (£0.99) | 100 | — | Sub-£1 floor for impulse spend. |
| Pouch | $4.99 (£4.99) | 500 | **+50 gems first-buy only** | The doubler anchor; converts most payers. |
| Sack | $9.99 (£9.99) | 1,200 | — | Value-leader (2.4× pouch for 2× price). |
| Casket | $19.99 (£18.99) | 2,800 | — | Mid-whale rung. |
| Hoard | $49.99 (£44.99) | 7,500 | — | High-whale; doubles casket value at 2.5× price. |
| Tribute | $99.99 (£89.99) | 18,000 | — | Maximum-allowed single SKU in most markets. |

**Bonus structure:** only the £4.99 SKU has the first-purchase doubler. Removes choice paralysis from non-payers (the right answer is always "buy the £4.99 once"). Whales don't care about a one-shot 50-gem bonus.

### 4.2 Starter Bundle — single SKU, Day-2 trigger

Per `monetisation_map.md` §2 + `warlord_tiers_v0.md` §2.3.

**Contents (locked):**
- 1 paid Warlord — **The Vow-Broken Magus** (cheapest of paid 5 per `warlords_v1.md`; cross-faction = highest novelty)
- 700 gems (equivalent to £4.99 + £4.99 = £9.99 raw value)
- **7-day +50% Warlord-XP booster** (multiplier; per §13 of monetisation_map.md booster registry)
- 5 retry tickets (skip the gem-cost on next 5 retries; trades into the IMV-1 retry economy from `2026-05-18_gallowfell_balance.md`)
- 1 exclusive card-back: "The Two Vows Kept" (mirrors Magus T4 skin per `warlord_tiers_full.md` W6)

**Total raw value:** ~£14 of items for £4.99. Hard anchor.

**Display string:** "70% off — first 7 days only"
**Acquisition rule:** offered once at session start of the player's first session on Day 2. Never re-offered.

### 4.3 Faction Set bundles (5 always-on)

One bundle per faction. Always-on, no countdown.

**Per-faction contents (£9.99):**
- 1 faction-flavoured Warlord skin (lower tier than premium live-ops skins)
- 1 card-back themed to faction
- 1 board skin themed to faction's biome
- 600 gems
- 5 Faction Frame tokens (alt frame for any card in the faction; cosmetic per `faction_frames_v0.md`)

**Value perception:** comparable to £14-£18 of standalone content for £9.99.

### 4.4 Limited live-ops bundles

See §5 for templates.

### 4.5 Tier-skip / Pass+

Cross-reference `season_pass_v0.md` §4 (BP-4).

### 4.6 Subscription — Ascendant Pact (post-IMV-2)

Per HANDOVER §5 ("Subscription 'Ascendant Pact' £4.99/mo"). Spec'd here for completeness.

**£4.99/mo recurring:**
- 30 gems/day (=900 gems/mo equivalent; ~80% of the £9.99 Sack's value for half-price + recurring)
- Daily double-rewards toggle (run-end +100% gold + Bones)
- Sub-only banner frame + UI accent
- Free monthly Cursed-treatment claim (1 random)

**Anti-P2W audit:** all rewards are speed/cosmetic. No exclusive cards. No power.

**Soft launch:** ship without subscription. Light up in patch 1.2.

---

## 5. Live-ops bundles (SHOP-5)

4 template bundles. Live-ops layer triggers per-segment.

| Template | Trigger | Segment | Refresh | Anti-burnout |
|---|---|---|---|---|
| **Returner Bundle** | absent ≥ 14 days, return event | absent-returner | 1 per 90 days max | only 1 returner bundle in lifetime per absence-streak |
| **Whale Mountain** | spend ≥ £100 in 30 days, presented at next session | top 5% spend | 1 per 30 days | hard cap; no top-up if rejected |
| **Faction-War Reward Pack** | active during faction-war event window | all active players | every event | only purchasable during event; archived after |
| **Lapsed-Payer Last-Chance** | paid in past 60 days but not in past 30 | re-conversion | 1 per 60 days | offered exactly once per lapse |

### Returner Bundle (£2.99 / £9.99 / £19.99 — segmented by past LTV)
- £2.99 returner: 1 free paid Warlord rental for 24h + 200 gems + 100 Bones top-up
- £9.99 returner: above + permanent paid Warlord + Cursed-treatment of choice
- £19.99 returner: above + free season-pass Premium track unlock for current season

### Whale Mountain (£49.99)
- 8,500 gems (raw value > £49 Hoard; whale-only +13% bonus)
- 2 Ultimate-treatment selectors (player picks 2 cards to apply Ultimate to)
- 1 exclusive nameplate "Whose Name Even Hangs Lower"
- Daily double-rewards for 30 days

### Faction-War Reward Pack (£4.99, event-window only)
- 500 gems
- 1 random faction Warlord skin (player's contributing faction)
- 200 Marrow Shards
- 1 themed card-back

### Lapsed-Payer Last-Chance (£4.99)
- 800 gems (60% bonus vs same-price Pouch)
- 5 retry tickets
- 1 random Foil treatment token

---

## 6. Anti-pay-to-win audit + spend caps (SHOP-6)

Extends the 6 invariants in `monetisation_map.md` §"Anti-pay-to-win guardrails".

### Per-account spend caps

**Soft warning:** at £100 cumulative spend in any 30-day window, the next gem-purchase screen shows a one-time dismissible banner:
> _"You've spent £100 in the last month on Gallowfell. The curse never asked it of you."_

**Hard cap (opt-in / regional regulator-led):**
- Player can self-set a monthly cap in Settings (£0 / £25 / £50 / £100 / £250 / £500 / unlimited).
- UK + EU markets: the cap selector is presented during first IAP purchase as a 6-line modal; "Unlimited" is the default but tracked.
- Markets with regulated F2P (e.g. CN — though we don't ship there v1; Belgium, Netherlands): cap defaults to £250.

**Parental gate (under 18):**
- Store account birthdate < 18 ? Hard cap defaults to £25/mo and **cannot** be raised without parental email re-auth.
- Loot-box adjacent SKUs (gacha pulls) hidden from under-13 accounts entirely.

### Self-exclusion

- One-tap "Stop showing me purchase prompts" in Settings.
- 30-day cool-off available — disables all SKUs except subscription cancellation.

### Restated invariants (re-stated for clarity at the contract layer)

1. **No card is paid-exclusive.** Every card obtainable via play (run rewards, shop, gacha-shards, BP free track).
2. **No Warlord is gem-only.** All paid Warlords also reachable via Marrow Shards.
3. **No power-creep in BP exclusives.** BP-exclusive is cosmetic + shards only.
4. **Gacha is for cosmetics.** No gameplay-impact gacha.
5. **No PvP** removes the largest P2W pressure axis (per `gdd_v0.md`).
6. **Rewarded video never gates progress.**
7. **Booster cap ×3.0 server-side.** (Per `warlord_tiers_v0.md` §6.)
8. **Souls are no-IAP.** Pure earn-only currency.
9. **Spend caps surfaced.** Self-set or regulator-default.

---

## 7. Engine handoff

### 7.1 New resource classes

`game/src/data/sku.gd` — Resource:
```
@export var id: StringName
@export var display_name: String
@export var sku_kind: SkuKind  # ENUM: GEM_PACK / BUNDLE / SUBSCRIPTION / TIER_SKIP / GACHA_PULL
@export var price_anchor_usd: float
@export var contents: Array[SkuContentEntry]
@export var first_purchase_only: bool = false
@export var first_purchase_bonus: Array[SkuContentEntry]
@export var segment_gate: StringName = &""  # empty = all players
@export var window_start: int = 0  # unix
@export var window_end: int = 0    # 0 = no expiry
```

`game/src/data/sku_content_entry.gd` — Resource:
```
@export var content_kind: SkuContentKind  # GEMS / BONES / MARROW_SHARDS / CARD / WARLORD / TREATMENT / SKIN / CARD_BACK / BOARD_SKIN / BOOSTER_MULTIPLIER / RETRY_TICKET
@export var quantity: int = 1
@export var ref_id: StringName = &""  # e.g. warlord_id or treatment_id
@export var duration_days: int = 0    # for boosters / rentals
```

`game/src/data/shop_node_definition.gd` — Resource (for in-run shop):
```
@export var slots: Array[ShopSlotDefinition]
@export var reroll_cost: int = 25
@export var max_rerolls: int = 1
```

### 7.2 GameState extensions

```
# wallet
var wallet_gold: int = 0         # per-run, reset on start_run
var wallet_bones: int = 0        # persistent
var wallet_marrow_shards: int = 0  # persistent
var wallet_gems: int = 0         # persistent (already exists)
var wallet_souls: int = 0        # persistent

# spend tracking
var lifetime_spend_gbp: float = 0.0
var monthly_spend_gbp: float = 0.0  # rolling 30-day
var monthly_spend_cap_gbp: float = 0.0  # 0 = unlimited

# signals
signal currency_changed(currency: StringName, new_value: int)
signal sku_purchased(sku_id: StringName, contents_applied: Dictionary)
signal sku_offered(sku_id: StringName)  # for analytics
signal spend_cap_warning_shown()
signal spend_cap_hit()
```

### 7.3 Shop controller API

```
class_name ShopController
extends Node

func offer_in_run_shop(definition: ShopNodeDefinition) -> InRunShopOffer
func purchase_slot(offer: InRunShopOffer, slot_idx: int) -> bool  # returns false on insufficient gold
func reroll(offer: InRunShopOffer) -> bool
func purchase_sku(sku: Sku) -> SkuPurchaseResult  # routes to platform IAP SDK on Sku.sku_kind != IN_RUN
func close_offer(offer: InRunShopOffer) -> void
```

### 7.4 Save format additions

```
# game_save.json additions
"wallet": { "bones": int, "marrow_shards": int, "gems": int, "souls": int },
"spend": { "lifetime_gbp": float, "monthly_window_start_unix": int, "monthly_gbp": float, "cap_gbp": float },
"sku_history": { "<sku_id>": { "first_purchase_used": bool, "last_offered_unix": int } },
"subscription": { "active": bool, "next_renewal_unix": int, "tier": "ascendant_pact" }
```

### 7.5 IAP SDK abstraction

Per HANDOVER tooling table: **AppLovin MAX** for ads, **Apple StoreKit / Google Play Billing** for IAP. Engine wraps with a `PlatformBilling` autoload that exposes:

```
class_name PlatformBilling
extends Node

signal purchase_completed(sku_id: StringName, receipt: String)
signal purchase_failed(sku_id: StringName, reason: StringName)
signal purchase_restored(sku_id: StringName)

func purchase(sku_id: StringName) -> void  # async; emits signal
func restore_purchases() -> void
func query_localised_price(sku_id: StringName) -> String  # returns "£4.99" / "$4.99" / "€4.99"
```

Implementation = thin GDExtension wrappers per platform. iOS = StoreKit 2 with `Transaction.updates` listener. Android = Play Billing v6 with `PurchasesUpdatedListener`. **Test mode** flag in `project_config.md` routes through a sandbox stub for IMV-2 dev playtesting before SDK enable.

---

## 8. MVP coverage (cross-ref backlog phases)

| Surface | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| In-run shop node | — (no SHOP node in linear ch1 map) | ✅ | ✅ | ✅ | ✅ |
| Hub Storefront | — | wireframe-only | ✅ | ✅ | ✅ |
| Gem packs (single SKU) | — | ✅ | full 6-tier ladder | full | full |
| Starter Bundle | — | — | ✅ | ✅ | ✅ |
| Faction Set bundles | — | — | — | 1 of 5 | all 5 |
| Live-ops bundles | — | — | — | Returner only | all 4 templates |
| Subscription | — | — | — | — | ✅ (patch 1.2) |
| Spend cap UI | — | — | ✅ | ✅ | ✅ |
| Parental gate | — | — | ✅ | ✅ | ✅ |

---

## 9. Open questions for Paul

1. **Currency names — confirm.** Specifically: do you want "Bones" as the meta soft, or rename to e.g. "Marrow Salt" / "Funerary Coin"? "Bones" is on-tone but might overload with relic/lore meaning.
2. **Starter Bundle Warlord pick.** Recommend Vow-Broken Magus (cheapest, most novel). Alternative: Warden Caspar Voll (most distinct mechanically). Lock now.
3. **Subscription "Ascendant Pact"** — keep planned for patch 1.2, or drop entirely? F2P subscription gates are still polarising in 2026.
4. **Spend cap default for under-18.** £25/mo as default — too high, too low, or correct?
5. **Faction Set bundle Warlord skin** — does it require the player owning the Warlord already? Recommend: yes (skin is a topcoat, not an unlock). Cross-references variants Open Q (`variants_system_v0.md` §"Open questions").

---

## 10. Cross-references

- `monetisation_map.md` — player-journey diagram + booster registry (master). This doc = the contract/catalogue layer underneath.
- `season_pass_v0.md` — BP track contents + tier-skip economy.
- `variants_system_v0.md` — what cosmetics are sold + acquisition rules.
- `upgrade_trees_v0.md` — Ancestor Tree (Bones sink) + Ascension ladder.
- `2026-05-18_gallowfell_balance.md` — IMV-1 gem economy in-engine.
- `warlord_tiers_v0.md` §13 + §6 — booster registry + cap.
- `collection_ui_v0.md` — Collection screen storefront route.

— Controller, 2026-05-21
