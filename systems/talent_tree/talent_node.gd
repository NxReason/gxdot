class_name TalentNode
extends Control

signal selected

@onready var bg: Panel = $BG

func _ready() -> void:
	update_tint()

# Getters / setters
var input: Vector2:
	get:
		return Vector2(position.x + bg.size.x / 2, position.y + 3)

var output: Vector2:
	get:
		return Vector2(position.x + bg.size.x / 2, position.y + bg.size.y - 3)


func set_resource(talent: Talent):
	set_icon(talent.icon)
	set_label(talent.name)
	position = talent.position


@onready var icon: TextureRect = $BG/Icon
func set_icon(value: Texture2D):
	icon.texture = value


@onready var label: Label = $BG/Label
func set_label(value: String):
	label.text = value


# State handling
enum State {
	LOCKED,
	AVAILABLE,
	TAKEN
}

var state: State = State.LOCKED:
	set(value):
		state = value
		update_tint()

func set_locked():
	state = State.LOCKED

func set_available():
	state = State.AVAILABLE

func set_taken():
	state = State.TAKEN

const LOCKED_COLOR: Color = Color8(120, 120, 120)
const AVAILABLE_COLOR: Color = Color8(133, 204, 133)
const TAKEN_COLOR: Color = Color8(255, 255, 255)

func update_tint():
	match state:
		State.LOCKED: modulate = LOCKED_COLOR
		State.AVAILABLE: modulate = AVAILABLE_COLOR
		_: modulate = TAKEN_COLOR


func _on_bg_gui_input(event: InputEvent) -> void:
	if state != State.AVAILABLE:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected.emit()
