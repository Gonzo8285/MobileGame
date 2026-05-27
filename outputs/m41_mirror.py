"""Python mirror of the M41.E1 state machine.
Validates: arm-once / consume / cap-once-per-turn / reset-on-turn / cost-formula.
"""

class GameState:
    ASH_MOURNERS = 1
    def __init__(self):
        self.mana = 5
        self.mourner_discount_armed = False
        self._fired_this_turn = False
        self.signal_log = []

    def arm(self):
        if self.mourner_discount_armed or self._fired_this_turn:
            return
        self.mourner_discount_armed = True
        self._fired_this_turn = True
        self.signal_log.append(("armed_changed", True))

    def consume(self):
        if not self.mourner_discount_armed:
            return
        self.mourner_discount_armed = False
        self.signal_log.append(("armed_changed", False))
        # _fired_this_turn stays True

    def compute_cost(self, faction, base_cost):
        if self.mourner_discount_armed and faction == self.ASH_MOURNERS:
            return max(0, base_cost - 1)
        return base_cost

    def next_turn(self):
        had = self.mourner_discount_armed
        self.mourner_discount_armed = False
        self._fired_this_turn = False
        if had:
            self.signal_log.append(("armed_changed", False))

errors = 0

# Scene 1: arm + consume happy path
gs = GameState()
gs.arm()
assert gs.mourner_discount_armed, "S1 arm failed"
assert gs.compute_cost(1, 3) == 2, f"S1 discount failed: {gs.compute_cost(1, 3)}"
assert gs.compute_cost(1, 0) == 0, "S1 floor-0 failed"
assert gs.compute_cost(0, 3) == 3, "S1 non-Mourner unaffected failed"  # IRON_PENITENTS
gs.consume()
assert not gs.mourner_discount_armed, "S1 consume failed"
print("S1 arm-consume happy path: OK")

# Scene 2: cap-once-per-turn — second arm blocked
gs = GameState()
gs.arm()
assert gs.mourner_discount_armed
gs.consume()
assert not gs.mourner_discount_armed
gs.arm()  # SHOULD BE BLOCKED — _fired_this_turn lock holds
assert not gs.mourner_discount_armed, "S2 re-arm should be blocked"
assert gs.compute_cost(1, 3) == 3, "S2 cost should be base after consume + blocked re-arm"
print("S2 cap-once-per-turn: OK")

# Scene 3: turn-reset clears both flags
gs = GameState()
gs.arm()
gs.consume()
gs.next_turn()
gs.arm()  # SHOULD succeed — turn reset cleared lock
assert gs.mourner_discount_armed, "S3 post-reset re-arm failed"
print("S3 turn-reset clears lock: OK")

# Scene 4: armed-but-unconsumed cleared on turn-start
gs = GameState()
gs.arm()
assert gs.mourner_discount_armed
gs.next_turn()
assert not gs.mourner_discount_armed, "S4 unconsumed-on-turn-reset failed"
# Confirm a signal fired for the implicit clear
assert ("armed_changed", False) in gs.signal_log, "S4 missing implicit clear signal"
print("S4 unconsumed flag cleared at turn-start: OK")

# Scene 5: arm idempotent — second arm in same turn before consume is no-op
gs = GameState()
gs.arm()
log_len = len(gs.signal_log)
gs.arm()  # already armed AND already fired this turn — no-op
assert len(gs.signal_log) == log_len, "S5 idempotent re-arm fired extra signal"
print("S5 idempotent arm: OK")

# Scene 6: consume on un-armed state is no-op
gs = GameState()
gs.consume()  # never armed — no-op
assert not gs.mourner_discount_armed
assert gs.signal_log == [], "S6 consume on un-armed fired spurious signal"
print("S6 consume-without-arm safe no-op: OK")

# Scene 7: discount stacks correctly across multiple turns
gs = GameState()
for t in range(3):
    gs.arm()
    assert gs.compute_cost(1, 4) == 3, f"S7 turn {t+1} discount failed"
    gs.consume()
    assert gs.compute_cost(1, 4) == 4, f"S7 turn {t+1} post-consume cost failed"
    gs.next_turn()
print("S7 multi-turn arm-consume cycle: OK")

print("\nAll 7 scenes PASS — M41.E1 state machine verified")
