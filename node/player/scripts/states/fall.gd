extends State
class_name PlayerFallState

@export var animation : AnimationPlayer
@export var fall_sfx : AudioStreamPlayer
@onready var player : Player = owner 

func on_ready() -> void:
	animation.play("fall", 0.0)
	fall_sfx.pitch_scale = Helper.random_pitch(0.7, 1.1)

func process(_delta : float) -> void:
	if not player.player_is_moving() and player.is_on_floor():
		fall_sfx.play()
		change_state("Idle")
	if player.player_is_moving() and player.is_on_floor():
		fall_sfx.play()
		change_state("Move")
	if Input.is_action_just_pressed("attack"):
		change_state("Attack")

func physics_process(delta : float) -> void:
	player.move(delta)
	player.apply_gravity(delta)

func on_exit() -> void:
	pass
