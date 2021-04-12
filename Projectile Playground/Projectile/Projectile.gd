extends Node2D

onready var timer = $Timer
onready var sprite = $Sprite

var direction = Vector2.ZERO
var speed = 300
var fire_rate = ControlManager.properties.fire_rate
var fire_range = ControlManager.properties.fire_range
var projectile_scale = ControlManager.properties.scale
var custom_projectile = ControlManager.properties.custom_projectile
var is_custom = false

func _ready():
	sprite.set_scale(Vector2(projectile_scale, projectile_scale))
	if ControlManager.properties.rainbow:
		sprite.set_modulate(Color(randf(), randf(), randf()))
	else:
		sprite.set_modulate(ControlManager.properties.color)
	if ControlManager.properties.use_custom_projectile and custom_projectile:
		var custom_projectile_node = custom_projectile.duplicate()
		sprite.visible = false
		custom_projectile_node.scale = Vector2(0.5, 0.5)
		if ControlManager.properties.rainbow:
			custom_projectile_node.set_modulate(Color(randf(), randf(), randf()))
		custom_projectile_node.global_position = Vector2(0, -64)
		add_child(custom_projectile_node)
	else:
		sprite.visible = true

func _process(delta):
	position += direction * speed * delta

func remove_projectile(time):
	yield(get_tree().create_timer(time), "timeout")
	queue_free()
