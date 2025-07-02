extends Node2D

const speed=250

func _physics_process(delta: float) -> void:
	position+=transform.x*speed*delta

func _on_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority():
		return
	if body is Player:
		body.takeDamage.rpc_id(body.get_multiplayer_authority(),25)
	remove_Bullet.rpc()
	
@rpc("call_local")
func remove_Bullet():
	queue_free()
