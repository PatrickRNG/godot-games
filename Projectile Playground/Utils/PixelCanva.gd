extends Node2D

onready var pixel = preload("res://Utils/WhitePixel.tscn")
onready var sprites = $Sprites
onready var tilemap = $TileMap
onready var mouse_pixel

onready var grid_size = Vector2(64, 64)
onready var has_projectiles = get_tree().get_nodes_in_group("projectile").size() > 0 
var cell_size = 8
var coord = Vector2.ZERO
var added_positions: Dictionary = {}
var can_draw = false

signal custom_projectile
signal is_drawing

func _ready():
	mouse_pixel = pixel.instance()
	mouse_pixel.visible = false
	mouse_pixel.modulate = Color(1,1,1,0.3)
	set_process_input(true)
	add_child(mouse_pixel)

func _process(event):
	if coord.x >= 0 and coord.y >= 0 and coord.x < 8 and coord.y < 8:
		print_debug(ControlManager.is_firing)
		if Input.is_action_pressed("action") and can_draw and !ControlManager.is_firing:
			var pixel_instance = pixel.instance()
			pixel_instance.position = Vector2(coord.x * cell_size, coord.y * cell_size)
			pixel_instance.set_modulate(ControlManager.properties.color)
			# Remove the pixel behind if placed on top
			if added_positions.get(coord):
				var added_pixel = added_positions.get(coord)
				added_pixel.queue_free()
			added_positions[coord] = pixel_instance
			sprites.add_child(pixel_instance)
			ControlManager.properties.custom_projectile = sprites
		if Input.is_action_pressed("remove_action") and can_draw:
			var pixel_instance = added_positions.get(coord)
			if pixel_instance:
				pixel_instance.queue_free()
			added_positions.erase(coord)

func _input(event):
	if event is InputEventMouseMotion and can_draw:
		var posX = int($Area2D.get_local_mouse_position().x / cell_size)
		var posY = int($Area2D.get_local_mouse_position().y / cell_size)
		var pos = Vector2(posX, posY)
		if pos != coord:
			coord = pos
			mouse_pixel.position = Vector2(coord.x * cell_size, coord.y * cell_size) - Vector2(32, 32)

func _draw():
	draw_line(Vector2(-32, -32), Vector2(-32, 32), Color(1, 1, 1, 1))
	draw_line(Vector2(-32, -32), Vector2(32, -32), Color(1, 1, 1, 1))
	draw_line(Vector2(-32, 32), Vector2(32, 32), Color(1, 1, 1, 1))
	draw_line(Vector2(32, -32), Vector2(32, 32), Color(1, 1, 1, 1))
	for x in range(-32, grid_size.x / 2 , cell_size):
		for y in range(-32, grid_size.y / 2, cell_size):
			draw_line(Vector2(x, y), Vector2(x, y + cell_size), Color(1, 1, 1, 0.3))
			draw_line(Vector2(x, y), Vector2(x + cell_size, y), Color(1, 1, 1, 0.3))

func _on_Area2D_mouse_exited():
	if added_positions.size() > 0:
		emit_signal("custom_projectile", sprites)
	can_draw = false
	mouse_pixel.visible = false
	ControlManager.is_drawing = false

func _on_Area2D_mouse_entered():
	can_draw = true
	mouse_pixel.visible = true
	ControlManager.is_drawing = true
