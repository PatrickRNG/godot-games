extends StaticBody2D

onready var campfireHealth = $Health

func _on_Hurtbox_body_entered(body):
	# Grab wood from player
	var player = body
	campfireHealth.current += player.wood
	player.wood = 0
	Manager.wood = player.wood
