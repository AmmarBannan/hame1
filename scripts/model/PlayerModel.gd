class_name Player
extends CharacterBody2D

## Movement parameters
@export var max_speed := 300.0
@export var acceleration := 1500.0
@export var friction := 1200.0
@export var jump_velocity := -400.0
@export var double_jump_velocity := -300.0

## Combat parameters
@export var max_health := 100
@export var invincibility_duration := 0.5

## Nodes
@onready var sprite := $AnimatedSprite2D
@onready var collision_shape := $CollisionShape2D
@onready var state_machine := $StateMachine
@onready var hurtbox := $HurtBox

## Internal variables
var current_health: int
var can_double_jump := false
var is_invincible := false
var direction := Vector2.ZERO

signal health_changed(new_health)
signal player_died

func _ready():
	current_health = max_health
	hurtbox.hurt.connect(_on_hurt)

func _physics_process(delta):
	if state_machine.current_state != state_machine.States.DEAD:
		_handle_movement(delta)
		_update_animations()
		move_and_slide()

func _handle_movement(delta):
	# Get input direction
	direction = Input.get_vector("left", "right", "up", "down")
	
	# Apply horizontal movement
	if direction.x != 0:
		velocity.x = move_toward(velocity.x, direction.x * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	# Handle jumping
	if is_on_floor():
		can_double_jump = true
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	else:
		if Input.is_action_just_pressed("jump") and can_double_jump:
			velocity.y = double_jump_velocity
			can_double_jump = false
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += get_gravity() * delta

func _update_animations():
	if direction.x != 0:
		sprite.flip_h = direction.x < 0
	
	if is_on_floor():
		sprite.play("run" if abs(velocity.x) > 10 else "idle")
	else:
		sprite.play("jump" if velocity.y < 0 else "fall")

func take_damage(amount: int):
	if is_invincible:
		return
	
	current_health -= amount
	health_changed.emit(current_health)
	
	if current_health <= 0:
		_die()
	else:
		_start_invincibility()

func _start_invincibility():
	is_invincible = true
	sprite.modulate.a = 0.5
	await get_tree().create_timer(invincibility_duration).timeout
	sprite.modulate.a = 1.0
	is_invincible = false

func _die():
	state_machine.transition_to(state_machine.States.DEAD)
	player_died.emit()
	set_physics_process(false)
	collision_shape.set_deferred("disabled", true)

func _on_hurt(hitbox):
	take_damage(hitbox.damage)

func get_gravity_value() -> float:
	return ProjectSettings.get_setting("physics/2d/default_gravity")
