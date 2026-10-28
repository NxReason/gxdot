extends Area2D

@export var speed: float = 600.0
@export var damage: float = 100.0

func _physics_process(delta: float) -> void:
	position.y += speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
		queue_free()
