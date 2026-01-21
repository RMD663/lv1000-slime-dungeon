extends Area3D
class_name EffectHitBox

@export var parent : PickUpArea3D

var hurt_data : HurtData

func _ready() -> void:
	if parent:
		hurt_data = parent.hurt_data
		parent.player_picked_up.connect(_explode)


func _explode() -> void:
	var bodies = get_overlapping_bodies()

	for body : Enemy in bodies:
		hurt_data.direction = parent.global_position.direction_to(body.global_position)
		body.hurt(hurt_data)
