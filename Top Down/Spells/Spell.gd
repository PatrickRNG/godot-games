extends RigidBody2D

#var explosion = preload("res://Player/Explosion.tscn")

export(int) var projectile_speed = 200
var enemy_hit_count: int = 0

func _physics_process(delta):
	position += Vector2(projectile_speed, 0).rotated(rotation) * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
