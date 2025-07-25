extends Area2D



func _on_collision_shape_2d_child_entered_tree(Body:Player) -> void:
	var game=get_parent()
	game.get_random_spawnpoint
	Body.dead()
