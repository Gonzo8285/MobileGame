# Cosmetic Expansion v1 — The Curse of Gallowfell

_Authored 2026-05-25 by Controller (round 5). Extends `variants_system_v0.md` (alt-arts / Warlord skins / card-backs / boards / summon VFX / gacha banner) with the next wave of cosmetic vectors validated by Marvel Snap and the broader F2P card-game category. The Snap-economy lesson: cosmetic stack is the £40-100M ARR engine; depth + breadth on cosmetic surfaces is the whale-LTV ceiling. Tied to `theme_packs_system_v0.md` (new orthogonal axis above this stack)._

**Status:** v0 draft. **Anti-P2W invariant locked.** Pending Paul sign-off on Open Qs.

---

## 1. Recap — cosmetic surface stack (as of 2026-05-25)

| Layer | Source | Locked? |
|---|---|---|
| Theme pack (whole-deck or per-card re-skin) | `theme_packs_system_v0.md` | new this round |
| Alt-art variant | `variants_system_v0.md` §3 | yes |
| Warlord skin | `variants_system_v0.md` §4 | yes |
| Treatment shader (Foil / Gold / Ink / Prism / Cursed / Ultimate) | `variants_system_v0.md` §2 + `shader_stack_design.md` | yes |
| Faction frame | `faction_frames_v0.md` | yes |
| Card-back | `variants_system_v0.md` §5 | yes |
| Board / lane skin | `variants_system_v0.md` §6 | yes |
| Summon VFX | `variants_system_v0.md` §7 | yes |
| Nameplate / banner / title | `variants_system_v0.md` §8 + `upgrade_trees_v0.md` §5 | yes |

This doc adds **8 new vectors** orthogonal to the above. None overlap. Each has its own monetisation hook, technical effort estimate, and Marvel Snap reference where applicable.

---

## 2. New cosmetic vectors — 8

### 2.1 Card foils (deeper than treatment)

**What:** A separate finish layer that ships **on top of** the treatment shader. Five tiers: base / silver / gold / prismatic / rainbow-shimmer. Animation plays only on **card-played** moment (not idle).

| Tier | Visual | Animation |
|---|---|---|
| Base | matte print | none |
| Silver | brushed-metal edge highlight | 0.4s play-flash, sweep |
| Gold | metallic gold sweep | 0.6s play-flash, slow gold-bloom |
| Prismatic | rainbow refraction sweep | 0.8s play-flash, multi-axis prism |
| Rainbow shimmer | full-card animated rainbow | continuous on-play; 1.2s decay |

**Not the same as Treatment:** treatment changes the *card's appearance* (Foil/Gold sparkle ON the face). Foil-as-vector changes the *finish* layer — like a card's varnish. Treatment + foil compound: a Gold-treatment card with a Rainbow-Shimmer foil is *the maximum cosmetic flex* in the game.

**Acquisition:**
- Base = default.
- Silver = season pass premium tier 12, 14, 17 (3 random card-applies).
- Gold foil = £4.99 SKU for 5 picks; gacha banner drop (1.5%).
- Prismatic = £9.99 SKU for 3 picks; Pass+ tier 25 (1 pick).
- Rainbow shimmer = £14.99 SKU for 1 pick OR Ultimate-treatment SKU bundle.

**Effort:** **M** — adds one shader uniform + 5 animation paths per card. Render budget = 8ms per played card. Mobile-perf safe.

**Marvel Snap reference:** equivalent to Snap's "Foil" and "Prism" frame finishes. Snap monetised these as separate SKUs after treatments — replicable.

### 2.2 Card-frame variants (border treatments)

**What:** Same art, different **border treatment**. Already partly covered by faction frames; this extends to non-faction "vibe frames".

| Frame name | Visual |
|---|---|
| ash-charred | burnt edges, ember-glow corners |
| coven-vine | living thorn-vine wraps the border |
| iron-rivet | brass rivets at each corner, hammered-iron edge |
| pyre-bone | knuckle-bones at corners, candle-stub finials |
| gilded-mourning | thin gold filigree on black; tasteful |
| ragged-tabard | torn-cloth frame, bloodstain on one corner |
| reliquary-gold | jewelled-reliquary corners, stained-glass accent |
| oath-broken | each corner shows a snapped chain link |

**Total launch frames:** 8 non-faction + 5 faction-canonical = 13 frames. Players equip per-card (orthogonal to alt-art and theme pack).

