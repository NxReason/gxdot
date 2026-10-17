class_name Cell
extends Node2D

var _value: int
var target_pos: Vector2
var old_pos: Vector2
var is_shifting: bool = false

func _ready() -> void:
	pass

func set_pos(pos: Vector2) -> void:
	position = pos

func set_target_pos(pos: Vector2) -> void:
	target_pos = pos
	old_pos = position

func set_value(new_value: int) -> void:
	_value = new_value
	$Value.text = str(new_value)

func get_value() -> int:
	return _value

func double() -> void:
	set_value(_value * 2)

func move_to_target(perc: float):
	perc = clamp(perc, 0.0, 1.0)
	var path = target_pos - old_pos
	position = old_pos + path * perc

func destroy():
	queue_free()
