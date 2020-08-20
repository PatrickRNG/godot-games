extends RigidBody2D

var explosion = preload("res://Player/Explosion.tscn")

func _on_Bullet_body_entered(body):
	if !body.is_in_group("player") and !body.is_in_group("bullet"):
		var explosion_instance = explosion.instance()
		explosion_instance.position = global_position
		get_tree().get_root().add_child(explosion_instance)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
