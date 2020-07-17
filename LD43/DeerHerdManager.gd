extends Area2D

const MAX_REST_TIME = 3
const MAX_FLEE_TIME = 10

onready var game_trail = get_parent().get_node("GameTrail")
var cur_trail_node = 3
var deer = []
var state = "travel"
var trail_target = Vector2()
var cur_rest_time = 0
var cur_flee_time = 0
var threat_point = Vector2()

func _ready():
	add_to_group("handles_gunshots")
	yield(get_tree(), "idle_frame")
	deer = get_tree().get_nodes_in_group("deer")
	set_next_trail_target()
	for d in deer:
		var i = randi() % 8
		if i == 7:
			d.spawn_steps = true

func _process(delta):
	global_position = calc_center_point()
	
	if state == "travel":
		state_travel()
	elif state == "rest":
		state_rest(delta)
	elif state == "flee":
		state_flee(delta)
	"""
	if state == 0 and calc_center_point().distance_to(trail_target) < 100:
		state = 1
	if state == 1:
		cur_rest_time += delta
		if cur_rest_time > MAX_REST_TIME:
			state = 0
			cur_rest_time = 0
			get_next_trail_target()
	if state == 2:
		cur_flee_time += delta
		if cur_flee_time > MAX_FLEE_TIME:
			cur_flee_time = 0
			state = 0
			var offset = trail_target - calc_center_point()
			for d in deer:
				d.set_target(d.global_position + offset)
			check_for_threats()
	"""

func state_travel():
	if calc_center_point().distance_to(trail_target) < 100:
		set_next_trail_target()
		state = "rest"
		cur_rest_time = 0
		
	check_for_threats()
	
	var offset = trail_target - calc_center_point()
	for d in deer:
		d.set_target(d.global_position + offset)

func state_rest(delta):
	cur_rest_time += delta
	if cur_rest_time > MAX_REST_TIME:
		cur_rest_time = 0
		state = "travel"
	
	check_for_threats()
	
	for d in deer:
		d.set_target(d.global_position)

func state_flee(delta):
	var offset = (calc_center_point() - threat_point) * 20
	for d in deer:
		d.set_target(d.global_position + offset)
	
	cur_flee_time += delta
	if cur_flee_time > MAX_FLEE_TIME:
		cur_flee_time = 0
		cur_rest_time = 0
		state = "rest"
		set_next_trail_target()

func check_for_threats():
	for body in get_overlapping_bodies():
		if body.name == "Player" or ("role" in body and (body.role == "predator" or body.role == "friendly")):
			state = "flee"
			cur_flee_time = 0
			threat_point = body.global_position

func gunshot(pos):
	threat_point = pos
	cur_flee_time = 0
	state = "flee"
	

func set_threat(pos):
	cur_flee_time = 0
	threat_point = pos
	state = "flee"
	var offset = (calc_center_point() - threat_point) * 20
	for d in deer:
		d.set_target(d.global_position + offset)

func set_to_rest():
	for d in deer:
		d.set_target(d.global_position)

func set_next_trail_target():
	cur_trail_node += 1
	cur_trail_node %= game_trail.get_child_count()
	trail_target = game_trail.get_child(cur_trail_node).global_position
	

func calc_center_point():
	var avg_pos = Vector2()
	for d in deer:
		avg_pos += d.global_position
	return avg_pos / deer.size()