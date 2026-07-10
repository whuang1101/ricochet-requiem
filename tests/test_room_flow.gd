extends SceneTree

const RunFlowScript := preload("res://scripts/run_flow.gd")
var failures: Array[String] = []

func _init() -> void:
	var flow := RunFlowScript.new()
	for expected_room in 3:
		flow.start_room(3)
		for _enemy in 3:
			flow.enemy_defeated()
		_check(flow.waiting_for_door, "room %d must open doors after the final enemy" % expected_room)
		_check(flow.choose_next_room(), "room %d must advance through its chosen door" % expected_room)
	flow.free()
	if failures.is_empty():
		print("PASS test_room_flow: three rooms clear end-to-end by observed state")
		quit(0)
	for failure in failures:
		push_error(failure)
	quit(1)

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
