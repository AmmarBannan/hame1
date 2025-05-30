class_name Player
extends CharacterBody2D

@onready
var animations = $animation

@onready
var state_machine = $stateMachine

var player_name: String 
@onready var line_edit: LineEdit = $LineEdit

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func set_namePlayer(new_name: String) -> void:
	player_name = new_name
	name = str(new_name)  # Also sets the node name if desired
	
	
	# You can add additional name-related logic here:
	if has_node("Label"):
		get_node("Label").text = new_name
