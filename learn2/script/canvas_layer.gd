extends CanvasLayer

@onready
var child=self.get_child(0)
var uper=-200
@onready var parent = get_parent()

func _ready() -> void:
	child.position.y=uper+parent.position.y

func _process(delta: float) -> void:

	child.position.y+=(delta*80)
	child.position.x=parent.position.x-300
	if child.position.y>0:
		child.position.y=uper
