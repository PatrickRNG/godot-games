extends KinematicBody2D

var can_cast: bool = true
export(int) var speed = 45
export(int) var acceleration = 30
export(int) var cast_rate = 5
onready var health = $Health
var velocity = Vector2.ZERO

onready var animation_tree = $AnimationTree
onready var animation_player = $AnimationPlayer
onready var animation_mode = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true

func cast_spell(spell: Resource, target: Node, fire_rate: float = 5, hit_damage: bool = true, sorted: bool = false):
	var spell_instance = spell.instance()
	spell_instance.position = target.position
	if sorted:
		get_tree().get_root().get_node("World/Props/YSort").add_child(spell_instance)
	else:
		get_tree().get_root().get_node("World/Props/Props").add_child(spell_instance)
	if hit_damage:
		target.health.current -= spell_instance.damage
	can_cast = false
	yield(get_tree().create_timer(fire_rate), "timeout")
	can_cast = true

func basic_ranged_movement(target, should_move: bool = true) -> void:
	if target != null and should_move:
		var direction = global_position.direction_to(target.global_position)
		velocity = velocity.move_toward(direction * speed, acceleration)
		velocity = move_and_slide(velocity)
		animation_tree.set("parameters/Walk/BlendSpace2D/blend_position", velocity.normalized())
		animation_tree.set("parameters/Idle/blend_position", velocity.normalized())
		animation_mode.travel("Walk")
	else:
		# Look at the target when inside the inner enemy range
		if target:
			var direction = global_position.direction_to(target.global_position)
			animation_tree.set("parameters/Idle/blend_position", direction.normalized())
		velocity = Vector2.ZERO
		animation_mode.travel("Idle")
		
func death():
	animation_player.play("Die")
	yield(animation_player, "animation_finished")
	queue_free()
