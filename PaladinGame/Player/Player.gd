extends CharacterBody2D

@export var speed: float = 150
@export var acceleration: float = 14
@export var friction: float = 20
@export var attack_friction: float = 8

@onready var animation_tree : AnimationTree = $AnimationTree

var direction : Vector2 = Vector2.ZERO

enum PlayerState {
	RUN,
	IDLE,
	ATTACK
}

var state: PlayerState = PlayerState.RUN

func _ready():
	animation_tree.active = true

func _process(_delta):
	update_animation_parameters()

func _physics_process(_delta):
	match state:
		PlayerState.RUN:
			run_state()
		PlayerState.ATTACK:
			attack_state()

# Defines the running action
func run_state():
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * speed, acceleration)
		#velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)
		#velocity = Vector2.ZERO
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = PlayerState.ATTACK

# Defines the attacking action
func attack_state():
	# Applying friction after attack so it doesn't stops abruptly
	velocity = velocity.move_toward(Vector2.ZERO, attack_friction)
	move_and_slide()

# Defines the animations state machine
func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	
	if Input.is_action_just_pressed("attack"):
		animation_tree["parameters/conditions/is_moving"] = false
		animation_tree["parameters/conditions/attack"] = true
	else:
		animation_tree["parameters/conditions/attack"] = false
	
	# Defines the direction of the animations
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Run/blend_position"] = direction
		animation_tree["parameters/Attack/blend_position"] = direction

# Triggered after attack animation is finished, so it can run again
func _finished_attack():
	state = PlayerState.RUN
