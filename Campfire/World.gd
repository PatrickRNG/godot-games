extends Node2D

onready var campfireHealth = $YSort/Campfire/Health
onready var wood = preload("res://Wood/Wood.tscn")


func _ready():
	# Spawn all wood
	spawn_wood()
	
func spawn_wood():
	var screenSize = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var wood_position = Vector2(rng.randi_range(0, screenSize.x), rng.randi_range(0, screenSize.y))
	var wood_instance = wood.instance()
	add_child(wood_instance)
	wood_instance.position = wood_position

func _on_Timer_timeout():
	campfireHealth.current -= 1
