class_name AirState
extends AnimationState

var can_double_jump = false
var double_jump_timer = Timer.new()

func _ready():
	add_child(double_jump_timer)
	double_jump_timer.one_shot = true
	double_jump_timer.timeout.connect(_on_double_jump_timeout)

func _on_double_jump_timeout():
	can_double_jump = false

func state_process(_delta):
	if character.is_on_floor():
		next_state = landing_state

func state_input(event : InputEvent):
	if (event.is_action_pressed("jump") && can_double_jump):
		double_jump()

func on_exit():
	can_double_jump = false
	if (next_state == landing_state):
		playback.travel(jump_end_animation_name)

func on_enter():
	can_double_jump = true
	playback.travel(jump_start_animation_name)
	double_jump_timer.wait_time = character.double_jump_wait_time_sec
	double_jump_timer.start()

func double_jump():
	can_double_jump = false
	character.velocity.y = character.double_jump_velocity
	playback.travel(double_jump_animation_name)

