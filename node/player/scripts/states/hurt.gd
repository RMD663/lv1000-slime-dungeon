extends State

@export var animation : AnimationPlayer

@onready var player : Player = owner 
@onready var hit_sfx: AudioStreamPlayer = $"../../Effects/HitSfx"

func on_ready() -> void:
	hit_sfx.pitch_scale = Helper.random_pitch(0.8, 1.2)
	hit_sfx.play()
	animation.play("hurt", 0.0)
	animation.animation_finished.connect(_animation_finished)
	is_dead()

func on_exit() -> void:
	animation.animation_finished.disconnect(_animation_finished)
	player.can_be_hurt = true

func _animation_finished(_anim_name : String) -> void:
	change_state("Move")

func is_dead() -> void:
	if player.health <= 0:
		change_state("Die")
