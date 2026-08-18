extends RefCounted
class_name GFSimulator

## Balance simulator: auto-plays whole runs headlessly with GFAIPolicy driving
## card plays and GFCombatResolver (a documented B2.7 stand-in) resolving
## combat, then aggregates win-rate and per-card telemetry across a batch.
##
## Needs a scene-tree host (to mount Combat nodes). Deterministic per seed.

const CombatScript := preload("res://src/runtime/combat.gd")
const CARDS_DIR: String = "res://data/cards/"

const HAND_START_DRAW: int = 5
const DRAW_PER_TURN: int = 1
const TURN_CAP: int = 60          # safety against a non-terminating combat

var _host: Node

func _init(host: Node) -> void:
	_host = host

# ---- content --------------------------------------------------------------

func _starter_pool() -> Array[Card]:
	## Cards live in per-faction subdirs (data/cards/<faction>/), so this must
	## recurse — a top-level-only scan returns an empty pool and the whole
	## simulation silently reports 0% win-rate instead of failing loudly.
	var out: Array[Card] = []
	_collect_starters(CARDS_DIR, out)
	return out

func _collect_starters(dir_path: String, out: Array[Card]) -> void:
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir == null:
		return
	dir.list_dir_begin()
	var f: String = dir.get_next()
	while f != "":
		if dir.current_is_dir():
			if not f.begins_with("."):
				_collect_starters(dir_path + f + "/", out)
		elif f.ends_with(".tres"):
			var c: Card = load(dir_path + f) as Card
			if c != null and c.is_starter and c.card_type == GFEnums.CardType.UNIT:
				# multiple copies so a deck is playable
				out.append(c.duplicate_card())
				out.append(c.duplicate_card())
		f = dir.get_next()
	dir.list_dir_end()

## Escalating wave set — each combat is tougher than the last.
func _waves() -> Array[Wave]:
	var out: Array[Wave] = []
	for stage: int in range(1, 4):
		var spawns: Array[WaveSpawnEntry] = []
		var count: int = 2 + stage
		for k: int in range(count):
			var hp: int = 3 + stage * 2
			var atk: int = 1 + stage
			var spd: int = 1 if k % 4 != 0 else 2
			var e: Enemy = GFFactory.enemy(StringName("sim_e%d_%d" % [stage, k]), hp, atk, spd)
			spawns.append(GFFactory.spawn_entry(1 + k, k % 3, e))
		out.append(GFFactory.wave(StringName("sim_stage_%d" % stage), count + 4, spawns))
	return out

# ---- one run --------------------------------------------------------------

func simulate_run(seed_value: int, telem: Dictionary) -> Dictionary:
	var pool: Array[Card] = _starter_pool()
	if pool.is_empty():
		# Fail loudly: an empty pool would otherwise report a plausible-looking
		# 0% win-rate and hide a content/loader regression.
		push_error("[sim] starter pool is EMPTY under %s — content or loader regression, aborting run" % CARDS_DIR)
		return {"victory": false, "cleared": 0, "turns": 0, "aborted": true}
	GameState.start_run(pool, &"sim", seed_value)
	var waves: Array[Wave] = _waves()
	var cleared: int = 0
	for i: int in range(waves.size()):
		var w: Wave = waves[i]
		GameState.max_mana = 3 + i        # mana curve grows per stage (engine: "grows with chapter")
		var outcome: Dictionary = _play_combat(w, telem)
		if outcome["victory"] and GameState.base_hp > 0:
			cleared += 1
		else:
			break
	var win: bool = cleared == waves.size() and GameState.base_hp > 0
	return {
		"win": win,
		"combats_cleared": cleared,
		"base_hp": GameState.base_hp,
		"turns": GameState.turn,
	}

func _play_combat(w: Wave, telem: Dictionary) -> Dictionary:
	var c := CombatScript.new()
	_host.add_child(c)
	c.setup(w)
	var ended: Array[bool] = []
	c.combat_ended.connect(func(v: bool) -> void: ended.append(v))
	c.start()                       # → turn 1
	_draw(HAND_START_DRAW, telem)
	var guard: int = 0
	while not c.has_ended() and guard < TURN_CAP:
		guard += 1
		# play as many cards as the policy wants / mana allows
		while true:
			var play: Dictionary = GFAIPolicy.next_play(GameState.hand, c.lanes, GameState.mana)
			if play.is_empty():
				break
			var card: Card = play["card"]
			var r: Dictionary = CardPlay.play_card(card, play["target"], GameState.hand, GameState.discard, c.lanes)
			if not r["success"]:
				break
			GFCombatResolver._telem_add(telem, String(card.id), "played", 1)
		GFCombatResolver.resolve_turn(c.lanes, telem)
		GameState.next_turn()
		_draw(DRAW_PER_TURN, telem)
		if GameState.base_hp <= 0:
			break
	var victory: bool = ended.size() > 0 and ended[0]
	c.cleanup()
	c.queue_free()
	return {"victory": victory}

func _draw(n: int, telem: Dictionary) -> void:
	for _i: int in range(n):
		var card: Card = GameState.deck.draw_one(GameState.discard)
		if card == null:
			return
		GFCombatResolver._telem_add(telem, String(card.id), "drawn", 1)
		if not GameState.hand.add(card):
			GameState.discard.add(card)   # hand full → burn to discard

# ---- batch ----------------------------------------------------------------

func run_batch(n: int, base_seed: int) -> Dictionary:
	var telem: Dictionary = {}
	var wins: int = 0
	var total_cleared: int = 0
	var total_hp: int = 0
	var loss_hp: int = 0
	var losses: int = 0
	for i: int in range(n):
		var res: Dictionary = simulate_run(base_seed + i * 7919, telem)
		if res["win"]:
			wins += 1
		else:
			losses += 1
			loss_hp += int(res["base_hp"])
		total_cleared += int(res["combats_cleared"])
		total_hp += int(res["base_hp"])
	return {
		"runs": n,
		"wins": wins,
		"win_rate": float(wins) / float(maxi(n, 1)),
		"avg_combats_cleared": float(total_cleared) / float(maxi(n, 1)),
		"avg_base_hp": float(total_hp) / float(maxi(n, 1)),
		"avg_base_hp_on_loss": (float(loss_hp) / float(losses)) if losses > 0 else 0.0,
		"telemetry": telem,
	}
