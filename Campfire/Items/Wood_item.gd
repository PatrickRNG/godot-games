extends Node2D

func _on_Area2D_body_entered(body):
	var player = body
	if (!player.is_holding):
		player.is_holding = true
		player.wood += 2
		player.attach_item("Wood")
		queue_free()
