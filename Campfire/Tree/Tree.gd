extends Node2D

signal can_cut_tree(can_cut)

func _on_Area2D_area_entered(area):
	var player = area.get_parent()
	connect("can_cut_tree", player, "toggle_cut_tree")
	emit_signal("can_cut_tree", true, self)

func _on_Area2D_area_exited(area):
	emit_signal("can_cut_tree", false, null)
