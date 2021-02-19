extends Node2D

func _on_Area2D_body_entered(body):
	var player = body
	player.wood += 1
	Manager.wood = player.wood
	queue_free()
