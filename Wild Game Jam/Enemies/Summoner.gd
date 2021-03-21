extends "res://Enemies/Enemy.gd"

onready var tentacleSpell = preload("res://Effects/PurpleTentacles.tscn")

var is_in_stop_area: bool = false
var is_in_follow_area: bool = false
var target: Node = null

func _process(delta):
	basic_ranged_movement(target, !is_in_stop_area and is_in_follow_area)
	if target and can_cast:
		cast_spell(tentacleSpell, target, 5, false, true)

func _on_DetectArea_body_entered(body):
	is_in_stop_area = true

func _on_DetectArea_body_exited(body):
	is_in_stop_area = false

func _on_FollowArea_body_entered(body):
	target = body
	is_in_follow_area = true

func _on_FollowArea_body_exited(body):
	target = null
	is_in_follow_area = false

func _on_Health_depleted():
	death()

func _on_Hurtbox_is_hit():
	$Hurtbox.hit_effect(self, Color(1, 0.5, 1))
	
