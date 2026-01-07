extends RigidBody2D

var gravity = 0.5

# Vi trenger ikke lenger @export hit_effect her!
# ParticleSpawner håndterer alt!

@onready var particle_spawner: particle_spawner = $Particle_Spawner

func _ready():
	add_to_group("coins")
	gravity_scale = gravity

# Bullet kaller denne funksjonen
func spawn_effect():
	print("Coin: Forwarding to ParticleSpawner")
	if particle_spawner:
		particle_spawner.spawn_effect()
