class_name Shooter
extends Node
## All firing lives here so adding a second player later does not rewrite combat.

const SlugScript := preload("res://scripts/slug.gd")

var _cooldown := 0.0

func _process(delta: float) -> void:
	_cooldown = maxf(_cooldown - delta, 0.0)
	if Input.is_action_pressed("fire") and _cooldown <= 0.0:
		fire()

func fire() -> void:
	var slugs := get_tree().get_nodes_in_group("slugs")
	if slugs.size() >= Balance.MAX_SLUGS:
		return
	_cooldown = 1.0 / Balance.FIRE_RATE
	var slug := SlugScript.new()
	slug.add_to_group("slugs")
	get_tree().current_scene.add_child(slug)
	var player: RequiemPlayer = get_parent()
	slug.setup(player.global_position + player.aim_direction() * (Balance.PLAYER_RADIUS + 8.0), player.aim_direction())
