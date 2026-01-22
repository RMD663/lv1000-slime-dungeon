extends Marker3D
class_name EnemySpawner

@export var enemies : Array[PackedScene]
@export var timer : Timer 
@export var increment_timer : Timer

var entities_node : Entities

func _ready() -> void:
	Helper.reset.connect(_reset)
	increment_timer.timeout.connect(_increment_timeout)
	timer.timeout.connect(_timeout)
	timer.start()
	increment_timer.start()
	entities_node = Helper.get_enemy_spanwer()

func spawn_random() -> void:
	var enemy : Enemy = enemies.pick_random().instantiate()
	enemy.spawn_position = self.global_position
	entities_node.add_entity(enemy)

func _timeout() -> void:
	spawn_random()
	timer.start()

func _increment_timeout() -> void:
	if timer.wait_time > 0.5:
		timer.wait_time -= 0.3
	
	increment_timer.start()

func _reset() -> void:
	timer.wait_time = 3.0
	timer.start()
	increment_timer.start()
