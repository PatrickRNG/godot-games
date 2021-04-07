extends Node2D

onready var timer = $Timer
onready var sprite = $Sprite

var direction = Vector2.ZERO
var speed = 300
var fire_rate = ControlManager.properties.fire_rate
var fire_range = ControlManager.properties.fire_range
var projectile_scale = ControlManager.properties.scale

func _ready():
	sprite.set_scale(Vector2(projectile_scale, projectile_scale))
	if ControlManager.properties.rainbow:
		sprite.set_modulate(Color(randf(), randf(), randf()))
	else:
		sprite.set_modulate(ControlManager.properties.color)

func _process(delta):
	position += direction * speed * delta

func remove_projectile(time):
	yield(get_tree().create_timer(time), "timeout")
	queue_free()

