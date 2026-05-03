# G8 — Monetisation surface map

_Drafted 2026-04-30 by heartbeat. One diagram, plus a breakdown of every paid touchpoint and where it sits in the player journey. MVP markers show what ships day-one vs post-soft-launch._

## Player-journey diagram (Mermaid)

```mermaid
flowchart TD
    A[App Launch] --> B[Home / Hub]
    B -->|"$ STORE: gem packs, starter bundle, BP"| B
    B -->|"$ WARLORD UNLOCK: gems or meta-currency"| C[Pick Warlord & Faction]
    C --> D[Draft Starting Deck<br/>12 cards]
    D --> E[Run Map<br/>16 nodes / 4 acts]

    E --> F[Battle Node<br/>8-12 waves TD]
    E --> G[Elite / Boss]
    E --> H[Shop Node<br/>$ in-run gold sink]
    E --> I[Event / Shrine]

    F -->|Win| J[Reward Pick<br/>card / gold / relic]
    G -->|Win| J
    F -->|"DEFEAT: AD CONTINUE (rewarded video, 1x per run)"| F
    G -->|"DEFEAT: AD CONTINUE (rewarded video, 1x per run)"| G

    J --> E
    J -->|"OPTIONAL: AD 2x REWARDS"| J

    E -->|Run end:<br/>death or final boss| K[Run Summary]
    K -->|"OPTIONAL: AD 2x META XP"| K
    K --> L[Meta Progression]

    L -->|"$ BATTLE PASS premium track unlock"| L
    L -->|"BP claim: free + premium rewards"| L
    L -->|"$ COSMETIC SKINS for Warlords / boards"| L
    L -->|"DAILY CHEST (1x free, ad-gated 2nd)"| L
    L -->|"$ GACHA pull (gems) + AD bonus pull"| L
    L -->|"ENERGY refill (gems or ad), if energy is on"| L

    L --> B

    M[Live Ops Layer<br/>rotating events, faction wars,<br/>returner bundles, limited skins]
    M -.-> B
    M -.-> L
```

## Surface-by-surface breakdown

### 1. Gem currency (hard currency)
- **Where:** Home/Hub store tab, plus contextual offers (out-of-energy popup, gacha pull short, BP-tier skip).
- **Price ladder (USD anchor — localise per market):** $0.99 / $4.99 / $9.99 / $19.99 / $49.99 / $99.99. First-purchase doubler on the $4.99 SKU.
- **MVP:** No. Post-soft-launch.

### 2. Starter bundle (one-time, $4.99)
- **Where:** Pops once on Day 2 in the Hub. Single SKU, never repeats.
- **Contains:** 1 paid Warlord (cheapest of the 5), gem stack, 7-day XP boost.
- **Why it works:** Anchors the price ladder, converts D2 retained users into payers cheaply, gives flavour-of-paid-content without pay-to-win.
- **MVP:** No. Add at first commercial pass (post-soft-launch).

### 3. Weekly bundles (rotating)
- **Where:** Store tab, refreshes Mondays. 2–3 SKUs at $1.99 / $4.99 / $9.99.
- **Contents tilt:** cosmetic-heavy + gems. Never raw card power.
- **MVP:** No.

### 4. Warlord unlocks
- **Where:** Pick-Warlord screen + Hub roster. 5 free Warlords from launch, 5 paid (G9).
- **Two paths per paid Warlord:**
  - **Gems** (instant, $4.99-equivalent each).
  - **Meta-currency grind** (Marrow Shards, ~10–15 hours of play). Keeps non-payers progressing.
- **MVP:** Only 3 free Warlords playable. No paid Warlords yet.

### 5. Cosmetic skins
- **Where:** Hub > Warlord screen, and BP premium-track rewards. Pure cosmetic — Warlord re-skins, board skins, card-back frames, summon VFX recolours.
- **Pricing:** $2.99 common skin, $9.99 epic, $14.99 legendary. Limited skins via live-ops only.
- **MVP:** No.

