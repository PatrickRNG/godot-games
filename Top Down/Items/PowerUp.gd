extends Sprite

enum {
	SET,
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

enum {
	BULLET,
	SPELL
}

signal item_pickup

export(String) var player_stat_name
export(float) var player_stat_value
export(int, "SET", "ADD", "SUBTRACT", "MULTIPLY", "DIVIDE") var calculation = ADD

func _on_Hitbox_area_entered(area):
	var player = area.get_parent()
	var stat = player.get(player_stat_name)
	var value = addValue(stat, player_stat_value)
	player.set(player_stat_name, value)
	queue_free()
	emit_signal("item_pickup")

func addValue(stat, value):
	match calculation:
		SET: return value
		ADD: return stat + value
		SUBTRACT: return stat - value
		MULTIPLY: return stat * value
		DIVIDE: return stat / value
