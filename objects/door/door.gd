extends CharacterBody2D


@export_category("Trigger")
@export var trigger : Node2D
@export var switch_name : String

@export_category("Animations")
@export var anim_speed: float
@export var move_speed: float
@export var start_pos: Node
@export var end_pos: Node

enum _State {idle, moving}

@onready var _sprite = $AnimatedSprite2D
@onready var _state: _State = _State.idle
@onready var _direction: Vector2
@onready var _velocity: Vector2 = Vector2(0, 0)


func set_trigger(new_trigger: Node2D) -> void:
	trigger = new_trigger


func get_trigger() -> bool:
	if typeof(trigger.get(switch_name)) == TYPE_BOOL:
		return trigger.get(switch_name)
	return false


func _ready():
	position = start_pos.position


func _physics_process(delta: float):
	if get_trigger():
		_direction = end_pos.position - position
		move_to(delta, end_pos)
	else:
		_direction = start_pos.position - position
		move_to(delta, start_pos)
	move_and_collide(_velocity)
	#position += move_speed * delta


func set_anim(state: _State) -> void:
	if state == _State.idle:
		_sprite.animation = "idle"
	elif state == _State.moving:
		_sprite.animation = "moving"
	else:
		_sprite.animation = "idle"
		print(get_name() + " : unknown _State error")
	_sprite.set_speed_scale(anim_speed)
	_sprite.play(_sprite.animation)


func move_to(delta: float, pos: Node2D) -> void:
	if position != pos.position:
		_state = _State.moving
		_velocity = _direction.normalized() * delta * move_speed * 100
		if _direction.length() < 2:
			position = pos.position
			_velocity = Vector2(0, 0)
	else:
		_state = _State.idle
	set_anim(_state)
