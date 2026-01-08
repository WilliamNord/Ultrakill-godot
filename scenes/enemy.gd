extends StaticBody2D

@onready var particle_spawner: particle_spawner = $Particle_Spawner
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	add_to_group("enemy")
	animated_sprite_2d.flip_h = true


func spawn_effect():
	print("Coin: Forwarding to ParticleSpawner")
	if particle_spawner:
		particle_spawner.spawn_effect()
