extends Area2D

@onready var camera_2d: Camera2D = $"../Camera2D"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		tween.parallel().tween_property(camera_2d, "zoom", Vector2(6, 6), 1.0)
		tween.parallel().tween_property(camera_2d, "position", Vector2(520, 157), 1.0)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		tween.parallel().tween_property(camera_2d, "zoom", Vector2(4, 4), 1.0)
		tween.parallel().tween_property(camera_2d, "position", Vector2(395, 157), 1.0)
