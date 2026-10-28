class_name Ball
extends CharacterBody2D

signal round_end(winner: int)

@export var speed := 600.0
@export var angle_range := PI / 2.5
@export var start_pos := Vector2(500, 300)

var h_dir: int = -1

func _init() -> void:
	velocity = Vector2(-1, 0)
	position = start_pos

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * speed * delta)

	if not collision:
		return

	var collider = collision.get_collider()
	# player
	if collider is Player:
		var offset = collider.get_offset(position)
		var angle = angle_range * offset
		h_dir = - h_dir
		velocity = Vector2(h_dir * cos(angle), sin(angle))
	# wall
	else:
		velocity.y = - velocity.y


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print(start_pos)
	if (position.x < start_pos.x):
		round_end.emit(2)
	if (position.x > start_pos.x):
		round_end.emit(1)
	queue_free()
