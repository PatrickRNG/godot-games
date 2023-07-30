# Player spell manager to deal with spell using logic
extends Node
class_name SpellManager

#@export var player_spells: Spells
@export var spell_slots: Array[Spell]

var spell_cooldowns: Dictionary = {}

func get_spell(spell_index: int) -> Spell:
	return spell_slots[spell_index]

func assign_spell():
	pass

func cast_spell(spell_index: int) -> void:
	var spell_to_cast: Spell = get_spell(spell_index)
	print(spell_cooldowns)
	
	if not is_spell_on_cooldown(spell_to_cast.name):
		match spell_to_cast.cast_type:
			spell_to_cast.Cast_Type.ON_MOUSE:
				cast_spell_on_mouse(spell_to_cast)

func cast_spell_on_mouse(spell: Spell):
	var spell_instance = load(spell.spell_scene_path).instantiate()
	var mouse_pos = get_parent().get_global_mouse_position()
	
	get_tree().get_root().add_child(spell_instance)
	spell_instance.position = mouse_pos
	
	start_spell_cooldown(spell)

func start_spell_cooldown(spell: Spell):
	# Set the cooldown for the spell
	spell_cooldowns[spell.name] = spell.cooldown
	# Start the cooldown timer.
	start_cooldown_timer(spell, spell.cooldown)

func is_spell_on_cooldown(spell_name: String) -> bool:
	return spell_cooldowns.has(spell_name) and spell_cooldowns[spell_name] > 0

func start_cooldown_timer(spell: Spell, cooldown: float):
	# Create a cooldown timer and execute timeout function after timeout
	await get_tree().create_timer(cooldown).timeout
	_on_cooldown_timer_timeout(spell)

func _on_cooldown_timer_timeout(spell: Spell):
	print('TIMEOUT')
	# Timer timeout, reset the cooldown for the spell.
	spell_cooldowns[spell.name] = 0.0
