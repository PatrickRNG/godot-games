extends KinematicBody2D

var role = "friendly"
var dead = false

const pain1 = preload("res://audio/pain1.wav")
const pain2 = preload("res://audio/pain2.wav")

const step1 = preload("res://audio/footstep1.wav")
const step2 = preload("res://audio/footstep2.wav")
const step3 = preload("res://audio/footstep3.wav")

const muzzle_flash = preload("res://graphics/MuzzleFlash.tscn")
const footstep = preload("res://graphics/FootStep.tscn")
const blood = preload("res://graphics/Blood.tscn")
const STEP_RATE = 30
var cur_step_dist = 0

const MOVE_SPEED = 120
const RELOAD_TIME = 1.0
var time_spent_reloading = 0
var reloading = false
var facing_right = false
var gun_facing_right = false

var health = 100
var food = 0
var hunger = 0
var ammo = 50

onready var gun = $Gun
onready var raycast = $Gun/RayCast2D

var starved = false

func _ready():
	update_stats()
	add_to_group("eats")
	raycast.add_exception(self)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("need_player_ref", "set_player", self)

func increase_hunger():
	hunger += 1
	update_stats()
	if hunger > 4:
		starved = true
		#die()

func feed():
	if food <= 0:
		return
	
	var areas = $FeedArea.get_overlapping_areas()
	for a in areas:
		if a.has_method("feed"):
			if a.feed():
				food -= 1
				$EatPlayer.play()
				return
	"""
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.has_method("feed") and global_position.distance_to(raycast.get_collision_point()) < 40:
			if coll.feed():
				food -= 1
				
	"""

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if dead and Input.is_action_just_pressed("restart"):
		get_tree().call_group("delete_on_restart", "queue_free")
		get_tree().reload_current_scene()
	if dead:
		return
	
	if Input.is_action_just_pressed("feed"):
		feed()
		update_stats()
	if Input.is_action_just_pressed("feed_self"):
		if food > 0 and hunger > 0:
			hunger -= 1
			food -= 1
			update_stats()
			$EatPlayer.play()
	
	
	if !reloading:
		gun.look_at(get_global_mouse_position())
	if reloading:
		time_spent_reloading += delta
		if time_spent_reloading >= RELOAD_TIME:
			reloading = false
			time_spent_reloading = 0
	if Input.is_action_just_pressed("shoot") and !reloading:
		shoot()
	
	if !reloading:
		gun.scale.x = 1
		var r = gun.global_rotation_degrees
		if (r > 90 or r < -90) and facing_right:
			flip()
		if (r < 90 and r > -90) and !facing_right:
			flip()
	if reloading:
		gun.rotation = 0
		if facing_right:
			gun.scale.x = 1
		else:
			gun.scale.x = -1


func _physics_process(delta):
	if dead:
		return
	var move_vec = Vector2()
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	
	move_and_slide(move_vec * MOVE_SPEED, Vector2())
	
	if move_vec != Vector2():
		cur_step_dist += MOVE_SPEED * delta
		if cur_step_dist > STEP_RATE:
			cur_step_dist -= STEP_RATE
			step()


func flip():
	$Graphics.scale.x *= -1
	facing_right = !facing_right
	$Gun/Graphics.scale.y *= -1


func shoot():
	if ammo <= 0:
		return
	ammo -= 1
	update_stats()
	reloading = true
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.has_method("kill"):
			coll.kill()
	$AnimationPlayer.play("reload")
	var flash = muzzle_flash.instance()
	flash.global_position = $Gun/FirePoint.global_position
	flash.global_rotation = raycast.global_rotation
	get_tree().get_root().add_child(flash)
	flash.emitting = true
	get_tree().call_group("handles_gunshots", "gunshot", global_position)
	$GunShotPlayer.play()
	$ReloadPlayer.play()

var left_step = true
func step():
	left_step = !left_step
	var f = footstep.instance()
	f.add_to_group("delete_on_restart")
	get_tree().get_root().add_child(f)
	get_tree().get_root().move_child(f, 0)
	var step_spot = $RStep.global_position
	if left_step:
		step_spot = $LStep.global_position
	f.global_position = step_spot
	var steps = [step1, step2, step3]
	var cur_step = randi() % 3
	$StepPlayer.stream = steps[cur_step]
	$StepPlayer.play()

func kill():
	health -= 10
	if !dead and !$PainPlayer.playing:
		var ind = randi() % 2
		var p = [pain1, pain2]
		$PainPlayer.stream = p[ind]
		$PainPlayer.play()
	if health <= 0:
		starved = false
		die()

	update_stats()

func die():
	health = 0
	dead = true
	var b = blood.instance()
	b.add_to_group("delete_on_restart")
	get_tree().get_root().add_child(b)
	get_tree().get_root().move_child(b, 0)
	b.global_position = global_position
	$Graphics.global_rotation_degrees = 90
	if starved:
		$CanvasLayer/DeathMessage/Label.text = "You starved to death, press R to restart"
	else:
		$CanvasLayer/DeathMessage/Label.text = "You were mauled by wolves, press R to restart"
	$CanvasLayer/DeathMessage.show()

func update_stats():
	var label = $CanvasLayer/Label
	label.text = ""
	label.text += "health: " + str(health) + "\n"
	label.text += "hunger: " + str(hunger) + "\n"
	label.text += "food: " + str(food) + "\n"
	label.text += "ammo: " + str(ammo) + "\n"
	label.text += "days: " + str(get_parent().cur_day) + "\n"
