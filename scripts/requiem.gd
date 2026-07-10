class_name Requiem
extends Node
## Tempo meter: score keeps it alive; banking adds a deliberate greed decision.

signal note_added(amount: int, total: int)
signal cadenza_ready
signal cadenza_started(grand: bool)
signal cadenza_ended
signal decayed(total: int)

var notes := 0
var _idle_time := 0.0
var _cadenza_time := 0.0
var _grand := false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cadenza"):
		start_cadenza(notes >= Balance.REQUIEM_BANK_CAP)
	tick(delta)

func tick(delta: float) -> void:
	if is_in_cadenza():
		_cadenza_time -= delta / Balance.CADENZA_TIME_SCALE
		if _cadenza_time <= 0.0:
			_cadenza_time = 0.0
			Engine.time_scale = 1.0
			cadenza_ended.emit()
		return
	_idle_time += delta
	while _idle_time >= Balance.REQUIEM_DECAY_INTERVAL and notes > 0:
		_idle_time -= Balance.REQUIEM_DECAY_INTERVAL
		notes -= 1
		decayed.emit(notes)

func award_kill(bounces: int, tuned: bool) -> void:
	var amount := bounces + (1 if tuned else 0)
	if amount <= 0:
		return
	var was_ready := notes >= Balance.REQUIEM_CADENZA_NOTES
	notes = mini(notes + amount, Balance.REQUIEM_BANK_CAP)
	_idle_time = 0.0
	note_added.emit(amount, notes)
	if not was_ready and notes >= Balance.REQUIEM_CADENZA_NOTES:
		cadenza_ready.emit()

func on_player_hit() -> void:
	if notes > Balance.REQUIEM_CADENZA_NOTES:
		notes = Balance.REQUIEM_CADENZA_NOTES

func start_cadenza(grand: bool) -> bool:
	if is_in_cadenza() or notes < Balance.REQUIEM_CADENZA_NOTES:
		return false
	_grand = grand and notes >= Balance.REQUIEM_BANK_CAP
	notes = 0
	_cadenza_time = Balance.GRAND_CADENZA_DURATION if _grand else Balance.CADENZA_DURATION
	Engine.time_scale = Balance.CADENZA_TIME_SCALE
	cadenza_started.emit(_grand)
	return true

func is_in_cadenza() -> bool:
	return _cadenza_time > 0.0
