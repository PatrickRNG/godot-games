extends Label

func _process(_delta):
	text = "Score: " + build_time(int(Manager.time_score))

func build_time(seconds) -> String:
	return String(int(seconds / 60)) +  "m " + String(seconds % 60) + "s"
