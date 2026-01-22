extends ShapeCast3D
class_name HitArea

@export var player : Player 

func _hit() -> void:
	force_shapecast_update()
	var counter : int = get_collision_count()
	
	for body : int in range(counter):
		var enemy : Enemy = get_collider(body)
		enemy.hurt(player.hurt_data)
	
