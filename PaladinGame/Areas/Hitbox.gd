class_name Hitbox
extends Area2D

@export var damage: float = 10

func _init() -> void:
	collision_layer = 2
	# Turn off all masks
	collision_mask = 0
