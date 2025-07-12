class_name Game
extends Node

#@onready var multiplayer_ui = $ui/multiplayer
#@onready var oid_lbl = $ui/multiplayer/VBoxContainer/OID
#@onready var oid_input = $ui/multiplayer/VBoxContainer/OIDInput
var oid_input
const PLAYER = preload("res://player/player.tscn")

var peer = ENetMultiplayerPeer.new()
var players: Array[Player] = []

func _ready():
	$MultiplayerSpawner.spawn_function = add_player
	
	await Multiplayer.noray_connected
	#oid_lbl.text = Noray.oid

func hosting():
	Multiplayer.host()
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game!")
			$MultiplayerSpawner.spawn(pid)
	)
	
	$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
	#multiplayer_ui.hide()

func joining():
	Multiplayer.join(oid_input.text)
	
	#multiplayer_ui.hide()

func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = $level.get_child(players.size()).global_position
	players.append(player)
	
	return player

func get_random_spawnpoint():
	return $Level.get_children().pick_random().global_position

func _on_copy_oid_pressed():
	DisplayServer.clipboard_set(Noray.oid)
