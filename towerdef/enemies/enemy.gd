class_name Enemy
extends PathFollow2D

signal escaped
signal died(enemy: Enemy)

@export var speed: float = 100.0
@export var health: float = 1000.0

@onready var path_length = get_parent().curve.get_baked_length()

func _process(delta: float) -> void:
	progress += speed * delta

	if progress >= path_length:
		escaped.emit()
		queue_free()


func take_damage(value: float) -> void:
	health -= value
	if health <= 0.0:
		die()


func die():
	died.emit(self)
	queue_free()
