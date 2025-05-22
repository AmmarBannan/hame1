extends AnimatableBody2D

@onready var hit: RayCast2D = $hit

func _process(delta: float) -> void:
	if hit.is_colliding():
		print("hit")
		
