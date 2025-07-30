extends CanvasLayer

@export_range(0.1, 5.0, 0.1) var duration := 2.0  # czas przejścia

@onready var fade_rect := ColorRect.new()

var _tween: Tween
var _target_scene: PackedScene = null
var _previous_scene_path: String = ""
var _current_scene_path: String = ""
var _entry_point_name: String = ""

func _ready() -> void:
	fade_rect.color = Color.BLACK
	fade_rect.size = get_viewport().size
	fade_rect.modulate.a = 0.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fade_rect)
	visible = false

	get_viewport().size_changed.connect(func(): fade_rect.size = get_viewport().size)

# Przejście do nowej sceny
func transition_to(scene: PackedScene) -> void:
	if !scene:
		push_error("Transition: target scene is null.")
		return

	_target_scene = scene
	if get_tree().current_scene:
		_previous_scene_path = get_tree().current_scene.scene_file_path
	_current_scene_path = scene.resource_path

	visible = true
	if _tween: _tween.kill()

	_tween = create_tween()
	_tween.tween_property(fade_rect, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_SINE)
	_tween.tween_callback(_load_target_scene)

# Wczytanie sceny docelowej
func _load_target_scene() -> void:
	if _target_scene:
		get_tree().change_scene_to_packed(_target_scene)
		# fade-in po zmianie sceny
		fade_rect.modulate.a = 1.0
		_tween = create_tween()
		_tween.tween_property(fade_rect, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE)
		_tween.tween_callback(func(): visible = false)

# Powrót do poprzedniej sceny
func transition_back() -> void:
	if _previous_scene_path != "":
		var previous_scene = load(_previous_scene_path)
		if previous_scene is PackedScene:
			transition_to(previous_scene)
		else:
			push_error("Transition: failed to load previous scene: " + _previous_scene_path)
	else:
		push_warning("Transition: no previous scene recorded.")
		
func set_entry_point(name: String) -> void:
	_entry_point_name = name

func get_entry_point() -> String:
	return _entry_point_name
func restart_scene() -> void:
	# Zabezpieczenie
	if not get_tree().current_scene:
		push_error("Transition: brak bieżącej sceny do restartu.")
		return

	_target_scene = null
	_current_scene_path = get_tree().current_scene.scene_file_path

	visible = true
	if _tween: _tween.kill()

	_tween = create_tween()
	_tween.tween_property(fade_rect, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_SINE)
	_tween.tween_callback(_reload_current_scene)

# prywatny callback
func _reload_current_scene() -> void:
	get_tree().change_scene_to_file(_current_scene_path)

	# fade-in
	fade_rect.modulate.a = 1.0
	_tween = create_tween()
	_tween.tween_property(fade_rect, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE)
	_tween.tween_callback(func(): visible = false)
