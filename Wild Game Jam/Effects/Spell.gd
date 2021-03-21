extends Node

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("start_spell")

func _on_ExpireSpell_timeout():
	animationPlayer.play("end_spell")
	yield(animationPlayer, "animation_finished")
	queue_free()
