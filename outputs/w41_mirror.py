"""
W41 Pack-Caller Initiate — Wolf-Token draw trigger Python state-machine mirror.

Phase 2.16 W41.E1 verification surface (Controller hourly backlog cycle #22,
2026-05-27). Mirrors the W41 trigger semantics implemented in
`game/src/runtime/game_state.gd` (`try_trigger_wolf_summon_draw`) and
`game/src/runtime/combat.gd` (`_on_unit_placed`'s W41 branch) so we can prove
arm-once / draw / cap-once-per-turn / reset-on-turn / lane-scoping end-to-end
without a live Godot runtime.

The sandbox cannot execute GDScript; this mirror is the validation surface
for the Combat-level trigger (same convention as `outputs/m41_mirror.py`
for M41.E1 — neither lives in the turn_engine_test.gd GDScript test runner
because both triggers are Combat-level, not turn-engine-level).

Run with:  python3 outputs/w41_mirror.py
Exit code 0 = all scenes PASS; 1 = at least one assertion FAILED.

Anti-P2W invariant: no monetisation state involved; trigger reads only
`card.id`, lane-membership, and the once-per-turn flag.
"""

from __future__ import annotations
from dataclasses import dataclass, field
from typing import List, Optional


# ---------------------------------------------------------------------------
# Minimal mirror types — just enough to model W41.E1 behaviour. NOT a
# replica of UnitInstance / Lane / GameState — only the fields the W41
# trigger reads.
# ---------------------------------------------------------------------------

@dataclass
class Card:
    id: str
    display_name: str = ""


@dataclass
class Unit:
    card: Card
    lane_index: int
    alive: bool = True

    def is_alive(self) -> bool:
        return self.alive


@dataclass
class Lane:
    lane_index: int
    friendly_units: List[Unit] = field(default_factory=list)

    def place_unit(self, card: Card) -> Unit:
        u = Unit(card=card, lane_index=self.lane_index, alive=True)
        self.friendly_units.append(u)
        return u


@dataclass
class GameStateMirror:
    """Minimal GameState mirror: deck/hand/discard as int counts + the
    once-per-turn flag. Counts are enough — we only care that try_trigger
    decrements deck and increments hand by 1 on success."""
    deck: int = 5
    hand: int = 0
    discard: int = 0
    hand_cap: int = 7
    wolf_summon_draw_fired_this_turn: bool = False
    draws_logged: int = 0

    def next_turn(self) -> None:
        """Mirror of GameState.next_turn's W41 reset only."""
        self.wolf_summon_draw_fired_this_turn = False

    def try_trigger_wolf_summon_draw(self) -> bool:
        """Mirror of game_state.gd::try_trigger_wolf_summon_draw."""
        if self.wolf_summon_draw_fired_this_turn:
            return False
        # Burn-mill: if deck empty but discard non-empty, recycle.
        if self.deck == 0 and self.discard > 0:
            self.deck = self.discard
            self.discard = 0
        if self.deck == 0:
            # Burn-mill terminal — no draw fired, flag stays clear.
            return False
        # Draw one.
        self.deck -= 1
        self.wolf_summon_draw_fired_this_turn = True
        if self.hand < self.hand_cap:
            self.hand += 1
        else:
            # Hand overflow → discard.
            self.discard += 1
        self.draws_logged += 1
        return True


def on_unit_placed(unit: Unit, lane: Lane, gs: GameStateMirror) -> bool:
    """Mirror of combat.gd::_on_unit_placed's W41 branch.

    Returns True if the W41 trigger attempted (regardless of whether the
    draw actually fired — caller can check gs.draws_logged delta for the
    actual-draw outcome). Used so tests can distinguish "trigger conditions
    met but capped" from "trigger conditions NOT met".
    """
    if unit.card.id != "W28":
        return False
    # Walk lane.friendly_units looking for an alive W41.
    has_w41 = any(
        u.is_alive() and u.card.id == "W41"
        for u in lane.friendly_units
    )
    if not has_w41:
        return False
    gs.try_trigger_wolf_summon_draw()
    return True


# ---------------------------------------------------------------------------
# Test scenes — J1..J6 per W41.E1 spec.
# Each scene starts from a fresh GameState + Lane setup.
# ---------------------------------------------------------------------------

FAILURES: List[str] = []


