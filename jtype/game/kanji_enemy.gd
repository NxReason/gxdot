class_name KanjiEnemy
extends Node2D

var row: int = 0
var col: int = 0
var max_row: int = 10

# x - top, y - bottom
var height_range: Vector2


func _ready() -> void:
	set_y_pos()


func move():
	row += 1
	set_y_pos()


func set_y_pos():
	var total_height := height_range.y - height_range.x
	var step: float = float(total_height) / (max_row - 1)
	var offset: float = step * row
	position.y = height_range.x + offset
