extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -230.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dust: AnimatedSprite2D = $dust

var on_ladder: bool = false
var can_move: bool = true

func _ready():
	var point_name = Transition.get_entry_point()
	if point_name != "":
		var spawn_point = get_tree().current_scene.get_node_or_null(point_name)
		if spawn_point:
			global_position = spawn_point.global_position
		Transition.set_entry_point("")  # wyczyść


func _physics_process(delta: float) -> void:
	if !can_move:
		return
	else:
		if not is_on_floor() and !on_ladder:
			velocity += get_gravity() * delta
		if on_ladder:
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
			if direction == 0:
				dust.visible = false
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("walk")
				dust.visible = true
				dust.play("dust")
		else:
			animated_sprite_2d.play("jump")
			
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		move_and_slide()

func _on_ladder_area_2d_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		on_ladder = true

func _on_ladder_area_2d_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		on_ladder = false
