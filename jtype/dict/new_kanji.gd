extends Control

@onready var glyph: LineEdit = $VBox/GlyphHBox/LineEdit
@onready var on_readings: LineEdit = $VBox/OnHBox/LineEdit
@onready var kun_readings: LineEdit = $VBox/KunHBox/LineEdit
@onready var meanings: LineEdit = $VBox/MeaningsHBox/LineEdit
@onready var tags: LineEdit = $VBox/TagsHBox/LineEdit
@onready var inputs: Array[LineEdit] = [
	glyph,
	on_readings,
	kun_readings,
	meanings,
	tags
]


func _on_save_button_button_down() -> void:
	Kanji.save({
		'glyph': glyph.text,
		'on_readings': on_readings.text.split(', '),
		'kun_readings': kun_readings.text.split(', '),
		'meanings': meanings.text.split(', '),
		'tags': tags.text.split(', '),
	})
	SceneManager.load_dict()


func _on_reset_button_button_down() -> void:
	for input in inputs:
		input.text = ''


func _on_cancel_button_down() -> void:
	SceneManager.load_dict()
