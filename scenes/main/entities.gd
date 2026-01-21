extends Node
class_name Entities

@export var max_entities : int = 100

var enemies : Array[Enemy]
var enemie_counter : int = 0

@export var enemies_per_frame : int = 25

var entity_ammount : int = 0
var paused : bool = false
var game_ended : bool = false
var current_enemies : int = 0
const total_enemies : int = 500

func _ready() -> void:
	current_enemies = total_enemies
	Helper.reset.connect(_reset)
	Helper.entity_died.connect(_entity_died)
	Helper.pause.connect(_pause)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	update_enemies()

func update_enemies() -> void:
	var total : int = enemies.size()
	
	for i in range(total):
		if total == 0:
			return
		if enemie_counter >= total:
			enemie_counter = 0
			return
		var enemy : Enemy = enemies[enemie_counter]
		if is_instance_valid(enemy):
			enemy.move_and_slide()
			enemie_counter += 1
		else:
			enemies.erase(enemie_counter)
func add_entity(entity : CharacterBody3D) -> void:
	if not game_ended:
		if entity_ammount < max_entities and entity_ammount < current_enemies:
			entity_ammount += 1
			add_child(entity)
			entity.spawn()
			if entity.is_in_group("Enemy"):
				enemies.append(entity)


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
	
