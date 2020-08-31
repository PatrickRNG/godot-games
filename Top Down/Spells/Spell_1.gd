extends "res://Spells/Spell.gd"

onready var animation_player = $AnimationPlayer
var projectile: int = 1
var projectile_angle: int = 1
var damage: int = 1
var fire_rate: float = 0.4
var tier: int = 1
var pierce: int = 1

func _ready():
	animation_player.play("Spell_1")
