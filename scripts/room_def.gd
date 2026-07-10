class_name RoomDef
extends Node2D

signal spawn_requested(kind: String, at: Vector2)

@export var room_id := 0

func begin() -> void:
	for enemy in _layout_enemies():
		spawn_requested.emit(enemy.kind, enemy.at)

func _ready() -> void:
	_build_walls()
	queue_redraw()

func _layout_enemies() -> Array:
	var layouts := [
		[{"kind": "chorister", "at": Vector2(-260.0, -140.0)}, {"kind": "sidler", "at": Vector2(280.0, -120.0)}, {"kind": "wailer", "at": Vector2(220.0, 150.0)}],
		[{"kind": "chorister", "at": Vector2(-320.0, 120.0)}, {"kind": "chorister", "at": Vector2(310.0, -140.0)}, {"kind": "sidler", "at": Vector2(0.0, -200.0)}],
		[{"kind": "wailer", "at": Vector2(-290.0, -170.0)}, {"kind": "sidler", "at": Vector2(290.0, 170.0)}, {"kind": "chorister", "at": Vector2(0.0, 180.0)}],
		[{"kind": "sidler", "at": Vector2(-260.0, -180.0)}, {"kind": "sidler", "at": Vector2(260.0, 180.0)}, {"kind": "wailer", "at": Vector2(0.0, -180.0)}],
		[{"kind": "chorister", "at": Vector2(-310.0, 0.0)}, {"kind": "wailer", "at": Vector2(310.0, 0.0)}, {"kind": "sidler", "at": Vector2(0.0, 200.0)}],
	]
	var base: Array = layouts[room_id % layouts.size()]
	if room_id >= 5:
		base = base.duplicate(true)
		base[0].kind = "mirrorback" if room_id % 2 == 0 else "mason"
	if room_id >= 10:
		base = base.duplicate(true)
		base[1].kind = "bellringer"
	return base

func _build_walls() -> void:
	var half := Balance.ROOM_SIZE / 2.0
	_add_wall(Vector2(0.0, -half.y), Vector2(Balance.ROOM_SIZE.x, Balance.WALL_THICKNESS))
	_add_wall(Vector2(0.0, half.y), Vector2(Balance.ROOM_SIZE.x, Balance.WALL_THICKNESS))
	_add_wall(Vector2(-half.x, 0.0), Vector2(Balance.WALL_THICKNESS, Balance.ROOM_SIZE.y))
	_add_wall(Vector2(half.x, 0.0), Vector2(Balance.WALL_THICKNESS, Balance.ROOM_SIZE.y))
	var pillar_positions := [Vector2(0.0, -70.0), Vector2(-180.0, 0.0), Vector2(180.0, 0.0), Vector2(0.0, 110.0), Vector2.ZERO]
	_add_wall(pillar_positions[room_id % pillar_positions.size()], Vector2(150.0, Balance.WALL_THICKNESS))

func _add_wall(pos: Vector2, size: Vector2) -> void:
	var wall := StaticBody2D.new()
	wall.position = pos
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = size
	shape.shape = rectangle
	wall.add_child(shape)
	add_child(wall)

func _draw() -> void:
	var half := Balance.ROOM_SIZE / 2.0
	draw_rect(Rect2(-half, Balance.ROOM_SIZE), Color("#22242e"))
	draw_rect(Rect2(-half, Balance.ROOM_SIZE), Color("#69616a"), false, 4.0)
	draw_string(ThemeDB.fallback_font, Vector2(-half.x + 24.0, half.y - 22.0), "ROOM %d  //  clear the score" % (room_id + 1), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, Color("#847b87"))
