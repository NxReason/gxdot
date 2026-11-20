extends Node

var game_scene := preload("res://kanji/kanji_type.tscn")
var dict_scene := preload("res://dict/dict.tscn")


func _on_play_button_button_down() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_dict_button_button_down() -> void:
	get_tree().change_scene_to_packed(dict_scene)


func _on_exit_button_button_down() -> void:
	get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	print(event)
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
