extends KinematicBody2D

const yelp1 = preload("res://audio/yelp1.wav")
const yelp2 = preload("res://audio/yelp2.wav")
const yelp3 = preload("res://audio/yelp3.wav")

export(String, "friendly", "prey", "predator") var role
var fear = 3 # runs away from player, runs away from player and dog, runs away from gunshots, will only attack
var hunger = 0

const ATTACK_RATE = 0.8
var attack_time = 0
const meat = preload("res://Meat.tscn")
const blood = preload("res://graphics/Blood.tscn")
const footstep = preload("res://graphics/FootStep.tscn")
const STEP_RATE = 30
var cur_step_dist = 0

var spawn_steps = false

export var move_speed = 100

const MAX_DIST =  15
const MIN_DIST = 10
var player = null
var target_pos = Vector2()

var facing_right = true
var dead = false

onready var anim_player = $AnimalGraphics/AnimationPlayer
onready var raycast = $RayCast2D

func _ready():
	add_to_group("need_player_ref")
	if role == "prey":
		add_to_group("deer")
	if role == "predator":
		add_to_group("wolves")
	if role == "friendly":
		spawn_steps = true


func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	
	if role == "friendly":
		target_pos = -(player.global_position - global_position).normalized() * 30  + player.global_position
	#elif role == "prey":
		#target_pos = calc_prey_travel_target()
	#elif role == "predator":
		#target_pos = calc_predator_travel_target()
	
	var move_vec = target_pos - global_position
	var dist = move_vec.length()
	move_vec = move_vec.normalized()
	
	#var speed = clamp((dist - MIN_DIST) / (MAX_DIST - MIN_DIST), 0, 1) * move_speed
	var speed = move_speed
	attack_time += delta
	if role == "predator" and attack_time > ATTACK_RATE:
		if raycast.is_colliding():
			var coll = raycast.get_collider()
			if coll.has_method("kill") and coll.role != role:
				attack_time = 0
				coll.kill()
	move_vec = obstacle_avoid(move_vec)
	
	if global_position.distance_to(target_pos) > 5:
		move_and_slide(move_vec * speed, Vector2())
	
	if dist > MIN_DIST + 5:
		play_anim("walk")
	else:
		play_anim("idle")
	
	if move_vec.x < 0 and facing_right:
		flip()
	if move_vec.x > 0 and !facing_right:
		flip()
	
	if move_vec != Vector2():
		cur_step_dist += speed * delta
		if cur_step_dist > STEP_RATE:
			cur_step_dist -= STEP_RATE
			step()


func set_target(t):
	target_pos = t

func calc_prey_travel_target():
	var bodies = $DetectionArea.get_overlapping_bodies()
	var dir = Vector2()
	#var enemy_positions = []
	for b in bodies:
		if "role" in b and b.role in ["predator", "friendly"]:
			#enemy_positions.append(b.global_position)
			dir += b.global_position - global_position
	
	return -dir

func calc_predator_travel_target():
	var bodies = $DetectionArea.get_overlapping_bodies()
	var dir = Vector2()
	var nearby_prey = []
	for b in bodies:
		if "role" in b:
			if b.role == "prey":
				nearby_prey.append(b)
			if b.role == "friendly":
				pass
				#fear check
			#enemy_positions.append(b.global_position)
	var min_dist = 200000000
	var closest = null
	for prey in nearby_prey:
		var d = prey.global_position.distance_squared_to(global_position)
		if d < min_dist:
			closest = prey
	
	if closest == null:
		return global_position
	return closest.global_position

func obstacle_avoid(move_vec):
	var new_move_vec = move_vec
	raycast.cast_to = move_vec * 15
	if raycast.is_colliding():
		var n = raycast.get_collision_normal()
		var dir1 = n.rotated(deg2rad(90))
		var dir2 = n.rotated(deg2rad(-90))
		new_move_vec = dir1
		if move_vec.dot(dir1) < move_vec.dot(dir2):
			new_move_vec = dir2
		#print(dir1, dir2, new_move_vec)
	return new_move_vec

func flip():
	$AnimalGraphics.scale.x *= -1
	facing_right = !facing_right

func set_player(p):
	player = p

func play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)

func kill():
	if dead:
		return
	dead = true
	$CollisionShape2D.disabled = true
	collision_layer = 2
	play_anim("death")
	var b = blood.instance()
	get_tree().get_root().add_child(b)
	get_tree().get_root().move_child(b, 0)
	b.global_position = global_position
	b.add_to_group("delete_on_restart")
	
	if role != "predator":
		var m = meat.instance()
		get_tree().get_root().add_child(m)
		m.global_position = global_position
		m.add_to_group("delete_on_restart")
	
	if has_node("Feedable"):
		get_node("Feedable").dead = true
	
	if role != "prey":
		var ind = randi() % 3
		var y = [yelp1, yelp2, yelp3]
		$AudioStreamPlayer2D.stream = y[ind]
		$AudioStreamPlayer2D.play()
	if role == "friendly":
		get_tree().call_group("tracks_dead", "add_dead", "Dog")



var left_step = false
func step():
	if !spawn_steps:
		return
	left_step = !left_step
	var steps = []
	for i in range(2):
		var f = footstep.instance()
		get_tree().get_root().add_child(f)
		get_tree().get_root().move_child(f, 0)
		steps.append(f)
		f.add_to_group("delete_on_restart")
	
	if left_step:
		steps[0].global_position = global_position + Vector2(5, 2)
		steps[1].global_position = global_position + Vector2(-5, -2)
	else:
		steps[0].global_position = global_position + Vector2(5, -2)
		steps[1].global_position = global_position + Vector2(-5, 2)

func feed():
	if has_node("Feedable"):
		return get_node("Feedable").feed()