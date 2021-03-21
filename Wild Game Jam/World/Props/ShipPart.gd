extends Node2D

enum {
	BATTERY,
	CUBE,
	COMPONENT,
	SHIP,
}

export(int, "BATTERY", "CUBE", "COMPONENT", "SHIP") var type = BATTERY
var is_player_in_range = false
var player = null

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var uiControl = $Control

func _process(delta):
	if player and Input.is_action_just_pressed("action"):
		if is_player_in_range and !player.is_holding:
			player.is_holding = true
			player.attach_item(type)
			queue_free()

func _ready():
	sprite.region_enabled = true
	uiControl.visible = false
	match type:
		BATTERY:
			sprite.region_rect = Rect2(303, 57, 13, 25)
		CUBE:
			sprite.region_rect = Rect2(251, 155, 26, 27)
		COMPONENT:
			sprite.region_rect = Rect2(251, 8, 23, 33)
		SHIP:
			sprite.region_rect = Rect2(104, 154, 29, 28)

# Pick up part
func _on_InteractArea_body_entered(body):
	is_player_in_range = true
	uiControl.visible = true
	player = body
	animationPlayer.play("GrowText")
	yield(animationPlayer, "animation_finished")
	animationPlayer.play("BlinkText")

func _on_InteractArea_body_exited(body):
	is_player_in_range = false
	uiControl.visible = false
