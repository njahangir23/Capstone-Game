extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumping = false
var has_pickup = false
var cabbage_counter = 0

@onready var cabbage_label = %Label
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var speech_bubble := $SpeechBubble   # <– child bubble node on Farmer


func say(text: String) -> void:
	if speech_bubble:
		# speech_bubble.gd uses set_text(text, wait_time)
		speech_bubble.set_text(text, 1.5)   # visible ~1.5s
		

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
	var direction := Input.get_axis("move_left", "move_right")

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


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("cabbage"):
		set_cabbage(cabbage_counter + 1)
	if area.is_in_group("purple_cabbage"):
		set_cabbage(cabbage_counter + 2)


func set_cabbage(new_cabbage_count: int) -> void:
	cabbage_counter = new_cabbage_count
	cabbage_label.text = "=" + str(cabbage_counter)
	if cabbage_counter >= 10:
		_go_to_next_scene()


func _go_to_next_scene() -> void:
	$TransitionLayer/AnimationPlayer.play("fade_out")
	await $TransitionLayer/AnimationPlayer.animation_finished
	await get_tree().create_timer(0.25).timeout
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Finished.tscn")


func _on_ditch_trigger_body_entered(body: Node2D) -> void:
	if body == self:
		say("Oh shit!!")


func _on_ditch_trigger_body_exited(body: Node2D) -> void:
	if body == self and speech_bubble:
		speech_bubble.visible = false
