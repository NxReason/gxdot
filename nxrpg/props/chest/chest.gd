extends StaticBody2D

@onready var loot: LootTable = LootTable.new()
@onready var animator: AnimatedSprite2D = $Animator


const ANIM_OPEN = 'open'


func open():
	animator.play(ANIM_OPEN)
	print(loot.gen_common_loot())


func _on_animator_animation_finished() -> void:
	queue_free()


func _on_loot_area_body_entered(body: Node2D) -> void:
	if body is Player:
		# open()
		pass