**Acquisition:**
- 3 frames free (ash-charred + iron-rivet + gilded-mourning) at A1 mastery.
- 5 frames behind season-pass milestones (1/season + bonus).
- 5 frames in gacha banner pool (1% drop each).
- All frames also purchasable individually at 800 gems = ~£7.20.

**Effort:** **S-M** — frame assets are 1 PNG overlay per frame, no shader. Asset cost ~£40 per frame at AI-gen rate.

**Marvel Snap reference:** Snap's "Variant Frame" system — proven £4-12 per-frame whale spend.

### 2.3 Animated card states (idle micro-animation)

**What:** When a card is in hand (idle), subtle motion plays — banner flutters, smoke drifts, a candle flickers, water ripples. **Very subtle** — designed to not distract during play. Per-card opt-in cosmetic.

**Animation budget per card:** 0.5s loop, 60fps, ≤30kb sprite-sheet additional.

**Mobile-perf rule:** max 5 animated cards in hand simultaneously (we hold 5-7 cards) — render budget 12ms/frame. If 6th card in hand, oldest animated card pauses until played.

**Acquisition:**
- 1 animated state ships per art-complete theme pack (premium cards only).
- 50 cards Y1 get the animated treatment (mostly hero / legendary / boss-tier).
- £2.99 single-card "Animate This Card" SKU.
- Pass+ tier 30 reward = 1 chosen animated card.

**Effort:** **M-L** — requires 4-6 frame sprite-sheet per card commissioned in addition to the base art. Cost = +30% on top of canonical card commission.

**Marvel Snap reference:** Snap's "Animated" frame — historically the highest-LTV cosmetic finish (whales pay £15+ for one).

### 2.4 Play / death VFX (per-card and per-faction)

**What:** Special effect plays when a card **enters play** (placed on a lane tile) or **dies** (HP reaches 0). Distinct from Summon VFX (which is per-faction generic flash) and from in-combat damage VFX (which is hard-coded).

**Per-card VFX:** unique to that card, premium SKU. Examples:
- Pall-Bearer plays → black-bell tolls + smoke-puff
- Bramble Princess plays → thorny vines burst from tile, retract
- Whip Brother plays → blood-splatter on tile, brief drip
- Three Shadows plays → three shadowy figures coalesce, settle
- Sun-Bone Pharaoh plays → sand-storm whirl, bandage strips

**Per-faction VFX:** broader, lower price; sold as part of a faction theme pack OR Faction Set Bundle (`shop_economy_v0.md` §4.3).

**Acquisition:**
- 1 per-card VFX per Warlord ships with that Warlord (free).
- 5 cards per faction get the VFX treatment as part of Faction Set bundle.
- £3.99 single-card "Play VFX" SKU.
- Pass+ tier 45 reward = 1 chosen card VFX.

**Effort:** **M** — particle preset + sound trigger per VFX. Mobile budget = 30 particles, 0.6s, 8ms render. Cost = ~£50 per VFX commissioned.

**Marvel Snap reference:** Snap doesn't have this exact vector. It's a Hearthstone-derived premium hook — works because it makes whales feel their cards are *more visible* in matches.

### 2.5 Card-back deep-customise (per-back layered)

**What:** Goes beyond the 18 card-back launches in `variants_system_v0.md` §5. Each card-back has **layered customisation**:

| Layer | Examples |
|---|---|
| Pattern | herringbone / dotted / damask / runic / serpent-coiled |
| Colour | 8 palette presets per pattern (player picks) |
| Motif | central sigil (Hangman, Bell, Antler, Iron Cross, Wave, Bramble) |
| Animation | subtle border-glow, candle-flicker, rain-drift |
| Edge wear | crisp / weathered / soot-charred (3 wear states) |

**Result:** each player can build a near-unique card-back. ~3,400 combinations per pattern × 8 patterns = ~27,000 unique looks. Identity vector.

**Acquisition:**
- 1 pattern free (default).
- 3 patterns earned via Ascension A1/A6/A11.
- 4 patterns behind season pass (1/season).
- 1 colour palette per Faction Set bundle.
- Motif slots free (one per faction-mastery T4).
- Animation = £1.99 SKU per pattern.
- Edge-wear = free, player-selectable.

**Effort:** **S-M** — uses existing card-back shader, adds 3-4 colour-presets per pattern. The combinatorial breadth comes free from the shader.

**Marvel Snap reference:** Snap's card-back system. Snap monetised these well — players treat their card-back as their identity on the leaderboard.

### 2.6 Boards — dynamic time-of-day / weather + variant cadence

**What:** Already shipped 11 boards in `variants_system_v0.md` §6. This extends each board with **dynamic states**:

