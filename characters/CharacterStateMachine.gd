class_name CharacterStateMachine
extends Node

@export var current_state : State

var states : Array[State]

func _read():
	for child in get_children():
		if child is State:
			states.append(child)
		else:
			push_warning("Chiled " + child.name + " is not a State for CharacterStateMachine")

func check_if_can_move():
	return current_state.can_move
