extends Enemy


@export_category("Behavior")


func target_noticed_behavior(_delta: float, checkpoint: Vector2) -> void:
	# Finding distance to the target
	var distance = checkpoint - global_position

	# Finding direction to the target
	var direction = distance.normalized()

	# Moving towards the target on ground
	velocity = direction * movement_speed


func target_unnoticed_behavior(_delta: float, _checkpoint: Vector2) -> void:
	pass


func target_reached_behavior(_delta: float, _checkpoint: Vector2) -> void:
	pass


func target_unreachable_behavior(_delta: float, _checkpoint: Vector2) -> void:
	pass
