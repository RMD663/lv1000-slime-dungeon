extends Node
class_name Entities

@export var max_entities : int = 200

var splice_group_size : int = 50
var enemies : Array[Enemy] = []
var _counter : int = 0


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

func _physics_process(delta: float) -> void:
	process_enemy_physics()

func process_enemy_physics() -> void:
	var total : int = enemies.size()
	
	if total <= 0:
		return
	
	var total_groups : float = float(total) / float(splice_group_size)
	if total_groups < 1.0:
		total_groups = 1.0
	
	var iterations : int = min(splice_group_size, total)
	
	for i in range(iterations):
		if _counter >= total:
			_counter = 0
			return
	
		var enemy : Enemy = enemies[_counter]
		
		if is_instance_valid(enemy):
			var original_velocity : Vector3 = enemy.velocity
			enemy.velocity *= total_groups
			
			enemy.move_and_slide()
			
			enemy.velocity = original_velocity
			_counter += 1
		else:
			enemies.remove_at(_counter)
	

func add_entity(entity : CharacterBody3D) -> void:
	if not game_ended:
		if entity_ammount < max_entities and entity_ammount < current_enemies:
			entity_ammount += 1
			add_child(entity)
			entity.spawn()
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
	_counter = 0
	current_enemies = total_enemies
	entity_ammount = 0
	enemies.clear()