| State | Trigger | Effect |
|---|---|---|
| Time-of-day | tied to player-local clock (dawn / day / dusk / night) | board palette shifts subtly; sky changes |
| Weather | random per combat start (clear / rain / mist / storm / snow) | particle layer added; ambient SFX changes |
| Hanging-Hour state | turn 5 of combat fires | board ambient red-shift; bell-toll sting |

**Day-1 / Week-1 / Month-1 variants:** for high-engagement players, the boards visibly age — soot accumulates, banners fray, candles burn down. This is a **progression visualisation**, free, automatic — visible at week 1 and month 1 of player tenure on that board.

**Acquisition:**
- Time-of-day + weather: free, automatic on all owned boards.
- Hanging-Hour state: free, canonical mechanic visualisation.
- Day-1/Week-1/Month-1 wear states: free, automatic, identity-driven.
- "Reset board to pristine" SKU = 200 gems (£1.80 — for players who want clean boards back).

**Effort:** **M** — adds 4 time-of-day palette overlays + 5 weather particle layers + 3 wear states per board. Asset cost = ~£200 per board for the full state-set.

**Marvel Snap reference:** Snap doesn't do board ageing. This is a Gallowfell-distinctive vector — "your boards remember your runs". Lore-aligned with the cursed-town setting.

### 2.7 Avatar / portrait — poses + backgrounds + expressions

**What:** Extends Warlord skins from `variants_system_v0.md` §4. Each Warlord skin has:

| Layer | Count | What it does |
|---|---|---|
| Portrait pose | 3-5 per Warlord | different stance / weapon ready / arms folded / kneeling / standing-with-banner |
| Portrait background | 8 choices | per-faction biome backdrop swapped per-Warlord choice |
| Expression | 4-5 per Warlord | neutral / wrath / sorrow / contempt / pious-fervour |

Surfaces in: Warlord-select screen, in-combat HUD avatar bubble (top-left), social profile, PvP loadout card, leaderboard, friend-list.

**Acquisition:**
- 1 pose + 1 background + 1 expression per Warlord free (canonical).
- Additional poses unlocked via Ascension (1 per A1, A6, A11).
- Backgrounds: 3 free per faction; 5 paid (£0.99 each).
- Expressions: 2 free; 3 unlocked via card-mastery / boss-clear milestones.

**Effort:** **L** — 11 Warlords × 5 poses × 5 expressions × 8 backgrounds = ~2,200 portrait state-renders if fully populated. Realistic launch = canonical + 1 alt-pose + 2 backgrounds per Warlord = 44 assets. Asset cost per portrait = ~£60. Total ~£2,600 launch.

**Marvel Snap reference:** Snap's "Avatar" system. Snap monetised these as £4-6 SKUs in bundles.

### 2.8 Banners + titles + emotes

**What:** Three meta-game customisation vectors visible on the player profile, leaderboards, PvP, friend-list.

**Banner (background of your name-card):**
- 30 launch banners. Examples: "Tolled" (S1 free track), "Bell-Tide" (S1 premium), "Cathedral-Burned" (Ch1 boss clear), "Spoke the Name" (A20).
- Each banner = a flat colour-and-pattern strip with optional motif overlay.

**Title (text under your name):**
- 50 launch titles. Examples: "The Hangman's Witness", "Bell-Sworn", "Marrow-Bound", "Whose Name Hangs Lower".
- Earned via achievements, Ascension, season pass.

**Emotes:**
- 12 launch emotes. Toggleable in-combat (during your turn only, 2/turn cap). Visible to opponent in PvP / Ghost Duel.
- 4 free + 4 season pass + 4 paid.
- Emotes = a single-line text overlay + 0.4s sprite-flash:
  - "Bell tolls" — bell icon
  - "Marrow weeps" — black-tear icon
  - "Iron Vespers" — hammer icon
  - "Three Shadows watching" — three-dot icon
  - "I pray" — folded-hands icon
  - "I see you" — eye icon
  - "Hangman approves" — knot icon
  - "Cinder ash" — flame icon
  - "Bone laughter" — skull-laughing
  - "Coven knows" — moon icon
  - "Antler-bound" — antler icon
  - "Confessor heard" — broken-chain icon

**Anti-toxicity rule:** no negative emotes ("get rekt" / "lmao" / mocking-gestures). All emotes are flavour-positive or neutral. Emotes cannot be spammed (2/turn cap). Players can mute opponent emotes (per-game and per-account-default).

