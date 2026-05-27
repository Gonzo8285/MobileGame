extends Resource
class_name Warlord

## Warlord resource — the player's run-anchor identity.
##
## Canonical roster lives in `warlords_v1.md` (11 entries: 5 free + 5 paid +
## 1 lore-locked secret). Tier ladder design intent lives in
## `warlord_tiers_v0.md`; per-Warlord tier content in `warlord_tiers_full.md`.
##
## Authored as .tres in `game/data/warlords/<id>.tres` (and `<id>_tiers.tres`
## for the tier_unlocks array if authored separately). Loaded at run-start by
## GameState — see start_run() which is W5+W6 work.

@export var id: StringName = &""                 ## Stable warlord identifier (e.g. &"vyrrun")
@export var display_name: String = ""            ## Player-facing name
@export var faction: GFEnums.Faction = GFEnums.Faction.NEUTRAL

## Base loadout — what a Tier-1 player plays with. Variant passives and
## alt-fires from tier_unlocks layer over this at T2/T3 via the warlord-select
## UI (see warlord_select_ui_v0.md Screens C+D).
@export_group("Base loadout")
@export var base_passive_id: StringName = &""   ## Default passive ID (e.g. &"mortify")
@export var signature_unit: Card = null         ## Deck-included signature unit
@export var signature_spell: Card = null        ## Deck-included signature spell

## Tier ladder — Array[TierContent] of length 4, indexed 0..3 for tiers 1..4.
## Empty array = tier system not yet wired for this Warlord (acceptable during
## IMV-1 trim per internal_mvp_scope.md). The export type is intentionally
## Array[Resource] not Array[TierContent] because Godot's editor doesn't always
## round-trip custom-class array exports cleanly across Godot point releases.
## Runtime accessors below cast on read.
@export_group("Tier system")
@export var tier_unlocks: Array[Resource] = []

## Unlock economy (per monetisation_map.md §4). Free Warlords have all three
## meta fields at default. Paid Warlords have non-zero marrow_shard_cost AND
## gem_cost (player picks payment path). Lore-locked Warlords (W11) use
## unlock_tag with is_free=false.
@export_group("Meta")
@export var is_free: bool = true
@export var marrow_shard_cost: int = 0
@export var gem_cost: int = 0
@export var unlock_tag: StringName = &""        ## e.g. &"campaign_all_10" for W11


## Returns the TierContent for `tier` (1..4), or null if tier_unlocks is empty
## or the index is out of range. Caller is expected to handle null gracefully —
## tier-system content may not be authored for all Warlords during IMV-1.
func get_tier_content(tier: int) -> Resource:
	var idx: int = tier - 1
	if idx < 0 or idx >= tier_unlocks.size():
		return null
	return tier_unlocks[idx]


## Validation hook — empty array if valid, otherwise human-readable problems.
func validate() -> Array[String]:
	var errors: Array[String] = []
	if id == &"":
		errors.append("Warlord has no id")
	if display_name == "":
		errors.append("Warlord '%s' has no display_name" % id)
	if not is_free:
		if marrow_shard_cost <= 0 and gem_cost <= 0 and unlock_tag == &"":
			errors.append("Paid/locked Warlord '%s' has no unlock path" % id)
	# Tier content: 0 entries is fine (not yet authored).
	# If authored, expect 4 entries indexed for T1..T4 and each must validate.
	if not tier_unlocks.is_empty():
		if tier_unlocks.size() != 4:
			errors.append("'%s' tier_unlocks must be 0 or 4 entries (got %d)" %
					[id, tier_unlocks.size()])
		for i in range(tier_unlocks.size()):
			var tc: Resource = tier_unlocks[i]
			if tc == null:
				errors.append("'%s' tier_unlocks[%d] is null" % [id, i])
				continue
			if tc.has_method("validate"):
				var tier_errors: Array = tc.call("validate")
				for e in tier_errors:
					errors.append("'%s' tier_unlocks[%d]: %s" % [id, i, e])
			# Sanity: TierContent.tier should match its index+1.
			if tc.get("tier") != null and int(tc.get("tier")) != i + 1:
				errors.append("'%s' tier_unlocks[%d].tier expected %d, got %d" %
						[id, i, i + 1, int(tc.get("tier"))])
	return errors
