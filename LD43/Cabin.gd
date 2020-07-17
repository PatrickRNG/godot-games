extends StaticBody2D


func _ready():
	$Area2D.connect("body_entered", self, "hide_roof")
	$Area2D.connect("body_exited", self, "show_roof")

func show_roof(body):
	if body.name == "Player":
		$Graphics/Roof.show()

func hide_roof(body):
	if body.name == "Player":
		$Graphics/Roof.hide()