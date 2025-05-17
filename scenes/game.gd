extends Node2D

var peer = ENetMultiplayerPeer.new()

var connected_peer_ids = []
var local_player_character

func _on_start_server_pressed():
	$VBoxContainer.visible = false
	peer.create_server(9999, 10)  # Port 12345, max 10 clients
	multiplayer.multiplayer_peer = peer
	print("Server started on port 12345")
	add_player_character(1)
	peer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			rpc("add_newly_connected_player_character", new_peer_id)
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
			add_player_character(new_peer_id)
			print("created")
	)

func _on_join_server_pressed():
	$VBoxContainer.visible = false
	peer.create_client("10.0.0.5", 9999)  # Replace with server IP
	multiplayer.multiplayer_peer = peer
	print("Connected to server")

@rpc
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	
func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://scenes/player.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	if peer_id == multiplayer.get_unique_id():
		local_player_character = player_character
		
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)
