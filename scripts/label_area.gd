extends Area2D

@export var label_name: String = ""  # Nazwa Labela do wyświetlenia tekstu
@export_multiline var full_text: String = ""  # Treść wiadomości
@export var type_speed: float = 0.03  # Prędkość pojawiania się liter

var current_char := 0
var label_ref: Label
var typing := false
var already_shown := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if already_shown or typing:
		return

	if body.name != "Player":
		return

	label_ref = get_node_or_null(label_name)
	if label_ref == null:
		push_error("Nie znaleziono labela o nazwie: " + label_name)
		return

	typing = true
	already_shown = true
	label_ref.text = ""
	current_char = 0
	_start_typing()

func _start_typing():
	if current_char < full_text.length():
		label_ref.text += full_text[current_char]
		current_char += 1
		await get_tree().create_timer(type_speed).timeout
		_start_typing()
	else:
		typing = false
