extends CharacterBody2D

var speed = 400
var direction = 1  # Default to right
@onready var timer: Timer = $Timer
@onready var hit: RayCast2D = $hit
var power=100


func _ready() -> void:
	add_to_group("hazard")
	
func _physics_process(delta):
	velocity.x = speed * direction
	move_and_slide()

func _process(delta):
	
	if hit.is_colliding():
		direction*=-1
		if hit.get_collider().has_method("damage"):
			print(hit.get_collider())
			hit.get_collider().damage(power)
	

func _on_body_entered(body):
	if body.has_method("hit"):
		print("ÿes")
	#if body.is_in_group("player"):
		#body.hit(power*direction)
		#queue_free()
	#if body != get_parent():  # Don't collide with player who fired it
		#queue_free()
	# Add damage/hit effects here

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	queue_free()
	
