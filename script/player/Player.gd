extends CharacterBody2D # Or your base class
class_name Player
@onready var animations = $animations
@onready var state_machine = $stateMachine
var player_name: String
@onready var playerName: Label = $name
func _ready():
	# Only process input for our own player
	print("player_name : ",player_name)
	state_machine.init(self)
	playerName.text="sdsadasdasda"

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
