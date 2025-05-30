extends Node2D

var enterGame = false
var PLAYER = preload("res://scene/Player.tscn")

func _ready() -> void:
	# Verify signal connection
	_on_scene_changed(Global.scene_changed)

func _on_scene_changed(data):
	print("wow")  # Now this should print
	add_Player(data.id, data.namePLayer)


func add_Player(id, namePlayer):
	var player_instance = PLAYER.instantiate()
	player_instance.set_multiplayer_authority(id)
	player_instance.set_namePlayer(namePlayer)
	self.add_child(player_instance)
	print("Added player:", player_instance.name)
