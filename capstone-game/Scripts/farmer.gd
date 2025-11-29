extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumping = false
var has_pickup = false  # ✅ tracks whether the player collected the pickup

@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Reset jump state when on the ground
		jumping = false

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true
		animated_sprite_2d.play("jump")

	# Movement
	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = direction * SPEED
		if not jumping and is_on_floor():
			animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not jumping and is_on_floor():
			animated_sprite_2d.play("idle")

	move_and_slide()
