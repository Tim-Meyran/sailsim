extends Node3D  # Für 3D-Objekte wie MeshInstance3D, Node3D, etc.

@export var wave_height: float = 1.0  # Höhe der Wellenbewegung
@export var wave_speed: float = 1.0   # Geschwindigkeit der Wellen
@export var tilt_amplitude: float = 5.0  # Neigungswinkel (in Grad)
@export var tilt_speed: float = 0.5   # Geschwindigkeit der Neigung

@onready
var obj = $"../Sailboat"

var original_position: Vector3
var original_rotation: Vector3
var time_passed: float = 0.0  # Zeit-Tracker

func _process(delta: float) -> void:
	time_passed += delta

	# Vertikale Wellenbewegung (sanftes Auf und Ab)
	var wave_offset = sin(time_passed * wave_speed) * wave_height

	# Neigung (leichtes Kippen um X und Z für ein realistisches Wellengefühl)
	var tilt_x = sin(time_passed * tilt_speed) * tilt_amplitude
	var tilt_z = cos(time_passed * tilt_speed) * tilt_amplitude

	# Position und Rotation anwenden
	obj.position.y = position.y + wave_offset
	obj.rotation_degrees.x = rotation.x + tilt_x
	obj.rotation_degrees.z = rotation.z + tilt_z
