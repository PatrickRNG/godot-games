extends KinematicBody2D

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var bullet = preload("res://Player/Bullet.tscn")
var can_fire = true

onready var hurtbox = $Hurtbox
onready var turn_axis = $TurnAxis
onready var bullet_point = $TurnAxis/BulletPoint
onready var sprite = $Sprite
onready var current_color = modulate

export(int) var hp = 5

export var MAX_SPEED = 5200
export var BULLET_SPEED = 200
export var fire_rate = 0.4
export(int) var projectiles = 1

func _ready():
	Global.player = self

func _process(_delta):
	if Input.is_action_pressed("fire") and can_fire:
		fireProjectile()
	if hp <= 0:
		queue_free()

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Player moving
	if input_vector != Vector2.ZERO:
		velocity = input_vector * MAX_SPEED
	# Player not moving
	else:
		velocity = Vector2.ZERO
	
	move_and_slide(velocity * delta)

func fireProjectile():
	for i in range(projectiles):
		var bullet_instance = bullet.instance()
		var direction = sign(get_global_mouse_position().x - sprite.global_position.x)
		sprite.flip_h = direction < 0
		turn_axis.rotation = get_angle_to(get_global_mouse_position())
		bullet_instance.position = get_node("TurnAxis/BulletPoint" + String(i)).global_position
		bullet_instance.rotation = get_angle_to(get_global_mouse_position())
		bullet_instance.apply_impulse(Vector2(), Vector2(BULLET_SPEED, 0).rotated(bullet_instance.rotation))
		get_tree().get_root().add_child(bullet_instance)
	can_fire = false
#	Wait some time before able to fire, (receive timeout signal after completion)
	yield(get_tree().create_timer(fire_rate), "timeout")
	can_fire = true

func _on_Hurtbox_area_entered(_area):
	if !hurtbox.invincible:
		hp -= 1
		hurtbox.start_invincibility(0.5)
		modulate = Color(100, 100, 100)
		yield(get_tree().create_timer(0.1), "timeout")
		modulate = current_color
