extends Node2D

const PlayerScript := preload("res://scripts/player.gd")
const ShooterScript := preload("res://scripts/shooter.gd")
const EnemyScript := preload("res://scripts/enemy.gd")
const ResonanceNoteScript := preload("res://scripts/resonance_note.gd")
const WailerShotScript := preload("res://scripts/wailer_shot.gd")
const RequiemScript := preload("res://scripts/requiem.gd")
const RunFlowScript := preload("res://scripts/run_flow.gd")
const RoomScenes := [
	preload("res://scenes/room_01.tscn"),
	preload("res://scenes/room_02.tscn"),
	preload("res://scenes/room_03.tscn"),
	preload("res://scenes/room_04.tscn"),
	preload("res://scenes/room_05.tscn"),
]

var _hud: Label
var _requiem: Requiem
var _flow: RunFlow
var _room_host: Node2D

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#171820"))
	_room_host = Node2D.new()
	_room_host.name = "RoomHost"
	add_child(_room_host)
	var player := PlayerScript.new()
	player.position = Vector2.ZERO
	player.add_to_group("player")
	player.damaged.connect(_on_player_damaged)
	player.add_child(ShooterScript.new())
	add_child(player)
	_requiem = RequiemScript.new()
	add_child(_requiem)
	_flow = RunFlowScript.new()
	add_child(_flow)
	_load_room()
	_build_hud()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart_run"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("advance_room") and _flow.choose_next_room():
		_load_room()
	if is_instance_valid(_hud):
		var player := get_tree().get_first_node_in_group("player")
		var door_text := "DOORS LOCKED"
		if _flow.waiting_for_door:
			door_text = "ROOM CLEAR  //  [E] NEXT DOOR"
		_hud.text = "RICOCHET REQUIEM  //  P0 GRAY ROOM\nWASD move   SPACE dash   LMB fire   Q Cadenza   R restart\nDead slugs tune. First wall bounce makes them LIVE.\nHP %d / %d   Notes %d / %d   Slugs %d / %d\n%s" % [player.hp, Balance.PLAYER_MAX_HP, _requiem.notes, Balance.REQUIEM_BANK_CAP, get_tree().get_nodes_in_group("slugs").size(), Balance.MAX_SLUGS, door_text]

func _load_room() -> void:
	for child in _room_host.get_children():
		child.queue_free()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	var room: RoomDef = RoomScenes[_flow.room_index].instantiate()
	_room_host.add_child(room)
	room.spawn_requested.connect(_spawn_enemy)
	_flow.start_room(3)
	room.begin()

func _spawn_enemy(kind: String, at: Vector2) -> void:
	var enemy := EnemyScript.new()
	enemy.global_position = at
	enemy.configure(kind)
	enemy.died.connect(_on_enemy_died)
	enemy.shot_fired.connect(_on_wailer_shot)
	add_child(enemy)

func _on_enemy_died(at: Vector2, spawn_resonance: bool, bounces: int, tuned: bool) -> void:
	_requiem.award_kill(bounces, tuned)
	_flow.enemy_defeated()
	if not spawn_resonance:
		return
	var note := ResonanceNoteScript.new()
	note.global_position = at
	add_child(note)

func _on_wailer_shot(origin: Vector2, direction: Vector2) -> void:
	var shot := WailerShotScript.new()
	add_child(shot)
	shot.setup(origin, direction)

func _on_player_damaged(_amount: int, _hp_remaining: int) -> void:
	_requiem.on_player_hit()

func _build_hud() -> void:
	_hud = Label.new()
	_hud.position = Vector2(28.0, 24.0)
	_hud.add_theme_color_override("font_color", Color("#d6d0c4"))
	_hud.add_theme_font_size_override("font_size", 16)
	add_child(_hud)
