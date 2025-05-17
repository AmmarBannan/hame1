extends CharacterBody2D

const speed = 150.0
const jump_velocity = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		if not is_on_floor():
			velocity.y +=gravity*delta
		
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y =jump_velocity
			
		if Input.is_action_just_pressed("down") and not is_on_floor():
			velocity.y =-jump_velocity
			
		var direction:Vector2 =Vector2.ZERO
		var d=Input.get_axis("left","right")
		if d:
			direction.x= d*speed
		else:
			velocity.x=move_toward(velocity.x,0,speed)
			
		global_position += direction.normalized()
		rpc("remote_set_position", global_position)
		move_and_slide()
	
@rpc("unreliable","any_peer")
func remote_set_position(authority_position):
	global_position = authority_position
	
	
