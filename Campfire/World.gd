extends Node2D

onready var campfireHealth = $YSort/Campfire/Health
onready var world = $YSort
onready var tree = preload("res://Tree/Tree.tscn")
onready var spawn_boundaries_top_left = $Spawn_boundaries_top_left
onready var spawn_boundaries_bottom_right = $Spawn_boundaries_bottom_right
onready var spawn_boundaries_bottom_left = $Spawn_boundaries_bottom_left
onready var spawn_boundaries_top_right = $Spawn_boundaries_top_right

export(int) var total_tree_spawn_count = 80

func _ready():
	# Spawn all trees
	for n in total_tree_spawn_count:
		spawn_tree()

func spawn_tree():
	var screenSize = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var tree_position = Vector2(rng.randi_range(
		spawn_boundaries_top_left.position.x, 
		spawn_boundaries_bottom_right.position.x), 
		rng.randi_range(spawn_boundaries_bottom_left.position.y, 
		spawn_boundaries_top_right.position.y))
	
	var tree_instance = tree.instance()
	tree_instance.connect("spawn_tree", self, "spawn_tree")
	
	world.add_child(tree_instance)
	tree_instance.position = tree_position

func _on_Timer_timeout():
	campfireHealth.current -= 1
