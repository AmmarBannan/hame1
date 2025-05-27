extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

@onready var player_name=$Name
var id
var face=1

func _ready():
	add_to_group("player")
	id = str(get_multiplayer_authority())
	player_name.text = PlayerData.player_name

	
func _on_name_received(id):
	self.id.text = name

func _process(delta: float) -> void:	
	var collision = move_and_collide(velocity * delta)

func _on_body_entered(body):
	if body.is_in_group("hazard"):
		print("hitted")
			
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
			face=direction
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Sync position BEFORE moving (to avoid overwriting)
		rpc("remote_set_position", global_position)
		if Input.is_action_just_pressed("fire"):
			fire(global_position,int(face))
		# Move the character
		move_and_slide()

# Allow any peer to update positions (crucial for multiplayer sync)
@rpc("any_peer", "unreliable")
func remote_set_position(new_position):
	if not is_multiplayer_authority():
		global_position = new_position
		
func fire(position: Vector2, direction: int):
	var bolt = preload("res://scenes/fire.tscn").instantiate()
	bolt.set_multiplayer_authority(int(id))
	get_parent().add_child(bolt)

	# Set both position and direction
	bolt.position = Vector2(position.x+direction*10,position.y)
	bolt.direction = direction  # This will be used in fire.gd

	# Optional: Flip projectile sprite if needed
	if direction < 0:
		bolt.scale.x = -1


func damage(power):
	print("ÿes")
	velocity.x=-power
