class_name KanjiEnemy
extends Node2D

signal finished(enemy: KanjiEnemy)

var kanji: Kanji
var is_disappearing: bool = false
var row: int = 0
var col: int = 0
var max_row: int = 10
# x - top, y - bottom
var height_range: Vector2

@onready var particles: GPUParticles2D = $Particles
@onready var visual: Polygon2D = $Visual
@onready var glyph: Label = $Label


func _ready() -> void:
	set_y_pos()


func set_kanji(k: Kanji):
	kanji = k
	glyph.text = kanji.glyph

func move():
	if is_disappearing: return

	row += 1
	if row == max_row:
		disappear()
	else:
		set_y_pos()


func disappear():
	is_disappearing = true
	visual.visible = false
	glyph.visible = false
	particles.emitting = true


func set_y_pos():
	var total_height := height_range.y - height_range.x
	var step: float = float(total_height) / (max_row - 1)
	var offset: float = step * row
	position.y = height_range.x + offset


func _on_particles_finished() -> void:
	finished.emit(self)
	queue_free()
