extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -220.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dust: AnimatedSprite2D = $dust
@onready var camera_2d: Camera2D = $Camera2D

var on_ladder: bool = false

var fall_velocity: float = 0.0
const LANDING_SHAKE_THRESHOLD: float = 350.0  


func _physics_process(delta: float) -> void:
	if not is_on_floor() and !on_ladder:
		velocity += get_gravity() * delta
	if on_ladder and not is_on_floor():
		if Input.is_action_pressed("down"):
			velocity.y = SPEED*delta*30
		elif Input.is_action_pressed("up"):
			velocity.y = -SPEED*delta*30
		else:
			velocity.y = 0.0
			
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("left", "right")
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
		if fall_velocity > LANDING_SHAKE_THRESHOLD:
			shake_camera()
			fall_velocity = 0.0
		if direction == 0:
			dust.visible = false
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("walk")
			dust.visible = true
			dust.play("dust")
	else:
		animated_sprite_2d.play("jump")
		fall_velocity = velocity.y
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func shake_camera():
	if camera_2d:
		camera_2d.offset = Vector2.ZERO
		var tween := get_tree().create_tween().set_loops(2)
		
		for i in range(2):
			var offset = Vector2(randf_range(-4, 4), randf_range(-4, 4))
			tween.tween_property(camera_2d, "offset", offset, 0.05).set_trans(Tween.TRANS_SINE)
			tween.tween_property(camera_2d, "offset", Vector2.ZERO, 0.05).set_trans(Tween.TRANS_SINE)

func _on_ladder_area_2d_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		on_ladder = true

func _on_ladder_area_2d_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		on_ladder = false
