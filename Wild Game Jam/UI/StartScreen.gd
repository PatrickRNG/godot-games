extends "res://UI/ScreenManager.gd"

onready var label = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/Label
onready var animation_tree = $AnimationTree
onready var animation_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer
onready var button_audio_player = $ButtonAudioStreamPlayer
onready var start_button = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/StartButton
onready var quit_button = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/QuitButton
#var text_1 = "You were going home."
#var text_2 = "Strangely, your ship started to breakdown."
#var text_3 = "After such a long trip, you just sit down, exhausted, and try to control the ship enough for a landing somewhere. A close planet arrives at your radar. After the stabilization, you just lay down and wait."
#var text_4 = "Your ship landed."
#var text_5 = "You woke up at an unfamiliar space."

func _ready():
	animation_tree.active = false
	label.visible = false
	label.text = ""
	audio_player.playing = true

func start_game():
	audio_player.playing = false
	get_tree().change_scene("res://World/World.tscn")

func _on_StartButton_pressed():
	start_button.visible = false
	quit_button.visible = false
	label.visible = true
	animation_tree.active = true

func _on_QuitButton_pressed():
	quit_game()

func _on_StartButton_mouse_entered():
	play_sound(button_audio_player)

func _on_QuitButton_mouse_entered():
	play_sound(button_audio_player)
