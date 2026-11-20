extends Node

const CHARS := '0123456789abcdef'

func uuid() -> String:
	var result := ''

	for i in range(32):
		if i in [8, 12, 16, 20]:
			result += '-'
		if i == 12:
			result += '4'
		elif i == 16:
			var r := (randi() % 16 & 0x3) | 0x8
			result += CHARS[r]
		else:
			result += CHARS[randi() % 4]

	return result


func pick_random_n(arr: Array, n: int):
	if n > arr.size(): return pick_random_n_duplicate(arr, n)

	var indices: Array[int] = []
	indices.resize(arr.size())
	for i in range(arr.size()):
		indices[i] = i

	var result := Array()
	result.resize(n)
	for i in range(n):
		var picked_idx := randi_range(i, indices.size() - 1)
		var temp := indices[i]
		indices[i] = indices[picked_idx]
		indices[picked_idx] = temp
		result[i] = arr[picked_idx]

	return result


func pick_random_n_duplicate(arr: Array, n: int):
	var result = []
	result.resize(n)

	for i in range(n):
		var picked = arr[randi_range(0, arr.size() - 1)]
		result[i] = picked

	return result
