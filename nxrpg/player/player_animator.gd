class_name PlayerAnimator
extends RefCounted

var animator: AnimatedSprite2D

const IDLE := 'idle'
const RUN := 'run'
const ATTACK := 'attack'
const DASH := 'dash'

var current: String


func _init(anim_sprite: AnimatedSprite2D) -> void:
	animator = anim_sprite
	idle()


func set_dir(input: Vector2):
	if input.x < 0:
		animator.flip_h = true
	else:
		animator.flip_h = false


func run():
	play_animation(RUN)


func idle():
	play_animation(IDLE)


func attack():
	play_animation(ATTACK)


func dash():
	play_animation(DASH)


func play_animation(name: String) -> void:
	if current != name:
		current = name
		animator.play(name)
