extends SceneTree
## Step 1 contract: 100 random shots in a box all expire or detonate, without tunneling.

const SlugScript := preload("res://scripts/slug.gd")

var failures: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_add_wall(world, Vector2(0.0, -Balance.ROOM_SIZE.y / 2.0), Vector2(Balance.ROOM_SIZE.x, Balance.WALL_THICKNESS))
	_add_wall(world, Vector2(0.0, Balance.ROOM_SIZE.y / 2.0), Vector2(Balance.ROOM_SIZE.x, Balance.WALL_THICKNESS))
	_add_wall(world, Vector2(-Balance.ROOM_SIZE.x / 2.0, 0.0), Vector2(Balance.WALL_THICKNESS, Balance.ROOM_SIZE.y))
	_add_wall(world, Vector2(Balance.ROOM_SIZE.x / 2.0, 0.0), Vector2(Balance.WALL_THICKNESS, Balance.ROOM_SIZE.y))
	await process_frame
	for i in 100:
		await _run_shot(world, i)
	if failures.is_empty():
		print("PASS test_slug_physics: 100 shots expired or detonated with no tunneling")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)

func _run_shot(world: Node2D, index: int) -> void:
	var slug := SlugScript.new()
	world.add_child(slug)
	slug.setup(Vector2.ZERO, Vector2.RIGHT.rotated(float(index) * TAU / 100.0))
	await process_frame
	var terminal := false
	for _step in 300:
		if terminal or not is_instance_valid(slug):
			break
		slug.simulate_step(1.0 / 60.0)
		terminal = slug._finished
		var limit := Balance.ROOM_SIZE / 2.0 + Vector2(2.0, 2.0)
		if absf(slug.position.x) > limit.x or absf(slug.position.y) > limit.y:
			failures.append("shot %d tunneled outside room at %s" % [index, slug.position])
			return
	if not terminal:
		failures.append("shot %d did not expire or detonate" % index)

func _add_wall(world: Node2D, pos: Vector2, size: Vector2) -> void:
	var wall := StaticBody2D.new()
	wall.position = pos
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = size
	shape.shape = rectangle
	wall.add_child(shape)
	world.add_child(wall)
