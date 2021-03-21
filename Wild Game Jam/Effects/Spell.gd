extends Node

onready var animation_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer

func _ready():
	animation_player.play("start_spell")
	audio_player.play()

func _on_ExpireSpell_timeout():
	animation_player.play("end_spell")
	yield(animation_player, "animation_finished")
	queue_free()
