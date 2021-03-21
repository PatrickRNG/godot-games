extends CanvasLayer

#onready var titleLabel = $PanelContainer/MarginContainer/Rows/TitleLabel

func set_title(text: String):
	$PanelContainer/MarginContainer/Rows/TitleLabel.text = text

func _on_RestartButton_pressed():
	get_tree().change_scene("res://World/World.tscn")
	get_tree().paused = false

func _on_QuitButton_pressed():
	get_tree().quit()
