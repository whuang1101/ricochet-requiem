extends Node2D

const PlayerScript := preload("res://scripts/player.gd")
const ShooterScript := preload("res://scripts/shooter.gd")

var _hud: Label

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#171820"))
	_build_room()
	var player := PlayerScript.new()
	player.position = Vector2.ZERO
	player.add_child(ShooterScript.new())
	add_child(player)
	_build_hud()

func _process(_delta: float) -> void:
	if is_instance_valid(_hud):
		_hud.text = "RICOCHET REQUIEM  //  P0 GRAY ROOM\nWASD move   SPACE dash   LMB fire\nDead slugs pass through. First wall bounce makes them LIVE.\nLive slugs: %d / %d" % [get_tree().get_nodes_in_group("slugs").size(), Balance.MAX_SLUGS]

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
