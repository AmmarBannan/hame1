extends CharacterBody2D
class_name Player

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
var max_health=100
var health=max_health
@onready var game:Game=get_parent()
const bult=preload("res://bolt/bolt.tscn")

func _enter_tree() -> void:
	set_multiplayer_authority(int(str(name)))
func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	# Add the gravity.
	$gunContainer.look_at(get_local_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		shoot.rpc(multiplayer.get_unique_id())
	if get_local_mouse_position().x < global_position.x:
		$gunContainer/Sprite2D.flip_v=true
	else:
		$gunContainer/Sprite2D.flip_v=false
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
@rpc("any_peer")
func takeDamage(amount):
	health-=amount
	if health<=0:
		health=max_health
		global_position=game.get_random_spawn_Point()
@rpc("call_local")
func shoot(shooter_id):
	var bullet=bult.instantiate()
	bullet.set_multiplayer_authority(shooter_id)
	get_parent().add_child(bullet)
	bullet.transform=$gunContainer/Sprite2D/muzzle.global_transform
