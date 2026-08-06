extends RefCounted
class_name GFFactory

## Deterministic in-code builders for test + sim use. Avoids depending on any
## particular .tres so tests stay stable across content/balance edits.

static func unit_card(id: StringName, cost: int, hp: int, atk: int,
		cd: int = 1, rng: GFEnums.AttackRange = GFEnums.AttackRange.MELEE) -> Card:
	var c: Card = Card.new()
	c.id = id
	c.display_name = String(id)
	c.card_type = GFEnums.CardType.UNIT
	c.cost = cost
	c.hp = hp
	c.attack = atk
	c.cooldown = cd
	c.attack_range = rng
	c.is_starter = true
	return c

static func spell_card(id: StringName, cost: int) -> Card:
	var c: Card = Card.new()
	c.id = id
	c.display_name = String(id)
	c.card_type = GFEnums.CardType.SPELL
	c.cost = cost
	c.is_starter = true
	return c

static func enemy(id: StringName, hp: int, atk: int, spd: int = 1, armor: int = 0) -> Enemy:
	var e: Enemy = Enemy.new()
	e.id = id
	e.display_name = String(id)
	e.max_hp = hp
	e.attack = atk
	e.move_speed = spd
	e.armor = armor
	return e

static func spawn_entry(on_turn: int, lane: int, e: Enemy) -> WaveSpawnEntry:
	var s: WaveSpawnEntry = WaveSpawnEntry.new()
	s.on_turn = on_turn
	s.lane = lane
	s.enemy = e
	return s

static func wave(id: StringName, turn_count: int, spawns: Array[WaveSpawnEntry]) -> Wave:
	var w: Wave = Wave.new()
	w.id = id
	w.display_name = String(id)
	w.turn_count = turn_count
	w.spawns = spawns
	return w
