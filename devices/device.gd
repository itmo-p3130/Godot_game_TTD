class_name Device
extends Node


@export var speed: float = 0.5

@onready var state_logger: StateLogger = get_node("/root/Main/State").logger
@onready var playing: bool = false
@onready var time_passed: float = 0


func _process(delta: float) -> void:
	if not playing:
		return

	time_passed += delta
	if time_passed < 1 / speed:
		return

	time_passed = 0

	var state_log = state_logger.get_log()

	for id in state_log.keys():
		var instance = state_log[id]["instance_link"]
		var saves = state_log[id]["saves"]

		if len(saves) > 0:
			var key = saves.keys()[-1]
			var save = saves[key]
			instance.load_save_data(save)
			saves.erase(key)
		else:
			on_end()


func on_start() -> void:
	state_logger.set_enabled(false)
	playing = true


func on_end() -> void:
	playing = false
	state_logger.set_enabled(true)
