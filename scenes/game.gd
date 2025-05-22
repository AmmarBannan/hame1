extends Node2D

var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 9999
const ADDRESS = "127.0.0.1"
signal name_submitted(player_name)

var connected_peer_ids = []
var local_player_character

@onready var playerName
@onready var nameLE: LineEdit = $menu/wrapper/Name/name

var enterGame=false
func _on_submitName()->void:
	if nameLE.text.length()<3:
		enterGame=false
	else:
		playerName=nameLE.text
		print(playerName)
		PlayerData.player_name = playerName.strip_edges()
		enterGame=true

	
func _process(delta: float) -> void:
	if !enterGame:
		$menu/wrapper/server/START.disabled=true
	else:
		$menu/wrapper/server/START.disabled=false
		
func _on_host_pressed():
	$menu.visible = false
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	
	add_player_character(1)
	
	multiplayer_peer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			rpc("add_newly_connected_player_character", new_peer_id)
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
			add_player_character(new_peer_id)
	)


func _on_join_pressed():
	$menu.visible = false
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer

func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://scenes/player.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	

@rpc	
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)
