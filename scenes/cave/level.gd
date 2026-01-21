extends Node3D
class_name Level

@export var camera_marker : Marker3D = null
@export var is_camera_locked : bool = true
@export var camera_offset : float = 1.0
@export var lock_v_movement : bool = true

var camera : GameCamera = null

func _ready() -> void:
	setup()
	if not camera:
		camera = Helper.get_camera()
		camera.locked = is_camera_locked
		camera.lock_v_movement = lock_v_movement
		camera.target = camera_marker.global_position
		camera.rotation = camera_marker.rotation
		camera.v_offset = camera_offset


func remove() -> void:
	for child in get_children():
		child.queue_free.call_deferred()

func setup() -> void:
	pass
