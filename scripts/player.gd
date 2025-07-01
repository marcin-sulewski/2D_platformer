extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -250.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dust: AnimatedSprite2D = $dust
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword: AnimatedSprite2D = $sword

var on_ladder: bool = false
var attacking: bool = false

func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	# Add the gravity.
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
		
	if Input.is_action_just_pressed("attack") and !animation_player.is_playing() and !sword.is_playing() and !on_ladder:
		attacking = true
		sword.play("attack")
		animation_player.play("attack")
		animation_player.play("sword_return")
	move_and_slide()
	
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "attack" and attacking:
		animation_player.play("sword_return")
		attacking = false
		sword.visible = false


func _on_ladder_area_2d_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		on_ladder = true

func _on_ladder_area_2d_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		on_ladder = false
