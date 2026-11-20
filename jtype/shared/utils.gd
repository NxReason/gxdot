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
