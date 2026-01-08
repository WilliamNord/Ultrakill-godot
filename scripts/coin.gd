extends RigidBody2D

var gravity = 0.5

# Vi trenger ikke lenger @export hit_effect her!
# ParticleSpawner håndterer alt!

@onready var particle_spawner: particle_spawner = $Particle_Spawner

func _ready():
	add_to_group("coins")
	gravity_scale = gravity

signal screen_shake

# Bullet kaller denne funksjonen
func spawn_effect():
	print("Coin: Forwarding to ParticleSpawner")
	if particle_spawner:
		particle_spawner.spawn_effect()
		
		var camera = get_tree().get_first_node_in_group("camera")
		if camera and camera.has_method("shake_screen"):
			camera.shake_screen()
