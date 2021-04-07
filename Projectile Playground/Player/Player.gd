extends KinematicBody2D

onready var shooter = $Shooter
onready var sprite = $Sprite
onready var animation_tree = $AnimationTree
onready var animation_player = $AnimationTree
onready var animation_state = animation_tree.get('parameters/playback')

var velocity = Vector2.ZERO
var speed = 200

func _ready():
	animation_tree.active = true
	animation_state.travel("Idle")

func _process(delta):
	move()
	if Input.is_action_pressed("action"):
		var direction = (get_global_mouse_position() - global_position).normalized()
		var y_direction = sign(get_global_mouse_position().y - global_position.y)
		shooter.rotation = get_angle_to(get_global_mouse_position())
		animation_tree.set("parameters/Idle/blend_position", direction)
		# Hide projectile below if player is aiming up
		if y_direction < 0:
			sprite.z_index = 1
		else:
			sprite.z_index = 0

func move():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	input_vector.y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide(velocity)
