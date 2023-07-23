extends CharacterBody2D

# Movement
@export var speed: float = 120
@export var acceleration: float = 14
@export var friction: float = 15
@export var attack_friction: float = 8

# Resources
@export var stats: Stats
@export var spells: Spells

# Nodes
@onready var animation_tree: AnimationTree = $AnimationTree

var direction: Vector2 = Vector2.ZERO
var target: Vector2 = position

enum PlayerState {
	RUN,
	IDLE,
	ATTACK,
	CAST_SPELL
}

var state: PlayerState = PlayerState.IDLE
var attack_pressed: bool = false
var spell_index: int

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
	
	if Input.is_action_just_pressed("cast_spell_1"):
		state = PlayerState.CAST_SPELL
		spell_index = 0
	if Input.is_action_just_pressed("cast_spell_2"):
		state = PlayerState.CAST_SPELL
		spell_index = 1
	if Input.is_action_just_pressed("cast_spell_3"):
		state = PlayerState.CAST_SPELL
		spell_index = 2

func _physics_process(_delta):
	match state:
		PlayerState.RUN:
			run_state()
		PlayerState.ATTACK:
			attack_state()
		PlayerState.IDLE:
			idle_state()
		PlayerState.CAST_SPELL:
			cast_spell_state()

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

# Decide which spell, based on key_pressed - ok
# Call cast_spell from that specific spell - the cast_spell fn is flexible
# cast_spell fn instantiates the spell node
# The instantiated spell node has to have properties such as damage
func cast_spell_state():
#	var spell_index = 0
	var spell = spells.get_spell(spell_index)

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
