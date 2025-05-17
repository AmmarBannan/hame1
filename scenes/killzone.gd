extends Area2D




func _on_body_entered(body: Node2D) -> void:
	print("ëntered")
	body.queue_free()
	get_tree().reload_current_scene()
