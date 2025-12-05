extends CharacterBody2D

@export var speed: float = 40.0
@export var left_offset: float = -50.0
@export var right_offset: float = 50.0

var _start_x: float
var _direction: int = 1

func _ready() -> void:
	_start_x = global_position.x

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Move horizontally
	velocity.x = _direction * speed
	move_and_slide()

	# Flip direction when reaching the patrol limits
	if global_position.x > _start_x + right_offset:
		_direction = -1
	elif global_position.x < _start_x + left_offset:
		_direction = 1
