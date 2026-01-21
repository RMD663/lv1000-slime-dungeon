extends Area3D
class_name ChangeZone

@export var scene_to : PackedScene

func _ready() -> void:
	body_entered.connect(_body_entered)

func _body_entered(_body : Player) -> void:
	Helper.fade_out.emit()
	Helper.next_scene.emit(scene_to)
