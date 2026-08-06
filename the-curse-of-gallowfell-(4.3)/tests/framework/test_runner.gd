extends Node
class_name GFTestRunner

## Headless test runner for The Curse of Gallowfell.
## Discovers every GFTest suite under res://tests/suites/, runs each `test_*`
## method with before/after hooks, aggregates, prints a report, returns a result
## Dictionary. Strictly typed to satisfy the project's warning-as-error policy.

const SUITES_DIR: String = "res://tests/suites/"

var _suites: int = 0
var _tests: int = 0
var _passed: int = 0
var _failed: int = 0
var _assertions: int = 0
var _failures: Array[String] = []

func run_all() -> Dictionary:
	_suites = 0
	_tests = 0
	_passed = 0
	_failed = 0
	_assertions = 0
	_failures = []
	var suite_paths: Array[String] = _discover_suites()
	suite_paths.sort()
	print("\n=== Gallowfell test run — %d suite(s) ===" % suite_paths.size())
	for path: String in suite_paths:
		_run_suite(path)
	var ok: bool = _failed == 0 and _suites > 0
	_print_summary(ok)
	return {
		"suites": _suites, "tests": _tests, "passed": _passed,
		"failed": _failed, "assertions": _assertions,
		"failures": _failures, "ok": ok,
	}

func _discover_suites() -> Array[String]:
	var out: Array[String] = []
	var dir: DirAccess = DirAccess.open(SUITES_DIR)
	if dir == null:
		push_error("[runner] cannot open %s" % SUITES_DIR)
		return out
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if not dir.current_is_dir() and fname.ends_with(".gd"):
			out.append(SUITES_DIR + fname)
		fname = dir.get_next()
	dir.list_dir_end()
	return out

func _run_suite(path: String) -> void:
	var scr: GDScript = load(path)
	if scr == null:
		_failures.append("%s :: could not load script" % path)
		_failed += 1
		return
	var suite: GFTest = scr.new() as GFTest
	if suite == null:
		# Not a GFTest suite (helper script) — skip.
		return
	_suites += 1
	suite.host = self
	var label: String = suite.suite_name()
	var methods: Array[String] = _test_methods(suite)
	print("• %s (%d test%s)" % [label, methods.size(), "" if methods.size() == 1 else "s"])
	suite.before_all()
	for m: String in methods:
		var before_fails: int = suite.failures().size()
		suite.before_each()
		suite._set_current(m)
		suite.call(m)
		suite.after_each()
		_tests += 1
		if suite.failures().size() - before_fails == 0:
			_passed += 1
			print("    [PASS] %s" % m)
		else:
			_failed += 1
			print("    [FAIL] %s" % m)
	suite.after_all()
	_assertions += suite.assertion_count()
	for f: String in suite.failures():
		_failures.append("[%s] %s" % [label, f])

func _test_methods(suite: GFTest) -> Array[String]:
	var seen: Dictionary = {}
	var out: Array[String] = []
	for m: Dictionary in suite.get_method_list():
		var n: String = String(m.get("name", ""))
		if n.begins_with("test_") and not seen.has(n):
			seen[n] = true
			out.append(n)
	out.sort()
	return out

func _print_summary(ok: bool) -> void:
	print("\n=== SUMMARY ===")
	print("suites=%d  tests=%d  passed=%d  failed=%d  assertions=%d" % [
		_suites, _tests, _passed, _failed, _assertions])
	if not ok or _failed > 0:
		if _failures.size() > 0:
			print("\nFAILURES:")
			for f: String in _failures:
				print("  [FAIL] %s" % f)
		print("\nRESULT: FAIL")
	else:
		print("\nRESULT: PASS")
