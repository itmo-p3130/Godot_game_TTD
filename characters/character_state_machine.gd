class_name CharacterStateMachine
extends Node

@export var character : CharacterBody2D
@export var current_state : AnimationState
@export var animation_tree : AnimationTree

var states : Array[AnimationState]
var jump_buffer_timer : float = 0

func _process(delta):
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

func _ready():
	for child_state in get_children():
		if child_state is AnimationState:
			states.append(child_state)
			child_state.character = character
			child_state.playback = animation_tree["parameters/playback"]
		else:
			push_warning("Chiled " + child_state.name + " is not a AnimationState for CharacterStateMachine")

func _physics_process(delta):
	if (current_state.next_state != null):
		switch_states(current_state.next_state)
	current_state.state_process(delta)

func _input(event : InputEvent):
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = character.jump_buffer_time
	current_state.state_input(event)

func check_if_can_move():
	return current_state.can_move

func switch_states(new_state : AnimationState):
	if (current_state != null):
		current_state.on_exit()
		current_state.next_state = null
	current_state = new_state
	current_state.on_enter()
