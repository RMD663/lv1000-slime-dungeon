extends NavigationAgent3D
class_name NavigationNode3D

@export var movement_speed : float = 1.0
@export var acceleration : float = 0.5
var movement_target : CharacterBody3D = null

@onready var body : CharacterBody3D = owner

func _ready() -> void:
	movement_target = get_tree().get_first_node_in_group("Player")
	path_desired_distance = 0.5
	target_desired_distance = 0.5

	setup.call_deferred()

func setup() -> void:
	await get_tree().physics_frame
	
	if movement_target:
		set_path(movement_target.global_position)

func update_path() -> void:
	if movement_target:
		set_path(movement_target.global_position)

func set_path(target : Vector3) -> void:
	var random_offset : float = randf_range(-1, 1)
	target.x += random_offset
	target.z += random_offset
	target.y = body.global_position.y
	set_target_position(target)

func navigate() -> void:
	var current_agent_position: Vector3 = body.global_position
	var next_path_position: Vector3 = get_next_path_position()
	var navigation_point_direction : Vector3 =  current_agent_position.direction_to(next_path_position).normalized()
	var desired_velocity : Vector3 = navigation_point_direction * movement_speed
	body.velocity.x = lerp(velocity.x, desired_velocity.x * movement_speed, acceleration * get_physics_process_delta_time())
	body.velocity.z = lerp(velocity.z, desired_velocity.z * movement_speed, acceleration * get_physics_process_delta_time())
