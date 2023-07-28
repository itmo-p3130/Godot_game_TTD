class_name GroundState
extends State

@export var air_state : State


func state_input(event : InputEvent):
	if (event.is_action_pressed("jump")):
		jump()
		
func jump():
	character.velocity.y = character.jump_velocity
	next_state = air_state
