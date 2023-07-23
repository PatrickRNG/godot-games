extends Resource
class_name Stats

@export var max_health: int
@export var damage: float

var current_health: int

signal health_changed
signal health_depleted

#func _init():
#	current_health = max_health

func reset():
	current_health = max_health

func take_damage(amount: int):
	current_health = max(0, current_health - amount)
	emit_signal("health_changed", current_health)
	if current_health <= 0:
		emit_signal("health_depleted")

func heal(amount: int):
	current_health = min(max_health, current_health + amount)
	emit_signal("health_changed", current_health)
