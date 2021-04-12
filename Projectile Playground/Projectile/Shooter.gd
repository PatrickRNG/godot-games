extends Position2D

onready var projectile = preload("res://Projectile/Projectile.tscn")
onready var shooter_point = $Shooter_Point

var can_fire = true
var fire_rate = ControlManager.properties.fire_rate
var fire_range = ControlManager.properties.fire_range
var shots = ControlManager.properties.shots
var shot_angle = ControlManager.properties.shot_angle

func _process(_delta):
	if Input.is_action_pressed("action"):
		shoot()

# Update some properties for when the controls change
func update_properties():
	fire_rate = ControlManager.properties.fire_rate
	fire_range = ControlManager.properties.fire_range
	shots = ControlManager.properties.shots
	shot_angle = ControlManager.properties.shot_angle

func create_angle_spread(projectiles_quantity: int, angle_multiplier: int) -> Array:
	var projectiles_angles = [0]
	for i in range(1, projectiles_quantity * 2):
		var num = (float(i) / 10) * angle_multiplier
		projectiles_angles.append(num)
		projectiles_angles.append(num * -1)
	return projectiles_angles

func shoot() -> void:
	update_properties()
	if can_fire:
		for i in range(shots):
			var aim_direction = global_position.direction_to(get_global_mouse_position())
			var projectiles_angles = create_angle_spread(shots, shot_angle)
			var projectile_instance = projectile.instance()
			projectile_instance.position = shooter_point.global_position
			projectile_instance.direction = aim_direction.rotated(projectiles_angles[i])
			projectile_instance.look_at(get_global_mouse_position())
			get_tree().get_root().add_child(projectile_instance)
			projectile_instance.remove_projectile(fire_range)
		shooter_point.position = Vector2(20, 0)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
