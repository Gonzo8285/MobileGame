extends GFTest

## GameState run/combat lifecycle, mana, and HP rules.

func _starter() -> Array[Card]:
	var out: Array[Card] = []
	for i: int in range(5):
		out.append(GFFactory.unit_card(StringName("S%d" % i), 1, 3, 2))
	return out

func before_each() -> void:
	GameState.start_run(_starter(), &"test_warlord", 12345)

func test_start_run_initialises_zones_and_vitals() -> void:
	assert_not_null(GameState.deck, "deck created")
	assert_not_null(GameState.hand, "hand created")
	assert_not_null(GameState.discard, "discard created")
	assert_eq(GameState.base_hp, GameState.max_base_hp, "full HP at run start")
	assert_eq(GameState.current_phase, GFEnums.RunPhase.MAP, "starts in MAP phase")

func test_spend_mana_success_and_failure() -> void:
	GameState.max_mana = 3
	GameState.mana = 3
	assert_true(GameState.spend_mana(2), "can afford 2 of 3")
	assert_eq(GameState.mana, 1, "1 mana left")
	assert_false(GameState.spend_mana(5), "cannot overspend")
	assert_eq(GameState.mana, 1, "no deduction on failed spend")

func test_gain_mana_respects_overflow_cap() -> void:
	GameState.max_mana = 3
	GameState.mana = 3
	GameState.gain_mana(10)
	assert_le(GameState.mana, GameState.max_mana + GameState.MANA_OVERFLOW_CAP, "capped at overflow ceiling")

func test_take_damage_and_lethal_ends_run() -> void:
	var ended: Array[bool] = []
	GameState.run_ended.connect(func(v: bool) -> void: ended.append(v))
	GameState.base_hp = 10
	assert_eq(GameState.take_damage(4), 4, "dealt 4")
	assert_eq(GameState.base_hp, 6, "hp down to 6")
	GameState.take_damage(100)
	assert_eq(GameState.base_hp, 0, "hp clamps at 0")
	assert_not_empty(ended, "run_ended fired")
	assert_false(ended[0], "lethal ends run as defeat")

func test_next_turn_refills_mana_and_increments_turn() -> void:
	GameState.max_mana = 3
	GameState.turn = 0
	GameState.mana = 0
	GameState.next_turn()
	assert_eq(GameState.turn, 1, "turn advanced to 1")
	assert_eq(GameState.mana, 3, "mana refilled to ceiling")
