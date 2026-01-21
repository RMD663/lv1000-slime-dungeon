extends Node
class_name EnemyFiniteStateMachine

enum StateID {MOVE, FALL, ATTACK, HURT, DIE}

@export var states_map : Dictionary = {
	StateID.MOVE : EnemyState,
	StateID.FALL : EnemyState,
	StateID.ATTACK : EnemyState,
	StateID.HURT : EnemyState,
	StateID.DIE : EnemyState
	}

#current state
var current_state : EnemyState
#first state
var initial_state : EnemyState
#used when a state change occour
signal _state_changed(new_state : String)

#initialize the first child as the first state
func _ready() -> void:
	setup_states()

func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)

# Removes current state; if the new state is valid, swaps it with the current
func next_state(state_id : StateID) -> void:
	var new_state = get_state(state_id)
	if new_state:
		if current_state:
			current_state.on_exit()
		current_state = new_state
		current_state.on_ready()
	else:
		printerr("Invalid state ID: %d " % state_id)
		return

# Add all states to the list
func setup_states() -> void:
	for child in get_children():
		if child:
			child.fsm = self
			states_map.get_or_add(child.id, child)
	initial_state = states_map[0]
	current_state = initial_state
	current_state.on_ready()
	
# If the state exists, returns it; else, returns null
func get_state(state_id : StateID) -> EnemyState:
	return states_map.get(state_id)

#returns the name of the current running state
func get_current_state_name() -> String:
	return current_state.name.capitalize()
