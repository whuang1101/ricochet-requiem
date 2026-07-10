extends SceneTree
## Step 3 contract: note math, decay, hit banking penalty, and Cadenza timing.

const RequiemScript := preload("res://scripts/requiem.gd")
var failures: Array[String] = []

func _init() -> void:
	var meter := RequiemScript.new()
	meter.award_kill(3, false)
	_check(meter.notes == 3, "bounce-3 kill must add three notes")
	meter.tick(Balance.REQUIEM_DECAY_INTERVAL)
	_check(meter.notes == 2, "Requiem must decay one note per interval without scoring")
	meter.notes = Balance.REQUIEM_BANK_CAP
	meter.on_player_hit()
	_check(meter.notes == Balance.REQUIEM_CADENZA_NOTES, "a hit above 12 notes must drop bank to 12")
	meter.notes = Balance.REQUIEM_CADENZA_NOTES
	_check(meter.start_cadenza(false), "Cadenza must start at 12 notes")
	meter.tick(Balance.CADENZA_DURATION * Balance.CADENZA_TIME_SCALE)
	_check(not meter.is_in_cadenza() and is_equal_approx(Engine.time_scale, 1.0), "Cadenza must restore time scale after its real duration")
	meter.free()
	if failures.is_empty():
		print("PASS test_requiem: notes, decay, banking, and Cadenza rules hold")
		quit(0)
	for failure in failures:
		push_error(failure)
	quit(1)

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
