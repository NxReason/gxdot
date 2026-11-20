extends Node2D

@export var enemy_scene: PackedScene

const INITIAL_ENEMY_COUNT := 4

const ROWS := 10
const COLS := 10

var kanji_list: Dictionary[String, Kanji] = {}
var bounds: Bounds = Bounds.new()
var enemies: Array[KanjiEnemy] = []


func _init() -> void:
	kanji_list = Kanji.read()


func _ready() -> void:
	spawn_enemies(INITIAL_ENEMY_COUNT)


func spawn_enemies(count: int = 5):
	var cols := pick_random_cols(count)
	var kanjis = Utils.pick_random_n(kanji_list.keys(), count)

	for i in range(count):
		var col := cols[i]
		var kanji_id = kanjis[i]
		var enemy_x := get_x_pos(col)
		var enemy := enemy_scene.instantiate() as KanjiEnemy
		enemy.position.x = enemy_x
		enemy.max_row = ROWS
		enemy.height_range = Vector2(bounds.start, bounds.end)
		enemy.connect('finished', clear_enemy)

		add_child(enemy)
		enemy.set_kanji(kanji_list[kanji_id])
		enemies.push_back(enemy)


func pick_random_cols(count: int) -> Array[int]:
	var cols: Array[int] = []
	for i in range(COLS):
		cols.push_back(i)

	for i in range(count):
		var picked_index := randi_range(i, COLS - 1)
		var temp := cols[i]
		cols[i] = cols[picked_index]
		cols[picked_index] = temp
	
	return cols.slice(0, count)


func get_x_pos(col: int) -> float:
	var width := bounds.right - bounds.left
	var step := float(width) / (COLS - 1)
	return bounds.left + step * col


func clear_enemy(enemy: KanjiEnemy):
	enemies.erase(enemy)


func _on_step_interval_timeout() -> void:
	for enemy in enemies:
		enemy.move()


class Bounds:
	var start: int = 40
	var end: int = 580
	var left: int = 200
	var right: int = 952
