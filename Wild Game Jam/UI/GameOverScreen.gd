extends "res://UI/ScreenManager.gd"

onready var button_audio_player = $AudioStreamPlayer
onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("start")

func set_title(text: String):
	$PanelContainer/MarginContainer/Rows/TitleLabel.text = text

func _on_RestartButton_pressed():
	get_tree().change_scene("res://World/World.tscn")
	get_tree().paused = false

func _on_QuitButton_pressed():
	quit_game()

func _on_RestartButton_mouse_entered():
	play_sound(button_audio_player)

func _on_QuitButton_mouse_entered():
	play_sound(button_audio_player)
