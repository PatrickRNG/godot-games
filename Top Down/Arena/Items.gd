extends Node2D

var total_weight: int = 0
var max_items: int = 2
var item_positions: Array = [
	Vector2(250, 125),
	Vector2(220, 125),
	Vector2(190, 125),
	Vector2(160, 125),
	Vector2(130, 125)
]
var items: Array  = [
		{ "name": 'FireRateUp', "wave": 1, "weight": 40 },
		{ "name": 'ProjectileUp', "wave": 3, "weight": 20 },
		{ "name": 'PierceUp', "wave": 3, "weight": 10 },
		{ "name": 'DamageUp', "wave": 5, "weight": 10 },
		{ "name": 'Spell_tier_2', "wave": 10, "weight": 20 },
	]

func _init():
#	 Update items array with the correct accumulative weights
	var weights = Random.get_weighted_properties(items)
	items = weights.list
	total_weight = weights.total_weight

# Spawn items in the center of the arena
func spawn_all_items() -> void:
	var generated_items = []
	for i in range(max_items):
		var random_item = get_random_item()
#		Generate random item until it`s not a duplicate
		while has_duplicates(generated_items, random_item.name):
			random_item = get_random_item()
		generated_items.append(random_item.name)
		var item = load("res://Items/" + random_item.name + ".tscn")
		var item_instance = item.instance()
		item_instance.connect("item_pickup", self, "_on_item_pickup")
		item_instance.global_position = item_positions[i]
		add_child(item_instance)

func get_random_item() -> Dictionary:
	return Random.get_random_instance_by_weight(items, total_weight, items[0])

func has_duplicates(list: Array, value: String) -> bool:
	return list.has(value)

# Actions after the wave item has been picked up
func _on_item_pickup():
#	Delete other items after one have been picked up
	for child in get_children():
		child.queue_free()
