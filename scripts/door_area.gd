extends Area2D

@onready var door: AnimatedSprite2D = $AnimatedSprite2D
@export var scene_to_load: PackedScene
@export var return_mode: bool = false
@export var target_entry_name: String
@export var required_key: String = ""  # ← wymagany klucz (jeśli pusty, drzwi otwarte)

@export var label_name: String = ""  # ścieżka do Labela (np. "../Label10")
@export_multiline var full_text: String = ""  # tekst do pokazania
@export var type_speed: float = 0.06  # czas między literami

var current_char := 0
var label_ref: Label = null
var typing := false

var player_in_range: bool = false
var opening: bool = false
var player_ref: Node = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if door:
		door.animation_finished.connect(_on_door_animation_finished)

func _input(event: InputEvent) -> void:
	if player_in_range and not opening and event.is_action_pressed("attack"):
		if required_key != "" and not Global.has_item(required_key):
			_start_typing()
			print("Drzwi zamknięte. Potrzebujesz klucza:", required_key)
			return

		opening = true
		if player_ref:
			player_ref.can_move = false

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

func _start_typing():
	if typing:
		return
	label_ref = get_node_or_null(label_name)
	if label_ref == null:
		push_error("Nie znaleziono labela: " + label_name)
		return

	typing = true
	current_char = 0
	label_ref.text = ""
	label_ref.visible = true
	_continue_typing()

func _continue_typing():
	if current_char < full_text.length():
		label_ref.text += full_text[current_char]
		current_char += 1
		await get_tree().create_timer(type_speed).timeout
		_continue_typing()
	else:
		typing = false
		await get_tree().create_timer(3.0).timeout
		if label_ref:
			label_ref.text = ""
			label_ref.visible = false
