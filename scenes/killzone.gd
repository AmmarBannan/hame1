extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("ëntered")
	var id=body.get_multiplayer_authority()
	body.queue_free()
	var player=preload("res://scenes/player.tscn").instantiate()
	player.set_multiplayer_authority(id)
	add_child(player)
