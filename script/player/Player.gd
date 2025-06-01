extends CharacterBody2D # Or your base class
class_name Player


var player_name: String

@onready var animations = $animations
@onready var state_machine = $stateMachine


func _ready():
	# Only process input for our own player
	set_process(multiplayer.get_unique_id() == get_multiplayer_authority())
	if multiplayer.get_unique_id() == get_multiplayer_authority():
		$Label.text = player_name
	else:
		$Label.text = player_name
	state_machine.init(self)

func _process(delta):
	if multiplayer.get_unique_id() != get_multiplayer_authority():
		return
		
	# Input handling for local player only
	state_machine.process_frame(delta)
	
	# Sync position with other players
	rpc("update_position", global_position)

@rpc("unreliable") # For smoother movement
func update_position(new_position):
	if multiplayer.get_unique_id() != get_multiplayer_authority():
		global_position = new_position
		
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
