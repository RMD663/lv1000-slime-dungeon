extends EnemyState
class_name EnemyDieState

@export var animation : AnimationPlayer

@onready var enemy : Enemy = owner 

func on_ready() -> void:
	Helper.entity_died.emit()
	enemy.can_be_hurt = false
	animation.play("die", 0.0)
	enemy.fly_away()
	await animation.animation_finished
	enemy.drop()
	await get_tree().create_timer(1).timeout
	enemy.die()

func physics_process(delta : float) -> void:
	enemy.move(delta)

func on_exit() -> void:
	animation.animation_finished.disconnect(_animation_finished)


func _animation_finished(_anim_name : String) -> void:
	enemy.die()
