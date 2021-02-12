extends Sprite

func _on_Hurtbox_area_entered(area):
	# Grab wood from player
	var player = area.get_parent()
	player.wood += 2
	queue_free()
