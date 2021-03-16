extends KinematicBody2D

enum {
	MOVE,
	ATTACK
}

onready var animationTree = $AnimationTree
onready var camera = $Camera2D
onready var animationState = animationTree.get("parameters/playback")

var state = MOVE
var velocity = Vector2.ZERO
var speed = 125

func _ready():
	animationTree.active = true
	manage_camera()

func _physics_process(_delta):
	match state:
		MOVE:
			move_state()

func move_state():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Moving
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = input_vector * speed
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO

	move_and_slide(velocity)

func manage_camera():
	var pos_top_right = get_node("/root/World/Boundaries_Top_Right")
	var pos_bottom_left = get_node("/root/World/Boundaries_Bottom_Left")
	var boundaries_right = pos_top_right.position.x
	var boundaries_left = pos_bottom_left.position.x
	var boundaries_top = pos_top_right.position.y
	var boundaries_bottom = pos_bottom_left.position.y
	camera.limit_right = boundaries_right
	camera.limit_left = boundaries_left
	camera.limit_top = boundaries_top
	camera.limit_bottom = boundaries_bottom
