class_name ResonanceNote
extends Node2D
## Healing is deliberately created at bounce-2+ kill sites, inside the danger.

var lifetime := Balance.RESONANCE_LIFETIME

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
		return
	var player := get_tree().get_first_node_in_group("player")
	if player:
		global_position = global_position.move_toward(player.global_position, Balance.ENEMY_SPEED["chorister"] * delta)
		if global_position.distance_to(player.global_position) <= Balance.RESONANCE_PICKUP_RADIUS:
			player.heal(Balance.RESONANCE_HEAL)
			queue_free()
	queue_redraw()

func _draw() -> void:
	var bob := sin(Time.get_ticks_msec() / 150.0) * 3.0
	draw_circle(Vector2(0.0, bob), 8.0, Color("#77d9c3"))
	draw_circle(Vector2(0.0, bob), 12.0, Color("#77d9c3", 0.2), false, 2.0)
