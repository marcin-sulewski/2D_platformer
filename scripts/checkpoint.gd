# Checkpoint.gd
extends Area2D

@export var checkpoint_id: String = "checkpoint_1"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalSave.set_checkpoint(get_tree().current_scene.scene_file_path, checkpoint_id, global_position)
