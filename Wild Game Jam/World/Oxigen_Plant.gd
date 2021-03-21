extends Node2D

func _on_Area2D_body_entered(player):
	player.setup_o2_meter(true, 2, 0.5)

func _on_Area2D_body_exited(player):
	player.setup_o2_meter()
