extends Node


@onready var oid_input = $ui/multiplayer/VBoxContainer/OIDInput

func _on_join_pressed():
	UserData.is_Host=false
	UserData.server_id=oid_input.text
	Multiplayer.join(UserData.server_id)
	if UserData.connected:
		var new_scene = load("res://game.tscn")
		var scene_instance = new_scene.instantiate()
		add_child(scene_instance)
		#get_tree().change_scene_to_file("res://game.tscn")
		get_tree().current_scene.queue_free()
	

func _on_back_pressed() -> void:
	
	get_tree().change_scene_to_file("res://pages/HomePage.tscn")
