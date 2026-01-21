extends EnemyState
class_name EnemyFallState


@export var navigation_node : NavigationNode3D

@export var animation : AnimationPlayer
@export var path_timer : Timer

@onready var enemy : Enemy = owner 

var timer_randon_time : float

func on_ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func physics_process(delta : float) -> void:
	if enemy.is_on_floor():
		change_state(fsm.StateID.MOVE)
	enemy.apply_gravity(delta)

func on_exit() -> void:
	pass
