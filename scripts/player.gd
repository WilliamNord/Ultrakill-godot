extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -500.0

const COIN_INSTANCE = preload("res://scenes/coin.tscn")
const BULLET_INSTANCE = preload("res://scenes/bullet.tscn")

@onready var world: Node2D = $".."

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# legger til tyngdekraft som drar spilleren ned
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#actions for å gå frem og tilbake med A og D keys
	#i tillegg til vesnstre og høyre pil 
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("throw"):
		Throw_Coin()
	
	if Input.is_action_just_pressed("shoot"):
		Shoot_bullet()
	move_and_slide()
	
func Throw_Coin():
	var COIN = COIN_INSTANCE.instantiate()
	world.add_child(COIN)
	#spawner coin litt over spilleren
	COIN.global_position = self.global_position + Vector2(0,-100)
	
	COIN.apply_impulse(get_direction())
	print("coin toss")

#skaffer vector mellom mus og spiller for å finne kraft og rettning
func get_direction():
	var target = get_global_mouse_position()
	var player_pos = self.global_position
	var direction = target - player_pos
	var length = direction.length()
	return direction

func Shoot_bullet():
	print("y")
	var BULLET = BULLET_INSTANCE.instantiate()
	var target = get_global_mouse_position()
	var spawn_pos = self.global_position + Vector2(0,-100)
	var direction = (target - spawn_pos).normalized()
	#setter retning og fart til kulen
	BULLET.velocity = direction * BULLET.speed
	BULLET.rotation = direction.angle() + deg_to_rad(90)
	#legger til kulen i world
	world.add_child(BULLET)
	BULLET.global_position = spawn_pos

#denne funksjonen bruker raycast for å sjekke om noe er imellom to mynter
#from: mynt som er truffet
#to: nærmeste mynt som skal treffs
#exclude_node: alle mynter som allerede er truffet
func has_line_of_sight(from: Vector2, to: Vector2, exclude_nodes = []) -> bool:
	var space_state = get_world_2d().direct_space_state
	#bruker raycast for å sjekke kollisjoner i veien mellom to steder
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self] + exclude_nodes
	
	var result = space_state.intersect_ray(query)
	if result:
		print(result.collider.name)
	
	if result.is_empty():
		#raycast traff ingenting
		return true
	
	if result.collider.is_in_group("enemy"):
		#raycast traff en enemy - prioritert
		return true
	
	if result.collider.is_in_group("coins"):
		#raycast traff en mynt
		return true
	
	if result.collider.is_in_group("obstacle"):
		print("RAYCAST TRAFF EN TING")
		return false
	
	#raycast traff noe som ikke er en mynt
	return false

#exclude_coin er mynten som kulen spretter av.
#exclude_list er alle mynter som kulen allerede har troffet
#dette er for at mynten ikke skal telles som nærmest
func nearest_visible_coin(from_pos: Vector2, exclude_coin = null, exclude_list = []):
	#henter alle mynter i scene
	var coins = get_tree().get_nodes_in_group("coins")
	#henter alle enemys i levelet
	var enemies = get_tree().get_nodes_in_group("enemy")
	#variabel for nærmeste mynt eller enemy
	var nearest_target = null
	#veldig stort tall, garrantert at en mynt er nærmere
	var nearest_distance = INF
	
	#sjekker distansen til alle enemies i scene og sender tilbake den nærmeste
	for enemy in enemies:
		
		if not enemy or enemy in exclude_list:
			continue
		
		if has_line_of_sight(from_pos, enemy.global_position, exclude_list):
			return enemy
			
		#var distance = from_pos.distance_to(enemy.global_position)
		#
		#if distance < nearest_distance and has_line_of_sight(from_pos, enemy.global_position, exclude_list):
			#nearest_distance = distance
			#nearest_target = enemy

	for coin in coins:
		#hopper over mynten som sprettes av
		if coin == exclude_coin:
			continue
		#fikserbug med null spretting av mynt lengre unna enn siste sprett
		if coin in exclude_list:
			continue
		
		#finner distansen fra denne myntes til alle andre mynter i world
		var distance = from_pos.distance_to(coin.global_position)
		
		if distance < nearest_distance and has_line_of_sight(from_pos, coin.global_position, exclude_list):
			nearest_distance = distance
			nearest_target = coin
			
	#returnerer det koden fant som næreste mynt
	return nearest_target
