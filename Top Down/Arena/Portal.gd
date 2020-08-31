extends Node2D

onready var timer = $SpawnTime
onready var sprite = $Sprite
onready var animation_tree = $AnimationTree
onready var animation_mode = animation_tree.get("parameters/playback")

export(float) var spawn_rate = 1
export(bool) var is_spawning = true
export(int) var max_enemies = 5
var spawned_enemies = 0
var total_weight = 0

var enemies = [
	{
		"name": 'Goblin',
		"wave": 1,
		"weight": 85
	},
	{	
		"name": 'Barbarian',
		"wave": 6,
		"weight": 15
	}
]

func _init():
#	 Update enemies array with the correct accumulative weights
	var weights = Random.get_weighted_properties(enemies)
	enemies = weights.list
	total_weight = weights.total_weight

func _ready():
	timer.wait_time = spawn_rate
	sprite.frame = 8
	animation_tree.active = true

func spawn_enemy() -> void:
	var random_enemy = Random.get_random_instance_by_weight(enemies, total_weight, enemies[0]);
	var enemy = load("res://Enemies/" + random_enemy.name + ".tscn")
	var enemy_instance = enemy.instance()
	enemy_instance.position = global_position
	get_tree().get_root().add_child(enemy_instance)

func destroy_portal() -> void:
	animation_mode.travel("Destroy")

func _on_SpawnTime_timeout():
	if (spawned_enemies >= max_enemies):
		is_spawning = false
	if is_spawning:
		spawn_enemy()
		spawned_enemies += 1
