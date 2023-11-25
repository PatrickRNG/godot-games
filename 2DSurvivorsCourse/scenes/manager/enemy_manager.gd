extends Node

# Some pixels outside the boundaries of the window
const SPAWN_RADIUS = 370

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawnn_time = 0

func _ready():
	base_spawnn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	# A Vector that is rotated from 0 to 360deg in radians
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	# Iterate throught 4 because 90º * 4 = 360deg
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		
		# Check if it's invalid spawn position
		var terrain_mask_value = 1
		# player pos = starting pos. spawn pos = spawn pos of enemy. terrain mask = collision being checked if ray is hitting
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, terrain_mask_value)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if result.is_empty():
			break
		else:
			# Rotating by 90º if spawn location is intersecting a wall (to find an empty space)
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.1 / 12) * arena_difficulty # 5 seconds per difficulty increase - 12 5s segments in a minute
	time_off = min(time_off, .7)
	timer.wait_time = base_spawnn_time - time_off
