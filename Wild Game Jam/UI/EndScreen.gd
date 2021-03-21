extends CanvasLayer

onready var quit_button = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/QuitButton
onready var audioPlayer = $AudioStreamPlayer
onready var animation_tree = $AnimationTree

func _ready():
	animation_tree.active = true
	quit_button.visible = false
	audioPlayer.playing = true

func show_buttons():
	quit_button.visible = true

func _on_QuitButton_pressed():
	get_tree().quit()
