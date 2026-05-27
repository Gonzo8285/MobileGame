"""
L41.E1 — L41 Banner-Bearer self-aura Python mirror

Validates the engine wiring in `game/src/runtime/aura_dispatch.gd` against
the spec in `keywords/aura_v0.md` + backlog Phase 2.16 L41.E1 entry. Cowork
sandbox can't run Godot syntax, so this mirror reproduces the lane/unit
invariants in pure Python and exercises the four scene cases from Scene G
in `turn_engine_test.gd`.

Authored 2026-05-27 by Controller hourly cycle (L41.E1).
"""

from __future__ import annotations
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Set


PIERCE = "PIERCE"
LIFESTEAL = "LIFESTEAL"
TAUNT = "TAUNT"


@dataclass
class Card:
    id: str
    display_name: str
    cost: int = 0
    hp: int = 1
    attack: int = 0
    keywords: Set[str] = field(default_factory=set)


@dataclass
class UnitInstance:
    """Mirror of UnitInstance — fields we care about for L41 self-aura."""
    card_data: Card
    tile: int
    lane_index: int
    current_hp: int = 0
    aura_stats: Dict["UnitInstance", Dict[str, int]] = field(default_factory=dict)
    runtime_keywords: Dict["UnitInstance", Set[str]] = field(default_factory=dict)

    def __post_init__(self):
        if self.current_hp == 0:
            self.current_hp = self.card_data.hp

    def __hash__(self):
        return id(self)

    def is_alive(self) -> bool:
        return self.current_hp > 0

    def max_hp(self) -> int:
        total = self.card_data.hp
        for entry in self.aura_stats.values():
            total += entry.get("hp", 0)
        return max(0, total)

    def current_attack(self) -> int:
        total = self.card_data.attack
        for entry in self.aura_stats.values():
            total += entry.get("atk", 0)
        return max(0, total)

    def has_keyword(self, kw: str) -> bool:
        if kw in self.card_data.keywords:
            return True
        for kws in self.runtime_keywords.values():
            if kw in kws:
                return True
        return False

    def apply_aura_grant(self, source: "UnitInstance", atk_buff: int,
                          hp_buff: int, keywords: List[str]) -> None:
        self.aura_stats[source] = {"atk": atk_buff, "hp": max(0, hp_buff)}
        self.runtime_keywords[source] = set(keywords)
        if hp_buff > 0:
            self.current_hp += hp_buff
        self.current_hp = min(self.current_hp, self.max_hp())
        if self.current_hp < 1:
            self.current_hp = 1

    def revoke_aura_grant(self, source: "UnitInstance") -> None:
        self.aura_stats.pop(source, None)
        self.runtime_keywords.pop(source, None)
        new_max = max(1, self.max_hp())
        self.current_hp = min(self.current_hp, new_max)
        if self.current_hp < 1:
            self.current_hp = 1


@dataclass
class Lane:
    lane_index: int
    friendly_units: List[UnitInstance] = field(default_factory=list)

    def place_unit(self, card: Card, tile: int) -> UnitInstance:
        u = UnitInstance(card_data=card, tile=tile, lane_index=self.lane_index)
        self.friendly_units.append(u)
        self._on_unit_entered_lane(u)
        return u

    def cull_dead_units(self) -> int:
        removed = 0
        for u in list(self.friendly_units):
            if not u.is_alive():
                self._on_unit_leaving_lane(u)
                self.friendly_units.remove(u)
                removed += 1
        return removed

    def _on_unit_entered_lane(self, new_unit: UnitInstance) -> None:
        # Outbound auras (W42-style) — not used in this mirror but
        # included for structural fidelity. L41 self-aura is fired by
        # re_evaluate_self_auras below.
        for source in self.friendly_units:
            if source is new_unit or source is None:
                continue
            maybe_grant(source, new_unit, self)
        maybe_grant(new_unit, None, self)
        re_evaluate_self_auras(self, excluding=None)

    def _on_unit_leaving_lane(self, leaving: UnitInstance) -> None:
        revoke_all_from(leaving, self)
        re_evaluate_self_auras(self, excluding=leaving)


