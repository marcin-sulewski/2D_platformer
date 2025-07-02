extends Area2D

@onready var door: AnimatedSprite2D = $AnimatedSprite2D
#@export var scene_to_load: PackedScene

var player_in_range: bool = false
var opening: bool = false

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	#if door:
		#door.animation_finished.connect(_on_door_animation_finished)

func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("attack") and !opening:
		opening = true
		door.play("default")  # nazwa animacji otwierania drzwi

#func _on_door_animation_finished():
#	if opening and scene_to_load:
#		get_tree().change_scene_to_packed(scene_to_load)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_in_range = false
