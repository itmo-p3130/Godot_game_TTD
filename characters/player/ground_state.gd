class_name GroundState
extends AnimationState

@export var air_state : AnimationState

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



