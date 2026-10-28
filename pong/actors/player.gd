class_name Player
extends CharacterBody2D


@export var speed = 500.0

@onready var visual: Polygon2D = $Visual
var height: float
var half_height: float

func _ready() -> void:
	height = visual.polygon[0].y - visual.polygon[3].y
	half_height = height / 2


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("up", "down")
	velocity.y = direction * speed

	move_and_collide(velocity * delta)

# return % offset of the given position from the center of player
func get_offset(other: Vector2) -> float:
	return clamp((other.y - position.y) / half_height, -1.0, 1.0)