def expect(label: str, actual, expected) -> None:
    if actual == expected:
        print(f"  PASS  {label}: {actual}")
    else:
        print(f"  FAIL  {label}: got {actual!r}, expected {expected!r}")
        FAILURES.append(label)


def scene_j1_w41_alone_no_trigger() -> None:
    """J1 — W41 alone in lane, NO Wolf-Token placed → no draw."""
    print("\nJ1: W41 alone in lane, no Wolf-Token placed")
    gs = GameStateMirror(deck=5, hand=0)
    lane = Lane(lane_index=0)
    # Place W41 itself. _on_unit_placed runs but W41 isn't a Wolf-Token.
    w41_card = Card(id="W41", display_name="Pack-Caller Initiate")
    w41 = lane.place_unit(w41_card)
    on_unit_placed(w41, lane, gs)
    expect("J1 deck unchanged", gs.deck, 5)
    expect("J1 hand unchanged", gs.hand, 0)
    expect("J1 flag still clear", gs.wolf_summon_draw_fired_this_turn, False)
    expect("J1 draws_logged", gs.draws_logged, 0)


def scene_j2_wolf_token_w41_in_lane_draws() -> None:
    """J2 — Wolf-Token placed with W41 alive in same lane → draws 1."""
    print("\nJ2: Wolf-Token placed with W41 in same lane")
    gs = GameStateMirror(deck=5, hand=0)
    lane = Lane(lane_index=0)
    w41 = lane.place_unit(Card(id="W41"))
    on_unit_placed(w41, lane, gs)  # placing W41 doesn't trigger
    expect("J2 W41-place no-draw", gs.draws_logged, 0)
    wolf = lane.place_unit(Card(id="W28", display_name="Wolf-Token"))
    on_unit_placed(wolf, lane, gs)
    expect("J2 wolf-place draws", gs.draws_logged, 1)
    expect("J2 deck decremented", gs.deck, 4)
    expect("J2 hand incremented", gs.hand, 1)
    expect("J2 flag now set", gs.wolf_summon_draw_fired_this_turn, True)


def scene_j3_wolf_token_no_w41_no_draw() -> None:
    """J3 — Wolf-Token placed, NO W41 in lane → no draw."""
    print("\nJ3: Wolf-Token placed with NO W41 in lane")
    gs = GameStateMirror(deck=5, hand=0)
    lane = Lane(lane_index=0)
    wolf = lane.place_unit(Card(id="W28"))
    on_unit_placed(wolf, lane, gs)
    expect("J3 no draw", gs.draws_logged, 0)
    expect("J3 deck unchanged", gs.deck, 5)
    expect("J3 flag still clear", gs.wolf_summon_draw_fired_this_turn, False)


def scene_j4_second_wolf_same_turn_capped() -> None:
    """J4 — Two Wolf-Tokens placed same turn with W41 → only first draws.

    Verifies the cap-once-per-turn semantics: the trigger fires on the
    first Wolf-Token but is locked out for the second.
    """
    print("\nJ4: Two Wolf-Tokens same turn — second is capped")
    gs = GameStateMirror(deck=5, hand=0)
    lane = Lane(lane_index=0)
    lane.place_unit(Card(id="W41"))
    wolf_a = lane.place_unit(Card(id="W28"))
    on_unit_placed(wolf_a, lane, gs)
    expect("J4 first wolf draws", gs.draws_logged, 1)
    wolf_b = lane.place_unit(Card(id="W28"))
    on_unit_placed(wolf_b, lane, gs)
    expect("J4 second wolf capped", gs.draws_logged, 1)
    expect("J4 deck only -1 total", gs.deck, 4)
    expect("J4 hand only +1 total", gs.hand, 1)


def scene_j5_wolf_different_lane_no_draw() -> None:
    """J5 — Wolf-Token in a different lane from W41 → no draw."""
    print("\nJ5: Wolf-Token in different lane from W41")
    gs = GameStateMirror(deck=5, hand=0)
    lane_a = Lane(lane_index=0)
    lane_b = Lane(lane_index=1)
    lane_a.place_unit(Card(id="W41"))  # W41 in lane 0
    wolf = lane_b.place_unit(Card(id="W28"))  # Wolf in lane 1
    on_unit_placed(wolf, lane_b, gs)
    expect("J5 no draw — wrong lane", gs.draws_logged, 0)
    expect("J5 flag still clear", gs.wolf_summon_draw_fired_this_turn, False)


