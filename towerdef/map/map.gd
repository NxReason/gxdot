extends Node2D

@onready var spawner: EnemySpawner = $EnemySpawner
@onready var tower_placer: TowerPlacer = $TowerPlacer

@onready var ground_tiles: TileMapLayer = $Ground
@onready var road_tiles: TileMapLayer = $Road

func _on_spawn_timer_timeout() -> void:
	var enemy := spawner.spawn()
	enemy.died.connect(on_enemy_death)


func on_enemy_death(enemy: Enemy) -> void:
	tower_placer.clear_dead_enemy(enemy)


func _on_tower_button_button_down() -> void:
	tower_placer.toggle()
