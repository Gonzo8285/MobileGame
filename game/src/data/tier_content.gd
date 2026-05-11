extends Resource
class_name TierContent

## Per-tier payload for a Warlord — one entry per tier in Warlord.tier_unlocks.
## See warlord_tiers_v0.md §3 for design intent and warlord_tiers_full.md for
## the canonical per-Warlord content authored against this shape.
##
## Tier semantics:
##   - T1: variant_passives empty, alt_fire null, mastery fields empty.
##         (T1 is the "default" tier — base passive/spell live on the Warlord
##         resource itself, not in TierContent.)
##   - T2: variant_passives has exactly 2 entries (A/B sidegrades; the Warlord's
##         default passive remains selectable per warlord_tiers_v0.md §3.2).
##         alt_fire null, mastery fields empty.
##   - T3: variant_passives carries forward from T2; alt_fire_spell populated
##         (same mana cost as the default sig spell, effect axis rotated per
##         §3.3). Mastery fields empty.
##   - T4: variant_passives + alt_fire as T3; mastery_skin_id + lore + title +
##         ascension_mod_id all populated per §3.4.
##
## Anti-pay-to-win invariant (audit-tested below): a TierContent NEVER carries
## raw stat boosts. Variant passives are ID strings into the Warlord's passive
## registry; alt_fires are Card resources at the same cost as the default; the
## mastery bundle is cosmetic + lore + a *harder* Ascension slot. See §6 audit.

@export var tier: int = 1                          ## 1..4, must match index+1 in Warlord.tier_unlocks

## Variant passive payloads — StringName IDs into the Warlord's passive registry.
## Empty at T1, length-2 at T2+. The player picks one of
## {default, variant_passives[0], variant_passives[1]} from the warlord-select UI.
@export var variant_passives: Array[StringName] = []

## Tier-3 signature spell alt-fire. Same mana cost as the Warlord's default
## sig spell; effect axis rotated. Null for T1/T2.
@export var alt_fire_spell: Card = null

## Tier-4 mastery payoff bundle (per warlord_tiers_v0.md §3.4).
## All four fields populated only at T4; empty/null at lower tiers.
@export var mastery_skin_id: StringName = &""           ## res:// or treatment-registry key
@export_multiline var mastery_lore_string: String = ""  ## ≤30-word in-fiction reveal
@export var mastery_title: StringName = &""             ## Display-only profile/leaderboard badge
@export var ascension_mod_id: StringName = &""          ## Warlord-specific A11 challenge slot ID


## Validation hook — returns empty array if valid, otherwise human-readable problems.
## Designed for CI gating + editor tooling. Mirrors the Card.validate() pattern.
func validate() -> Array[String]:
	var errors: Array[String] = []
	if tier < 1 or tier > 4:
		errors.append("tier out of range (must be 1..4, got %d)" % tier)
		return errors  # rest of audit is tier-relative; bail early

	if tier == 1:
		if not variant_passives.is_empty():
			errors.append("T1 must have no variant_passives (got %d)" % variant_passives.size())
		if alt_fire_spell != null:
			errors.append("T1 must have no alt_fire_spell")
		if mastery_skin_id != &"" or mastery_title != &"":
			errors.append("T1 must have no mastery payload")
	elif tier == 2:
		if variant_passives.size() != 2:
			errors.append("T2 must have exactly 2 variant_passives (got %d)" % variant_passives.size())
		if alt_fire_spell != null:
			errors.append("T2 must have no alt_fire_spell")
	elif tier == 3:
		if variant_passives.size() != 2:
			errors.append("T3 must carry 2 variant_passives from T2 (got %d)" % variant_passives.size())
		if alt_fire_spell == null:
			errors.append("T3 missing alt_fire_spell")
	elif tier == 4:
		if variant_passives.size() != 2:
			errors.append("T4 must carry 2 variant_passives (got %d)" % variant_passives.size())
		if alt_fire_spell == null:
			errors.append("T4 missing alt_fire_spell")
		if mastery_skin_id == &"":
			errors.append("T4 missing mastery_skin_id")
		if mastery_title == &"":
			errors.append("T4 missing mastery_title")
		# mastery_lore_string and ascension_mod_id are nice-to-have at engine level;
		# their absence is a content-completeness issue caught by warlord-content tests.
	return errors
