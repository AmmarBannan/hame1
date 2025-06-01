extends Node2D # Or whatever your root node is

@export var player_scene: PackedScene=preload("res://scene/Player.tscn")
var players = {}
var multiplayer_peer = ENetMultiplayerPeer.new()
const PORT = 9999
const ADDRESS = "10.0.0.5"
var init_params={}

func _ready():
	print(init_params.auth)

func _host():
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	
	multiplayer_peer.peer_connected.connect(
		func(new_peer_id):
			print("Peer connected:", new_peer_id)
			rpc("add_newly_connected_player_character",new_peer_id)
			#rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
	)
func _join():
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	
@rpc("reliable")
func remote_spawn_player(peer_id, player_name):
	add_player_character()

func add_player_character():
	var player_character = preload("res://scene/Player.tscn").instantiate()
	player_character.set_multiplayer_authority(Global.player_Data.id)
	player_character.player_name = Global.player_Data.player_name
	player_character.name=str(Global.player_Data.id)
	add_child(player_character)
