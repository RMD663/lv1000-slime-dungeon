extends Node
class_name Entities

@export var max_entities : int = 100

var entity_ammount : int = 0
var paused : bool = false
var game_ended : bool = false
var current_enemies : int = 0
const total_enemies : int = 250

func _ready() -> void:
	current_enemies = total_enemies
	Helper.reset.connect(_reset)
	Helper.entity_died.connect(_entity_died)
	Helper.pause.connect(_pause)

func add_entity(entity : CharacterBody3D) -> void:
	if not game_ended:
		if entity_ammount < max_entities and entity_ammount < current_enemies:
			entity_ammount += 1
			add_child(entity)
			entity.spawn()


func _entity_died() -> void:
	entity_ammount -= 1
	current_enemies -= 1
	if current_enemies <= 0:
		game_ended = true
		Helper.ended.emit()

func _pause() -> void:
	if process_mode == ProcessMode.PROCESS_MODE_DISABLED:
		process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		process_mode = Node.PROCESS_MODE_DISABLED

func _reset() -> void:
	for enemy in get_children():
		if enemy is Enemy:
			enemy._die()
	current_enemies = total_enemies
	entity_ammount = 0
	
