extends Node2D

onready var campfireHealth = $YSort/Campfire/Health
onready var wood = preload("res://Wood/Wood.tscn")

export(int) var wood_spawn_count = 10

func _ready():
	# Spawn all wood
	spawn_wood()
	
func spawn_wood():
	var screenSize = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for n in wood_spawn_count:
		var wood_position = Vector2(rng.randi_range(0, screenSize.x), rng.randi_range(0, screenSize.y))
		var wood_instance = wood.instance()
		add_child(wood_instance)
		wood_instance.position = wood_position

func _on_Timer_timeout():
	campfireHealth.current -= 1
