class_name StateLogger


const MAX_LENGTH = 50

var state_log: Dictionary = {}
var enabled: bool = true


func register(node) -> void:
	if not enabled:
		return

	var id = node.get_instance_id()

	if not node.has_method("get_save_data") or not node.has_method("load_save_data"):
		printerr("Not does not implement 'savable' interface!")
		return

	state_log[id] = {
		"instance_link": node,
		"saves": {
			_get_current_timestamp(): node.get_save_data()
		}
	}


func write_log(node) -> void:
	if not enabled:
		return

	var id = node.get_instance_id()

	state_log[id]["saves"][_get_current_timestamp()] = node.get_save_data()
	if len(state_log[id]["saves"]) > MAX_LENGTH:
		var key_to_remove = state_log[id]["saves"].keys()[0]
		state_log[id]["saves"].erase(key_to_remove)


func get_log() -> Dictionary:
	return state_log


func set_enabled(state: bool) -> void:
	enabled = state


func apply(node) -> void:
	var id = node.get_instance_id()

	var saves = state_log[id]["saves"]
	state_log[id]["saves"] = {}

	var first_save = saves.values()[0]
	node.load_save_data(first_save)


func _get_current_timestamp() -> float:
	return Time.get_unix_time_from_system()
