extends RefCounted
class_name WaveGenerator

## WaveGenerator (IMV-1 — Paul, 2026-05-18) — builds a Wave on the fly for a
## given round number, scaling enemy stats by round depth and varying spawn
## density by node kind (normal / elite / horde / boss).
##
## Why dynamic rather than per-round .tres files: keeps the round content
## terse (one formula, eight rounds) and lets the rest of the system scale
## with a single tuning constant. Per-round .tres can be authored in IMV-2
## for hand-tuned encounters once the playtest reveals where the curve breaks.
##
## Scaling per Paul's 2026-05-18 design call:
##   HP  multiplier = 1.00 + 0.15 × (round - 1)   → round 8 HP  ≈ 2.05×
##   ATK multiplier = 1.00 + 0.10 × (round - 1)   → round 8 ATK ≈ 1.70×
## Counts:
##   COMBAT:   3-4 enemies across 5 spawn turns
##   ELITE:    2-3 enemies + 1 boss-flagged elite
##   HORDE:    8-9 enemies in 3 spawn turns (overlapping spawns)
##   BOSS:     1 boss + 2 minions

const ENEMIES_DIR: String = "res://data/enemies/"

const HP_PER_ROUND: float = 0.15
const ATK_PER_ROUND: float = 0.10


## Build a wave for the given round (1..8). Loads E1-E5 base enemies from
## res://data/enemies/, applies scaling, and lays out spawn entries by kind.
static func for_round(round_num: int, kind: int, run_seed: int) -> Wave:
	var pool: Array[Enemy] = _load_enemy_pool()
	if pool.is_empty():
		push_error("[WaveGenerator] no enemies loaded from %s" % ENEMIES_DIR)
		return null

	var hp_mult: float = 1.0 + HP_PER_ROUND * float(round_num - 1)
	var atk_mult: float = 1.0 + ATK_PER_ROUND * float(round_num - 1)

	var rng := RandomNumberGenerator.new()
	rng.seed = run_seed ^ (round_num * 1009 + kind * 7919)

	var wave: Wave = Wave.new()
	wave.id = StringName("r%d_%d" % [round_num, kind])
	wave.display_name = _name_for_kind(kind, round_num)
	wave.turn_count = 10

	var spawns: Array[WaveSpawnEntry] = []
	match kind:
		GFEnums.NodeKind.HORDE:
			spawns = _build_horde(pool, hp_mult, atk_mult, rng)
		GFEnums.NodeKind.BOSS:
			spawns = _build_boss(pool, hp_mult, atk_mult, rng)
		GFEnums.NodeKind.ELITE:
			spawns = _build_elite(pool, hp_mult, atk_mult, rng)
		_:
			spawns = _build_combat(pool, hp_mult, atk_mult, rng)
	wave.spawns = spawns
	return wave


## Build a wave for a specific map node (BM-3). Round scaling comes from the
## node depth; the node's EncounterArchetype (if any) then layers density / stat
## / move / keyword biases on top. Non-combat or archetype-less nodes get the
## plain scaled wave. `for_round` stays as the shim used elsewhere.
static func for_node(node: MapNode, run_seed: int) -> Wave:
	if node == null:
		return null
	var round_num: int = max(1, node.depth + 1)
	var wave: Wave = for_round(round_num, node.kind, run_seed)
	if wave == null:
		return null
	var arch: EncounterArchetype = EncounterArchetype.get_archetype(node.encounter_id)
	if arch != null:
		_apply_archetype(wave, arch, run_seed ^ node.seed_offset)
		wave.display_name = "%s — %s" % [wave.display_name, arch.display_name]
	return wave


