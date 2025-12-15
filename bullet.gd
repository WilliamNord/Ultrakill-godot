extends Area2D

var velocity = Vector2.ZERO
var speed = 2000

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	print("body entered: ", body)
	
