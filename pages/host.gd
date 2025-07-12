class_name Host
extends Node

@onready var multiplayer_ui = $ui/multiplayer
@onready var oid_lbl = $ui/multiplayer/VBoxContainer/OID
var game:Game=Game.new()


func _on_copy_oid_pressed():
	DisplayServer.clipboard_set(Noray.oid)


func _on_host_pressed() -> void:
	game.hosting()
