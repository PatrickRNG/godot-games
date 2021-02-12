extends KinematicBody2D

var velocity = Vector2.ZERO

export(int) var speed = 80
export(int) var wood = 0


func _ready():
	var campfire_health_node = get_node("../Campfire/Health")
	campfire_health_node.connect("depleted", self, "handle_player_die")
	
func _physics_process(delta):
	move_state(delta)
	
func move_state(_delta) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Player moving
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO
	velocity = move_and_slide(velocity)

func handle_player_die():
	queue_free()
