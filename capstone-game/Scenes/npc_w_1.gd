extends CharacterBody2D

@export var speed: float = 40.0
@export var left_offset: float = -50.0
@export var right_offset: float = 50.0

var direction: int = 1
var left_limit: float
var right_limit: float

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var speech_bubble = $SpeechBubble

var player_in_range: bool = false


func _ready() -> void:
	# Patrol limits based on starting position
	left_limit = global_position.x + left_offset
	right_limit = global_position.x + right_offset

	if speech_bubble:
		speech_bubble.visible = false


func _physics_process(delta: float) -> void:
	# Simple left/right patrol
	velocity.x = direction * speed
	move_and_slide()

	if global_position.x <= left_limit:
		direction = 1
		_face_direction(1)
	elif global_position.x >= right_limit:
		direction = -1
		_face_direction(-1)


func _face_direction(dir: int) -> void:
	if sprite:
		sprite.flip_h = dir < 0


func _process(delta: float) -> void:
	# Player presses E/Enter/Space (ui_accept) while in range
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		if speech_bubble:
			speech_bubble.set_text(
				"Get out, [color=red]of my way I'm getting my steps in[/color]",
				3.0
			)


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true


func _on_Area2D_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		if speech_bubble:
			speech_bubble.visible = false
