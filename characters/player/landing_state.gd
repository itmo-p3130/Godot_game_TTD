class_name LandingState
extends AnimationState

func _on_animation_tree_animation_finished(anim_name):
	if (anim_name == jump_end_animation_name):
		next_state = ground_state

func on_enter():
	pass

