#!/usr/bin/env python3
"""W4.E1 Bear-Skin Hierophant dynamic-outbound aura — Python mirror.

Verifies the algorithmic shape of `aura_dispatch.gd::_find_highest_cost_wilds_excluding`
+ `re_evaluate_dynamic_outbound_auras` + the lane-hook integration before
the GDScript runs in Godot. Mirrors Scene H of `turn_engine_test.gd`.

Run: `python3 outputs/w4_mirror.py` from the Gaming app project root.
Exits 0 on PASS, non-zero on assertion failure.

Anti-P2W: no monetisation state read anywhere; aura system is gameplay-only.
"""

from __future__ import annotations
from dataclasses import dataclass, field
from typing import Optional


# Faction enum (mirrors GFEnums.Faction integer values)
IRON_PENITENTS = 0
ASH_MOURNERS = 1
COVEN = 2
LAST_LEGION = 3
SKINWARD_PACT = 4
NEUTRAL = 5

# Keyword enum (mirrors GFEnums.Keyword — only CLEAVE used here)
KW_CLEAVE = 0
KW_PIERCE = 1
KW_LIFESTEAL = 16


@dataclass
class Card:
    card_id: str
    faction: int
    cost: int
    hp: int
    attack: int
    keywords: list[int] = field(default_factory=list)

    def has_keyword(self, kw: int) -> bool:
        return kw in self.keywords


@dataclass
class UnitInstance:
    card_data: Card
    tile: int
    lane_index: int = 0
    current_hp: int = 0
    atk_offset: int = 0
    # AURA.E1: dicts keyed by source UnitInstance (using object identity)
    aura_stats: dict = field(default_factory=dict)
    runtime_keywords: dict = field(default_factory=dict)

    def __post_init__(self):
        if self.current_hp == 0:
            self.current_hp = self.card_data.hp

    def is_alive(self) -> bool:
        return self.current_hp > 0

    def current_attack(self) -> int:
        aura_atk = sum(s.get("atk", 0) for s in self.aura_stats.values())
        return max(0, self.card_data.attack + self.atk_offset + aura_atk)

    def max_hp(self) -> int:
        aura_hp = sum(s.get("hp", 0) for s in self.aura_stats.values())
        return self.card_data.hp + aura_hp

    def has_keyword(self, kw: int) -> bool:
        if self.card_data.has_keyword(kw):
            return True
        for kws in self.runtime_keywords.values():
            if kw in kws:
                return True
        return False

    def apply_aura_grant(self, source, atk_buff: int, hp_buff: int,
                        keywords: list[int]) -> None:
        if source is None:
            return
        # Replace existing entry from same source.
        self.aura_stats[id(source)] = {"atk": atk_buff, "hp": max(0, hp_buff)}
        self.runtime_keywords[id(source)] = list(keywords)
        if hp_buff > 0:
            self.current_hp += hp_buff
        self.current_hp = min(self.current_hp, self.max_hp())
        if self.current_hp < 1:
            self.current_hp = 1

    def revoke_aura_grant(self, source) -> None:
        if source is None or id(source) not in self.aura_stats:
            return
        was_alive = self.is_alive()
        self.aura_stats.pop(id(source), None)
        self.runtime_keywords.pop(id(source), None)
        new_max = max(1, self.max_hp())
        self.current_hp = min(self.current_hp, new_max)
        # "Revoke never kills" floor — only applies to a unit that was alive
        # BEFORE revoke. A unit already at 0 HP (mid-cull dying target) must
        # not be resurrected to 1 HP by an unrelated revoke. Found by W4.E1
        # Scene H4 (W8 was the aura holder, dies; subsequent revoke from
        # cull pre-hook re-floored W8 to 1 → broke target-shift-on-death).
        if self.current_hp < 1 and was_alive:
            self.current_hp = 1


@dataclass
class Lane:
    lane_index: int = 0
    tile_count: int = 6
    friendly_units: list[UnitInstance] = field(default_factory=list)

    def place_unit(self, card: Card, tile: int) -> UnitInstance:
        for u in self.friendly_units:
            if u.tile == tile and u.is_alive():
                return None
        u = UnitInstance(card_data=card, tile=tile, lane_index=self.lane_index)
        self.friendly_units.append(u)
        # Mirrors lane.gd::_on_unit_entered_lane
        for source in list(self.friendly_units):
            if source is u:
                continue
            AuraDispatch.maybe_grant(source, u, self)
        AuraDispatch.maybe_grant(u, None, self)
        # re_evaluate_self_auras skipped (no self-aura cards in this test)
        AuraDispatch.re_evaluate_dynamic_outbound_auras(self, None)
        return u

    def cull_dead_units(self) -> int:
        removed = 0
        for u in list(self.friendly_units):
            if not u.is_alive():
                # _on_unit_leaving_lane
                AuraDispatch.revoke_all_from(u, self)
                # re_evaluate_self_auras skipped
                AuraDispatch.re_evaluate_dynamic_outbound_auras(self, u)
                self.friendly_units.remove(u)
                removed += 1
        return removed


