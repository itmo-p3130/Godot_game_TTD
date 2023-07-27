class_name CharacterStateMachine
extends Node

var states : Array[State]

func _read():
	for child in get_children():
		if child is State:
			states.append(child)
		else:
			push_warning("Chiled " + child.name + " is not a State for CharacterStateMachine")