**Acquisition:**
- Banners: 6 free at account start; 4 per season; 5 in achievements; 5 in shop (£1.99 each); 10 in Ascension.
- Titles: 10 free at start; 15 in achievements; 12 in Ascension; 8 in season pass; 5 paid.
- Emotes: 4 free; 4 season pass; 4 paid (£2.99 each); plus 1 per gifted-friend reward.

**Effort:** **S** — banners + titles are text + sprite. Emotes need 12 sprite-flash anims. Total asset cost ~£800.

**Marvel Snap reference:** Snap's "Title" + "Avatar Frame" + emote system. Snap learned the anti-toxicity lesson the hard way; we ship it from day 1.

### 2.9 Battle cosmetics — VFX changes on combat actions

**What:** Players can customise the VFX of their combat actions — parry sparks, kill flourishes, draw-card flash, mana-tick particle, mulligan-shuffle anim.

| Action | Default VFX | Customisable to |
|---|---|---|
| Draw card | white-spark | ash / gold / bone / antler / iron / brass |
| Mana tick | candle-glow | bell-flash / coin-spin / antler-spark / cog-tick |
| Card played | tile-puff | feather-burst / soot-ring / blood-droplet / ember |
| Kill flourish | enemy-fade | bone-shatter / smoke-dissolve / coin-clatter / dust-burst |
| Mulligan | shuffle | bell-toll / smoke-veil / coin-flip / antler-strike |
| Hanging-Hour fires | bell-toll + red-shift | (system canonical; one alt = "silent bell" reveal mod, premium) |

**Effort:** **M** — particle preset + audio swap per action. Mobile budget per action = 4-6ms. Total launch asset cost = ~£600.

**Acquisition:**
- 1 alt per action free (mastery T3).
- 2 paid per action (£1.99 each).
- Pass+ tier 18 = 1 chosen action-VFX preset.

**Marvel Snap reference:** none direct — this is a Hearthstone-influenced premium hook.

---

## 3. Loot crate — explicit non-doctrine

**Stated for the record because the F2P category invites this question.** Gallowfell will **not** ship random-only loot boxes in their predatory form. Two reasons:

1. **UK CMA + EU regulation.** Belgium and Netherlands have effectively banned random-content paid loot crates. Apple/Google guidance requires drop rates disclosed. The risk-reward isn't favourable.
2. **Player trust.** Marvel Snap's Spotlight Caches (per `competitive_landscape_v0.md` §1.4) generated real consumer anger. The "I paid and didn't get what I wanted" experience is the single biggest reason players uninstall card games.

**What we ship instead — Transparent Grab-Bag:**

> A "Grab-Bag" SKU presents the player with **3 visible options** before purchase. Player picks 1. Pays the GBP price. Receives that one item. No randomness on the buy.

**Grab-Bag SKUs:**
- "Pick a Frame" — £2.99, player picks 1 of 3 visible frames.
- "Pick an Emote" — £2.99, player picks 1 of 3 visible emotes.
- "Pick a Card-Back" — £3.99, player picks 1 of 3 visible card-backs.
- "Pick a Foil for a Card" — £4.99, player picks 1 card from their collection + applies a Foil tier.

Refresh: grab-bag pool rotates weekly (Mon 04:00 local). No hidden items.

**Gacha banners (`variants_system_v0.md` §9) are kept** because:
- Drop rates are published.
- Pity system at 80 pulls.
- Vault re-purchase exists after 60 days (no permanent FOMO).
- Anti-P2W: only cosmetics in the pool.

The Grab-Bag is the **alternative entry-level cosmetic** for players who don't want gacha. Gacha remains for the cosmetic-collector whale segment who specifically enjoy that loop.

---

## 4. Cross-cutting monetisation hooks (summary)

| Vector | Lowest price | Highest price | Bundle play |
|---|---|---|---|
| Card foils | £4.99 (5 silver picks) | £14.99 (Rainbow Shimmer per card) | bundled into Ultimate-treatment SKU |
| Card-frame variants | 800g (~£7.20) per frame | full set 8 frames £14.99 | included in Faction Set Bundle |
| Animated card states | £2.99 per card | included in art-complete theme packs | Pass+ tier 30 = 1 free |
| Per-card play/death VFX | £3.99 per card | — | included in Faction Set Bundle |
| Card-back deep-customise | Free pattern/colour | £1.99 animation upgrade | included in season pass |
| Board dynamic states | Free | "Reset board" 200g | — |
| Avatar pose / background | £0.99 background | £4.99 pose | included in Warlord-skin SKU |
| Banners / titles / emotes | Free or £1.99 | £2.99 emote | season pass primary distribution |
| Battle cosmetics | £1.99 per action | — | Pass+ tier 18 = 1 free |

