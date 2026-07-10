extends SceneTree
## Step 2 contract: dead slugs tune, only live slugs kill, resonance needs bounce 2+.

const EnemyScript := preload("res://scripts/enemy.gd")
var failures: Array[String] = []

func _init() -> void:
	var target := EnemyScript.new()
	target.configure("chorister")
	_check(Balance.ENEMY_HP["sidler"] > Balance.ENEMY_HP["chorister"] and Balance.ENEMY_SPEED["wailer"] > 0.0, "all P0 enemy configurations must exist")
	var dead_result := target.apply_slug_hit(Slug.State.DEAD, 0)
	_check(dead_result.tuned and target.hp == Balance.ENEMY_HP["chorister"], "dead slug must tune without dealing damage")
	var tuned_live := target.apply_slug_hit(Slug.State.LIVE, 1)
	_check(target.hp == 1 and not tuned_live.killed, "tuned tier-1 live hit must use tier-2 damage")
	var final_live := target.apply_slug_hit(Slug.State.LIVE, 1)
	_check(final_live.killed and not final_live.resonance, "live bounce-1 kill must not spawn resonance")
	var bounce_two_target := EnemyScript.new()
	bounce_two_target.configure("chorister")
	bounce_two_target.hp = Balance.DAMAGE_TIERS[2]
	var bounce_two := bounce_two_target.apply_slug_hit(Slug.State.LIVE, 2)
	_check(bounce_two.killed and bounce_two.resonance, "bounce-2 live kill must spawn resonance")
	if is_instance_valid(target):
		target.free()
	if is_instance_valid(bounce_two_target):
		bounce_two_target.free()
	if failures.is_empty():
		print("PASS test_tuning_resonance: tuning, live damage, and resonance rules hold")
		quit(0)
	for failure in failures:
		push_error(failure)
	quit(1)

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
