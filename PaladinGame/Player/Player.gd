extends CharacterBody2D

# Movement
@export var speed: float = 150
@export var acceleration: float = 14
@export var friction: float = 20
@export var attack_friction: float = 8

# Resources
@export var stats: Stats

# Nodes
@onready var animation_tree: AnimationTree = $AnimationTree

var direction: Vector2 = Vector2.ZERO
var target: Vector2 = position

enum PlayerState {
	RUN,
	IDLE,
	ATTACK
}

var state: PlayerState = PlayerState.IDLE
var attack_pressed: bool = false

func _ready():
	animation_tree.active = true
	stats.reset()

func _process(delta):
	update_animation_parameters()
	
	if Input.is_action_pressed("left_click"):
		target = get_global_mouse_position()
		if not attack_pressed:
			state = PlayerState.RUN
	
	if Input.is_action_just_pressed("attack"):
		state = PlayerState.ATTACK
		attack_pressed = true

func _physics_process(_delta):
	match state:
		PlayerState.RUN:
			run_state()
		PlayerState.ATTACK:
			attack_state()
		PlayerState.IDLE:
			idle_state()

# Defines the running action
func run_state():
	# Calculate the direction towards the target
	direction = (target - position).normalized()
	
	# Calculate acceleration
	velocity = velocity.move_toward(direction * speed, acceleration)
	
	# Move the character
	move_and_slide()
	
	# Check if the target is reached
	if position.distance_to(target) < 10:
		state = PlayerState.IDLE


# Defines the attacking action
func attack_state():
	# Applying friction after attack so it doesn't stops abruptly
	velocity = velocity.move_toward(Vector2.ZERO, attack_friction)
	target = position
	move_and_slide()

func idle_state():
	# Apply friction to slow down the character
	velocity = velocity.move_toward(Vector2.ZERO, friction)
	
	# Move the character
	move_and_slide()

	# Check if the character should start running again
	if velocity != Vector2.ZERO:
		state = PlayerState.RUN

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
	attack_pressed = false
