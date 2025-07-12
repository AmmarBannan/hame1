extends Node2D
@onready var host: Button = $ui/multiplayer/VBoxContainer/Host
@onready var join: Button = $ui/multiplayer/VBoxContainer/Join



func _on_host_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/Host.tscn")


func _on_join_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/Join.tscn")
