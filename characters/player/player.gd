extends CharacterBody2D

@export var speed : float =  250.0
@export var jump_velocity : float = -350.0
@export var double_jump_velocity : float = -300.0
@export var double_jump_wait_time_sec : float = 1.5
@export var jump_buffer_time : float = 0.1
@export var coyote_time : float = 0.15

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO

const LANDING_SPEED_FACTOR = 5

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	direction = Input.get_vector("left", "right", "up", "down")
	if direction && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		#velocity.x = direction.x * speed / LANDING_SPEED_FACTOR
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation_parameters()
	update_facing_direction()
	
func update_animation_parameters():
	animation_tree.set("parameters/Move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
		sprite.offset = Vector2(0, 0)
	elif direction.x < 0:
		sprite.flip_h = true
		sprite.offset = Vector2(-15, 0)
