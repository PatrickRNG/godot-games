# Base Item Scene script for creating items from
extends Node2D
class_name Base_Item

@export var itemStats: Item

@onready var sprite2D: Sprite2D = $Sprite2D
@onready var label: Label = $Sprite2D/Label/PanelContainer/ItemNameLabel
@onready var label_panel: PanelContainer = $Sprite2D/Label/PanelContainer
@onready var pickup_radius: CollisionShape2D = $Pickup_Radius/CollisionShape2D

var player_on_range = null
var clicked_item: bool = false

func _ready():
	if not itemStats:
		print('Item stats not available. Add the Resource Object.')
	sprite2D.texture = itemStats.sprite
	label.text = itemStats.name

# TODO - Fix able to get Item if already inside the circle and clicking the item
func _unhandled_input(event):
	# Can't pickup item if player changed click position to outside the item
	if event.is_action_pressed("left_click"):
		if get_global_mouse_position().distance_to(self.position) > pickup_radius.shape.radius:
			clicked_item = false
		else:
			print('clickk')
			clicked_item = true

func _on_pickup_radius_body_entered(body: CharacterBody2D):
	if (body.is_in_group("player")):
		player_on_range = body
		if (clicked_item):
			var item_manager = player_on_range.get_node("ItemManager")
			item_manager.pickup_item(self)

func _on_pickup_radius_body_exited(body):
	player_on_range = null

func _on_pickup_radius_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		clicked_item = true
