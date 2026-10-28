class_name Player
extends CharacterBody2D

@export var speed: float = 400.0
@export var health: float = 1000.0

var shoot_cd: float = 1.0
var last_shot: float = - shoot_cd * 1000

const ROCKET_SCENE: PackedScene = preload("res://actors/rocket.tscn")
@onready var rocket_pos := $RocketPos


func _process(_delta: float) -> void:
	handle_shoot()


func _physics_process(_delta: float) -> void:
	handle_move()


# Movement
func handle_move():
	var dir := get_move_dir()
	if dir != 0.0:
		velocity.x = dir * speed
		move_and_slide()


func get_move_dir() -> float:
	var dir := 0.0
	if Input.is_action_pressed("move_right"):
		dir += 1
	if Input.is_action_pressed("move_left"):
		dir -= 1
	return dir


# Shooting
func handle_shoot():
	if !Input.is_action_just_pressed("shoot"):
		return

	if !(Time.get_ticks_msec() > last_shot + shoot_cd * 1000):
		return
	
	var rocket = ROCKET_SCENE.instantiate()
	rocket.position = rocket_pos.global_position
	get_tree().current_scene.add_child(rocket)
	last_shot = Time.get_ticks_msec()

# Taking Damage
func take_damage(val: float):
	health -= val
	print(health)
