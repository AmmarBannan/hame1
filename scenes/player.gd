extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

@onready var player_name=$Name
var id

func _ready():
	id = str(get_multiplayer_authority())
	print("player",PlayerData.player_name)
	player_name.text = PlayerData.player_name
	
func _on_name_received(id):
	self.id.text = name
	
func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():  # Only control your own player
		# Apply gravity
		if not is_on_floor():
			velocity.y += gravity * delta
		
		# Handle jump
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# Get input direction (-1, 0, or 1)
		var direction = Input.get_axis("left", "right")
		
		# Flip sprite based on direction
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
			
		# Apply movement
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Sync position BEFORE moving (to avoid overwriting)
		rpc("remote_set_position", global_position)
		if Input.is_action_just_pressed("fire"):
			fire()
		# Move the character
		move_and_slide()

# Allow any peer to update positions (crucial for multiplayer sync)
@rpc("any_peer", "unreliable")
func remote_set_position(new_position):
	if not is_multiplayer_authority():
		global_position = new_position
		
func fire():
	var bolt=preload("res://scenes/fire.tscn").instantiate()
	bolt.set_multiplayer_authority(int(id))
	bolt.velocity.x=400
	get_node("res://scenes/game.tscn").add_child(bolt)
	
