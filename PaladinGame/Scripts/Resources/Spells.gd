extends Resource
class_name Spells

# [ { resource_path: '',  } ]

@export var spells: Array[Dictionary]
@export var damage: float

func get_spell(spell_index: int):
	return spells[spell_index]