# ============================================================================
# AuraDispatch — mirrors aura_dispatch.gd
# ============================================================================

class AuraDispatch:

    @staticmethod
    def _entry_for(card_id: str) -> dict:
        if card_id == "W4":
            return {
                "target_kind": "highest_cost_wilds",
                "target_param": None,
                "grant": {"atk": 0, "hp": 2, "keywords": [KW_CLEAVE]},
            }
        return {}

    @staticmethod
    def _is_dynamic_outbound_kind(kind: str) -> bool:
        return kind == "highest_cost_wilds"

    @staticmethod
    def _find_highest_cost_wilds_excluding(source: UnitInstance, lane: Lane) -> Optional[UnitInstance]:
        if lane is None:
            return None
        max_cost = -1
        winner = None
        for u in lane.friendly_units:
            if u is None or u is source:
                continue
            if not u.is_alive():
                continue
            if u.card_data is None:
                continue
            if u.card_data.faction != SKINWARD_PACT:
                continue
            cost = u.card_data.cost
            if (winner is None
                    or cost > max_cost
                    or (cost == max_cost and u.tile < winner.tile)):
                max_cost = cost
                winner = u
        return winner

    @staticmethod
    def _is_highest_cost_wilds_excluding(source: UnitInstance,
                                        candidate: UnitInstance,
                                        lane: Lane) -> bool:
        if candidate is None or candidate.card_data is None:
            return False
        if not candidate.is_alive():
            return False
        if candidate is source:
            return False
        if candidate.card_data.faction != SKINWARD_PACT:
            return False
        winner = AuraDispatch._find_highest_cost_wilds_excluding(source, lane)
        return winner is not None and winner is candidate

    @staticmethod
    def _matches_target(entry: dict, source: UnitInstance,
                       candidate: UnitInstance, lane: Lane) -> bool:
        if candidate is None or candidate.card_data is None:
            return False
        if not candidate.is_alive():
            return False
        kind = entry.get("target_kind", "")
        if kind == "highest_cost_wilds":
            return AuraDispatch._is_highest_cost_wilds_excluding(source, candidate, lane)
        return False

    @staticmethod
    def maybe_grant(source: UnitInstance, candidate: Optional[UnitInstance],
                    lane: Lane) -> None:
        if source is None or source.card_data is None:
            return
        entry = AuraDispatch._entry_for(source.card_data.card_id)
        if not entry:
            return
        targets = []
        if candidate is not None:
            targets.append(candidate)
        else:
            for u in lane.friendly_units:
                if u is None or u is source:
                    continue
                targets.append(u)
        for t in targets:
            if t is None or t is source:
                continue
            if not AuraDispatch._matches_target(entry, source, t, lane):
                continue
            spec = entry["grant"]
            t.apply_aura_grant(
                source,
                int(spec.get("atk", 0)),
                int(spec.get("hp", 0)),
                spec.get("keywords", []),
            )

    @staticmethod
    def revoke_all_from(leaving_source: UnitInstance, lane: Lane) -> None:
        if leaving_source is None:
            return
        for u in lane.friendly_units:
            if u is None:
                continue
            u.revoke_aura_grant(leaving_source)

    @staticmethod
    def re_evaluate_dynamic_outbound_auras(lane: Lane,
                                          excluding: Optional[UnitInstance] = None) -> None:
        if lane is None:
            return
        for source in list(lane.friendly_units):
            if source is None or source is excluding:
                continue
            if source.card_data is None:
                continue
            entry = AuraDispatch._entry_for(source.card_data.card_id)
            if not entry:
                continue
            if not AuraDispatch._is_dynamic_outbound_kind(entry.get("target_kind", "")):
                continue
            AuraDispatch.revoke_all_from(source, lane)
            AuraDispatch.maybe_grant(source, None, lane)


# ============================================================================
# Card factories
# ============================================================================

def mk_w4() -> Card:
    return Card("W4", SKINWARD_PACT, cost=4, hp=4, attack=3)


def mk_wilds(card_id: str, cost: int) -> Card:
    return Card(card_id, SKINWARD_PACT, cost=cost, hp=2, attack=2)


def mk_legion(card_id: str, cost: int) -> Card:
    return Card(card_id, LAST_LEGION, cost=cost, hp=5, attack=2)


# ============================================================================
# Scene H — W4 dynamic outbound aura
# ============================================================================

