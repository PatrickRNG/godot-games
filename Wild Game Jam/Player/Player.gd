extends KinematicBody2D

enum {
	MOVE,
	SHIP,
	ATTACK,
}

onready var animationTree = $AnimationTree
onready var camera = $Camera2D
onready var health = $Health
onready var o2Timer = $O2Timer
onready var item_holder = $ItemHolder
onready var animationState = animationTree.get("parameters/playback")
onready var ship_part_node = preload("res://World/Props/ShipPart.tscn")

var state = MOVE
var velocity = Vector2.ZERO
var speed = 125
var is_in_ship = false
var regenerating_o2 = false
var is_holding = false
var default_o2_value = 1
var default_o2_wait_time = 1
var o2_value = default_o2_value
var o2_wait_time = default_o2_wait_time
var current_holding_item_type

func _ready():
	manage_camera()
	animationTree.active = true
	o2Timer.wait_time = o2_wait_time

func _physics_process(_delta):
	if is_in_ship:
		state = SHIP
	else:
		state = MOVE

	match state:
		MOVE:
			move_state()
			visible = true
		SHIP:
			visible = false

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

func setup_o2_meter(regenerate: bool = false, value: int = default_o2_value, wait_time: float = default_o2_wait_time):
	o2_value = value
	o2_wait_time = wait_time
	regenerating_o2 = regenerate

func attach_item(partType: int):
	if item_holder.get_children().size() < 1:
		var item_instance = ship_part_node.instance()
		item_instance.type = partType
		item_holder.add_child(item_instance)
		current_holding_item_type = partType

func detach_item():
	is_holding = false
	if item_holder.get_children().size() > 0:
		item_holder.get_children()[0].queue_free()
		current_holding_item_type = null

func _on_O2Timer_timeout():
	if regenerating_o2:
		health.current += o2_value
		o2Timer.wait_time = o2_wait_time
	else:
		health.current -= o2_value
		o2Timer.wait_time = o2_wait_time
