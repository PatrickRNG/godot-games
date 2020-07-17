extends Area2D

const MAX_REST_TIME = 8
const MAX_FLEE_TIME = 5
const PLAYER_HUNT_TIME = 10
const RAVENOUS_HUNGER = 4
onready var game_trail = get_parent().get_node("GameTrail")
var cur_trail_node = 3
var wolves = []
var state = "travel"
var trail_target = Vector2()
var cur_rest_time = 0
var cur_flee_time = 0
var cur_player_hunt_time = 0
var threat_point = Vector2()
var hunger = 0
var cur_prey = null
var cur_food = null
var player = null
var wolf_count = 0

func set_player(p):
	player = p

func _ready():
	add_to_group("eats")
	add_to_group("handles_gunshots")
	add_to_group("need_player_ref")
	yield(get_tree(), "idle_frame")
	wolves = get_tree().get_nodes_in_group("wolves")
	wolf_count = wolves.size()
	get_next_trail_target()
	#connect("body_entered", self, "check_threat")
	$AudioStreamPlayer2D.play()
	for d in wolves:
		var i = randi() % 8
		if i == 7:
			d.spawn_steps = true


func _process(delta):
	if state == "travel":
		state_travel()
	elif state == "hunt":
		state_hunt()
	elif state == "feed":
		state_feed(delta)
	elif state == "flee":
		state_flee(delta)
	elif state == "hunt_player":
		state_hunt_player(delta)
	#print(state)
	global_position = calc_center_point()
	"""
	global_position = calc_center_point()
	if state == 0 and cur_food == null:
		var f = check_for_food()
		if f != null:
			cur_food = weakref(f).get_ref()
	if state == 0 and cur_food != null and str(cur_food) != "[Deleted Object]":
		cur_prey = null
		for d in wolves:
			d.set_target(cur_food.global_position)
	
	if state == 0 and cur_prey == null and cur_food == null:
		cur_prey = find_nearest_prey()
	if state == 0 and cur_prey != null:
		for d in wolves:
			d.set_target(cur_prey.global_position)
	if state == 0 and cur_food != null and str(cur_food) != "[Deleted Object]" and calc_center_point().distance_to(cur_food.global_position) < 100:
		state = 1
		for d in wolves:
			d.set_target(d.global_position)
	elif state == 0 and calc_center_point().distance_to(trail_target) < 100 and cur_food == null and cur_prey == null:
		state = 1
	
	if state == 1:
		if cur_food == null and hunger > 0:
			cur_prey = find_nearest_prey()
			if cur_prey != null:
				state = 0
				cur_rest_time = 0
		cur_rest_time += delta
		if cur_rest_time > MAX_REST_TIME:
			if cur_food != null and str(cur_food) != "[Deleted Object]":
				
				cur_food.queue_free()
				cur_food = null
				hunger -= 1
				hunger = clamp(hunger, 0, 50)
			state = 0
			cur_rest_time = 0
			get_next_trail_target()
	if state == 2:
		cur_flee_time += delta
		if cur_flee_time > MAX_FLEE_TIME:
			cur_flee_time = 0
			state = 0
			var offset = trail_target - calc_center_point()
			for d in wolves:
				d.set_target(d.global_position + offset)
			if hunger <= get_threat_level():
				check_for_threats()
	"""


func state_travel():
	var threat_level = get_threat_level()
	if threat_level > hunger:
		state = "flee"
		cur_flee_time = 0
		return
	
	var f = check_for_food()
	if f != null:
		cur_food = weakref(f).get_ref()
	
	if cur_food != null:
		state = "feed"
		cur_rest_time = 0
		return
	
	var p = find_nearest_prey()
	if p != null:
		cur_prey = weakref(p).get_ref()
	if cur_prey != null:
		state = "hunt"
		return
	
	#follow trail
	if calc_center_point().distance_to(trail_target) < 100:
		get_next_trail_target()
	
	var offset = trail_target - calc_center_point()
	for w in wolves:
		w.set_target(w.global_position + offset)

