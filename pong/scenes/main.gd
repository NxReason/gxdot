class_name MainScene
extends Node

@export var ball: PackedScene
var current_ball: Ball

@onready var score_label: Label = $HUD/Score

var score_count: Vector2 = Vector2(0, 0)

enum State {
	PAUSE,
	PLAY
}
var state: State = State.PAUSE
var pause_duration: float = 1.5
var pause_left: float = pause_duration

func _ready() -> void:
	update_score()


func _process(delta: float) -> void:
	match state:
		State.PAUSE: process_pause(delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func process_pause(delta: float):
	pause_left -= delta
	if pause_left < 0.0:
		start_play()


func start_play():
	state = State.PLAY
	pause_left = pause_duration
	score_label.visible = false
	current_ball = ball.instantiate()
	add_child(current_ball)
	current_ball.round_end.connect(_on_round_end)


func _on_round_end(winner: int) -> void:
	match winner:
		1: score_count.x += 1
		2: score_count.y += 1
		_: print('Invalid winner value')
	state = State.PAUSE
	update_score()
	score_label.visible = true


func update_score():
	score_label.text = "%d : %d" % [score_count.x, score_count.y]
