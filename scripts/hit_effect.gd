extends Resource
class_name hit_effect

# Partikkel innstillinger
@export_group("partickles")
@export var particle_color: Color = Color.RED
@export var particle_amount: int = 20
@export var particle_lifetime: float = 0.5
@export var particle_speed: float = 200.0
@export var particle_gravity: float = 100.0
@export var particle_scale: float = 1.0

@export_group("scale")
@export var scale_curve: CurveTexture

# Lyd og andre effekter
@export_group("sound and other")
@export var hit_sound: AudioStream
@export var slowmo_duration: float = 0.1
@export var slowmo_scale: float = 0.05

#screenShake
@export_group("screenShake")
@export var screen_shake_intensity: float = 0.0
