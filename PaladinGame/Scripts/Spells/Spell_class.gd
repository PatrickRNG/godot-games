# Spell resource with common properties and stats for each skill
extends Resource
class_name Spell

enum Cast_Type {
	ON_MOUSE
}

signal spell_casted
signal spell_was_casted

@export var name: String = ''
@export var damage: int = 10
@export var cast_type: Cast_Type = Cast_Type.ON_MOUSE
@export var spell_scene_path: String
@export var cooldown: float
