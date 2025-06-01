extends Control

var multiplayer_peer = ENetMultiplayerPeer.new()

var connected_peer_ids = []
var local_player_character


@onready var player_name: LineEdit = $Panel/HBoxContainer/user/namePlayer
var gameGround = preload("res://scene/gameGround.tscn").instantiate()

func _ready() -> void:
	$Panel/HBoxContainer/user/submit.pressed.connect(_on_submitName)
	$Panel/HBoxContainer/network/host.disabled=true
	$Panel/HBoxContainer/network/join.disabled=true
	player_name.text="test"
	
func _on_submitName()->void:
	if player_name.text.length()>3:
		$Panel/HBoxContainer/network/host.disabled=false
		$Panel/HBoxContainer/network/join.disabled=false
		
func _on_host_pressed():
	_change_scene(true)
	get_tree().change_scene_to_file("res://scene/gameGround.tscn")


func _on_join_pressed():
	_change_scene(false)
	get_tree().change_scene_to_file("res://scene/gameGround.tscn")

func _change_scene(isHost):
	var new_scene = load("res://scene/gameGround.tscn").instantiate()
	new_scene.init_params = {"auth": isHost}  # Custom property
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene
