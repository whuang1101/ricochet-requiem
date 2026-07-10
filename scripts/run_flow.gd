class_name RunFlow
extends Node

signal room_started(index: int)
signal room_cleared(index: int)
signal door_opened(index: int)

var room_index := 0
var enemies_remaining := 0
var waiting_for_door := false

func start_room(enemy_count: int) -> void:
	enemies_remaining = enemy_count
	waiting_for_door = false
	room_started.emit(room_index)

func enemy_defeated() -> void:
	if enemies_remaining <= 0:
		return
	enemies_remaining -= 1
	if enemies_remaining == 0:
		waiting_for_door = true
		room_cleared.emit(room_index)
		door_opened.emit(room_index)

func choose_next_room() -> bool:
	if not waiting_for_door:
		return false
	room_index += 1
	return room_index < Balance.ACT1_ROOM_COUNT
