class_name Projectile
extends Area2D


@export var speed: float = 100.0
@export var damage: float = 300.0
@export var rotation_angle_offset: float = PI / 2

@onready var visual: Sprite2D = $Visual

var target: Enemy
var direction: Vector2

func _process(delta: float) -> void:
	if not target:
		queue_free()
		return
	
	direction = (target.global_position - global_position).normalized()
	rotation = direction.angle() + rotation_angle_offset
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().take_damage(damage)
		queue_free()
