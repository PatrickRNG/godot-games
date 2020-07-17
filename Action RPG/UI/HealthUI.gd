extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var heartPixelSize = 15

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

onready var label = $Label

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * heartPixelSize

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * heartPixelSize

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changes", self, "set_max_hearts")
