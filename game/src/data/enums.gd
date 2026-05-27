extends Object
class_name GFEnums

## Game-wide enums for The Curse of Gallowfell.
## Kept as a pure namespace so other scripts can reference e.g. GFEnums.Faction.IRON_PENITENTS
## without needing to instantiate. See cards_v0.md and faction_bible.md for canonical names.

## Canonical 5 factions per faction_bible.md v1 (renamed 2026-05-25; integer indices preserved).
## Old names IRON_PENITENTS / WITHERED_COURT / HOLLOW_PACT / FERRUM_HOST / SABLE_WILDS map 1:1
## by integer position so every existing .tres (which stores `faction = N` as int) loads unchanged.
## Folder layout under game/data/cards/ already uses the new names.
enum Faction {
	IRON_PENITENTS,    ## (0) Aggro / Sacrifice — flagellant crusaders of the Cathedral Ruins
	ASH_MOURNERS,      ## (1) Control / Debuff — necromancer-aristocrats of the Catacombs (was WITHERED_COURT)
	COVEN,             ## (2) Swarm / Poison — Coven of the Black Mire (was HOLLOW_PACT)
	LAST_LEGION,       ## (3) Tempo / Engineering — Last Legion war-machine cult (was FERRUM_HOST)
	SKINWARD_PACT,     ## (4) Summoner / Bestial — skin-changers of the Cinderwood (was SABLE_WILDS)
	NEUTRAL,           ## (5) Cross-faction utility / starter cards
}

enum CardType {
	UNIT,
	SPELL,
	TRAP,
}

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,         ## Reserved — not in starter pool
	LEGENDARY,    ## Reserved — Warlord-signature tier
}

## Attack range buckets. Tile distances are resolved at combat time by the targeting system.
enum AttackRange {
	NONE,    ## Auras / non-attackers (CD = —)
	MELEE,   ## 1 tile
	SHORT,   ## 2 tiles
	LONG,    ## 3 tiles
}

## Formal, evergreen keywords (cards_v0.md v1.0). Adding a new keyword = balance decision,
## so the enum is the single point of truth — gameplay code branches on these, never on strings.
enum Keyword {
	CLEAVE,       ## Hits 2 adjacent enemies on attack
	PIERCE,       ## Ignores Shield
	BLEED,        ## DoT, physical
	POISON,       ## DoT, stacks
	ROOT,         ## Cannot move
	FEAR,         ## ATK reduced
	SHIELD,       ## Absorbs N damage
	RESURRECT,    ## Returns on death (per card text)
	SUMMON,       ## Generates a token unit
	SACRIFICE,    ## Consumes a friendly unit for an effect
	PENANCE,      ## Iron Penitents trigger — gains stat on friendly Penitent death
	DREAD,        ## Court debuff aura, stacks with Smoke
	SMOKE,        ## Zone status — Fear-1 + ATK debuff while in zone
	SLOW,         ## Movement -X, stacks up to Slow-3 (= rooted)
	PERSIST,      ## On death: return to lane at end-of-turn at -1 ATK (floor 0), once per combat. See keywords/persist_v0.md.
	TAUNT,        ## Enemies in lane must target this unit first (within range, non-token). See keywords/taunt_v0.md.
	LIFESTEAL,    ## On successful attack, heal attacker for damage_dealt (capped at max_hp). See keywords/lifesteal_v0.md.
}

