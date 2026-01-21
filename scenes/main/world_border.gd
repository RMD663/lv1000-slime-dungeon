extends Area3D
class_name WorldBorder


func _ready() -> void:
	body_entered.connect(_body_entered)


func _body_entered(body : Node3D) -> void:
	if not body.is_in_group("Player"):
		body.queue_free()
	elif body is Enemy:
		body.die()
	elif body is Player:
		Helper.reset.emit()
