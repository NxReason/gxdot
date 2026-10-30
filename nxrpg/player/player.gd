extends CharacterBody2D

@export var speed := 400.0

var animator: PlayerAnimator

enum State {
	FREE,
	ATTACK,
	DASH
}
var state := State.FREE

var look_dir: Vector2

func _ready() -> void:
	animator = PlayerAnimator.new($Animator)
	look_dir = Vector2.RIGHT


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
func attack() -> void:
	if state != State.FREE: return

	if Input.is_action_just_pressed("attack"):
		state = State.ATTACK
		animator.attack()


func _on_animation_finished() -> void:
	if state in [State.ATTACK, State.DASH]:
		state = State.FREE
		animator.idle()
