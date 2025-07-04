extends Area2D
@export var item_id : String  # np. "green_key"

func _ready() -> void:
	# jeśli ten node został już zebrany – usuń
	var scene_path = get_tree().current_scene.scene_file_path
	if str(get_path()) in GlobalSave.get_state(scene_path).get("removed", []):
		queue_free()
	else:
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.add_item(item_id)            # do Twojego ekwipunku
		GlobalSave.mark_removed(             # zapisz, że zniknął
			get_tree().current_scene.scene_file_path,
			get_path()
		)
		queue_free()
