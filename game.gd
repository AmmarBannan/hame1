class_name Game
extends Node

#@onready var multiplayer_ui = $ui/multiplayer
#@onready var oid_lbl = $ui/multiplayer/VBoxContainer/OID
#@onready var oid_input = $ui/multiplayer/VBoxContainer/OIDInput
var oid_input
const PLAYER = preload("res://player/player.tscn")
@onready var label: Label = $Label

var peer = ENetMultiplayerPeer.new()
var players: Array[Player] = []

func _ready():
	$MultiplayerSpawner.spawn_function = add_player
	if UserData.is_Host:
		label.text="I am a Host"
		hosting()
	else:
	
		label.text="I am a guest"
		joining(UserData.server_id)
	await Multiplayer.noray_connected
	
func hosting():
	
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game!")
			spawnPlayer(multiplayer.get_unique_id())
			spawnPlayer(pid)
	)
	
	
	#multiplayer_ui.hide()
func spawnPlayer(id):
	
	$MultiplayerSpawner.spawn(id)
	

func joining(oid):
	print("you'r connecting to: "+oid)
	Multiplayer.join(UserData.server_id)
	#multiplayer_ui.hide()

func add_player(pid):
	$loading.hide()
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = $level.get_child(players.size()).global_position
	players.append(player)
	
	return player

func get_random_spawnpoint():
	return $level.get_children().pick_random().global_position

func _on_copy_oid_pressed():
	DisplayServer.clipboard_set(Noray.oid)
