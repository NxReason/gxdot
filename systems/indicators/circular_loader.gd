extends Node2D

@export var show_cirlce: bool = true

func _process(delta: float) -> void:
	var accel = cos(Time.get_ticks_msec()) + 1.5
	rotate(deg_to_rad(270) * delta * accel)

func _draw() -> void:
	if show_cirlce:
		# draw_circle(Vector2(50, -50), 50, Color8(255, 0, 255))
		draw_arc(Vector2(0, 0), 50, deg_to_rad(0), deg_to_rad(60), 100, Color8(255, 0, 255), 10, true)
