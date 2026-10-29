class_name HPBar
extends Panel

@onready var hp: ColorRect = $HP
@onready var timer: Timer = $Timer

var hp_max: float = 1000
var hp_curr: float = 850
var hp_perc: float = hp_curr / hp_max

@onready var bar_max_width = size.x - 20


func _ready() -> void:
	update_hp()
	timer.start()


func update_hp() -> void:
	hp_perc = hp_curr / hp_max
	hp.size.x = hp_perc * bar_max_width


func _on_timer_timeout() -> void:
	hp_curr -= 50
	update_hp()
