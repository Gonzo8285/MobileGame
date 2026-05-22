# Variants system v0 — The Curse of Gallowfell

_Authored 2026-05-21 by Controller. Closes inventory items VAR-1..6. Extends `monetisation_map.md` §5 (which named the Snap-style card-treatment system as primary cosmetic surface) by adding alt-arts, Warlord skin pools, card-backs, board skins, summon-VFX skins, and the variant-gacha banner system. **The cosmetic ceiling for whale LTV.**_

**Status:** v0 draft. **Anti-P2W invariant locked.** Pending Paul sign-off on Open Qs.

---

## 1. Cosmetic surface taxonomy

Each cosmetic surface is one of these orthogonal axes. Per-card or per-Warlord or per-account.

| Surface | Scope | Already spec'd? | This doc |
|---|---|---|---|
| Card treatment (Default / Foil / Gold / Ink / Prism / Cursed / Ultimate) | per-card | yes — `collection_ui_v0.md` + `shader_stack_design.md` + `game/data/treatments/` | recap §2 |
| Faction frame | per-card | yes — `faction_frames_v0.md` | recap §2 |
| **Alt-art variant** | per-card | no | §3 (VAR-1) |
| **Warlord skin (beyond mastery)** | per-Warlord | partial — only mastery skin per-Warlord | §4 (VAR-2) |
| **Card-back** | per-account (equipped) | no | §5 (VAR-3) |
| **Board skin (lane backgrounds)** | per-account (equipped) | no | §6 (VAR-4) |
| **Summon VFX** | per-faction | no | §7 (VAR-5) |
| Sigil glyph | per-faction | yes — `art_specs/_sigils.md` | n/a — fixed identity |
| Nameplate / banner / title | per-account (equipped) | partial — earned via Ascension + season pass | §8 |

---

## 2. Card treatments (recap of existing spec)

Already locked. Recapped here for cross-reference.

| Treatment | Effect | Acquisition | Price |
|---|---|---|---|
| Default | base frame | free | — |
| Faction frame (×5) | per-faction re-styled base | faction-loyalty milestones | free, 1/faction |
| Foil | static sparkle | gacha + low IAP | £2.99 |
| Gold | metallic gold | mid IAP + season pass | £9.99 |
| Ink | monochrome alt-art | season pass premium-only | £14.99 |
| Prism | rainbow-shimmer animated | high IAP + BP+ | £19.99 |
| Cursed (limited) | green-pyre HH event | season pass premium hero slot or 14-day event SKU | £14.99 ltd |
| Ultimate | Gold + Prism + animated sheen | whale-tier IAP | £49.99 |

Per `monetisation_map.md` §5 and `shader_stack_design.md`. Engine: `CardInstance.treatment_id` per `card_treatment.gd`. Treatment is cosmetic-only (anti-P2W invariant); never read by combat code.

**Cross-references in this doc:** treatments × alt-arts compound (3 alt-arts × 7 treatments = 21 versions per card per VAR-1).

---

## 3. Alt-art variant system (VAR-1)

### 3.1 Premise

> Each card has up to **3 alt-art slots** beyond the canonical art. Alt-arts are independent of treatments — you can have a Gold-treatment on the Pall-Bearer's "Bell-Watch" alt-art, the Pall-Bearer's "Court-Funeral" alt-art, or the canonical art. **3 alt-arts × 7 treatments = 21 unique cosmetic versions per card.**

The alt-art is the per-card "season skin" of card-treatment cosmetics. Big content vertical for AI art pipeline; modest art-spend per alt-art.

### 3.2 Slot count rules

| Card rarity | Alt-art slots | Notes |
|---|---|---|
| Common | 1 alt-art only | keeps Common-volume art spend bounded |
| Uncommon | 2 alt-arts | mid-investment |
| Rare | 3 alt-arts | full slot count |
| Epic / Legendary | 3 alt-arts | full slot count |

