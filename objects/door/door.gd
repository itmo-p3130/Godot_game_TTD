extends AnimatableBody2D

@export_category("Trigger")
@export var trigger : Node2D
@export var switch_name : String

@export_category("Animations")
@export var anim_speed: float
@export var move_speed: float
@export var start_pos: Node
@export var end_pos  : Node

enum _State {idle, moving}

@onready var _sprite = $AnimatedSprite2D
@onready var _state: _State = _State.idle
@onready var _direction : Vector2
@onready var _consistant: bool

func set_trigger(new_trigger: Node2D) -> void:
	trigger = new_trigger

func get_trigger() -> bool:
	if typeof(trigger.get(switch_name)) == TYPE_BOOL:
		return trigger.get(switch_name)
	return false

func _ready():
	position = start_pos.position

func _process(delta):
	if get_trigger():
		_direction = end_pos.position-position
		move_to(delta, end_pos)
	else:
		_direction = start_pos.position-position
		move_to(delta, start_pos)
	#position += move_speed * delta

func setAnim(state: _State) -> void:
	if state == _State.idle:
		_sprite.animation = "idle"
	elif state == _State.moving:
		_sprite.animation = "moving"
	else:
		_sprite.animation = "idle"
		print(get_name() + " : unknown _State error")
		
func move_to(delta:float, pos:Node2D) -> void:
	if position != pos.position:
		_state = _State.moving
		position += _direction.normalized() * delta * move_speed * 10
		return
	else: _state = _State.idle
	setAnim(_state)
