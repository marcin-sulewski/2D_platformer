extends Node

# { scene_path : { "removed": PackedStringArray, "vars": { node_path: {key: value} } } }
var scene_state := {}
var checkpoints := {}

func mark_removed(scene_path: String, node_path: String) -> void:
	if not scene_state.has(scene_path):
		scene_state[scene_path] = {"removed": PackedStringArray(), "vars": {}}
	if not scene_state[scene_path]["removed"].has(node_path):
		scene_state[scene_path]["removed"].append(str(node_path))

func save_var(scene_path: String, node_path: String, key: String, value) -> void:
	if not scene_state.has(scene_path):
		scene_state[scene_path] = {"removed": PackedStringArray(), "vars": {}}
	
	if not scene_state[scene_path]["vars"].has(node_path):
		scene_state[scene_path]["vars"][node_path] = {}
	
	scene_state[scene_path]["vars"][node_path][key] = value

func get_state(scene_path: String) -> Dictionary:
	if scene_state.has(scene_path):
		return scene_state[scene_path]
	else:
		return {}
		

func set_checkpoint(scene_path: String, id: String, position: Vector2) -> void:
	checkpoints[scene_path] = {"id": id, "position": position}

func get_checkpoint(scene_path: String) -> Dictionary:
	return checkpoints.get(scene_path, {})
