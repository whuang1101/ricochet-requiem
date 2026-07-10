class_name Shooter
extends Node
## All firing lives here so adding a second player later does not rewrite combat.

const SlugScript := preload("res://scripts/slug.gd")

signal flourish(kill_count: int)

var _cooldown := 0.0

func _process(delta: float) -> void:
	_cooldown = maxf(_cooldown - delta, 0.0)
	var deck := get_tree().get_first_node_in_group("deck")
	if Input.is_action_pressed("fire") and _cooldown <= 0.0 and deck and deck.start_chosen:
		fire()

func fire() -> void:
	var slugs := get_tree().get_nodes_in_group("slugs")
	var gun: String = get_node("/root/Game").active_gun
	var max_slugs := Balance.MAX_SLUGS if gun != "tuba" else 2
	if slugs.size() >= max_slugs:
		return
	_cooldown = 1.0 / Balance.FIRE_RATE
	var slug := SlugScript.new()
	slug.add_to_group("slugs")
	get_tree().current_scene.add_child(slug)
	var deck := get_tree().get_first_node_in_group("deck")
	slug.lifetime += deck.modifiers.extra_lifetime
	slug.max_bounces += deck.modifiers.extra_bounces
	slug.live_speed_bonus = deck.modifiers.live_speed_bonus
	slug.flourish.connect(func(kill_count: int): flourish.emit(kill_count))
	var player: RequiemPlayer = get_parent()
	slug.setup(player.global_position + player.aim_direction() * (Balance.PLAYER_RADIUS + 8.0), player.aim_direction())
	player.position -= player.aim_direction() * Balance.MUZZLE_NUDGE
	if gun == "fanfare":
		for angle in [-12.0, 12.0]:
			var fan_slug := SlugScript.new()
			fan_slug.add_to_group("slugs")
			get_tree().current_scene.add_child(fan_slug)
			fan_slug.setup(player.global_position, player.aim_direction().rotated(deg_to_rad(angle)))
