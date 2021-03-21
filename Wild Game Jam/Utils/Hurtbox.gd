extends Node

signal is_hit

func _on_Hurtbox_area_entered(area):
#	var target = area.get_parent()
	emit_signal("is_hit")

func hit_effect(target: Node, color: Color):
	target.modulate = color
	yield(get_tree().create_timer(0.2), "timeout")
	target.modulate = Color(1, 1, 1, 1)
