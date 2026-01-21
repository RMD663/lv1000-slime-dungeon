extends Node
class_name State

var fsm : FiniteStateMachine

#executes when entering the state
func on_ready() -> void:
	pass

#state process
func process(_delta : float) -> void:
	pass

#state physics process
func physics_process(_delta : float) -> void:
	pass

#executes when exiting this state
func on_exit() -> void:
	pass

#change the current state with the new one and calls on_exit
func change_state(new_state : String) -> void:
	fsm.next_state(new_state)
