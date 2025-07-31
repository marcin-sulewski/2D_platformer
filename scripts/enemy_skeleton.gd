extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var speed := 20.0
@onready var area_2d: Area2D = $Area2D
@onready var headarea: Area2D = $headarea
@onready var hurt_timer: Timer = $HurtTimer

var direction := -1
var is_alive := true
var is_hurt := false

@export var health : int = 1

func _ready():
	headarea.body_entered.connect(_on_head_hit)
	area_2d.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	if not is_alive:
		return

	if is_hurt:
		velocity.x = 0  # Zatrzymaj ruch
	else:
		velocity.x = direction * speed
		animated_sprite_2d.play("default")

	move_and_slide()

	if is_on_wall() and not is_hurt:
		direction *= -1
		animated_sprite_2d.flip_h = direction < 0

func _on_head_hit(body):
	if not is_alive or is_hurt:
		return

	if body.name == "Player":
		area_2d.monitoring = false
		is_hurt = true
		health -= 1

		if health <= 0:
			die()
		else:
			animated_sprite_2d.play("hurt")
			hurt_timer.start()

		if body.has_method("bounce"):
			body.bounce()

		await get_tree().create_timer(0.2).timeout
		area_2d.monitoring = true

func _on_body_entered(body):
	if not is_alive or is_hurt:
		return

	if body.name == "Player":
		if body.has_method("kill"):
			body.kill()

func die():
	is_alive = false
	animated_sprite_2d.play("die")
	await animated_sprite_2d.animation_finished
	queue_free()

func _on_hurt_timer_timeout() -> void:
	is_hurt = false
