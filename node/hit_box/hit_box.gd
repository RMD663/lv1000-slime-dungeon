extends Area3D
class_name HitBox

@export var target : String = "None"

@export var damage : int = 1

@onready var parent : CharacterBody3D = owner

func _ready() -> void:
	body_entered.connect(_body_entered)

func _body_entered(body : Node3D) -> void:
	if body.is_in_group(target) and body.can_be_hurt:
		var data = parent.hurt_data
		data.knockback = parent.knockback
		data.direction = parent.global_position.direction_to(body.global_position)
		body.hurt(data)
		Helper.shake_camera.emit(0.2, 0.3)