### 6. Battle Pass (30-day season, "Marrow Pass")
- **Where:** Permanent BP tab, persistent banner on Hub.
- **Structure:** 50 levels, dual track (free + premium). Premium = $4.99/season. "Pass+" tier at $9.99 grants +10 instant levels and an exclusive skin.
- **Free track:** card unlocks, gold, single cosmetic.
- **Premium track:** gems, paid-Warlord shards, epic/legendary skins, BP-exclusive card frames.
- **Earn rate tuning target:** finishable in ~25 days at 1 hr/day to leave urgency without rage-gating.
- **MVP:** No. Ship at first commercial pass.

### 7. Energy (provisional — A/B test on/off)
- **Where:** Run-start gate. 5 charges, 1 charge per run-start, 30-min refill.
- **Refill paths:** gems ($0.99-equivalent), single rewarded-ad refill per day, full refill in starter bundle.
- **Decision:** Default OFF for soft-launch (modern midcore trend). Revisit only if D7 retention is high but ARPDAU is dead.
- **MVP:** No.

### 8. Rewarded video — placement rules
Strict cap: max 5 rewarded-ad views per session, max 8 per day. Frequency-cap helps eCPM.

| # | Trigger | Reward | MVP? |
|---|---------|--------|------|
| 1 | Continue-after-defeat (1x per run) | Resume battle at 25% HP | No |
| 2 | 2× run rewards on run-end summary | Double XP + gold | No |
| 3 | 2× reward on card-pick screen (1x per run) | Pick 2 of 3 instead of 1 of 3 | Possible MVP |
| 4 | Free daily chest (always-on) | Gold + small card-shard pull | **MVP yes** |
| 5 | Bonus gacha pull after a 10x | One free 1x | No |
| 6 | Energy refill (if energy is on) | Full refill, 1x/day | N/A unless energy on |

### 9. Gacha / shard summon
- **Where:** Hub > Summon tab. Pulls give card duplicates → shards → unlock new cards. **No card power locked behind gacha** — every card also obtainable via run rewards. Gacha is a *speed* lever, not a *power* lever.
- **Cost:** 100 gems / pull, 900 gems / 10x. Pity at 80 pulls.
- **MVP:** No.

### 10. In-run shop (soft sink, no real-money)
- **Where:** Shop nodes inside a run, paid in run-gold.
- **Why it matters:** keeps run economy interesting and creates demand pressure that *justifies* meta-currency without forcing IAP. **Pure design lever; no $$$.**
- **MVP:** **Yes.**

### 11. Daily reward calendar
- **Where:** Auto-popup on first daily login. 7-day loop, 28-day super-loop, BP XP on every claim.
- **MVP:** Lite version — single daily chest, no calendar UI yet.

### 12. Live-ops bundles (returner / event / faction war)
- **Where:** Push-driven banners on Hub. Limited-time offers gated to player segment (returner = absent 14+ days, whale = top 5% spend, etc.).
- **MVP:** No.

## Anti-pay-to-win guardrails (design constraint, do not break)

1. Every card and every Warlord is reachable via play, even if slowly. Gems = speed only.
2. No power-creep cards locked to BP or gacha. BP-exclusive content is cosmetic + duplicate cards (shards).
3. No energy in launch build (default off).
4. No PvP — removes the largest pay-to-win pressure entirely (per Paul's design constraint, GDD line 71).
5. Rewarded video never gates progress, only accelerates it.

## What's in MVP vs later

| Surface | MVP (first internal build) | Post-soft-launch |
|---|---|---|
| Run-shop (gold sink) | ✅ | — |
| Daily chest (1× rewarded ad) | ✅ | — |
| Gold IAP (single SKU) | ✅ | full ladder |
| Warlord unlocks (paid) | — | ✅ |
| Cosmetic skins | — | ✅ |
| Battle Pass | — | ✅ |
| Gacha | — | ✅ |
| Energy | — | A/B test only |
| Live-ops bundles | — | ✅ |
| Starter bundle | — | ✅ (Day 2 trigger) |

## Open questions for Paul

1. **Confirm no-energy launch?** (GDD already flags this; restating to lock it.)
2. **Battle Pass price tier** — happy with $4.99 standard / $9.99 Pass+? (Industry-standard, but worth your call.)
3. **Cosmetic-only paid Warlord variants** — would you ever sell a "skinned" Warlord ($14.99) on top of unlocking the base Warlord, or one-and-done?
4. **Geo-priced ladders** — auto-localise via store, or hand-tune top 5 markets? (Auto is fine for soft-launch.)
