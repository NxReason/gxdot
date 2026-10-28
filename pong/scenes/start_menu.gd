extends Node

var main_scene: PackedScene

func _ready() -> void:
	main_scene = preload("res://scenes/main.tscn")

func _on_start_button_down() -> void:
	get_tree().change_scene_to_packed(main_scene)


func _on_quit_button_down() -> void:
	get_tree().quit()
