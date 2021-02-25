extends StaticBody2D

onready var campfireHealth = $Health

signal change_tree_position

func _on_Hurtbox_body_entered(body):
	# Grab wood from player
	var player = body
	campfireHealth.current += player.wood
	player.wood = 0
	player.detach_item()

func _on_LimitSpawn_area_entered(tree_area):
	# Spawn tree again if inside campfire area
	var tree = tree_area.get_parent()
	emit_signal("change_tree_position", tree)
