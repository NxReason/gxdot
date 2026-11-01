class_name LootTable
extends Node

var common: Dictionary[String, int] = {
	coin = 50,
	potion = 25,
	rustic_sword = 10
}

func gen_common_loot():
	return gen_loot(common)

func gen_loot(table: Dictionary[String, int]):
	var total_weight: int = 0
	for weight in table.values():
		total_weight += weight

	if total_weight == 0:
		return null

	var rnd_value = randi_range(1, total_weight)
	var rel_weight: int = 0
	for key in table:
		var weight = table[key]
		rel_weight += weight
		if rnd_value <= rel_weight:
			return key

	return null
