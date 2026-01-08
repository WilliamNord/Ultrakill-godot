extends Node2D
class_name particle_spawner

# Dette er "pluggbart" - sett forskjellige resources i editor
@export var effect: hit_effect
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

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
		
		material.gravity = Vector3(0, effect.particle_gravity, 0)
		material.initial_velocity_min = effect.particle_speed * 0.8
		material.initial_velocity_max = effect.particle_speed * 1.2
		
		if effect.scale_curve:
			material.scale_curve = effect.scale_curve
		
		#gir partiklene egenskapene til meterialet so vi nettop har endret
		particles.process_material = material
		
#funksjonen som sender ut partikler. denne blir kalt av bullet når truffet
func spawn_effect():
	print("ParticleSpawner: Spawning effect!")
	
	if particles:
		particles.restart()
		particles.emitting = true
	
	#spillet lyd med litt tilfelgihet i pitch så det ikke er repetetivt
	if effect and effect.hit_sound and audio_player:
		audio_player.stream = effect.hit_sound
		audio_player.pitch_scale = randf_range(0.9, 1.1)  # Litt variasjon!
		audio_player.play()
	
	#Screen shake direkte fra resource
	if effect and effect.screen_shake_intensity > 0:
		var camera = get_tree().get_first_node_in_group("camera")
		if camera and camera.has_method("shake_screen"):
			camera.shake_screen(effect.screen_shake_intensity)
	
	# Slowmo
	if effect:
		Engine.time_scale = effect.slowmo_scale
		await get_tree().create_timer(effect.slowmo_duration, true, false, true).timeout
		Engine.time_scale = 1.0
