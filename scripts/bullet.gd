extends Area2D

var velocity = Vector2.ZERO
var speed = 2000
#en array for mynter som allerede har blir boinget
var bounced_coins = []

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var impact_frame: Timer = $impactFrame

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
		#senker tidsfarten, men burde ikke være null.
		Engine.time_scale = 0.05
		
		#lager en timer (time_sec, Process always, process_in_physics, ignore_time_scale)
		#vi setter ignore_time_scale så vi ikke må vente lengre bassert på time_scale
		await get_tree().create_timer(0.10, true, false, true).timeout
		
		#setter tiden til vanlig etter await
		Engine.time_scale = 1.0
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
			Engine.time_scale = 1.0
			print("no more bounce")
	#hvis kulen traff noe som ikke er en mynt
	elif body.is_in_group("obstacles"):
		print("HIT:", body, "deleting")
		#problem med queue_free() skaper mye time_scale problemer?????
		Engine.time_scale = 1.0
		queue_free()
		pass

#setter tidshastigheten til normal etter en liten timer
func _on_impact_frame_timeout() -> void:
	Engine.time_scale = 1.0
