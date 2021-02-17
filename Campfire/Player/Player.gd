extends KinematicBody2D

enum {
	MOVE,
	ATTACK
}

var velocity = Vector2.ZERO
var can_cut_tree: bool = false
var current_active_tree
var facing_left = false
var is_attacking = false
var state = MOVE

export(int) var speed = 80
export(int) var wood = 0

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	var campfire_health_node = get_node("../Campfire/Health")
	campfire_health_node.connect("depleted", self, "handle_player_die")

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
	
func move_state(_delta) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Player moving
	if input_vector != Vector2.ZERO :
		animationState.travel("Walk")
		velocity = input_vector * speed
		
		if input_vector.x < 0 and !facing_left:
			flip()
		elif input_vector.x > 0 and facing_left:
			flip()
			
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO

	move_and_slide(velocity)
	
	if Input.is_action_just_pressed("ui_action"):
		state = ATTACK

func flip():
	scale.x *= -1
	facing_left = !facing_left

func finished_attack():
	state = MOVE

func handle_player_die():
	queue_free()

# Triggered after entering/leaving tree radius
func toggle_cut_tree(can_cut, tree) -> void:
	can_cut_tree = can_cut
	current_active_tree = tree

func attack_state():
	is_attacking = true
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	if can_cut_tree and current_active_tree.cutted == false:
		cut_tree()

func cut_tree():
	current_active_tree.cutted = true
	print_debug("action clicked ", current_active_tree)