**Total launch budget:**
- Per-faction: 24 Commons × 1 + 12 Uncommons × 2 + 4 Rares × 3 = **60 alt-art slots per faction**
- 5 factions × 60 = **300 alt-art slots total** for launch
- Plus 11 Warlord alt-arts (1 per Warlord) = **311 launch alt-art slots**

Realistic Y1 fill rate: ~120 alt-arts authored = 40% slot fill. Holds high perceived "still discovering content" for Y1 collectors.

### 3.3 Acquisition paths

| Path | Frequency | Cost |
|---|---|---|
| **Season pass** (premium track) | 2-3 per season | included with £4.99 BP |
| **Treatment gacha** (alt-art pull) | each pull = 1 random alt-art | 100 gems / pull (per `monetisation_map.md` §9) |
| **Card mastery** Tier 4 "Cherished" | 1 per card at 200 plays | free, earned |
| **Event reward** (limited) | 1-2 per event | event-quest completion |
| **Pre-order / launch bundle** | 1 per faction | one-off launch SKU |

**Hard rule:** alt-art **never gates gameplay**. Equipped alt-art changes the displayed art only. Combat code reads `Card`, not `CardInstance.alt_art_id`. (Already enforced in `card_instance.gd` per T1.)

### 3.4 Alt-art naming convention

Alt-art has a per-card slot ID + a thematic name:

| Slot | Theme convention | Example |
|---|---|---|
| `alt_1` | season-skin (rotates by season theme) | "Bell-Watch" (S1 Bell-Tide), "Soot-Drill" (S2 Soot Vigil) |
| `alt_2` | faction-deep-cut (lore-flavoured) | "Court-Funeral", "Cathedral Sermon" |
| `alt_3` | crossover (cross-faction or boss-themed) | "Bound-by-Bargain" (Coven × Penitents) |

### 3.5 Aesthetic guardrails

- Alt-art must read as the *same character/spell/trap* — silhouette + key identifying feature preserved.
- Frame compatibility: alt-arts must work with all 7 treatments + all 5 faction frames (so 35 visual combinations).
- Style consistency: alt-arts use the same LoRA stack as the canonical art (per `pipeline_spec.md` §2.2).
- File spec: same 832×1166 canvas as canonical per `art_direction.md`.
- AI-gen friendly: subject description in `art_specs/<faction>/<card>/<alt_slot>.md` follows the canonical `_template.md` pattern.

### 3.6 Engine handoff

```
class_name CardArtVariant extends Resource

@export var card_id: StringName  # FK to Card.id
@export var slot: StringName  # "canonical" / "alt_1" / "alt_2" / "alt_3"
@export var theme_name: String  # "Bell-Watch"
@export var art_path: String   # "res://game/art/cards/m20_pall_bearer/alt_1_bell_watch.png"
@export var acquisition_source: StringName  # "season_pass" / "gacha" / "mastery_t4" / "event" / "launch"
@export var season_tied: StringName = &""  # if season-exclusive

# In CardInstance (already exists per T1)
# var alt_art_id: StringName = &"canonical"
```

Collection chooser already references alt-arts per `collection_ui_v0.md` §"treatment chooser" — extend to show alt-art row above treatment row.

---

## 4. Warlord skin pool beyond mastery (VAR-2)

### 4.1 Per-Warlord skin runway

Each Warlord gets **4 skin slots** in Y1:

