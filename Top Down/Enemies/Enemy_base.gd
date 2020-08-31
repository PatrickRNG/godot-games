extends KinematicBody2D

enum {
	REST,
	CHASE
}

export(int) var health = 5
export(int) var SPEED = 60
export(int) var ACCELERATION = 300
export(int) var damage = 1

onready var hurtbox = $Hurtbox
onready var animation_tree = $AnimationTree
onready var soft_collision = $SoftCollision
onready var animation_mode = animation_tree.get("parameters/playback")
onready var current_color = modulate

var velocity = Vector2.ZERO
var is_player_in_range = false

func _ready():
	animation_tree.active = true

func _process(delta):
	if health <= 0:
		queue_free()
		Global.enemies_killed += 1
		Global.wave_enemies_killed += 1

func basic_movement_towards_player(delta) -> void:
	if Global.player != null:
		var direction = global_position.direction_to(Global.player.global_position)
#		Prevent overlapping
		if soft_collision.is_colliding():
			velocity += soft_collision.get_push_vector() * 10
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		velocity = move_and_slide(velocity)
		animation_tree.set('parameters/Walk/blend_position', velocity.normalized())
		animation_mode.travel("Walk")
	else:
		animation_mode.travel("Idle")

func basic_ranged_movement(delta) -> void:
	if Global.player != null and !is_player_in_range:
		var direction = global_position.direction_to(Global.player.global_position)
#		Prevent overlapping
		if soft_collision.is_colliding():
			velocity += soft_collision.get_push_vector() * 10
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		velocity = move_and_slide(velocity)
		animation_tree.set('parameters/Walk/blend_position', velocity.normalized())
		animation_mode.travel("Walk")
	elif is_player_in_range:
		animation_mode.travel("Attack")
	else:
		animation_mode.travel("Idle")

func ranged_attack(projectile, target, turn_axis, bullet_point) -> void:
	var distance = global_position.distance_to(target.global_position)
	projectile.position = bullet_point.global_position
	projectile.rotation = get_angle_to(target.global_position)
	turn_axis.rotation = distance
	bullet_point.position = Vector2(5, 0)
	get_tree().get_root().add_child(projectile)

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("bullet"):
		var bullet = area.get_parent()
#		Times the bullet has collided with an enemy
		bullet.enemy_hit_count += 1
#		Delete only after the correct amount of enemy hits
		if bullet.enemy_hit_count >= PlayerStats.pierce:
			bullet.queue_free()
		health -= PlayerStats.damage
		$Audio.play_audio("res://Sounds/Enemies/damage.wav", -10)
		hurtbox.start_invincibility(0.2)
		modulate = Color(100, 100, 100)
		yield(get_tree().create_timer(0.1), "timeout")
		modulate = current_color
