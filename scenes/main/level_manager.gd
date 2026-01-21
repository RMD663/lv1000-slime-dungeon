extends Node
class_name LevelManager

@export var main_scene : PackedScene 

var next_scene : PackedScene
var current_map : Node3D
func _ready() -> void:
	Helper.next_scene.connect(change_scene)
	var children : Array[Node] = get_children()
	if children.size() > 0:
		for child in children:
			child.queue_free.call_deferred()
	var scene_instance : Node3D = main_scene.instantiate()
	current_map = scene_instance
	add_child(scene_instance)

func change_scene(scene : PackedScene) -> void:
	var scene_instance : Node3D = scene.instantiate()
	add_child(scene_instance)
	current_map.remove()
	current_map = scene_instance
	Helper.reset.emit()
