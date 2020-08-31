extends Node

var enemies_stats: Dictionary = {
	"goblin": {
		"health": 5,
		"damage": 1
	},
	"barbarian": {
		"health": 6,
		"damage": 1
	}
}

func add_all_enemies_stats(stat, value):
	for i in enemies_stats:
		var enemy = enemies_stats[i]
		enemy[stat] += value
