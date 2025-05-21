extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var id = body.get_multiplayer_authority()
	
	# Use call_deferred for all node operations during collision
	call_deferred("_replace_player", body, id)

func _replace_player(old_body: Node2D, player_id: int) -> void:
	
	# Free the old body safely
	if is_instance_valid(old_body):
		old_body.queue_free()
		
	# Create and add new player
	var player = preload("res://scenes/player.tscn").instantiate()
	player.set_multiplayer_authority(player_id)
	# Add child with proper parenting
	var parent = old_body.get_parent()
	if is_instance_valid(parent):

		parent.call_deferred("add_child", player)
		# Position the new player where the old one s
	
