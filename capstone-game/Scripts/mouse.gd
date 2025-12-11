extends Node2D   # or CharacterBody2D if using physics

# Movement speed
const SPEED = 80.0

# Direction: 1 = right, -1 = left
var direction = 1

# Node references
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

func _process(delta):
	# Check collisions with walls
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	elif ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	# Move the rat
	position.x += direction * SPEED * delta
