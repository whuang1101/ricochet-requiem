extends SceneTree

const RunFlowScript := preload("res://scripts/run_flow.gd")
var failures: Array[String] = []

func _init() -> void:
	var flow := RunFlowScript.new()
	for room in Balance.ACT1_ROOM_COUNT:
		var enemy_count := 4 if room == Balance.ACT1_ROOM_COUNT - 1 else 3
		flow.start_room(enemy_count)
		while flow.enemies_remaining > 0:
			flow.enemy_defeated()
		_check(flow.waiting_for_door, "Act 1 room %d must reach cleared state" % (room + 1))
		if room < Balance.ACT1_ROOM_COUNT - 1:
			_check(flow.choose_next_room(), "Act 1 room %d must transition" % (room + 1))
	_check(flow.room_index == Balance.ACT1_ROOM_COUNT - 1, "full Act 1 sim must end on the Organist room")
	flow.free()
	if failures.is_empty():
		print("PASS test_act1: full 15-room Act 1 state simulation clears")
		quit(0)
	for failure in failures:
		push_error(failure)
	quit(1)

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
