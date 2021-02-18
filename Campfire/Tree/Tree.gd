extends Node2D

signal cut_tree

var is_cut = false

onready var health = 5 setget damage_tree
onready var cutdown_tree_texture

func damage_tree(new_health: int):
	health = new_health
	if (health <= 0):
		is_cut = true
		$Sprite.position = Vector2(0, -33.001)
		$Sprite.texture.region = Rect2(10, 260, 40, 30)
		

# Player axe hitbox entered tree
func _on_Hurtbox_area_entered(area):
#	var player = area.get_parent()
	if (!is_cut):
		self.health -= 1
