extends Node

static func burst(parent: Node, at: Vector2, color: Color, count := 12) -> void:
	var particles := CPUParticles2D.new()
	particles.global_position = at
	particles.one_shot = true
	particles.emitting = true
	particles.amount = count
	particles.lifetime = 0.35
	particles.explosiveness = 1.0
	particles.spread = 180.0
	particles.initial_velocity_min = 55.0
	particles.initial_velocity_max = 180.0
	particles.scale_amount_min = 2.0
	particles.scale_amount_max = 4.0
	particles.color = color
	parent.add_child(particles)
	particles.get_tree().create_timer(0.8).timeout.connect(particles.queue_free)

static func freeze(tree: SceneTree, duration := 0.12) -> void:
	Engine.time_scale = 0.05
	tree.create_timer(duration, true, false, true).timeout.connect(func(): Engine.time_scale = 1.0)
