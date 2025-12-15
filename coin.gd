extends RigidBody2D

var gravity = 0.5

func _ready():
	add_to_group("coins")
	gravity_scale = gravity
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
