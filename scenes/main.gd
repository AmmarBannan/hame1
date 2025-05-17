extends Control

var peer = ENetMultiplayerPeer.new()

@onready var line_edit: LineEdit = $VBoxContainer2/VBoxContainer/LineEdit
@onready var text_edit: TextEdit = $VBoxContainer2/VBoxContainer/TextEdit

func _on_start_server_pressed():
	peer.create_server(9999, 10)  # Port 12345, max 10 clients
	multiplayer.multiplayer_peer = peer
	print("Server started on port 12345")

func _on_join_server_pressed():
	peer.create_client("10.0.0.5", 9999)  # Replace with server IP
	multiplayer.multiplayer_peer = peer
	print("Connected to server")

func _on_send_message_pressed():
	var message = line_edit.text
	if message != "":
		rpc("broadcast_message", message)
		line_edit.text = ""

@rpc("any_peer")
func broadcast_message(message):
	text_edit.text += "Message: %s\n" % message
	
	
