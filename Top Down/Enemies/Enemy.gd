extends KinematicBody2D

enum {
	REST,
	CHASE
}

export(int) var hp = 3
export(int) var SPEED = 4200

onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite
onready var animation_tree = $AnimationTree
onready var animation_mode = animation_tree.get("parameters/playback")
onready var current_color = modulate

var velocity = Vector2.ZERO

func _ready():
	animation_tree.active = true

func _process(delta):
	basic_movement_towards_player(delta)
	if hp <= 0:
		queue_free()
		Global.enemies_killed += 1
		Global.wave_enemies_killed += 1

func basic_movement_towards_player(delta):
	if Global.player != null:
		var direction = global_position.direction_to(Global.player.global_position)
#		animation_tree.set('parameters/Walk/blend_position', direction)
		velocity = direction * SPEED
		velocity = move_and_slide(velocity * delta)
		animation_tree.set('parameters/Walk/blend_position', velocity.normalized())
		animation_mode.travel("Walk")
	else:
		animation_mode.travel("Idle")

func createExplosionImpact(target):
	var explosion = preload("res://Player/Explosion.tscn")
	var explosion_instance = explosion.instance()
	explosion_instance.position = target.global_position
	get_tree().get_root().add_child(explosion_instance)

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("bullet"):
		area.get_parent().queue_free()
		hp -= 1
		createExplosionImpact(area)
		hurtbox.start_invincibility(0.2)
		modulate = Color(100, 100, 100)
		yield(get_tree().create_timer(0.1), "timeout")
		modulate = current_color
