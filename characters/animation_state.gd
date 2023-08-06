class_name AnimationState
extends Node

@export var ground_state : AnimationState
@export var landing_state : AnimationState
@export var falling_state : AnimationState
@export var jumping_state : AnimationState

@export var can_move : bool = true

@export var jump_start_animation_name = "jump_start"
@export var jump_end_animation_name = "jump_end"
@export var double_jump_animation_name = "double_jump"

var character : CharacterBody2D
var next_state : AnimationState
var playback : AnimationNodeStateMachinePlayback

func state_process(_delta):
	pass

func state_input(_event: InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
