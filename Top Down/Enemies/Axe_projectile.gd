extends RigidBody2D

onready var animation_player = $AnimationPlayer
var projectile_speed = 200
var damage
var fire_rate = 0.6
var projectile_range = 0.7

func _ready():
	animation_player.play("Idle")

func _physics_process(delta):
	position += Vector2(projectile_speed, 0).rotated(rotation) * delta
	yield(get_tree().create_timer(projectile_range), "timeout")
	queue_free()

# Delete projectile when offscreen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
