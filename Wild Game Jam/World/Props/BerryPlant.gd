extends StaticBody2D

var is_eaten: bool = false
var target

onready var animationPlayer = $AnimationPlayer
onready var uiControl = $Control

func _ready():
	uiControl.visible = false

func _process(delta):
	if target and target.health and Input.is_action_just_pressed("action_2") and !is_eaten:
		target.health.current += 15
		is_eaten = true

func _on_Area2D_body_entered(body):
	target = body
	if !is_eaten:
		uiControl.visible = true
		animationPlayer.play("GrowText")
		yield(animationPlayer, "animation_finished")
		animationPlayer.play("BlinkText")

func _on_Area2D_body_exited(body):
	uiControl.visible = false
	target = null
