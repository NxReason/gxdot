class_name Talent
extends Resource

@export var id: String
@export var name: String

@export var icon: Texture2D
@export var position: Vector2 = Vector2.ZERO
@export var prerequisites: Array[String] = []
