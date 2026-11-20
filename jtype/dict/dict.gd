extends Node

@export var kanji_scene: PackedScene

var kanji_file: FileAccess
var kanji_list: Array[Kanji] = []

@onready var kanji_container: GridContainer = $Control/Margin/VBox/KanjiGrid

func _init() -> void:
	DirAccess.make_dir_recursive_absolute("user://data")
	kanji_file = FileAccess.open("user://data/kanji.json", FileAccess.READ_WRITE)

	if not kanji_file:
		FileAccess.open("user://data/kanji.json", FileAccess.WRITE)
		kanji_file = FileAccess.open("user://data/kanji.json", FileAccess.READ_WRITE)
		kanji_file.store_string("[]")

	# read kanji
	var kanji_json_text = kanji_file.get_as_text()
	var kanji_json = JSON.new()
	var error = kanji_json.parse(kanji_json_text)

	if error != OK:
		print(kanji_json.get_error_message())
		return
	
	for entry in kanji_json.data:
		parse_kanji(entry)


func _ready() -> void:
	print(OS.get_user_data_dir())
	display_kanji()


func parse_kanji(json_entry):
	var kanji = Kanji.new()
	if !json_entry.has('glyph'):
		print('Kanji missing glyph')
		return

	kanji.glyph = json_entry.get('glyph')
	kanji.meanings.assign(json_entry.get('meanings', []))
	kanji.on_readings.assign(json_entry.get('on_readings', []))
	kanji.kun_readings.assign(json_entry.get('kun_readings', []))
	kanji.tags.assign(json_entry.get('tags', []))

	kanji_list.push_back(kanji)


func display_kanji():
	if not kanji_scene:
		print(kanji_scene)
		return
	for kanji in kanji_list:
		var kanji_entry: KanjiEntry = kanji_scene.instantiate()
		kanji_entry.kanji = kanji
		kanji_container.add_child(kanji_entry)
