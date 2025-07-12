extends Node



@onready var oid_input = $ui/multiplayer/VBoxContainer/OIDInput

func _on_join_pressed():
	Multiplayer.join(oid_input.text)
	get_tree().change_scene_to_file("")
