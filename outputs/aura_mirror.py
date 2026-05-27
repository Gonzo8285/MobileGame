"""
AURA.E1 Python mirror — verifies F1-F6 from keywords/aura_v0.md against a
faithful port of unit_instance.gd + lane.gd + aura_dispatch.gd behaviour.

GDScript can't be exercised in the sandbox; this mirror replays the same
plumbing (runtime_keywords + aura_stats source-keyed dicts, max_hp / current_attack
sums, apply/revoke semantics, place_unit on-enter hook, cull_dead leave hook,
W42 -> Wolf-Token dispatch rule) so logical regressions are caught here.

Sister to outputs/m41_mirror.py, outputs/reward_mirror.py, outputs/map_mirror.py.
Run: python3 aura_mirror.py  (stdlib only)
"""

from dataclasses import dataclass, field
from typing import Optional


# ----- enum sentinels (mirror GFEnums.Keyword) ---------------------------
LIFESTEAL = 16
TAUNT = 15
PIERCE = 1
SHIELD = 2  # placeholder
CARD_UNIT = 0


# ----- Card (subset) ------------------------------------------------------
@dataclass
class Card:
    id: str
    name: str
    cost: int
    hp: int
    attack: int
    card_type: int = CARD_UNIT
    keywords: list[int] = field(default_factory=list)
    is_draftable: bool = True

    def has_keyword(self, kw: int) -> bool:
        return kw in self.keywords


# ----- UnitInstance (mirrors game/src/runtime/unit_instance.gd) ----------
class UnitInstance:
    def __init__(self, card: Card, tile: int, lane_index: int):
        self.card_data = card
        self.current_hp = card.hp
        self.lane_index = lane_index
        self.tile = tile
        self.cooldown_counter = 0
        self.atk_offset = 0
        self.has_persisted = False
        self.is_token = False
        # AURA.E1 plumbing — source-keyed so partial revoke is clean
        self.runtime_keywords: dict[int, list[int]] = {}  # id(source) -> kw list
        self.aura_stats: dict[int, dict[str, int]] = {}   # id(source) -> {atk, hp}
        self._aura_sources: dict[int, UnitInstance] = {}  # keep refs alive

    def is_alive(self) -> bool:
        return self.current_hp > 0

    def _aura_atk_sum(self) -> int:
        return sum(s.get("atk", 0) for s in self.aura_stats.values())

    def _aura_hp_sum(self) -> int:
        return sum(s.get("hp", 0) for s in self.aura_stats.values())

    def max_hp(self) -> int:
        return self.card_data.hp + self._aura_hp_sum()

    def current_attack(self) -> int:
        return max(0, self.card_data.attack + self.atk_offset + self._aura_atk_sum())

    def has_keyword(self, kw: int) -> bool:
        if self.card_data.has_keyword(kw):
            return True
        for granted in self.runtime_keywords.values():
            if kw in granted:
                return True
        return False

    def apply_aura_grant(self, source: "UnitInstance", atk_buff: int,
                         hp_buff: int, keywords: list[int]) -> None:
        if source is None:
            return
        # Replace (don't stack from same source); HP delta applied cleanly.
        sid = id(source)
        self._aura_sources[sid] = source
        prev_hp = int(self.aura_stats.get(sid, {}).get("hp", 0))
        self.aura_stats[sid] = {"atk": atk_buff, "hp": max(0, hp_buff)}
        self.runtime_keywords[sid] = list(keywords)
        if hp_buff > 0:
            # Raise current_hp by NEW grant (subtract prev if replacing)
            self.current_hp += hp_buff - prev_hp
        self.current_hp = min(self.current_hp, self.max_hp())
        if self.current_hp < 1:
            self.current_hp = 1

    def revoke_aura_grant(self, source: "UnitInstance") -> None:
        if source is None:
            return
        sid = id(source)
        if sid not in self.aura_stats:
            return
        del self.aura_stats[sid]
        del self.runtime_keywords[sid]
        self._aura_sources.pop(sid, None)
        new_max = max(1, self.max_hp())
        self.current_hp = min(self.current_hp, new_max)
        if self.current_hp < 1:
            self.current_hp = 1


# ----- AuraDispatch (mirrors aura_dispatch.gd) ---------------------------
def _entry_for(card_id: str) -> Optional[dict]:
    if card_id == "W42":
        return {
            "target_kind": "friendly_token_with_id",
            "target_param": "W28",
            "grant": {"atk": 1, "hp": 1, "keywords": [LIFESTEAL]},
        }
    return None


