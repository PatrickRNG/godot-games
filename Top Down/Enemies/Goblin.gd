extends "res://Enemies/Enemy_base.gd"

var stats = EnemyStats.enemies_stats["goblin"]

func _ready():
	health = stats.health
	damage = stats.damage
	animation_tree.active = true

func _process(delta):
	basic_movement_towards_player(delta)
