class_name Alien
extends Area2D

signal died(instance: Alien)

@export var health: float = 100.0

const PROJECTILE_SCENE: PackedScene = preload("res://actors/projectile.tscn")

@onready var collider: CollisionShape2D = $Collider
@onready var visual: Sprite2D = $Visual
const DEATH_SPRITE = preload("res://assets/explosion.PNG")

func take_damage(val: float):
	health -= val
	if health <= 0.0:
		die()

func die():
	died.emit(self)
	collider.set_deferred("disabled", true)
	visual.set_texture(DEATH_SPRITE)
	print(get_tree())
	await get_tree().create_timer(0.5).timeout
	queue_free()

func shoot():
	var proj = PROJECTILE_SCENE.instantiate()
	proj.position = position
	get_tree().current_scene.add_child(proj)