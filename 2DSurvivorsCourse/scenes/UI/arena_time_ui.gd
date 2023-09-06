extends CanvasLayer

@export var arena_time_manager: Node
# Get the label in the scene tree
@onready var label = %Label

# Getting the arena_time_manager from the export assigned in the scene
func _process(delta):
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds/60)
	var remaining_seconds = seconds - (minutes * 60)
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds))
	
