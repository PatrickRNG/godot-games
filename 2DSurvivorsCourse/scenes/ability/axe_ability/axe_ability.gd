extends Node2D

# As far as the axe can be from the player in radius
const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT

func _ready():
	# Randomized spawn direction to end in difference place
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	# telling the tween that we want to go from 0 to 2, over 3 seconds (float). And while tweening, call the tween method with the current value.
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 3)
	tween.tween_callback(queue_free)


func tween_method(rotations: float):
	var percent = rotations / 2
	var current_radius = percent * MAX_RADIUS
	# Get rotation applied to Right vector (0 deg)
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	var root_position = Vector2.ZERO
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null:
		return
	
	root_position = player.global_position
	
	global_position = root_position + (current_direction * current_radius)
