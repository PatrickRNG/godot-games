extends "res://Spells/Spell.gd"

onready var animation_player = $AnimationPlayer
var projectile: int = 1
var projectile_angle: int = 3 
var damage: int = 1
var fire_rate: float = 0.3
var tier: int = 2
var pierce: int = 2

func _ready():
	animation_player.play("Spell_2")
