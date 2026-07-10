extends SceneTree

const MetaScript := preload("res://scripts/meta.gd")
var failures: Array[String] = []

func _init() -> void:
	PersistentSaveData.readonly = true
	PersistentSaveData.data = {"version": 1, "motifs": 0, "first_win": false, "unlocked_guns": ["default"], "dissonance": 0}
	var meta := MetaScript.new()
	var seed_a := meta.begin_run("2026-07-10")
	var seed_b := meta.begin_run("2026-07-10")
	_check(seed_a == seed_b, "daily seed must be stable for a date")
	_check(not meta.select_gun("tuba"), "locked alternate gun must not be selectable")
	PersistentSaveData.data.unlocked_guns.append("tuba")
	_check(meta.select_gun("tuba"), "unlocked alternate gun must be selectable")
	meta.award_run_motifs(7)
	_check(meta.run_motifs == 7 and PersistentSaveData.data.motifs == 7, "Motifs must persist from run rewards")
	_check(not meta.set_dissonance(1), "Dissonance must remain locked before first win")
	PersistentSaveData.data.first_win = true
	_check(meta.set_dissonance(3), "Dissonance tiers must unlock after first win")
	meta.free()
	PersistentSaveData.data = {}
	PersistentSaveData.readonly = false
	if failures.is_empty():
		print("PASS test_meta: readonly save, alternate guns, daily seed, and Dissonance hold")
		quit(0)
	for failure in failures:
		push_error(failure)
	quit(1)

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
