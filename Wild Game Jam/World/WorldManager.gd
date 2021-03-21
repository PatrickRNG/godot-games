extends Node

onready var game_over_screen = preload("res://UI/GameOverScreen.tscn")

func game_over(location, death: bool = true):
	var game_over_instance = game_over_screen.instance()
	if death:
		game_over_instance.set_title("You died")
	else:
		game_over_instance.set_title("You suffocated")
	location.add_child(game_over_instance)
	get_tree().paused = true
