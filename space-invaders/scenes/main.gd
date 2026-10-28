extends Node

const ALIEN_SCENE: PackedScene = preload("res://actors/alien.tscn")

@export var rows := 4
@export var cols := 8

var aliens: Array[Alien] = []

@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	var vs = get_viewport().size
	var top_left := Vector2(vs.x * 0.1, vs.y * 0.1)
	var x_offset = (vs.x * 0.8) / float(cols - 1)
	var y_offset = (vs.y / 2.5) / float(rows - 1)

	
	var current := top_left
	for row in rows:
		current.x = top_left.x
		for col in cols:
			var alien = ALIEN_SCENE.instantiate()
			alien.position = Vector2(current.x, current.y)
			alien.connect("died", on_alien_death)

			add_child(alien)
			aliens.append(alien)

			current.x += x_offset
		current.y += y_offset


func _on_attack_timer_timeout() -> void:
	if len(aliens) == 0: return

	var alien: Alien = aliens.pick_random()
	alien.shoot()


func on_alien_death(alien: Alien):
	var alien_index = aliens.find(alien)
	aliens.remove_at(alien_index)
