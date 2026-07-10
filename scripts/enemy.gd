class_name RequiemEnemy
extends Area2D
## Base enemy for P0. A dead slug tunes; only a live slug can deal damage.

signal died(at: Vector2, spawn_resonance: bool, bounces: int, tuned: bool)
signal shot_fired(origin: Vector2, direction: Vector2)

var kind := "chorister"
var hp := 0
var _tuned_remaining := 0.0
var _shot_cooldown := Balance.WAILER_FIRE_INTERVAL

func _ready() -> void:
	collision_layer = 2
	collision_mask = 4 | 8
	add_to_group("enemies")
	if get_node_or_null("CollisionShape2D") == null:
		var collision_shape := CollisionShape2D.new()
		var circle := CircleShape2D.new()
		circle.radius = Balance.ENEMY_RADIUS
		collision_shape.shape = circle
		add_child(collision_shape)
	area_entered.connect(_on_area_entered)

func configure(enemy_kind: String) -> void:
	kind = enemy_kind
	hp = Balance.ENEMY_HP[kind]
	queue_redraw()

func _physics_process(delta: float) -> void:
	_tuned_remaining = maxf(_tuned_remaining - delta, 0.0)
	var player := get_tree().get_first_node_in_group("player")
	if player and kind == "chorister":
		global_position += global_position.direction_to(player.global_position) * Balance.ENEMY_SPEED[kind] * delta
	elif player and kind == "sidler":
		var toward: Vector2 = global_position.direction_to(player.global_position)
		var strafe := toward.rotated(PI / 2.0)
		global_position += (toward * 0.35 + strafe * 0.9).normalized() * Balance.ENEMY_SPEED[kind] * delta
	elif player and kind == "wailer":
		_shot_cooldown -= delta
		if _shot_cooldown <= 0.0:
			shot_fired.emit(global_position, global_position.direction_to(player.global_position))
			_shot_cooldown = Balance.WAILER_FIRE_INTERVAL
	queue_redraw()

func apply_slug_hit(slug_state: int, bounces: int) -> Dictionary:
	if slug_state == Slug.State.DEAD:
		_tuned_remaining = Balance.TUNING_DURATION
		queue_redraw()
		return {"tuned": true, "killed": false, "resonance": false}
	var was_tuned := is_tuned()
	var effective_tier := mini(bounces + (1 if was_tuned else 0), Balance.DAMAGE_TIERS.size() - 1)
	_tuned_remaining = 0.0
	hp -= Balance.DAMAGE_TIERS[effective_tier]
	var killed := hp <= 0
	var resonance := killed and bounces >= 2
	if killed:
		died.emit(global_position, resonance, bounces, was_tuned)
		queue_free()
	else:
		queue_redraw()
	return {"tuned": false, "killed": killed, "resonance": resonance}

func is_tuned() -> bool:
	return _tuned_remaining > 0.0

func _draw() -> void:
	var colors := {"chorister": Color("#bd7d8d"), "sidler": Color("#7199c8"), "wailer": Color("#b08ac7")}
	var color: Color = colors[kind]
	if is_tuned():
		color = Color("#d8cf73")
	draw_circle(Vector2.ZERO, Balance.ENEMY_RADIUS, color)
	draw_circle(Vector2.ZERO, Balance.ENEMY_RADIUS + 3.0, Color(color, 0.22), false, 2.0)
	draw_line(Vector2(-8.0, 0.0), Vector2(8.0, 0.0), Color("#171820"), 3.0)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hurtbox":
		var player := area.get_parent()
		if player:
			player.take_damage(Balance.ENEMY_CONTACT_DAMAGE)
