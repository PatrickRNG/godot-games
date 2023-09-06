extends Node
class_name HealthComponent

signal died

@export var max_health: float = 10
var current_health


func _ready():
	current_health = max_health

func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	# Remove error - Can't change the state while flushing
	Callable(check_death).call_deferred()

func check_death():
	if current_health == 0:
		died.emit()
		# owner of this component (like player or enemy)
		owner.queue_free()
