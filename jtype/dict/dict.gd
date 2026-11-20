extends Node

@export var kanji_scene: PackedScene

var kanji_list: Dictionary[String, Kanji] = {}
var kanji_visuals: Dictionary[String, KanjiVisual] = {}

@onready var kanji_container: GridContainer = $Control/Margin/VBox/KanjiGrid


func _init() -> void:
	kanji_list = Kanji.read()


func _ready() -> void:
	display_kanji()


func display_kanji():
	for id in kanji_list:
		var kanji := kanji_list[id]
		var kanji_visual: KanjiVisual = kanji_scene.instantiate()
		kanji_visual.id = id
		kanji_visual.kanji = kanji
		kanji_visual.connect('delete_kanji', handle_delete_kanji)

		kanji_container.add_child(kanji_visual)
		kanji_visuals[id] = kanji_visual


func handle_delete_kanji(id: String):
	Kanji.delete(id)

	var visual: KanjiVisual = kanji_visuals.get(id)
	if not visual:
		print("Can't delete visual with id: ", id)
		return

	kanji_list.erase(id)
	kanji_visuals.erase(id)
	visual.queue_free()


func _on_button_button_down() -> void:
	SceneManager.load_new_kanji()


func _on_go_back_button_button_down() -> void:
	SceneManager.load_main()
