class_name TowerPlacer
extends Node2D

@export var tower_scene: PackedScene

@onready var preview: Sprite2D = $Preview
@onready var ground: TileMapLayer = $"../Ground"
@onready var road: TileMapLayer = $"../Road"

var is_active: bool = false
var placed_towers: Dictionary[Vector2i, Tower] = {}

const VALID_COLOR = Color8(255, 255, 255, 125)
const INVALID_COLOR = Color8(255, 55, 55, 125)

class Positions:
	var mouse: Vector2
	var ground_cell: Vector2i
	var road_cell: Vector2i

var pos: Positions = Positions.new()


func _process(_delta: float) -> void:
	if !is_active: return

	move_preview()


func move_preview():
	pos.mouse = get_global_mouse_position()
	pos.ground_cell = ground.local_to_map(pos.mouse)
	pos.road_cell = road.local_to_map(pos.mouse)

	var ground_pos := ground.map_to_local(pos.ground_cell)
	preview.position = ground_pos

	validate()


var is_valid := true
func validate():
	is_valid = true

	is_valid = is_valid and ground.get_cell_source_id(pos.ground_cell) != -1
	is_valid = is_valid and road.get_cell_source_id(pos.road_cell) == -1
	is_valid = is_valid and !placed_towers.has(pos.ground_cell)

	if is_valid: preview.modulate = VALID_COLOR
	else: preview.modulate = INVALID_COLOR


func place_tower():
	var tower := tower_scene.instantiate()
	tower.position = preview.position

	add_child(tower)
	placed_towers[pos.ground_cell] = tower


func clear_dead_enemy(enemy: Enemy):
	for tower in placed_towers.values():
		tower.remove_enemy(enemy)


#Input
func _unhandled_input(event: InputEvent) -> void:
	if !is_active: return

	if event.is_action_pressed("left_click"):
		if !is_valid: return
		place_tower()
	if event.is_action_pressed("right_click"):
		disable()


# Activation
func toggle() -> void:
	if is_active: disable()
	else: enable()

func enable() -> void:
	preview.visible = true
	is_active = true

func disable() -> void:
	preview.visible = false
	is_active = false
