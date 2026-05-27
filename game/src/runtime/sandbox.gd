extends Node

## Sandbox launcher (B2.6 UI smoke test).
##
## Bootstraps a minimal run + populates the hand with 5 cards so Paul can
## drag-drop-test the combat scene visually. Not part of the real game flow
## — production entry will go through B2.9 map screen + B2.8 reward picker.
##
## To run: in Godot's FileSystem panel, right-click `scenes/sandbox.tscn` →
## "Run Scene" (or open it in the editor and press F6). You should see:
##   - 3 lane backgrounds across the upper portion
##   - dark red base bar below the lanes
##   - 5 face-up cards along the bottom strip
## Drag a card onto a lane. If you have enough mana, the card disappears
## from hand → goes to discard, and the unit is "placed" (no visual sprite
## yet — we just print confirmation to the console).

const CARD_POOL_DIRS: Array[String] = [
	"res://data/cards/iron_penitents/",
	"res://data/cards/ash_mourners/",
	"res://data/cards/coven/",
	"res://data/cards/",
]
const COMBAT_SCENE: PackedScene = preload("res://scenes/combat.tscn")
const STARTER_HAND_SIZE: int = 5
const STARTER_MANA: int = 8


func _ready() -> void:
	print("=== Sandbox — B2.6 UI smoke ===")
	# 1. Load a card pool. Filter to UNITs ≤ 3 cost so the test deck is
	#    actually playable with a sane mana budget.
	var pool: Array[Card] = []
	for d in CARD_POOL_DIRS:
		pool.append_array(_load_pool(d))
	if pool.is_empty():
		printerr("[sandbox] FATAL: no cards loaded; check res://data/cards/ paths")
		return
	var playable_units: Array[Card] = []
	for c in pool:
		if c.card_type == GFEnums.CardType.UNIT and c.cost <= 3 and c.is_starter:
			playable_units.append(c)
	if playable_units.size() < STARTER_HAND_SIZE:
		# Fallback: drop the is_starter filter so we definitely get enough.
		playable_units.clear()
		for c in pool:
			if c.card_type == GFEnums.CardType.UNIT and c.cost <= 3:
				playable_units.append(c)
	playable_units.shuffle()
	var starter: Array[Card] = playable_units.slice(0, STARTER_HAND_SIZE)
	print("[sandbox] loaded %d cards, picked %d starter units" % [pool.size(), starter.size()])

	# 2. Kick GameState. start_run builds Hand/Deck/Discard.
	GameState.start_run(starter, &"sandbox_warlord", 7777)
	GameState.start_combat()
	GameState.mana = STARTER_MANA

	# 3. Pre-populate hand from the deck so cards are visible.
	for i in range(min(STARTER_HAND_SIZE, GameState.deck.size())):
		var c: Card = GameState.deck.draw_one()
		if c != null:
			GameState.hand.add(c)
	print("[sandbox] hand populated: %d cards, mana=%d" % [
		GameState.hand.size(), GameState.mana
	])

	# 4. Instance the combat scene. Its HandView child auto-binds to
	#    GameState.hand on _ready, so the cards we just added will appear.
	var combat_root: Node2D = COMBAT_SCENE.instantiate() as Node2D
	add_child(combat_root)

	# 5. Listen for play attempts so we can log to console for visual debug.
	if combat_root.has_signal("card_play_attempted"):
		combat_root.card_play_attempted.connect(_on_card_play_attempted)

	print("[sandbox] ready — drag a card to a lane")


func _on_card_play_attempted(result: Dictionary) -> void:
	if result.get("success", false):
		var unit = result.get("unit")
		var u_str: String = "<spell/trap>"
		if unit != null:
			u_str = str(unit)
		print("[sandbox] PLAY OK — %s — mana now %d/%d, hand size %d" % [
			u_str, GameState.mana, GameState.max_mana, GameState.hand.size()
		])
	else:
		print("[sandbox] PLAY REJECTED — %s" % result.get("reason", ""))


# ---------- Helpers -------------------------------------------------------

func _load_pool(dir_path: String) -> Array[Card]:
	var out: Array[Card] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var f := dir.get_next()
	while f != "":
		if f.ends_with(".tres"):
			var res := load(dir_path + f) as Card
			if res != null:
				out.append(res)
		f = dir.get_next()
	dir.list_dir_end()
	return out
