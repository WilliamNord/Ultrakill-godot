extends Area2D

var velocity = Vector2.ZERO
var speed = 3000

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#ganger med delta slik at fart ikke kommer ann på frames
	self.position += velocity * delta

#testing for å se om spretting funker
func _on_body_entered(body: Node2D) -> void:
	print("body entered: ", body)
	#finner hvor den skal gå (skal være nærmeste coin)
	var player = get_tree().get_first_node_in_group("player")
	var direction = (player.global_position - self.global_position).normalized()
	velocity = direction * speed
	#setter retning of fart
	self.velocity = direction * self.speed
	self.rotation = direction.angle() + deg_to_rad(90)
