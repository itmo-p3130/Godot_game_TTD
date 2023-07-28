class_name AirState
extends State

@export var ground_state : State


func state_process(delta):
	if (character.is_on_floor()):
		next_state = ground_state
