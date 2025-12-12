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
	left_limit = global_position.x + left_offset
	right_limit = global_position.x + right_offset

	if speech_bubble:
		speech_bubble.visible = false


func _physics_process(delta: float) -> void:
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
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		print("NPC: ui_accept pressed while player in range")  # DEBUG
		if speech_bubble:
			speech_bubble.set_text(
				"Get out, [color=red]of my way I'm getting my steps in[/color]",
				3.0
			)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("NPC Area2D entered by: ", body.name)  # DEBUG
	if body.is_in_group("Player"):
		print("NPC: Player in range")  # DEBUG
		player_in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("NPC Area2D exited by: ", body.name)  # DEBUG
	if body.is_in_group("Player"):
		print("NPC: Player left range")  # DEBUG
		player_in_range = false
		if speech_bubble:
			speech_bubble.visible = false
