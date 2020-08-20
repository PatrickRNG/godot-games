extends YSort

export(Color, RGBA) var day_color = Color()
export(Color, RGBA) var night_color = Color()

const DAY_LENGTH = 20
const NIGHT_LENGTH = 20
const EVE_LENGTH = 10

var state = 0
var time = 0

var cur_day = 0
const MAX_DAYS = 15

onready var tint = $CanvasLayer/TextureRect

func _ready():
	add_to_group("tracks_dead")
	tint.show()
	

func _process(delta):
	time += delta
	var leng = EVE_LENGTH
	if state == 0:
		leng = DAY_LENGTH
	if state == 2:
		leng = NIGHT_LENGTH
	
	if time > leng:
		time -= leng
		state += 1
		state %= 4
		if state == 0:
			increase_day()
			get_tree().call_group("eats", "increase_hunger")
	
	var col = Color()
	if state == 0:
		col = day_color
	elif state == 1:
		col = day_color.linear_interpolate(night_color, clamp(time / EVE_LENGTH, 0, 1))
	elif state == 2:
		col = night_color
	elif state == 3:
		col = night_color.linear_interpolate(day_color, clamp(time / EVE_LENGTH, 0, 1))
	
	tint.color = col


var all_dead = []
func add_dead(name):
	all_dead.append(name)

func increase_day():
	cur_day += 1
	$Player.update_stats()
	if !$Player.dead and cur_day >= MAX_DAYS:
		WinStats.all_dead = all_dead
		get_tree().change_scene("res://WinLevel.tscn")
