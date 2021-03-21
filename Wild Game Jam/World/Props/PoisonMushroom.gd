extends StaticBody2D

onready var poison_cloud = preload("res://Effects/PoisonCloud.tscn")
onready var audio_player = $AudioStreamPlayer

var is_in_range: bool = false
var target
var poison_cloud_instance

func _on_Area2D_body_entered(body):
	$Timer.start()
	is_in_range = true
	target = body
	poison_cloud_instance = poison_cloud.instance()
	poison_cloud_instance.position += Vector2(0, -10)
	target.add_child(poison_cloud_instance)
	audio_player.play()

func _on_Area2D_body_exited(body):
	$Timer.stop()
	is_in_range = false
	target = body
	target.remove_child(poison_cloud_instance)
	audio_player.playing = false

func _on_Timer_timeout():
	if target and target.health:
		target.health.current -= 3
