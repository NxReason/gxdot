class_name TalentConnection
extends RefCounted

var from: Vector2
var to: Vector2
var color: Color = Color8(240, 0, 240)
var width: float = 3.0

func _init(from_pos: Vector2, to_pos: Vector2) -> void:
	from = from_pos
	to = to_pos
