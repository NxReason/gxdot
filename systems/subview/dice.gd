extends Node3D

@onready var model: Node3D = $Pivot

@export var accel: float = 3

func _process(delta: float) -> void:
	# model.rotate_x(deg_to_rad(randf_range(45, 90) * accel) * delta)
	model.rotate_y(deg_to_rad(randf_range(45, 90) * accel) * delta)
	model.rotate_z(deg_to_rad(randf_range(45, 90) * accel) * delta)
