extends Node
class_name Game

const PLAYER =preload("res://player/player.tscn")
var peer=ENetMultiplayerPeer.new()
var players:Array[Player]=[]
@onready var multiplayer_ui=$ui/multiplayer
@onready var oid_lbl=$ui/multiplayer/VBoxContainer/OID
@onready var oid_input=$ui/multiplayer/VBoxContainer/OIDInput


func _ready() -> void:
	$MultiplayerSpawner.spawn_function=addPlayer
	await Multiplayer.noray_connected
	oid_lbl.text=Noray.oid
func _on_host_pressed() -> void:
	Multiplayer.host()
	#peer.create_server(25565)
	#multiplayer.multiplayer_peer=peer
	multiplayer.peer_connected.connect(
		func(pid):
			print("Player ID: ",pid)
			$MultiplayerSpawner.spawn(pid)
	)
	$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
	$ui/multiplayer.hide()
	
func _on_join_pressed() -> void:
	Multiplayer.join(oid_input.text)
	#peer.create_client("localhost",25565)
	#multiplayer.multiplayer_peer=peer
	$ui/multiplayer.hide()

func addPlayer(pid):
	var player=PLAYER.instantiate()
	player.name=str(pid)
	player.global_position=$level.get_child(players.size()).global_position
	players.append(player)
	add_child(player)

func get_random_spawn_Point():
	return $level.get_children().pick_random().global_position
	



func _on_copy_oid_pressed() -> void:
	DisplayServer.clipboard_get()
