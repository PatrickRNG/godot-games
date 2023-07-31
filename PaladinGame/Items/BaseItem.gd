# Base Item Scene script for creating items from
extends Node2D
class_name Base_Item

@export var itemStats: Item

# TODO - fix item name to label node
@onready var sprite2D: Sprite2D = $Sprite2D
@onready var label: RichTextLabel = $ItemNameLabel

func _ready():
	if not itemStats:
		print('Item stats not available. Add the Resource Object.')
	sprite2D.texture = itemStats.sprite
	label.set_text(itemStats.name)

func _on_pickup_radius_body_entered(body):
	print('pickup radius')
