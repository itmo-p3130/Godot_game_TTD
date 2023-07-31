class_name State
extends Node

@export var ground_state : State
@export var air_state : State
@export var landing_state : State

@export var can_move : bool = true

@export var jump_start_animation_name = "jump_start"
@export var jump_end_animation_name = "jump_end"
@export var double_jump_animation_name = "double_jump"

var character : CharacterBody2D
var next_state : State
var playback : AnimationNodeStateMachinePlayback

func state_process(delta):
	pass

func state_input(event : InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
