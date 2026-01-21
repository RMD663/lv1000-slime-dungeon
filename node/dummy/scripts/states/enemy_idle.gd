extends State
class_name EnemyIdleState

@export var navigation_node : NavigationNode3D

@export var animation : AnimationPlayer
@export var path_timer : Timer

@onready var enemy : Enemy = owner 

var timer_randon_time : float

func on_ready() -> void:
	timer_randon_time = randf_range(0.3, 1.0)
	path_timer.start(timer_randon_time)
	path_timer.timeout.connect(_timeout)
	animation.play("move", 0.2)
	navigation_node.update_path()
	navigation_node.navigation_finished.connect(_reached_player)

func physics_process(_delta : float) -> void:
	if navigation_node.is_target_reachable() and enemy.player_alive:
		navigation_node.navigate()

func on_exit() -> void:
	navigation_node.navigation_finished.disconnect(_reached_player)
	path_timer.timeout.disconnect(_timeout)

func _timeout() -> void:
	navigation_node.update_path()
	path_timer.start(timer_randon_time)

func _reached_player() -> void:
	change_state("Attack")
