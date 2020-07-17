extends Area2D

export(String) var full_msg 
export(String) var hungry_msg
export(String) var starving_msg

onready var label = $Node2D/Label

var hunger = 1
var dead = false

func _ready():
	add_to_group("eats")
	connect("body_entered", self, "display_hunger")
	connect("body_exited", self, "hide_hunger")

func display_hunger(body):
	if dead:
		return
	if body.name != "Player":
		return
	label.show()
	update_text()

func hide_hunger(body):
	if body.name != "Player":
		return
	label.hide()

func increase_hunger():
	hunger += 1
	if hunger > 4:
		dead = true
		label.hide()
		if get_parent().has_method("kill"):
			get_parent().kill()

func kill():
	label.hide()
	get_tree().call_group("tracks_dead", "add_dead", get_parent().name)

func update_text():
	var msg = full_msg
	if hunger > 0:
		msg = hungry_msg
	if hunger > 3:
		msg = starving_msg
	label.text = msg

func feed():
	if hunger == 0:
		return false
	hunger -= 1
	update_text()
	return true