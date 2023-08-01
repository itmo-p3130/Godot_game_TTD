class_name FallingState
extends State

var coyote_timer : float = 0

func _process(delta):
	if coyote_timer > 0:
		coyote_timer -= delta

func state_process(delta):
	if character.is_on_floor():
		next_state = landing_state

func state_input(event):
	if event.is_action_pressed("jump") && coyote_timer > 0:
		jump()

func on_exit():
	if (next_state == landing_state):
		playback.travel(jump_end_animation_name)

func on_enter():
	coyote_timer = character.coyote_time
	playback.travel(jump_start_animation_name)


func jump():
	character.velocity.y = character.jump_velocity
	next_state = jumping_state