def scene_h_w4_dynamic_outbound() -> int:
    errors = 0

    # H1: W4 alone — no grant
    lane = Lane(lane_index=0)
    w4 = lane.place_unit(mk_w4(), 1)
    assert w4 is not None, "H1: W4 place_unit failed"
    if w4.aura_stats:
        print(f"H1: W4 should have no aura grants alone, got {w4.aura_stats}")
        errors += 1

    # H2: W4 + W3 (cost 2) — W3 receives the grant
    w3 = lane.place_unit(mk_wilds("W3", cost=2), 2)
    assert w3 is not None, "H2: W3 place_unit failed"
    if w3.max_hp() != 4:
        print(f"H2: W3 max_hp expected 4, got {w3.max_hp()}")
        errors += 1
    if w3.current_hp != 4:
        print(f"H2: W3 current_hp expected 4 (full after aura), got {w3.current_hp}")
        errors += 1
    if not w3.has_keyword(KW_CLEAVE):
        print(f"H2: W3 should have CLEAVE from W4 aura")
        errors += 1

    # H3: W8 (cost 6) enters — grant shifts onto W8, W3 reverts
    w8 = lane.place_unit(mk_wilds("W8", cost=6), 3)
    assert w8 is not None, "H3: W8 place_unit failed"
    if w8.max_hp() != 4 or not w8.has_keyword(KW_CLEAVE):
        print(f"H3: W8 (new max) should hold grant, got max_hp={w8.max_hp()} "
              f"CLEAVE={w8.has_keyword(KW_CLEAVE)}")
        errors += 1
    if w3.max_hp() != 2:
        print(f"H3: W3 max_hp should revert to 2, got {w3.max_hp()}")
        errors += 1
    if w3.has_keyword(KW_CLEAVE):
        print(f"H3: W3 should LOSE CLEAVE after target shift")
        errors += 1
    if w3.current_hp > w3.max_hp():
        print(f"H3: W3 current_hp must clamp to max: cur={w3.current_hp} max={w3.max_hp()}")
        errors += 1
    if not w3.is_alive():
        print(f"H3: W3 must remain alive after revoke (floor 1)")
        errors += 1

    # H4: W8 dies — grant returns to W3
    w8.current_hp = 0
    lane.cull_dead_units()
    if w3.max_hp() != 4:
        print(f"H4: W3 should regain aura after W8 cull, max_hp expected 4, got {w3.max_hp()}")
        errors += 1
    if not w3.has_keyword(KW_CLEAVE):
        print(f"H4: W3 should regain CLEAVE after W8 cull")
        errors += 1

    # H5: W4 + non-Wilds (Legion) — no grant
    lane_h5 = Lane(lane_index=1)
    w4_h5 = lane_h5.place_unit(mk_w4(), 1)
    legion = lane_h5.place_unit(mk_legion("LX", cost=6), 2)
    assert w4_h5 is not None and legion is not None, "H5: setup failed"
    if legion.max_hp() != 5:
        print(f"H5: non-Wilds should not receive aura, max_hp expected 5, got {legion.max_hp()}")
        errors += 1
    if legion.has_keyword(KW_CLEAVE):
        print(f"H5: non-Wilds should NOT have CLEAVE from W4")
        errors += 1
    if legion.aura_stats:
        print(f"H5: non-Wilds aura_stats should be empty, got {legion.aura_stats}")
        errors += 1

    return errors


def main() -> int:
    print("=== W4.E1 Bear-Skin Hierophant dynamic-outbound aura (Python mirror) ===")
    errors = scene_h_w4_dynamic_outbound()
    if errors == 0:
        print("[w4_mirror] PASS — Scene H (5 cases) 0 failures")
        return 0
    print(f"[w4_mirror] FAIL — {errors} assertion(s) failed")
    return 1


if __name__ == "__main__":
    import sys
    sys.exit(main())
    return errors


def main() -> int:
    print("=== W4.E1 Bear-Skin Hierophant dynamic-outbound aura (Python mirror) ===")
    errors = scene_h_w4_dynamic_outbound()
    if errors == 0:
        print("[w4_mirror] PASS — Scene H (5 cases) 0 failures")
        return 0
    else:
        print(f"[w4_mirror] FAIL — {errors} assertion(s) failed")
        return 1


if __name__ == "__main__":
    import sys
    sys.exit(main())

    return errors


def main() -> int:
    print("=== W4.E1 Bear-Skin Hierophant dynamic-outbound aura (Python mirror) ===")
    errors = scene_h_w4_dynamic_outbound()
    if errors == 0:
        print("[w4_mirror] PASS — Scene H (5 cases) 0 failures")
        return 0
    print(f"[w4_mirror] FAIL — {errors} assertion(s) failed")
    return 1


if __name__ == "__main__":
    import sys
    sys.exit(main())
