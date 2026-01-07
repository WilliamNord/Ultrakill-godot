extends Node2D
class_name particle_spawner

# Dette er "pluggbart" - sett forskjellige resources i editor
@export var effect: hit_effect

@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready():
	if effect and particles:
		setup_particles()

func setup_particles():
	# Konfigurer partikler basert på resource
	particles.amount = effect.particle_amount
	particles.lifetime = effect.particle_lifetime
	particles.emitting = false
	
	# Hvis du har en ParticleProcessMaterial, kan du sette farge:
	if particles.process_material is ParticleProcessMaterial:
		#duplikade sikrer at vi lager en kopi av matrealet slik at
		#-vi ikke endrer på andre resourses som kommer fra samme instanse
		var material = particles.process_material.duplicate() as ParticleProcessMaterial
		material.color = effect.particle_color
		particles.process_material = material

#funksjonen som sender ut partikler. denne blir kalt av bullet når truffet
func spawn_effect():
	print("ParticleSpawner: Spawning effect!")
	
	if particles:
		particles.restart()
		particles.emitting = true
	
	# Slowmo fra resource
	if effect:
		Engine.time_scale = effect.slowmo_scale
		await get_tree().create_timer(effect.slowmo_duration, true, false, true).timeout
		Engine.time_scale = 1.0
