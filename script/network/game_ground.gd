extends Node2D # Or whatever your root node is

@export var player_scene: PackedScene=preload("res://scene/Player.tscn")
var players = {}
var multiplayer_peer = ENetMultiplayerPeer.new()
const PORT = 9999
const ADDRESS = "10.0.0.5"
var init_params={}
var connected_peer_ids = []
var local_player_character

func _ready():
	if !init_params.auth:
		print("error no data")	
	elif init_params.auth:
		print("host started")	
		_host(init_params.playerName)
	else:
		print("client joined")	
		_join(init_params.playerName)

func _host(playerName):
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	add_player_character(1,playerName)
	multiplayer_peer.peer_connected.connect(
		func(new_peer_id,packet: PackedByteArray):
			var clientName
			var data = packet.get_string_from_utf8()
			if data.begins_with("NAME:"):
				clientName = data.trim_prefix("NAME:")
			print("Peer connected:", new_peer_id,new_peer_id)
			rpc("add_newly_connected_player_character",new_peer_id)
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
	)
	
func _join(playerName):
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	

func add_player_character(peer_id,playerName):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://scene/Player.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	player_character.player_name=playerName
	add_child(player_character)
	

@rpc	
func add_newly_connected_player_character(new_peer_id,playername):
	add_player_character(new_peer_id,playername)
	
@rpc
func add_previously_connected_player_characters(peer_ids,playername):
	for peer_id in peer_ids:
		add_player_character(peer_id,playername)
