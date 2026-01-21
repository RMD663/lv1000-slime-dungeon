extends EnemyState
class_name EnemyHurtState

@export var hits_sfx : Array[AudioStreamPlayer]
@export var animation : AnimationPlayer

@onready var enemy : Enemy = owner 

var sfx : AudioStreamPlayer

func on_ready() -> void:
	sfx = hits_sfx.pick_random()
	sfx.pitch_scale = Helper.random_pitch(0.8, 1.2)
	sfx.play()
	animation.play("hurt", 0.0)
	animation.animation_finished.connect(_animation_finished)
	is_dead()

func on_exit() -> void:
	animation.animation_finished.disconnect(_animation_finished)

func _animation_finished(_anim_name : String) -> void:
	if not enemy.is_on_floor():
		change_state(fsm.StateID.FALL)
	change_state(fsm.StateID.MOVE)

func is_dead() -> void:
	if enemy.health <= 0:
		change_state(fsm.StateID.DIE)
