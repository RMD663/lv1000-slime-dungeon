extends Area3D
class_name PickUpArea3D

@export var target : String = "None"
@export var effect_data : EffectData
@export var damage : int = 1
@export var material : BaseMaterial3D
@export var sfx : AudioStreamPlayer
@export var debris_particles : GPUParticles3D
@export var fire_particles : GPUParticles3D
@export var hurt_data : HurtData

var rand_color : Color
var timer : Timer
signal player_picked_up

@onready var mesh_instance_3d: MeshInstance3D = $"../MeshInstance3D"
@onready var parent : RigidBody3D = owner

func _ready() -> void:
	# Codigo muito foda :p
	timer = Timer.new()
	add_child(timer)
	timer.start(5)
	timer.timeout.connect(_die)
	# -------------------------
	Helper.reset.connect(_reset)
	mesh_instance_3d.set_surface_override_material(0, material)
	body_entered.connect(_body_entered)
	

func _body_entered(body : Player) -> void:
	call_deferred("apply_monitoring")
	if body.is_in_group(target):
		player_picked_up.emit()
		self.hide()
		if sfx:
			sfx.pitch_scale = Helper.random_pitch(0.9, 1.2)
			sfx.play()
		if debris_particles:
			debris_particles.emitting = true
		if fire_particles:
			fire_particles.emitting = true
		Helper._frame_freeze(effect_data.timescale, effect_data.screen_freeze_duration)
		Helper.shake_camera.emit(effect_data.screen_shake, effect_data.screen_shake_duration)
		body.apply_effect(effect_data)
		await get_tree().create_timer(1.0).timeout
		parent.queue_free.call_deferred()

func _reset() -> void:
	parent.queue_free.call_deferred()

func _die() -> void:
	owner.queue_free.call_deferred()

func apply_monitoring() -> void:
	monitoring = false
