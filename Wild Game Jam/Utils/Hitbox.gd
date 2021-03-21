extends Area2D

export(int) var damage: int = 10
export(bool) var damage_over_time: bool = false
var is_in_area: bool = false
var target: Node = null

onready var timer = $Timer

func _ready():
	if !damage_over_time:
		timer.stop()

func damage_target():
	if target and target.health:
		target.health.current -= damage

func _on_Hitbox_area_entered(area):
	is_in_area = true
	target = area.get_parent()
	if !damage_over_time:
		damage_target()

func _on_Hitbox_area_exited(area):
	is_in_area = false
	target = null

func _on_Timer_timeout():
	if is_in_area:
		damage_target()
