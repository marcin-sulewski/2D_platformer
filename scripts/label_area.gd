extends Area2D

@export var label_name: String = ""  # ścieżka do Labela (np. "../CanvasLayer/Label")
@export_multiline var full_text: String = ""  # Tekst
@export var type_speed: float = 0.03
@export var label_id: String = ""  # Unikalny ID dla zapisu

var current_char := 0
var label_ref: Label
var typing := false

func _ready():
	body_entered.connect(_on_body_entered)

	# Sprawdź, czy był już wyświetlony
	if GlobalSave.was_label_shown(get_tree().current_scene.scene_file_path, label_id):
		label_ref = get_node_or_null(label_name)
		if label_ref:
			label_ref.text = full_text

func _on_body_entered(body):
	if typing:
		return
	if body.name != "Player":
		return

	if GlobalSave.was_label_shown(get_tree().current_scene.scene_file_path, label_id):
		return

	label_ref = get_node_or_null(label_name)
	if label_ref == null:
		push_error("Nie znaleziono labela: " + label_name)
		return

	label_ref.text = ""
	current_char = 0
	typing = true
	GlobalSave.mark_label_shown(get_tree().current_scene.scene_file_path, label_id)
	_start_typing()

func _start_typing():
	if current_char < full_text.length():
		label_ref.text += full_text[current_char]
		current_char += 1
		await get_tree().create_timer(type_speed).timeout
		_start_typing()
	else:
		typing = false
