extends Node

const MAIN := "res://scenes/main_menu.tscn"
const DICT := "res://dict/dict.tscn"
const NEW_KANJI := "res://dict/new_kanji.tscn"
const GAME := "res://kanji/kanji_type.tscn"


func load_main():
	load_scene(MAIN)


func load_dict():
	load_scene(DICT)


func load_new_kanji():
	load_scene(NEW_KANJI)


func load_game():
	load_scene(GAME)


func load_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)