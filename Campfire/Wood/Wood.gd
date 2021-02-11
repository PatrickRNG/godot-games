extends Sprite

func _on_Area2D_body_entered(body):
	# Grab wood from player
	if body.is_in_group('player'):
		body.wood += 2
		queue_free()
