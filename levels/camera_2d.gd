extends Camera2D

@export var random_strength: float = 8.0
@export var shake_fade: float = 5.0
@export var max_shake_offset: float = 20.0  # Begrens hvor mye den kan riste

var rng = RandomNumberGenerator.new()
var shake_strength = 0.0
var original_position: Vector2  # Husk original posisjon

func _ready() -> void:
	add_to_group("camera")
	original_position = position  # Lagre start-posisjon

func shake_screen(intensity: float = 8.0):
	shake_strength = min(intensity, max_shake_offset)
	print("Camera shaking with intensity: ", intensity)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_shake"):
		shake_screen(10.0)
	
	# Håndter shake
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		position = original_position + random_offset()
		
		# Når shake er ferdig, reset til original posisjon
		if shake_strength < 0.01:
			shake_strength = 0
			position = original_position
	else:
		#gå tilbake til orginal posisjon
		position = position.lerp(original_position, 10.0 * delta)

func random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)
