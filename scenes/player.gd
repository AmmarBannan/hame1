extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

var player_name 

func _ready():
	name = str(get_multiplayer_authority())
	get_node("res://scenes/game.tscn").name_submitted.connect(_on_name_received)
	
func _on_name_received(name):
	self.namePlayer = name
	$Name.text = name
	
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
		
		# Move the character
		move_and_slide()

# Allow any peer to update positions (crucial for multiplayer sync)
@rpc("any_peer", "unreliable")
func remote_set_position(new_position):
	if not is_multiplayer_authority():
		global_position = new_position
