class_name Orc
extends CharacterBody2D

@export var health: float = 100.0
@export var speed: float = 200.0
@export var damage: float = 100.0
@export var chase_limit: float = 200.0
@export var attack_range: float = 40.0

@onready var initial_pos: Vector2 = position
@onready var animator: AnimatedSprite2D = $Animator
@onready var attack_cast: ShapeCast2D = $AttackCast
@onready var attack_timer: Timer = $AttackDelay

var target: Player = null

func _ready() -> void:
	animator.play()


func _physics_process(_delta: float) -> void:
	match state:
		State.CHASE: chase()
		State.RETREAT: retreat()
		_: return


func chase():
	if (target.position - initial_pos).length() > chase_limit:
		begin_retreat()
		return

	var move_v = target.position - position
	flip_sprite(move_v)

	if move_v.length() < attack_range:
		begin_attack()
		return

	velocity = move_v.normalized() * speed
	move_and_slide()


func retreat():
	var move_v = initial_pos - position
	if move_v.length() < 3:
		end_retreat()
	else:
		velocity = (initial_pos - position).normalized() * speed
		move_and_slide()


# Attack
var attack_dir: Vector2

func attack():
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
	if collider is Player:
		collider.take_damage(damage)


# Visual
func flip_sprite(move_vector: Vector2):
	if move_vector.x < 0.0:
		animator.flip_h = true
	else:
		animator.flip_h = false


# Outside use
func take_damage(value: float) -> void:
	health -= value
	print('Orc health: ', health)


# Signal handlers
func _on_detection_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	begin_chase(body)


func _on_animator_animation_finished() -> void:
	if state != State.ATTACK:
		return

	end_attack()


func _on_attack_delay_timeout() -> void:
	attack()


# Animations
const ANIM_IDLE = 'idle'
const ANIM_RUN = 'run'
const ANIM_ATTACK = 'attack'


func play_animation(anim_name: String):
	if animator.animation != anim_name:
		animator.play(anim_name)


func play_oneshot(anim_name: String):
	animator.play(anim_name)


# State management
enum State {
	IDLE,
	CHASE,
	RETREAT,
	ATTACK
}
var state: State

func begin_chase(t):
	state = State.CHASE
	target = t
	play_animation(ANIM_RUN)

func begin_retreat():
	state = State.RETREAT
	target = null
	play_animation(ANIM_RUN)
	flip_sprite(initial_pos - position)

func end_retreat():
	state = State.IDLE
	position = initial_pos
	play_animation(ANIM_IDLE)
	animator.flip_h = false

func begin_attack():
	state = State.ATTACK
	play_oneshot(ANIM_ATTACK)
	attack_dir = target.position - position
	attack_timer.start()

func end_attack():
	# retreat
	if (target.position - initial_pos).length() > chase_limit:
		begin_retreat()
		return

	# next attack
	if (target.position - position).length() < attack_range:
		# another attack
		flip_sprite(target.position - position)
		begin_attack()
	else:
		# continue chasing the same target
		begin_chase(target)
