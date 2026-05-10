extends Object
class_name GFEnums

## Game-wide enums for The Curse of Gallowfell.
## Kept as a pure namespace so other scripts can reference e.g. GFEnums.Faction.IRON_PENITENTS
## without needing to instantiate. See cards_v0.md and faction_bible.md for canonical names.

enum Faction {
	IRON_PENITENTS,    ## Aggro / Sacrifice — zealot crusaders
	WITHERED_COURT,    ## Control / Debuff — funerary court of the catacombs
	HOLLOW_PACT,       ## Swarm / Poison — bog-witches of the Bog of Bargains
	FERRUM_HOST,       ## (Post-MVP) Tempo / Engineering — foundry war-machine cult
	SABLE_WILDS,       ## (Post-MVP) Summoner / Bestial — skin-changers of the Cinderwood
	NEUTRAL,           ## Cross-faction utility / starter cards
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
}

## Cosmetic treatment tiers — the Marvel-Snap-style upgrade system.
## See art_direction.md §2 for visual spec, and backlog.md Phase 2.10 for engine work.
## Authored entries live in `game/data/treatments/treatment_definitions.tres`.
## VISUAL ONLY — never branch combat code on these. Anti-P2W invariant.
enum TreatmentTier {
	DEFAULT,         ## Base frame — every card resolves to this when no other treatment is set
	FACTION_FRAME,   ## 5 entries (1 per faction); earned by faction-loyalty milestones
	FOIL,            ## Static sparkle highlight — gacha + low-tier IAP ($2.99)
	GOLD,            ## Metallic gold treatment — mid-tier IAP + season pass ($9.99)
	INK,             ## Monochrome alt-art version — season pass premium ($14.99)
	PRISM,           ## Animated rainbow-shimmer overlay — high-tier IAP + battle pass+ ($19.99)
	CURSED,          ## Animated green-pyre overlay — Hanging Hour event 14-day window ($14.99 ltd)
	ULTIMATE,        ## Gold + Prism + animated highlight combo — top-tier whale SKU ($49.99)
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
