class_name HealthBar
extends Node2D

@onready var progress: ProgressBar = $ProgressBar

func setup(max_hp: float, current_hp: float):
	progress.max_value = max_hp
	progress.value = current_hp


func update(hp: float):
	progress.value = hp
