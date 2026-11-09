class_name EnemySpawner
extends Node

@export var enemy_scene: PackedScene
@export var path: Path2D

func spawn() -> Enemy:
	var enemy := enemy_scene.instantiate()
	enemy.progress = 0.0
	path.add_child(enemy)
	return enemy
