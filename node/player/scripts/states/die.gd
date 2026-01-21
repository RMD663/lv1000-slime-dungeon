extends State
class_name PlayerDieState

@export var animation : AnimationPlayer

@onready var player : Player = owner 
@onready var defeat_sfx: AudioStreamPlayer = $"../../Effects/DefeatSFX"
@onready var boom_sfx: AudioStreamPlayer = $"../../Effects/BoomSFX"
@onready var die_particles: GPUParticles3D = $"../../Body/DieParticles"

func on_ready() -> void:
	die_particles.emitting = true
	player.is_dead = true
	Helper.player_died.emit()
	defeat_sfx.pitch_scale = Helper.random_pitch(0.8, 1.3)
	boom_sfx.pitch_scale = Helper.random_pitch(1.2, 1.7)
	
	defeat_sfx.play()
	boom_sfx.play()
	
	player.can_move = false
	player.can_be_hurt = false
	animation.play("die", 0.0)
	animation.animation_finished.connect(_animation_finished)
	player.velocity = Vector3.ZERO

func on_exit() -> void:
	animation.animation_finished.disconnect(_animation_finished)
func _animation_finished(_anim_name : String) -> void:
	Helper.reset.emit()
