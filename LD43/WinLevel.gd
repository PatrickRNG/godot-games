extends ColorRect

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var label = $Label
	if WinStats.all_dead.size() > 0:
		label.text += "\nUnfortunately not everyone made it, rest in piece:\n"
	for d in WinStats.all_dead:
		label.text += d + "\n"

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()