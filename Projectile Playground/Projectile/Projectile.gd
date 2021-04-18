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
		set_custom_projectile()
		sprite.visible = false
	else:
		sprite.visible = true

func set_custom_projectile():
	if custom_projectile:
		var projectile_instance = custom_projectile.duplicate()
		if ControlManager.properties.rainbow:
			projectile_instance.set_modulate(Color(randf(), randf(), randf()))
		projectile_instance.add_to_group("projectile")
		projectile_instance.position = Vector2(-32 * projectile_scale, -32 * projectile_scale)
		projectile_instance.set_scale(Vector2(projectile_scale, projectile_scale))
		add_child(projectile_instance)

func _process(delta):
	position += direction * speed * delta

func remove_projectile(time):
	yield(get_tree().create_timer(time), "timeout")
	queue_free()
