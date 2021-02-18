extends Node2D

onready var campfireHealth = $YSort/Campfire/Health
onready var world = $YSort
onready var tree = preload("res://Tree/Tree.tscn").duplicate()

export(int) var tree_spawn_count = 10

func _ready():
	# Spawn all trees
	spawn_trees()
	
func spawn_trees():
	var screenSize = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for n in tree_spawn_count:
		var tree_position = Vector2(rng.randi_range(0, screenSize.x), rng.randi_range(0, screenSize.y))
		var tree_instance = tree.instance()
		world.add_child(tree_instance)
		tree_instance.position = tree_position

func _on_Timer_timeout():
	campfireHealth.current -= 1
