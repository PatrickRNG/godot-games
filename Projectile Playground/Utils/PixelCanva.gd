extends Node2D

onready var pixel = preload("res://Utils/WhitePixel.tscn")
onready var sprites = $Sprites
onready var tilemap = $TileMap
onready var mouse_pixel

onready var grid_size = Vector2(256, 256)
var cell_size = 16
var coord = Vector2.ZERO
var added_positions: Dictionary = {}
var can_draw = true

signal custom_projectile

func _ready():
	mouse_pixel = pixel.instance()
	mouse_pixel.visible = false
	mouse_pixel.modulate = Color(1,1,1,0.3)
	add_child(mouse_pixel)

func _process(event):
	var cell_position = Vector2(int(get_local_mouse_position().x / cell_size), int(get_local_mouse_position().y / cell_size))
	if can_draw:
		mouse_pixel.position = Vector2(cell_position.x * 16, cell_position.y * 16)
	
	if Input.is_action_pressed("action") and can_draw:
		if cell_position != coord:
			coord = cell_position
			if coord.x >= 0 and coord.y >= 0 and coord.x < 16 and coord.y < 16:
				var pixel_instance = pixel.instance()
				pixel_instance.position = Vector2(coord.x * 16, coord.y * 16)
				pixel_instance.set_modulate(ControlManager.properties.color)
				# Remove the pixel behind if there is already one placed
				if added_positions.get(coord):
					var added_pixel = added_positions.get(coord)
					added_pixel.queue_free()
				added_positions[coord] = pixel_instance
				sprites.add_child(pixel_instance)
				ControlManager.properties.custom_projectile = sprites
	if Input.is_action_pressed("remove_action") and can_draw:
		if cell_position != coord:
			coord = cell_position
			if coord.x >= 0 and coord.y >= 0 and coord.x < 16 and coord.y < 16:
				var pixel_instance = added_positions.get(coord)
				if pixel_instance:
					pixel_instance.queue_free()
				added_positions.erase(coord)

func _draw():
	for x in range(0, grid_size.x, cell_size):
		print_debug("x: ", x)
		for y in range(0, grid_size.y, cell_size):
			draw_line(Vector2(x, y), Vector2(x, y + cell_size), Color(1, 1, 1, 0.3), 1.0)
			draw_line(Vector2(x, y), Vector2(x + cell_size, y), Color(1, 1, 1, 0.3), 1.0)

func _on_Area2D_mouse_exited():
	emit_signal("custom_projectile", sprites)
	can_draw = false
	mouse_pixel.visible = false

func _on_Area2D_mouse_entered():
	can_draw = true
	mouse_pixel.visible = true
