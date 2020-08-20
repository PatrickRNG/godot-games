extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var audioStream = $AudioStreamPlayer
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	randomize()
#	[object that have signal].connect("signal_name", object_that_have_function, "function")
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
   
	# Player moving
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	# Player not moving
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
   
	move()
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL 
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	move_and_slide(velocity)

func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finish():
	state = MOVE

func play_attack_audio():
	var stream = load("res://Music and Sounds/Swipe.wav")
	audioStream.set_stream(stream)
	audioStream.volume_db = -15
	audioStream.pitch_scale = 1
	audioStream.play()

func play_hurt_audio():
	var stream = load("res://Music and Sounds/Hurt.wav")
	audioStream.set_stream(stream)
	audioStream.volume_db = -15
	audioStream.pitch_scale = 1
	audioStream.play()

func _on_Hurtbox_area_entered(area):
	if not hurtbox.invincible:
		stats.health -= area.damage
		hurtbox.start_invincibility(0.5)
		hurtbox.create_hit_effect(area)
		play_hurt_audio()

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

