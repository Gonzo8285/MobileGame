extends RefCounted
class_name GFTest

## Base class for all Gallowfell unit / integration test suites.
##
## Write a suite by extending GFTest and adding methods whose names start with
## `test_`. The runner discovers and calls each one. Use the assert_* helpers;
## every failed assertion is recorded with the test name and a message, and the
## suite (and CI) fails if any assertion fails.
##
##   extends GFTest
##   func test_deck_draw_reduces_size() -> void:
##       var d := Deck.new([_card()], 1)
##       assert_eq(d.size(), 1, "one card in")
##       d.draw_one()
##       assert_eq(d.size(), 0, "empty after draw")
##
## Optional lifecycle hooks (all no-ops by default):
##   before_all()  – once before the suite's first test
##   before_each() – before every test method
##   after_each()  – after every test method
##   after_all()   – once after the suite's last test

## Scene-tree host, set by the runner. Integration suites that need a node in
## the tree (so its _ready fires) can do `host.add_child(node)`.
var host: Node = null

var _asserts: int = 0
var _failures: Array[String] = []
var _current: String = ""

# ---- lifecycle (override as needed) ---------------------------------------
func before_all() -> void: pass
func after_all() -> void: pass
func before_each() -> void: pass
func after_each() -> void: pass

## Human-readable suite name (defaults to the script filename).
func suite_name() -> String:
	var scr: Script = get_script()
	return scr.resource_path.get_file().get_basename() if scr != null else "GFTest"

# ---- runner hooks (called by GFTestRunner) --------------------------------
func _set_current(test_name: String) -> void:
	_current = test_name

func _record(ok: bool, msg: String) -> void:
	_asserts += 1
	if not ok:
		_failures.append("%s :: %s" % [_current, msg])

func assertion_count() -> int:
	return _asserts

func failures() -> Array[String]:
	return _failures

# ---- assertions -----------------------------------------------------------
func assert_true(cond: bool, msg: String = "expected true") -> void:
	_record(cond == true, msg)

func assert_false(cond: bool, msg: String = "expected false") -> void:
	_record(cond == false, msg)

func assert_eq(a: Variant, b: Variant, msg: String = "") -> void:
	_record(a == b, msg if msg != "" else "expected %s == %s" % [str(a), str(b)])

func assert_ne(a: Variant, b: Variant, msg: String = "") -> void:
	_record(a != b, msg if msg != "" else "expected %s != %s" % [str(a), str(b)])

func assert_null(v: Variant, msg: String = "expected null") -> void:
	_record(v == null, msg)

func assert_not_null(v: Variant, msg: String = "expected non-null") -> void:
	_record(v != null, msg)

func assert_gt(a: Variant, b: Variant, msg: String = "") -> void:
	_record(a > b, msg if msg != "" else "expected %s > %s" % [str(a), str(b)])

func assert_ge(a: Variant, b: Variant, msg: String = "") -> void:
	_record(a >= b, msg if msg != "" else "expected %s >= %s" % [str(a), str(b)])

func assert_lt(a: Variant, b: Variant, msg: String = "") -> void:
	_record(a < b, msg if msg != "" else "expected %s < %s" % [str(a), str(b)])

func assert_le(a: Variant, b: Variant, msg: String = "") -> void:
	_record(a <= b, msg if msg != "" else "expected %s <= %s" % [str(a), str(b)])

func assert_almost_eq(a: float, b: float, eps: float = 0.0001, msg: String = "") -> void:
	_record(absf(a - b) <= eps, msg if msg != "" else "expected %f ~= %f (eps %f)" % [a, b, eps])

func assert_has(coll: Variant, item: Variant, msg: String = "") -> void:
	_record(item in coll, msg if msg != "" else "expected collection to contain %s" % str(item))

func assert_empty(coll: Variant, msg: String = "expected empty") -> void:
	_record(coll != null and coll.size() == 0, msg)

func assert_not_empty(coll: Variant, msg: String = "expected non-empty") -> void:
	_record(coll != null and coll.size() > 0, msg)

func fail(msg: String = "forced failure") -> void:
	_record(false, msg)
