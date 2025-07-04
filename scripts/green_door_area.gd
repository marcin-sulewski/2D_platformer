extends Area2D

@onready var door: AnimatedSprite2D = $green_door
@export var scene_to_load: PackedScene
@export var return_mode: bool = false
@export var target_entry_name: String
@export var required_key: String = ""  # ← dodaj nazwę klucza (lub pusty jeśli nie wymagany)

var player_in_range: bool = false
var opening: bool = false
var player_ref: Node = null

func _ready() -> void:
	if door:
		door.animation_finished.connect(_on_door_animation_finished)

func _input(event: InputEvent) -> void:
	if player_in_range and not opening and event.is_action_pressed("attack"):
		# Sprawdź czy wymagany klucz jest obecny
		if required_key != "" and not Global.has_item(required_key):
			print("Drzwi zamknięte. Potrzebujesz klucza:", required_key)
			return

		opening = true

		if player_ref:
			player_ref.can_move = false  # ⛔ zablokuj ruch gracza

		if door and "default" in door.sprite_frames.get_animation_names():
			door.play("default")
		else:
			_on_door_animation_finished()

func _on_door_animation_finished() -> void:
	if return_mode:
		Transition.set_entry_point(target_entry_name)
		Transition.transition_back()
	elif scene_to_load:
		Transition.set_entry_point(target_entry_name)
		Transition.transition_to(scene_to_load)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_in_range = true
		player_ref = body

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_in_range = false
		player_ref = null