**Compounding lever:** the spreader-effect of Card foils + Frame variants + Animated states + Play/death VFX layered on the same card means the **per-card max LTV ceiling** rises from ~£15 (current variants spec) to ~£35-40. This is the Snap-ROI lesson — cosmetic stacking is multiplicative, not additive, in spend behaviour.

---

## 5. Effort summary table

| Vector | Effort | Asset cost (launch) | Render cost (mobile) |
|---|---|---|---|
| Card foils | M | £200 (5 finish shaders) | 8ms per played card |
| Card-frame variants | S-M | £320 (8 frames × £40) | <2ms (texture overlay) |
| Animated card states | M-L | £4,500 (50 cards × £90) | 12ms idle cap at 5 cards |
| Play / death VFX | M | £2,200 (~44 cards × £50) | 8ms per trigger |
| Card-back deep-customise | S-M | £600 (8 patterns + 64 palettes) | <2ms |
| Board dynamic states | M | £2,200 (11 boards × ~£200) | 4-8ms (weather particle) |
| Avatar pose / bg / expr | L | £2,600 (~44 portrait states) | <1ms (texture swap) |
| Banners / titles / emotes | S | £800 (anims + sprites) | <2ms |
| Battle cosmetics | M | £600 (5 actions × 2 alts) | 4-6ms per action |
| **Total launch asset cost** | | **~£14,000** | within mobile budget |

For comparison: a full art-complete theme pack is ~£25,000-30,000 commissioned. The full cosmetic expansion above ships for half the cost of one theme — but unlocks ~10× the cosmetic SKU surface area.

---

## 6. MVP coverage

| Surface | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| Card foils | — | — | spec only | 3 of 5 tiers | full 5 tiers |
| Card-frame variants | — | — | — | 5 frames | 13 frames |
| Animated card states | — | — | — | 10 cards animated | 50 cards |
| Per-card play/death VFX | — | — | — | 22 cards (Warlord set + 11 boss) | 44 cards |
| Card-back deep-customise | — | — | base patterns | + customise UI | + animation tier |
| Board dynamic states | — | placeholder | time-of-day + weather | + wear states | + Hanging-Hour state |
| Avatar pose / bg / expr | — | canonical only | + 1 alt pose per Warlord | + 8 backgrounds | full set |
| Banners / titles / emotes | — | — | titles only | + 6 banners + 8 emotes | full set |
| Battle cosmetics | — | — | — | draw + mana | all 5 actions |
| **Grab-Bag SKUs** | — | — | — | 4 Grab-Bag rotations live | weekly rotation |

---

## 7. Open questions for Paul

1. **Animated card states cap.** Recommend max 5 simultaneous (matches hand-size). Drop to 3 if mobile perf testing fails on RTX 2050-equivalent.
2. **Emote toxicity policy.** Recommend ship with 12 launch emotes, all flavour-positive. Confirm: any emote you'd add or remove? Or shall we reserve "tilted" / "frustrated" for v1.1 community-requested?
3. **Grab-Bag pool depth.** 4 SKUs at launch (Frame / Emote / Card-Back / Foil). Recommend keeping it small to validate purchase behaviour before expansion. Lock at 4?
4. **Animated card commission priority order.** Recommend hero/legendary cards first (visible most often) — 5 per faction = 25 cards as the soft-launch ship target, then ~50 by v1.0. Confirm.
5. **Avatar background paid-vs-free split.** 3 free + 5 paid per faction. Confirm — or invert to 5 free + 3 paid (more generous, lower revenue).

---

## 8. Cross-references

- `variants_system_v0.md` — the cosmetic stack this doc extends.
- `theme_packs_system_v0.md` — orthogonal new top-layer; theme packs do not replace the vectors here.
- `shop_economy_v0.md` + `shop_economy_v2.md` — IAP routing, currency exchange, regional pricing.
- `season_pass_v0.md` + `season_pass_v2.md` — Pass+ distribution channel for many vectors here.
- `competitive_landscape_v0.md` §1.4 — Marvel Snap cosmetic-economy lesson; §1.4 anti-gacha rule.
- `shader_stack_design.md` — treatment shader stack; foil layer rides on top.
- `monetisation_map.md` §5 — primary cosmetic monetisation framing.
- `art_pipeline_readiness_v0.md` — commission rates basis for asset-cost estimates.

— Controller, 2026-05-25
