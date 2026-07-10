class_name RequiemPlayer
extends CharacterBody2D

signal damaged(amount: int, hp_remaining: int)
signal died

var _dash_timer := 0.0
var _dash_cooldown := 0.0
var _aim_direction := Vector2.RIGHT
var hp := Balance.PLAYER_MAX_HP

func _physics_process(delta: float) -> void:
	_dash_timer = maxf(_dash_timer - delta, 0.0)
	_dash_cooldown = maxf(_dash_cooldown - delta, 0.0)
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("dash") and _dash_cooldown <= 0.0:
		_dash_timer = Balance.DASH_DURATION
		_dash_cooldown = Balance.DASH_COOLDOWN
		velocity = (input_vector if input_vector.length_squared() > 0.0 else _aim_direction) * Balance.DASH_SPEED
	if _dash_timer <= 0.0:
		velocity = input_vector * Balance.PLAYER_SPEED
	move_and_slide()
	global_position.x = clampf(global_position.x, -Balance.ROOM_SIZE.x / 2.0 + Balance.PLAYER_RADIUS, Balance.ROOM_SIZE.x / 2.0 - Balance.PLAYER_RADIUS)
	global_position.y = clampf(global_position.y, -Balance.ROOM_SIZE.y / 2.0 + Balance.PLAYER_RADIUS, Balance.ROOM_SIZE.y / 2.0 - Balance.PLAYER_RADIUS)
	_aim_direction = get_global_mouse_position() - global_position
	if _aim_direction.length_squared() > 0.0:
		_aim_direction = _aim_direction.normalized()
	queue_redraw()

func _ready() -> void:
	if get_node_or_null("Hurtbox") == null:
		var hurtbox := Area2D.new()
		hurtbox.name = "Hurtbox"
		hurtbox.collision_layer = 8
		hurtbox.collision_mask = 2 | 4
		var collision_shape := CollisionShape2D.new()
		var circle := CircleShape2D.new()
		circle.radius = Balance.PLAYER_RADIUS
		collision_shape.shape = circle
		hurtbox.add_child(collision_shape)
		add_child(hurtbox)

func aim_direction() -> Vector2:
	return _aim_direction

func heal(amount: int) -> void:
	hp = mini(hp + amount, Balance.PLAYER_MAX_HP)

func take_damage(amount: int) -> void:
	hp = maxi(hp - amount, 0)
	damaged.emit(amount, hp)
	if hp == 0:
		died.emit()

func _draw() -> void:
	draw_circle(Vector2.ZERO, Balance.PLAYER_RADIUS, Color("#f2eee5"))
	draw_circle(Vector2.ZERO, Balance.PLAYER_RADIUS + 3.0, Color("#d97757"), false, 2.0)
	draw_line(Vector2.ZERO, _aim_direction * 28.0, Color("#f2eee5"), 4.0)
