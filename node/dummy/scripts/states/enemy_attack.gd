extends EnemyState
class_name EnemyAttackState

@export var animation : AnimationPlayer
@export var hurt_sfx: AudioStreamPlayer

var attack_animations : Array[String] = ["squash", "attack"]


@onready var enemy : Enemy = owner 

func on_ready() -> void:
	if not enemy.player_alive:
		change_state(fsm.StateID.MOVE)
	
	hurt_sfx.pitch_scale = Helper.random_pitch(0.6, 0.9)
	hurt_sfx.play()
	
	animation.play(attack_animations.pick_random(), 0.0)
	animation.animation_finished.connect(_animation_finished)

func on_exit() -> void:
	if animation.animation_finished.is_connected(_animation_finished):
		animation.animation_finished.disconnect(_animation_finished)

func _animation_finished(_anim_name : String) -> void:
	change_state(fsm.StateID.MOVE)

func is_dead() -> void:
	if enemy.health <= 0:
		change_state(fsm.StateID.DIE)
