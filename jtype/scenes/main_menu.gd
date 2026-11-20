extends Node

func _on_play_button_button_down() -> void:
	SceneManager.load_game()


func _on_dict_button_button_down() -> void:
	SceneManager.load_dict()


func _on_exit_button_button_down() -> void:
	get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
