extends EnemyState
class_name EnemyMoveState

@export var navigation_node : NavigationNode3D

@export var animation : AnimationPlayer
@export var path_timer : Timer

@onready var enemy : Enemy = owner 

var timer_randon_time : float

func on_ready() -> void:
	timer_randon_time = randf_range(0.3, 1.0)
	path_timer.start(timer_randon_time)
	animation.play("move", 0.2)
	navigation_node.update_path()
	path_timer.start(timer_randon_time)
	navigation_node.update_path()
	navigation_node.navigation_finished.connect(_reached_player)

func process(_delta : float) -> void:
	if path_timer.is_stopped():
		navigation_node.update_path()
		path_timer.start()


func physics_process(delta : float) -> void:
	if not enemy.is_on_floor():
		change_state(fsm.StateID.FALL)
	if navigation_node.is_target_reachable() and enemy.player_alive:
		navigation_node.navigate(delta)

func on_exit() -> void:
	navigation_node.navigation_finished.disconnect(_reached_player)

func _reached_player() -> void:
	change_state(fsm.StateID.ATTACK)
