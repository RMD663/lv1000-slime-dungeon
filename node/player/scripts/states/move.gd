extends State
class_name PlayerMoveState

@export var animation : AnimationPlayer
@export var trail : GPUParticles3D
@export var move_sfx : AudioStreamPlayer
@onready var player : Player = owner 

func on_ready() -> void:
	trail.emitting = true
	move_sfx.finished.connect(_move_sfx_finished)
	animation.play("move", 0.2)

func process(_delta : float) -> void:
	#trail.process_material.gravity.x = -player.velocity.x
	#trail.draw_pass_1.radius = player.scale.x / 8
	#trail.draw_pass_1.height = player.scale.x / 6
	
	if not player.is_on_floor():
		change_state("Fall")
	if not player.player_is_moving():
		change_state("idle")
	if Input.is_action_just_pressed("attack"):
		change_state("Attack")

func physics_process(delta : float) -> void:
	player.move(delta)

func on_exit() -> void:
	move_sfx.finished.disconnect(_move_sfx_finished)
	trail.emitting = false

func _move_sfx_finished() -> void:
	move_sfx.pitch_scale = Helper.random_pitch(0.8, 1.3)
