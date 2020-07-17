extends Area2D

func _ready():
	connect("body_entered", self, "give_food")

func give_food(body):
	if body.name != "Player":
		return
	body.food += 1
	body.update_stats()
	call_deferred('free')

