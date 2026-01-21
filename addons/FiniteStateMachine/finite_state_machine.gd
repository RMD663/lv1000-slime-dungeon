extends Node
class_name FiniteStateMachine

#stores all the child states of the fsm
var states : Dictionary

#current state
var current_state : State
#first state
var initial_state : State

#used when a state change occour
signal _state_changed(new_state : String)

#initialize the first child as the first state
func _ready() -> void:
	setup_states()
	initial_state = get_child(0)
	current_state = initial_state
	current_state.on_ready()

func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)

# Removes current state; if the new state is valid, swaps it with the current
func next_state(state : String) -> void:
	var new_state = get_state(state.to_lower())
	if new_state:
		if current_state:
			current_state.on_exit()
		current_state = new_state
		current_state.on_ready()
	else:
		printerr("Invalid state: " + state)
		return
	
	emit_signal("_state_changed", state)

# Add all states to the list
func setup_states() -> void:
	for child in get_children():
		if child is State:
			child.fsm = self
			states.get_or_add(child.name.to_lower(), child)

# If the state exists, returns it; else, returns null
func get_state(state_name : String) -> State:
	return self.states.get(state_name.to_lower()) if self.states.has(state_name.to_lower()) else null

#returns the current running state
func get_current_state() -> String:
	return current_state.name.capitalize()
