class_name KanjiVisual
extends PanelContainer

signal delete_kanji(id: String)

var id: String
var kanji: Kanji

@onready var glyph: Label = $Margin/VBox/Glyph
@onready var on_readings: Label = $Margin/VBox/On
@onready var kun_readings: Label = $Margin/VBox/Kun
@onready var meanings: Label = $Margin/VBox/Meanings
@onready var tags: Label = $Margin/VBox/Tags


func _ready() -> void:
	if not kanji:
		print('Invalid kanji: ', kanji)
		return

	glyph.text = kanji.glyph
	on_readings.text = ', '.join(kanji.on_readings)
	kun_readings.text = ', '.join(kanji.kun_readings)
	meanings.text = ', '.join(kanji.meanings)
	tags.text = ', '.join(kanji.tags)


func _on_button_button_down() -> void:
	delete_kanji.emit(id)
