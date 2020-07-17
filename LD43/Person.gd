extends StaticBody2D

const meat = preload("res://Meat.tscn")
const blood = preload("res://graphics/Blood.tscn")
var dead = false

func _ready():
	pass

func kill():
	if dead:
		return
	dead = true
	$CollisionShape2D.disabled = true
	collision_layer = 2
	
	get_node("Graphics").global_rotation_degrees = 90
	get_node("Feedable").dead = true
	var b = blood.instance()
	get_tree().get_root().add_child(b)
	get_tree().get_root().move_child(b, 0)
	b.global_position = global_position
	b.add_to_group("delete_on_restart")
	
	
	var m = meat.instance()
	get_tree().get_root().add_child(m)
	m.global_position = global_position
	get_node("Feedable").kill()
	m.add_to_group("delete_on_restart")

func feed():
	return get_node("Feedable").feed()