# ---------------------------------------------------------------------------
# AuraDispatch mirror
# ---------------------------------------------------------------------------

def _entry_for(card_id: str) -> Dict:
    if card_id == "L41":
        return {
            "target_kind": "self_if_friendly_banner_in_lane",
            "target_param": None,
            "grant": {"atk": 1, "hp": 0, "keywords": [PIERCE]},
        }
    # W42 omitted from mirror — Scene F has its own.
    return {}


def _self_targets_source(entry: Dict) -> bool:
    return str(entry.get("target_kind", "")).startswith("self_")


def _is_friendly_banner_in_lane(lane: Lane, excluding: Optional[UnitInstance]) -> bool:
    for u in lane.friendly_units:
        if u is None or u is excluding:
            continue
        if not u.is_alive():
            continue
        if u.card_data.id == "L34":
            return True
    return False


def maybe_grant(source: UnitInstance, candidate: Optional[UnitInstance], lane: Lane) -> None:
    if source is None or source.card_data is None:
        return
    entry = _entry_for(source.card_data.id)
    if not entry:
        return
    is_self = _self_targets_source(entry)
    targets: List[UnitInstance] = []
    if candidate is not None:
        if is_self and candidate is not source:
            return
        targets.append(candidate)
    else:
        if is_self:
            targets.append(source)
        else:
            for u in lane.friendly_units:
                if u is None or u is source:
                    continue
                targets.append(u)
    for t in targets:
        if t is None:
            continue
        if t is source and not is_self:
            continue
        if not _matches_target(entry, source, t, lane):
            continue
        spec = entry["grant"]
        t.apply_aura_grant(source, spec.get("atk", 0), spec.get("hp", 0),
                            list(spec.get("keywords", [])))


def _matches_target(entry: Dict, source: UnitInstance, candidate: UnitInstance,
                     lane: Lane) -> bool:
    if candidate is None or candidate.card_data is None or not candidate.is_alive():
        return False
    if candidate.lane_index != source.lane_index:
        return False
    kind = str(entry.get("target_kind", ""))
    if kind == "self_if_friendly_banner_in_lane":
        if candidate is not source:
            return False
        return _is_friendly_banner_in_lane(lane, excluding=None)
    return False


def revoke_all_from(leaving_source: UnitInstance, lane: Lane) -> None:
    for u in lane.friendly_units:
        if u is None:
            continue
        u.revoke_aura_grant(leaving_source)


def re_evaluate_self_auras(lane: Lane, excluding: Optional[UnitInstance]) -> None:
    for u in lane.friendly_units:
        if u is None or u is excluding or u.card_data is None:
            continue
        entry = _entry_for(u.card_data.id)
        if not entry or not _self_targets_source(entry):
            continue
        condition_holds = _evaluate_self_condition(entry, u, lane, excluding)
        currently_granted = u in u.aura_stats
        if condition_holds and not currently_granted:
            spec = entry["grant"]
            u.apply_aura_grant(u, spec.get("atk", 0), spec.get("hp", 0),
                               list(spec.get("keywords", [])))
        elif not condition_holds and currently_granted:
            u.revoke_aura_grant(u)


def _evaluate_self_condition(entry: Dict, source: UnitInstance, lane: Lane,
                               excluding: Optional[UnitInstance]) -> bool:
    kind = str(entry.get("target_kind", ""))
    if kind == "self_if_friendly_banner_in_lane":
        return _is_friendly_banner_in_lane(lane, excluding=excluding)
    return False


# ---------------------------------------------------------------------------
# Card builders (mirror Scene G)
# ---------------------------------------------------------------------------

def mk_l41() -> Card:
    return Card(id="L41", display_name="Banner-Bearer of the Crowned Anvil",
                cost=3, hp=3, attack=2, keywords=set())


def mk_l34() -> Card:
    return Card(id="L34", display_name="Crowned Anvil Standard",
                cost=5, hp=8, attack=0, keywords=set())