## Layer an archetype's biases onto an already-scaled wave (BM-3).
static func _apply_archetype(wave: Wave, arch: EncounterArchetype, seed_value: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value ^ 0x9E3779B9
	for entry in wave.spawns:
		var e: Enemy = entry.enemy
		if e == null:
			continue
		if arch.hp_bias != 1.0:
			e.max_hp = max(1, int(round(float(e.max_hp) * arch.hp_bias)))
		if arch.atk_bias != 1.0:
			e.attack = max(0, int(round(float(e.attack) * arch.atk_bias)))
		if arch.move_bias != 0:
			e.move_speed = max(0, e.move_speed + arch.move_bias)
		for kw in arch.emphasise_keywords:
			if not e.keywords.has(kw):
				e.keywords.append(kw)
		if arch.prefer_faction != GFEnums.Faction.NEUTRAL:
			e.faction = arch.prefer_faction
	if arch.density > 0:
		_add_density(wave, arch.density * 2, rng)
	elif arch.density < 0:
		var remove: int = min(-arch.density, max(0, wave.spawns.size() - 1))
		for _i in range(remove):
			wave.spawns.remove_at(wave.spawns.size() - 1)


## Clone `extra` already-biased spawns into fresh lanes/turns (density +).
static func _add_density(wave: Wave, extra: int, rng: RandomNumberGenerator) -> void:
	if wave.spawns.is_empty():
		return
	for _i in range(extra):
		var src: WaveSpawnEntry = wave.spawns[rng.randi() % wave.spawns.size()]
		var clone: WaveSpawnEntry = WaveSpawnEntry.new()
		clone.on_turn = 1 + (rng.randi() % 3)
		clone.lane = rng.randi() % 3
		clone.enemy = _scaled_enemy(src.enemy, 1.0, 1.0, false)
		wave.spawns.append(clone)


# ----------------------------------------------------------------------------
# Spawn-pattern builders — each returns Array[WaveSpawnEntry]
# ----------------------------------------------------------------------------

static func _build_combat(pool: Array[Enemy], hp_mult: float, atk_mult: float, rng: RandomNumberGenerator) -> Array[WaveSpawnEntry]:
	# 3-4 enemies across turns 1-5. Spread across all three lanes.
	var out: Array[WaveSpawnEntry] = []
	var count: int = 3 + (rng.randi() % 2)  # 3 or 4
	for i in range(count):
		var entry: WaveSpawnEntry = WaveSpawnEntry.new()
		entry.on_turn = 1 + (i * 5) / count  # spread across turns 1-5
		entry.lane = rng.randi() % 3
		entry.enemy = _scaled_enemy(pool[rng.randi() % pool.size()], hp_mult, atk_mult, false)
		out.append(entry)
	return out


static func _build_elite(pool: Array[Enemy], hp_mult: float, atk_mult: float, rng: RandomNumberGenerator) -> Array[WaveSpawnEntry]:
	# 2 normal enemies + 1 elite (double stats).
	var out: Array[WaveSpawnEntry] = []
	for i in range(2):
		var entry: WaveSpawnEntry = WaveSpawnEntry.new()
		entry.on_turn = 1 + i
		entry.lane = rng.randi() % 3
		entry.enemy = _scaled_enemy(pool[rng.randi() % pool.size()], hp_mult, atk_mult, false)
		out.append(entry)
	var elite_entry: WaveSpawnEntry = WaveSpawnEntry.new()
	elite_entry.on_turn = 3
	elite_entry.lane = rng.randi() % 3
	elite_entry.enemy = _scaled_enemy(pool[rng.randi() % pool.size()], hp_mult * 2.0, atk_mult * 1.5, false)
	elite_entry.enemy.display_name = "Elite " + elite_entry.enemy.display_name
	out.append(elite_entry)
	return out


static func _build_horde(pool: Array[Enemy], hp_mult: float, atk_mult: float, rng: RandomNumberGenerator) -> Array[WaveSpawnEntry]:
	# 8-9 weak enemies in 3 overlapping spawn turns. Half-HP/half-ATK each
	# (they're swarming, not strong individually).
	var out: Array[WaveSpawnEntry] = []
	var count: int = 8 + (rng.randi() % 2)
	for i in range(count):
		var entry: WaveSpawnEntry = WaveSpawnEntry.new()
		entry.on_turn = 1 + (i % 3)  # waves on turn 1, 2, 3
		entry.lane = i % 3  # round-robin lanes
		entry.enemy = _scaled_enemy(pool[rng.randi() % pool.size()], hp_mult * 0.55, atk_mult * 0.6, false)
		entry.enemy.display_name = "Swarm " + entry.enemy.display_name
		out.append(entry)
	return out


static func _build_boss(pool: Array[Enemy], hp_mult: float, atk_mult: float, rng: RandomNumberGenerator) -> Array[WaveSpawnEntry]:
	# 1 boss (centre lane, turn 1, 6× HP, 2× ATK) + 2 minions (flanking).
	var out: Array[WaveSpawnEntry] = []
	var boss_entry: WaveSpawnEntry = WaveSpawnEntry.new()
	boss_entry.on_turn = 1
	boss_entry.lane = 1
	boss_entry.enemy = _scaled_enemy(pool[rng.randi() % pool.size()], hp_mult * 6.0, atk_mult * 2.0, true)
	boss_entry.enemy.display_name = "BOSS — " + boss_entry.enemy.display_name
	out.append(boss_entry)
	for i in range(2):
		var minion: WaveSpawnEntry = WaveSpawnEntry.new()
		minion.on_turn = 2 + i
		minion.lane = 0 if i == 0 else 2
		minion.enemy = _scaled_enemy(pool[rng.randi() % pool.size()], hp_mult * 0.8, atk_mult, false)
		out.append(minion)
	return out


# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------

static func _scaled_enemy(src: Enemy, hp_mult: float, atk_mult: float, is_boss: bool) -> Enemy:
	# duplicate() doesn't deep-copy custom resources reliably across Godot
	# point releases. Build a fresh Enemy and copy fields.
	var e: Enemy = Enemy.new()
	e.id = src.id
	e.display_name = src.display_name
	e.is_boss = is_boss or src.is_boss
	e.max_hp = int(round(float(src.max_hp) * hp_mult))
	e.attack = int(round(float(src.attack) * atk_mult))
	e.armor = src.armor
	e.move_speed = src.move_speed
	e.base_damage_override = src.base_damage_override
	e.faction = src.faction
	e.keywords = src.keywords.duplicate()
	e.flavour = src.flavour
	return e


static func _load_enemy_pool() -> Array[Enemy]:
	var out: Array[Enemy] = []
	var dir := DirAccess.open(ENEMIES_DIR)
	if dir == null:
		return out
	dir.list_dir_begin()
	var name: String = dir.get_next()
	while name != "":
		if not dir.current_is_dir() and name.ends_with(".tres"):
			var e := load(ENEMIES_DIR + name) as Enemy
			if e != null:
				out.append(e)
		name = dir.get_next()
	dir.list_dir_end()
	return out


static func _name_for_kind(kind: int, round_num: int) -> String:
	match kind:
		GFEnums.NodeKind.HORDE: return "Round %d — Horde" % round_num
		GFEnums.NodeKind.BOSS:  return "Round %d — Boss" % round_num
		GFEnums.NodeKind.ELITE: return "Round %d — Elite" % round_num
		_:                      return "Round %d" % round_num
