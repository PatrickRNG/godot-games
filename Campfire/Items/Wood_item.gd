extends Node2D

export(int) var wood_value = 2

func _on_Area2D_body_entered(body):
	var player = body
	if (!player.is_holding):
		player.is_holding = true
		player.wood += wood_value
		player.attach_item("Wood")
		queue_free()
