extends Node2D

@onready var bodies_in_fan = []
@onready var towards: Node2D = $towards
@onready var fan: Node2D = $"."

@export var push_force: Vector2 = Vector2(0, -500)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("coin"):
		bodies_in_fan.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in bodies_in_fan:
		bodies_in_fan.erase(body)

func _physics_process(delta: float) -> void:
	for body in bodies_in_fan:
		if body.is_in_group("coin"):
			body.apply_central_force(push_force)
