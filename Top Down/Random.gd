extends Node

func get_weighted_properties(list: Array) -> Dictionary:
	# 	Calculate total weight and accumulate the weight for each item
	var total_weight = 0
	var new_list = list.duplicate(true)
	for item in new_list:
		total_weight += item.weight
		item.weight = total_weight
	return {
		"total_weight": total_weight,
		"list": new_list
	}

func get_random_instance_by_weight(list: Array, total_weight: int, default):
	var rng = randi() % total_weight
	for item in list:
		# if the RNG is <= item cumulated weight then drop that item
		if rng <= item.weight and Global.wave >= item.wave:
			return item
	return default
