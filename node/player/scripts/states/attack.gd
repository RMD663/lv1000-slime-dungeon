extends State
class_name PlayerAttackState

@export var animation : AnimationPlayer
@export var attack_sfx: AudioStreamPlayer
@onready var player : Player = owner 
@export var hit_particles: GPUParticles3D

func on_ready() -> void:
	hit_particles.emitting = true
	animation.animation_finished.connect(_animation_finished)
	attack_sfx.pitch_scale = Helper.random_pitch(1.3, 1.7)
	animation.play("attack", 0.2)


func physics_process(delta : float) -> void:
	player.stop(delta)
	player.apply_gravity(delta)

func on_exit() -> void:
	animation.animation_finished.disconnect(_animation_finished)
	hit_particles.emitting = false

func _animation_finished(anim_name : String) -> void:
	if not player.is_on_floor():
		change_state("Fall")
	if player.player_is_moving():
		change_state("Move")
	if not player.player_is_moving():
		change_state("Idle")
