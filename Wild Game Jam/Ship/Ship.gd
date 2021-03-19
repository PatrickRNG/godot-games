extends StaticBody2D

enum {
	BATTERY,
	CUBE,
	COMPONENT
}

onready var timer = $Timer

var is_player_in_range = false
var player = null

onready var label = $Control/Label
onready var panel = $Control2/Panel
onready var animationPlayer = $AnimationPlayer

onready var missing_parts = {
	BATTERY: { "label": $Control2/Panel/Label, "texture": $Control2/Panel/TextureRect, "value": false },
	CUBE: { "label": $Control2/Panel/Label2, "texture": $Control2/Panel/TextureRect2, "value": false },
	COMPONENT: { "label": $Control2/Panel/Label3, "texture": $Control2/Panel/TextureRect3, "value": false }
}

func _ready():
	toggle_ui(false)
	change_label($Control2/Panel/Label, false)
	change_label($Control2/Panel/Label2, false)
	change_label($Control2/Panel/Label3, false)

func _process(delta):
	if player and Input.is_action_just_pressed("action"):
		if is_player_in_range and !player.is_in_ship and !player.is_holding:
			enter_ship()
		elif player.is_holding:
			# Attach item to ship
			var added_item = missing_parts[player.current_holding_item_type]
			added_item.value = true
			change_label(added_item.label, true, added_item.texture)
			player.detach_item()
			
		elif player.is_in_ship:
			leave_ship()

func enter_ship():
	player.is_in_ship = true
	player.setup_o2_meter(true, 2, 0.5)

func leave_ship():
	player.is_in_ship = false
	player.setup_o2_meter()

func _on_Interact_Area_body_entered(body):
	player = body
	is_player_in_range = true
	toggle_ui(true)
	animationPlayer.play("GrowUI")

func _on_Interact_Area_body_exited(body):
	player = body
	is_player_in_range = false
	animationPlayer.play("ShrinkUI")

func toggle_ui(visibility: bool = false):
	label.visible = visibility
	panel.visible = visibility

func change_label(label: Node, value: bool, texture: TextureRect = null):
	var completed = "Missing"
	label.add_color_override("font_color", Color(0.752941, 0.654902, 0.654902,1))
	if value:
		completed = "Done"
		texture.set_modulate(Color(1,1,1,1))
		label.add_color_override("font_color", Color(0.654902, 0.752941, 0.658824, 1))

	label.text = completed
