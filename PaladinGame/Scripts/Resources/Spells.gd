# Spells Resource script - List of available spells
extends Resource
class_name Spells

@export var spells: Array[Spell]

# SpellManager - Access to Player assigned spells

# Player gets a gem
# Each gem has a spell assigned to it
# Spell is attached to a player available spell slot
# Player press the spell slot shortcut
# Uses Spell Resource to cast that specific spell
