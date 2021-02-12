extends StaticBody2D

onready var campfireHealth = $Health

func _on_Area2D_area_entered(area):
	# Grab wood from player
	var player = area.get_parent()
	campfireHealth.current += player.wood
	player.wood = 0
