extends State
class_name PlayerIdleState

@export var animation : AnimationPlayer

@onready var player : Player = owner 

func on_ready() -> void:
	animation.play("idle", 0.2)

func process(_delta : float) -> void:
	if not player.is_on_floor():
		change_state("Fall")
	if player.player_is_moving():
		change_state("Move")
	if Input.is_action_just_pressed("attack"):
		change_state("Attack")

func physics_process(delta : float) -> void:
	player.stop(delta)

func on_exit() -> void:
	pass
