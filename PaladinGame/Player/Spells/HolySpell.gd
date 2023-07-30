extends Node2D

@onready var sprite2D: AnimatedSprite2D = $Sprite2D

func _ready():
	sprite2D.frame = 0
	sprite2D.play("cast")

func _destroy_spell():
	queue_free()

func _on_sprite_2d_animation_finished():
	_destroy_spell()
