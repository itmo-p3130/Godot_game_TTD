class_name CharacterStateMachine
extends Node

@export var character : CharacterBody2D
@export var current_state : State

var states : Array[State]

func _read():
	for child_state in get_children():
		if child_state is State:
			states.append(child_state)
			child_state.character = character
		else:
			push_warning("Chiled " + child_state.name + " is not a State for CharacterStateMachine")

func check_if_can_move():
	return current_state.can_move