def _matches_target(entry: dict, source: UnitInstance,
                    candidate: UnitInstance, lane: "Lane") -> bool:
    if candidate is None or not candidate.is_alive():
        return False
    if candidate.lane_index != source.lane_index:
        return False
    kind = entry.get("target_kind", "")
    if kind == "friendly_token_with_id":
        return candidate.card_data.id == entry.get("target_param")
    if kind == "friendly_id":
        return candidate.card_data.id == entry.get("target_param")
    return False


def maybe_grant(source: UnitInstance, candidate: Optional[UnitInstance],
                lane: "Lane") -> None:
    if source is None:
        return
    entry = _entry_for(source.card_data.id)
    if entry is None:
        return
    targets = []
    if candidate is not None:
        targets = [candidate]
    else:
        for u in lane.friendly_units:
            if u is source:
                continue
            targets.append(u)
    for t in targets:
        if t is None or t is source:
            continue
        if not _matches_target(entry, source, t, lane):
            continue
        spec = entry["grant"]
        t.apply_aura_grant(
            source,
            int(spec.get("atk", 0)),
            int(spec.get("hp", 0)),
            spec.get("keywords", []),
        )


def revoke_all_from(leaving_source: UnitInstance, lane: "Lane") -> None:
    if leaving_source is None:
        return
    for u in lane.friendly_units:
        if u is None:
            continue
        u.revoke_aura_grant(leaving_source)


# ----- Lane (subset — place_unit + cull_dead_units + on-enter/leave) -----
class Lane:
    def __init__(self, idx: int = 0, tiles: int = 6):
        self.lane_index = idx
        self.tile_count = tiles
        self.friendly_units: list[UnitInstance] = []

    def is_tile_in_range(self, t: int) -> bool:
        return 1 <= t < self.tile_count

    def is_tile_occupied(self, t: int) -> bool:
        return any(u for u in self.friendly_units if u.is_alive() and u.tile == t)

    def place_unit(self, card: Card, tile_idx: int) -> Optional[UnitInstance]:
        if card is None or card.card_type != CARD_UNIT:
            return None
        if not self.is_tile_in_range(tile_idx):
            return None
        if self.is_tile_occupied(tile_idx):
            return None
        u = UnitInstance(card, tile_idx, self.lane_index)
        self.friendly_units.append(u)
        self._on_unit_entered_lane(u)
        return u

    def _on_unit_entered_lane(self, new_unit: UnitInstance) -> None:
        for source in self.friendly_units:
            if source is new_unit:
                continue
            maybe_grant(source, new_unit, self)
        maybe_grant(new_unit, None, self)

    def _on_unit_leaving_lane(self, leaving: UnitInstance) -> None:
        revoke_all_from(leaving, self)

    def cull_dead_units(self) -> int:
        removed = 0
        for u in list(self.friendly_units):
            if not u.is_alive():
                self._on_unit_leaving_lane(u)
                self.friendly_units.remove(u)
                removed += 1
        return removed


# ----- Card factories ----------------------------------------------------
def mk_w28() -> Card:
    return Card(id="W28", name="Wolf-Token", cost=0, hp=2, attack=1)


def mk_w42() -> Card:
    return Card(id="W42", name="Den-Mother of the Cinderwood",
                cost=4, hp=4, attack=2)


# ----- Scene runners (parallel to GDScript test scenes) -------------------
def assert_eq(label: str, got, want) -> int:
    if got != want:
        print(f"  FAIL {label}: got {got!r}, want {want!r}")
        return 1
    return 0


