extends Object
class_name AuraDispatch

## AURA.E1 (keywords/aura_v0.md) — per-card aura registry.
##
## Pure-static dispatch keyed on card.id. Each entry declares (a) what
## counts as a valid target for that source's aura, (b) the grant payload
## (atk / hp / keywords). Lane hooks (`_on_unit_entered_lane`,
## `_on_unit_leaving_lane`) call `maybe_grant` and `revoke_all_from` so the
## aura system is invisible to the rest of the engine — no per-card
## branches anywhere else in turn_engine.gd / lane.gd.
##
## v0 design choice: card IDs are hard-coded here rather than read from a
## `.tres` `aura_spec` property. Trade-off explicit in aura_v0.md — moving
## the dispatch table into `.tres` files is a v1 polish step that lets
## non-coding designers register auras without touching .gd. v0 keeps the
## dispatch table in one easily-reviewable file. ~~~~~~~~~~~~~~~~~~~~~~~~
##
## First consumer: **W42 Den-Mother of the Cinderwood** (Phase 2.13 N4).
## Targets friendly Wolf-Tokens (card.id == &"W28") in the same lane;
## grants +1/+1 + LIFESTEAL. Den-Mother is a 4c U; without this dispatch
## her effect text is purely decorative and the Wolf-Tokens she's meant to
## amplify just sit there as 1/2 commons.
##
## Future consumers queued in backlog.md Phase 2.16:
##   * W4 Bear-Skin Hierophant (highest-cost Wilds gets +2 HP + Cleave)
##   * L27-L40 Banner-Buff spine (12 cards, same banner-presence condition)
##
## Second consumer (L41.E1, 2026-05-27): **L41 Banner-Bearer of the Crowned
## Anvil** — first SELF-AURA case in the engine. "While a friendly banner
## stands in this row, gains +1 ATK and Pierce." Three additions vs. W42:
##   1. New target_kind "self_if_friendly_banner_in_lane" — condition is
##      lane-state-derived (banner present) rather than per-candidate.
##   2. `maybe_grant`'s self-target filter (`if t == source: continue`) is
##      bypassed for self-* target kinds via the new `_self_targets_source`
##      helper. apply_aura_grant(self, self, ...) stores the grant keyed on
##      self — revoke_aura_grant(self) cleans it up symmetrically.
##   3. New `re_evaluate_self_auras(lane, excluding)` hook called from
##      lane.gd's _on_unit_entered_lane + _on_unit_leaving_lane so the
##      condition flips when banner-presence changes (any unit enter/leave
##      can affect banner-presence). `excluding` skips the leaving banner
##      so the just-killed L34 doesn't count as "still in lane".
##
## v0 banner predicate: friendly L34 (Crowned Anvil Standard, 5c R artifact-
## unit) in lane. The Banner-Buff spine (L32/L33/L36/L37/L40) spawns
## BANNER_TOKEN LaneEffects which DON'T EXIST in the engine yet — when the
## LaneEffect system lands, extend `_is_friendly_banner_in_lane` to also
## check `lane.lane_effects` for `kind == BANNER_TOKEN`. Without LaneEffect,
## the v0 implementation captures the L34-payoff path only; the L33/L32-
## etc. text-only banner condition stays decorative until LaneEffect lands.


# ============================================================================
# Public dispatch API
# ============================================================================

## Walks the dispatch table; if `source.card_data.id` is a registered aura,
## checks each `candidate` against the aura's target rule and applies the
## grant when matched. Used by lane hooks when:
##   (a) a new candidate unit enters lane and may match existing sources
##   (b) a new source enters lane and may match existing candidates
## `candidate == null` means "walk all friendly units in lane" — the new-
## source branch.
static func maybe_grant(source: UnitInstance, candidate: UnitInstance,
		lane: Lane) -> void:
	if source == null or source.card_data == null:
		return
	var entry := _entry_for(source.card_data.id)
	if entry.is_empty():
		return
	var is_self_aura: bool = _self_targets_source(entry)
	var targets: Array[UnitInstance] = []
	if candidate != null:
		# Standard candidate-narrowed call. For self-auras, only fire when
		# the candidate IS the source (caller is re-evaluating self after
		# its own enter/leave). For outbound auras, the source-target
		# filter below still skips t == source.
		if is_self_aura and candidate != source:
			return
		targets.append(candidate)
	else:
		# New source — grant onto every existing friendly that matches.
		# Source never grants to itself (aura_v0.md open-Q1 default = no
		# self-buff) UNLESS this is an explicit self-aura entry. W4 Bear-
		# Skin Hierophant's "highest-cost Wilds" target rule explicitly
		# excludes the Hierophant per the same Q1.
		if is_self_aura:
			targets.append(source)
		else:
			for u in lane.friendly_units:
				if u == null or u == source:
					continue
				targets.append(u)
	for t in targets:
		if t == null:
			continue
		# Self-target filter: outbound auras skip self; self-auras keep it.
		if t == source and not is_self_aura:
			continue
		if not _matches_target(entry, source, t, lane):
			continue
		var spec: Dictionary = entry["grant"]
		t.apply_aura_grant(
			source,
			int(spec.get("atk", 0)),
			int(spec.get("hp", 0)),
			spec.get("keywords", []) as Array
		)


