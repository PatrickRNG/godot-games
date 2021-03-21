extends StaticBody2D

enum {
	BATTERY,
	CUBE,
	COMPONENT,
	SHIP
}

onready var timer = $Timer

var is_player_in_range = false
var is_complete = false
var player = null
var is_fixed = false
var parts_array = []

onready var label = $UI/Control/Label
onready var panel = $UI/Control2/Panel
onready var fixBar = $UI/Control/FixBar
onready var animationPlayer = $AnimationPlayer

onready var missing_parts = {
	BATTERY: { "label": $UI/Control2/Panel/Label, "texture": $UI/Control2/Panel/TextureRect, "value": false },
	CUBE: { "label": $UI/Control2/Panel/Label2, "texture": $UI/Control2/Panel/TextureRect2, "value": false },
	COMPONENT: { "label": $UI/Control2/Panel/Label3, "texture": $UI/Control2/Panel/TextureRect3, "value": false },
	SHIP: { "label": $UI/Control2/Panel/Label4, "texture": $UI/Control2/Panel/TextureRect4, "value": false }
}

func _ready():
	fixBar.visible = false
	toggle_ui(false)
	change_label($UI/Control2/Panel/Label, false)
	change_label($UI/Control2/Panel/Label2, false)
	change_label($UI/Control2/Panel/Label3, false)
	change_label($UI/Control2/Panel/Label4, false)

func _process(delta):
	if player and is_player_in_range and Input.is_action_just_pressed("action"):
		if !player.is_in_ship and !player.is_holding:
			enter_ship()
		elif player.is_holding:
			# Attach item to ship
			var added_item = missing_parts[player.current_holding_item_type]
			added_item.value = true
			change_label(added_item.label, true, added_item.texture)
			player.detach_item()
		elif player.is_in_ship:
			leave_ship()
		
		parts_array = []
		for part in missing_parts.values():
			parts_array.append(part.value)
	
	if parts_array == [true, true, true, true]:
		is_complete = true
		label.text = 'Hold "F" to fix the ship'
		if Input.is_action_pressed("action_2"):
			fixBar.visible = true
			label.visible = false
			fixBar.value += 0.05
			if fixBar.value == 100:
				fix_ship()

func enter_ship():
	player.is_in_ship = true
	player.setup_o2_meter(true, 4, 0.5)
	if is_fixed and parts_array == [true, true, true, true]:
		get_tree().change_scene("res://UI/EndScreen.tscn")

func leave_ship():
	player.is_in_ship = false
	player.setup_o2_meter()

func _on_Interact_Area_body_entered(body):
	player = body
	player.can_attack = false
	is_player_in_range = true
	toggle_ui(true)
	animationPlayer.play("GrowUI")

func _on_Interact_Area_body_exited(body):
	player = body
	player.can_attack = true
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

func fix_ship():
	$BrokenParticles.visible = false
	$BrokenParticles2.visible = false
	$Smoke.visible = false
	is_fixed = true
