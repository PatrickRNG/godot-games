extends Node2D

var is_cut = false
var tree_full_rect = Rect2(0, 160, 60, 100)
var tree_cut_rect = Rect2(10, 262, 40, 30)
var cut_down_wood = 0

signal change_tree_position

onready var wood_item = preload("res://Items/Wood_item.tscn")
onready var spawn_area = $SpawnArea
onready var spawn_area_shape = $SpawnArea/CollisionShape2D
onready var health = 5 setget damage_tree
onready var cutdown_tree_texture

var step = 2 * PI / 5

func _ready():
	$Sprite.set_region_rect(tree_full_rect)

func damage_tree(new_health: int):
	health = new_health
	spawn_wood_item()
	if (health <= 0):
		is_cut = true
		$Sprite.set_position(Vector2(0, 43))
		$Sprite.set_region_rect(tree_cut_rect)

func spawn_wood_item():
	cut_down_wood += 1
	var center_pos = spawn_area_shape.position
	var area_radius = Vector2(spawn_area_shape.shape.radius, 0)
	var wood_pos = center_pos + area_radius.rotated(step * cut_down_wood)
	var wood_item_instance = wood_item.instance()
	add_child(wood_item_instance)
	wood_item_instance.position = wood_pos

# Player axe hitbox entered tree
func _on_Hurtbox_area_entered(area):
	var player = area.get_parent()
	if (!is_cut):
		self.health -= 1

func _on_SpawnArea_area_entered(area):
#	spawn tree again if overlap
	var area_node = area.get_parent()
	if area_node.is_in_group("tree"):
		emit_signal("change_tree_position", area_node)
