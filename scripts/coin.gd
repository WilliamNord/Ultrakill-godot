extends RigidBody2D

var gravity = 0.5

@onready var particle_spawner: particle_spawner = $Particle_Spawner
@onready var coin_sprite: Sprite2D = $coin_sprite

func _ready():
	add_to_group("coins")
	gravity_scale = gravity
	
func _process(delta: float) -> void:
	coin_sprite.rotation += 4.0 * delta
	
# Bullet kaller denne funksjonen
func spawn_effect():
	print("Coin: Forwarding to ParticleSpawner")
	if particle_spawner:
		particle_spawner.spawn_effect()
