extends Node2D

signal score_increased(by_amount: int)

@export var cell_scene: PackedScene

const CELL_SIZE: float = 64
@onready var BOARD_SIZE: float = $BG.get_rect().size[0] * $BG.scale.x
@onready var GAP_SIZE: float = (BOARD_SIZE - CELL_SIZE * 4) / 5

var cells: Array[Cell]

enum ShiftDir {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	NONE,
}

var was_moved: bool

enum State {
	IDLE,
	SHIFTING,
	CREATING
}
var state: State = State.IDLE

@export var shift_duration: float
@onready var shift_duration_left: float = shift_duration

func _ready() -> void:
	for i in range(16):
		cells.append(null)
	init()

func _process(delta: float) -> void:
	match state:
		State.IDLE:
			var shift_dir: ShiftDir = get_shift_input()
			if shift_dir != ShiftDir.NONE:
				shift_cells(shift_dir)
		State.SHIFTING:
			shift_duration_left -= delta
			animate_shift(1 - shift_duration_left / shift_duration)
		State.CREATING:
			if was_moved:
				create_cell()
			state = State.IDLE


#
# SHIFTING
#
func get_shift_input() -> ShiftDir:
	if Input.is_action_just_pressed("move_up"):
		return ShiftDir.UP
	if Input.is_action_just_pressed("move_down"):
		return ShiftDir.DOWN
	if Input.is_action_just_pressed("move_left"):
		return ShiftDir.LEFT
	if Input.is_action_just_pressed("move_right"):
		return ShiftDir.RIGHT
	return ShiftDir.NONE


func shift_cells(dir: ShiftDir):
	var col_range = range(3, -1, -1) \
		if dir == ShiftDir.RIGHT \
		else range(0, 4)
	var row_range = range(3, -1, -1) \
		if dir == ShiftDir.DOWN \
		else range(0, 4)

	was_moved = false
	var shift_delta = get_shift_delta(dir)
	for row in row_range:
		for col in col_range:
			var index = get_array_index(row, col)
			var cell = cells[index]
			if not cell: continue
			try_shift_cell(cell, Vector2i(row, col), shift_delta)
	
	if was_moved:
		state = State.SHIFTING


func try_shift_cell(cell: Cell, cur_pos: Vector2i, delta: Vector2i):
	var test_pos = cur_pos + delta
	while !is_out_bounds(test_pos):
		var is_cell = cells[get_array_index(test_pos.x, test_pos.y)] != null
		if is_cell: break
		test_pos += delta
	test_pos -= delta

	if test_pos != cur_pos:
		var old_index = get_array_index(cur_pos.x, cur_pos.y)
		var new_index = get_array_index(test_pos.x, test_pos.y)
		cells[new_index] = cell
		cells[old_index] = null
		cell.set_target_pos(grid_pos_from_array_index(new_index))
		cell.is_shifting = true
		was_moved = true

	# try merge
	var merge_test = test_pos + delta
	if is_out_bounds(merge_test): return

	var merge_cell: Cell = cells[get_array_index(merge_test.x, merge_test.y)]
	if merge_cell.get_value() == cell.get_value():
		score_increased.emit(cell.get_value())
		merge_cell.double()
		cell.destroy()
		cells[get_array_index(cur_pos.x, cur_pos.y)] = null
		was_moved = true

func get_shift_delta(dir: ShiftDir) -> Vector2i:
	match dir:
		ShiftDir.UP:    return Vector2i(-1, 0)
		ShiftDir.DOWN:  return Vector2i(1, 0)
		ShiftDir.LEFT:  return Vector2i(0, -1)
		ShiftDir.RIGHT: return Vector2i(0, 1)
		_: return Vector2i(0, 0)

#
# ANIMATE SHIFTING
#
func animate_shift(perc: float):
	var shifted_cells = cells.filter(func(c): return c != null && c.is_shifting == true)
	for sc in shifted_cells:
		sc.move_to_target(perc)
	if (perc > 1.0):
		state = State.CREATING
		shift_duration_left = shift_duration
		for sc in shifted_cells:
			sc.is_shifting = false

#
# CREATE CELLS
#
func init():
	for i in range(3):
		create_cell()

func create_cell():
	var empty = []
	for i in cells.size():
		if cells[i] == null:
			empty.append(i)

	var new_cell_idx = empty.pick_random()
	var new_cell = cell_scene.instantiate() as Cell
	cells[new_cell_idx] = new_cell
	new_cell.set_pos(grid_pos_from_array_index(new_cell_idx))
	new_cell.set_value(2)
	add_child(cells[new_cell_idx])

#
# UTILS
# 
func grid_pos_from_grid_index(grid_index: Vector2i) -> Vector2:
	@warning_ignore("integer_division")
	return Vector2(
		(grid_index.y * CELL_SIZE) + (CELL_SIZE / 2) - (BOARD_SIZE / 2) + GAP_SIZE * (grid_index.y + 1),
		(grid_index.x * CELL_SIZE) + (CELL_SIZE / 2) - (BOARD_SIZE / 2) + GAP_SIZE * (grid_index.x + 1),
	)

func grid_pos_from_array_index(index_pos: int) -> Vector2:
	return grid_pos_from_grid_index(get_2d_index(index_pos))

func get_2d_index(index_pos: int) -> Vector2i:
	@warning_ignore("integer_division")
	var row: int = index_pos / 4
	var col: int = index_pos % 4
	return Vector2i(row, col)

func get_array_index(row: int, col: int) -> int:
	return row * 4 + col

func is_out_bounds(pos: Vector2i) -> bool:
	return pos.x < 0 || pos.x > 3 || pos.y < 0 || pos.y > 3
