extends Node3D

@export var speed: float = 0.5   # Geschwindigkeit der Neigung

@onready
var camera = $"../Camera3D"

@onready
var boat = $"../Sailboat"

func _process(delta: float) -> void:
	camera.position = camera.position.lerp(position,0.5)
	camera.look_at_from_position(camera.global_position,boat.global_position,Vector3.UP)
	
