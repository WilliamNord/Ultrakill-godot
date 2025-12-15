extends Area2D

var velocity = Vector2.ZERO
var speed = 2000
#en array for mynter som allerede har blir boinget
var bounced_coins = []

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#ganger med delta slik at fart ikke kommer ann på fps
	self.position += velocity * delta

#testing for å se om spretting funker
func _on_body_entered(body: Node2D) -> void:
	print("body entered: ", body)
	
	if body.is_in_group("coins") and body not in bounced_coins:
		bounced_coins.append(body)
		print("coins boinged: ", bounced_coins.size())
		#henter player fra scenetree slik at vi kan bruke dens funksjoner
		var player = get_tree().get_first_node_in_group("player")
		var next_coin = player.nearest_visible_coin(body.global_position, body, bounced_coins)
		
		if next_coin:
			var direction = (next_coin.global_position - self.global_position).normalized()
			velocity = direction * speed
			rotation = direction.angle() + deg_to_rad(90)
			print("im bouncin to: ", next_coin.global_position)
		else:
			print("no more bounce")
	#hvis kulen traff noe som ikke er en mynt
	elif not body.is_in_group("coins"):
		pass
		#queue_free()
	
