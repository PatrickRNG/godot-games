extends "res://UI/ScreenManager.gd"

onready var quit_button = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/QuitButton
onready var audioPlayer = $AudioStreamPlayer
onready var button_audio_player = $ButtonAudioStreamPlayer
onready var animation_tree = $AnimationTree

func _ready():
	animation_tree.active = true
	quit_button.visible = false
	audioPlayer.playing = true

func show_buttons():
	quit_button.visible = true

func _on_QuitButton_pressed():
	quit_game()

func _on_QuitButton_mouse_entered():
	play_sound(button_audio_player)
