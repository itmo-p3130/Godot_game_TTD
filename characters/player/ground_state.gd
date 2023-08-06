class_name GroundState
extends AnimationState

func state_process(_delta):
	if !character.is_on_floor():
		next_state = falling_state

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()

func jump():
	character.velocity.y = character.jump_velocity
	next_state = jumping_state

func on_enter():
	if character.state_machine.jump_buffer_timer > 0:
		jump()
