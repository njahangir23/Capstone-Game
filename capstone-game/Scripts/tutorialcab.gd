extends Area2D

func _on_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(2.0).timeout

	queue_free()

	get_tree().call_deferred(
		"change_scene_to_file",
		"res://Scenes/Main_Scene.tscn"
	)
