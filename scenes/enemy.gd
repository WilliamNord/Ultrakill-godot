extends StaticBody2D

@onready var particle_spawner: particle_spawner = $Particle_Spawner

func _ready():
	add_to_group("enemy")

func spawn_effect():
	print("Coin: Forwarding to ParticleSpawner")
	if particle_spawner:
		particle_spawner.spawn_effect()
