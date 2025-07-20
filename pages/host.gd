class_name Host
extends Node

@onready var multiplayer_ui = $ui/multiplayer
@onready var oid_lbl = $ui/multiplayer/VBoxContainer/OID
var game:Game=Game.new()



func _ready() -> void:
	Multiplayer.host()
	oid_lbl.text = Noray.oid
	
func _on_copy_oid_pressed():
	DisplayServer.clipboard_set(Noray.oid)

func _on_start_pressed() -> void:
	UserData.is_Host=true
	get_tree().change_scene_to_file("res://game.tscn")
	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/HomePage.tscn")