def scene_f1_f2(verbose=True) -> int:
    err = 0
    lane = Lane()
    t1 = lane.place_unit(mk_w28(), 1)
    t2 = lane.place_unit(mk_w28(), 2)
    err += assert_eq("F1-baseline t1.max_hp", t1.max_hp(), 2)
    err += assert_eq("F1-baseline t1.atk", t1.current_attack(), 1)
    w42 = lane.place_unit(mk_w42(), 3)
    for label, tok in [("F1-t1", t1), ("F1-t2", t2)]:
        err += assert_eq(f"{label}.atk", tok.current_attack(), 2)
        err += assert_eq(f"{label}.max_hp", tok.max_hp(), 3)
        err += assert_eq(f"{label}.has_LS", tok.has_keyword(LIFESTEAL), True)
    # F2 — late-arriving token
    t3 = lane.place_unit(mk_w28(), 4)
    err += assert_eq("F2-t3.atk", t3.current_attack(), 2)
    err += assert_eq("F2-t3.max_hp", t3.max_hp(), 3)
    err += assert_eq("F2-t3.has_LS", t3.has_keyword(LIFESTEAL), True)
    # F3 — W42 dies, revoke fires
    w42.current_hp = 0
    lane.cull_dead_units()
    for label, tok in [("F3-t1", t1), ("F3-t2", t2), ("F3-t3", t3)]:
        err += assert_eq(f"{label}.atk", tok.current_attack(), 1)
        err += assert_eq(f"{label}.max_hp", tok.max_hp(), 2)
        err += assert_eq(f"{label}.has_LS", tok.has_keyword(LIFESTEAL), False)
        err += assert_eq(f"{label}.aura_stats", tok.aura_stats, {})
        err += assert_eq(f"{label}.runtime_keywords", tok.runtime_keywords, {})
    if verbose:
        print(f"  F1+F2+F3: {err} failure(s)")
    return err


def scene_f4(verbose=True) -> int:
    err = 0
    lane = Lane(idx=1)
    t = lane.place_unit(mk_w28(), 1)
    w_b = lane.place_unit(mk_w42(), 2)
    w_c = lane.place_unit(mk_w42(), 3)
    # Double aura: +2/+2 additive, LIFESTEAL still single (set-union)
    err += assert_eq("F4-double.atk", t.current_attack(), 3)
    err += assert_eq("F4-double.max_hp", t.max_hp(), 4)
    err += assert_eq("F4-double.has_LS", t.has_keyword(LIFESTEAL), True)
    # Kill one Den-Mother — drops to +1/+1, LIFESTEAL persists from other
    w_b.current_hp = 0
    lane.cull_dead_units()
    err += assert_eq("F4-single.atk", t.current_attack(), 2)
    err += assert_eq("F4-single.max_hp", t.max_hp(), 3)
    err += assert_eq("F4-single.has_LS", t.has_keyword(LIFESTEAL), True)
    if w_c is None:
        err += 1
    if verbose:
        print(f"  F4: {err} failure(s)")
    return err


def scene_f5(verbose=True) -> int:
    err = 0
    lane = Lane(idx=2)
    t = lane.place_unit(mk_w28(), 1)
    w_d = lane.place_unit(mk_w42(), 2)
    w_e = lane.place_unit(mk_w42(), 3)
    # Setup — full HP under double aura should be 4/4
    err += assert_eq("F5-setup.current_hp", t.current_hp, 4)
    err += assert_eq("F5-setup.max_hp", t.max_hp(), 4)
    # One Den-Mother dies → max drops to 3 → current must clamp to 3
    w_d.current_hp = 0
    lane.cull_dead_units()
    err += assert_eq("F5-clamp.max_hp", t.max_hp(), 3)
    err += assert_eq("F5-clamp.current_hp", t.current_hp, 3)
    if w_e is None:
        err += 1
    if verbose:
        print(f"  F5: {err} failure(s)")
    return err


def scene_f6(verbose=True) -> int:
    err = 0
    lane = Lane()
    t = lane.place_unit(mk_w28(), 1)
    w_f = lane.place_unit(mk_w42(), 2)
    w_g = lane.place_unit(mk_w42(), 3)
    # Damage token to 1/4 under double aura
    t.current_hp = 1
    # Kill both Den-Mothers — must NOT kill the token (floor at 1)
    w_f.current_hp = 0
    w_g.current_hp = 0
    lane.cull_dead_units()
    err += assert_eq("F6-floor.alive", t.is_alive(), True)
    err += assert_eq("F6-floor.current_hp", t.current_hp, 1)
    err += assert_eq("F6-floor.max_hp", t.max_hp(), 2)
    if verbose:
        print(f"  F6: {err} failure(s)")
    return err


def main() -> int:
    print("AURA.E1 Python mirror — F1-F6 scenes")
    total = 0
    total += scene_f1_f2()
    total += scene_f4()
    total += scene_f5()
    total += scene_f6()
    if total == 0:
        print("\n[aura_mirror] PASS (all F1-F6 scenes green)")
        return 0
    else:
        print(f"\n[aura_mirror] FAIL — {total} assertion(s) failed")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