## Cosmetic treatment tiers — the Marvel-Snap-style upgrade system.
## See art_direction.md §2 for visual spec, and backlog.md Phase 2.10 for engine work.
## Authored entries live in `game/data/treatments/treatment_definitions.tres`.
## VISUAL ONLY — never branch combat code on these. Anti-P2W invariant.
## Extended 2026-05-25 with the foil/frame/animated tiers from cosmetic_expansion_v1.md.
enum TreatmentTier {
	DEFAULT,         ## Base frame — every card resolves to this when no other treatment is set
	FACTION_FRAME,   ## 5 entries (1 per faction); earned by faction-loyalty milestones
	FOIL,            ## Static sparkle highlight — gacha + low-tier IAP (£2.99)
	GOLD,            ## Metallic gold treatment — mid-tier IAP + season pass (£9.99)
	INK,             ## Monochrome alt-art version — season pass premium (£14.99)
	PRISM,           ## Animated rainbow-shimmer overlay — high-tier IAP + battle pass+ (£19.99)
	CURSED,          ## Animated green-pyre overlay — Hanging Hour event 14-day window (£14.99 ltd)
	ULTIMATE,        ## Gold + Prism + animated highlight combo — top-tier whale SKU (£49.99)
	## New 2026-05-25 — cosmetic_expansion_v1.md §2.1 Card Foils (finish layer on top of treatment shader).
	FOIL_SILVER,     ## Silver brushed-metal edge highlight; 0.4s play-flash sweep
	FOIL_GOLD,       ## Metallic gold sweep; 0.6s play-flash + slow gold-bloom (separate SKU from base GOLD treatment)
	FOIL_PRISMATIC,  ## Rainbow refraction sweep; 0.8s play-flash, multi-axis prism
	FOIL_RAINBOW,    ## Full-card animated rainbow; continuous on-play with 1.2s decay
	## New 2026-05-25 — cosmetic_expansion_v1.md §2.2 non-faction frame variants.
	FRAME_VARIANT,   ## Generic "vibe frame" overlay (ash-charred / iron-rivet / pyre-bone / oath-broken etc)
	## New 2026-05-25 — cosmetic_expansion_v1.md §2.3 animated idle state.
	FRAME_ANIMATED,  ## Subtle 0.5s idle loop (banner flutter, candle flicker, water ripple)
}

## Theme pack category — used by theme_pack.gd. IP-rule axis per theme_packs_system_v0.md §0.
enum ThemePackCategory {
	PUBLIC_DOMAIN,        ## PD source material — ship freely (Brothers Grimm, Lovecraft pre-1929, Norse / Greek myth, etc)
	ORIGINAL,             ## Gallowfell-original — always safe; we own the IP
	LICENSED_BLOCKED,     ## Reference-only; do NOT ship under this name (LOTR / Wizarding World / GoT / etc) — flagged for audit
}

## Status of a theme pack's art pipeline. Drives the UI "Themed name only / Full art" badge.
enum ThemePackStatus {
	ART_COMPLETE,    ## All ~342 cards re-arted, named, frame-variant, flavour
	ART_STUBBED,     ## Themed name + frame variant only; canonical art retained (auto-upgrades on patch)
	ROADMAP,         ## Y2+ slot, not in launch catalogue; spec-only entry
}

## Shop item kind — drives how the storefront groups + filters SKUs.
enum ShopItemKind {
	FEATURED_DEAL,    ## Weekly Mon-04:00 hero slot, always £4.99 anchor
	ROTATING_SLOT,    ## Daily 04:00 rotation; 6 slots per player, deterministic-seeded
	ALWAYS_AVAILABLE, ## Starter Bundle / Faction Set / etc — permanent anchor SKU
	GEM_PACK,         ## Hard-currency pack ladder
	GRAB_BAG,         ## Transparent 3-choice grab-bag (NOT random loot box) — see grab_bag.gd
	SEASONAL_BUNDLE,  ## Theme-tied seasonal bundle (Mon-04:00 / 30-day window)
	THEME_PACK,       ## Card-art / frame / name / flavour re-skin SKU
	WARLORD_SKIN,     ## Warlord cosmetic skin SKU
	SUBSCRIPTION,     ## Ascendant Pact monthly / quarterly / annual
}

