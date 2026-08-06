extends Node

## Headless entry for the balance simulator.
## Run:  godot --headless --path . res://tests/sim/run_sim.tscn -- --runs 200
## Writes a markdown + JSON report under res://tests/sim/reports/ and prints a
## summary. Exits 0 (the sim reports balance, it does not gate the build).

const REPORT_DIR: String = "res://tests/sim/reports/"

func _ready() -> void:
	var runs: int = _arg_int("--runs", 100)
	var base_seed: int = _arg_int("--seed", 20260806)
	print("\n=== Gallowfell balance sim — %d runs (seed base %d) ===" % [runs, base_seed])
	var sim := GFSimulator.new(self)
	var result: Dictionary = sim.run_batch(runs, base_seed)
	_print_summary(result)
	_write_reports(result, runs, base_seed)
	get_tree().quit(0)

func _arg_int(flag: String, def: int) -> int:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	for i: int in range(args.size()):
		if args[i] == flag and i + 1 < args.size():
			return int(args[i + 1])
	return def

func _print_summary(r: Dictionary) -> void:
	print("win_rate=%.1f%%  avg_combats_cleared=%.2f/3  avg_base_hp=%.1f  avg_base_hp_on_loss=%.1f" % [
		float(r["win_rate"]) * 100.0, r["avg_combats_cleared"], r["avg_base_hp"], r["avg_base_hp_on_loss"]])

func _card_rows(telem: Dictionary) -> Array:
	var rows: Array = []
	for id: String in telem.keys():
		var t: Dictionary = telem[id]
		var played: int = int(t.get("played", 0))
		var dmg: int = int(t.get("damage", 0))
		rows.append({
			"id": id,
			"drawn": int(t.get("drawn", 0)),
			"played": played,
			"damage": dmg,
			"kills": int(t.get("kills", 0)),
			"dpp": (float(dmg) / float(played)) if played > 0 else 0.0,
		})
	rows.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a["damage"] > b["damage"])
	return rows

func _write_reports(r: Dictionary, runs: int, base_seed: int) -> void:
	DirAccess.make_dir_recursive_absolute(REPORT_DIR)
	var stamp: String = Time.get_datetime_string_from_system()
	var rows: Array = _card_rows(r["telemetry"])
	# --- markdown ---
	var md: String = "# Gallowfell Balance Simulation Report\n\n"
	md += "Generated: %s  |  Runs: %d  |  Seed base: %d\n\n" % [stamp, runs, base_seed]
	md += "## Summary\n\n"
	md += "- Win rate: **%.1f%%**\n" % (float(r["win_rate"]) * 100.0)
	md += "- Avg combats cleared: %.2f / 3\n" % r["avg_combats_cleared"]
	md += "- Avg base HP at end of run: %.1f\n" % r["avg_base_hp"]
	md += "- Avg base HP on a loss: %.1f\n\n" % r["avg_base_hp_on_loss"]
	md += "## Per-card performance (sorted by total damage)\n\n"
	md += "| Card | Drawn | Played | Damage | Kills | Dmg/Play |\n"
	md += "|------|------:|-------:|-------:|------:|---------:|\n"
	for row: Dictionary in rows:
		md += "| %s | %d | %d | %d | %d | %.2f |\n" % [
			row["id"], row["drawn"], row["played"], row["damage"], row["kills"], row["dpp"]]
	md += "\n> Note: combat resolution here is GFCombatResolver, a documented B2.7 stand-in.\n"
	md += "> Absolute numbers move once the real attack engine lands; use these for RELATIVE\n"
	md += "> card comparison and regression tracking.\n"
	_write_file(REPORT_DIR + "sim_report.md", md)
	# --- json ---
	_write_file(REPORT_DIR + "sim_report.json", JSON.stringify(r, "  "))
	print("reports written to %s" % REPORT_DIR)

func _write_file(path: String, content: String) -> void:
	var fa: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if fa == null:
		push_error("could not write %s" % path)
		return
	fa.store_string(content)
	fa.close()
