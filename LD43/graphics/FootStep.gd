extends Node2D

var life_time = 2
var cur_life_time = 0

func _ready():
	var ind = randi() % 100
	if ind < 3:
		life_time = 120
	if ind < 1:
		life_time = 500

func _process(delta):
	cur_life_time += delta
	if cur_life_time >= life_time:
		queue_free()
	else:
		$Sprite.modulate.a = clamp(1 - cur_life_time / life_time, 0, 0.5)

