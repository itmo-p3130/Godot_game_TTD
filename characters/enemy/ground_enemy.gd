extends Enemy


@export_category("Behavior")
@export var movement_speed: float =  300.0
@export var jump_velocity: float = -400.0
@export var jump_deviation: float = 0.1
@export var inactive_distance: float = 20
@export var jump_activation_distance: float = 10
@export var jump_minimal_velocity: float = 0.5
@export var standing_distance: float = 0.5


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var prev_position = Vector2(0, 0)


func target_noticed_behavior(delta: float, checkpoint: Vector2) -> void:
	# Finding distance to the target
	var distance = checkpoint - global_position
	
	# If we reached target or cannot do it, then stop
	#if ((not navigation_agent.is_target_reachable()) or
	#	(navigation_agent.distance_to_target() < inactive_distance)):
	#	velocity.x = 0
	#	move_and_slide()
	#	return

	# Finding direction to the target
	var direction = distance.normalized()

	# Moving towards the target on ground
	velocity.x = direction.x * movement_speed

	# Finding deviation from PI/2
	var angle = max(0, PI / 2 - acos(-distance.y / distance.length()))
	var jump_force = jump_velocity * max(jump_minimal_velocity, min(angle, 1))

	if distance.x < jump_activation_distance:
		# If further path avaliable only via jumping, then jump
		if abs(PI / 2 - angle) < jump_deviation and is_on_floor():
			velocity.y = jump_force

	# Or if standing too long at one place, then jump too
	if global_position.distance_to(prev_position) < standing_distance and is_on_floor():
		velocity.y = jump_force

	prev_position = global_position


func target_unnoticed_behavior(delta: float, checkpoint: Vector2) -> void:
	pass


func target_reached_behavior(_delta: float, _checkpoint: Vector2) -> void:
	velocity.x = 0


func target_unreachable_behavior(_delta: float, _checkpoint: Vector2) -> void:
	velocity.x = 0


func _physics_process(delta):
	super._physics_process(delta)

	# Applying gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
