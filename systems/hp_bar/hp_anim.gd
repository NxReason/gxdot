extends Panel

@onready var bar: ColorRect = $Bar
@onready var timer: Timer = $Timer

var hp_max: float = 1000
var hp_curr: float = 800
var hp_perc = hp_curr / hp_max

@export var decay_duration: float = 0.5
var decay_left: float = 0.0
var hp_decay: float = 0.0

@onready var bar_max_width = size.x - 20

func _ready() -> void:
	update_hp()
	timer.start()

func _process(delta: float) -> void:
	if decay_left > 0.0:
		decay_left = clamp(decay_left - delta, 0.0, decay_duration)
		update_hp()

func update_hp() -> void:
	hp_perc = hp_curr / hp_max
	var decay_left_perc = decay_left / decay_duration
	var decay_perc = hp_decay * decay_left_perc / hp_max
	bar.size.x = hp_perc * bar_max_width + decay_perc * bar_max_width


func set_current(val: float) -> void:
	if val < hp_curr:
		hp_decay = hp_curr - val
		decay_left = decay_duration
	hp_curr = val


# Signals
func _on_timer_timeout() -> void:
	set_current(hp_curr - 50)
	update_hp()
