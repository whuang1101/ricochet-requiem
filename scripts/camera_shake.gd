extends Camera2D

var trauma := 0.0

func _process(delta: float) -> void:
	trauma = maxf(trauma - 2.5 * delta, 0.0)
	var amount := trauma * trauma * 18.0
	offset = Vector2(randf_range(-amount, amount), randf_range(-amount, amount))

func add_trauma(amount: float) -> void:
	trauma = minf(trauma + amount, 1.0)
