extends Node2D

@onready var text_node: RichTextLabel = $Anchor/RichTextLabel
@onready var text_bg: ColorRect       = $Anchor/ColorRect

const CHAR_TIME: float = 0.03                # speed of typewriter
const PADDING   := Vector2(16, 20)           # padding around text (more vertical)
const MIN_WIDTH := 220.0                     # bubble minimum width
const MIN_HEIGHT := 70.0                     # bubble minimum height (taller so no cut-off)


func _ready() -> void:
	visible = false

	# Make text wrap nicely and use a visible color
	text_node.autowrap_mode = TextServer.AUTOWRAP_WORD
	text_node.add_theme_color_override("default_color", Color.BLACK)
	text_node.bbcode_enabled = true

	# Debug line – you can remove later if you want
	set_text("Get out of my [color=red]WAY![/color]\nI'm trying to get my steps in!", 9999.0)


func set_text(text: String, wait_time: float = 3.0) -> void:
	visible = true

	$Timer.stop()
	$Timer.wait_time = wait_time

	text_node.bbcode_text = text
	text_node.visible_ratio = 0.0

	_update_bubble_size()

	# Typewriter duration based on character count
	var char_count: int = text_node.get_total_character_count()
	var duration: float = max(0.2, float(char_count) * CHAR_TIME)

	var tween := create_tween()
	tween.tween_property(text_node, "visible_ratio", 1.0, duration)
	tween.finished.connect(_on_tween_finished)


func _update_bubble_size() -> void:
	var text_size: Vector2 = text_node.get_minimum_size()

	text_size.x = max(text_size.x, MIN_WIDTH)
	text_size.y = max(text_size.y, MIN_HEIGHT)

	text_node.size = text_size

	var bubble_size := text_size + PADDING * 2.0

	text_bg.size = bubble_size
	text_bg.position = Vector2.ZERO

	text_node.position = PADDING


func _on_tween_finished() -> void:
	$Timer.start()


func _on_Timer_timeout() -> void:
	visible = false
