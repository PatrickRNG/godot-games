extends KinematicBody2D

enum {
	MOVE,
	SHIP,
	ATTACK,
}

onready var animationTree = $AnimationTree
onready var camera = $Camera2D
onready var health = $Health
onready var oxygen = $Oxygen
onready var o2Timer = $O2Timer
onready var item_holder = $ItemHolder
onready var attack_sprite = $Attack
onready var attack_collider = $Attack/Hitbox/CollisionPolygon2D
onready var animationState = animationTree.get("parameters/playback")
onready var ship_part_node = preload("res://World/Props/ShipPart.tscn")
onready var game_over_screen = preload("res://UI/GameOverScreen.tscn")

var state = MOVE
var velocity = Vector2.ZERO
var speed = 135
var is_in_ship = false
var regenerating_o2 = false
var is_holding = false
var default_o2_value = 0.5
var default_o2_wait_time = 1
var o2_value = default_o2_value
var o2_wait_time = default_o2_wait_time
var current_holding_item_type
var can_attack: bool = true

func _ready():
	manage_camera()
	animationTree.active = true
	attack_collider.disabled = true
	attack_sprite.visible = false
	o2Timer.wait_time = o2_wait_time

func _physics_process(_delta):
	if is_in_ship:
		state = SHIP
	else:
		state = MOVE
		
	if state != SHIP and Input.get_action_strength("action"):
		attack_state()

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
		can_attack = false
		# To not attack when pickping up an item
		yield(get_tree().create_timer(0.5), "timeout")
		can_attack = true

func detach_item():
	is_holding = false
	if item_holder.get_children().size() > 0:
		item_holder.get_children()[0].queue_free()
		current_holding_item_type = null

func attack_state():
	if can_attack:
		attack_sprite.visible = true
		attack_sprite.frame = 0
		attack_sprite.play()
		attack_collider.disabled = false
		can_attack = false
		yield(get_tree().create_timer(0.6), "timeout")
		can_attack = true

func _on_O2Timer_timeout():
	if regenerating_o2:
		oxygen.current += o2_value
		o2Timer.wait_time = o2_wait_time
	else:
		oxygen.current -= o2_value
		o2Timer.wait_time = o2_wait_time

func _on_Attack_animation_finished():
	attack_collider.disabled = true

func _on_Hurtbox_is_hit():
	$Hurtbox.hit_effect(self, Color(0.5, 0.5, 0.5))

func _on_Health_depleted():
	WorldManager.game_over(self, true)

func _on_Oxygen_depleted():
	WorldManager.game_over(self, false)

