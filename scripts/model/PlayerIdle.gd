extends State
class_name PlayerIdle

@export var player:CharacterBody2D
@export var move_speed:=10.0

var move_direction:Vector2
var wanter_time:float

var direction := Vector2.ZERO

func randomize_wander():
	move_direction=Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	wanter_time=randf_range(1,3)

func Enter():
	randomize_wander()

func Update(delta:float):
	if wanter_time>0:
		wanter_time-=delta
	else:
		randomize_wander()

func physics_Update(delta:float):
	if player:
		player.velocity=move_direction*move_speed
