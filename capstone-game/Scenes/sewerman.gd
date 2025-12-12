extends Node2D

@export var dialogue_text := "Will you join my village?\n the outside world is dangerous."
@export var wait_time := 2.5

@onready var area: Area2D = $Area2D
@onready var speech_bubble = $SpeechBubble

var player_in_range := false
var bubble_showing := false

func _ready() -> void:
	# Hide bubble at start (your bubble script also hides itself, but this is fine)
	speech_bubble.visible = false

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		_toggle_dialogue()

func _toggle_dialogue() -> void:
	bubble_showing = !bubble_showing

	if bubble_showing:
		# Use the SpeechBubble's API (this sets text + typewriter + auto hide)
		speech_bubble.set_text(dialogue_text, wait_time)
	else:
		speech_bubble.visible = false

func _on_body_entered(body: Node) -> void:
	if body.name == "Farmer":
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Farmer":
		player_in_range = false
		bubble_showing = false
		speech_bubble.visible = false