# ---------------------------------------------------------------------------
# Scenes
# ---------------------------------------------------------------------------

def scene_g1_l41_alone() -> List[str]:
    errors = []
    lane = Lane(lane_index=0)
    l41 = lane.place_unit(mk_l41(), 1)
    if l41.current_attack() != 2:
        errors.append(f"G1: L41 alone should have base ATK=2, got {l41.current_attack()}")
    if l41.has_keyword(PIERCE):
        errors.append("G1: L41 alone should NOT have PIERCE (no banner)")
    if l41 in l41.aura_stats:
        errors.append("G1: L41 alone should have no self-grant entry")
    return errors


def scene_g2_banner_then_l41() -> List[str]:
    errors = []
    lane = Lane(lane_index=0)
    lane.place_unit(mk_l34(), 1)  # banner first
    l41 = lane.place_unit(mk_l41(), 2)
    if l41.current_attack() != 3:
        errors.append(f"G2: L41 with banner should have ATK=3, got {l41.current_attack()}")
    if not l41.has_keyword(PIERCE):
        errors.append("G2: L41 with banner should have PIERCE")
    if l41 not in l41.aura_stats:
        errors.append("G2: L41 with banner should have self-grant entry")
    return errors


def scene_g3_l41_then_banner_retroactive() -> List[str]:
    errors = []
    lane = Lane(lane_index=0)
    l41 = lane.place_unit(mk_l41(), 1)
    # Baseline pre-banner
    if l41.current_attack() != 2 or l41.has_keyword(PIERCE):
        errors.append(f"G3-pre: L41 pre-banner should be base 2 no-PIERCE; got ATK={l41.current_attack()} PIERCE={l41.has_keyword(PIERCE)}")
    # Banner enters — should retroactively activate L41's self-aura
    lane.place_unit(mk_l34(), 2)
    if l41.current_attack() != 3:
        errors.append(f"G3-post: L41 post-banner should have ATK=3, got {l41.current_attack()}")
    if not l41.has_keyword(PIERCE):
        errors.append("G3-post: L41 post-banner should have PIERCE")
    return errors


def scene_g4_banner_dies_revoke() -> List[str]:
    errors = []
    lane = Lane(lane_index=0)
    l34 = lane.place_unit(mk_l34(), 1)
    l41 = lane.place_unit(mk_l41(), 2)
    # Confirm setup grants
    if l41.current_attack() != 3 or not l41.has_keyword(PIERCE):
        errors.append("G4-setup: L41+banner should be 3/PIERCE before banner dies")
        return errors
    # Banner dies — self-aura should revoke via re-eval with exclude=l34
    l34.current_hp = 0
    lane.cull_dead_units()
    if l41.current_attack() != 2:
        errors.append(f"G4: post-banner-death L41 ATK should revert to 2, got {l41.current_attack()}")
    if l41.has_keyword(PIERCE):
        errors.append("G4: post-banner-death L41 should NOT have PIERCE")
    if l41 in l41.aura_stats:
        errors.append("G4: post-banner-death L41 should have self-grant cleared")
    return errors


def main():
    scenes = [
        ("G1 — L41 alone, no banner", scene_g1_l41_alone),
        ("G2 — L34 then L41, self-aura on enter", scene_g2_banner_then_l41),
        ("G3 — L41 then L34, retroactive grant", scene_g3_l41_then_banner_retroactive),
        ("G4 — banner dies, self-aura revoked", scene_g4_banner_dies_revoke),
    ]
    total_errors = 0
    for name, fn in scenes:
        errs = fn()
        if errs:
            print(f"FAIL — {name}")
            for e in errs:
                print(f"  • {e}")
        else:
            print(f"PASS — {name}")
        total_errors += len(errs)
    print()
    if total_errors == 0:
        print(f"l41_mirror PASS — {len(scenes)} scenes, 0 errors")
    else:
        print(f"l41_mirror FAIL — {total_errors} errors across {len(scenes)} scenes")
    return total_errors


if __name__ == "__main__":
    import sys
    sys.exit(main())
