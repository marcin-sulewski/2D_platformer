extends CharacterBody2D

const MAX_SPEED := 100.0
const JUMP_VELOCITY := -230.0

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer_jump
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dust: AnimatedSprite2D = $dust

var on_ladder: bool = false
@export var can_move: bool = true

func _ready():
	var checkpoint = GlobalSave.get_checkpoint(get_tree().current_scene.scene_file_path)
	if checkpoint.has("position"):
		global_position = checkpoint["position"]

	var point_name = Transition.get_entry_point()
	if point_name != "":
		var spawn_point = get_tree().current_scene.get_node_or_null(point_name)
		if spawn_point:
			global_position = spawn_point.global_position
		Transition.set_entry_point("")

func _physics_process(delta: float) -> void:
	if not can_move:
		return

	if not is_on_floor() and not on_ladder:
		velocity += get_gravity() * delta

	if on_ladder:
		if Input.is_action_pressed("down"):
			velocity.y =  MAX_SPEED * delta * 30
		elif Input.is_action_pressed("up"):
			velocity.y = -MAX_SPEED * delta * 30
		else:
			velocity.y = 0.0

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		audio_stream_player.play()

	var direction := Input.get_axis("left", "right")
	velocity.x = direction * MAX_SPEED  # ← natychmiastowa zmiana prędkości

	dust.visible = false

	if direction > 0:
		animated_sprite_2d.flip_h = false
		dust.position.x = -11.0
		dust.flip_h = true
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		dust.position.x = 11.0
		dust.flip_h = false

	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("walk")
			dust.visible = true
			dust.play("dust")
	else:
		animated_sprite_2d.play("jump")

	move_and_slide()

func _on_ladder_area_2d_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		on_ladder = true

func _on_ladder_area_2d_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		on_ladder = false

func kill():
	can_move = false
	velocity = Vector2.ZERO
	animated_sprite_2d.play("die") 
	Transition.restart_scene()

func bounce():
	velocity.y = JUMP_VELOCITY / 1.5 
	velocity.x = MAX_SPEED * 2.0
