extends StaticBody2D

onready var campfireHealth = $Health

func _on_Area2D_body_entered(body):
	# Grab wood from player
	if body.is_in_group('player'):
		var wood = body.wood
		campfireHealth.current += wood
		body.wood -= wood
		
	
