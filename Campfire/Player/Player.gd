extends KinematicBody2D

enum {
	MOVE,
	ATTACK
}

var velocity = Vector2.ZERO
var current_active_tree
var facing_left = false
var is_attacking = false
var can_attack = true
var state = MOVE

export(int) var speed = 80
export(int) var wood = 0

onready var camera = $Camera2D
onready var animationTree = $AnimationTree
onready var hitbox = $Hitbox/CollisionShape2D
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	hitbox.disabled = true
	var campfire_health_node = get_node("../Campfire/Health")
	campfire_health_node.connect("depleted", self, "handle_player_die")
	manage_camera()

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_action"):
		state = ATTACK
	
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			if can_attack:
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

func flip():
	scale.x *= -1
	facing_left = !facing_left

func finished_attack():
	state = MOVE
	hitbox.disabled = true

func handle_player_die():
	queue_free()

func attack_state():
	is_attacking = true
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	can_attack = false
	var attack_rate = 1
#	Wait some time before able to fire, (receive timeout signal after completion)
	yield(get_tree().create_timer(attack_rate), "timeout")
	can_attack = true

func manage_camera():
	var pos_top_right = get_node("/root/World/Spawn_boundaries_top_right")
	var pos_bottom_left = get_node("/root/World/Spawn_boundaries_bottom_left")
	var boundaries_right = pos_top_right.position.x
	var boundaries_left = pos_bottom_left.position.x
	var boundaries_top = pos_top_right.position.y
	var boundaries_bottom = pos_bottom_left.position.y
	camera.limit_right = boundaries_right
	camera.limit_left = boundaries_left
	camera.limit_top = boundaries_top
	camera.limit_bottom = boundaries_bottom
