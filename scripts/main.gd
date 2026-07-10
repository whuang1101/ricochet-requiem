extends Node2D

const PlayerScript := preload("res://scripts/player.gd")
const ShooterScript := preload("res://scripts/shooter.gd")
const EnemyScript := preload("res://scripts/enemy.gd")
const ResonanceNoteScript := preload("res://scripts/resonance_note.gd")

var _hud: Label

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#171820"))
	_build_room()
	var player := PlayerScript.new()
	player.position = Vector2.ZERO
	player.add_to_group("player")
	player.add_child(ShooterScript.new())
	add_child(player)
	_spawn_enemy("chorister", Vector2(-260.0, -140.0))
	_spawn_enemy("sidler", Vector2(280.0, -120.0))
	_spawn_enemy("wailer", Vector2(220.0, 150.0))
	_build_hud()

func _process(_delta: float) -> void:
	if is_instance_valid(_hud):
		var player := get_tree().get_first_node_in_group("player")
		_hud.text = "RICOCHET REQUIEM  //  P0 GRAY ROOM\nWASD move   SPACE dash   LMB fire\nDead slugs tune. First wall bounce makes them LIVE.\nHP %d / %d   Slugs %d / %d" % [player.hp, Balance.PLAYER_MAX_HP, get_tree().get_nodes_in_group("slugs").size(), Balance.MAX_SLUGS]

func _spawn_enemy(kind: String, at: Vector2) -> void:
	var enemy := EnemyScript.new()
	enemy.global_position = at
	enemy.configure(kind)
	enemy.died.connect(_on_enemy_died)
	add_child(enemy)

func _on_enemy_died(at: Vector2, spawn_resonance: bool) -> void:
	if not spawn_resonance:
		return
	var note := ResonanceNoteScript.new()
	note.global_position = at
	add_child(note)

func _build_room() -> void:
	var half := Balance.ROOM_SIZE / 2.0
	_add_wall(Vector2(0.0, -half.y), Vector2(Balance.ROOM_SIZE.x, Balance.WALL_THICKNESS))
	_add_wall(Vector2(0.0, half.y), Vector2(Balance.ROOM_SIZE.x, Balance.WALL_THICKNESS))
	_add_wall(Vector2(-half.x, 0.0), Vector2(Balance.WALL_THICKNESS, Balance.ROOM_SIZE.y))
	_add_wall(Vector2(half.x, 0.0), Vector2(Balance.WALL_THICKNESS, Balance.ROOM_SIZE.y))
	var pillar := StaticBody2D.new()
	pillar.position = Vector2(0.0, -70.0)
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(150.0, Balance.WALL_THICKNESS)
	shape.shape = rectangle
	pillar.add_child(shape)
	add_child(pillar)

func _add_wall(pos: Vector2, size: Vector2) -> void:
	var wall := StaticBody2D.new()
	wall.position = pos
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = size
	shape.shape = rectangle
	wall.add_child(shape)
	add_child(wall)

func _build_hud() -> void:
	_hud = Label.new()
	_hud.position = Vector2(28.0, 24.0)
	_hud.add_theme_color_override("font_color", Color("#d6d0c4"))
	_hud.add_theme_font_size_override("font_size", 16)
	add_child(_hud)

func _draw() -> void:
	var half := Balance.ROOM_SIZE / 2.0
	draw_rect(Rect2(-half, Balance.ROOM_SIZE), Color("#22242e"))
	draw_rect(Rect2(-half, Balance.ROOM_SIZE), Color("#69616a"), false, 4.0)
	draw_rect(Rect2(Vector2(-75.0, -82.0), Vector2(150.0, 24.0)), Color("#4d4650"))
