extends Node

export(int) var max_health = 10 setget set_max_health
var health = max_health setget set_health
var projectiles = 1
var fire_rate
var damage
var pierce

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
#	If the health is greater than the max_health, adjusts the health
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = max_health