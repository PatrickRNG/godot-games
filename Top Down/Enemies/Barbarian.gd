extends "res://Enemies/Enemy_base.gd"

onready var turn_axis = $TurnAxis
onready var bullet_point = $TurnAxis/BulletPoint

var axe = preload("res://Enemies/Axe_projectile.tscn")
var stats =  EnemyStats.enemies_stats["barbarian"]
var can_fire = true

func _ready():
	health = stats.health
	animation_tree.active = true

func _process(delta):
	basic_ranged_movement(delta)

func _physics_process(delta):
	if is_player_in_range and can_fire:
		var axe_instance = axe.instance()
		axe_instance.damage = stats.damage
		ranged_attack(axe_instance, Global.player, turn_axis, bullet_point)
		can_fire = false
#		Wait some time before able to fire, (receive timeout signal after completion)
		yield(get_tree().create_timer(axe_instance.fire_rate), "timeout")
		can_fire = true

func _on_Detection_body_entered(body):
	is_player_in_range = true

func _on_Detection_body_exited(body):
	is_player_in_range = false
