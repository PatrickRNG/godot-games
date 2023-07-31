extends CharacterBody2D

# Movement
@export var speed: float = 120
@export var acceleration: float = 14
@export var friction: float = 15
@export var attack_friction: float = 8

# Resources
@export var stats: Stats

# Nodes
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var spellsManager: SpellManager = $SpellManager

var direction: Vector2 = Vector2.ZERO
var target: Vector2 = position

enum Player_State {
	RUN,
	IDLE,
	ATTACK
}

var state: Player_State = Player_State.IDLE
var attack_pressed: bool = false
var spell_index: int

func _ready():
	animation_tree.active = true
	stats.reset()

func _process(delta):
	update_animation_parameters()
	
	if Input.is_action_pressed("left_click"):
		target = get_global_mouse_position()
		if not attack_pressed and target.distance_to(position) > 10:
			state = Player_State.RUN

	if Input.is_action_just_pressed("attack"):
		state = Player_State.ATTACK
		attack_pressed = true
	
	if Input.is_action_just_pressed("cast_spell_1"):
		spell_index = 0
		cast_spell_state()
	if Input.is_action_just_pressed("cast_spell_2"):
		state = Player_State.ATTACK
		spell_index = 1
	if Input.is_action_just_pressed("cast_spell_3"):
		state = Player_State.ATTACK
		spell_index = 2

func _physics_process(_delta):
	match state:
		Player_State.RUN:
			run_state()
		Player_State.ATTACK:
			attack_state()
		Player_State.IDLE:
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
		state = Player_State.IDLE

# Defines the attacking ac	tion
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

func cast_spell_state():
	var spell: Spell = spellsManager.get_spell(spell_index)
	
	if not spellsManager.is_spell_on_cooldown(spell.name):
		spellsManager.cast_spell(spell_index)
		attack_pressed = true
		state = Player_State.ATTACK
		
	velocity = velocity.move_toward(Vector2.ZERO, attack_friction)
	target = position
	move_and_slide()


# Defines the animations state machine
func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	
	if attack_pressed:
		animation_tree["parameters/conditions/is_moving"] = false
		animation_tree["parameters/conditions/attack"] = true
	else:
		animation_tree["parameters/conditions/attack"] = false
	
	# Defines the direction of the animations
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Run/blend_position"] = direction
		animation_tree["parameters/Attack/blend_position"] = direction
		animation_tree["parameters/CastSpell/blend_position"] = direction

# Triggered after attack/cast animation is finished, so it can run again
func _finished_attack():
	state = Player_State.RUN
	attack_pressed = false
