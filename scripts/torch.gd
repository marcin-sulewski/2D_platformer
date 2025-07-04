extends AnimatedSprite2D

@onready var light: PointLight2D = $PointLight2D
var active := true  # flaga zapobiegająca działaniu po usunięciu z drzewa

func _ready():
	await ready
	start_flicker()

func start_flicker():
	_do_next_flicker()

func _do_next_flicker():
	if !active or !is_inside_tree():  # bezpieczeństwo
		return

	var tween := get_tree().create_tween()
	var target_energy := randf_range(0.8, 1.1)
	var duration := randf_range(0.2, 0.4)

	tween.tween_property(light, "energy", target_energy, duration).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(Callable(self, "_do_next_flicker"))

func _exit_tree():
	active = false  # wyłącza dalsze działanie gdy node znika ze sceny