## Strip every grant whose source is `leaving_source` across every friendly
## unit in lane. Called when `leaving_source` is about to be removed from
## the lane (death / sacrifice / lane wipe). Idempotent — safe to call on
## a non-source unit (just iterates and finds no entries to remove).
static func revoke_all_from(leaving_source: UnitInstance, lane: Lane) -> void:
	if leaving_source == null:
		return
	for u in lane.friendly_units:
		if u == null:
			continue
		u.revoke_aura_grant(leaving_source)


# ============================================================================
# Dispatch table — internal
# ============================================================================
#
# Entry shape:
# {
#   "target_kind": "friendly_token_with_id" | "friendly_id" | "highest_cost_wilds"
#                | "self_if_condition" | ...,
#   "target_param": <kind-specific parameter, e.g. token card.id>,
#   "grant": { "atk": int, "hp": int, "keywords": Array[int] }
# }

static func _entry_for(card_id: StringName) -> Dictionary:
	match card_id:
		&"W42":
			# Den-Mother of the Cinderwood: friendly Wolf-Tokens in lane
			# gain +1/+1 and LIFESTEAL while she is in lane.
			return {
				"target_kind": "friendly_token_with_id",
				"target_param": &"W28",  # Wolf-Token
				"grant": {
					"atk": 1,
					"hp": 1,
					"keywords": [GFEnums.Keyword.LIFESTEAL],
				},
			}
		&"L41":
			# Banner-Bearer of the Crowned Anvil (Phase 2.13 N2, L41.E1).
			# Self-aura: while a friendly banner stands in this row,
			# gains +1 ATK and PIERCE. The condition is lane-state-derived
			# (banner present), not source-target paired — re-evaluated by
			# `re_evaluate_self_auras` whenever ANY unit enters/leaves the
			# lane (banner could be the enter/leave subject).
			return {
				"target_kind": "self_if_friendly_banner_in_lane",
				"target_param": null,
				"grant": {
					"atk": 1,
					"hp": 0,
					"keywords": [GFEnums.Keyword.PIERCE],
				},
			}
		_:
			return {}


static func _matches_target(entry: Dictionary, source: UnitInstance,
		candidate: UnitInstance, lane: Lane) -> bool:
	if candidate == null or candidate.card_data == null:
		return false
	if not candidate.is_alive():
		return false
	# Source and candidate must share the lane — auras are lane-scoped
	# (aura_v0.md). The candidate is already in `lane.friendly_units` by
	# the time this is called, but check anyway for defensive symmetry.
	if candidate.lane_index != source.lane_index:
		return false
	var kind: String = String(entry.get("target_kind", ""))
	match kind:
		"friendly_token_with_id":
			# Match by Card.id AND the runtime is_token flag, so a draft-
			# included Wolf-Token (which CAN appear in deck per cards_v0.md)
			# also benefits — `is_token` is set true by the spawner OR by
			# draftable=true Wolf-Token cards being played from hand.
			var want_id: StringName = entry.get("target_param", &"")
			return candidate.card_data.id == want_id
		"friendly_id":
			var want: StringName = entry.get("target_param", &"")
			return candidate.card_data.id == want
		"highest_cost_wilds":
			# W4 Bear-Skin Hierophant — picks the max-cost friendly Wilds
			# unit in lane that ISN'T the source itself. Implemented when
			# W4 is wired (currently unreachable — W4 not in dispatch table).
			return _is_highest_cost_wilds_excluding(source, candidate, lane)
		"self_if_friendly_banner_in_lane":
			# L41 Banner-Bearer self-aura. Two gates: (a) candidate must
			# BE the source (it's a self-aura — `maybe_grant` is structured
			# to put source into targets only when this kind fires), and
			# (b) the lane must contain a friendly banner. Excluding-list
			# handling for "banner is currently dying" lives in the lane
			# hook, which passes `excluding` to re_evaluate_self_auras.
			if candidate != source:
				return false
			return _is_friendly_banner_in_lane(lane, null)
		_:
			return false


