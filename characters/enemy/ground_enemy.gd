extends Enemy


@export_category("Behavior")
@export var jump_speed: float
@export var jump_deviation: float = 0.75
@export var jump_activation_distance: float = 10
@export var jump_minimal_scaling_factor: float = 0.75


func target_noticed_behavior(delta: float, checkpoint: Vector2) -> void:
	# Finding distance to the target
	var distance = checkpoint - global_position

	# Finding direction to the target
	var direction = distance.normalized()

	# Moving towards the target on ground
	velocity.x = direction.x * movement_speed

	# If close enough to a target
	if distance.x < jump_activation_distance:
		# If further path avaliable only via jumping, then jump
		var angle = _compute_angle(checkpoint)
		if _compute_angle_deviation(angle) < jump_deviation and is_on_floor():
			velocity.y = _compute_jump_force(checkpoint)


func target_unnoticed_behavior(delta: float, checkpoint: Vector2) -> void:
	pass


func target_reached_behavior(_delta: float, _checkpoint: Vector2) -> void:
	velocity.x = 0


func target_unreachable_behavior(_delta: float, checkpoint: Vector2) -> void:
	# If got stuck, then jump
	if is_on_floor():
		velocity.y = _compute_jump_force(checkpoint)


func _compute_angle(point: Vector2) -> float:
	# Finding distance to a target
	var distance = point - global_position

	# Finding angle
	var angle = max(0, PI / 2 - acos(-distance.y / distance.length()))

	return angle


func _compute_angle_deviation(angle: float) -> float:
	# Finding deviation from PI/2
	var deviation = abs(angle - PI / 2)

	return deviation


func _compute_jump_force(point: Vector2) -> float:
	var angle = _compute_angle(point)
	var deviation = _compute_angle_deviation(angle)

	# Finding appropriate jump force
	var jump_scaling_factor = min(1, max(angle, jump_minimal_scaling_factor))
	var jump_force = -jump_speed * jump_scaling_factor

	return jump_force
