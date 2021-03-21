extends StaticBody2D

onready var poisonCloud = preload("res://Effects/PoisonCloud.tscn")

var is_in_range: bool = false
var target
var poisonCloud_instance

func _on_Area2D_body_entered(body):
	$Timer.start()
	is_in_range = true
	target = body
	poisonCloud_instance = poisonCloud.instance()
	poisonCloud_instance.position += Vector2(0, -10)
	target.add_child(poisonCloud_instance)

func _on_Area2D_body_exited(body):
	$Timer.stop()
	is_in_range = false
	target = body
	target.remove_child(poisonCloud_instance)

func _on_Timer_timeout():
	if target and target.health:
		target.health.current -= 3