def scene_j6_turn_reset_allows_retrigger() -> None:
    """J6 — Cap clears on turn_started so next turn re-triggers."""
    print("\nJ6: Turn reset allows re-trigger")
    gs = GameStateMirror(deck=10, hand=0)
    lane = Lane(lane_index=0)
    lane.place_unit(Card(id="W41"))
    # Turn 1: first wolf draws, second wolf capped.
    wolf_t1a = lane.place_unit(Card(id="W28"))
    on_unit_placed(wolf_t1a, lane, gs)
    wolf_t1b = lane.place_unit(Card(id="W28"))
    on_unit_placed(wolf_t1b, lane, gs)
    expect("J6 T1 draws=1", gs.draws_logged, 1)
    # Turn boundary — cap clears.
    gs.next_turn()
    expect("J6 flag cleared on turn", gs.wolf_summon_draw_fired_this_turn, False)
    # Turn 2: first wolf draws again.
    wolf_t2a = lane.place_unit(Card(id="W28"))
    on_unit_placed(wolf_t2a, lane, gs)
    expect("J6 T2 first draws", gs.draws_logged, 2)
    expect("J6 hand+2 total", gs.hand, 2)


def scene_j7_dead_w41_does_not_count() -> None:
    """J7 — W41 in lane but is_alive() = False → no draw.

    Edge case: W41 was killed earlier this turn (cull moves it out of
    friendly_units, but in pre-cull window it can still be in the array).
    The trigger checks is_alive() not just lane membership, mirroring the
    M41 pattern (`u.is_alive()`).
    """
    print("\nJ7: Dead W41 in lane does not count")
    gs = GameStateMirror(deck=5, hand=0)
    lane = Lane(lane_index=0)
    w41 = lane.place_unit(Card(id="W41"))
    w41.alive = False  # killed mid-turn, not yet culled
    wolf = lane.place_unit(Card(id="W28"))
    on_unit_placed(wolf, lane, gs)
    expect("J7 dead W41 no draw", gs.draws_logged, 0)


def scene_j8_burnmill_empty_deck_no_flag_burn() -> None:
    """J8 — Deck+discard both empty → no draw, flag stays clear so a later
    deck refill can still fire the trigger this turn.
    """
    print("\nJ8: Burn-mill terminal — no flag burn on failed draw")
    gs = GameStateMirror(deck=0, discard=0, hand=0)
    lane = Lane(lane_index=0)
    lane.place_unit(Card(id="W41"))
    wolf = lane.place_unit(Card(id="W28"))
    on_unit_placed(wolf, lane, gs)
    expect("J8 no draw", gs.draws_logged, 0)
    expect("J8 flag still clear", gs.wolf_summon_draw_fired_this_turn, False)
    # Simulate a mid-turn deck reseed (e.g. a spell effect adds a card).
    gs.deck = 1
    wolf2 = lane.place_unit(Card(id="W28"))
    on_unit_placed(wolf2, lane, gs)
    expect("J8 post-reseed draws", gs.draws_logged, 1)


# ---------------------------------------------------------------------------
# Runner
# ---------------------------------------------------------------------------

def main() -> int:
    print("=" * 72)
    print("W41 Pack-Caller Initiate Wolf-Token draw trigger — Python mirror")
    print("Phase 2.16 W41.E1 verification — Controller cycle #22, 2026-05-27")
    print("=" * 72)

    scene_j1_w41_alone_no_trigger()
    scene_j2_wolf_token_w41_in_lane_draws()
    scene_j3_wolf_token_no_w41_no_draw()
    scene_j4_second_wolf_same_turn_capped()
    scene_j5_wolf_different_lane_no_draw()
    scene_j6_turn_reset_allows_retrigger()
    scene_j7_dead_w41_does_not_count()
    scene_j8_burnmill_empty_deck_no_flag_burn()

    print("\n" + "=" * 72)
    if FAILURES:
        print(f"FAIL — {len(FAILURES)} assertion(s) failed:")
        for f in FAILURES:
            print(f"  - {f}")
        return 1
    print("PASS — all 8 scenes (J1..J8) green, 0 failures.")
    print("=" * 72)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
