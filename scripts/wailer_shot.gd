class_name WailerShot
extends Node2D
## Wailer shots use the same bounce rule: direct lines are harmless.

var velocity := Vector2.ZERO
var lifetime := Balance.SLUG_LIFETIME
var live := false

func setup(origin: Vector2, shot_direction: Vector2) -> void:
	global_position = origin
	velocity = shot_direction.normalized() * Balance.WAILER_SHOT_SPEED
	queue_redraw()

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
		return
	var next := global_position + velocity * delta
	var half := Balance.ROOM_SIZE / 2.0 - Vector2(Balance.WALL_THICKNESS, Balance.WALL_THICKNESS)
	if absf(next.x) >= half.x:
		velocity.x *= -1.0
		live = true
	if absf(next.y) >= half.y:
		velocity.y *= -1.0
		live = true
	global_position += velocity * delta
	var player := get_tree().get_first_node_in_group("player")
	if live and player and global_position.distance_to(player.global_position) <= Balance.PLAYER_RADIUS + Balance.SLUG_RADIUS:
		player.take_damage(Balance.WAILER_SHOT_DAMAGE)
		queue_free()
	queue_redraw()

func _draw() -> void:
	var color := Color("#96818e") if not live else Color("#d46498")
	draw_circle(Vector2.ZERO, Balance.SLUG_RADIUS, color)
