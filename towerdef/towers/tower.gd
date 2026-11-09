class_name Tower
extends Node2D

@export var proj_scene: PackedScene

@onready var proj_origin: Marker2D = $ProjectileOrigin

var enemies: Array[Enemy] = []
var target: Enemy

func _on_detection_area_entered(area: Area2D) -> void:
	var enemy = try_cast_enemy(area)
	if enemy:
		enemies.append(enemy)
		select_target()


func _on_detection_area_exited(area: Area2D) -> void:
	var enemy = try_cast_enemy(area)
	remove_enemy(enemy)


func remove_enemy(enemy: Enemy) -> void:
	if not enemy:
		return
	var index = enemies.find(enemy)
	if index >= 0:
		enemies.remove_at(index)
		select_target()


func try_cast_enemy(area: Area2D) -> Enemy:
	if not area.get_parent():
		return null
	return area.get_parent() as Enemy


func select_target():
	target = enemies[0] if enemies.size() > 0 else null

func _on_attack_cooldown_timeout() -> void:
	if not target:
		return
	
	var proj = proj_scene.instantiate() as Projectile
	proj.position = proj_origin.global_position
	proj.target = target
	get_tree().root.add_child(proj)
