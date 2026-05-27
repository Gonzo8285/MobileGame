extends Control
class_name HandView

## HandView (B2.6 UI) — auto-populating display of GameState.hand.
##
## Listens to Hand.added / Hand.removed signals and keeps a CardView per
## card in the hand. Children are arranged in a horizontal strip via the
## HBoxContainer child node. Layout target: bottom strip of the screen,
## ~200px tall.
##
## Wires itself to GameState on _ready. If a hand is ever swapped wholesale
## (e.g. start of a new run), call `rebind()` to re-attach signals.

const CARD_VIEW_SCENE: PackedScene = preload("res://scenes/card_view.tscn")

@onready var hbox: Container = $HBox

var _hand: Hand = null
var _added_cb: Callable
var _removed_cb: Callable


func _ready() -> void:
	rebind()


# ============================================================================
# Wiring
# ============================================================================

## Re-attach to GameState.hand. Call after a new run starts so the visual
## reflects the new deck/hand objects.
func rebind() -> void:
	_disconnect_current()
	_hand = GameState.hand
	if _hand == null:
		_clear_views()
		return
	_added_cb = Callable(self, "_on_card_added")
	_removed_cb = Callable(self, "_on_card_removed")
	_hand.added.connect(_added_cb)
	_hand.removed.connect(_removed_cb)
	_repopulate()


func _disconnect_current() -> void:
	if _hand == null:
		return
	if _added_cb.is_valid() and _hand.added.is_connected(_added_cb):
		_hand.added.disconnect(_added_cb)
	if _removed_cb.is_valid() and _hand.removed.is_connected(_removed_cb):
		_hand.removed.disconnect(_removed_cb)


# ============================================================================
# Population
# ============================================================================

func _repopulate() -> void:
	_clear_views()
	if _hand == null:
		return
	for c in _hand.cards():
		_add_view_for(c)


func _clear_views() -> void:
	for child in hbox.get_children():
		child.queue_free()


func _add_view_for(card: Card) -> CardView:
	var view: CardView = CARD_VIEW_SCENE.instantiate() as CardView
	view.bind(card)
	hbox.add_child(view)
	return view


func _find_view_for(card: Card) -> CardView:
	for child in hbox.get_children():
		var cv := child as CardView
		if cv != null and cv.card_data == card:
			return cv
	return null


# ============================================================================
# Signal handlers
# ============================================================================

func _on_card_added(card: Card) -> void:
	_add_view_for(card)


func _on_card_removed(card: Card) -> void:
	var v := _find_view_for(card)
	if v != null:
		v.queue_free()


func _exit_tree() -> void:
	_disconnect_current()
