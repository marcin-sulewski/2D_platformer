extends Area2D

@onready var timer: Timer = $Timer
@onready var camera_2d: Camera2D = $"../Player/Camera2D"


func _on_body_entered(body: CharacterBody2D) -> void:
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	camera_2d.limit_bottom = camera_2d.global_position.y + 100
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().call_deferred("reload_current_scene")
