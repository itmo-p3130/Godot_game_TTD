class_name GroundState
extends State

func state_input(event : InputEvent):
	if (event.is_action_pressed("jump")):
		jump()
		
		
func jump():
	character.velocity.y = character.jump_velocity
