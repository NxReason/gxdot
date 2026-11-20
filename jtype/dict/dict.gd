extends Node

@export var kanji_scene: PackedScene

var kanji_list: Array[Kanji] = []

@onready var kanji_container: GridContainer = $Control/Margin/VBox/KanjiGrid

func _init() -> void:
	kanji_list = Kanji.read_store()


func _ready() -> void:
	print(OS.get_user_data_dir())
	display_kanji()


func display_kanji():
	if not kanji_scene:
		print(kanji_scene)
		return
	for kanji in kanji_list:
		var kanji_entry: KanjiEntry = kanji_scene.instantiate()
		kanji_entry.kanji = kanji
		kanji_container.add_child(kanji_entry)


func _on_button_button_down() -> void:
	SceneManager.load_new_kanji()