## Pass reward kind — what is granted at a tier-up. Anti-P2W: REWARD cannot include cards / Warlord unlocks for PvP modes.
enum PassRewardKind {
	CURRENCY,        ## Gems / Bones / Marrow Shards / Souls payload
	COSMETIC,        ## Theme / frame / foil / back / board / banner / title / emote payload
	CARD_UNLOCK,     ## PvE-only — unlocks a draftable card in collection
	WARLORD_UNLOCK,  ## PvE-only — unlocks a Warlord roster slot
	GRAB_BAG,        ## Player picks 1-of-3 visible alternatives at claim time
	XP_BOOST,        ## Temporary XP multiplier
	RETRY_TICKET,    ## Consumable run-retry
	HERO_SKIN,       ## Season hero reward (per season_pass_v2.md §8) — unique-per-season, never re-sold
}

## Season pass kind — drives multi-pass eligibility logic per season_pass_v2.md §9.
enum SeasonPassKind {
	STANDARD,            ## Default 50-tier 30-day season pass
	RETURNING_SEEKER,    ## 14-day 20-tier mini-pass; absent ≥30 days trigger
	FIRST_PASS_EVER,     ## 30-day 50-tier on first-season-encountered; front-loaded pacing
}

## Game mode kind — drives matchmaking, server routing, anti-cheat path.
enum GameModeKind {
	CORE,            ## Mode A — single-player roguelike deckbuilder; the heart of the game
	DAILY_BRAWL,     ## Mode C — async tournament under a daily preset rule (ship FIRST)
	GHOST_DUEL,      ## Mode B — async PvP against recorded "ghosts"; deterministic server-side sim
	CO_OP,           ## Mode E — 2-player co-op PvE boss trial
	LIVE_1V1,        ## Mode D — real-time turn-based PvP; deferred to v1.5+
}

## What a daily-brawl preset rule applies to — drives the modifier-payload resolver.
enum BrawlRuleApplies {
	DECK_BUILD,      ## "Coven only" — restricts deck construction phase
	COSTS,           ## "All cards cost 1 less" / "...1 more" — mana adjustment
	DAMAGE,          ## "Double damage" — both-sides ATK multiplier
	MANA_CAP,        ## "Half mana" / "Tripled mana" — max-mana ceiling adjustment
	HANGING_HOUR,    ## "Hanging Hour every turn" — escalation trigger override
	MULLIGAN,        ## "No mulligan" — disables mulligan phase
	LANES,           ## "Single lane" — middle-lane only
	WAVE_COMPOSITION,## "Boss Rush" — replaces swarm rounds with bosses
	REWARDS,         ## "Reward Drought" / "Reward Bounty" — pick-N modifier
	GLOBAL_CURSES,   ## "No Curses" / "Curse Cascade" — curse system override
	UNITS,           ## "Permadeath of Units" — once-dead-stays-dead override
	MIRROR,          ## "Mirror Match" — enemy deck = your deck
}

## Where in the run this scene/screen sits. Drives the meta navigator.
enum RunPhase {
	MAP,           ## Branching node selection
	COMBAT,        ## Wave-based defence
	REWARD,        ## Pick 1 of 3 cards
	SHOP,          ## Spend run currency
	EVENT,         ## Narrative choice node
	BOSS,          ## Chapter boss (Hanging Hour escalation)
	GAME_OVER,
	VICTORY,
}

## Map node types (B2.9). Drives what scene loads when the player picks a node.
## Distinct from RunPhase — RunPhase tracks "which screen is up right now",
## NodeKind tracks "what kind of encounter does this map tile represent".
## Generator (map_generator.gd) decides distribution per chapter.
enum NodeKind {
	COMBAT,        ## Standard wave-based fight (default node type)
	ELITE,         ## Tougher fight with better reward roll
	EVENT,         ## Narrative choice node (no combat)
	SHOP,          ## Spend Ash for cards / removes / relics
	SHRINE,        ## One-time blessing or curse (chapter-randomised)
	REST,          ## Heal or upgrade-a-card pick
	HORDE,         ## Wave of many weak enemies