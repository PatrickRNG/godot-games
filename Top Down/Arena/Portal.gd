extends Node2D

var enemy = preload("res://Enemies/Enemy.tscn")

onready var timer = $SpawnTime

export(float) var spawn_delay = 3
export(bool) var is_spawning = true
export(int) var max_enemies = 5
export(int) var enemies_count = 0

func _ready():
	timer.wait_time = spawn_delay

func _on_SpawnTime_timeout():
	if is_spawning and enemies_count < max_enemies:
		enemies_count += 1
		var enemy_instance = enemy.instance()
		enemy_instance.position = global_position
		get_tree().get_root().add_child(enemy_instance)
