class_name Slug
extends CharacterBody2D
## A dead slug becomes live only after its first wall contact.

signal bounced(tier: int, at: Vector2)
signal detonated(at: Vector2, tier: int)
signal expired

enum State { DEAD, LIVE }

var state := State.DEAD
var tier := 0
var bounces := 0
var lifetime := Balance.SLUG_LIFETIME
var direction := Vector2.RIGHT
var _finished := false

func setup(origin: Vector2, shot_direction: Vector2) -> void:
	if get_node_or_null("CollisionShape2D") == null:
		var collision_shape := CollisionShape2D.new()
		var circle := CircleShape2D.new()
		circle.radius = Balance.SLUG_RADIUS
		collision_shape.shape = circle
		add_child(collision_shape)
	if get_node_or_null("Hitbox") == null:
		var hitbox := Area2D.new()
		hitbox.name = "Hitbox"
		hitbox.collision_layer = 4
		hitbox.collision_mask = 2
		var hit_shape := CollisionShape2D.new()
		var hit_circle := CircleShape2D.new()
		hit_circle.radius = Balance.SLUG_RADIUS
		hit_shape.shape = hit_circle
		hitbox.add_child(hit_shape)
		hitbox.area_entered.connect(_on_hit_area)
		add_child(hitbox)
	global_position = origin
	direction = shot_direction.normalized()
	velocity = direction * Balance.SLUG_SPEED
	queue_redraw()

func _physics_process(delta: float) -> void:
	simulate_step(delta)

func simulate_step(delta: float) -> void:
	if _finished:
		return
	lifetime -= delta
	if lifetime <= 0.0:
		expire()
		return
	var collision := move_and_collide(velocity * delta)
	if collision:
		global_position = collision.get_position()
		velocity = velocity.bounce(collision.get_normal()) * Balance.SLUG_BOUNCE_SPEED_MULTIPLIER
		bounces += 1
		tier = mini(bounces, Balance.MAX_BOUNCES)
		state = State.LIVE
		bounced.emit(tier, global_position)
		queue_redraw()
		if bounces >= Balance.MAX_BOUNCES:
			detonate()
		return
	queue_redraw()

func detonate() -> void:
	if _finished:
		return
	_finished = true
	detonated.emit(global_position, tier)
	queue_free()

func expire() -> void:
	if _finished:
		return
	_finished = true
	expired.emit()
	queue_free()

func _draw() -> void:
	var color := Color("#8c9099") if state == State.DEAD else _tier_color()
	draw_circle(Vector2.ZERO, Balance.SLUG_RADIUS, color)
	draw_line(Vector2(-16.0, 0.0), Vector2(-Balance.SLUG_RADIUS, 0.0), color.lightened(0.2), 3.0)
	if state == State.LIVE:
		draw_circle(Vector2.ZERO, Balance.SLUG_RADIUS + 3.0, Color(color, 0.18), false, 2.0)

func _tier_color() -> Color:
	var colors := [Color("#f5d06f"), Color("#f2a65a"), Color("#ee7654"), Color("#dd4d87"), Color("#b36cff")]
	return colors[mini(maxi(tier, 1) - 1, colors.size() - 1)]

func _on_hit_area(area: Area2D) -> void:
	if area is RequiemEnemy:
		area.apply_slug_hit(state, bounces)
