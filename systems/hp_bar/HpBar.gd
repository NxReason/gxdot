extends CanvasLayer

var max_hp: float = 1000
var hp: float = 800

@onready var bar: ProgressBar = $ProgressBar
@onready var label: Label = $Label

func _ready() -> void:
	label.scale = Vector2.ONE / scale
	update_visual()

func setup(_max_hp: float, _hp: float):
	max_hp = _max_hp
	hp = _hp

func set_hp(value: float):
	hp = value
	update_visual()

func set_max(value: float):
	max_hp = value
	update_visual()

func update_visual():
	bar.value = hp
	bar.max_value = max_hp
	label.text = "%d / %d" % [hp, max_hp]
	label.position = Vector2(bar.size.x / 2 - label.size.x / 2, 10)


func _on_damage_timer_timeout() -> void:
	set_hp(hp - 20)