| Slot | Acquisition | Cost | Per-Warlord example (Vyrrun) |
|---|---|---|---|
| 1 | **Mastery T4** (per `warlord_tiers_full.md`) | free, earned | "The Flayed Sermon" |
| 2 | **Cursed-event one-shot** (live-op, 14-day window) | event participation OR £14.99 SKU | "The Wax-Sealed Mask" (Cursed-Bell event) |
| 3 | **Paid live-ops** (limited-time bundle) | £14.99 stand-alone, or in Faction Set bundle £9.99 | "The Pilgrim Returned" |
| 4 | **Seasonal hero** (one Warlord per season gets the hero-skin treatment per `season_pass_v0.md` §2.3) | £4.99 BP Premium OR £9.99 Pass+ | (S1 = Sieren; Vyrrun's slot at S2 not S1) |

**5 free + 5 paid + 1 lore-locked = 11 Warlords × 4 skin slots = 44 skin assets Y1 max.**

Realistic Y1 ship: 22 skins authored (mastery × 11 + 11 paid distributed across 4 seasons). 50% fill rate.

### 4.2 Skin scope

Each skin = full Warlord portrait re-render + idle-animation re-render. Per `warlord_tiers_full.md`, mastery skins are already spec'd. Paid/event skins follow same composition spec.

**Skin asset:**
- Full portrait (per `art_specs/warlords/<warlord>.md` composition tier "warlord_signature")
- 4-frame idle loop (per `art_direction.md` §3)
- Card-art version (re-derived from portrait for in-game card)
- Display-name + 1-line lore flavour

### 4.3 Skin equip mechanics

- Per-account, per-Warlord: one skin equipped at a time.
- Equipped skin shows in Warlord-select grid + in combat HUD.
- Owned but un-equipped skins live in `Collection > Warlord Skins`.
- **Anti-P2W invariant:** skin grants ×1.05 XP multiplier per `monetisation_map.md` §13 (stacks toward ×3.0 cap). Earned mastery skin counts identically — no advantage from paid.

### 4.4 Faction Set bundle Warlord skin (per `shop_economy_v0.md` §4.3)

The Faction Set bundle includes 1 Warlord skin per faction. **Resolution of Open Q**: skin requires the player to **own the Warlord** to equip. Bundle delivers the asset; equip is gated on Warlord ownership. Cosmetic-without-ownership is incoherent.

### 4.5 Engine handoff

```
class_name WarlordSkin extends Resource

@export var id: StringName        # "vyrrun_flayed_sermon"
@export var warlord_id: StringName  # "vyrrun"
@export var display_name: String  # "The Flayed Sermon"
@export var flavour_text: String  # 1-line lore
@export var slot_kind: StringName  # "mastery" / "cursed_event" / "paid_liveop" / "season_hero"
@export var portrait_path: String
@export var idle_anim_path: String
@export var card_art_path: String
@export var acquisition_source: StringName  # "tier_4" / "event_<id>" / "bundle_<id>" / "season_<id>" / "vault"
@export var booster_multiplier: float = 1.05
```

`GameState`:
```
var equipped_warlord_skins: Dictionary  # { warlord_id: skin_id }
var owned_warlord_skins: Array[StringName]

signal warlord_skin_equipped(warlord_id, skin_id)
signal warlord_skin_acquired(skin_id, source)
```

---

## 5. Card-back skins (VAR-3)

### 5.1 Premise

The card-back is the visible-to-other-players surface even in PvE (per `collection_ui_v0.md` references). For PvE: visible during draw animation, during opponent reveal (if asynchronous boss-event leaderboard), in collection-share.

### 5.2 Launch card-back catalogue

| Slot | Name | Acquisition |
|---|---|---|
| 1 | "Plain Black" | free, default |
| 2 | "Cathedral Red" (Iron Penitents) | Faction Set bundle (Penitents) OR play-50-runs-with-Penitents |
| 3 | "Court Bone" (Ash-Mourners) | Faction Set bundle OR play-50-runs |
| 4 | "Bog Coin" (Coven) | Faction Set bundle OR play-50-runs |
| 5 | "Foundry Iron" (Last Legion) | Faction Set bundle OR play-50-runs |
| 6 | "Antler Bark" (Skinward Pact) | Faction Set bundle OR play-50-runs |
| 7 | "Bell-Tide" (S1 free track hero) | Season 1 free track tier 5 |
| 8 | "Black-Bell Boss" (S1 premium tier 40) | Season 1 premium track tier 40 |
| 9 | "Brass Reliquary" | Pre-order / launch bundle |
| 10 | "Hangman's Knot" | A11 completion any Warlord (free, earned) |

### 5.3 Per-season card-back

Each new season adds **1 free-track card-back + 1 premium-track card-back** to the catalogue. Y1 total = 10 launch + 8 season = 18.

### 5.4 Equip & display

- Per-account, single card-back equipped.
- Equip menu: Collection > Card-Backs.
- Display: deck draw animation back-of-card, opponent boss async-reveal, leaderboard avatar accent.

### 5.5 Engine handoff

```
class_name CardBack extends Resource

@export var id: StringName
@export var display_name: String
@export var art_path: String  # 832×1166 same as card frame
@export var acquisition_source: StringName  # "default" / "faction_play_50" / "bundle_<id>" / "season_<id>" / "vault"
@export var season_tied: StringName = &""
```

`GameState`:
```
var equipped_card_back: StringName = &"plain_black"
var owned_card_backs: Array[StringName] = [&"plain_black"]
```

---

## 6. Board / lane-art skins (VAR-4)

### 6.1 Premise

Board skin = the 3-lane background rendered behind units during combat. Per `combat.tscn` placeholder = solid colour; production = parallax painterly background per `art_direction.md`.

### 6.2 Launch board catalogue

5 launch boards, one per faction biome.

| Board | Biome | Acquisition |
|---|---|---|
| "Cathedral Ruins" | Iron Penitents biome | free, default — used when playing Penitents |
| "Catacombs" | Ash-Mourners biome | free, default — used when playing Ash-Mourners |
| "Black Mire" | Coven biome | free, default — used when playing Coven |
| "Foundry" | Last Legion biome | free, default — used when playing Last Legion |
| "Cinderwood" | Skinward Pact biome | free, default — used when playing Skinward Pact |

**Default rule:** board art rotates per-Warlord faction. So if I play Sieren, I see Catacombs. This is FREE — biome boards are the canon-look.

### 6.3 Paid / earned boards (live-ops add to catalogue)

| Board | Theme | Acquisition |
|---|---|---|
| "Bell Cathedral" (S1 hero board) | Bell-Tide theme | Season 1 premium track tier 15 |
| "Cold Furnace" (S2 hero board) | Soot Vigil theme | Season 2 premium track tier 15 |
| "Demon-Coin Pool" (S3 hero board) | Mire-Bargain theme | Season 3 premium track tier 15 |
| "Cinder-Crown" (S4 hero board) | Cinder-Crown theme | Season 4 premium track tier 15 |
| "Gallows Hill" (boss board) | Boss biome | Beat campaign with any Warlord at A1+ (free, earned) |
| "The Vault" | Lore-deep cosmetic | Owned only by W11-unlocked players, sold via Vault tab post-S4 for 8,000 gems |

Y1 total = 5 free + 4 seasonal + 1 earned + 1 prestige = **11 boards.**

### 6.4 Equip rule

- Default: rotates per-Warlord faction.
- **Override mode**: Settings toggle "Always use equipped board" — selects a single board for all runs (per-account preference).
- Equip menu: Collection > Board Skins.

### 6.5 Engine handoff

```
class_name BoardSkin extends Resource

@export var id: StringName
@export var display_name: String
@export var biome_id: StringName  # "cathedral_ruins" / "catacombs" / etc.
@export var faction_id: StringName  # default-association faction; empty for non-faction
@export var background_image_path: String  # 1080×1920 portrait
@export var parallax_layers: Array[String]  # 3 layer paths (sky / mid / fore)
@export var acquisition_source: StringName
```

`GameState`:
```
var equipped_board_override: StringName = &""  # empty = per-Warlord auto
var owned_board_skins: Array[StringName]
```

`Combat.scene`:
```
@export var lane_background: BoardSkin  # populated at combat-start from GameState
```

---

## 7. Summon-VFX skins (VAR-5)

### 7.1 Premise

When a unit is summoned to a lane tile, a VFX flash plays (per `gfx_5` status overlay note). Default VFX = faction-coloured smoke puff. Players can equip a **per-faction VFX preset** that swaps the summon flash.

### 7.2 Launch VFX preset catalogue

4 VFX presets per faction × 5 factions = **20 VFX presets**.

| Faction | Default | Alt 1 | Alt 2 | Alt 3 |
|---|---|---|---|---|
| Iron Penitents | "Brass Sparks" (default, free) | "Wax-Drip" (mastery) | "Blood-Mist" (paid) | "Hammerfall" (seasonal) |
| Ash-Mourners | "Court-Smoke" (default, free) | "Raven-Burst" (mastery) | "Ink-Bloom" (paid) | "Bell-Echo" (seasonal) |
| Coven | "Bog-Bubble" (default, free) | "Demon-Coin Flash" (mastery) | "Three-Shadows" (paid) | "Hex-Glow" (seasonal) |
| Last Legion | "Forge-Spark" (default, free) | "Banner-Wave" (mastery) | "Drum-Beat" (paid) | "Iron-Pour" (seasonal) |
| Skinward Pact | "Antler-Glow" (default, free) | "Pelt-Shed" (mastery) | "Cinder-Smoke" (paid) | "Wyrm-Coil" (seasonal) |

### 7.3 Acquisition

| Source | Frequency |
|---|---|
| Default (free) | per-faction, always available |
| Mastery alt (free) | unlock per-faction by playing 25 runs as that faction's Warlord |
| Paid alt | £4.99 SKU per VFX OR Faction Set bundle inclusion |
| Seasonal alt | season-tied per `season_pass_v0.md` |

### 7.4 Tech budget

VFX preset = particle preset + shader uniform. **Mobile-perf budget:** max 30 particles per summon flash, ≤8 ms render time on RTX 2050-class equivalent (per Paul's hardware ref). Per-faction preset authored as Godot `.tres` particle system + 1 fragment shader.

### 7.5 Engine handoff

```
class_name SummonVFX extends Resource

@export var id: StringName
@export var display_name: String
@export var faction_id: StringName
@export var particle_preset_path: String
@export var shader_path: String
@export var duration_seconds: float = 0.6
@export var acquisition_source: StringName
```

`GameState`:
```
var equipped_summon_vfx: Dictionary  # { faction_id: vfx_id }
var owned_summon_vfx: Array[StringName]
```

`Combat.gd` summon-handler:
```
func on_unit_summoned(unit: UnitInstance, tile: int) -> void:
    var vfx_id = GameState.equipped_summon_vfx.get(unit.card_data.faction, _default_for(unit.card_data.faction))
    VFXPool.play(vfx_id, tile_position(tile))
```

---

## 8. Nameplates / banners / titles

Earned via Ascension + season pass + lore unlocks. Already partially covered in `upgrade_trees_v0.md` §5 — Ascension rewards. Listed here for completeness:

| Slot | Source | Examples |
|---|---|---|
| Nameplate | A11 / A20 completion | "Mastered: Penance-Captain", "The Curse Itself" |
| Banner-frame | Season pass tier 1 | "Bell-Tide", "Soot Vigil" |
| Title | A20 + Ancestor T4 | "Spoke the Name", "Closed the Gate" |

No additional engine spec — these slot into existing `WarlordAscension.completion_rewards` (per `upgrade_trees_v0.md` §7.1) and `SeasonPassTier.rewards`.

---

## 9. Variant rarity, drop weights, gacha banner mechanics (VAR-6)

### 9.1 Treatment-gacha banner

Per `monetisation_map.md` §9 — gacha is for cosmetics. Banner-based pull system.

**Pull cost:**
- 1× pull = 100 gems
- 10× pull = 900 gems (10% discount)
- 80-pull pity guaranteed: any 80 pulls without a "featured" hit → 81st pull guaranteed featured

**Banner composition:**
- 1 banner active at a time
- 4-week rotation (1 banner per season-quarter)
- Banner has 1 "featured" treatment + alt-art (4-8× drop rate vs general pool)
- General pool = all owned-faction cards × all 7 treatments + all alt-arts

**Per-pull odds:**

| Tier | Drop rate | Notes |
|---|---|---|
| Common alt-art (own faction) | 50% | Modest novelty drop |
| Faction Frame token | 20% | Useful applies |
| Foil treatment token (random card) | 15% | Most-used premium treatment |
| Gold treatment token (random card) | 8% | Mid-prestige |
| Ink treatment (random card) | 4% | High-prestige |
| Prism treatment (random card) | 2% | Banner-rare |
| Featured treatment + alt-art | 1% | Banner exclusive |

Pulls **never** yield duplicates of an already-owned alt-art slot — re-rolls within the tier. Treatments stack (Foil-on-card-X already owned? Convert to 5 Marrow Shards).

### 9.2 Banner rotation calendar (Y1)

| Banner | Theme | Window | Featured |
|---|---|---|---|
| B1 "Bell-Tide" | S1 launch | wks 1-4 | Sieren "Bell That Sang First" skin alt-art + "Bell-Watch" Pall-Bearer alt-art |
| B2 "Soot Vigil" | S1 mid | wks 5-8 | Veska "Cold Furnace Resumed" skin alt-art + "Drill-Vow" Veska alt-art |
| B3 "Mire-Bargain" | S2 launch | wks 9-12 | Eddra alt-art + "Three-Shadows" VFX preset |
| B4 "Cinder-Crown" | S2 mid | wks 13-16 | Mhar "God-Tree's Heir Bloomed" skin alt-art |
| B5 "Brass-Crowned" | S3 launch | wks 17-20 | Whelp paid alt-art |
| B6 "Court-Funeral" | S3 mid | wks 21-24 | Sieren second alt-art + "Court-Smoke" alt VFX |
| B7 "Last Confession" | S4 launch | wks 25-28 | Confessor alt-art |
| B8 "Hangman's Knot" | S4 mid | wks 29-32 | W11 hint-art + "Bell-Echo" alt VFX |

Banners ≥ B9 = Y2 planning slot.

### 9.3 Vault re-purchase mechanic

Past-banner featured drops enter the "Vault" tab in Hub Storefront 60 days after banner closes. Vault prices:
- Featured treatment + alt-art combo: 8,000 gems (≈ £72 raw)
- Featured skin alt-art only: 5,000 gems

Per UK CMA compliance per `season_pass_v0.md` §2.3.

### 9.4 Anti-P2W audit (gacha)

| Concern | Test | Pass |
|---|---|---|
| Gameplay loot in gacha | Drop table is treatments / alt-arts / VFX only; no cards, no relics, no Warlords | ✅ |
| Pity ratio | 80 pulls = 8,000 gems = ~£72 ceiling for a guaranteed banner-pull. Within market norm. | ✅ |
| Forced FOMO | Vault re-purchase exists per §9.3; no permanent removal | ✅ |
| Under-18 access | Per `shop_economy_v0.md` §6, gacha hidden from <13 accounts; <18 hard-capped at £25/mo monthly | ✅ |

---

## 10. Engine handoff (consolidated)

### 10.1 New resource classes (summary)

- `card_art_variant.gd` (alt-arts)
- `warlord_skin.gd` (skins)
- `card_back.gd` (card-backs)
- `board_skin.gd` (boards)
- `summon_vfx.gd` (VFX presets)
- `gacha_banner.gd` (rotating banner config)
- `gacha_drop_pool.gd` (drop-rate config)

### 10.2 Collection UI extensions (per `collection_ui_v0.md`)

Add tabs to Collection:
- Card Treatments (existing) + alt-art row above treatment row
- Warlord Skins (NEW)
- Card-Backs (NEW)
- Board Skins (NEW)
- Summon VFX (NEW)
- Nameplates / Titles / Banners (NEW)

### 10.3 GameState extensions (consolidated)

```
# All owned cosmetics persist
var owned_alt_arts: Array[StringName]  # card_id-slot combo
var owned_warlord_skins: Array[StringName]
var owned_card_backs: Array[StringName]
var owned_board_skins: Array[StringName]
var owned_summon_vfx: Array[StringName]

# Equipped state
var equipped_alt_arts: Dictionary  # { card_id: alt_slot }
var equipped_warlord_skins: Dictionary  # { warlord_id: skin_id }
var equipped_card_back: StringName
var equipped_board_override: StringName
var equipped_summon_vfx: Dictionary  # { faction_id: vfx_id }
var equipped_nameplate: StringName
var equipped_title: StringName

# Signals
signal cosmetic_acquired(kind: StringName, id: StringName, source: StringName)
signal cosmetic_equipped(kind: StringName, target: StringName, id: StringName)
```

### 10.4 Save format

```
# game_save.json
"cosmetics": {
  "alt_arts_owned": [...],
  "warlord_skins_owned": [...],
  "card_backs_owned": [...],
  "board_skins_owned": [...],
  "summon_vfx_owned": [...],
  "equipped": {
    "alt_arts": { "m20_pall_bearer": "alt_1_bell_watch" },
    "warlord_skins": { "sieren": "court_of_one" },
    "card_back": "bell_tide",
    "board_override": "",
    "summon_vfx": { "ash_mourners": "raven_burst" },
    "nameplate": "mastered_court_necromant",
    "title": "spoke_the_name"
  }
}
```

### 10.5 Gacha API

```
class_name GachaController extends Node

func current_banner() -> GachaBanner
func pull(count: int = 1) -> Array[GachaResult]
func pull_pity_count(banner_id: StringName) -> int  # for "X pulls until pity" UI
```

---

## 11. MVP coverage

| Surface | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| Card treatments (existing) | — | shaders stubbed | full | full | full |
| Alt-arts | — | spec-only | season pass alt-arts ship | gacha banners ship | full Y1 catalogue |
| Warlord skins | mastery skin asset only | mastery × 5 free Warlords | mastery × 11 | + season hero skins | + paid live-op skins |
| Card-backs | — | 1 default | + 5 faction | + season cadence | + 18 Y1 catalogue |
| Board skins | placeholder | 5 free faction boards | + 1 boss board | + season hero board | + Vault prestige |
| Summon VFX | placeholder default | per-faction default | + 1 mastery alt | + paid alt | full 20 presets |
| Gacha banner | — | — | — | B1 launches | full B1-B8 rotation |
| Vault | — | — | — | — | post-S4 only |

---

## 12. Open questions for Paul

1. **Alt-art slot count by rarity** (Common 1 / Uncommon 2 / Rare 3) — confirm vs alternative flat 2 / 2 / 2 (simpler, larger Common asset load).
2. **Skin equip ownership rule (Open Q resolved):** equipped skin requires Warlord ownership. **Locked in §4.4 by Controller.**
3. **Vault gem price (8,000 / 5,000)** vs `season_pass_v0.md` Vault price recommendation (5,000 for hero re-acquisition only). Reconcile: hero skin = 5,000 (per BP doc); featured treatment + alt-art combo from gacha = 8,000 (this doc). Two different SKUs.
4. **Card-back launch count (10 vs 6)** — 10 is generous, 6 is the must-have minimum (default + 5 faction). Recommend 10 for launch perceived-value.
5. **Board skin override toggle vs always-rotate** — recommend rotate per-Warlord by default but offer override (per §6.4). Confirm.

---

## 13. Cross-references

- `monetisation_map.md` §5 + §9 — primary cosmetic-system + gacha framing.
- `collection_ui_v0.md` — Collection screen storefront route (gets extended by this doc's surfaces).
- `shop_economy_v0.md` — bundle compositions, gem economy, IAP routing.
- `season_pass_v0.md` §2 — track rewards include alt-arts + card-backs + board skins + hero skins; cross-refs banner rotation.
- `upgrade_trees_v0.md` §5 — Ascension grants nameplates + titles; card mastery grants alt-art slot unlock.
- `shader_stack_design.md` — treatment shaders consume `CardInstance.treatment_id`; alt-arts orthogonal at `CardInstance.alt_art_id`.
- `faction_frames_v0.md` — frame system underpins per-card frame; orthogonal to treatments + alt-arts.
- `warlord_tiers_full.md` — mastery skins per Warlord already spec'd.
- `art_specs/warlords/` — alt-art slot stubs to be added per-Warlord.

— Controller, 2026-05-21
