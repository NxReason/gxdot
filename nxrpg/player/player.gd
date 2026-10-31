class_name Player
extends CharacterBody2D

@export var speed := 400.0
@export var health := 1000.0

enum State {
	FREE,
	ATTACK,
	DASH
}
var state := State.FREE

var animator: PlayerAnimator
var look_dir: Vector2
var hp_current: float = health

@onready var hp_bar: HealthBar = $HealthBar

func _ready() -> void:
	animator = PlayerAnimator.new($Animator)
	look_dir = Vector2.RIGHT
	hp_bar.setup(health, hp_current)


func _physics_process(_delta: float) -> void:
	dash()
	attack()
	move()


# Move
func move() -> void:
	if state != State.FREE: return

	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input == Vector2.ZERO:
		animator.idle()
		return

	state = State.FREE
	look_dir = input

	animator.set_dir(input)
	animator.run()

	velocity = input * speed
	move_and_slide()


# Dash
@export var dash_speed: float = 1000.0
func dash() -> void:
	# process current dash
	if state == State.DASH:
		velocity = look_dir * dash_speed
		move_and_slide()
		return

	# start new dash
	if Input.is_action_just_pressed("dash"):
		state = State.DASH
		animator.dash()

# Attack
@export var damage: float = 20.0
@onready var attack_cast: ShapeCast2D = $AttackCast
var attack_dir: Vector2

func attack() -> void:
	if state != State.FREE: return

	if Input.is_action_just_pressed("attack"):
		state = State.ATTACK
		attack_dir = look_dir
		animator.attack()


func check_hits():
	attack_cast.enabled = true
	attack_cast.force_shapecast_update()

	if attack_cast.is_colliding():
		var count = attack_cast.get_collision_count()
		for i in range(count):
			try_damage(i)

	attack_cast.enabled = false


func try_damage(index: int) -> void:
	var normal = attack_cast.get_collision_normal(index)
	var dot = normal.dot(attack_dir)
	if dot >= 0.0:
		return

	var collider = attack_cast.get_collider(index)
	if collider.has_method("take_damage"):
		collider.take_damage(damage)


# Taking damage
func take_damage(value: float) -> void:
	hp_current -= value
	hp_bar.update(hp_current)


# One-shot animations finish
func _on_animation_finished() -> void:
	if state == State.ATTACK:
		check_hits()

	if state in [State.ATTACK, State.DASH]:
		state = State.FREE
		animator.idle()
