extends CharacterBody2D


@export var speed : float =  250.0
@export var jump_velocity : float = -350.0
@export var double_jump_velocity : float = -300.0
@export var double_jump_wait_time_sec : float = 1.5
@export var jump_buffer_time : float = 0.1
@export var coyote_time : float = 0.15
@export var puss_off_ledges_x_offset : float = 7
@export var landing_speed_factor : float = 5000000

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var state_logger: Variant = get_node("/root/Main/State").logger
@onready var device: Device = get_node("/root/Main/Device")


@onready var right_outer_raycast : RayCast2D = $CollisionShape2D/RightOuterRaycast
@onready var left_outer_raycast : RayCast2D = $CollisionShape2D/LeftOuterRaycast
@onready var right_inner_raycast : RayCast2D = $CollisionShape2D/RightInnerRaycast
@onready var left_inner_raycast : RayCast2D = $CollisionShape2D/LeftInnerRaycast

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO



func _ready():
	animation_tree.active = true
	state_logger.register(self)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_home"):
		device.on_start()
	elif Input.is_action_just_released("ui_home"):
		device.on_end()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	direction = Input.get_vector("left", "right", "up", "down")
	if direction && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
#		velocity.x = direction.x * speed / (landing_speed_factor * landing_speed_factor)
		velocity.x = move_toward(velocity.x, 0, speed)

	check_push_off_ledges()

	move_and_slide()
	update_animation_parameters()
	update_facing_direction()
	state_logger.write_log(self)


func update_animation_parameters():
	animation_tree.set("parameters/Move/blend_position", direction.x)


func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
		sprite.offset = Vector2(0, 0)
	elif direction.x < 0:
		sprite.flip_h = true
		sprite.offset = Vector2(-15, 0)


func get_save_data() -> Dictionary:
	return {
		"position": position,
		"velocity": velocity
	}


func load_save_data(data: Dictionary) -> void:
	position = data["position"]
	velocity = data["velocity"]
	move_and_slide()


func check_push_off_ledges():
	if right_outer_raycast.is_colliding() && !right_inner_raycast.is_colliding() && \
		!left_outer_raycast.is_colliding() && !left_inner_raycast.is_colliding():
			global_position.x -= puss_off_ledges_x_offset
	elif left_outer_raycast.is_colliding() && !left_inner_raycast.is_colliding() && \
		!right_outer_raycast.is_colliding() && !right_inner_raycast.is_colliding():
			global_position.x += puss_off_ledges_x_offset
