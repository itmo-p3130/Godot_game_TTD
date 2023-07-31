class_name GroundState
extends State

func state_process(delta):
	if (!character.is_on_floor()):
		next_state = air_state

func state_input(event : InputEvent):
	if (event.is_action_pressed("jump")):
		jump()
		
func jump():
	character.velocity.y = character.jump_velocity
	next_state = air_state
	#playback.travel(jump_start_animation_name)

func on_enter():
	if character.state_machine.jump_buffer_timer > 0:
		jump()
