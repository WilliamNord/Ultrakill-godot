extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -500.0
const COIN_INSTANCE = preload("res://coin.tscn")
@onready var world: Node2D = $".."

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("click"):
		Throw_Coin()
		
		
	move_and_slide()
	
func Throw_Coin():
		var COIN = COIN_INSTANCE.instantiate()
		world.add_child(COIN)
		#spawner coin litt over spilleren
		COIN.global_position = self.global_position + Vector2(0,-100)
		COIN.sleeping = false
		COIN.apply_impulse(get_direction())
		print("coin toss")

func get_direction():
	var target = get_global_mouse_position()
	var player_pos = self.global_position
	var direction = target - player_pos
	var length = direction.length()
	print(direction)
	return direction
