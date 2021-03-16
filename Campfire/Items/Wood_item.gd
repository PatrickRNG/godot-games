extends Node2D

export(int) var wood_value = 2

# TODO - Make an item.gd

func _on_Area2D_body_entered(body):
	var player = body
	if (!player.is_holding):
		player.is_holding = true
		player.wood += wood_value
		player.attach_item("Wood")
		queue_free()

func disable_colectable():
	$Area2D/CollisionShape2D.disabled = true
