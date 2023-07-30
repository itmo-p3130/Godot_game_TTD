class_name Enemy
extends CharacterBody2D


@export_category("Enemy dependencies")
@export var target: Node2D
@export var navigation_agent: NavigationAgent2D

@export_category("Enemy visability")
@export var visability_find_range: float
@export var visability_lose_range: float

@export_category("Enemy distancing")
@export var distancing_stop_range: float
@export var distancing_giveup_range: float
@export var distancing_can_fly: bool


var is_target_visible: bool
var is_target_reached: bool
var is_target_reachable: bool

var previous_position: Vector2


func set_target(new_target: Node2D) -> void:
	target = new_target


func target_noticed_behavior(_delta: float, _checkpoint: Vector2) -> void:
	printerr("'target_noticed_behavior' is not implemented")


func target_unnoticed_behavior(_delta: float, _checkpoint: Vector2) -> void:
	printerr("'target_unnoticed_behavior' is not implemented")


func target_reached_behavior(_delta: float, _checkpoint: Vector2) -> void:
	printerr("'target_reached_behavior' is not implemented")


func target_unreachable_behavior(_delta: float, _checkpoint: Vector2) -> void:
	printerr("'target_unreachable_behavior' is not implemented")


func _ready() -> void:
	is_target_visible = false
	is_target_reached = false
	is_target_reachable = false
	previous_position = Vector2(0, 0)
	call_deferred("_navigation_actor_setup")


func _physics_process(delta: float) -> void:
	navigation_agent.target_position = target.global_position

	var checkpoint = navigation_agent.get_next_path_position()

	if not _is_target_set():
		print("Target is unset")
		return

	_update_target_visability()
	_update_target_distancing()
	_update_target_reachability()

	if is_target_reached:
		target_reached_behavior(delta, target.global_position)
	else:
		if is_target_reachable:
			if is_target_visible:
				target_noticed_behavior(delta, checkpoint)
			else:
				target_unnoticed_behavior(delta, checkpoint)
		else:
			target_unreachable_behavior(delta, target.global_position)


func _navigation_actor_setup() -> void:
	await get_tree().physics_frame


func _is_target_set() -> bool:
	return navigation_agent.target_position != null


func _update_target_visability() -> bool:
	var target_position = navigation_agent.target_position
	var distance_to_target = global_position.distance_to(target_position)

	if distance_to_target < visability_find_range:
		is_target_visible = true

	if distance_to_target > visability_lose_range:
		is_target_visible = false

	return is_target_visible


func _update_target_distancing() -> bool:
	var target_position = navigation_agent.target_position
	var distance_to_target = global_position.distance_to(target_position)

	if distance_to_target < distancing_stop_range:
		is_target_reached = true
	else:
		is_target_reached = false

	return is_target_reached


func _update_target_reachability() -> bool:
	var target_position = navigation_agent.target_position

	is_target_reachable = true

	return is_target_reachable
