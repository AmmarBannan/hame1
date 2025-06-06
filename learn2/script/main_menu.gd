extends Control

@onready var namePlayer: LineEdit = $Panel/HBoxContainer/user/name
@onready var submit: Button = $Panel/HBoxContainer/user/submit
@onready var host: Button = $Panel/HBoxContainer/network/host
@onready var join: Button = $Panel/HBoxContainer/network/join

var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 9999
const ADDRESS = "127.0.0.1"
var name_submitted:String

var connected_peer_ids = []
var local_player_character


func _ready() -> void:
	host.disabled=true
	join.disabled=true
	submit.disabled=true

func _on_submit_pressed() -> void:
	host.disabled=false
	join.disabled=false

func _process(delta: float) -> void:
	if namePlayer.text.length()>3:
		name_submitted=namePlayer.text
		submit.disabled=false

func _on_host_pressed() -> void:
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
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	

func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://scene/Player.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	start_game(peer_id)
	

@rpc	
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)

func start_game(id):
	Global.change_scene_with_data("res://scene/gameGround.tscn", {"id":id,"namePLayer": name_submitted})