# ============================================================================
# Self-aura support (L41.E1)
# ============================================================================
#
# Self-auras whose condition depends on lane state (rather than a single
# source-target pair) need re-evaluation whenever lane state changes — i.e.
# any unit enter/leave. The lane hook calls `re_evaluate_self_auras` after
# the standard maybe_grant / revoke_all_from pass; that hook compares each
# friendly's current self-grant state with the condition outcome and either
# applies or revokes accordingly.
#
# Why a separate hook (not just relying on maybe_grant): maybe_grant fires
# when a SOURCE enters or a CANDIDATE enters — it doesn't fire when an
# UNRELATED unit (e.g. the banner under L41's condition) enters or leaves.
# A standalone re-evaluation pass closes that gap without polluting every
# place_unit / cull path with bespoke per-card branches.

## Returns true iff the entry's target_kind is a self-aura (target is the
## source itself). Used by maybe_grant to bypass the standard
## "skip t == source" filter.
static func _self_targets_source(entry: Dictionary) -> bool:
	var kind: String = String(entry.get("target_kind", ""))
	return kind.begins_with("self_")


## Re-evaluate every self-aura source in `lane`. For each source whose
## dispatch entry is a self-aura, apply the grant if the condition holds
## and it's not yet active, OR revoke the grant if the condition has
## stopped holding. Idempotent — safe to call multiple times per phase.
##
## `excluding` is an optional UnitInstance to skip when evaluating the
## condition. Lane hooks pass the leaving unit here so a just-killed banner
## doesn't count toward the banner-presence check during its own
## cull_dead_units pass (the unit is still in friendly_units at that point).
static func re_evaluate_self_auras(lane: Lane,
		excluding: UnitInstance = null) -> void:
	if lane == null:
		return
	for u in lane.friendly_units:
		if u == null or u == excluding:
			continue
		if u.card_data == null:
			continue
		var entry := _entry_for(u.card_data.id)
		if entry.is_empty():
			continue
		if not _self_targets_source(entry):
			continue
		var condition_holds: bool = _evaluate_self_condition(entry, u, lane, excluding)
		var currently_granted: bool = u.aura_stats.has(u)
		if condition_holds and not currently_granted:
			var spec: Dictionary = entry["grant"]
			u.apply_aura_grant(
				u,
				int(spec.get("atk", 0)),
				int(spec.get("hp", 0)),
				spec.get("keywords", []) as Array
			)
		elif not condition_holds and currently_granted:
			u.revoke_aura_grant(u)


## Evaluate the self-condition embedded in `entry` against `lane`. Mirrors
## the `self_if_*` branches of `_matches_target`, but with explicit
## `excluding` support (the leaving-unit case).
static func _evaluate_self_condition(entry: Dictionary, source: UnitInstance,
		lane: Lane, excluding: UnitInstance) -> bool:
	var kind: String = String(entry.get("target_kind", ""))
	match kind:
		"self_if_friendly_banner_in_lane":
			return _is_friendly_banner_in_lane(lane, excluding)
		_:
			return false


## v0 banner predicate: friendly L34 (Crowned Anvil Standard, 5c R
## artifact-unit) alive in lane. Future: extend to check
## `lane.lane_effects` for BANNER_TOKEN entries once the LaneEffect system
## lands (see backlog Phase 2.13 N2 + cards_last_legion_v1.md Q1).
##
## `excluding` skips a specific unit (used by `re_evaluate_self_auras`
## during cull_dead_units, where the leaving banner is still in
## friendly_units at hook time). Pass null to count all friendlies.
static func _is_friendly_banner_in_lane(lane: Lane,
		excluding: UnitInstance) -> bool:
	if lane == null:
		return false
	for u in lane.friendly_units:
		if u == null or u == excluding:
			continue
		if not u.is_alive():
			continue
		if u.card_data == null:
			continue
		if u.card_data.id == &"L34":
			return true
	return false


## Reserved for W4 Bear-Skin Hierophant when it's wired into the dispatch
## table. Returns true iff `candidate` is the unique max-cost Wilds friendly
## in `lane` excluding `source`. Ties (multiple units sharing max-cost)
## resolve to lowest tile (closest to base) for determinism; document the
## tie-break in W4.E1's backlog ticket.
static func _is_highest_cost_wilds_excluding(source: UnitInstance,
		candidate: UnitInstance, lane: Lane) -> bool:
	# Stub for W4.E1 — implementation deferred. Returns false to keep the
	# dispatch table safe to extend without firing untested code paths.
	# When wiring W4, replace this stub with the real lookup and add
	# scene-G tests for "tied max-cost → lower tile wins" + "Hierophant is
	# alone in lane → no grant (excluded from own target set)".
	return false
