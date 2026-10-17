extends Node

var current_score: int = 0

func _ready() -> void:
	pass # Replace with function body.


func _on_board_score_increased(by_amount: int) -> void:
	set_score(current_score + by_amount)


func set_score(value: int):
	current_score = value
	$ScoreLabel.text = "Score: " + str(value)