func state_hunt():
	#if threat is spotted, compare with hunger levels
	var threat_level = get_threat_level()
	if threat_level > hunger:
		state = "flee"
		cur_flee_time = 0
		return
	
	var f = check_for_food()
	if f != null:
		cur_food = weakref(f).get_ref()
	if cur_food != null:
		state = "feed"
		cur_rest_time = 0
		return
	
	if cur_prey == null or str(cur_prey) == "[Deleted Object]":
		state = "travel"
		cur_prey = null
		return
	
	for w in wolves:
		w.set_target(cur_prey.global_position)

func state_feed(delta):
	cur_prey = null
	if cur_food == null or str(cur_food) == "[Deleted Object]":
		state = "travel"
		cur_food = null
		return
	
	#var offset = cur_food.global_position - global_position
	for w in wolves:
		w.set_target(cur_food.global_position)
	
	cur_rest_time += delta
	if cur_rest_time > MAX_REST_TIME:
		cur_rest_time = 0
		cur_food.queue_free()
		cur_food = null
		hunger -= 1
		if hunger < 0:
			hunger = 0

func state_flee(delta):
	cur_prey = null
	cur_food = null
	cur_flee_time += delta
	if cur_flee_time > MAX_FLEE_TIME:
		state = "travel"
		cur_flee_time = 0
		return
	
	var offset = (calc_center_point() - threat_point) * 20
	for w in wolves:
		w.set_target(w.global_position + offset)

func state_hunt_player(delta):
	cur_player_hunt_time += delta
	if cur_player_hunt_time > PLAYER_HUNT_TIME:
		threat_point = player.global_position
		state = "flee"
		cur_flee_time = 0
		cur_player_hunt_time = 0
		return
	for w in wolves:
		w.set_target(player.global_position)

func check_for_food():
	for body in get_overlapping_areas():
		if body.has_method("give_food"):
			return body
	return null

func check_threat(body):
	if body.name == "Player" or ("role" in body and body.role == "friendly"):
		if hunger <= get_threat_level():
			set_threat(body.global_position)

func check_for_threats():
	for body in get_overlapping_bodies():
		if body.name == "Player" or ("role" in body and body.role == "friendly"):
			set_threat(body.global_position)

func get_threat_level():
	var threat_level = 0
	for body in get_overlapping_bodies():
		if body.name == "Player" or ("role" in body and body.role == "friendly"):
			threat_level += 1
	return threat_level

func find_nearest_prey():
	var dist = 2000000
	var nearest = null
	for body in get_overlapping_bodies():
		var b = body
		if "role" in body and body.role == "prey":
			var d = global_position.distance_to(body.global_position)
			if d < dist:
				nearest = body
				dist = d
		if body.name == "Player" or ("role" in body and body.role == "friendly"):
			if hunger > get_threat_level():
				var d = global_position.distance_to(body.global_position)
				if d < dist:
					nearest = body
					dist = d
	return nearest

func gunshot(pos):
	
	if hunger < RAVENOUS_HUNGER:
		get_next_trail_target()
		state = "flee"
		cur_food = null
		cur_prey = null
		set_threat(pos)
	elif state != "flee" and state != "hunt_player" and wolf_count > get_wolf_count(): # wolf was shot
		cur_prey = player
		state = "hunt_player"
		cur_player_hunt_time = 0
		
	wolf_count = get_wolf_count()

func get_wolf_count():
	var count = 0
	for w in wolves:
		if !w.dead:
			count += 1
	return count

func set_threat(pos):
	cur_flee_time = 0
	threat_point = pos
	#state = 2
	var offset = (calc_center_point() - threat_point) * 20
	#for d in wolves:
	#	d.set_target(d.global_position + offset)

func set_to_rest():
	for d in wolves:
		d.set_target(d.global_position)

func get_next_trail_target():
	cur_trail_node += 1
	cur_trail_node %= game_trail.get_child_count()
	trail_target = game_trail.get_child(cur_trail_node).global_position
	var offset = trail_target - calc_center_point()
	for d in wolves:
		d.set_target(d.global_position + offset)

func calc_center_point():
	var avg_pos = Vector2()
	for d in wolves:
		avg_pos += d.global_position
	return avg_pos / wolves.size()