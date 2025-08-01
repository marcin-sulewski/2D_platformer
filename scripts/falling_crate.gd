extends RigidBody2D

@export var shake_duration := 2.0
@export var respawn_delay := 4.0
@export var shake_intensity := 2.0

@onready var original_position := global_position
@onready var area_2d := $Area2D
@onready var sprite := $AnimatedSprite2D
@onready var collision := $CollisionShape2D

@onready var shake_timer := Timer.new()
@onready var respawn_timer := Timer.new()

var shaking := false
var tween: Tween

func _ready():
	# Zablokuj fizykę
	freeze = true
	gravity_scale = 0
	sleeping = true

	# Dodaj timery
	add_child(shake_timer)
	shake_timer.one_shot = true
	shake_timer.wait_time = shake_duration
	shake_timer.timeout.connect(_on_shake_timer_timeout)

	add_child(respawn_timer)
	respawn_timer.one_shot = true
	respawn_timer.wait_time = respawn_delay
	respawn_timer.timeout.connect(_on_respawn_timer_timeout)

	area_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and not shaking:
		shaking = true
		start_shaking()
		shake_timer.start()

func start_shaking():
	tween = create_tween().set_loops()
	tween.tween_property(self, "global_position:x", original_position.x + shake_intensity, 0.05)
	tween.tween_property(self, "global_position:x", original_position.x - shake_intensity, 0.05)
	tween.tween_property(self, "global_position:x", original_position.x, 0.05)

func _on_shake_timer_timeout():
	if tween:
		tween.kill()
	# Spadnij
	freeze = false
	gravity_scale = 1
	sleeping = false
	respawn_timer.start()

func _physics_process(delta):
	# Gdy zacznie spadać i minie kilka pikseli od oryginalnej pozycji – zniknij
	if not freeze and global_position.y > original_position.y + 5:
		sprite.visible = false
		collision.disabled = true

func _on_respawn_timer_timeout():
	# Resetuj
	global_position = original_position
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	rotation = 0
	shaking = false

	# Przywróć stan
	sprite.visible = true
	collision.disabled = false
	freeze = true
	gravity_scale = 0
	sleeping = true
