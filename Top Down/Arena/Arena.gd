extends Node2D

var max_enemies = 2
var spawn_delay = 3
var portal_count = 0
var update_portal = false

var portal = preload("res://Arena/Portal.tscn")
func _ready():
	randomize()

func _process(_delta):
	var is_next_wave = Global.wave_enemies_killed >= round(max_enemies)
#	print(Global.wave_enemies_killed, ' - ', round(max_enemies))
	if portal_count == 0:
		portal_count += 1
		spawn_portal(max_enemies, spawn_delay)
	if is_next_wave:
		Global.wave += 1
		Global.wave_enemies_killed = 0
		max_enemies += 2
		spawn_delay -= 0.5
		portal_count += 1
		
#		Difficult
		var random = randi() % 2
#		print(random)
		if random == 0:
			var max_portals = 2
			for i in range(max_portals):
				spawn_portal(max_enemies / max_portals, spawn_delay)
		elif random == 1:
			max_enemies *= 1.5
			spawn_portal(max_enemies, spawn_delay)
		else:
			spawn_delay -= 0.5
			spawn_portal(max_enemies, spawn_delay) 

func spawn_portal(enemies, delay):
	var portal_position = Vector2(rand_range(30, 450), rand_range(30, 235))
	var portal_instance = portal.instance()
	portal_instance.max_enemies = enemies
	portal_instance.spawn_delay = delay
	portal_instance.global_position = portal_position
	get_tree().get_root().add_child(portal_instance)
