extends Camera2D

var target_position = Vector2.ZERO

func _ready():
	make_current()


func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20)) # Math to make smoothing work with any frames per second


func acquire_target():
	# Get all nodes in the player group (array)
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position = player.global_position
