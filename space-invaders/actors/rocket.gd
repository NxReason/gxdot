extends Area2D

@export var speed := 600.0
@export var damage := 120.0


func _physics_process(delta: float) -> void:
	position.y -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Alien:
		area.take_damage(damage)
	queue_free()