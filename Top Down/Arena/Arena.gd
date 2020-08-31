extends Node2D

var rng = RandomNumberGenerator.new()

onready var portal = preload("res://Arena/Portal.tscn")
onready var portal_timer = $PortalTimer

export(bool) var is_spawning = true

var spawn_rate: float = 1
var portal_rate: float = 8
var portal_count: int = 0 setget set_portal_count
var min_enemies_per_portal_number = 2
var max_enemies_per_portal_number = 4
var max_enemies_per_portal: int = max_enemies_per_portal_number
var max_portals: int = 4

func _ready():
	randomize()
	if !Global.mute:
		$Audio.play_audio("res://Sounds/penance.wav", -15)
	portal_timer.wait_time = portal_rate

func _process(_delta):
#	Start first wave
	if portal_count == 0 and Global.wave == 1 and is_spawning:
		self.portal_count += 1
		spawn_portal()

# Random enemy quantity per portal
func generate_random_portal_stats() -> void:
	var random_number = rng.randi_range(min_enemies_per_portal_number, max_enemies_per_portal_number)
	max_enemies_per_portal = random_number

# Check if wave is finished (all portals have been spawned)
func is_wave_finished() -> bool:
	return portal_count == max_portals

# Set function for portal_count var
func set_portal_count(value: int) -> void:
	portal_count = value
#	Pause after each wave (manual trigger next wave)
	if is_wave_finished():
		is_spawning = false

# Check if it`s a item wave
func is_item_wave() -> bool:
#	Each 3 waves, and all portals have spawned, it's a item wave
	return Global.wave % 3 == 0 and is_wave_finished()

# Spawn a portal
func spawn_portal() -> void:
	var portal_position = Vector2(rand_range(30, 450), rand_range(30, 235))
	var portal_instance = portal.instance()
	portal_instance.max_enemies = max_enemies_per_portal
	portal_instance.spawn_rate = spawn_rate
	portal_instance.global_position = portal_position
	get_node('Portals').add_child(portal_instance)

# Increment wave status each wave (difficult)
func set_wave_stats() -> void:
	self.portal_count = 0
	if Global.wave % 3 == 0:
		portal_rate = max(portal_rate - 0.2, 0.5)
		max_enemies_per_portal_number += 1
		min_enemies_per_portal_number = min(min_enemies_per_portal_number + 1, max_enemies_per_portal_number)
	if Global.wave % 6 == 0:
		EnemyStats.add_all_enemies_stats('health', 1)
	if Global.wave % 10 == 0:
		EnemyStats.add_all_enemies_stats('damage', 1)
		max_portals += 2

# Start the next wave, chaging the wave stats
func start_next_wave() -> void:
#	Remove all portals from previous wave
	for portal_node in get_node("Portals").get_children():
		portal_node.destroy_portal()
	portal_timer.start(portal_rate)
	Global.wave_enemies_killed = 0
	Global.wave += 1
	set_wave_stats()
	spawn_portal()
	is_spawning = true

# After some time, spawn a portal or item wave
func _on_Timer_timeout():
	generate_random_portal_stats()
	if is_item_wave():
		$Items.spawn_all_items()
		portal_timer.paused = true
	elif is_spawning:
		spawn_portal()
		self.portal_count += 1

# Start next wave manually by entering the area
func _on_NextWave_body_entered(_body):
	if is_wave_finished():
		portal_timer.paused = false
		start_next_wave()
