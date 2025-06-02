extends Control

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



func _on_join_pressed():
	_change_scene(false)


func _change_scene(isHost):
	var new_scene = load("res://scene/gameGround.tscn").instantiate()
	new_scene.init_params = {"auth": isHost,"playerName":player_name}  # Custom property
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene
